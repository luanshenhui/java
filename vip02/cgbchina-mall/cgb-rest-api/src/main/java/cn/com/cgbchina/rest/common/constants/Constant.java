package cn.com.cgbchina.rest.common.constants;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by 11140721050130 on 2016/5/3.
 */
public class Constant {
	//******************字符集****************************
	public static final String CHARSET_GBK = "GBK";
	public static final String CHARSET_UTF8 = "UTF-8";
	//******************o2o加密串的顺序*********************
	public static final String[] O2O_SIGN_ORDER = { "msgtype", "format", "version", "shopid", "timestamp", "method",
			"message" };
	//******************o2o的请求类型标识********************
	public static final String REQUESTMESSAGE = "requestmessage";
	//******************日志类型，1：请求日志 2：响应日志**********
	public static final String SEND_FLG="1";
	public static final String RECEIVE_FLG="2";
	//******************日志打印线程池数量*********************
	public static final int THREAD_NUM=5;
	//******************O2Oheader*********************
	public static final String FORWARD_URL="ForwardUrl";

	//******************限流系统的key*********************
	public static Map<String,String> keysMap = new HashMap<String,String>(){
		private static final long serialVersionUID = 362496894263181265L;
		{
			put("SWT2", "增值系统");
			put("IPBS", "电子支付");
			put("BPSN", "工单系统");
			put("JFDJ", "积分系统");
			put("O2O", "O2O系统");
			put("EBANK", "个人网银");
		}
	};

}
