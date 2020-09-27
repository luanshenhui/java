package com.dpn.ciqqlc.common.util;

import java.io.UnsupportedEncodingException;

import org.apache.commons.codec.binary.Base64;

public class BaseUtils {

	public static byte [] decode(byte [] s){
		
		byte [] a = new byte[s.length];
		
		if(s == null && s.length == 0){
			return a;
		}
		
		a = Base64.decodeBase64(s);
		
		return a;
	}

	public static String decode(String s) throws UnsupportedEncodingException{
		byte [] a = Base64.decodeBase64(s.getBytes());
		String c = new String(a,"UTF-8");
		return c;
	}
	
	public static byte[] encode(String a ){
		
		byte[] q = new byte [65554];
		try {
			q = Base64.encodeBase64(a.getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return q;
	}
}
