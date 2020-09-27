package rcmtm.encrypt;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import chinsoft.core.Utility;
import net.sf.json.JSONObject;
import rcmtm.business.ConfigSR;
import rcmtm.encrypt.CCBInterfaceUtil;
import rcmtm.entity.ErrorInfo;

public class SendDataUtil implements Runnable {
	private String url;
	private String data;

	public SendDataUtil() {
	}
	
	public SendDataUtil(String data) {
		this.data = data;
	}

	public SendDataUtil(String url, String data) {
		this.url = url;
		this.data = data;
	}
	@Override
	public void run() {
		boolean sendSuccess = false;
		int sendCount = 0;
		boolean returnValue = false;
		// 发送数据
		try {
			while (!sendSuccess && sendCount != 3) {
				// 假设的发送返回错误状态 1成功 2失败 3异常
				if(sendCount == 0) {
					String result = new CCBInterfaceUtil().sendData(ConfigSR.URL_BIND,data);
					JSONObject  js=JSONObject.fromObject(result);
					ErrorInfo error=(ErrorInfo) JSONObject.toBean(js,ErrorInfo.class);
					returnValue = error.isFlag();
				}else{
					if (returnValue) {//发送成功了
						sendSuccess = true;
					}else if(!returnValue) {//数据错误
						Thread.currentThread();
						Thread.sleep(3000);
						String result = new CCBInterfaceUtil().sendData(ConfigSR.URL_BIND,data);
						JSONObject  js=JSONObject.fromObject(result);
						ErrorInfo error=(ErrorInfo) JSONObject.toBean(js,ErrorInfo.class);
						returnValue = error.isFlag();
					}else{//网络问题
						Thread.currentThread();
						Thread.sleep(30000);
						String result = new CCBInterfaceUtil().sendData(ConfigSR.URL_BIND,data);
						JSONObject  js=JSONObject.fromObject(result);
						ErrorInfo error=(ErrorInfo) JSONObject.toBean(js,ErrorInfo.class);
						returnValue = error.isFlag();
					} 
				}
				sendCount++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 三次发送数据的方法,
	 * @param url 地址
	 * @param data	数据
	 */
	public void sendDate(String url,String data){
		ScheduledExecutorService service = Executors.newScheduledThreadPool(3);
		service.schedule(new SendDataUtil(url,data), 0,
				TimeUnit.MILLISECONDS);
	}
}
