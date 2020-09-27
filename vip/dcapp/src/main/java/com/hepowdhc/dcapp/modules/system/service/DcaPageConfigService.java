/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.system.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.common.collect.Lists;
import com.hepowdhc.dcapp.modules.common.utils.Constant;
import com.hepowdhc.dcapp.modules.system.dao.DcaPageConfigDao;
import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfig;
import com.hepowdhc.dcapp.modules.system.entity.DcaPageConfigDetail;
import com.hepowdhc.dcapp.modules.system.entity.EfficacyAnalysis;
import com.hepowdhc.dcapp.modules.system.entity.InvolveDept;
import com.hepowdhc.dcapp.modules.system.entity.OverallData;
import com.hepowdhc.dcapp.modules.system.entity.TimeDimension;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.common.utils.StringUtils;
import com.thinkgem.jeesite.modules.sys.entity.Office;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 页面设置Service
 * 
 * @author zhengwei.cui
 * @version 2016-12-26
 */
@Service
@Transactional(readOnly = true)
public class DcaPageConfigService extends CrudService<DcaPageConfigDao, DcaPageConfig> {

	@Autowired
	private DcaPageConfigDao dcaPageConfigDao;

	public DcaPageConfig get(String id) {
		return super.get(id);
	}

	public List<DcaPageConfig> findList(DcaPageConfig dcaPageConfig) {
		return super.findList(dcaPageConfig);
	}

	public Page<DcaPageConfig> findPage(Page<DcaPageConfig> page, DcaPageConfig dcaPageConfig) {
		return super.findPage(page, dcaPageConfig);
	}

	@Transactional(readOnly = false)
	public void save(DcaPageConfig dcaPageConfig) {
		super.save(dcaPageConfig);
	}

	/**
	 * 保存数据
	 * 
	 * @param dcaPageConfigDetail
	 */
	public void saveSubmit(DcaPageConfigDetail dcaPageConfigDetail) {
		List<DcaPageConfig> configList = Lists.newArrayList();
		// 当前用户id
		String userId = UserUtils.getUser().getId();

		// 循环总体数据
		int count = 1;
		for (OverallData overallData : dcaPageConfigDetail.getOverallDataList()) {
			DcaPageConfig dcaPageConfig = new DcaPageConfig();
			dcaPageConfig.setCfgId(IdGen.uuid());
			dcaPageConfig.setCfgType(Constant.OVER_ALL_DATA);
			dcaPageConfig.setCfgCode(count++);
			dcaPageConfig.setCfgName(overallData.getTargetName()); // 指标名称
			dcaPageConfig.setCfgValue1(overallData.getTargetValue()); // 指标值
			dcaPageConfig.setCreatePerson(userId);
			dcaPageConfig.setUpdatePerson(userId);
			configList.add(dcaPageConfig);
		}

		// 时间维度
		for (TimeDimension timeDimension : dcaPageConfigDetail.getTimeDimensionList()) {
			DcaPageConfig dcaPageConfig = new DcaPageConfig();
			dcaPageConfig.setCfgId(IdGen.uuid());
			dcaPageConfig.setCfgType(Constant.TIME_DIMENSION);
			dcaPageConfig.setCfgCode(timeDimension.getQuarter());
			dcaPageConfig.setCfgName(timeDimension.getQuarterName()); // 季度
			dcaPageConfig.setCfgValue1(timeDimension.getAlarmNum()); // 告警数
			dcaPageConfig.setCfgValue2(timeDimension.getRiskNum()); // 风险数
			dcaPageConfig.setCreatePerson(userId);
			dcaPageConfig.setUpdatePerson(userId);
			configList.add(dcaPageConfig);
		}

		// 涉及部门
		count = 1;
		for (InvolveDept involveDept : dcaPageConfigDetail.getInvolveDeptList()) {
			DcaPageConfig dcaPageConfig = new DcaPageConfig();
			dcaPageConfig.setCfgId(IdGen.uuid());
			dcaPageConfig.setCfgType(Constant.INVOLVE_DEPT);
			dcaPageConfig.setCfgCode(count++);
			dcaPageConfig.setCfgName(involveDept.getDept()); // 部门
			dcaPageConfig.setCfgValue1(involveDept.getRiskRatio()); // 风险占比
			dcaPageConfig.setCreatePerson(userId);
			dcaPageConfig.setUpdatePerson(userId);
			configList.add(dcaPageConfig);
		}

		// 业务综合效能分析
		count = 1;
		for (EfficacyAnalysis efficacyAnalysis : dcaPageConfigDetail.getEfficacyAnalysisList()) {
			DcaPageConfig dcaPageConfig = new DcaPageConfig();
			dcaPageConfig.setCfgId(IdGen.uuid());
			dcaPageConfig.setCfgType(Constant.EFFICACY_ANALYSIS);
			dcaPageConfig.setCfgCode(count++);
			dcaPageConfig.setCfgName(efficacyAnalysis.getEfficacyName()); // 效能名
			dcaPageConfig.setCfgValue1(efficacyAnalysis.getEfficacyValue()); // 效能值
			dcaPageConfig.setCfgValue2(efficacyAnalysis.getGreen()); // 绿色临界值
			dcaPageConfig.setCfgValue3(efficacyAnalysis.getYellow()); // 黄色临界值
			dcaPageConfig.setCfgValue4(efficacyAnalysis.getOrange()); // 橙色临界值
			dcaPageConfig.setCfgValue5(efficacyAnalysis.getRed());// 红色临界值
			dcaPageConfig.setCreatePerson(userId);
			dcaPageConfig.setUpdatePerson(userId);
			configList.add(dcaPageConfig);
		}

		// 批量插入(先清空，再插入)
		dcaPageConfigDao.delectAll();
		dcaPageConfigDao.insertBatch(configList);
	}

	/**
	 * 查询部门列表
	 * 
	 * @return
	 */
	public List<Office> getOfficeList() {
		return dcaPageConfigDao.getOfficeList();
	}

	/**
	 * 获取首页配置数据
	 * 
	 * @return
	 */
	public DcaPageConfigDetail getAllData() {

		DcaPageConfigDetail dcaPageConfigDetail = new DcaPageConfigDetail();

		// [总体数据]初始化
		List<OverallData> overallDataList = new ArrayList<OverallData>();

		// [时间维度]初始化
		List<TimeDimension> timeDimensionList = new ArrayList<TimeDimension>();

		// [涉及部门]初始化
		List<InvolveDept> involveDeptList = new ArrayList<InvolveDept>();

		// [业务综合效能分析]初始化
		List<EfficacyAnalysis> efficacyAnalysisList = new ArrayList<EfficacyAnalysis>();

		// 获取首页配置数据
		List<DcaPageConfig> list = dcaPageConfigDao.getAllData();

		if (CollectionUtils.isNotEmpty(list)) {

			for (DcaPageConfig dcaPageConfig : list) {

				String type = dcaPageConfig.getCfgType();

				if (StringUtils.isNotEmpty(type)) {

					// [总体数据]的数据设置
					if (Constant.OVER_ALL_DATA.equals(type)) {
						overallDataList.add(overallDataFormat(dcaPageConfig));

						// [时间维度]的数据设置
					} else if (Constant.TIME_DIMENSION.equals(type)) {
						timeDimensionList.add(timeDimensionFormat(dcaPageConfig));

						// [涉及部门]的数据设置
					} else if (Constant.INVOLVE_DEPT.equals(type)) {
						involveDeptList.add(involveDeptFormat(dcaPageConfig));

						// [业务综合效能分析]的数据设置
					} else {
						efficacyAnalysisList.add(efficacyAnalysisFormat(dcaPageConfig));
					}

				}

			}

			// 给总体数据按code值排序
			if (CollectionUtils.isNotEmpty(overallDataList)) {
				Collections.sort(overallDataList, new Comparator<OverallData>() {
					@Override
					public int compare(OverallData o1, OverallData o2) {
						int a = o1.getCode();
						int b = o2.getCode();
						return a - b;
					}
				});
			}

			// 给时间维度按quarter值排序
			if (CollectionUtils.isNotEmpty(timeDimensionList)) {
				Collections.sort(timeDimensionList, new Comparator<TimeDimension>() {
					@Override
					public int compare(TimeDimension o1, TimeDimension o2) {
						int a = o1.getQuarter();
						int b = o2.getQuarter();
						return a - b;
					}
				});
			}

			dcaPageConfigDetail.setOverallDataList(overallDataList);
			dcaPageConfigDetail.setTimeDimensionList(timeDimensionList);
			dcaPageConfigDetail.setInvolveDeptList(involveDeptList);
			dcaPageConfigDetail.setEfficacyAnalysisList(efficacyAnalysisList);

		}

		return dcaPageConfigDetail;

	}

	/**
	 * [总体数据]的数据设置
	 * 
	 * @return
	 */
	public OverallData overallDataFormat(DcaPageConfig dcaPageConfig) {

		OverallData overallData = new OverallData();

		overallData.setCode(dcaPageConfig.getCfgCode());

		// 指标名称
		overallData.setTargetName(dcaPageConfig.getCfgName());
		// 指标值
		overallData.setTargetValue(dcaPageConfig.getCfgValue1());

		return overallData;

	}

	/**
	 * [时间维度]的数据设置
	 * 
	 * @return
	 */
	public TimeDimension timeDimensionFormat(DcaPageConfig dcaPageConfig) {

		TimeDimension timeDimension = new TimeDimension();

		// 季度
		timeDimension.setQuarter(dcaPageConfig.getCfgCode());
		// 季度名称
		timeDimension.setQuarterName(dcaPageConfig.getCfgName());
		// 告警数
		timeDimension.setAlarmNum(dcaPageConfig.getCfgValue1());
		// 风险数
		timeDimension.setRiskNum(dcaPageConfig.getCfgValue2());

		return timeDimension;

	}

	/**
	 * [涉及部门]的数据设置
	 * 
	 * @return
	 */
	public InvolveDept involveDeptFormat(DcaPageConfig dcaPageConfig) {

		InvolveDept involveDept = new InvolveDept();
		// 部门
		involveDept.setDept(dcaPageConfig.getCfgName());
		// 风险占比
		involveDept.setRiskRatio(dcaPageConfig.getCfgValue1());

		return involveDept;

	}

	/**
	 * [业务综合效能分析]的数据设置
	 * 
	 * @return
	 */
	public EfficacyAnalysis efficacyAnalysisFormat(DcaPageConfig dcaPageConfig) {

		EfficacyAnalysis efficacyAnalysis = new EfficacyAnalysis();
		// 效能名
		efficacyAnalysis.setEfficacyName(dcaPageConfig.getCfgName());
		// 效能值
		efficacyAnalysis.setEfficacyValue(dcaPageConfig.getCfgValue1());
		// 绿色临界值
		efficacyAnalysis.setGreen(dcaPageConfig.getCfgValue2());
		// 黄色临界值
		efficacyAnalysis.setYellow(dcaPageConfig.getCfgValue3());
		// 橙色临界值
		efficacyAnalysis.setOrange(dcaPageConfig.getCfgValue4());
		// 红色临界值
		efficacyAnalysis.setRed(dcaPageConfig.getCfgValue5());

		return efficacyAnalysis;
	}

}