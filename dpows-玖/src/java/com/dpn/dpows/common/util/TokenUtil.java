package com.dpn.dpows.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by zhaoqian on 15-10-20.
 */
public class TokenUtil {

    private static final String TRANSACTION_TOKEN_KEY = "mps_token_key";
    private static final String TOKEN_KEY = "mps_token";


    public static void resetToken(HttpServletRequest request){
        saveToken(request);
    }



    public static void saveToken(HttpServletRequest request){
        long token = System.currentTimeMillis();
        request.setAttribute(TOKEN_KEY, String.valueOf(token));
        request.getSession().setAttribute(TRANSACTION_TOKEN_KEY, String.valueOf(token));
    }



    public static synchronized boolean isTokenValid(HttpServletRequest request){
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }

        String saved = (String) session.getAttribute(TRANSACTION_TOKEN_KEY);
        if (saved == null) {
            return false;
        }

        String token = request.getParameter(TOKEN_KEY);
        if(token == null){
            return false;
        }

        return saved.equals(token);
    }
}
