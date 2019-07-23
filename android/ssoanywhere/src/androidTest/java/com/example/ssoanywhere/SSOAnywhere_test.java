package com.example.ssoanywhere;

import android.content.Context;
import androidx.test.InstrumentationRegistry;
import androidx.test.runner.AndroidJUnit4;

import com.android.volley.toolbox.StringRequest;
import com.example.ssoanywhere.controller.AutherizedResponseInterface;
import com.example.ssoanywhere.controller.Utility;
import com.example.ssoanywhere.model.Access_RefreshTokenAPI;
import com.example.ssoanywhere.model.SessionDataManager_Model;
import com.example.ssoanywhere.view.SSOAnywhere;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.not;

@RunWith(AndroidJUnit4.class)
public class SSOAnywhere_test implements AutherizedResponseInterface {
    private Context context;
    private SSOAnywhere ssoAnywhere;
    private AutherizedResponseInterface _autherizedResponseInterface;
    private String expected_jsonResponse,invalid_jsonResponse,expected_clientId,expected_clientSecret,expected_username,expected_password,expected_refreshToken,expected_URL;
    private Utility ut;

    @Before
    public void setUp() {
        context = InstrumentationRegistry.getContext();
        _autherizedResponseInterface = this;
        ut = new Utility();
        readExpectedJson();
        ssoAnywhere = SSOAnywhere.getInstance(context, expected_clientId, expected_clientSecret, _autherizedResponseInterface);
    }
    //read dummy input
    private void readExpectedJson() {
        try {
            InputStream testInput = context.getAssets().open("DummyData.json");
            BufferedReader br = new BufferedReader(new InputStreamReader(testInput));
            StringBuilder sb = new StringBuilder();
            String line = br.readLine();
            while (line != null) {
                sb.append(line);
                line = br.readLine();
            }
            JSONObject json = new JSONObject(sb.toString());
            expected_jsonResponse = json.getString("valid_Json");
            invalid_jsonResponse = json.getString("invalid_Json");
            JSONObject expected_Input = json.getJSONObject("expected_Input");
            expected_clientId = expected_Input.getString("expected_clientId");
            expected_clientSecret = expected_Input.getString("expected_clientSecret");
            expected_username = expected_Input.getString("expected_username");
            expected_password = expected_Input.getString("expected_password");
            expected_refreshToken = expected_Input.getString("expected_refreshToken");
            expected_URL = expected_Input.getString("expected_URL");
            System.out.println(expected_jsonResponse + "\n************\n" + invalid_jsonResponse);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    // testing the inputs for creating single instance of library
    @Test
    public void test_inputToCreate_Obj() {
        Assert.assertEquals("All inputs are valid",ut.isValidInputToConstructor(context, expected_clientId, expected_clientSecret, _autherizedResponseInterface));
    }

    // testing the inputs to call accessToken api
    @Test
    public void test_inputToAccessToken_api() {
        Assert.assertEquals("All inputs are valid",ut.isValidInput_AccessToken(expected_username, expected_password));
    }

    // testing the inputs to call RefreshToken api
    @Test
    public void test_inputToRefreshToken_api() {
        Assert.assertEquals("All inputs are valid",ut.isValidInput_RefreshToken(expected_refreshToken));
    }

    // testing the response before saving data to library
    @Test
    public void test_JsonResponse() {
        Assert.assertEquals("All inputs are valid",ut.isValidJsonResponse(expected_jsonResponse));
    }

    // testing the function which saves data to library with dummy json response
    @Test
    public void test_saveData() {
        ssoAnywhere.setSSOSharedPreference(expected_jsonResponse);
        Assert.assertThat(_MapfromResponse(ssoAnywhere.getTokenresponse()),is(_MapfromResponse(expected_jsonResponse)));
    }
//function to create Map from String JsonResponse
    private HashMap<String,String> _MapfromResponse(String response){
        HashMap<String, String> response_Map = new HashMap<String, String>();
        try {
            JSONObject json = new JSONObject(response);
            response_Map.put("access_token",json.getString("access_token"));
            response_Map.put("refresh_token",json.getString("refresh_token"));
            response_Map.put("scope",json.getString("scope"));
            response_Map.put("token_type",json.getString("token_type"));
            response_Map.put("expires_in",json.getString("expires_in"));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return response_Map;
    }
    // testing the function which returns dummy data which is saved in library
    @Test
    public void test_getData() {
        ArrayList<String> temp = ssoAnywhere.getSessionData();
        Assert.assertThat(temp.size(), is(not(0)));
    }

    //testing  function where user is loggen in or not ,that is session is expired or not
    @Test
    public void test_isLoggedIn_withValidInput() {
        long currentSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        long expected_expireTime = 599;
        long expireSeconds = currentSeconds + expected_expireTime; // case 1: test case pass
        SessionDataManager_Model sm = new SessionDataManager_Model(context);
        sm.setExpiredTime(expireSeconds);
        Assert.assertTrue(ssoAnywhere.isLoggedIn());

    }
    //testing  function where user is loggen in or not ,that is session is expired or not
    //long expireSeconds = 0 ;  // case 2
    @Test
    public void test_isLoggedIn_with_zero_Input() {
        long expireSeconds = 0 ;
        SessionDataManager_Model sm = new SessionDataManager_Model(context);
        sm.setExpiredTime(expireSeconds);
        Assert.assertFalse("Expired time can not be zero",ssoAnywhere.isLoggedIn());
    }

    //testing  function where user is loggen in or not ,that is session is expired or not
    // case 3: as expiretime is less than currentSeconds test case fail
    @Test
    public void test_isLoggedIn_with_expire_lessThan_currentTime() {
        long currentSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        long expireSeconds = currentSeconds - 20;
        SessionDataManager_Model sm = new SessionDataManager_Model(context);
        sm.setExpiredTime(expireSeconds);
        Assert.assertFalse("Expired time can not be less than current time",ssoAnywhere.isLoggedIn());
    }
    //testing  function where user is loggen in or not ,that is session is expired or not
   // long expireSeconds = currentSeconds; // case 4: test case fail as requirement is , expireTime should be greater than current seconds
    @Test
    public void test_isLoggedIn_with_expireTime_equalTo_currentTime() {
        long expireSeconds = TimeUnit.MILLISECONDS.toSeconds(System.currentTimeMillis());
        SessionDataManager_Model sm = new SessionDataManager_Model(context);
        sm.setExpiredTime(expireSeconds);
        Assert.assertFalse("Expired time can not be equal to current time",ssoAnywhere.isLoggedIn());
    }

        //testing  function where data is deleted to clear session
    @Test
    public void test_deleteSession() {
        ssoAnywhere.setSSOSharedPreference(expected_jsonResponse);
        SessionDataManager_Model sm = new SessionDataManager_Model(context);
        sm.deleteSome(expected_clientId, expected_clientSecret);
        Assert.assertTrue(sm.isData_deleted());
    }
//testing URL from postRequest of Access token API call
    @Test
    public void test_URL(){
        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_username, expected_password, this, expected_clientId, expected_clientSecret,false);
        access_RefreshTokenAPI.call_API();
        StringRequest postRequest = access_RefreshTokenAPI.getPostRequest_AccessToken();
        Assert.assertEquals(expected_URL, postRequest.getUrl());
    }
    //testing  function to check header send to access_Token api request
    @Test
    public void test_AccessTokenReq_headers() throws Exception {
        Map<String, String> postHeaders = new HashMap<>();
        postHeaders.put("Content-Type", "application/x-www-form-urlencoded");
        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_username, expected_password, this, expected_clientId, expected_clientSecret,false);
        access_RefreshTokenAPI.call_API();
        StringRequest postRequest = access_RefreshTokenAPI.getPostRequest_AccessToken();
        Assert.assertEquals(postHeaders, postRequest.getHeaders());
    }
    //testing  function to check header send to refresh_Token api request
    @Test
    public void test_RefreshTokenReq_headers() throws Exception {
        Map<String, String> postHeaders = new HashMap<>();
        postHeaders.put("Content-Type", "application/x-www-form-urlencoded");
        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_refreshToken, this, expected_clientId, expected_clientSecret,true);
        access_RefreshTokenAPI.call_API();
        StringRequest postRequest = access_RefreshTokenAPI.getPostRequest_AccessToken();
        Assert.assertEquals(postHeaders, postRequest.getHeaders());
    }
    //testing  function to check parameters send to accessToken api request
    @Test
    public void test_AccessTokenReq_Params(){
        Map<String, String> expectedPostDataParams = new HashMap<>();
        expectedPostDataParams.put("grant_type", "password");
        expectedPostDataParams.put("client_id", expected_clientId);
        expectedPostDataParams.put("client_secret", expected_clientSecret);
        expectedPostDataParams.put("username", expected_username);
        expectedPostDataParams.put("password", expected_password);
        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_username, expected_password, this, expected_clientId, expected_clientSecret,false);
        Assert.assertEquals(expectedPostDataParams, access_RefreshTokenAPI.createPostParams());
    }

    //testing  function to check parameters send to RefreshToken api request
    @Test
    public void test_RefreshTokenReq_Params(){
        Map<String, String> expectedPostDataParams = new HashMap<>();
        expectedPostDataParams.put("grant_type", "refresh_token");
        expectedPostDataParams.put("client_id", expected_clientId);
        expectedPostDataParams.put("client_secret", expected_clientSecret);
        expectedPostDataParams.put("refresh_token", expected_refreshToken);
        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_refreshToken, this, expected_clientId, expected_clientSecret,true);
        Assert.assertEquals(expectedPostDataParams, access_RefreshTokenAPI.createPostParams());
    }

    //testing  function checkResponse() - to check access_Token api response with valid dummy response input
    // to test function with invalid dummy respone use input parameter invalid_jsonResponse instead of expected_jsonResponse
    @Test
    public void test_AccessToken_Response(){
        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_username, expected_password, this, expected_clientId, expected_clientSecret,false);
        Assert.assertEquals(access_RefreshTokenAPI.checkResponse(expected_jsonResponse),"Success",access_RefreshTokenAPI.checkResponse(expected_jsonResponse));
    }

    //testing  function checkResponse() - to check refresh_Token api response with valid dummy response input
    // to test function with invalid dummy respone use input parameter invalid_jsonResponse instead of expected_jsonResponse
//    @Test
//    public void test_RefreshToken_Response() {
//        Access_RefreshTokenAPI access_RefreshTokenAPI = new Access_RefreshTokenAPI(ssoAnywhere, context, expected_refreshToken, this, expected_clientId, expected_clientSecret, true);
//        Assert.assertEquals(access_RefreshTokenAPI.checkResponse(expected_jsonResponse), "Success", access_RefreshTokenAPI.checkResponse(invalid_jsonResponse));
//    }

    //AutherizedResponseInterface - interface methods needs to implement to create object of library
    @Override
    public void getResponse(String result, boolean fromRefreshAPI) {}
    //AutherizedResponseInterface - interface methods needs to implement to create object of library
    @Override
    public void getErrorResponse(int responseCode) {}

}
