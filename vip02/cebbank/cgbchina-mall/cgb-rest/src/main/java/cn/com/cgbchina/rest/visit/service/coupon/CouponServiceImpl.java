package cn.com.cgbchina.rest.visit.service.coupon;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.util.XMLUtil;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.ActivateCouponProjectResutl;
import cn.com.cgbchina.rest.visit.model.coupon.CouponProjectPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponPage;
import cn.com.cgbchina.rest.visit.model.coupon.ProvideCouponResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfo;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponInfoResult;
import cn.com.cgbchina.rest.visit.model.coupon.QueryCouponProjectResult;
import cn.com.cgbchina.rest.visit.vo.coupon.ActivateCouponProjectResutlVO;
import cn.com.cgbchina.rest.visit.vo.coupon.ActivateCouponVO;
import cn.com.cgbchina.rest.visit.vo.coupon.CouponProjectPageVO;
import cn.com.cgbchina.rest.visit.vo.coupon.ProvideCouponPageVO;
import cn.com.cgbchina.rest.visit.vo.coupon.ProvideCouponResultVO;
import cn.com.cgbchina.rest.visit.vo.coupon.QueryCouponInfoResultVO;
import cn.com.cgbchina.rest.visit.vo.coupon.QueryCouponInfoVO;
import cn.com.cgbchina.rest.visit.vo.coupon.QueryCouponProjectResultVO;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Service
public class CouponServiceImpl implements CouponService {
	private static final String receiverId = "SWT2";
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;

	@Override
	public QueryCouponInfoResult queryCouponInfo(QueryCouponInfo info) {

		QueryCouponInfoVO sendVo = BeanUtils.copy(info, QueryCouponInfoVO.class);
		SoapModel<QueryCouponInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("MA4000");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);

		QueryCouponInfoResultVO resultOther = (QueryCouponInfoResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				QueryCouponInfoResultVO.class);
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);

		QueryCouponInfoResult result = BeanUtils.copy(resultOther, QueryCouponInfoResult.class);
		return result;

	}

	@Override
	public QueryCouponProjectResult queryCouponProject(CouponProjectPage page) {
		CouponProjectPageVO sendVo = BeanUtils.copy(page, CouponProjectPageVO.class);
		SoapModel<CouponProjectPageVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("MA4001");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		QueryCouponProjectResultVO resultOther = (QueryCouponProjectResultVO) inputSoapBodyProcessImpl.packing(
				returnXml, QueryCouponProjectResultVO.class);
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);
		QueryCouponProjectResult result = BeanUtils.copy(resultOther, QueryCouponProjectResult.class);
		if (resultOther.getReturnCode() != null) {
			result.setRetCode(resultOther.getReturnCode());
		}
		if (resultOther.getReturnDes() != null) {
			result.setRetErrMsg(resultOther.getReturnDes());
		}
		return result;
	}

	@Override
	public ActivateCouponProjectResutl activateCoupon(ActivateCouponInfo info) {
		ActivateCouponVO sendVo = BeanUtils.copy(info, ActivateCouponVO.class);
		SoapModel<ActivateCouponVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("MA1000");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		ActivateCouponProjectResutlVO resultOther = (ActivateCouponProjectResutlVO) inputSoapBodyProcessImpl.packing(
				returnXml, ActivateCouponProjectResutlVO.class);
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);
		ActivateCouponProjectResutl result = BeanUtils.copy(resultOther, ActivateCouponProjectResutl.class);
		if (resultOther.getReturnCode() != null) {
			result.setRetCode(resultOther.getReturnCode());
		}
		if (resultOther.getReturnDes() != null) {
			result.setRetErrMsg(resultOther.getReturnDes());
		}
		return result;
	}

	@Override
	public ProvideCouponResult provideCoupon(ProvideCouponPage page) {
		ProvideCouponPageVO sendVo = BeanUtils.copy(page, ProvideCouponPageVO.class);
		SoapModel<ProvideCouponPageVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("MA1001");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		ProvideCouponResultVO resultOther = (ProvideCouponResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				ProvideCouponResultVO.class);
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);
		ProvideCouponResult result = BeanUtils.copy(resultOther, ProvideCouponResult.class);
		if (resultOther.getReturnCode() != null) {
			result.setRetCode(resultOther.getReturnCode());
		}
		if (resultOther.getReturnDes() != null) {
			result.setRetErrMsg(resultOther.getReturnDes());
		}
		return result;
	}

}
