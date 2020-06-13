package com.handcricket.appengine.datamodel;

import java.util.ArrayList;

public class Team {
    private final ArrayList<String> redTeam;
    private final ArrayList<String> blueTeam;

    public Team() {
        redTeam = new ArrayList<>();
        blueTeam = new ArrayList<>();
    }

    public Team(ArrayList<String> red, ArrayList<String> blue) {
        redTeam = new ArrayList<>();
        redTeam.addAll(red);
        blueTeam = new ArrayList<>();
        blueTeam.addAll(blue);
    }

    public ArrayList<String> getRedTeam() {
        return redTeam;
    }

    public ArrayList<String> getBlueTeam() {
        return blueTeam;
    }

    public void setRedTeam(ArrayList<String> red) {
        redTeam.addAll(red);
    }

    public void setBlueTeam(ArrayList<String> blue) {
        blueTeam.addAll(blue);
    }
}