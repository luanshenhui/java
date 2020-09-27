package cn.com.cgbchina.restful.controller;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.log.model.MessageLogModel;
import cn.com.cgbchina.log.model.MessageLogModelExt;
import cn.com.cgbchina.log.service.MessageLogService;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.O2OModel;
import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.*;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ScanTradeCode;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.vo.BaseO2OEntityVO;
import cn.com.cgbchina.user.model.ShopinfOutsystemModel;
import cn.com.cgbchina.user.service.OutSysVendorInfoService;
import com.spirit.util.JsonMapper;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Date;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;

/**
 * @author lvdaokun
 *
 */
@Slf4j
public abstract class BaseOutputContrller {
	@Resource
	OutputXMLProcessImpl outputXMLProcessImpl;
	@Resource
	InputSoapHanderProcessImpl inputSoapHanderProcess;
	@Resource
	InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	Str2ObjO2OProcessImpl str2ObjO2OProcessImpl;
	@Resource
	Obj2SendModelProcessImpl obj2StrO2OProcessImpl;
	@Resource
	OutSysVendorInfoService outSysVendorInfoService;
	@Resource
	private MessageLogService messageLogService;
	private ExecutorService threadPool=Executors.newFixedThreadPool(Constant.THREAD_NUM);
	private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();
	@Resource
	private IdGenarator idGenarator;
	/**
	 * O2O或行外系统的
	 * @param o2oSendModel
	 * @return
	 */
	protected String outSystemRealProcess(O2OSendModel o2oSendModel) {
		String senderSn=idGenarator.genarateSenderSN();
		String senderPack="["+senderSn+"]";
		log.info(senderPack+"【接受到的o2o报文】:\n" +jsonMapper.toJson(o2oSendModel) );
		//--------------包装日志记录表数据
		MessageLogModelExt sendMsg=new MessageLogModelExt();
		sendMsg.setMessagecontent(jsonMapper.toJson(o2oSendModel));
		sendMsg.setSenderid(o2oSendModel.getShopid());
		sendMsg.setTradecode(o2oSendModel.getMethod());
		sendMsg.setOpertime(new Date());
		sendMsg.setSendflag(Constant.RECEIVE_FLG);
		sendMsg.setSendersn(senderSn);
		
		//--------------返回对象
		BaseO2OEntityVO resultObj=new BaseO2OEntityVO();;
		O2OModel<BaseO2OEntityVO> model = SOAPUtils.createO2OModel(resultObj);
		
		//--------------查找处理流程的业务模块
		String method = o2oSendModel.getMethod();
		XMLProvideService<Object,?> service = (XMLProvideService) ScanTradeCode.getBean(method);
		if (service == null) {
			String msg = senderPack+"[o2o请求找不到交易类]";
			log.error(msg,new RuntimeException(msg));
			return msg;
		}
		Class<?> clazz = null;
		if (XMLProvideService.class.isAssignableFrom(service.getClass())) {
			Type[] interfaces = service.getClass().getGenericInterfaces();
			for (Type inface : interfaces) {
				if (XMLProvideService.class == ((ParameterizedType) inface).getRawType()) {
					clazz = (Class<?>) ((ParameterizedType) inface).getActualTypeArguments()[0];
					break;
				}
			}
		} else {
			String string = senderPack+service.getClass().getName() + " 没有继承 " + XMLProvideService.class.getName();
			log.error(string,new RuntimeException(string));
			return string;
		}

		//------------读取key
		ShopinfOutsystemModel vendor;
		ShopinfOutsystemModel mall;
		model.setMsgType(Constant.REQUESTMESSAGE);
		model.setMethod(method);
		model.setShopId(o2oSendModel.getShopid());
		try {
			vendor = outSysVendorInfoService.findByOutSysId(o2oSendModel.getShopid());
			mall = outSysVendorInfoService.findMallKey();
		} catch (Exception e) {
			String string = senderPack+"[获取供应商key或商城key失败]";
			log.error(string+e.getMessage(),e);
			return string;
		}
		
		//--------------发送记录日志
		sendMsg.setReceiverid(mall.getShopId());
		threadPool.execute(new SendMessageLog(sendMsg));
		String result=null;
		
		
		//--------------读取报文，处理业务，包装报文
		Object obj;
		try {
			obj = str2ObjO2OProcessImpl.packing(o2oSendModel, clazz, vendor.getKey(), mall.getKey());
			if(obj==null){
				throw new RuntimeException("[解密失败]");
			}
			log.info(senderPack+"[o2o请求，解密后内容]"+jsonMapper.toJson(obj));
			resultObj = (BaseO2OEntityVO) service.process(obj);
		} catch (Exception e) {
			String string = senderPack+"[o2o业务处理异常]";
			log.error(string+e.getMessage(),e);
			resultObj.setReturnCode("false");
			resultObj.setReturnDes(string);
		}
		model.setMessage(resultObj);
		log.info(senderPack+"[加密前的内容]:"+jsonMapper.toJson(model));
		O2OSendModel sendModel = obj2StrO2OProcessImpl.packing(model, vendor.getKey(), mall.getKey());
		
		
		//------------打印日志到db里
		result=packO2OSendModel(sendModel);
		log.info(senderPack+"[o2o返回内容]"+result);
		MessageLogModelExt receiveMsg=new MessageLogModelExt();
		receiveMsg.setMessagecontent(result);
		receiveMsg.setTradecode(sendModel.getMethod());
		receiveMsg.setSenderid(o2oSendModel.getShopid());
		receiveMsg.setReceiverid(mall.getShopId());
		receiveMsg.setOpertime(new Date());
		receiveMsg.setSendflag(Constant.RECEIVE_FLG);
		receiveMsg.setSendersn(senderSn);
		threadPool.execute(new SendMessageLog(receiveMsg));
		return result;
	}
	
	/**
	 * 把o2o对象转成string
	 * @param sendModel
	 * @return
	 */
	private String packO2OSendModel(O2OSendModel sendModel){
		StringBuilder sb=new StringBuilder();
		sb.append("msgtype=").append(sendModel.getMsgtype());
		sb.append("&format=").append(sendModel.getFormat());
		sb.append("&version=").append(sendModel.getVersion());
		sb.append("&shopid=").append(sendModel.getShopid());
		sb.append("&timestamp=").append(sendModel.getTimestamp());
		sb.append("&sign=").append(sendModel.getSign());
		sb.append("&method=").append(sendModel.getMethod());
		sb.append("&message=").append(sendModel.getMessage());
		return sb.toString();
	}
	
	/**
	 * 获取o2o传入对象
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public O2OSendModel getO2OModel(HttpServletRequest request) throws IOException{
		String character = getCharacter(request);
		String bodyStr=this.getStream(request, character);
		String contentType=request.getContentType();
		Map<String,String[]> bodyMap=request.getParameterMap();
		if(!bodyMap.isEmpty()){
			bodyStr = map2Str(bodyMap);
		}
		String[] strs = bodyStr.split("&");
		O2OSendModel o2oSendModel=new O2OSendModel();
		for(String str:strs){
			try {
				int index=str.indexOf("=");
				String key=str.substring(0,index);
				String value=str.substring(index+1);
				PropertyDescriptor pd=new PropertyDescriptor(key, o2oSendModel.getClass());
				Method method = pd.getWriteMethod();
				method.invoke(o2oSendModel, value);
				
			} catch (IllegalAccessException | IllegalArgumentException
					| InvocationTargetException | IntrospectionException e) {
				log.error(e.getMessage(),e);
			}
		}
		return o2oSendModel;
	}
	
	/**
	 * 用来将map转成url
	 * @param bodyMap
	 * @return
	 */
	private String map2Str(Map<String,String[]> bodyMap){
		StringBuffer sb=new StringBuffer();
		Set<Entry<String, String[]>> set = bodyMap.entrySet();
		for(Entry<String, String[]> entry:set){
			for(String str:entry.getValue()){
				sb.append(entry.getKey()).append("=").append(str).append("&");
			}
		}
		String bodyStr = sb.length()>0?sb.substring(0,sb.length()-1):sb.toString();
		return bodyStr;
	}
	/**
	 * 
	 * Description : Get character , default is UTF-8
	 * 
	 * @return
	 */
	private String getCharacter(HttpServletRequest request) {
		String character = "UTF-8";
		String contentType = request.getContentType();
		if (StringUtils.isNotEmpty(contentType)) {
			String strs[] = contentType.split(";");
			for (String s : strs) {
				int local = s.indexOf("charset=");
				if (local > -1) {
					String split[] = s.split("=");
					character = split[1].trim();
					break;
				}
			}
		}
		return character;
	}
	/**
	 * 
	 * Description : Get request stream
	 * 
	 * @param request
	 * @param character
	 * @return
	 * @throws IOException
	 */
	private String getStream(HttpServletRequest request, String character) throws IOException{
		InputStream is = request.getInputStream();
		InputStreamReader isr = new InputStreamReader(is, character);
		StringBuffer sb = new StringBuffer();
		char chars[] = new char[1024];
		int k = 0;
		while ((k = isr.read(chars)) != -1) {
			sb.append(chars, 0, k);
		}
		isr.close();
		is.close();
		return sb.toString();
	}
	public String getXml(HttpServletRequest request) throws IOException {
		return getStream(request, Constant.CHARSET_GBK);
	}
	/**
	 * 处理商城MAL接口的
	 * @param result
	 * @return
	 */
	protected String malRealProcess(String result) {
		String responseStr = null;
		String xml = null;
		xml = result;
		log.info("【接受到的xml报文】:\n" + xml);
		SoapModel<Object> model = null;
		try {
			model = inputSoapHanderProcess.packing(xml, SoapModel.class,"UTF-8");
		} catch (Exception e) {
			throw new ConverErrorException("【解析soap头报文异常】", e);
		}
		//----------------包装保存到db的日志对象
		MessageLogModelExt sendMsg=new MessageLogModelExt();
		sendMsg.setMessagecontent(result);
		sendMsg.setSenderid(model.getSenderId());
		sendMsg.setTradecode(model.getTradeCode());
		sendMsg.setOpertime(new Date());
		sendMsg.setSendflag(Constant.SEND_FLG);
		sendMsg.setSendersn(model.getSenderSN());
		sendMsg.setReceiverid(model.getReceiverId());
		threadPool.execute(new SendMessageLog(sendMsg));
		String senderSN=model.getSenderSN();
		String senderPack="["+senderSN+"]";
		
		//-----------------获取对应的处理模块单元
		// 获取处理该请求的服务
		SoapProvideService object = (SoapProvideService) ScanTradeCode.getBean(model.getTradeCode());
		if (object == null) {
			throw new RuntimeException(senderPack+"找不到交易类");
		}
		Class clazz = null;
		// 判断object是否实现SoapProvideService父类
		if (SoapProvideService.class.isAssignableFrom(object.getClass())) {
			Type[] interfaces = object.getClass().getGenericInterfaces();
			for (Type inface : interfaces) {
				// 判断是实现SoapProvideService的接口
				if (SoapProvideService.class == ((ParameterizedType) inface).getRawType()) {
					// 获取第一个参数的泛型的实际类型
					clazz = (Class) ((ParameterizedType) inface).getActualTypeArguments()[0];
					break;
				}
			}
		} else {
			throw new RuntimeException(senderPack+object.getClass().getName() + " 没有继承 " + SoapProvideService.class.getName());
		}

		try {
			model.setContent(inputSoapBodyProcessImpl.packing(xml, clazz,"UTF-8"));
		} catch (ConverErrorException e) {
			throw new ConverErrorException(senderPack+"【解析soap体报文异常】", e);
		}
		
		//--------------处理及包装返回对象
		ValidateUtil.validateModel(model);
		// 执行处理服务
		Object content = object.process(model, model.getContent());
		// 包装返回的报文头
		SoapModel<Object> responseModel = new SoapModel<>();
		responseModel.setCommCode(model.getCommCode());
		responseModel.setCommType(model.getCommType());
		responseModel.setGwErrorCode(model.getGwErrorCode());
		responseModel.setGwErrorMessage(model.getGwErrorMessage());
		responseModel.setReceiverId(model.getReceiverId());
		responseModel.setSenderSN(model.getSenderSN());
		responseModel.setSenderTime(model.getSenderTime());
		responseModel.setToEncrypt(model.getToEncrypt());
		responseModel.setTradeCode(model.getTradeCode());
		responseModel.setVersionNo(model.getVersionNo());
		responseModel.setSenderDate(model.getSenderDate());
		responseModel.setSenderId(model.getSenderId());
		responseModel.setContent(content);
		
		responseStr = null;
		try {
			// 包装返回的soap体
			responseStr = outputSoapProcessImpl.packing(responseModel,
					String.class);
			log.info("【发出的xml报文】:\n" + responseStr);
			
			//--------包装日志对象
			MessageLogModelExt receiveMsg = new MessageLogModelExt();
			receiveMsg.setMessagecontent(responseStr);
			receiveMsg.setSenderid(model.getSenderId());
			receiveMsg.setTradecode(model.getTradeCode());
			receiveMsg.setOpertime(new Date());
			receiveMsg.setSendflag(Constant.RECEIVE_FLG);
			receiveMsg.setSendersn(model.getSenderSN());
			receiveMsg.setReceiverid(model.getReceiverId());
			threadPool.execute(new SendMessageLog(receiveMsg));

			return responseStr;
		} catch (ConverErrorException e) {
			throw new ConverErrorException("【包装soap报文异常】", e);
		}
	}
	
	
	
	class SendMessageLog implements Serializable , Runnable{
		private static final long serialVersionUID = -3815555074600828954L;
		@Setter
		private MessageLogModel model;
		public SendMessageLog(MessageLogModel model) {
			this.model=model;
		}
		@Override
		public void run() {
			messageLogService.insertMessageLog(model);
		}
	}
}
