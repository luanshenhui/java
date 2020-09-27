package cn.com.cgbchina.rest.common.utils;

import com.google.common.base.Strings;

import java.math.BigDecimal;
import java.util.Random;

/**
 * Comment: Created by 11150321050126 on 2016/4/25.
 */
public class StringUtil {
	/**
	 * 首字母大写
	 * 
	 * @param name
	 * @return
	 */
	public static String captureName(String name) {
		if (!Strings.isNullOrEmpty(name) && !Strings.isNullOrEmpty(name.trim())) {
			char[] cs = name.toCharArray();
			cs[0] -= 32;
			return String.valueOf(cs);
		}else {
			return name;
		}
	}

	/**
	 * null转换""
	 *
	 * @param o
	 * @return
	 */
	public static String dealNullObject(Object o) {
		if (o == null) {
			return "";
		}
		return o.toString();
	}

	/**
	 *
	 * <p>
	 * Description:去空处理
	 * </p>
	 * 
	 * @param str
	 * @return
	 * @author:panhui
	 * @update:2014-7-2
	 */
	public static String dealNull(String str) {
		if (str == null) {
			return "";
		}
		return str.trim();
	}

	/**
	 * 返回s的trim值，如果s为空，则返回空
	 *
	 * @param s
	 */
	public static String getTrimValue(Object s) {
		if (s == null) {
			return null;
		} else {
			return s.toString().trim();
		}
	}

	/**
	 * Description : 获取指定位数的随机数 最长20位
	 * 
	 * @param level
	 * @return
	 */
	public static String getRamdomNumber(int level) {
		String str = "";
		if (level == 0 || level == 1) {
			level = 1;
		}
		int number = new Random().nextInt(Integer.parseInt("9999999999999999999999".substring(0, level)));
		str = String.valueOf(number);
		if (str.length() < level) {
			str = "00000000000000000000".substring(0, level - str.length()) + str;
		}
		return str;
	}

	/**
	 * Description :  int型转成字符串，前面补零，最长十位数
	 * @author xiel
	 * @param number
	 * @param length
	 * @return
	 */
	public static String intToString(int number, int length) {
		String numString = number + "";
		if (numString.length() > length || numString.length() > 10 || length > 10) {
			return numString;
		}
		String temp = "0000000000".substring(10 - length);
		return temp.substring(numString.length()) + numString;
	}

	/**
	 * Description : long型转成字符串，前面补零，最长十位数
	 * @author xiel
	 * @param longNum
	 * @param length
	 * @return
	 */
	public static String longToString(Long longNum, int length) {
		String numString = longNum + "";
		if (numString.length() > length || numString.length() > 10 || length > 10) {
			return numString;
		}
		String temp = "0000000000".substring(10 - length);
		return temp.substring(numString.length()) + numString;
	}

	/**
	 * Description : bigDecimal型转字符串  小数点保留两位，最长12位数，即是(小数点前十位+小数点后两位，没有小数点)<br/>
	 * 				待检验
	 * @author xiel
	 * @param num
	 * @param length
	 * @return
	 */
	public static String bigDecimalToString(BigDecimal num, int length) {
		String outStr = num + "";
		if (outStr.substring(outStr.indexOf(".")+1).length()<2) {
			outStr += "0";
		}
		outStr = outStr.replace(".", "");
		if (outStr.length()<12) {
			outStr =  "000000000000".substring(outStr.length())+outStr;
		}
		return outStr;
	}

	/**
	 * 屏蔽字符串关键信息
	 * @param sourceString 源字符串
	 * @return
	 */
	public static String maskString(String sourceString){
		if(sourceString==null){
			return sourceString;
		}else{
			sourceString = sourceString.trim();
		}
		StringBuffer sb = new StringBuffer();
		int length = sourceString.length();
		while(length>0){
			sb.append("*");
			length--;
		}
		return sb.toString();
	}

	/**
	 * 屏蔽字符串关键信息
	 * @param sourceString 源字符串
	 * @param startIndex 开始位置
	 * @param maskLength 屏蔽范围
	 * @return
	 */
	public static String maskString(String sourceString,String LR,int startIndex,int maskLength){
		if(sourceString==null){
			return sourceString;
		}else{
			sourceString = sourceString.trim();
		}
		if(sourceString.length()<=startIndex+maskLength){
			return sourceString;
		}
		String maskStr;
		if(maskLength==1){
			maskStr ="*";
		}else if(maskLength==2){
			maskStr ="**";
		}else if(maskLength==3){
			maskStr ="***";
		}else if(maskLength==4){
			maskStr ="****";
		}else if(maskLength==5){
			maskStr ="*****";
		}else if(maskLength==6){
			maskStr ="******";
		}else if(maskLength==7){
			maskStr ="*******";
		}else if(maskLength==8){
			maskStr ="********";
		}else if(maskLength==9){
			maskStr ="*********";
		}else if(maskLength==10){
			maskStr ="**********";
		}else{
			maskStr ="***********";
		}


		if("L".equalsIgnoreCase(LR)){
			try {
				return sourceString.substring(0, startIndex)+maskStr+sourceString.substring(startIndex+maskLength);
			} catch (Exception e) {
				return sourceString;
			}
		}else if("R".equalsIgnoreCase(LR)){
			try {
				int leftIndex = sourceString.length()-(startIndex+maskLength);
				return sourceString.substring(0, leftIndex)+maskStr+sourceString.substring(leftIndex+maskLength);
			} catch (Exception e) {
				return sourceString;
			}
		}else{
			return sourceString;
		}
	}

	/**
	 * 检查字符串是为空，为null，或者长度大于0
	 * @param str
	 * @return 非空：false，空：true
	 */
	public static boolean checkNull(String str){
		if(str!=null&&str.trim().length()>0)
			return false;

		return true;
	}

	/**
	 * 将应用网关的Double格式字符串（小数点前10位+小数点后2位，12字符串，没小数点），转换为double类型
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public static double ccEnvelopeStringToDouble(String str) throws Exception{
		if(str!=null&&
				("0".equals(str.trim())||"".equals(str.trim()))){
			return 0;
		}
		if(str==null||str.length()!=12){
			throw new Exception("Format Error");
		}
		String convertStr = str.substring(0,10)+"."+str.substring(10);
		return Double.parseDouble(convertStr);
	}
}
