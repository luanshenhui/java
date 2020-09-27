package com.jdecard;

import com.jdecard.common.JdEcardUtils;
import com.jdecard.gameapi.ActionRequest;
import com.jdecard.gameapi.ActionResponse;
import com.letv.common.LoggerUtil;

public class JdEcardClient {
	public ActionResponse GageApiAction(String privateKey, String customerId,
			String orderId, String orderStatus) {

		try {

			JdEcardUtils jdEcardUtils = new JdEcardUtils();
			//jdEcardUtils.setUrl(ReqUrl);
			jdEcardUtils.setCustomerId(customerId);
			jdEcardUtils.setPrivateKey(privateKey);
			
			ActionRequest ar = new ActionRequest();
			ActionResponse response = ar.DoPost(jdEcardUtils, orderId, orderStatus);
			return response;

		} catch (Exception ex) {
			com.letv.common.LoggerUtil.ErrorException(ex);
			return null;
		}
	}
}
