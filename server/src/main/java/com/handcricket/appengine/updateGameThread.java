package com.handcricket.appengine;

import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.handcricket.appengine.datamodel.Hands;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import static com.handcricket.appengine.HandCricketAPI.updateGameStats;

public class updateGameThread extends Thread {

    @Override
    public void run() {
        super.run();

        while (true) {
            BlockingQueue<String> tempGameIDs = new LinkedBlockingQueue<String>();
            updateGames(tempGameIDs);
            // Update gameIDs to tempGameIDs
            HandCricketServlet.gameIDs = tempGameIDs;
            try {
                sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private void updateGames(BlockingQueue<String> tempGameIDs) {
        while (!HandCricketServlet.gameIDs.isEmpty()) {

            String gameID = HandCricketServlet.gameIDs.poll();

            try {
                Hands secretHand = DB.getSecret_sync(gameID);
                if (secretHand.getBowl() != -1) {
                    // update all the game stats
                    updateGameStats(gameID, secretHand.getBat(), secretHand.getBowl());
                } else {
                    // Add game id to temp queue for thread to update later
                    tempGameIDs.add(gameID);
                }

            } catch (InternalServerErrorException e) {
                // Add back game id to queue?
                e.printStackTrace();
            } catch (NotFoundException e) {
                // Add back game id to queue?
                e.printStackTrace();
            }

        }
    }
}
