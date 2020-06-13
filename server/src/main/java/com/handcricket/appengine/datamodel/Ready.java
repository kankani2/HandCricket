package com.handcricket.appengine.datamodel;

public class Ready {
    private boolean bat;
    private boolean bowl;

    public Ready(){
        bat = false;
        bowl = false;
    }

    public Ready(boolean bat, boolean bowl){
        this.bat = bat;
        this.bowl = bowl;
    }

    public boolean isBat() {
        return bat;
    }

    public void setBat(boolean bat) {
        this.bat = bat;
    }

    public boolean isBowl() {
        return bowl;
    }

    public void setBowl(boolean bowl) {
        this.bowl = bowl;
    }
}
