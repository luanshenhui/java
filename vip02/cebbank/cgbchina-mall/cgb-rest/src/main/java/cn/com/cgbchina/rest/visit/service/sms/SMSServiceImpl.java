package cn.com.cgbchina.rest.visit.service.sms;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import cn.com.cgbchina.common.utils.FTSUtil;
import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.IntputSMSProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSMSProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.util.XMLUtil;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.CommunicationNatp;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.common.utils.ValidateUtil;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotify;
import cn.com.cgbchina.rest.visit.model.sms.BatchSendSMSNotifyInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSNotifyResult;
import cn.com.cgbchina.rest.visit.vo.sms.BatchSMSResultVo;
import cn.com.cgbchina.rest.visit.vo.sms.BatchSendSMSNotifyVO;
import cn.com.cgbchina.rest.visit.vo.sms.SendSMSInfoVO;
import cn.com.cgbchina.rest.visit.vo.sms.SendSMSNotifyResultVO;
import lombok.extern.slf4j.Slf4j;

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

	@Value("#{app['batchsms.FilePath']}")
	private String smsFilePath;
	@Value("#{app['batchsms.host']}")
	private String smsHost;
	@Value("#{app['batchsms.port']}")
	private String smsPort;
	@Value("#{app['batchsms.taskid']}")
	private String smsTaskId;
	@Value("#{app['batchsms.ServerPath']}")
	private String smsServerPath;
	private FTSUtil ftsUtil;
	private static final String receiverId = "SMSP";

	@Override
	public BaseResult batchSMSNotify(BatchSendSMSNotify notify) {
		BatchSendSMSNotifyVO sendVo = BeanUtils.copy(notify, BatchSendSMSNotifyVO.class);
		List<BatchSendSMSNotifyInfo> infos = notify.getInfos();
		if (infos != null && !infos.isEmpty()) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String fileName = smsFilePath + "/SASB" + sdf.format(new Date()) + ".txt";
			StringBuilder sb = new StringBuilder();
			for (BatchSendSMSNotifyInfo info : infos) {
				sb.append("SMSID" + info.getSmsId() + "|");
				sb.append("TEMPLATEID" + info.getTemplateId() + "|");
				if (!StringUtils.isEmpty(info.getFixTemplateId())) {
					sb.append("FIXTEMPLATEID" + info.getFixTemplateId() + "|");
				}
				sb.append("CHANNELCODE" + info.getChannelCode() + "|");
				sb.append("SENDBRANCH" + info.getSendBranch() + "|");

				sb.append("MOBILE" + info.getMobile());
				if (!StringUtils.isEmpty(info.getIdType())) {
					sb.append("|" + "IDTYPE" + info.getIdType());
				}
				if (!StringUtils.isEmpty(info.getIdCode())) {
					sb.append("|" + "IDCODE" + info.getIdCode());
				}
				if (!StringUtils.isEmpty(info.getSignupacct())) {
					sb.append("|" + "SIGNUPACCT" + info.getSignupacct());

				}
				sb.append("\n");
			}

			try {
				File smsFile = new File(fileName);
				FileUtils.writeStringToFile(smsFile, sb.toString());
				log.info("【批量短信文件】生成成功" + fileName);
				/*
				 * if (!smsHost.isEmpty()) { ftsUtil =
				 * FTSUtil.getInstance(smsHost, Integer.parseInt(smsPort),
				 * 5000); ftsUtil.send(fileName, fileName, smsServerPath,
				 * smsTaskId); }
				 */
			} catch (Exception e) {
				throw new RuntimeException(smsHost + " " + smsPort + "\n" + e);
			}

		}
		SoapModel<BatchSendSMSNotifyVO> model = SOAPUtils.createSOAPModel(sendVo);
		model.setTradeCode("SMS093");
		model.setReceiverId(receiverId);
		String outXml = outputSoapProcessImpl.packing(model, String.class);

		String returnXml = ConnectOtherSys.connectSoapSys(outXml);
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
	public SendSMSNotifyResult sendSMS(SendSMSInfo notify) {
		SendSMSInfoVO sendVo = BeanUtils.copy(notify, SendSMSInfoVO.class);
		CommunicationNatp natp = outputSMSProcessImpl.packing(sendVo, CommunicationNatp.class);

		// byte[] bytes = outputSMSProcessImpl.packing(sendVo,
		// CommunicationNatp.class);

		String out = ConnectOtherSys.connectSMS(natp);

		SendSMSNotifyResultVO vo = intputSMSProcessImpl.packing(out, SendSMSNotifyResultVO.class);
		ValidateUtil.validateModel(vo);
		SendSMSNotifyResult result = BeanUtils.copy(vo, SendSMSNotifyResult.class);
		result.setRetCode(vo.getErrorCode());
		result.setRetErrMsg(vo.getErrorMsg());
		return result;
	}

}
