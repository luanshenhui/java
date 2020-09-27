package cn.com.cgbchina.common.security;


import java.util.Properties;
import com.alibaba.druid.util.DruidPasswordCallback;
import com.google.common.base.Strings;

/**
 * 数据库密码回调解密
 *
 */
@SuppressWarnings("serial")
public class DBPasswordCallback extends DruidPasswordCallback {
    private static final byte[] key = { 9, -1, 0, 5, 39, 8, 6, 19 };

    public void setProperties(Properties properties) {
        super.setProperties(properties);
        String pwd = properties.getProperty("password");
        if (!Strings.isNullOrEmpty(pwd)) {
            try {
                String password = SecurityUtil.decryptDes(pwd, key);
                setPassword(password.toCharArray());
            } catch (Exception e) {
                setPassword(pwd.toCharArray());
            }
        } else {
            setPassword("".toCharArray());
        }
    }

    public static String getPwd(String pwd) {
        if (!Strings.isNullOrEmpty(pwd)) {
            try {
                return SecurityUtil.decryptDes(pwd, key);
            } catch (Exception e) {
                return pwd;
            }
        } else {
            return "";
        }
    }

    public static void main(String[] args) {
        String p1 = args[0];
        String encrypt = SecurityUtil.encryptDes(p1, key);
        System.out.println(encrypt);
        System.out.println( SecurityUtil.decryptDes(encrypt, key));
    }
}
