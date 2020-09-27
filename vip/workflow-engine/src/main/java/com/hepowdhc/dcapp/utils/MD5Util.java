package com.hepowdhc.dcapp.utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

/**
 * md5加密
 */
public final class MD5Util {

    /**
     * 字符串MD5加密
     * @param value
     * @return
     */
    public static String getMD5Str(String value) {
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            byte[] digest1 = digest.digest(value.getBytes());
            return new BigInteger(1, digest1).toString(16);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return value;
    }

}
