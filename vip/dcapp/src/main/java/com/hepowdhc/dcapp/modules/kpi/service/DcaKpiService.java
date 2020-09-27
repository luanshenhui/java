/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.kpi.dao.DcaKpiDao;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpi;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 企业绩效管理Service
 * 
 * @author dhc
 * @version 2017-01-09
 */
@Service
@Transactional(readOnly = true)
public class DcaKpiService extends CrudService<DcaKpiDao, DcaKpi> {

	public DcaKpi get(String id) {
		return super.get(id);
	}

	public List<DcaKpi> findList(DcaKpi dcaKpi) {
		return super.findList(dcaKpi);
	}

	public Page<DcaKpi> findPage(Page<DcaKpi> page, DcaKpi dcaKpi) {
		return super.findPage(page, dcaKpi);
	}

	@Transactional(readOnly = false)
	public void save(DcaKpi dcaKpi) {
		super.save(dcaKpi);
	}

	@Transactional(readOnly = false)
	public void delete(DcaKpi dcaKpi) {
		super.delete(dcaKpi);
	}

	/**
	 * 获取绩效考核结果数据
	 * 
	 * @return geshuo 20170109
	 */
	public List<DcaKpi> getKPICheckResult(DcaKpi dcaKpi) {
		return dao.getKPICheckResult(dcaKpi);
	}

	/**
	 * 保存提交（如果不存在插入，存在更新）
	 * 
	 * @param dataCollection
	 */
	@Transactional(readOnly = false)
	public void savaResult(List<DcaKpi> dataCollection) {

		for (DcaKpi dcaKpi : dataCollection) {

			dcaKpi.setKpiId(IdGen.uuid());
			dcaKpi.setCreatePerson(UserUtils.getUser().getId());
			dcaKpi.setUpdatePerson(UserUtils.getUser().getId());

			dao.savaResult(dcaKpi);
		}

	}

}