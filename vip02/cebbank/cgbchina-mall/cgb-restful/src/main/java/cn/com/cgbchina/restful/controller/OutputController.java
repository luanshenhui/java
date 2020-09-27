package cn.com.cgbchina.restful.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.InputXmlProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputXMLProcessImpl;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ScanTradeCode;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.vo.order.MsgQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticVO;
import lombok.extern.slf4j.Slf4j;

/**
 * Comment: Created by 11150321050126 on 2016/4/18. 处理http请求接口
 */
@Controller
@Slf4j
public class OutputController {

	@Resource
	OutputXMLProcessImpl outputXMLProcessImpl;
	@Resource
	InputXmlProcessImpl inputXmlProcessImpl;
	@Resource
	InputSoapHanderProcessImpl inputSoapHanderProcess;
	@Resource
	InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	OutputSoapProcessImpl outputSoapProcessImpl;

	/**
	 * 处理soap报文
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/GatewayReceiveServlet", method = RequestMethod.POST)
	@ResponseBody
	public String gatewayReceiveServlet2(HttpServletRequest request) {
		String responseStr = null;
		String xml = null;
		try {
			// 获取报文
			xml = getXml(request);
			log.info("【接受到的xml报文】:\n" + xml);
			SoapModel model = null;
			try {
				// 包装soap头部数据
				model = inputSoapHanderProcess.packing(xml, SoapModel.class);
			} catch (Exception e) {
				throw new ConverErrorException("【解析soap头报文异常】", e);
			}
			// 获取处理该请求的服务
			SoapProvideService object = (SoapProvideService) ScanTradeCode.getBean(model.getTradeCode());
			if (object == null) {
				throw new RuntimeException("找不到交易类");
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
				throw new RuntimeException(object.getClass().getName() + " 没有继承 " + SoapProvideService.class.getName());
			}

			try {
				// 将XMl转换为VO设置到content
				model.setContent(inputSoapBodyProcessImpl.packing(xml, clazz));
			} catch (ConverErrorException e) {
				throw new ConverErrorException("【解析soap体报文异常】", e);
			}
			// 校验数据正确性
			ValidateUtil.validateModel(model);
			// 执行处理服务
			Object content = object.process(model, model.getContent());
			// 包装返回的报文头
			SoapModel responseModel = new SoapModel();
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
				responseStr = outputSoapProcessImpl.packing(responseModel, String.class);
				log.debug("【发出的xml报文】:\n" + responseStr);
			} catch (ConverErrorException e) {
				throw new ConverErrorException("【包装soap报文异常】", e);
			}
		} catch (IOException e) {
			log.error("【异常报文】" + xml);
		}
		return responseStr;
	}

	/**
	 * 处理行外系统的请求
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/OutSystemBackServlet")
	@ResponseBody
	public String gatewayReceiveXMLServlet(HttpServletRequest request) {
		String responseStr = null;
		String xml = request.getParameter("message");
		String method = request.getParameter("method");// 获取交易码
		// 临时处理 如果联通性测试 直接返回map中的XML字符串

		log.debug("【接受到的xml报文】:\n" + xml);
		Object model = null;
		model = getObjectByMethod(method, model);// 通过方法名返回实例
		try {
			model = inputXmlProcessImpl.packing(xml, model.getClass());
			// 将xml打包成Vo类
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		XMLProvideService object = (XMLProvideService) ScanTradeCode.getBean(method);
		// 通过交易码找到将xml打包成vo、同时执行对就的service类 然后 返回的值要打包成一个新的Vo 的方法
		if (object == null) {
			throw new RuntimeException("找不到交易类");
		}
		Class clazz = null;
		if (XMLProvideService.class.isAssignableFrom(object.getClass())) {
			Type[] interfaces = object.getClass().getGenericInterfaces();
			for (Type inface : interfaces) {
				if (XMLProvideService.class == ((ParameterizedType) inface).getRawType()) {
					clazz = (Class) ((ParameterizedType) inface).getActualTypeArguments()[0];
					break;
				}
			}
		} else {
			throw new RuntimeException(object.getClass().getName() + " 没有继承 " + XMLProvideService.class.getName());
		}
		/*
		 * try { inputSoapBodyProcessImpl.packing(xml, clazz); } catch (ConverErrorException e) {
		 * log.error(e.getMessage(), e); }
		 */
		ValidateUtil.validateModel(model);

		Object responseModel = object.process(model);// 执行 业务的service
		if (responseModel == null) {
			throw new NullPointerException("返回的数据不可以为空");
		}
		responseStr = null;
		try {
			responseStr = outputXMLProcessImpl.packing(responseModel, String.class);
			log.debug("【发出的xml报文】:\n" + responseStr);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return responseStr;
	}

	/**
	 * 通过方法名返回实例
	 * 
	 * @param method
	 * @param model
	 * @return
	 */
	private Object getObjectByMethod(String method, Object model) {
		try {

			if (method.equals("21")) {
				model = new SendCodeInfoVO();
			} else if (method.equals("22")) {
				model = new VerificationNoticVO();
			} else if (method.equals("23")) {
				model = new MsgQueryVO();
			}

		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return model;
	}

	@Deprecated
	public String gatewayReceiveServlet(HttpServletRequest request) {
		String responseStr = null;
		try {
			String xml = getXml(request);
			log.debug("【接受到的xml报文】:\n" + xml);
			SoapModel model = null;
			try {
				model = SOAPUtils.parseXml(xml, "GBK");
			} catch (ConverErrorException e) {
				log.error(e.getMessage(), e);
			}
			SoapProvideService object = (SoapProvideService) ScanTradeCode.getBean(model.getTradeCode());
			if (object == null) {
				throw new NoClassDefFoundError("没有对应的TradeCode");
			}
			SoapModel responseModel = null;// object.process(model,
											// model.getContent());
			if (responseModel == null) {
				throw new NullPointerException("返回的数据不可以为空");
			}
			responseStr = null;
			try {
				responseStr = SOAPUtils.entityToSoap(responseModel);
			} catch (ConverErrorException e) {
				log.error(e.getMessage(), e);
			}
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}
		return responseStr;
	}

	private String getXml(HttpServletRequest request) throws IOException {
		InputStream is = request.getInputStream();
		InputStreamReader isr = new InputStreamReader(is);
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
}
