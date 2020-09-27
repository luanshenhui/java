package com.hepowdhc.dcapp.modules.riskmanage.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.riskmanage.service.DcaRiskManageService;

@Service
@Transactional(readOnly = true)
public class DcaRiskManageServiceImpl extends DcaRiskManageService {

    @Override
    protected String getDictList() {
        return "power_id";
    }
}
