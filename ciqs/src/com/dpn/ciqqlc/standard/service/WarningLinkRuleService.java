package com.dpn.ciqqlc.standard.service;

import java.util.List;



import com.dpn.ciqqlc.http.form.WarningLinkRuleForm;

public interface WarningLinkRuleService {
	List<WarningLinkRuleForm> findBillList(WarningLinkRuleForm warningLinkRuleForm)
			throws Exception;
}
