package com.handcricket.appengine;

import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.GenericTypeIndicator;
import com.google.firebase.database.ValueEventListener;
import com.google.firebase.database.DatabaseError;
import com.handcricket.appengine.datamodel.User;

import java.util.concurrent.CountDownLatch;

public class DB {
    public static final String USERS = "users";

    static User getUser_sync(String uid) throws InternalServerErrorException, NotFoundException {
        DataSnapshot snapshot = getDataSnapshot_sync(HandCricketServlet.firebase.child(DB.USERS).child(uid));
        mustExist(snapshot);

        return snapshot.getValue(new GenericTypeIndicator<User>() {});
    }

    static void userMustExist_sync(String uid) throws InternalServerErrorException, NotFoundException {
        DataSnapshot snapshot = getDataSnapshot_sync(HandCricketServlet.firebase.child(DB.USERS).child(uid));
        mustExist(snapshot);
    }

    private static void mustExist(DataSnapshot snapshot) throws NotFoundException {
        if (!snapshot.exists()) {
            throw new NotFoundException(String.format("Resource with ID %s not found.", snapshot.getKey()));
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
            public void onCancelled(DatabaseError databaseError) {}
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
