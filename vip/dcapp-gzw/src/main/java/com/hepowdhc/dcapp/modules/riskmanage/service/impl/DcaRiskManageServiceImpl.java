package com.hepowdhc.dcapp.modules.riskmanage.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.riskmanage.entity.DcaRiskManage;
import com.hepowdhc.dcapp.modules.riskmanage.entity.RiskDataEntity;
import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageService;
import com.thinkgem.jeesite.modules.sys.entity.Dict;
import com.thinkgem.jeesite.modules.sys.utils.DictUtils;

@Service
@Transactional(readOnly = true)
public class DcaRiskManageServiceImpl extends DcaRiskManageService {


	@Override
	protected String getDictList() {
		return "szyd_class";
	}


}
