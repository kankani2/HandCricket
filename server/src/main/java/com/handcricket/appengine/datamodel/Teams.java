package com.handcricket.appengine.datamodel;

import java.util.ArrayList;

public class Teams {
    private final ArrayList<String> red;
    private final ArrayList<String> blue;

    public Teams() {
        red = new ArrayList<>();
        blue = new ArrayList<>();
    }

    public Teams(ArrayList<String> red, ArrayList<String> blue) {
        this.red = new ArrayList<>();
        this.red.addAll(red);
        this.blue = new ArrayList<>();
        this.blue.addAll(blue);
    }

    public ArrayList<String> getRed() {
        return red;
    }

    public ArrayList<String> getBlue() {
        return blue;
    }

    public void setRed(ArrayList<String> red) {
        this.red.addAll(red);
    }

    public void setBlue(ArrayList<String> blue) {
        this.blue.addAll(blue);
    }
}
