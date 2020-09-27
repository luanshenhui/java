package com.hepowdhc.dcapp.modules.risklist.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.risklist.dao.RiskTypeDetailDao;
import com.hepowdhc.dcapp.modules.risklist.entity.RiskTypeDetail;
import com.hepowdhc.dcapp.modules.system.entity.SysDict;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

@Service
@Transactional(readOnly = true)
public class RiskTypeDetailService extends CrudService<RiskTypeDetailDao, RiskTypeDetail> {
	@Autowired
	private RiskTypeDetailDao riskTypeDetailDao;
	

	public List<SysDict> findriskListByType(SysDict sysDict) {
		sysDict.setType("risk_level");
		List<SysDict> result = riskTypeDetailDao.findriskListByType(sysDict);
		return result;
	}


	public List<List<String>> findTableListByType(SysDict sysDict) {
		sysDict = new SysDict();
		sysDict.setType("risk_type_detail");
		List<SysDict> detailList = riskTypeDetailDao.findriskListByType(sysDict);
		sysDict.setType("risk_level");
		List<SysDict> levelList = riskTypeDetailDao.findriskListByType(sysDict);
		List<List<String>> result=new ArrayList<List<String>>();
		for(SysDict detail :detailList){
			List<String> list=new ArrayList<String>();
			list.add(detail.getLabel());
			for(SysDict level :levelList){
				list.add(detail.getValue()+"_"+level.getValue());
			}
			result.add(list);
		}
		return result;
	}

	public List<RiskTypeDetail> getData(RiskTypeDetail riskTypeDetail) {
		riskTypeDetail=new RiskTypeDetail();
		riskTypeDetail.setDelFlg("0");
		return riskTypeDetailDao.getData(riskTypeDetail);
	}

	@Transactional(readOnly = false)
	public void saveRiskTypeDetail(List<RiskTypeDetail> detlist) {
		RiskTypeDetail riskTypeDetail=new RiskTypeDetail();
		riskTypeDetail.setDelFlg("1");
		riskTypeDetailDao.updateriskTypeDetail(riskTypeDetail);
		for(RiskTypeDetail r:detlist){
			r.setDelFlg("0");
			r.setUpdatePerson(UserUtils.getUser().getId());
			r.setUpdateDate(new Date());
			r.setCreateDate(new Date());
			r.setCreatePerson(UserUtils.getUser().getId());
			r.setId(IdGen.uuid());
			r.setRemark("");
			riskTypeDetailDao.insertriskTypeDetail(r);
		}
		
	}

}
