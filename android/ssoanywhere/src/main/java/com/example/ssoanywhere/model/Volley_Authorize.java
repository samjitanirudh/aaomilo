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

public class Volley_Authorize {
    private SSOAnywhere ssoAnywhere;
    private AutherizedResponseInterface autherizedResponseInterface;
    private Context context;
    private String clientId, clientSecret, username, password;

    public Volley_Authorize(SSOAnywhere single_instance, Context context, String username, String password, AutherizedResponseInterface autherizedResponseInterface, String clientId, String clientSecret) {
        this.ssoAnywhere = single_instance;
        this.context = context;
        this.autherizedResponseInterface = autherizedResponseInterface;
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.username = username;
        this.password = password;
    }

    public void authorizeAPICall() {
        StringRequest postRequest = new StringRequest(Request.Method.POST, context.getString(R.string.authorize_refreshTokenUrl),
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String Access_Token = jsonObject.getString("access_token");
                            String Refresh_Token = jsonObject.getString("refresh_token");
                            if (Access_Token.equals("")) {
                                new Volley_Refresh(ssoAnywhere, context, Refresh_Token, autherizedResponseInterface, clientId, clientSecret).refreshTokenAPICall();
                            } else {
                                ssoAnywhere.setSSOSharedPreference(response);
                                autherizedResponseInterface.getResponse(response, false);
                            }
                        } catch (Exception ex) {
                            autherizedResponseInterface.getErrorResponse(-1);
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
                postDataParams.put("grant_type", "password");
                postDataParams.put("client_id", clientId);
                postDataParams.put("client_secret", clientSecret);
                postDataParams.put("username", username);
                postDataParams.put("password", password);

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
