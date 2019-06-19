package com.example.ssoanywhere.model;

import android.content.Context;
//This class is created because we dont want to give public access to SessionDataManager
// where actual KEYS related to library are present.
public class SessionDataManager_Model extends SessionDataManager{
    public SessionDataManager_Model(Context context) {
        super(context);
    }

    @Override
    public void setExpiredTime(long expiredTime) {
        super.setExpiredTime(expiredTime);
    }

    @Override
    protected long getExpiredTime() {
        return super.getExpiredTime();
    }

    public boolean isData_deleted(){
        return !checkKeyInSeesion(ACCESSTOKEN) || !checkKeyInSeesion(REFRESHTOKEN) || !checkKeyInSeesion(TOKEN_JSONRESPONSE) || !checkKeyInSeesion(TOKEN_EXPIRED_TIME);
    }
}
