/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.common.utils;

import lombok.extern.slf4j.Slf4j;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.NetworkInterface;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/7/9
 */
@Slf4j
public class LocalHostUtil {

    public static void main(String[] arguments) throws Exception{

        System.out.println("Ip ......... "+getIpAddress());
        System.out.println("MAC ......... "+geMacAddress());
    }

    /**
     * 获取本机MAC地址
     * @return
     */
    public static String geMacAddress() throws  Exception{
        InetAddress ia = InetAddress.getLocalHost();
		// 下面代码是把mac地址拼装成String
		StringBuffer sb = new StringBuffer();
		// 获得网络接口对象（即网卡），并得到mac地址，mac地址存在于一个byte数组中。
		try {
			byte[] mac = NetworkInterface.getByInetAddress(ia).getHardwareAddress();

			for (int i = 0; i < mac.length; i++) {
				if (i != 0) {
					sb.append("-");
				}
				// mac[i] & 0xFF 是为了把byte转化为正整数
				String s = Integer.toHexString(mac[i] & 0xFF);
				sb.append(s.length() == 1 ? 0 + s : s);
			}
			// 把字符串所有小写字母改为大写成为正规的mac地址并返回

		} catch (Exception e) {
            log.error("get localhost infromation fail! {}",e);
		}
        return sb.toString().toUpperCase();
	}

    /**
     * 获取Ip地址
     * @return
     */
    public static String getIpAddress(){
        String ipStr = null;
        try{
            InetAddress ia = InetAddress.getLocalHost();
            ipStr = String.valueOf(ia);
        }catch (Exception e){
            log.error("get ip address fail{}",e);
        }
        return ipStr;
    }
}
