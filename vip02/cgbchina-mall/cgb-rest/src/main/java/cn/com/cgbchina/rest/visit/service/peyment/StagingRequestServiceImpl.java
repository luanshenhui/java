package cn.com.cgbchina.rest.visit.service.peyment;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQueryResult;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.rest.visit.vo.payment.StagingRequestResultVO;
import cn.com.cgbchina.rest.visit.vo.payment.StagingRequestVO;
import cn.com.cgbchina.rest.visit.vo.payment.WorkOrderQueryResultVO;
import cn.com.cgbchina.rest.visit.vo.payment.WorkOrderQueryVO;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Comment: Created by 11150321050126 on 2016/5/8.
 */
@Service
public class StagingRequestServiceImpl implements StagingRequestService {
	private static final String RETCODE = "0000";
	private static final String receiverId = "BPSN";
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	private IdGenarator idGenarator;

	@Override
	public StagingRequestResult getStagingRequest(StagingRequest req) {
		StagingRequestVO sendVo = BeanUtils.copy(req, StagingRequestVO.class);
		//color截取10个字符
		if(StringUtils.isNotEmpty(sendVo.getColor())&&sendVo.getColor().length()>10){
			sendVo.setColor(sendVo.getColor().substring(0, 9));
		}
		if(StringUtils.isNotEmpty(sendVo.getCustName())&&sendVo.getCustName().length()>30){
			sendVo.setCustName(sendVo.getCustName().substring(0, 29));
		}
		if(StringUtils.isNotEmpty(sendVo.getReceiveName())&&sendVo.getReceiveName().length()>30){
			sendVo.setReceiveName(sendVo.getReceiveName().substring(0, 29));
		}
		SoapModel<StagingRequestVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("BP0005");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		StagingRequestResultVO resultOther = (StagingRequestResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				StagingRequestResultVO.class);
		SoapModel returnModelVO = inputSoapHanderProcessImpl.packing(returnXml, SoapModel.class);
		if (!returnModelVO.getGwErrorCode().equals(RETCODE)) {
			resultOther.setRetCode(returnModelVO.getGwErrorCode());
			resultOther.setRetErrMsg(returnModelVO.getGwErrorMessage());
		}

		ValidateUtil.validateModel(resultOther);
		StagingRequestResult result = BeanUtils.copy(resultOther, StagingRequestResult.class);
		return result;
	}

	@Override
	public WorkOrderQueryResult workOrderQuery(WorkOrderQuery query) {

		WorkOrderQueryVO sendVo = BeanUtils.copy(query, WorkOrderQueryVO.class);
		SoapModel<WorkOrderQueryVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("BP1001");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		WorkOrderQueryResultVO resultOther = (WorkOrderQueryResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				WorkOrderQueryResultVO.class);
		SoapModel returnModelVO = inputSoapHanderProcessImpl.packing(returnXml, SoapModel.class);
		if (!returnModelVO.getGwErrorCode().equals(RETCODE)) {
			resultOther.setRetCode(returnModelVO.getGwErrorCode());
			resultOther.setRetErrMsg(returnModelVO.getGwErrorMessage());
		}
		ValidateUtil.validateModel(resultOther);
		WorkOrderQueryResult result = BeanUtils.copy(resultOther, WorkOrderQueryResult.class);
		return result;
	}

}
