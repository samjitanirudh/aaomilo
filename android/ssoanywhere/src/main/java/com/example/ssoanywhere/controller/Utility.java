package com.example.ssoanywhere.controller;

import android.content.Context;


//This class is created because we dont want to give static access to below methods
// which are used in both SSOAnywhere class as well as SSOAnywhere_test class.
public class Utility {
    public  String isValidInputToConstructor(Context context, String clientId, String clientSecret, AutherizedResponseInterface l_autherizedResponseInterface){
        String temp;
        if(null==context)
            temp = "context is null";
        else if(clientId == null)
            temp = "clientId is null";
        else if(clientId .equals(""))
            temp = "clientId is blank";
        else if(clientSecret == null)
            temp = "clientSecret is null";
        else if(clientSecret .equals(""))
            temp = "clientSecret is blank";
        else if(l_autherizedResponseInterface == null)
            temp = "l_autherizedResponseInterface is null";
        else
            temp = "All inputs are valid";


        return temp;
    }

    public String isValidInput_AccessToken(String username, String password){
        String temp ;
        if(username == null)
            temp = "username is null";
        else if(username .equals(""))
            temp = "username is blank";
        else if(password == null)
            temp = "password is null";
        else if(password .equals(""))
            temp = "password is blank";
        else
            temp = "All inputs are valid";
        return  temp;
    }
    public String isValidInput_RefreshToken(String refreshToken){
        String temp ;
        if(refreshToken == null)
            temp = "refreshToken is null";
        else if(refreshToken .equals(""))
            temp = "refreshToken is blank";
        else
            temp = "All inputs are valid";
        return  temp;
    }
    public String isValidJsonResponse(String jsonResponse){
        String temp ;
        if(jsonResponse == null)
            temp = "jsonResponse is null";
        else if(jsonResponse .equals(""))
            temp = "jsonResponse is blank";
        else
            temp = "All inputs are valid";
        return  temp;
    }

}
