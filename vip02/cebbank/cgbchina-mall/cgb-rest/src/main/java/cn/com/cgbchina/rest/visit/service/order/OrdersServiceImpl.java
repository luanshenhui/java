package cn.com.cgbchina.rest.visit.service.order;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.InputXmlProcessImpl;
import cn.com.cgbchina.rest.common.process.OutPutVisitXMLProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputXMLProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.PICCResult;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.model.order.ValidPICCInfo;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;
import cn.com.cgbchina.rest.visit.vo.order.PICCResultVO;
import cn.com.cgbchina.rest.visit.vo.order.ResendOrderInfoVO;
import cn.com.cgbchina.rest.visit.vo.order.SendOrderToO2OInfoVO;
import cn.com.cgbchina.rest.visit.vo.order.ValidPICCInfoVO;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class OrdersServiceImpl implements OrderService {
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	private InputXmlProcessImpl inputXmlProcessImpl;
	@Resource
	private OutputXMLProcessImpl outputXMLProcessImpl;
	@Resource 
	private OutPutVisitXMLProcessImpl  outPutVisitXMLProcessImpl;
	@Value("${shop.bigOrderNo}")
	private String bigOrderNo;

	@Override
	public BaseResult sendO2OOrderInfo(SendOrderToO2OInfo info) {
		SendOrderToO2OInfoVO sendVo = BeanUtils.copy(info, SendOrderToO2OInfoVO.class);
		sendVo.setSum(sendVo.getO2OOrderInfos().size());
		sendVo.setOrderno(bigOrderNo);
		SoapModel<SendOrderToO2OInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("11");
		String outXml = outputXMLProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectXmlSys(outXml, info.getVendorName());
		BaseResultVo resultOther = (BaseResultVo) inputXmlProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult resendOrder(ResendOrderInfo info) {
		ResendOrderInfoVO sendVo = BeanUtils.copy(info, ResendOrderInfoVO.class);
		SoapModel<ResendOrderInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("13");
		
		String outXml = outPutVisitXMLProcessImpl.packing(model.getContent(), String.class);
		String returnXml = ConnectOtherSys.connectXmlSys(outXml, info.getVendorName());
		BaseResultVo resultOther = (BaseResultVo) inputXmlProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	@Deprecated
	public PICCResult validSecureCode(ValidPICCInfo info) {
		ValidPICCInfoVO sendVo = BeanUtils.copy(info, ValidPICCInfoVO.class);
		SoapModel<ValidPICCInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("1");
		String outXml = outputXMLProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectXmlSys(outXml, null);
		PICCResultVO resultOther = (PICCResultVO) inputXmlProcessImpl.packing(returnXml, PICCResultVO.class);
		PICCResult result = BeanUtils.copy(resultOther, PICCResult.class);
		return result;
	}

}
