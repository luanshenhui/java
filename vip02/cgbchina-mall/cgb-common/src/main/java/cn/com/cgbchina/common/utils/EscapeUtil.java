package cn.com.cgbchina.common.utils;

/**
 * Created by lvzd on 2016/9/7.
 */
public class EscapeUtil {

    public static String allLikeStr(String tmp) {
        if (tmp == null || tmp.trim().length() == 0) return null;
        StringBuffer sb = new StringBuffer();
        sb.append("%");
        sb.append(tmp.replaceAll("%", "/%").replaceAll("_", "/_").replaceAll("\\\\", "/\\\\"));
        sb.append("%");
        return sb.toString();
    }

    public static String leftLikeStr(String tmp) {
        if (tmp == null || tmp.trim().length() == 0) return null;
        StringBuffer sb = new StringBuffer();
        sb.append("%");
        sb.append(tmp.replaceAll("%", "/%").replaceAll("_", "/_").replaceAll("\\\\", "/\\\\"));
        return sb.toString();
    }

    public static String rightLikeStr(String tmp) {
        if (tmp == null || tmp.trim().length() == 0) return null;
        StringBuffer sb = new StringBuffer();
        sb.append(tmp.replaceAll("%", "/%").replaceAll("_", "/_").replaceAll("\\\\", "/\\\\"));
        sb.append("%");
        return sb.toString();
    }
}
