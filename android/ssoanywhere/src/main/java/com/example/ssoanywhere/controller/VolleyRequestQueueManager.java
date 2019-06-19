package com.example.ssoanywhere.controller;

import android.annotation.SuppressLint;
import android.content.Context;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

public class VolleyRequestQueueManager {
    @SuppressLint("StaticFieldLeak")
    private static VolleyRequestQueueManager mInstance;
    private RequestQueue mRequestQueue;
    private  Context mCtx;

    private VolleyRequestQueueManager(Context context) {
        mCtx = context;
        mRequestQueue = getRequestQueue();
    }

    public static synchronized VolleyRequestQueueManager getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new VolleyRequestQueueManager(context);
        }
        return mInstance;
    }

    private RequestQueue getRequestQueue() {
        if (mRequestQueue == null) {
            // getApplicationContext() is key, it keeps you from leaking the
            // Activity or BroadcastReceiver if someone passes one in.
            mRequestQueue = Volley.newRequestQueue(mCtx.getApplicationContext());
        }
        return mRequestQueue;
    }

    public <T> void addToRequestQueue(Request<T> req) {
        getRequestQueue().add(req);
    }
}
