package com.handcricket.appengine;

import com.google.api.server.spi.config.Api;
import com.google.api.server.spi.config.ApiMethod;
import com.google.api.server.spi.config.Named;
import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
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

    private void setTeamStatus(Boolean bool, String gameID) {
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("redBatting").setValue(bool);
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
        int randomNum = new Random().nextInt(2);
        if (randomNum == 0) {
            setTeamStatus(true, gameID);
        } else {
            setTeamStatus(false, gameID);
        }

        // Set bat and bowl in secret to -1
        HandCricketServlet.firebase.child(DB.SECRET).child(gameID).child("bat").setValue(-1);
        HandCricketServlet.firebase.child(DB.SECRET).child(gameID).child("bowl").setValue(-1);

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
        // Update secret node
        HandCricketServlet.firebase.child(DB.SECRET).child(gameID).child("bowl").setValue(num);
    }

    @ApiMethod(
            name = "bat",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/{gameID}/bat/{num}"
    )
    public void bat(@Named("gameID") String gameID, @Named("num") int num) throws NotFoundException, InternalServerErrorException {
        DB.gameMustExist_sync(gameID);

        // Set hands value to -1
        HandCricketServlet.firebase.child(DB.GAMES).child("hands").setValue(new Hands());

        // Update secret node
        HandCricketServlet.firebase.child(DB.SECRET).child(gameID).child("bat").setValue(num);

        Hands secretHand = DB.getSecret_sync(gameID);
        if (secretHand.getBowl() != -1) {
            // update all the game stats
            updateGameStats(secretHand.getBat(), secretHand.getBowl(), gameID);
        } else {
            // Add game id to queue for thread to update stats after bowler has updated secret
            HandCricketServlet.gameIDs.add(gameID);
        }
    }

    private void updateGameStats(int bat, int bowl, String gameID) throws NotFoundException, InternalServerErrorException {

        //update game stats
        Stats stats = DB.getStats_sync(gameID);
        Teams teams = DB.getTeams_sync(gameID);
        boolean redTeamBatting = DB.isRedTeamBatting_sync(gameID);

        // Make pointers to team lists withing team and make changes to it
        ArrayList<String> battingTeam;
        ArrayList<String> bowlingTeam;
        if (redTeamBatting) {
            battingTeam = teams.getRed();
            bowlingTeam = teams.getBlue();
        } else {
            battingTeam = teams.getBlue();
            bowlingTeam = teams.getRed();
        }

        // 1. If bat == bowl, OUT
        if (bat == bowl) {

            // Runs +0, wickets +1, balls +1
            stats.setWickets(stats.getWickets() + 1);
            stats.setBalls(stats.getBalls() + 1);

            // Check if this was the last batter of the team
            if (stats.getWickets() == battingTeam.size()) {

                // Set score as target and refresh all other stats
                stats.setTarget(stats.getScore());
                stats.setScore(0);
                stats.setWickets(0);
                stats.setBalls(0);

                // Swap batting and bowling team
                redTeamBatting = !redTeamBatting;
            }

            // Move current batter to end of the list
            String currBatterUID = battingTeam.get(0);
            battingTeam.remove(0);
            battingTeam.add(currBatterUID);

            // Update current Bowler stats to Firebase
            String currBowlerUID = bowlingTeam.get(0);
            PlayerStats currBowlerStats = DB.getPlayerStats_sync(gameID, currBowlerUID);
            currBowlerStats.setWickets(currBowlerStats.getWickets() + 1);
            HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("players").child(currBowlerUID).setValue(currBowlerStats);

        } else {
            // NOT OUT!

            // Runs +bat, wickets +0, balls +1
            stats.setScore(stats.getScore() + bat);
            stats.setBalls(stats.getBalls() + 1);

            // Update current Batter stats to Firebase
            String currBatterUID = battingTeam.get(0);
            PlayerStats currBatterStats = DB.getPlayerStats_sync(gameID, currBatterUID);
            currBatterStats.setRuns(currBatterStats.getRuns() + 1);
            HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("players").child(currBatterUID).setValue(currBatterStats);

        }

        //Check if BOWLER OVER is done
        if (stats.getBalls() % 6 == 0) {
            // Move current bowler to end of the list
            String currBowlerUID = bowlingTeam.get(0);
            bowlingTeam.remove(0);
            bowlingTeam.add(currBowlerUID);
        }


        // Update overall stats, team lists, current batting team to Firebase
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("stats").setValue(stats);
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("redTeamBatting").setValue(redTeamBatting);
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("teams").setValue(teams);

        // Reset secret to -1
        HandCricketServlet.firebase.child(DB.SECRET).child(gameID).setValue(new Hands());

        // Update hands with batter and bowler under games
        Hands hands = new Hands(bat, bowl);
        HandCricketServlet.firebase.child(DB.GAMES).child("hands").setValue(hands);
    }
}
