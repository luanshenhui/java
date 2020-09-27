package cn.com.cgbchina.rest.visit.service.peyment;

import cn.com.cgbchina.common.utils.ValidateUtil;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.PropertieUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.*;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;
import cn.com.cgbchina.rest.visit.vo.payment.*;
import cn.com.cgbchina.rest.visit.vo.point.CCPointResultVo;
import com.google.common.base.Strings;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Comment: Created by 11150321050126 on 2016/5/8.
 */
@DependsOn("cn.com.cgbchina.rest.common.utils.PropertieUtils")
@Service
@Slf4j
public class PaymentServiceImpl implements PaymentService {
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	private String channel = PropertieUtils.getParam().get("channel");
	@Resource
	private IdGenarator idGenarator;
	private static final String receiverId ="IPBS";

	@Override
	public PaymentRequeryResult paymentRequery(PaymentRequeryInfo info) {
		PaymentRequeryInfoVO sendVo = BeanUtils.copy(info, PaymentRequeryInfoVO.class);
		SoapModel<PaymentRequeryInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT002");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
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
		SoapModel<String> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT004");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public CCPointResult ccPointsPay(CCPointsPay pay) {
		CCPointsPayVO sendVo = BeanUtils.copy(pay, CCPointsPayVO.class);
		SoapModel<CCPointsPayVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT016");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		CCPointResultVo resultOther = (CCPointResultVo) inputSoapBodyProcessImpl.packing(returnXml, CCPointResultVo.class);
		CCPointResult result = BeanUtils.copy(resultOther, CCPointResult.class);
		return result;
	}

	@Override
	public BaseResult reqMoney(ReqMoneyInfo info) {
		//Fixed by ldk bug-305912
		//没有活动时不要传费用承担方
		//if (info != null && Strings.isNullOrEmpty(info.getBalancePayer())) {
		//	info.setBalancePayer("01");
		//}
		ReqMoneyInfoVO sendVo = BeanUtils.copy(info, ReqMoneyInfoVO.class);
		SoapModel<ReqMoneyInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT007");
		model.setReceiverId(receiverId);
		sendVo.setChannel(channel);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public BaseResult returnGoods(ReturnGoodsInfo info) {
		log.info("returnGoods的请求报文：" + info);
		if (info != null && Strings.isNullOrEmpty(info.getPayee())) {
			info.setPayee("02");
		}
		ReturnGoodsInfoVO sendVo = BeanUtils.copy(info, ReturnGoodsInfoVO.class);
		SoapModel<ReturnGoodsInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT018");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		log.info("returnGoods的返回报文：" + result);
		return result;
	}

	@Override
	public BaseResult returnPoint(ReturnPointsInfo info) {
		BaseResult result = new BaseResult();
		try {
			ValidateUtil.validateModel(info);
		ReturnPointsInfoVO sendVo = BeanUtils.copy(info, ReturnPointsInfoVO.class);
		SoapModel<ReturnPointsInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT009");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
			result = BeanUtils.copy(resultOther, BaseResult.class);
		} catch (RuntimeException ex) {
			throw new RuntimeException(ex);
		}
		return result;
	}

	@Override
	public BaseResult pointsMallReqMoney(PointsMallReqMoneyInfo info) {
		PointsMallReqMoneyInfoVO sendVo = BeanUtils.copy(info, PointsMallReqMoneyInfoVO.class);
		sendVo.setChannel(channel);
		SoapModel<PointsMallReqMoneyInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("NSCT010");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;

	}

	@Override
	public BaseResult pointsMallReturnGoods(PointsMallReturnGoodsInfo info) {
		if (info != null && Strings.isNullOrEmpty(info.getPayee())) {
			info.setPayee("02");
		}
		PointsMallReturnGoodsInfoVO sendVo = BeanUtils.copy(info, PointsMallReturnGoodsInfoVO.class);
		SoapModel<PointsMallReturnGoodsInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(),
				sendVo);
		model.setTradeCode("NSCT012");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml, BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

	@Override
	public ChannelPayResult channelPay(ChannelPayInfo info) {
		ChannelPayInfoVO sendVo = BeanUtils.copy(info, ChannelPayInfoVO.class);
		SoapModel<ChannelPayInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("MMP011");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		ChannelPayResultVO resultOther = (ChannelPayResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				ChannelPayResultVO.class);
		ChannelPayResult result = BeanUtils.copy(resultOther, ChannelPayResult.class);
		return result;
	}
}
