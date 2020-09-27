package cn.lsh.web.controller.login.com;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;

import org.springframework.web.multipart.MultipartFile;

import com.baidu.yun.core.log.YunLogEvent;
import com.baidu.yun.core.log.YunLogHandler;
import com.baidu.yun.push.auth.PushKeyPair;
import com.baidu.yun.push.client.BaiduPushClient;
import com.baidu.yun.push.constants.BaiduPushConstants;
import com.baidu.yun.push.exception.PushClientException;
import com.baidu.yun.push.exception.PushServerException;
import com.baidu.yun.push.model.PushBatchUniMsgRequest;
import com.baidu.yun.push.model.PushBatchUniMsgResponse;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

/**
 * 推送单播通知
 * 
 * App ID: 9787766

API Key: m1PnLt0anrj75AsMF5AZMvAb

Secret Key: f4c6d866dfd21e2ff956111816c753e5
 * 
 * @author
 * @Date 2017年3月2日
 * @Desc
 */
public class BaiduPush {
	public static String fileName;

	public static String PushBatchUniMsg(String[] channelIds,String message) throws PushClientException, PushServerException{
        // 1. get apiKey and secretKey from developer console
//        String apiKey = "TKgo5mQ01t6TaXbyItsBqurr1sdKbxN0";//测试
        String apiKey = "M4UEr8xEWcP7r5uwQDduOk5G";
//        String secretKey = "NY0zAbpr45HbLEG6NsdtUpTOsm7Ljw3d";//测试
        String secretKey = "FS26KPRdEA1b3mRCXlmsqnn5uEN5kRf9";
        PushKeyPair pair = new PushKeyPair(apiKey, secretKey);

        // 2. build a BaidupushClient object to access released interfaces
        BaiduPushClient pushClient = new BaiduPushClient(pair,
                BaiduPushConstants.CHANNEL_REST_URL);

        // 3. register a YunLogHandler to get detail interacting information
        // in this request.
        pushClient.setChannelLogHandler(new YunLogHandler() {
            @Override
            public void onHandle(YunLogEvent event) {
                System.out.println(event.getMessage());
            }
        });
        try {
            // 4. specify request arguments
//            String[] channelIds = { "3476334069966359933","4404647499098611744"};
            PushBatchUniMsgRequest request = new PushBatchUniMsgRequest()
                    .addChannelIds(channelIds)
                    .addMsgExpires(new Integer(3600))
                    .addMessageType(1)
//                    .addMessage("{\"title\":\"消息通知\",\"description\":\"Hello Baidu @@@ push!\"}")
                    .addMessage("{\"title\":\"消息通知\",\"description\":\"当前时间"+BaiduPush.getSysTime("yyyy-MM-dd HH:mm:ss")+" "+message+"\"}")
                    .addDeviceType(3).addTopicId("BaiduPush");// 设置类别主题
            // 5. http request
            PushBatchUniMsgResponse response = pushClient
                    .pushBatchUniMsg(request);
            // Http请求返回值解析
            System.out.println(String.format("msgId: %s, sendTime: %d",
                    response.getMsgId(), response.getSendTime()));
        } catch (PushClientException e) {
            if (BaiduPushConstants.ERROROPTTYPE) {
                throw e;
            } else {
                e.printStackTrace();
            }
        } catch (PushServerException e) {
            if (BaiduPushConstants.ERROROPTTYPE) {
                throw e;
            } else {
                System.out.println(String.format(
                        "requestId: %d, errorCode: %d, errorMsg: %s",
                        e.getRequestId(), e.getErrorCode(), e.getErrorMsg()));
            }
        }
		return "success";
	}
	
    public static String getFourRandom(){
        Random random = new Random();
        String fourRandom = random.nextInt(10000) + "";
        int randLength = fourRandom.length();
        if(randLength<4){
          for(int i=1; i<=4-randLength; i++)
              fourRandom = "0" + fourRandom  ;
      }
        return fourRandom;
    }
	
	public void sendMobileCode() {
	    String rusult = null;
	    // 官网的URL
	    String url = "http://gw.api.taobao.com/router/rest";
	    // 成为开发者，创建应用后系统自动生成
	    String appkey = "23566780";
	    String secret = "自己的App Secret";
	    String code = "520";
	    String product = "cool_moon";
	    TaobaoClient client = new DefaultTaobaoClient(url, appkey, secret);
	    AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
	    req.setExtend("1234");
	    req.setSmsType("normal");
	    req.setSmsFreeSignName("验证提醒");
	    req.setSmsParamString("{\"code\":\""+code+"\",\"product\":\""+product+"\"}");
	    req.setRecNum("13130496439");
	    req.setSmsTemplateCode("SMS_34530098");
	    try {
	        AlibabaAliqinFcSmsNumSendResponse rsp = client.execute(req);
	        System.out.println(rsp.getBody());  
	        rusult = rsp.getSubMsg();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    System.out.println(rusult);
	}

	public static String getSysTime(String str){
		Date d = new Date();  
		SimpleDateFormat sdf = new SimpleDateFormat(str);  
		return sdf.format(d); 
		
	}
	
	public static String getLeveTime(String brithday) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
		Date bdate = sdf.parse(brithday); 
		Calendar aCalendar = Calendar.getInstance();
		aCalendar.setTime(bdate);
		aCalendar.add(Calendar.YEAR, 18);
		Date fDate=aCalendar.getTime();
		return String.valueOf(daysBetween(new Date(),fDate));
	}
	
	/**  
     * 计算两个日期之间相差的天数  
     * @param smdate 较小的时间 
     * @param bdate  较大的时间 
     * @return 相差天数 
     * @throws ParseException  
     */    
    public static int daysBetween(Date smdate,Date bdate) throws ParseException    
    {    
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");  
        smdate=sdf.parse(sdf.format(smdate));  
        bdate=sdf.parse(sdf.format(bdate));  
        Calendar cal = Calendar.getInstance();    
        cal.setTime(smdate);    
        long time1 = cal.getTimeInMillis();                 
        cal.setTime(bdate);    
        long time2 = cal.getTimeInMillis();         
        long between_days=(time2-time1)/(1000*3600*24);  
             
       return Integer.parseInt(String.valueOf(between_days));           
    }    
	
	public static void main(String[] args) throws ParseException {
//		BaiduPush baiduPush = new BaiduPush();
//		Map<String, Object> map = new HashMap<>();
//		baiduPush.pushNotificationByUser("clientChannelId", 3, "今天天气不错", map);
		
//		BaiduPush b=new BaiduPush();
//		String s=b.getLeveTime("1999-06-31");
//		System.out.println(s);
	}
	
	public static String dayToString(Date day ,String format){
		SimpleDateFormat sdf=new SimpleDateFormat(format);  
		return sdf.format(day);
	}

	   public static boolean YzImgType(MultipartFile user_img) {
	    	if(user_img.getOriginalFilename().equals("jpg") || user_img.getOriginalFilename().equals("jpeg") || user_img.getOriginalFilename().equals("png")){
	    		return true;
	    	}
	        String type = user_img.getOriginalFilename().indexOf(".") != -1?user_img.getOriginalFilename().substring(user_img.getOriginalFilename().lastIndexOf("."), user_img.getOriginalFilename().length()):null;
	        type = type.toLowerCase();
	        return type.equals(".jpg") || type.equals(".jpeg") || type.equals(".png");
	    }
	   
	    public static String saveFile(MultipartFile file, String filePath, String user_id) {
	        if(!file.isEmpty()) {
	            try {
	                String fileName1 = user_id + ".png";
	                File f = new File(filePath, fileName1);
	                if(f.exists()) {
	                    f.delete();
	                }
	                file.transferTo(f);
	            } catch (Exception var6) {
	                var6.printStackTrace();
	            }
	        }
	        return "ok";
	    }
}
