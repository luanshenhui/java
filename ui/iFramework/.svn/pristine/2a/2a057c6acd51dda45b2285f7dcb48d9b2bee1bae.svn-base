package com.dhc.base.audit.util;

import java.lang.management.ManagementFactory;
import java.lang.management.RuntimeMXBean;

import javax.servlet.http.HttpServletRequest;

import com.dhc.ilead.license.util.LicenseUtil;

public class AuditUtil {
	public static String getIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		if (ip != null && ip.equals("127.0.0.1")) {
			ip = getLocalIP();
		}
		return ip;
	}

	private static String getLocalIP() {
		String localIps = LicenseUtil.getLocalIPAddresses();
		if (localIps != null && localIps.indexOf("127.0.0.1") == 0) {
			localIps = localIps.substring("127.0.0.1".length() + 1, localIps.length() - 1);
		}
		return localIps;
	}

	public static String getBackupId(String actionTime) {
		String macs = getMacs();
		String vmVersion = getVmVersion();
		StringBuffer backupId = new StringBuffer();
		backupId.append(actionTime).append("@").append(macs).append("@").append(vmVersion);
		return backupId.toString();
	}

	private static String getMacs() {
		return LicenseUtil.getMacAddresses();
	}

	private static String getVmVersion() {
		RuntimeMXBean rmb = (RuntimeMXBean) ManagementFactory.getRuntimeMXBean();
		return rmb.getVmVersion();
	}

	public static void main(String[] args) {
		String a = AuditUtil.getBackupId("12345678901");
		System.out.println(a);
	}
}
