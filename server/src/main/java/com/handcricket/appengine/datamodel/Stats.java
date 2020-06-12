package com.handcricket.appengine.datamodel;

public class Stats {
    private int runs;
    private int balls;
    private int wickets;
    private int target; // set to -1 during first innings

    public Stats() {
        this.target = -1;
    }

    public Stats(int runs, int balls, int wickets, int target) {
        this.runs = runs;
        this.balls = balls;
        this.wickets = wickets;
        this.target = target;
    }

    public int getRuns() {
        return runs;
    }

    public void setRuns(int runs) {
        this.runs = runs;
    }

    public int getBalls() {
        return balls;
    }

    public void setBalls(int balls) {
        this.balls = balls;
    }

    public int getWickets() {
        return wickets;
    }

    public void setWickets(int wickets) {
        this.wickets = wickets;
    }

    public int getTarget() {
        return target;
    }

    public void setTarget(int target) {
        this.target = target;
    }
}
