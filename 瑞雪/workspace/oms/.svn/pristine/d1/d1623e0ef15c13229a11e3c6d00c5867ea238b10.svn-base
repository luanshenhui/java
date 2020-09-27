package cn.rkylin.core.utils;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtil {
    
    public static int strToInt(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
    
    public static String getFunctionName(String paramName) {
        String functionName = null;
        
        if (paramName.length() > 1) {
            functionName = paramName.substring(0, 1).toUpperCase()
                            + paramName.substring(1, paramName.length());
        } else {
            functionName = paramName.toUpperCase();
            
        }
        return functionName;
    }
    
    public static Date StringToDate(String sDate, String sFormat) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat(sFormat);
        return sdf.parse(sDate);
    }
    
    public static java.sql.Timestamp StringToTimestamp(String sDate, String sFormat) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat(sFormat);
        Date t = sdf.parse(sDate);
        return new java.sql.Timestamp(t.getTime());
        
    }
    
    public static Object StringToObj(String s, int type) {
        try {
            switch (type) {
                case -7:
                    return Boolean.parseBoolean(s);
                case -6:
                    return Byte.parseByte(s);
                case 5:
                    return Short.parseShort(s);
                case 4:
                    return Integer.parseInt(s);
                case -5:
                    return Long.parseLong(s);
                case 6:
                    return Float.parseFloat(s);
                case 7:
                case 8:
                    return Double.parseDouble(s);
                case 2:
                case 3:
                    return Integer.parseInt(s);
                case 91:
                    return StringToDate(s, "yyyy-MM-dd HH:mm:ss");
                case 92:
                case 93:
                    return StringToTimestamp(s, "yyyy-MM-dd HH:mm:ss");
                case 100:
    				return StringToTimestamp(s+" 00:00:00", "yyyy-MM-dd HH:mm:ss");
    			case 101:
    				return StringToTimestamp(s+" 23:59:59", "yyyy-MM-dd HH:mm:ss");
                case 9999:
                    return new BigDecimal(s);
                default:
                    return s;
            }
            
        } catch (Exception e) {
            return null;
        }
    }
    
    public static String getJavaType(int type, int scale) {
        String javaType = "";
        switch (type) {
            case -7:
                javaType = "Boolean";
            case -6:
                // return "byte";
                javaType = "java.sql.Blob";
            case 5:
                // return "short";
                javaType = "java.math.BigDecimal";
            case 4:
                // return "integer";
                javaType = "Integer";
            case -5:
                // return "long";
                javaType = "Long";
            case 6:
                // return "float";
                javaType = "java.math.BigDecimal";
            case 7:
            case 8:
                // return "double";
                javaType = "java.math.BigDecimal";
                break;
            case 2:
            case 3:
                // if (this.decimalDigits != 0) {
                // return "double";
                // }
                // return "long";
                if (scale != 0) {
                    javaType = "java.math.BigDecimal";
                } else {
                    javaType = "Integer";
                }
                break;
            case 91:
            case 92:
            case 93:
                // return "date";
                javaType = "java.util.Date";
                break;
            default:
                javaType = "String";
                
        }
        return javaType;
    }
    
    public static Date strToFormatDate(String date, String format) {
        if (date == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.parse(date, new ParsePosition(0));
    }
    
    /**
     * 将字符串转换为yyyy-MM-dd格式的日期
     * 
     * @param date
     * @return 转换后的日期对象
     */
    public static Date strToDate(String date) {
        return StringUtil.strToFormatDate(date, "yyyy-MM-dd");
    }
    
    /**
     * 将字符串转换为yyyy-MM-dd HH:mm:ss格式的日期
     * 
     * @param date
     * @return 转换后的日期对象
     */
    public static Date strToDateTime(String date) {
        return StringUtil.strToFormatDate(date, "yyyy-MM-dd HH:mm:ss");
    }
    
    /**
     * 将date型日期转换成特定格式的时间字符串
     * 
     * @param date
     * @param format
     * @return 转换后的日期对象
     */
    public static String dateToFormatStr(Date date, String format) {
        if (date == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(date);
    }
    
    /**
     * 将date型日期转换成yyyy-MM-dd HH:mm:ss格式的时间字符串
     * 
     * @param date
     *            日期
     * @return 返回yyyy-MM-dd HH:mm格式的时间字符串
     */
    public static String dateTimeToStr(Date date) {
        return StringUtil.dateToFormatStr(date, "yyyy-MM-dd HH:mm:ss");
    }
    
    /**
     * 将date型日期转换成yyyy-MM-dd格式的日期字符串
     * 
     * @param date
     *            日期
     * @return 返回yyyy-MM-dd格式的日期字符串
     */
    public static String dateToStr(Date date) {
        return StringUtil.dateToFormatStr(date, "yyyy-MM-dd");
    }
    
    /**
     * 计算出date day天之前或之后的日期
     * 
     * @param date
     *            {@link Date} 日期
     * @param days
     *            int 天数，正数为向后几天，负数为向前几天
     * @return 返回Date日期类型
     */
    public static Date getDateBeforeOrAfterDays(Date date, int days) {
        Calendar now = Calendar.getInstance();
        now.setTime(date);
        now.set(Calendar.DATE, now.get(Calendar.DATE) + days);
        return now.getTime();
    }
    
    /**
     * 计算出date monthes月之前或之后的日期
     * 
     * @param date
     *            日期
     * @param monthes
     *            月数，正数为向后几天，负数为向前几天
     * @return 返回Date日期类型
     */
    public static Date getDateBeforeOrAfterMonthes(Date date, int monthes) {
        Calendar now = Calendar.getInstance();
        now.setTime(date);
        now.set(Calendar.MONTH, now.get(Calendar.MONTH) + monthes);
        return now.getTime();
    }
    
    /**
     * 计算出date years年之前或之后的日期
     * 
     * @param date
     *            日期
     * @param years
     *            年数，正数为向后几年，负数为向前几年
     * @return 返回Date日期类型
     */
    public static Date getDateBeforeOrAfterYears(Date date, int years) {
        Calendar now = Calendar.getInstance();
        now.setTime(date);
        now.set(Calendar.YEAR, now.get(Calendar.YEAR) + years);
        return now.getTime();
    }
    
    /**
     * 计算两个日期之间的天数
     * 
     * @param beginDate
     * @param endDate
     * @return 如果beginDate 在 endDate之后返回负数 ，反之返回正数
     */
    public static int daysOfTwoDate(Date beginDate, Date endDate) {
        
        Calendar beginCalendar = Calendar.getInstance();
        Calendar endCalendar = Calendar.getInstance();
        
        beginCalendar.setTime(beginDate);
        endCalendar.setTime(endDate);
        
        return daysOfTwoDate(beginCalendar, endCalendar);
        
    }
    
    /**
     * 计算两个日期之间的天数
     * 
     * @param d1
     * @param d2
     * @return 如果d1 在 d2 之后返回负数 ，反之返回正数
     */
    public static int daysOfTwoDate(Calendar d1, Calendar d2) {
        int days = 0;
        int years = d1.get(Calendar.YEAR) - d2.get(Calendar.YEAR);
        if (years == 0) {// 同一年中
            days = d2.get(Calendar.DAY_OF_YEAR) - d1.get(Calendar.DAY_OF_YEAR);
            return days;
        } else if (years > 0) {// 不同一年
            for (int i = 0; i < years; i++) {
                d2.add(Calendar.YEAR, 1);
                days += -d2.getActualMaximum(Calendar.DAY_OF_YEAR);
                if (d1.get(Calendar.YEAR) == d2.get(Calendar.YEAR)) {
                    days += d2.get(Calendar.DAY_OF_YEAR)
                                    - d1.get(Calendar.DAY_OF_YEAR);
                    return days;
                }
            }
        } else
            for (int i = 0; i < -years; i++) {
                d1.add(Calendar.YEAR, 1);
                days += d1.getActualMaximum(Calendar.DAY_OF_YEAR);
                if (d1.get(Calendar.YEAR) == d2.get(Calendar.YEAR)) {
                    days += d2.get(Calendar.DAY_OF_YEAR)
                                    - d1.get(Calendar.DAY_OF_YEAR);
                    return days;
                }
            }
        return days;
    }
    
    /**
     * 获得当前时间当天的开始时间，即当前给出的时间那一天的00:00:00的时间
     * 
     * @param date
     *            当前给出的时间
     * @return 当前给出的时间那一天的00:00:00的时间的日期对象
     */
    public static Date getDateBegin(Date date) {
        SimpleDateFormat ymdFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (date != null) {
            try {
                return DateFormat.getDateInstance(DateFormat.DEFAULT, Locale.CHINA).parse(ymdFormat.format(date));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        
        return null;
    }
    
    /**
     * 获得当前时间当天的结束时间，即当前给出的时间那一天的23:59:59的时间
     * 
     * @param date
     *            当前给出的时间
     * @return 当前给出的时间那一天的23:59:59的时间的日期对象
     */
    public static Date getDateEnd(Date date) {
        SimpleDateFormat ymdFormat = new SimpleDateFormat("yyyy-MM-dd");
        if (date != null) {
            try {
                date = getDateBeforeOrAfterDays(date, 1);
                date = DateFormat.getDateInstance(DateFormat.DEFAULT, Locale.CHINA).parse(ymdFormat.format(date));
                Date endDate = new Date();
                endDate.setTime(date.getTime() - 1000);
                return endDate;
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
    
    public static String getTime() {
        Date d = new Date();
        String re = dateToFormatStr(d, "yyyyMMddHHmm");
        return re;
    }
    
    public static String removeLast(String str) {
        str = str.trim();
        return str.substring(0, str.length() - 1);
    }
    
    public static boolean isEmpty(String str) {
        return str == null || str.trim().length() == 0
                        || str.trim().equals("null");
    }
    
    public static int getRandom6() {
        Random ran = new Random();
        int r = 0;
        m1 : while (true) {
            int n = ran.nextInt(1000000);
            r = n;
            int[] bs = new int[6];
            for (int i = 0; i < bs.length; i++) {
                bs[i] = n % 10;
                n /= 10;
            }
            Arrays.sort(bs);
            for (int i = 1; i < bs.length; i++) {
                if (bs[i - 1] == bs[i]) {
                    continue m1;
                }
            }
            break;
        }
        return r;
    }
    
    public static int getCurrentTimeHashCode() {
        return String.valueOf(System.currentTimeMillis()).hashCode();
    }
    
    public static String randomNumString(int len) {
        final int maxNum = 10;
        char[] str = {'0', '1', '2', '3', '5', '6', '7', '8', '9'};
        StringBuffer randStr = new StringBuffer("");
        Random r = new Random();
        for (int i = 0, count = 0; count < len; i++) {
            i = Math.abs(r.nextInt(maxNum));
            if (i >= 0 && i < str.length) {
                randStr.append(str[i]);
                count++;
            }
        }
        return randStr.toString();
    }
    
    /**
     * 随机生成指定长度的字符串
     */
    public static String randomString(int length) {
        if (length < 1) { return null; }
        String basicchars = "0123456789abcdefghijklmnopqrstuvwxy";
        Random randGen = new Random();
        char[] numbersAndLetters = basicchars.toCharArray();
        char[] randBuffer = new char[length];
        for (int i = 0; i < randBuffer.length; i++) {
            randBuffer[i] = numbersAndLetters[randGen.nextInt(basicchars.length() - 1)];
        }
        return new String(randBuffer);
    }
    
    public static String format(String format, Object... objects) {
        return String.format(format, objects);
    }
    
    public static String Object2params(Object... params) {
        String newLine = "\n";
        if ("\\".equals(File.separator)) {// windows 下 log 换行符
            newLine = "\r\n";
        }
        StringBuffer info = new StringBuffer();
        info.append(newLine);
        int i = 1;
        if (params != null) {
            for (Object param : params) {
                info.append("[参数" + i + ":" + param + "]");
                info.append(newLine);
                i++;
            }
        }
        return info.toString();
    }
    
    public static boolean isAutowired(List<Object[]> condition) {
        return false;
    }
    
    public static boolean isAutowired(String condition) {
        return false;
    }
    
    public static String toUpperCaseFirstOne(String s) {
        if (Character.isUpperCase(s.charAt(0)))
            return s;
        else
            return (new StringBuilder()).append(Character.toUpperCase(s.charAt(0))).append(s.substring(1)).toString();
    }
    
    public static String formatBeanNameFirstUpper(String name) {
        if (name == null) return null;
        if (name.length() == 0) return "";
        String sReturn = formatBeanNameFirstLow(name);
        return toUpperCaseFirstOne(sReturn);
    }
    
    public static String formatBeanNameFirstLow(String name) {
        if (name == null) return null;
        if (name.length() == 0) return "";
        byte[] ss = name.toLowerCase().getBytes();
        int len = ss.length;
        byte[] ss1 = new byte[len];
        ss1[0] = ss[0];
        int k = 1;
        for (int i = 1; i < ss.length; i++) {
            if (ss[i] == '_') {
                if (i < ss.length - 1) {
                    ss1[k] = (byte)Character.toUpperCase(ss[(i + 1)]);
                    i++;
                }
                len--;
            } else {
                ss1[k] = ss[i];
            }
            k++;
        }
        return new String(ss1, 0, len);
    }
    
    public static Object getObjectValue(Field field, Object target) {
        Object result = null;
        try {
            String sMethodName = "get"
                            + StringUtil.toUpperCaseFirstOne(field.getName());
            Method method = target.getClass().getMethod(sMethodName, null);
            result = method.invoke(target, null);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    @SuppressWarnings("unchecked")
    public static String getValueFromObjectByName(Object obj, String fiedName) {
        if(!StringUtil.isEmpty(fiedName)){
            try {
                String sMethodName = "get"
//            + StringUtil.toUpperCaseFirstOne(fiedName);
                                + StringUtil.formatBeanNameFirstUpper(fiedName);//例：FIR_NAME 改成 FirName
                Method method = obj.getClass().getMethod(sMethodName, null);
                Object t = method.invoke(obj, null);
                if(t != null)
                    return t.toString();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
        }
        return null;
    }
    
    @SuppressWarnings("unchecked")
    public static Object[] getListByObject(Object obj) {
        ArrayList list = new ArrayList();
        for (Field field : obj.getClass().getDeclaredFields()) {
            Object result = getObjectValue(field, obj);
            list.add(field.getName() + "  值：   " + result);
        }
        return list.toArray();
    }  
    
    public static String replaceBlank(String str) {
        String dest = "";
        if (str != null) {
            Pattern p = Pattern.compile("\\s*|\t|\r|\n");
            Matcher m = p.matcher(str);
            dest = m.replaceAll("");
        }
        return dest;
    }
    
    
    public static String transferObjectList(List<Object[]> obj){
        
        if(obj == null){
            return "";
        }
        StringBuffer returnStr = new StringBuffer("[");
        for(Object[] o : obj){
            returnStr.append(Arrays.toString(o));
            returnStr.append(",");
        }
        returnStr.append("]");
        
        return returnStr.toString();
        
        
    }
    
}
