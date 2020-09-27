package com.test;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.apache.commons.io.FileUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.com.cgbchina.rest.common.exception.ConverErrorException;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.InputXmlProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputXMLProcessImpl;
import cn.com.cgbchina.rest.common.utils.ScanTradeCode;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.service.XMLProvideService;
import cn.com.cgbchina.rest.provider.vo.order.MsgQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.SendCodeInfoVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationNoticVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
@Slf4j
public class TestClass {

	@Resource
	InputSoapHanderProcessImpl inputSoapHanderProcess;
	@Resource
	InputXmlProcessImpl inputXmlProcessImpl;
	@Resource
	InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	OutputXMLProcessImpl outputXMLProcessImpl;

	@Test
	public void test2() throws IOException {
		String responseStr = null;
		String xml = FileUtils.readFileToString(new File("D:/zx/tmp/xml.xml"));
		String method = "21";// 获取交易码
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

		Object responseModel = object.process(model);// 执行 业务的service
		if (responseModel == null) {
			throw new NullPointerException("返回的数据不可以为空");
		}
		responseStr = null;
		try {
			responseStr = outputXMLProcessImpl.packing(responseModel, String.class);
			log.info(responseStr);

		} catch (ConverErrorException e) {
			log.error(e.getMessage(), e);
		} catch (Exception e) {
			e.printStackTrace();
		}

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
			switch (method) {
			case "21":
				model = new SendCodeInfoVO();
				break;
			case "22":
				model = new MsgQueryVO();
				break;
			case "23":
				model = new VerificationNoticVO();
				break;
			default:
				break;
			}
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return model;
	}

	public void test() {
		String xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:gateway=\"http://www.agree.com.cn/GDBGateway\">  <soapenv:Header>    <gateway:HeadType>      <gateway:versionNo>1</gateway:versionNo>       <gateway:toEncrypt>0</gateway:toEncrypt>       <gateway:commCode>500001</gateway:commCode>       <gateway:commType>0</gateway:commType>       <gateway:receiverId>BPSN</gateway:receiverId>       <gateway:senderId>MALL</gateway:senderId>       <gateway:senderSN>2016032211050284229831</gateway:senderSN>       <gateway:senderDate>20160322</gateway:senderDate>       <gateway:senderTime>110502</gateway:senderTime>       <gateway:tradeCode>BP1001</gateway:tradeCode>        <gateway:gwErrorCode/>       <gateway:gwErrorMessage/>    </gateway:HeadType>  </soapenv:Header>  <soapenv:Body>    <gateway:NoAS400>      <gateway:field name=\"CASEID\"/>       <gateway:field name=\"SRCCASEID\">201603160937013402</gateway:field>       <gateway:field name=\"CHANNEL\">070</gateway:field>    </gateway:NoAS400>  </soapenv:Body></soapenv:Envelope>";
		log.debug("【接受到的xml报文】:\n" + xml);
		SoapModel model = null;
		try {
			model = inputSoapHanderProcess.packing(xml, SoapModel.class);
		} catch (Exception e) {
			log.error("【解析soap报文】" + e.getMessage(), e);
		}
		SoapProvideService object = null;

		try {
			model.setTradeCode("MAL108");
			object = (SoapProvideService) ScanTradeCode.getBean(model.getTradeCode());
		} catch (Exception ex) {
			throw new RuntimeException(ex);
		}
		if (object == null) {
			throw new RuntimeException("找不到交易类");
		}
		Class clazz = null;
		if (SoapProvideService.class.isAssignableFrom(object.getClass())) {
			Type[] interfaces = object.getClass().getGenericInterfaces();
			for (Type inface : interfaces) {
				if (SoapProvideService.class == ((ParameterizedType) inface).getRawType()) {
					clazz = (Class) ((ParameterizedType) inface).getActualTypeArguments()[0];
					break;
				}
			}
		} else {
			throw new RuntimeException(object.getClass().getName() + " 没有继承 " + SoapProvideService.class.getName());
		}

		try {

			model.setContent(inputSoapBodyProcessImpl.packing(xml, clazz));
		} catch (ConverErrorException e) {
			log.error(e.getMessage(), e);
		}
		Object content = object.process(model, model.getContent());
		SoapModel responseModel = new SoapModel<>();
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
		responseModel.setContent(content);

		String responseStr = null;
		try {
			responseStr = outputSoapProcessImpl.packing(responseModel, String.class);
		} catch (ConverErrorException e) {
			log.error(e.getMessage(), e);
		}
		log.info("返回xml报文" + responseStr);
		log.info("ok");
		// System.out.println(responseStr);
	}

}
