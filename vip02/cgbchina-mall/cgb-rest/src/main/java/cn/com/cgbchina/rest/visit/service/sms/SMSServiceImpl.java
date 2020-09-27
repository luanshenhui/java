package cn.com.cgbchina.rest.visit.service.sms;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.*;
import cn.com.cgbchina.rest.common.util.XMLUtil;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.CommunicationNatp;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSNotifyResult;
import cn.com.cgbchina.rest.visit.vo.sms.BatchSMSResultVo;
import cn.com.cgbchina.rest.visit.vo.sms.BatchSendSMSNotifyVO;
import cn.com.cgbchina.rest.visit.vo.sms.SendSMSInfoVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
@Service
public class SMSServiceImpl implements SMSService {
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSMSProcessImpl<SendSMSInfoVO> outputSMSProcessImpl;
	@Resource
	private IntputSMSProcessImpl intputSMSProcessImpl;
	@Resource
	private IdGenarator idGenarator;

	@Value("#{propertieParam['batchsms.FilePath']}")
	private String smsFilePath;
	@Value("#{propertieParam['batchsms.host']}")
	private String smsHost;
	@Value("#{propertieParam['batchsms.port']}")
	private String smsPort;
	@Value("#{propertieParam['batchsms.taskid']}")
	private String smsTaskId;
	@Value("#{propertieParam['batchsms.ServerPath']}")
	private String smsServerPath;

	private static final String receiverId = "SMSP";
	ExecutorService threadPool=Executors.newCachedThreadPool();
	@Override
	public BaseResult batchSMSNotify(BatchSendSMSNotify notify) {
		log.info("【批量发送短信】sms inteface start,params:{}", notify.toString());
		BatchSendSMSNotifyVO sendVo = BeanUtils.copy(notify, BatchSendSMSNotifyVO.class);
		SoapModel<BatchSendSMSNotifyVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("SMS093");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);

		log.info("【批量发送短信】 result.msg-->{}", outXml);

		String	returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		BatchSMSResultVo resultOther = (BatchSMSResultVo) inputSoapBodyProcessImpl.packing(returnXml,
				BatchSMSResultVo.class);
		XMLUtil.CopyHeaderCode(returnXml, resultOther, inputSoapHanderProcessImpl);
		ValidateUtil.validateModel(resultOther);
		BaseResult result = new BaseResult();
		result.setRetCode(resultOther.getRespcode());
		result.setRetErrMsg(resultOther.getRespmsg());
		return result;
	}

	@Override
	public SendSMSNotifyResult sendSMS(final SendSMSInfo notify) {
		threadPool.execute(new Runnable() {

			@Override
			public void run() {
				SendSMSInfoVO sendVo = BeanUtils.copy(notify, SendSMSInfoVO.class);
				CommunicationNatp natp = outputSMSProcessImpl.packing(sendVo, CommunicationNatp.class);

				// byte[] bytes = outputSMSProcessImpl.packing(sendVo,
				// CommunicationNatp.class);

				String out = ConnectOtherSys.connectSMS(natp);
/*
				SendSMSNotifyResultVO vo = intputSMSProcessImpl.packing(out, SendSMSNotifyResultVO.class);
				vo.setRetCode(vo.getErrorCode());
				vo.setRetErrMsg(vo.getErrorMsg());
				ValidateUtil.validateModel(vo);
				SendSMSNotifyResult result = BeanUtils.copy(vo, SendSMSNotifyResult.class);
				return result;
*/			}
		});
		return new SendSMSNotifyResult(){
			private static final long serialVersionUID = -3412557960082175506L;
		{
			this.setRetCode("0000");
			this.setRetErrMsg("success");
		}};

	}

}
