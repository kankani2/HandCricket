package com.handcricket.appengine;

import com.google.api.server.spi.config.Api;
import com.google.api.server.spi.config.ApiMethod;
import com.google.api.server.spi.config.Named;
import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.GenericTypeIndicator;
import com.handcricket.appengine.datamodel.*;


import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Random;

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
    public GameInfo createGame(UID uid) throws NotFoundException, InternalServerErrorException, FileNotFoundException {
        // Creating a node under games
        DB.userMustExist_sync(uid.getUid());
        DatabaseReference gamesRef = HandCricketServlet.firebase.child(DB.GAMES);
        String gameID = gamesRef.push().getKey();

        // Creating a node under codes after generating an available 8 letter game code
        DatabaseReference codesRef = HandCricketServlet.firebase.child(DB.CODES);
        DataSnapshot snapshot = DB.getDataSnapshot_sync(codesRef);

        int numCodeWords = FourLetterCodes.CODES.length;
        if (snapshot.getChildrenCount() >= numCodeWords * numCodeWords) {
            throw new InternalServerErrorException("Could not assign a game code because all game codes are exhausted.");
        }

        String gameCode;
        while (true) {
            Random rand = new Random();
            int firstIndex = rand.nextInt(numCodeWords);
            int secondIndex = rand.nextInt(numCodeWords);
            gameCode = FourLetterCodes.CODES[firstIndex] + " " + FourLetterCodes.CODES[secondIndex];
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
    public void deleteGame(@Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException, FileNotFoundException {
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
        DB.userMustExist_sync(uid);
        String gameID = DB.getGameIdFrom(gameCode.getGameCode());
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

    private void addPlayersToTeam(String teamName, ArrayList<String> team, String gameID) {
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child(teamName).setValue(team);
    }

    private void setTeamStatus(boolean redBatting, String gameID) {
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("redBatting").setValue(redBatting);
    }

    @ApiMethod(
            name = "startGame",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/start"
    )
    public void startGame(Teams team, @Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        // Store assigned team value for each player
        addPlayersToTeam("red", team.getRed(), gameID);
        addPlayersToTeam("blue", team.getBlue(), gameID);

        // Assign a team to batting randomly
        setTeamStatus(new Random().nextBoolean(), gameID);

        // Set hands and secrets value to -1
        HandCricketServlet.firebase.child(DB.GAMES).child("hands").setValue(new Hands());
        HandCricketServlet.firebase.child(DB.GAMES).child("secret").setValue(new Hands());

        // Initialize game stats
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("stats").setValue(new Stats());

        // Update game message to null hence deleting the node
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("message").setValue(null);
    }

    @ApiMethod(
            name = "teamMatch",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/match"
    )
    public void teamMatch(@Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        // Free the game code
        String gameCode = DB.getGameCode_sync(gameID);
        HandCricketServlet.firebase.child(DB.CODES).child(gameCode).removeValue();
        // Update game message
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("message").setValue("The host is selecting teams...");
    }

    @ApiMethod(
            name = "bowl",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/bowl/{num}"
    )
    public void bowl(@Named("gameID") String gameID, @Named("num") int num) throws NotFoundException, InternalServerErrorException {
        DB.gameMustExist_sync(gameID);
        // Update hand node
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("secret").child("bowl").setValue(num);
    }

    @ApiMethod(
            name = "bat",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/bat/{num}"
    )
    public void bat(@Named("gameID") String gameID, @Named("num") int num) throws NotFoundException, InternalServerErrorException {
        DB.gameMustExist_sync(gameID);

        // Set hands to -1,-1
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("hands").setValue(new Hands());

        // Update hand node
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("secret").child("bat").setValue(num);
    }

    @ApiMethod(
            name = "update",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/update"
    )
    public void update(@Named("gameID") String gameID) throws NotFoundException, InternalServerErrorException {
        DB.gameMustExist_sync(gameID);

        // Get game snapshot
        DataSnapshot gameSnapshot = DB.getDataSnapshot_sync(HandCricketServlet.firebase.child(DB.GAMES).child(gameID));
        DB.mustExist(gameSnapshot);

        // Get secret
        Hands secret = gameSnapshot.child("secret").getValue(new GenericTypeIndicator<Hands>() {
        });

        // Set secret to -1,-1
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("secret").setValue(new Hands());

        if (secret.getBat() == -1 || secret.getBowl() == -1)
            throw new InternalServerErrorException("Bowler or batter hand not set before calling update. ");

        // Set hands to correct values
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("hands").setValue(new Hands(secret.getBat(), secret.getBowl()));

        // update all the game stats
        updateGameStats(gameSnapshot, HandCricketServlet.firebase.child(DB.GAMES).child(gameID), secret.getBat(), secret.getBowl());
    }

    private String getMessageForWinner(boolean redTeamBatting, boolean isCurrTeamWinner) {
        String redWins = "Red team wins! ";
        String blueWins = "Blue team wins! ";

        if ((redTeamBatting && isCurrTeamWinner) || (!redTeamBatting && !isCurrTeamWinner)) {
            return redWins;
        } else {
            return blueWins;
        }
    }

    private PlayerStats getPlayerStats(DataSnapshot gameSnapshot, String UID) {
        return gameSnapshot.child("players").child(UID).getValue(new GenericTypeIndicator<PlayerStats>() {
        });
    }

    private void updateGameStats(DataSnapshot gameSnapshot, DatabaseReference gameRef, int bat, int bowl) throws NotFoundException, InternalServerErrorException {
        String message = null;

        // update game stats
        Stats stats = gameSnapshot.child("stats").getValue(new GenericTypeIndicator<Stats>() {
        });
        Teams  teams = gameSnapshot.child("teams").getValue(new GenericTypeIndicator<Teams>() {
        });
        boolean redTeamBatting = gameSnapshot.child("redTeamBatting").getValue(new GenericTypeIndicator<Boolean>() {
        });

        // Make pointers to team lists within team and make changes to it
        ArrayList<String> battingTeam;
        ArrayList<String> bowlingTeam;
        if (redTeamBatting) {
            battingTeam = teams.getRed();
            bowlingTeam = teams.getBlue();
        } else {
            battingTeam = teams.getBlue();
            bowlingTeam = teams.getRed();
        }

        if (bat == bowl) {
            // OUT

            // Runs +0, wickets +1, balls +1
            stats.setWickets(stats.getWickets() + 1);
            stats.setBalls(stats.getBalls() + 1);

            // Check if this was the last batter of the team
            if (stats.getWickets() == battingTeam.size()) {

                // Check if this is the end of the game
                if (stats.getTarget() == -1) {
                    // Game is not over - switch batting/bowling

                    // Set score as target and refresh all other stats
                    stats.setTarget(stats.getRuns() + 1);
                    stats.setRuns(0);
                    stats.setWickets(0);
                    stats.setBalls(0);

                    // Swap batting and bowling team
                    redTeamBatting = !redTeamBatting;
                } else {
                    // Game is over

                    // Check who won
                    int target = stats.getTarget();
                    int runs = stats.getRuns();
                    if (target <= runs) {
                        // Current batting team won
                        message = getMessageForWinner(redTeamBatting, true);
                    } else if (target == (runs + 1)) {
                        //Tie
                        message = "IT'S A TIE! ";
                    } else {
                        // Current batting team lost
                        message = getMessageForWinner(redTeamBatting, false);
                    }
                }
            }

            // Move current batter to end of the list
            String currBatterUID = battingTeam.remove(0);
            battingTeam.add(currBatterUID);

            // Update current Bowler stats to Firebase
            String currBowlerUID = bowlingTeam.get(0);
            PlayerStats currBowlerStats = getPlayerStats(gameSnapshot, currBowlerUID);
            currBowlerStats.setWickets(currBowlerStats.getWickets() + 1);
            gameRef.child("players").child(currBowlerUID).setValue(currBowlerStats);

        } else {
            // NOT OUT!

            // Runs +bat, wickets +0, balls +1
            stats.setRuns(stats.getRuns() + bat);
            stats.setBalls(stats.getBalls() + 1);

            // Update current Batter stats to Firebase
            String currBatterUID = battingTeam.get(0);
            PlayerStats currBatterStats = getPlayerStats(gameSnapshot, currBatterUID);
            currBatterStats.setRuns(currBatterStats.getRuns() + 1);
            gameRef.child("players").child(currBatterUID).setValue(currBatterStats);

            // Check if target has been accomplished
            int target = stats.getTarget();
            if (target != -1 && target <= stats.getRuns()) {
                // Currently batting team won
                message = getMessageForWinner(redTeamBatting, true);
            }
        }

        //Check if BOWLER OVER is done
        if (stats.getBalls() % 6 == 0) {
            // Move current bowler to end of the list
            String currBowlerUID = bowlingTeam.remove(0);
            bowlingTeam.add(currBowlerUID);
        }

        // Update game message if not empty
        if (message != null) {
            gameRef.child("message").setValue(message);
        }

        // Update overall stats, team lists, current batting team to Firebase
        gameRef.child("redTeamBatting").setValue(redTeamBatting);
        gameRef.child("teams").setValue(teams);
        gameRef.child("stats").setValue(stats);
    }
}
