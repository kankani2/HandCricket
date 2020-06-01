package com.handcricket.appengine;

import com.google.api.server.spi.config.AnnotationBoolean;
import com.google.api.server.spi.config.Api;
import com.google.api.server.spi.config.ApiMethod;
import com.google.api.server.spi.config.Named;
import com.google.api.server.spi.response.InternalServerErrorException;
import com.google.api.server.spi.response.NotFoundException;
import com.google.firebase.database.*;
import com.handcricket.appengine.datamodel.UID;
import com.handcricket.appengine.datamodel.User;

import java.util.HashMap;
import java.util.Map;

@Api(
        name = "handcricket",
        version = "v1",
        apiKeyRequired = AnnotationBoolean.TRUE
)
public class HandCricketAPI {
    @ApiMethod(
            name = "addUser",
            httpMethod = ApiMethod.HttpMethod.POST,
            path = "user"
    )
    public UID addUser(User user) {
        DatabaseReference usersRef = HandCricketServlet.firebase.child(DB.USERS);
        String uid = usersRef.push().getKey();
        usersRef.child(uid).setValue(user);

        return new UID(uid);
    }

    @ApiMethod(
            name = "removeUser",
            httpMethod = ApiMethod.HttpMethod.DELETE,
            path = "user/{uid}"
    )
    public void removeUser(@Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        DB.userMustExist_sync(uid); // throws 404 if does not exist
        HandCricketServlet.firebase.child(DB.USERS).child(uid).removeValue();
    }

    @ApiMethod(
            name = "getUser",
            httpMethod = ApiMethod.HttpMethod.GET,
            path = "user/{uid}"
    )
    public User getUser(@Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        return DB.getUser_sync(uid);
    }

    @ApiMethod(
            name = "updateUser",
            httpMethod = ApiMethod.HttpMethod.PUT,
            path = "user/{uid}"
    )
    public void updateUser(User user, @Named("uid") String uid) throws NotFoundException, InternalServerErrorException {
        DB.userMustExist_sync(uid);
        HandCricketServlet.firebase.child(DB.USERS).child(uid).setValue(user);
    }
}
