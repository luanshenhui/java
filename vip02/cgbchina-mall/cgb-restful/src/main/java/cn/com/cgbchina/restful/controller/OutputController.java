package cn.com.cgbchina.restful.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.com.cgbchina.rest.common.model.O2OSendModel;

/**
 * Comment: Created by 11150321050126 on 2016/4/18. 处理http请求接口
 */
@Controller
@Slf4j
public class OutputController extends BaseOutputContrller {

	/**
	 * 处理soap报文
	 *
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/GatewayReceiveServlet", method = RequestMethod.POST, produces = "text/plain;charset=GBK")
	@ResponseBody
	public String gatewayReceiveServlet2(HttpServletRequest request) {
		String responseStr = null;
		String xml = null;
		try {
			// 获取报文
			xml = super.getXml(request);
			log.info("【接受到的xml报文】:\n" + xml);
			responseStr = malRealProcess(xml);
			log.info("【响应的xml报文】:\n" + responseStr);
		} catch (IOException e) {
			log.error("【异常报文】" + xml, e);
		}
		return responseStr;
	}

	/**
	 * 处理行外系统的请求
	 *
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/OutSystemBackServlet", method = RequestMethod.POST,  produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String outSystemRealProcess(HttpServletRequest request) {
		O2OSendModel o2oSendModel;
		String result=null;
		try {
			o2oSendModel = super.getO2OModel(request);
			result=super.outSystemRealProcess(o2oSendModel);
		} catch (IOException e) {
			log.error("【异常报文】" , e);
		}
		return result;
	}
	
}
