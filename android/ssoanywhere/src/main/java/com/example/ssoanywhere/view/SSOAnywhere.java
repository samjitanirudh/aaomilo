package com.example.ssoanywhere.view;


import android.annotation.SuppressLint;
import android.content.Context;
import android.util.Log;

import com.example.ssoanywhere.controller.AutherizedResponseInterface;
import com.example.ssoanywhere.controller.Utility;
import com.example.ssoanywhere.model.Access_RefreshTokenAPI;
import com.example.ssoanywhere.model.SessionDataManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.concurrent.TimeUnit;


public class SSOAnywhere extends SessionDataManager {

    private static AutherizedResponseInterface autherizedResponseInterface;
    private static Utility ut;
    private Context context;
    @SuppressLint("StaticFieldLeak")
    private static SSOAnywhere single_instance = null;
    //private constructor to pass context to its super class
    private SSOAnywhere(Context context, String clientId, String clientSecret) {
        super(context);
        this.context = context;
        setClientId(clientId);
        setClientSecret(clientSecret);
    }
    //create static object to make class singleton
    public static SSOAnywhere getInstance(Context context, String clientId, String clientSecret, AutherizedResponseInterface l_autherizedResponseInterface)
    {
         ut = new Utility();
        if(ut.isValidInputToConstructor(context, clientId, clientSecret,l_autherizedResponseInterface).equals("All inputs are valid")) {
        if (single_instance == null) {
            single_instance = new SSOAnywhere(context, clientId, clientSecret);
            autherizedResponseInterface = l_autherizedResponseInterface;
            Log.d("SSOAnywhere", " obj created");
        } else {
            autherizedResponseInterface = l_autherizedResponseInterface;
            Log.d("SSOAnywhere", " obj already created");
        }
        return single_instance;
    }else{
        return null;
    }
    }
    //call access token API
    public void callingAutherizeAPI(String userName, String password) {
        if(ut.isValidInput_AccessToken(userName,password).equals("All inputs are valid"))
            new Access_RefreshTokenAPI(single_instance , context, userName, password, autherizedResponseInterface, getClientId(), getClientSecret(),false).call_API();
        else
            autherizedResponseInterface.getErrorResponse(-3);
    }
    //call refresh token API
    public void callingRefreshTokenAPI() {
        if(ut.isValidInput_RefreshToken(getRefreshToken()).equals("All inputs are valid"))
            new Access_RefreshTokenAPI(single_instance,context, getRefreshToken(), autherizedResponseInterface, getClientId(), getClientSecret(),true).call_API();
        else
            autherizedResponseInterface.getErrorResponse(-3);
    }
    //saving data to library
    public void setSSOSharedPreference(String jsonResponse) {
        long currentSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        try {
            init_TokenResponseSessionData(jsonResponse);
            if (ut.isValidJsonResponse(jsonResponse).equals("All inputs are valid")) {
                JSONObject jsonObject = new JSONObject(jsonResponse);
                String expireTime = jsonObject.getString("expires_in");
                long expireSeconds = currentSeconds + Long.valueOf(expireTime);
                setAccessToken(jsonObject.getString("access_token"));
                setRefreshToken((jsonObject.has("refresh_token"))?jsonObject.getString("refresh_token"):"");
                setExpiredTime(expireSeconds);
            } else {
                setAccessToken("");
                setRefreshToken("");
                setExpiredTime(0);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    //get saved data from library
    public ArrayList<String> getSessionData() {
        ArrayList<String> sessionDataList = new ArrayList<>();
        sessionDataList.add(0, String.valueOf(getExpiredTime()));
        sessionDataList.add(1, getAccessToken());
        sessionDataList.add(2, getTokenresponse());
        return sessionDataList;
    }

}
