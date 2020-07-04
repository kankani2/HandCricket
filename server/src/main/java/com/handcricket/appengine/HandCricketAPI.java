package com.handcricket.appengine;

import com.google.api.server.spi.config.Api;
import com.google.api.server.spi.config.ApiMethod;
import com.google.api.server.spi.config.Named;
import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.handcricket.appengine.datamodel.*;


import java.util.ArrayList;
import java.util.Random;

import static java.lang.Math.max;

@Api(
        name = "handcricket",
        version = "v1"
)
public class HandCricketAPI {
    @ApiMethod(
            name = "addUser",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "user"
    )
    public UID addUser(User user) {
        DatabaseReference usersRef = HandCricketServlet.firebase.child(DB.USERS);
        String uid = usersRef.push().getKey();
        usersRef.child(uid).setValue(user);

        return new UID(uid);
    }

    @ApiMethod(
            name = "removeUser",
            httpMethod = ApiMethod.HttpMethod.DELETE,
            path = "user/{uid}"
    )
    public void removeUser(@Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        DB.userMustExist_sync(uid); // throws 404 if does not exist
        HandCricketServlet.firebase.child(DB.USERS).child(uid).removeValue();
    }

    @ApiMethod(
            name = "getUser",
            httpMethod = ApiMethod.HttpMethod.GET,
            path = "user/{uid}"
    )
    public User getUser(@Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        return DB.getUser_sync(uid);
    }

    @ApiMethod(
            name = "updateUser",
            httpMethod = ApiMethod.HttpMethod.PUT,
            path = "user/{uid}"
    )
    public void updateUser(User user, @Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        DB.userMustExist_sync(uid);
        HandCricketServlet.firebase.child(DB.USERS).child(uid).setValue(user);
    }

    @ApiMethod(
            name = "createGame",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game"
    )
    public GameInfo createGame(UID uid) throws NotFoundException, InternalServerErrorException {
        // Creating a node under games
        DB.userMustExist_sync(uid.getUid());
        DatabaseReference gamesRef = HandCricketServlet.firebase.child(DB.GAMES);
        String gameID = gamesRef.push().getKey();

        // Creating a node under codes after generating an available 8 letter game code
        DatabaseReference codesRef = HandCricketServlet.firebase.child(DB.CODES);
        DataSnapshot snapshot = DB.getDataSnapshot_sync(codesRef);

        int numCodeWords = Constants.CODES.length;
        if (snapshot.getChildrenCount() >= numCodeWords * numCodeWords) {
            throw new InternalServerErrorException("Could not assign a game code because all game codes are exhausted.");
        }

        String gameCode;
        while (true) {
            Random rand = new Random();
            int firstIndex = rand.nextInt(numCodeWords);
            int secondIndex = rand.nextInt(numCodeWords);
            gameCode = Constants.CODES[firstIndex] + " " + Constants.CODES[secondIndex];
            if (!snapshot.hasChild(gameCode)) {
                // TODO: handle race conditions
                codesRef.child(gameCode).setValue(gameID);

                Game game = new Game(uid.getUid(), gameCode);
                gamesRef.child(gameID).setValue(game);
                break;
            }
        }

        return new GameInfo(gameCode, gameID);
    }

    @ApiMethod(
            name = "deleteGame",
            httpMethod = ApiMethod.HttpMethod.DELETE,
            path = "game/{gameID}"
    )
    public void deleteGame(@Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        String gameCode = DB.getGameCode_sync(gameID);
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).removeValue();
        HandCricketServlet.firebase.child(DB.CODES).child(gameCode).removeValue();
    }

    @ApiMethod(
            name = "addPlayer",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/player/{uid}"
    )
    public GameInfo addPlayer(GameCode gameCode, @Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        String gameID = DB.getGameIdFrom(gameCode.getGameCode());
        // Do not add player if there's 10 players already (Not a hard requirement due to possible race conditions)
        Game game = DB.getGame_sync(gameID);
        if (game.getPlayers().size() >= Constants.MAX_PLAYERS) {
            throw new InternalServerErrorException("No more players can be added. ");
        }
        DB.userMustExist_sync(uid);
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("players").child(uid).setValue(new PlayerStats());
        return new GameInfo(gameCode.getGameCode(), gameID);
    }

    @ApiMethod(
            name = "removePlayer",
            httpMethod = ApiMethod.HttpMethod.DELETE,
            path = "game/{gameID}/player/{uid}"
    )
    public void removePlayer(@Named("gameID") String gameID, @Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        DB.userMustExist_sync(uid);
        DB.gameMustExist_sync(gameID);
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("players").child(uid).removeValue();
    }

    @ApiMethod(
            name = "startGame",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/start"
    )
    public void startGame(Teams team, @Named("gameID") String gameID) throws InternalServerErrorException {
        // Ensure that each team has at least 1 player
        if (team.getRed().size() < 1 || team.getBlue().size() < 1) {
            throw new InternalServerErrorException("Each team should have at least 1 member. ");
        }

        DatabaseReference gameRef = HandCricketServlet.firebase.child(DB.GAMES).child(gameID);

        // Store assigned team value for each player
        gameRef.child("teams").setValue(team);

        // Update game message to null hence deleting the node
        gameRef.child("message").setValue(null);
    }

    @ApiMethod(
            name = "teamMatch",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/match"
    )
    public void teamMatch(@Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        Game game = DB.getGame_sync(gameID);
        // Check if there's >= 2 players, else throw error
        if (game.getPlayers().size() < Constants.MIN_PLAYERS) {
            throw new InternalServerErrorException("Not enough players to move to team matching stage.");
        }
        // Free the game code
        HandCricketServlet.firebase.child(DB.CODES).child(game.getCode()).removeValue();
        // Update game message
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("message").setValue("The host is selecting teams...");
    }

    @ApiMethod(
            name = "bowl",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/bowl"
    )
    public void bowl(Move move, @Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        DB.gameMustExist_sync(gameID);
        // Update hand node
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("secret").child("bowl").setValue(move.getNum());
    }

    @ApiMethod(
            name = "bat",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/bat"
    )
    public void bat(Move move, @Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        DB.gameMustExist_sync(gameID);

        // Set hands to -1,-1
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("hands").setValue(new Hands());

        // Update hand node
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("secret").child("bat").setValue(move.getNum());
    }

    @ApiMethod(
            name = "update",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/update"
    )
    public void update(@Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        Game game = DB.getGame_sync(gameID);

        Hands secret = game.getSecret();
        game.setSecret(new Hands());

        if (secret.getBat() == -1 || secret.getBowl() == -1)
            throw new InternalServerErrorException("Bowler or batter hand not set before calling update. ");

        // Set hands to correct values
        game.setHands(new Hands(secret.getBat(), secret.getBowl()));

        // update all the game stats
        updateGameStats(game, secret.getBat(), secret.getBowl());
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).setValue(game);
    }

    private String getMessageForWinner(boolean redBatting, boolean isCurrTeamWinner, int winningMargin) {
        String redWins = "Red team wins by ";
        String blueWins = "Blue team wins by ";
        String winningCategory = isCurrTeamWinner ? "wickets" : "runs;";

        if ((redBatting && isCurrTeamWinner) || (!redBatting && !isCurrTeamWinner)) {
            return redWins + winningMargin + " " + winningCategory + "!";
        } else {
            return blueWins + winningMargin + " " + winningCategory + "!";
        }
    }

    private void updateGameStats(Game game, int bat, int bowl) {
        String message = null;
        String messageBar = null;

        // Make pointers to team lists within team and make changes to it
        ArrayList<String> battingTeam;
        ArrayList<String> bowlingTeam;
        if (game.isRedBatting()) {
            battingTeam = game.getTeams().getRed();
            bowlingTeam = game.getTeams().getBlue();
        } else {
            battingTeam = game.getTeams().getBlue();
            bowlingTeam = game.getTeams().getRed();
        }

        Stats stats = game.getStats();
        if (bat == bowl) {
            // OUT
            Random rand = new Random();
            int outMsgIdx = rand.nextInt(Constants.OUT_MESSAGES.length);

            // Runs +0, wickets +1, balls +1
            stats.setWickets(stats.getWickets() + 1);
            stats.setBalls(stats.getBalls() + 1);

            // For unequal teams, the smaller team gets extra wickets
            // Therefore each team bats for max(battingTeam.size(), bowlingTeam.size()) times
            if (stats.getWickets() == max(battingTeam.size(), bowlingTeam.size())) {

                // Check if this is the end of the game
                if (stats.getTarget() == -1) {
                    // Game is not over - switch batting/bowling
                    messageBar = "LAST PLAYER OUT: " + Constants.OUT_MESSAGES[outMsgIdx];

                    // Set score as target and refresh all other stats
                    stats.setTarget(stats.getRuns() + 1);
                    stats.setRuns(0);
                    stats.setWickets(0);
                    stats.setBalls(0);

                    // Swap batting and bowling team
                    game.setRedBatting(!game.isRedBatting());
                } else {
                    // Game is over
                    messageBar = "GAME OVER!";

                    // Check who won
                    int target = stats.getTarget();
                    int runs = stats.getRuns();
                    if (target == (runs + 1)) {
                        // Tie
                        message = "IT'S A TIE! ";
                    } else {
                        // Current batting team lost
                        message = getMessageForWinner(game.isRedBatting(), false, target - runs);
                    }
                }
            } else {
                messageBar = Constants.OUT_MESSAGES[outMsgIdx];
            }

            // Move current batter to end of the list
            String currBatterUID = battingTeam.remove(0);
            battingTeam.add(currBatterUID);

            // Update current Bowler stats to Firebase
            String currBowlerUID = bowlingTeam.get(0);
            PlayerStats currBowlerStats = game.getPlayers().get(currBowlerUID);
            currBowlerStats.setWickets(currBowlerStats.getWickets() + 1);

        } else {
            // NOT OUT!

            // Runs +bat, wickets +0, balls +1
            stats.setRuns(stats.getRuns() + bat);
            stats.setBalls(stats.getBalls() + 1);

            if (bat == 6) messageBar = "THAT'S A SIXER!";
            if (bat == 4) messageBar = "THAT'S A FOUR!";

            // Update current Batter stats to Firebase
            String currBatterUID = battingTeam.get(0);
            PlayerStats currBatterStats = game.getPlayers().get(currBatterUID);
            currBatterStats.setRuns(currBatterStats.getRuns() + bat);

            // Check if target has been accomplished
            int target = stats.getTarget();
            int wickets = stats.getWickets();
            if (target != -1 && target <= stats.getRuns()) {
                // Currently batting team won
                message = getMessageForWinner(game.isRedBatting(), true, max(battingTeam.size(), bowlingTeam.size()) - wickets);
            }
        }

        //Check if BOWLER OVER is done
        if (stats.getBalls() % 6 == 0) {
            if (messageBar == null) messageBar = "OVER DONE! NEXT BOWLER'S TURN!";
            // Move current bowler to end of the list
            String currBowlerUID = bowlingTeam.remove(0);
            bowlingTeam.add(currBowlerUID);
        }

        // Update game message bar
        game.setMessageBar(messageBar);

        // Update game message if not empty
        if (message != null) {
            game.setMessage(message);
        }
    }
}
