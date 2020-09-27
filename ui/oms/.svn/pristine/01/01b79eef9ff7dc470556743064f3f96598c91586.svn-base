package cn.rkylin.apollo.common.util;

import java.rmi.server.UID;
import java.util.UUID;

import org.springframework.jdbc.support.incrementer.MySQLMaxValueIncrementer;

public class SnoGerUtil {

	// 获取项目PROJECT_CODE唯一序列
	public static String getMysqlProjectCodeSeq() throws Exception {
		MySQLMaxValueIncrementer service = (MySQLMaxValueIncrementer) BeanUtils.getBean("incre");
		String seq = service.nextStringValue();
		return seq;
	}

	// 获取23为UID
	public static String getUID() {
		return new UID().toString().replaceAll(":", "").replace("-", "");
	}

	// 获取32位UUID
	public static String getUUID() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}

}
