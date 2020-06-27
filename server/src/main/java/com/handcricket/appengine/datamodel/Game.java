package com.handcricket.appengine.datamodel;

import java.util.HashMap;
import java.util.Random;

public class Game {
    // Changing these variable names might break functionality.
    private HashMap<String, PlayerStats> players;
    private String code;
    private String host;
    private String message;
    private String messageBar;
    private Hands hands;
    private Hands secret;
    private boolean redBatting;
    private Teams teams;
    private Stats stats;

    public Game() {}

    public Game(String uid, String gameCode) {
        host = uid;
        players = new HashMap<>();
        players.put(uid, new PlayerStats());
        code = gameCode;
        message = "Waiting for players to join...";
        hands = new Hands();
        secret = new Hands();
        redBatting = new Random().nextBoolean();
        teams = new Teams();
        stats = new Stats();
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

    public Hands getHands() {
        return hands;
    }

    public void setHands(Hands hands) {
        this.hands = hands;
    }

    public Hands getSecret() {
        return secret;
    }

    public void setSecret(Hands secret) {
        this.secret = secret;
    }

    public boolean isRedBatting() {
        return redBatting;
    }

    public void setRedBatting(boolean redBatting) {
        this.redBatting = redBatting;
    }

    public Teams getTeams() {
        return teams;
    }

    public void setTeams(Teams teams) {
        this.teams = teams;
    }

    public Stats getStats() {
        return stats;
    }

    public void setStats(Stats stats) {
        this.stats = stats;
    }

    public String getMessageBar() {
        return messageBar;
    }

    public void setMessageBar(String messageBar) {
        this.messageBar = messageBar;
    }
}
