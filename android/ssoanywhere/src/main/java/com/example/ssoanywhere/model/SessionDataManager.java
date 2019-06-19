package com.example.ssoanywhere.model;

import android.content.Context;

import com.orhanobut.hawk.Hawk;

import java.util.concurrent.TimeUnit;

public class SessionDataManager {
    String TOKEN_EXPIRED_TIME = "expiredTime";
    String TOKEN_JSONRESPONSE = "accessTokenResponse";
    String ACCESSTOKEN = "accessToken";
    String REFRESHTOKEN = "refreshToken";
    private static String CLIENTID = "clientId";
    private static String CLIENTSECRET = "clientSecret";

    protected SessionDataManager(Context context) {
        if(!Hawk.isBuilt())
            Hawk.init(context).build();
    }
    ///////setters//////////
    protected void setExpiredTime(long expiredTime) {
        Hawk.put(TOKEN_EXPIRED_TIME, expiredTime);
    }

    protected void setClientId(String clientId) {
        Hawk.put(CLIENTID, clientId);
    }
    protected void setClientSecret(String clientSecret) {
        Hawk.put(CLIENTSECRET, clientSecret);
    }

    private void setTokenResponse(String jsonResponse) {
        Hawk.put(TOKEN_JSONRESPONSE, jsonResponse);
    }
    protected void setAccessToken(String accessToken) {
        Hawk.put(ACCESSTOKEN, accessToken);
    }
    protected void setRefreshToken(String refreshToken) {
        Hawk.put(REFRESHTOKEN, refreshToken);
    }

///////getters//////

    protected long getExpiredTime() {
        if(checkKeyInSeesion(TOKEN_EXPIRED_TIME))
            return  Long.valueOf(Hawk.get(TOKEN_EXPIRED_TIME).toString());
        else
            return 0;
    }
    protected String getClientId() {
        return Hawk.get(CLIENTID, "");
    }


    protected String getClientSecret() {
        return Hawk.get(CLIENTSECRET, "");
    }

    public String getTokenresponse() {
        return Hawk.get(TOKEN_JSONRESPONSE, "");
    }

    protected String getAccessToken() {
        return Hawk.get(ACCESSTOKEN, "");
    }


    protected String getRefreshToken() {
        return Hawk.get(REFRESHTOKEN, "");
    }

    ///////////other methos//////////
//below funtions  used to check
// 1.whether user is logged in or not
// 2.Access token is expired or not
    public boolean isLoggedIn() {
        long currentSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        if(checkKeyInSeesion(TOKEN_EXPIRED_TIME)) {
            return getExpiredTime() != 0 && getExpiredTime() >= currentSeconds && getExpiredTime() - currentSeconds > 40;
        }else{
            return false;
        }
    }

    boolean checkKeyInSeesion(String key){
        return Hawk.contains(key);
    }

    private void deleteKeyInSeesion(String key){
        if(Hawk.contains(key))
            Hawk.delete(key);
    }
//function deletes all data except CLIENTID & CLIENTSECRET
    public void deleteSome(String clientId,String clientSecret) {
        Hawk.put(CLIENTID,clientId);
        Hawk.put(CLIENTSECRET,clientSecret);
        deleteKeyInSeesion(ACCESSTOKEN);
        deleteKeyInSeesion(REFRESHTOKEN);
        deleteKeyInSeesion(TOKEN_EXPIRED_TIME);
        deleteKeyInSeesion(TOKEN_JSONRESPONSE);
    }
//function checks key TOKEN_JSONRESPONSE and related value is present in session else set new data
    protected void init_TokenResponseSessionData(String jsonResponse){
        if(checkKeyInSeesion(TOKEN_JSONRESPONSE)) {
            if (getTokenresponse().equals(""))
                setTokenResponse(jsonResponse);
        }
        else{
            setTokenResponse(jsonResponse);
        }
    }

}
