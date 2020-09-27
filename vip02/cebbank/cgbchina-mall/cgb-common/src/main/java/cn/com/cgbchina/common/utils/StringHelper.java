package cn.com.cgbchina.common.utils;

import org.apache.commons.lang3.StringUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by zhangshiqiang on 2016/4/29.
 */
public class StringHelper {
	/**
	 * 判断输入的字符串参数是否为空
	 *
	 * @return boolean 空则返回true,非空则flase
	 */
	public static boolean isEmpty(String input) {
		return null == input || 0 == input.length() || 0 == input.replaceAll("\\s", "").length();
	}

	/**
	 * 判断输入的字节数组是否为空
	 *
	 * @return boolean 空则返回true,非空则flase
	 */
	public static boolean isEmpty(byte[] bytes) {
		return null == bytes || 0 == bytes.length;
	}

	/**
	 * 验证字符串非空
	 */
	public static boolean isNotEmpty(String str) {
		return (str == null || str.equals("")) ? false : true;
	}

	/**
	 * 检查IP串是否合法
	 *
	 * @param ips
	 * @param limit 分隔符
	 * @return
	 */
	public static boolean checkIps(String ips, String limit) {
		Pattern pattern = Pattern.compile(
				"^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\\.){1,3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])?$");
		boolean pass = false;
		String[] ipArray = ips.split(limit, 0);
		for (String ip : ipArray) {
			if (ip != null && ip.length() > 0) {
				if (pattern.matcher(ip).matches()) {
					pass = true;
				} else {
					pass = false;
					break;
				}
			}
		}
		return pass;
	}

	/**
	 * 校验手机号码是否合法
	 *
	 * @param mobile
	 * @return
	 */
	public static boolean checkMobile(String mobile) {
		// 增加了对17开头手机号码的支持
		Pattern pattern = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9])|(17[0-9]))\\d{8}$");
		Matcher matcher = pattern.matcher(mobile);
		return matcher.matches();
	}

	/**
	 * 校验邮箱是否合法
	 *
	 * @return
	 */
	public static boolean checkEmail(String email) {
		String checkemail = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
		Pattern pattern = Pattern.compile(checkemail);
		Matcher matcher = pattern.matcher(email);
		return matcher.matches();
	}

	/**
	 * 校验金额，小数点后面只能保留两位
	 *
	 * @param money
	 * @return
	 */
	public static boolean checkMoney(String money) {
		String checkMoney = "^(-)?(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$";
		Pattern pattern = Pattern.compile(checkMoney);
		Matcher matcher = pattern.matcher(money);
		return matcher.matches();
	}
	// public static void main(String arg[]) {
	// System.out.print(checkEmail("zhang@dhc.com.cn"));
	//
	// }

	/**
	 * 对卡号中间数字用＊代替
	 *
	 * @param cardNo
	 * @return
	 */
	public static String maskCardNo(String cardNo) {
		if (StringUtils.isBlank(cardNo)) {
			return cardNo;
		}
		return cardNo.substring(0, 4) + " * * * * * * * * " + cardNo.substring(cardNo.length() - 4, cardNo.length());
	}

}
