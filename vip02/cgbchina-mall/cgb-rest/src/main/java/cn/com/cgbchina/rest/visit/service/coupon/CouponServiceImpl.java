package cn.com.cgbchina.rest.visit.service.coupon;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.util.XMLUtil;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.ReflectUtil;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.visit.model.coupon.*;
import cn.com.cgbchina.rest.visit.vo.coupon.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.List;

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
	@Resource
	private IdGenarator idGenarator;

	@Override
	public QueryCouponInfoResult queryCouponInfo(QueryCouponInfo info) {

		QueryCouponInfoVO sendVo = BeanUtils.copy(info, QueryCouponInfoVO.class);
		SoapModel<QueryCouponInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("MA4000");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);

		QueryCouponInfoResultVO resultOther = (QueryCouponInfoResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				QueryCouponInfoResultVO.class);
		remove(resultOther.getCouponInfos());
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);

		QueryCouponInfoResult result = BeanUtils.copy(resultOther, QueryCouponInfoResult.class);

		for (CouponInfo couponInfo : result.getCouponInfos()) {
			BigDecimal limitMoney = couponInfo.getLimitMoney();
			BigDecimal privilegeMoney = couponInfo.getPrivilegeMoney();
			couponInfo.setLimitMoney(limitMoney.divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
			couponInfo.setPrivilegeMoney(privilegeMoney.divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
		}

		if (resultOther.getReturnCode() != null) {
			result.setRetCode(resultOther.getReturnCode());
		}
		if (resultOther.getReturnDes() != null) {
			result.setRetErrMsg(resultOther.getReturnDes());
		}
		return result;

	}

	@Override
	public QueryCouponProjectResult queryCouponProject(CouponProjectPage page) {
		CouponProjectPageVO sendVo = BeanUtils.copy(page, CouponProjectPageVO.class);
		SoapModel<CouponProjectPageVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("MA4001");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		QueryCouponProjectResultVO resultOther = (QueryCouponProjectResultVO) inputSoapBodyProcessImpl
				.packing(returnXml, QueryCouponProjectResultVO.class);
		remove(resultOther.getCouponProjects());
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
		SoapModel<ActivateCouponVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("MA1000");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		ActivateCouponProjectResutlVO resultOther = (ActivateCouponProjectResutlVO) inputSoapBodyProcessImpl
				.packing(returnXml, ActivateCouponProjectResutlVO.class);
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);
		ActivateCouponProjectResutl result = BeanUtils.copy(resultOther, ActivateCouponProjectResutl.class);
		if (resultOther.getReturnCode() != null) {
			if ("404206".equals(resultOther.getReturnCode())) {
				resultOther.setReturnCode("000001");
			}
			result.setRetCode(resultOther.getReturnCode());
		}
		if (resultOther.getReturnDes() != null) {
			result.setRetErrMsg(resultOther.getReturnDes());
		}
		//金额除以100
		BigDecimal limitMoney = result.getLimitMoney();
		BigDecimal privilegeMoney = result.getPrivilegeMoney();
		result.setLimitMoney(limitMoney.divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
		result.setPrivilegeMoney(privilegeMoney.divide(new BigDecimal(100), 2, BigDecimal.ROUND_HALF_UP));
		return result;
	}

	@Override
	public ProvideCouponResult provideCoupon(ProvideCouponPage page) {
		ProvideCouponPageVO sendVo = BeanUtils.copy(page, ProvideCouponPageVO.class);
		SoapModel<ProvideCouponPageVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("MA1001");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		ProvideCouponResultVO resultOther = (ProvideCouponResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				ProvideCouponResultVO.class);
		List<ProvideCouponResultInfoVO> list = resultOther.getProvideCouponResultInfos();
		remove(list);
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

	private void remove(List<?> list) {
		if (list != null && list.size() > 0) {
			for(int i=list.size()-1;i>=0;i--){
				Object obj = list.get(i);
				if (isDel(obj)) {
					list.remove(obj);
				}else{
					break;
				}
			}
		}
	}

	private <T> Boolean isDel(T object) {
		try {
			Class<?> clazz = object.getClass();
			Field[] fields = ReflectUtil.getFileds(clazz);
			for (Field field : fields) {
				if (field.getModifiers() == java.lang.reflect.Modifier.PRIVATE) {
					field.setAccessible(true);
					Object value = field.get(object);
					if (value != null) {
						if ("java.lang.String".equals(value.getClass().getName())) {
							if (StringUtils.isNotEmpty(value.toString())) {
								return false;
							}
						} else {
							return false;
						}
					}
				}
			}
		} catch (SecurityException | IllegalArgumentException | IllegalAccessException e) {
			throw new RuntimeException(e);
		}

		return true;
	}
}
