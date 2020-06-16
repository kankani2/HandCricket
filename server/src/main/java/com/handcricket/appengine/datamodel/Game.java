package com.handcricket.appengine.datamodel;

import java.util.HashMap;

public class Game {
    // Changing these variable names might break functionality.
    private HashMap<String, PlayerStats> players;
    private String code;
    private String host;
    private String message;

    public Game() {}

    public Game(String uid, String gameCode) {
        this.host = uid;
        this.players = new HashMap<>();
        this.players.put(uid, new PlayerStats());
        this.code = gameCode;
        this.message = "Waiting for players to join...";
    }

    public HashMap<String, PlayerStats> getPlayers() {
        return players;
    }

    public void setPlayers(HashMap<String, PlayerStats> players) {
        this.players = players;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}
