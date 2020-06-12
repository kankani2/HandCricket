package com.handcricket.appengine;

import com.google.api.server.spi.EndpointsServlet;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * HandCricketServlet is a hacky way to intercept EndpointsServlet initialization code to be able to access
 * ServletConfig so that we could initialize firebase database.
 */
public class HandCricketServlet extends EndpointsServlet {
    static DatabaseReference firebase;
    static BlockingQueue<String> gameIDs;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        final String credential = config.getInitParameter("credential");
        final String databaseUrl = config.getInitParameter("databaseUrl");

        FirebaseOptions options = new FirebaseOptions.Builder()
                .setServiceAccount(config.getServletContext().getResourceAsStream(credential))
                .setDatabaseUrl(databaseUrl)
                .build();
        FirebaseApp.initializeApp(options);
        firebase = FirebaseDatabase.getInstance().getReference();

        gameIDs = new LinkedBlockingQueue<String>();
    }
}
