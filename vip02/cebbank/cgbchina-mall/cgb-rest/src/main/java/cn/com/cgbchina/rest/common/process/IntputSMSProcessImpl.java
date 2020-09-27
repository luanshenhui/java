package cn.com.cgbchina.rest.common.process;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.visit.vo.sms.SendSMSNotifyResultVO;

@Service
public class IntputSMSProcessImpl implements
		PackProcess<String, SendSMSNotifyResultVO> {

	@Override
	public SendSMSNotifyResultVO packing(String r,
			Class<SendSMSNotifyResultVO> t) {
		SendSMSNotifyResultVO result = new SendSMSNotifyResultVO();
		if (r.equals("发送成功")) {
			result.setErrorMsg(r);
			result.setErrorCode("0000");
		} else {
			if (r.indexOf(":") > -1) {
				String[] strs = r.split(":");
				result.setErrorCode(strs[0]);
				result.setErrorMsg(strs[1]);
			}else {
				result.setRetErrMsg("发送失败");
			}
			// result.setRetCode(strs[1]);
		}

		return result;
	}

}
