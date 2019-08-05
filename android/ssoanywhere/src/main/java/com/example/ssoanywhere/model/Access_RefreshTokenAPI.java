package com.example.ssoanywhere.model;


import android.content.Context;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.example.ssoanywhere.R;
import com.example.ssoanywhere.controller.AutherizedResponseInterface;
import com.example.ssoanywhere.controller.VolleyRequestQueueManager;
import com.example.ssoanywhere.view.SSOAnywhere;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;
//Common class which contains API call for access token api as well as refresh token api.
public class Access_RefreshTokenAPI {
    private SSOAnywhere ssoAnywhere;
    private AutherizedResponseInterface autherizedResponseInterface;
    private Context context;
    private String clientId, clientSecret, username, password,refreshToken;
    private StringRequest postRequest = null;
    private boolean isRefreshTokenAPI_call;

    //constructor to initialize refresh token parameters
    public Access_RefreshTokenAPI(SSOAnywhere single_instance, Context context, String refresh_Token, AutherizedResponseInterface autherizedResponseInterface, String clientId, String clientSecret,boolean isRefreshTokenAPI_call) {
        this.ssoAnywhere = single_instance;
        this.context = context;
        this.autherizedResponseInterface = autherizedResponseInterface;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.refreshToken = refresh_Token;
        this.isRefreshTokenAPI_call= isRefreshTokenAPI_call;
    }
    // constructor to initialize access token parameters
    public Access_RefreshTokenAPI(SSOAnywhere single_instance, Context context, String username, String password, AutherizedResponseInterface autherizedResponseInterface, String clientId, String clientSecret, boolean isRefreshTokenAPI_call) {
        this.ssoAnywhere = single_instance;
        this.context = context;
        this.autherizedResponseInterface = autherizedResponseInterface;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.username = username;
        this.password = password;
       this.isRefreshTokenAPI_call= isRefreshTokenAPI_call;
    }

    public void call_API() {
        postRequest = new StringRequest(Request.Method.POST, get_URL(),
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        onGetResponse(response);
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        getOnErrorResponse(error);
                    }
                }
        ) {
            @Override
            protected Map<String, String> getParams() {
                return createPostParams();
            }

            @Override
            public Map<String, String> getHeaders() {
                Map<String, String> params = new HashMap<>();
                params.put("Content-Type", "application/x-www-form-urlencoded");
                return params;
            }
        };
        VolleyRequestQueueManager.getInstance(context).addToRequestQueue(postRequest);

    }

    public StringRequest getPostRequest_AccessToken() {
        return postRequest;
    }
//depending on variable isRefreshTokenAPI_call value  below function creates post params
// either for access token api or refresh token api
    public Map<String, String> createPostParams() {
        Map<String, String> postDataParams = new HashMap<>();
        postDataParams.put("client_id", clientId);
        postDataParams.put("client_secret", clientSecret);
        if(isRefreshTokenAPI_call){
            postDataParams.put("grant_type", "refresh_token");
            postDataParams.put("refresh_token", refreshToken);
        }else{
            postDataParams.put("grant_type", "password");
            postDataParams.put("username", username);
            postDataParams.put("password", password);
        }
        return postDataParams;
    }
//function executes further code depending on response from API
    private void onGetResponse(String response) {
        String responseCode = checkResponse(response);
        if (responseCode.equals("refresh_callAPI")) {
            try {
                String Refresh_Token = new JSONObject(response).getString("refresh_token");
                new Access_RefreshTokenAPI(ssoAnywhere, context, Refresh_Token, autherizedResponseInterface, clientId, clientSecret,true).call_API();
            } catch (Exception ex) {
                autherizedResponseInterface.getErrorResponse(-1);
            }
        } else if (responseCode.equals("Success")) {
            if(isRefreshTokenAPI_call)
                ssoAnywhere.deleteSome(clientId, clientSecret);
            ssoAnywhere.setSSOSharedPreference(response);
            autherizedResponseInterface.getResponse(response, isRefreshTokenAPI_call);
        } else if(responseCode.equals("Exception")) {
            autherizedResponseInterface.getErrorResponse(-1);
        }
    }
//function checks whether response is valid or has some missing parameters or its further usage leads to exception
    public String checkResponse(String response) {
        try {
            JSONObject jsonObject = new JSONObject(response);
            String Access_Token = jsonObject.getString("access_token");
            //String Refresh_Token = jsonObject.getString("refresh_token")!=null?jsonObject.getString("refresh_token"):"";
            String expiredTime = jsonObject.getString("expires_in");
            if (Access_Token.equals("")) {
                return "refresh_callAPI";
            } else {
                return "Success";
            }
        } catch (JSONException e) {
            e.printStackTrace();
            return "Exception";
        }

    }
//function checks 1. whether VolleyAPI returns null error response
// 2. or it gives some status code
// 3. or throws any exception
// depending on these conditions funtion excecute error handling callback
    private void getOnErrorResponse(VolleyError error) {
        try {
            if(null==error.networkResponse)
                autherizedResponseInterface.getErrorResponse(-1);
            else
                autherizedResponseInterface.getErrorResponse(error.networkResponse.statusCode);
        } catch (Exception ex) {
            autherizedResponseInterface.getErrorResponse(-1);
        }

    }
    //function returns url for token API call
    public String get_URL (){
        return  context.getString(R.string.authorize_refreshTokenUrl);
    }

}
