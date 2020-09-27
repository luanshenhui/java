package cn.com.cgbchina.rest.visit.service.peyment;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

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

	@Override
	public StagingRequestResult getStagingRequest(StagingRequest req) {
		StagingRequestVO sendVo = BeanUtils.copy(req, StagingRequestVO.class);

		SoapModel<StagingRequestVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("BP0005");

		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
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
		SoapModel<WorkOrderQueryVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("BP1001");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
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
