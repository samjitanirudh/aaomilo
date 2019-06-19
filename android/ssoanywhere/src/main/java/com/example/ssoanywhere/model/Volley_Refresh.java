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

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class Volley_Refresh {
    private SSOAnywhere ssoAnywhere;
    private AutherizedResponseInterface autherizedResponseInterface;
    private Context context;
    private String clientId, clientSecret, refreshToken;

    public Volley_Refresh(SSOAnywhere single_instance, Context context, String refresh_Token, AutherizedResponseInterface autherizedResponseInterface, String clientId, String clientSecret) {
        this.ssoAnywhere = single_instance;
        this.context = context;
        this.autherizedResponseInterface = autherizedResponseInterface;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.refreshToken = refresh_Token;
    }

    public void refreshTokenAPICall() {
        StringRequest postRequest = new StringRequest(Request.Method.POST, context.getString(R.string.authorize_refreshTokenUrl),
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String Access_Token = jsonObject.getString("access_token");
                            if (Access_Token.equals("")) {
                                new Volley_Refresh(ssoAnywhere, context, refreshToken, autherizedResponseInterface, clientId, clientSecret).refreshTokenAPICall();
                            } else {
                                ssoAnywhere.deleteSome(clientId, clientSecret);
                                ssoAnywhere.setSSOSharedPreference(response);
                                autherizedResponseInterface.getResponse(response, true);
                            }
                        } catch (Exception ex) {
                            if(ex.getMessage().equals("No value for refresh_token"))
                                autherizedResponseInterface.getErrorResponse(-1);
                            else
                                ex.printStackTrace();
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        try {
                            if(null==error.networkResponse)
                                autherizedResponseInterface.getErrorResponse(-1);
                            else
                                autherizedResponseInterface.getErrorResponse(error.networkResponse.statusCode);
                        } catch (Exception ex) {
                            autherizedResponseInterface.getErrorResponse(-1);
                        }
                    }
                }
        ) {
            @Override
            protected Map<String, String> getParams() {
                Map<String, String> postDataParams = new HashMap<>();
                postDataParams.put("grant_type", "refresh_token");
                postDataParams.put("client_id", clientId);
                postDataParams.put("client_secret", clientSecret);
                postDataParams.put("refresh_token", refreshToken);

                return postDataParams;
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
}

