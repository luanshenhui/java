package com.test.sms;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.extern.slf4j.Slf4j;
import cn.com.cgbchina.rest.common.utils.CommunicationNatp;

@Slf4j
public class TestSend {
	public static void main(String[] args) {
		SimpleDateFormat serialSdf = new SimpleDateFormat("yyyyMMddHHmmss99999");
		int natpVersion = 16;
		String transCode = "MSEND";
		String templateCode = "300001";
		String reservedCode = "SMSP";
		CommunicationNatp natp = new CommunicationNatp();
		natp.init(natpVersion, transCode, templateCode, reservedCode);

		try {
			// �ֻ���֤��
			natp.pack("SMSID", "FH");// �̳�Ҫ��FH

			// ��֤��ģ��
			natp.pack("TEMPLATEID", "072FH00001");// �����Ժ��

			natp.pack("FIXTEMPLATE", "");
			natp.pack("SERIAL", serialSdf.format(new Date()));
			natp.pack("CHANNELCODE", "072");// �̳�Ҫ��072
			natp.pack("SENDBRANCH", "000000");// �̳�Ҫ�� ��ҵ��
			natp.pack("MOBILE", "18675186626");
			natp.pack("CONTENT", "test");
			// natp.pack("SUBBRANCH", "000000");
			natp.pack("IDTYPE", "");
			natp.pack("IDCODE", "");
			// ��֤��
			// natp.pack("VERIFYCODE", "1235324");
			String sdf = new SimpleDateFormat("yyyyMMdd HH:mm:ss").format(new Date());
			natp.pack("DATEYYYY", sdf.substring(0, 4));
			natp.pack("DATEMM", sdf.substring(4, 6));
			natp.pack("DATEDD", sdf.substring(6, 8));
			natp.pack("TIMEHH", sdf.substring(9, 11));
			natp.pack("TIMEMM", sdf.substring(12, 14));
			System.out.println(natp.exchange_result("21.96.165.85:58088:5")); // 10.2.37.12:58088
		} catch (Exception e) {
			e.printStackTrace();
			// System.out.println("e");
		}
	}
}
