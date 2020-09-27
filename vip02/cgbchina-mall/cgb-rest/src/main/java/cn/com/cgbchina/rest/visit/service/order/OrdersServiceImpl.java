package cn.com.cgbchina.rest.visit.service.order;

import java.beans.IntrospectionException;
import java.beans.PropertyDescriptor;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.rest.common.model.O2OModel;
import cn.com.cgbchina.rest.common.model.O2OSendModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.InputXmlProcessImpl;
import cn.com.cgbchina.rest.common.process.O2OReturnStrProcessImpl;
import cn.com.cgbchina.rest.common.process.Obj2SendModelProcessImpl;
import cn.com.cgbchina.rest.common.process.OutPutVisitXMLProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputXMLProcessImpl;
import cn.com.cgbchina.rest.common.process.Str2ObjO2OProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.PICCResult;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.model.order.ValidPICCInfo;
import cn.com.cgbchina.rest.visit.vo.order.O2OResultVO;
import cn.com.cgbchina.rest.visit.vo.order.ResendOrderInfoVO;
import cn.com.cgbchina.rest.visit.vo.order.SendOrderToO2OInfoVO;
import cn.com.cgbchina.user.model.ShopinfOutsystemModel;
import cn.com.cgbchina.user.service.OutSysVendorInfoService;

/**
 * Comment: Created by 11150321050126 on 2016/4/30.
 */
@Slf4j
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
	private OutPutVisitXMLProcessImpl outPutVisitXMLProcessImpl;
	@Resource
	private Obj2SendModelProcessImpl obj2StrO2OProcessImpl;
	@Resource
	private Str2ObjO2OProcessImpl str2ObjO2OProcessImpl;
	@Resource
	private O2OReturnStrProcessImpl o2OReturnStrProcessImpl;
	@Resource
	private OutSysVendorInfoService outSysVendorInfoService;

	@Override
	public BaseResult sendO2OOrderInfo(SendOrderToO2OInfo info) {
		SendOrderToO2OInfoVO sendVo = BeanUtils.copy(info, SendOrderToO2OInfoVO.class);
		sendVo.setSum(sendVo.getO2OOrderInfos().size());
		O2OModel<SendOrderToO2OInfoVO> model = SOAPUtils.createO2OModel(sendVo);
		model.setMsgType(Constant.REQUESTMESSAGE);
		model.setMethod("11");
		model.setShopId(model.getShopId());
		ShopinfOutsystemModel vendor = outSysVendorInfoService.findByVendorId(info.getVendorName());
		ShopinfOutsystemModel mall = outSysVendorInfoService.findMallKey();
		model.setShopId(mall.getOutsystemId());
		O2OSendModel outModel = obj2StrO2OProcessImpl.packing(model, vendor.getKey(), mall.getKey());
		String returnXml = ConnectOtherSys.connectXmlSys(outModel, vendor.getActionUrl());

		O2OSendModel returnModel = requestToBeed(returnXml);

		O2OResultVO resultOther = str2ObjO2OProcessImpl.packing(returnModel, O2OResultVO.class, vendor.getKey(),
				mall.getKey());

		BaseResult result = new BaseResult();
		result.setRetCode(resultOther.getResultCode());
		result.setRetErrMsg(resultOther.getResultMsg());
		return result;
	}

	private O2OSendModel requestToBeed(String generalRequestString) {
		O2OSendModel generalRequest = new O2OSendModel();
		String[] maps = generalRequestString.split("&");
		try {
			for (String map : maps) {
				int index=map.indexOf("=");
				String key=map.substring(0,index);
				String value=map.substring(index+1);
				PropertyDescriptor pd=new PropertyDescriptor(key, O2OSendModel.class);
				Method method = pd.getWriteMethod();
				method.invoke(generalRequest, value);
			}
		} catch (IllegalAccessException | IllegalArgumentException
				| InvocationTargetException | IntrospectionException e) {
			log.error("[o2o转换失败]["+generalRequestString+"]",e);
		}
		return generalRequest;
	}
	
	@Override
	public BaseResult resendOrder(ResendOrderInfo info) {
		ResendOrderInfoVO sendVo = BeanUtils.copy(info, ResendOrderInfoVO.class);
		O2OModel<ResendOrderInfoVO> model = SOAPUtils.createO2OModel(sendVo);
		model.setMsgType(Constant.REQUESTMESSAGE);
		model.setMethod("13");
		ShopinfOutsystemModel vendor = outSysVendorInfoService.findByVendorId(info.getVendorName());
		ShopinfOutsystemModel mall = outSysVendorInfoService.findMallKey();
		model.setShopId(mall.getOutsystemId());
		O2OSendModel outModel = obj2StrO2OProcessImpl.packing(model, vendor.getKey(), mall.getKey());
		String returnXml = ConnectOtherSys.connectXmlSys(outModel, vendor.getActionUrl());
		O2OSendModel returnModel = requestToBeed(returnXml);
		O2OResultVO resultOther = str2ObjO2OProcessImpl.packing(returnModel, O2OResultVO.class, vendor.getKey(),
				mall.getKey());
		BaseResult result = new BaseResult();
		result.setRetCode(resultOther.getResultCode());
		result.setRetErrMsg(resultOther.getResultMsg());
		return result;
	}

	@Override
	@Deprecated
	public PICCResult validSecureCode(ValidPICCInfo info) {
		/*
		 * ValidPICCInfoVO sendVo = BeanUtils.copy(info, ValidPICCInfoVO.class); SoapModel<ValidPICCInfoVO> model =
		 * SOAPUtils.createSOAPModel(sendVo); model.setTradeCode("1"); String outXml =
		 * outputXMLProcessImpl.packing(model, String.class); String returnXml = ConnectOtherSys.connectXmlSys(outXml,
		 * null); PICCResultVO resultOther = (PICCResultVO) inputXmlProcessImpl.packing(returnXml, PICCResultVO.class);
		 * PICCResult result = BeanUtils.copy(resultOther, PICCResult.class);
		 */ return null;
	}

}
