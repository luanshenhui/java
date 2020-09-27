package com.jdecard;

import com.jdecard.gameapi.ActionResponse;
import com.jdecard.common.LoggerUtil;


public class jdTest {

	// 请求URL
	private static String ReqURL = "http://card.jd.com/api/";

	/**
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {

		LoggerUtil.LogPath = jdTest.class.getResource("/").getPath();

		JdEcardClient jc = new JdEcardClient();
		ActionResponse response =  jc.GageApiAction("1234567890", "12121212111", "ww3333434343", "1");

		System.out.println(response.getResult());
		System.out.println(response.getRetCode());
		System.out.println(response.getRetMessage());

	}
}
