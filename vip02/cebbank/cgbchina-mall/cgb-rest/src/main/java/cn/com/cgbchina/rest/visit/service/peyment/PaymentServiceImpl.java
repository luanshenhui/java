package cn.com.cgbchina.rest.visit.service.peyment;

import javax.annotation.Resource;

import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.PropertieUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayInfo;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayResult;
import cn.com.cgbchina.rest.visit.model.payment.DeliverOrderInfoResult;
import cn.com.cgbchina.rest.visit.model.payment.NotifyOrderDelivery;
import cn.com.cgbchina.rest.visit.model.payment.Orderluck;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;
import cn.com.cgbchina.rest.visit.vo.payment.CCPointsPayVO;
import cn.com.cgbchina.rest.visit.vo.payment.ChannelPayInfoVO;
import cn.com.cgbchina.rest.visit.vo.payment.ChannelPayResultVO;
import cn.com.cgbchina.rest.visit.vo.payment.PaymentRequeryInfoVO;
import cn.com.cgbchina.rest.visit.vo.payment.PaymentRequeryResultVO;
import cn.com.cgbchina.rest.visit.vo.payment.PointsMallReqMoneyInfoVO;
import cn.com.cgbchina.rest.visit.vo.payment.PointsMallReturnGoodsInfoVO;
import cn.com.cgbchina.rest.visit.vo.payment.ReqMoneyInfoVO;
import cn.com.cgbchina.rest.visit.vo.payment.ReturnGoodsInfoVO;
import cn.com.cgbchina.rest.visit.vo.payment.ReturnPointsInfoVO;

/**
 * Comment: Created by 11150321050126 on 2016/5/8.
 */
@DependsOn("cn.com.cgbchina.rest.common.utils.PropertieUtils")
@Service
public class PaymentServiceImpl implements PaymentService {
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	private String channel = PropertieUtils.getParam().get("change");

	@Override
	public PaymentRequeryResult paymentRequery(PaymentRequeryInfo info) {
		PaymentRequeryInfoVO sendVo = BeanUtils.copy(info, PaymentRequeryInfoVO.class);
		SoapModel<PaymentRequeryInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT002");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		PaymentRequeryResultVO resultOther = (PaymentRequeryResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				PaymentRequeryResultVO.class);
		PaymentRequeryResult result = BeanUtils.copy(resultOther, PaymentRequeryResult.class);
		return result;
	}

	/**
	 * NSCT003
	 */
	@Override
	@Deprecated
	public DeliverOrderInfoResult orderDeliveryInfoNotify(NotifyOrderDelivery notify) {
		return null;
	}

	/**
	 * NSCT004
	 */
	@Override
	public BaseResult luckPackReturn(Orderluck orderId) {
		Orderluck sendVo = BeanUtils.copy(orderId, Orderluck.class);
		SoapModel<String> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT004");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult ccPointsPay(CCPointsPay pay) {
		CCPointsPayVO sendVo = BeanUtils.copy(pay, CCPointsPayVO.class);
		SoapModel<CCPointsPayVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT016");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult reqMoney(ReqMoneyInfo info) {
		ReqMoneyInfoVO sendVo = BeanUtils.copy(info, ReqMoneyInfoVO.class);
		SoapModel<ReqMoneyInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT007");
		model.setReceiverId("IPBS");
		sendVo.setChannel(channel);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult returnGoods(ReturnGoodsInfo info) {
		ReturnGoodsInfoVO sendVo = BeanUtils.copy(info, ReturnGoodsInfoVO.class);
		SoapModel<ReturnGoodsInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT018");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult returnPoint(ReturnPointsInfo info) {
		ReturnPointsInfoVO sendVo = BeanUtils.copy(info, ReturnPointsInfoVO.class);
		SoapModel<ReturnPointsInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT009");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult pointsMallReqMoney(PointsMallReqMoneyInfo info) {
		PointsMallReqMoneyInfoVO sendVo = BeanUtils.copy(info, PointsMallReqMoneyInfoVO.class);
		sendVo.setChannel(channel);
		SoapModel<PointsMallReqMoneyInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT010");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;

	}

	@Override
	public BaseResult pointsMallReturnGoods(PointsMallReturnGoodsInfo info) {
		PointsMallReturnGoodsInfoVO sendVo = BeanUtils.copy(info, PointsMallReturnGoodsInfoVO.class);
		SoapModel<PointsMallReturnGoodsInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("NSCT012");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public ChannelPayResult channelPay(ChannelPayInfo info) {
		ChannelPayInfoVO sendVo = BeanUtils.copy(info, ChannelPayInfoVO.class);
		SoapModel<ChannelPayInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("MMP011");
		model.setReceiverId("IPBS");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		ChannelPayResultVO resultOther = (ChannelPayResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				ChannelPayResultVO.class);
		ChannelPayResult result = BeanUtils.copy(resultOther, ChannelPayResult.class);
		return result;
	}
}
