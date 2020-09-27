package cn.lsh.web.controller.login.com;

import com.baidu.yun.core.log.YunLogEvent;
import com.baidu.yun.core.log.YunLogHandler;
import com.baidu.yun.push.auth.PushKeyPair;
import com.baidu.yun.push.client.BaiduPushClient;
import com.baidu.yun.push.constants.BaiduPushConstants;
import com.baidu.yun.push.exception.PushClientException;
import com.baidu.yun.push.exception.PushServerException;
import com.baidu.yun.push.model.PushBatchUniMsgRequest;
import com.baidu.yun.push.model.PushBatchUniMsgResponse;

public class PushBatchUniMsg {
    public static void main(String[] args)
            throws PushClientException,PushServerException {
    	
//    	String imei = System.getProperty("868433024173936");
//    	System.out.println(imei);
        // 1. get apiKey and secretKey from developer console
        String apiKey = "TKgo5mQ01t6TaXbyItsBqurr1sdKbxN0";
        String secretKey = "NY0zAbpr45HbLEG6NsdtUpTOsm7Ljw3d";
        PushKeyPair pair = new PushKeyPair(apiKey, secretKey);

        // 2. build a BaidupushClient object to access released interfaces
        BaiduPushClient pushClient = new BaiduPushClient(pair,
                BaiduPushConstants.CHANNEL_REST_URL);

        // 3. register a YunLogHandler to get detail interacting information
        // in this request.
        pushClient.setChannelLogHandler(new YunLogHandler() {
           
            public void onHandle(YunLogEvent event) {
                System.out.println(event.getMessage());
            }
        });

        try {
            // 4. specify request arguments
            String[] channelIds = { "3476334069966359933","4404647499098611744"};
            PushBatchUniMsgRequest request = new PushBatchUniMsgRequest()
                    .addChannelIds(channelIds)
                    .addMsgExpires(new Integer(3600))
                    .addMessageType(1)
//                    .addMessage("{\"title\":\"ﾏ鋧｢ﾍｨﾖｪ\",\"description\":\"Hello Baidu @@@ push!\"}")
                    .addMessage("{\"title\":\"ﾏ鋧｢ﾍｨﾖｪ\",\"description\":\"ｵｱﾇｰﾊｱｼ�"+BaiduPush.getSysTime("yyyy-MM-dd HH:mm:ss")+"\"}")
                    .addDeviceType(3).addTopicId("BaiduPush");// ﾉ靹ﾃﾀ牾�
            // 5. http request
            PushBatchUniMsgResponse response = pushClient
                    .pushBatchUniMsg(request);
            // Httpﾇ�ﾇｵｻﾘﾖｵｽ簧�
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
    }
}