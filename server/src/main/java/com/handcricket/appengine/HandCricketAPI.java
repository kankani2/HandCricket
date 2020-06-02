package com.handcricket.appengine;

import com.google.api.server.spi.config.AnnotationBoolean;
import com.google.api.server.spi.config.Api;
import com.google.api.server.spi.config.ApiMethod;
import com.google.api.server.spi.config.Named;
import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.handcricket.appengine.datamodel.*;

import java.io.FileNotFoundException;
import java.util.Random;

@Api(
        name = "handcricket",
        version = "v1",
        apiKeyRequired = AnnotationBoolean.TRUE
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

        String gameCode = "";
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
        Game game = DB.getGame_sync(gameID);
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).removeValue();
        HandCricketServlet.firebase.child(DB.CODES).child(game.getCode()).removeValue();
    }

    @ApiMethod(
            name = "addPlayer",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "game/player/{uid}"
    )
    public GameInfo addPlayer(GameCode gameCode, @Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        DB.userMustExist_sync(uid);
        String gameID = DB.getGameIdFrom(gameCode.getGameCode());
        HandCricketServlet.firebase.child(DB.GAMES).child(gameID).child("players").child(uid).setValue(0);
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
}
