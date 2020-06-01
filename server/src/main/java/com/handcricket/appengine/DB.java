package com.handcricket.appengine;

import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.*;
import com.handcricket.appengine.datamodel.User;

import java.util.concurrent.CountDownLatch;

public class DB {
    public static final String USERS = "users";

    static User getUser_sync(String uid) throws InternalServerErrorException, NotFoundException {
        DataSnapshot snapshot = getDataSnapshot_sync(HandCricketServlet.firebase.child(DB.USERS).child(uid));
        userMustExist(uid, snapshot);

        return snapshot.getValue(new GenericTypeIndicator<User>() {});
    }

    static void userMustExist_sync(String uid) throws InternalServerErrorException, NotFoundException {
        DataSnapshot snapshot = getDataSnapshot_sync(HandCricketServlet.firebase.child(DB.USERS).child(uid));
        userMustExist(uid, snapshot);
    }

    private static void userMustExist(String uid, DataSnapshot snapshot) throws NotFoundException {
        if (!snapshot.exists()) {
            throw new NotFoundException("User " + uid + " not found.");
        }
    }

    static DataSnapshot getDataSnapshot_sync(DatabaseReference ref) throws InternalServerErrorException {
        CountDownLatch done = new CountDownLatch(1);
        final DataSnapshot[] snapshot = new DataSnapshot[1];
        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                snapshot[0] = dataSnapshot;
                done.countDown();
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });

        try {
            done.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
            throw new InternalServerErrorException(e.toString());
        }

        return snapshot[0];
    }
}
