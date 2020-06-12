package com.handcricket.appengine.datamodel;

public class Hands {
    private int bowl;
    private int bat;

    public Hands() {
        bowl = -1;
        bat = -1;
    }

    public Hands(int bat, int bowl) {
        this.bat = bat;
        this.bowl = bowl;
    }

    public int getBowl() {
        return bowl;
    }

    public void setBowl(int bowl) {
        this.bowl = bowl;
    }

    public int getBat() {
        return bat;
    }

    public void setBat(int bat) {
        this.bat = bat;
    }
}
