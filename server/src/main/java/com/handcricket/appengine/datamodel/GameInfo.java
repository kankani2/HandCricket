package com.handcricket.appengine.datamodel;

public class GameInfo {
    private String gameID;
    private String gameCode;

    public GameInfo(){}

    public GameInfo(String gameCode, String gameID){
        this.gameCode = gameCode;
        this.gameID = gameID;
    }

    public String getGameID() {
        return gameID;
    }

    public void setGameID(String gameID) {
        this.gameID = gameID;
    }

    public String getGameCode() {
        return gameCode;
    }

    public void setGameCode(String gameCode) {
        this.gameCode = gameCode;
    }
}

