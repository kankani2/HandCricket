package com.handcricket.appengine.datamodel;

import java.util.HashMap;

public class Game {

    private HashMap<String, Integer> players; // Changing this variable name might break functionality.
    private String host;
    private String code;

    public Game() {}

    public Game(String uid, String gameCode) {
        this.host = uid;
        this.players = new HashMap<>();
        this.players.put(uid, 0);
        this.code = gameCode;
    }

    public HashMap<String, Integer> getPlayers() {
        return players;
    }

    public void setPlayers(HashMap<String, Integer> players) {
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
}
