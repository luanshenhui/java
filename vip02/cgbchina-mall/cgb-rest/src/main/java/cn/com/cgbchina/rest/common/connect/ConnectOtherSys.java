package cn.com.cgbchina.rest.common.connect;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.log.model.MessageLogModelExt;
import cn.com.cgbchina.log.service.MessageLogService;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConnectErrorException;
import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.util.ConnectionLimitRedisLock;
import cn.com.cgbchina.rest.common.utils.*;
import com.github.kevinsawicki.http.HttpRequest;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeansException;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
public class ConnectOtherSys implements Serializable {

	private static final long serialVersionUID = -7954381041992107736L;
	private static String smsIp = PropertieUtils.getParam().get("connect.smsIp");

	private static Integer smsPort = Integer.valueOf(PropertieUtils.getParam().get("connect.smsPort"));

	private static String pwdIp = PropertieUtils.getParam().get("connect.pwdIp");

	private static Integer pwdPort = Integer.valueOf(PropertieUtils.getParam().get("connect.pwdPort"));

	private static String gatewayUrl = PropertieUtils.getParam().get("connect.gatewayUrl");

	private static String ebankUrl = PropertieUtils.getParam().get("connect.ebankUrl");

	private static String fortressMachine = PropertieUtils.getParam().get("fortress.machine");

	private static String ebankSuffix = ".do";

	private static JsonMapper jsonMapper = JsonMapper.JSON_NON_DEFAULT_MAPPER;
	private static ExecutorService threadPool=Executors.newFixedThreadPool(Constant.THREAD_NUM);
	private static SendMsgLog sendMsgLog=new SendMsgLog();
	private static IdGenarator idGenarator;
	static {
		idGenarator=SpringContextUtils.getBean(IdGenarator.class);
		connectionLimitRedisLock= SpringContextUtils.getBean(ConnectionLimitRedisLock.class);
	}
	private static ConnectionLimitRedisLock connectionLimitRedisLock;
	public static <T> String connectSoapSys(final String xml,SoapModel<T> soapModel) {
			try {
			log.info("【柜面网关系统[" + gatewayUrl + "]发送的的xml报文】\n" + xml);
			Map<String, String> mapps = new HashMap<>();
			mapps.put("Content-type", "text/xml;charset=" + Constant.CHARSET_GBK);
			mapps.put("Connection", "close");
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgSoap(xml,null, Constant.SEND_FLG,date);}});

			connectionLimitRedisLock.checkLimit(soapModel.getReceiverId());
			final String result = HttpRequest.post(gatewayUrl,false).contentType("text/xml",Constant.CHARSET_GBK).send(xml).connectTimeout(100000).body();//HttpClientUtil.getInstance().sendHttpPost(gatewayUrl, xml, mapps, Constant.CHARSET_GBK);
			connectionLimitRedisLock.decrLimit(soapModel.getReceiverId());

			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgSoap(xml,result, Constant.RECEIVE_FLG,date);}});
			log.info("【柜面网关系统[" + gatewayUrl + "]返回的的xml报文】\n" + result);
			return result;
		} catch (RuntimeException e) {
			throw new ConnectErrorException(e);
		}
	}

	public static String connectXmlSys(final O2OSendModel model, final String url) {
		try {
			log.info("【行外系统[" + url + "]请求的xml报文】\n" + jsonMapper.toJson(model));
			Class<? extends O2OSendModel> clazz = model.getClass();
			Field[] fields = ReflectUtil.getFileds(clazz);
			StringBuffer sb=new StringBuffer();
			for (Field field : fields) {
				String name = field.getName();
				PropertyDescriptor pd = new PropertyDescriptor(name, clazz);
				Method method = pd.getReadMethod();
				Object value = method.invoke(model);
				String str = "";
				if (value != null) {
					str = String.valueOf(value);
				}
				sb.append(name+"="+str+"&");
			}
			String body=sb.substring(0,sb.length()-1);
			Map<String, String> header = new HashMap<>();
			header.put(Constant.FORWARD_URL, url);
			header.put("Content-Type","text/plain;charset=UTF-8");
			final String senderSN=idGenarator.genarateSenderSN();
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgO2O(model,url, Constant.SEND_FLG,senderSN,date);}});


			connectionLimitRedisLock.checkLimit("O2O");
			final String result = HttpRequest.post(fortressMachine).connectTimeout(100000).headers(header).send(body).body();//HttpClientUtil.getInstance().sendHttpPost(fortressMachine , header,body);
			connectionLimitRedisLock.decrLimit("O2O");
			
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgO2O(result,model,url, Constant.RECEIVE_FLG,senderSN,date);}});
			log.info("【行外系统[" + url + "]返回的xml报文】\n" + result);
			return result;
		} catch (RuntimeException | IntrospectionException | IllegalAccessException | InvocationTargetException e) {
			String string = url + "[行外系统请求的xml报文]" + jsonMapper.toJson(model) + e.getMessage();
			throw new ConnectErrorException(string, e);
		}
	}

	public static String connectEBank(final Map<String, String> xml, final String code) {
		String url = ebankUrl + code + ebankSuffix;
		if (code.equals("EBOT04") || code.equals("EBOT12") || code.equals("EBOT13") || code.equals("EBAC02")) {
			url = ebankUrl + "mobile/" + code + ebankSuffix;
		}

		try {
			log.info("【请求个人网银系统[" + url + "]的xml报文】:\n" + xml);
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgEBank(xml, code, Constant.SEND_FLG,date);}});

			connectionLimitRedisLock.checkLimit("EBANK");
			final String res = HttpRequest.post(url).form(xml).connectTimeout(100000).body();//HttpClientUtil.getInstance().sendHttpPost(url, xml);
			connectionLimitRedisLock.decrLimit("EBANK");

			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgEBank(res,xml, code, Constant.RECEIVE_FLG,date);}});
			log.info("【请求个人网银[" + url + "]返回数据】:" + res);
			return res;
		} catch (RuntimeException e) {
			String string = e.getMessage() + "\n访问的URl是" + url + "\n [发出的为]" + xml;
			throw new ConnectErrorException(string, e);
		}
	}

	public static String connectPwd(String xml) {
		byte[] res = SocketClient.sendSocket(xml, pwdIp, pwdPort);
		try {
			final String c = new String(res, "GBK");
			final String senderSN=idGenarator.genarateSenderSN();
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgPwd(c,senderSN,  Constant.SEND_FLG,date);}});
			
			final String result=SocketClient.parseXml(c);
			
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgPwd(result,senderSN,  Constant.RECEIVE_FLG,date);}});
			return result;
		} catch (UnsupportedEncodingException e) {
			throw new ConnectErrorException(e);
		}
	}

	public static String connectSMS(final CommunicationNatp natp) {

		try {
			final String senderSN=idGenarator.genarateSenderSN();
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
				sendMsgLog.msgSMS(natp,  Constant.SEND_FLG,senderSN,date);}});
			
			// 5为超时时间
			final String result=natp.exchange_result(smsIp + ":" + smsPort + ":5");
			
			threadPool.execute(new Runnable() {
				private Date date=new Date();
				public void run() {
					sendMsgLog.msgSMS(result,natp,  Constant.SEND_FLG,senderSN,date);}});
			return result;
		} catch (Exception e) {
			throw new RuntimeException("发送短信报文出错 " + smsIp + ":" + smsPort, e);
		}

	}

	private static class SendMsgLog implements Serializable{
		private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
		private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
		private MessageLogService messageLogService;
		private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();
		public SendMsgLog() {
			inputSoapBodyProcessImpl=SpringContextUtils.getBean(InputSoapBodyProcessImpl.class);
			inputSoapHanderProcessImpl=SpringContextUtils.getBean(InputSoapHanderProcessImpl.class);
			String name = "restMessageLogService";
			try {
				messageLogService=(MessageLogService) SpringContextUtils.getBean(name);
			} catch (BeansException e) {
				log.warn("bean "+name+" 不存在，如果是单机模式这个是正常的,集群则有问题了",e);
			}
			if(messageLogService==null){
				messageLogService=SpringContextUtils.getBean(MessageLogService.class);
			}
		}
		public void msgSoap(String sendXml,String reXml,String sendFlg, Date date){
			SoapModel model = inputSoapHanderProcessImpl.packing(sendXml, SoapModel.class);
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setTradecode(model.getTradeCode());
			msgModel.setSenderid(model.getSenderId());
			msgModel.setReceiverid(model.getReceiverId());
			msgModel.setOpertime(date);
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(model.getSenderSN());
			if(sendFlg==Constant.SEND_FLG){
				msgModel.setMessagecontent(sendXml);
			}else{
				msgModel.setMessagecontent(reXml);
			}
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgEBank(Map<String, String> map, String code,String sendFlg, Date date){
			String senderSN=map.get("senderSN");
			String srcChannel=map.get("srcChannel");
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(jsonMapper.toJson(map));
			msgModel.setTradecode(code);
			msgModel.setOpertime(date);
			msgModel.setSenderid(srcChannel);
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgEBank(String result,Map<String, String> map, String code,String sendFlg, Date date){
			String senderSN=map.get("senderSN");
			String srcChannel=map.get("srcChannel");
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(result);
			msgModel.setTradecode(code);
			msgModel.setOpertime(date);
			msgModel.setSenderid(srcChannel);
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgO2O(O2OSendModel model,String url,String sendFlg,String senderSN, Date date){
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(jsonMapper.toJson(model));
			msgModel.setTradecode(model.getMethod());
			msgModel.setOpertime(date);
			msgModel.setSenderid(model.getShopid());
			msgModel.setReceiverid(url);
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgO2O(String xml,O2OSendModel model,String url,String sendFlg,String senderSN, Date date){
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(xml);
			msgModel.setTradecode(model.getMethod());
			msgModel.setOpertime(date);
			msgModel.setSenderid(model.getShopid());
			msgModel.setReceiverid(url);
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgSMS(CommunicationNatp natp,String sendFlg,String senderSN, Date date){
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(natp.getSendLog().toString());
			msgModel.setTradecode(natp.getDataTransfer().getTradeCode());
			msgModel.setOpertime(date);
			msgModel.setReceiverid("SMS");
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgSMS(String result,CommunicationNatp natp,String sendFlg,String senderSN, Date date){
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(result);
			msgModel.setTradecode(natp.getDataTransfer().getTradeCode());
			msgModel.setOpertime(date);
			msgModel.setReceiverid("SMS");
			msgModel.setSendflag(sendFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
		public void msgPwd(String xml,String senderSN,String senderFlg, Date date){
			MessageLogModelExt msgModel=new MessageLogModelExt();
			msgModel.setMessagecontent(xml);
			msgModel.setOpertime(date);
			msgModel.setReceiverid("PWD");
			msgModel.setSendflag(senderFlg);
			msgModel.setSendersn(senderSN);
			messageLogService.insertMessageLog(msgModel);
		}
	}
	public static void main(String[] args) {
		
	}
}
