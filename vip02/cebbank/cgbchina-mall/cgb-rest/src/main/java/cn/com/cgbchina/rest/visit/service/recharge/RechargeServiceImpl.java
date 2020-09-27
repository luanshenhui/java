package cn.com.cgbchina.rest.visit.service.recharge;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.recharge.MobileRechargeInfo;
import cn.com.cgbchina.rest.visit.vo.BaseResultVo;
import cn.com.cgbchina.rest.visit.vo.recharge.MobileRechargeInfoVO;
@Service
public class RechargeServiceImpl implements RechargeService  {
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;

	@Override
	public BaseResult rechargeCMCC(MobileRechargeInfo info) {
		MobileRechargeInfoVO sendVo = BeanUtils.copy(info, MobileRechargeInfoVO.class);
		SoapModel<MobileRechargeInfoVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("A_QUANDDEP");
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
		BaseResultVo resultOther = (BaseResultVo) inputSoapBodyProcessImpl.packing(returnXml,BaseResultVo.class);
		BaseResult result = BeanUtils.copy(resultOther, BaseResult.class);
		return result;
	}

}
