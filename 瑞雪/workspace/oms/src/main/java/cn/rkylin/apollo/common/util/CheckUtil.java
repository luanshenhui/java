package cn.rkylin.apollo.common.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CheckUtil {
	// 判断电话
    public static boolean isTelephone(String phonenumber) {
        String phone = "0\\d{2,3}-\\d{7,8}";
        Pattern p = Pattern.compile(phone);
        Matcher m = p.matcher(phonenumber);
        return m.matches();
    }

    // 判断手机号
    public static boolean isMobileNO(String mobiles) {
        Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$");
        Matcher m = p.matcher(mobiles);
        return m.matches();
    }

    // 判断邮箱
    public static boolean isEmail(String email) {
        String str = "^([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)*@([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)+[\\.][A-Za-z]{2,3}([\\.][A-Za-z]{2})?$";
        Pattern p = Pattern.compile(str);
        Matcher m = p.matcher(email);
        return m.matches();
    }

    // 判断日期格式:yyyy-mm-dd HH:mm:ss

    public static boolean isValidDate(String sDate) {
    	String datePattern = "(((01[0-9]{2}|0[2-9][0-9]{2}|[1-9][0-9]{3})-(0?[13578]|1[02])-(0?[1-9]|[12]\\d|3[01]))|((01[0-9]{2}|0[2-9][0-9]{2}|[1-9][0-9]{3})-(0?[13456789]|1[012])-(0?[1-9]|[12]\\d|30))|((01[0-9]{2}|0[2-9][0-9]{2}|[1-9][0-9]{3})-0?2-(0?[1-9]|1\\d|2[0-8]))|(((1[6-9]|[2-9]\\d)(0[48]|[2468][048]|[13579][26])|((04|08|12|16|[2468][048]|[3579][26])00))-0?2-29)) (20|21|22|23|[0-1]?\\d):[0-5]?\\d:[0-5]?\\d";
    	Pattern p = Pattern.compile(datePattern);
    	Matcher m = p.matcher(sDate);
    	return m.matches();
    }
    //验证整数
    public static boolean isInteger(String str) 
    { 
        java.util.regex.Pattern pattern=java.util.regex.Pattern.compile("^-?\\d+$"); 
        java.util.regex.Matcher match=pattern.matcher(str); 
        if(match.matches()==false) 
        { 
           return false; 
        } 
        else 
        { 
           return true; 
        } 
    }
    
  //验证浮点
    public static boolean isFloat(String str) 
    { 
        java.util.regex.Pattern pattern=java.util.regex.Pattern.compile("^(-?\\d+)(\\.\\d+)?$"); 
        java.util.regex.Matcher match=pattern.matcher(str); 
        if(match.matches()==false) 
        { 
           return false; 
        } 
        else 
        { 
           return true; 
        } 
    }
}
