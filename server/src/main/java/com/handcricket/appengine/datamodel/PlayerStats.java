package com.handcricket.appengine.datamodel;

public class PlayerStats {
    private int runs;
    private int wickets;

    public PlayerStats() {
        runs = 0;
        wickets = 0;
    }

    public PlayerStats(int runs, int wickets) {
        this.runs = runs;
        this.wickets = wickets;
    }

    public int getRuns() {
        return runs;
    }

    public void setRuns(int runs) {
        this.runs = runs;
    }

    public int getWickets() {
        return wickets;
    }

    public void setWickets(int wickets) {
        this.wickets = wickets;
    }
}
