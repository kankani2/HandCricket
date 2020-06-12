package com.handcricket.appengine.datamodel;

public class Stats {
    private int score;
    private int balls;
    private int wickets;
    private int target; // set to -1 during first innings

    public Stats() {
        this.target = -1;
    }

    public Stats(int score, int balls, int wickets, int target) {
        this.score = score;
        this.balls = balls;
        this.wickets = wickets;
        this.target = target;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
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
