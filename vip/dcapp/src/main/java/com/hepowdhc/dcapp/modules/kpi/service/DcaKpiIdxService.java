/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.kpi.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.kpi.dao.DcaKpiDao;
import com.hepowdhc.dcapp.modules.kpi.dao.DcaKpiIdxDao;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpi;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdx;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdxDataResult;
import com.hepowdhc.dcapp.modules.kpi.entity.DcaKpiIdxResult;
import com.thinkgem.jeesite.common.mapper.JsonMapper;
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
public class DcaKpiIdxService extends CrudService<DcaKpiIdxDao, DcaKpiIdx> {

	@Autowired
	private DcaKpiIdxDao dcaKpiIdxDao;
	@Autowired
	private DcaKpiDao dcaKpiDao;

	public DcaKpiIdx get(String id) {
		return super.get(id);
	}

	public List<DcaKpiIdx> findList(DcaKpiIdx dcaKpiIdx) {
		return super.findList(dcaKpiIdx);
	}

	public Page<DcaKpiIdx> findPage(Page<DcaKpiIdx> page, DcaKpiIdx dcaKpiIdx) {
		return super.findPage(page, dcaKpiIdx);
	}

	@Transactional(readOnly = false)
	public void save(DcaKpiIdx dcaKpiIdx) {
		super.save(dcaKpiIdx);
	}

	@Transactional(readOnly = false)
	public void delete(DcaKpiIdx dcaKpiIdx) {
		super.delete(dcaKpiIdx);
	}

	public List<DcaKpiIdxDataResult> getData(DcaKpiIdx dcaKpiIdx) {

		List<DcaKpiIdx> dcaKpiIdxList = dcaKpiIdxDao.getData(dcaKpiIdx);
		LinkedHashMap<String, LinkedHashMap<String, DcaKpiIdxResult>> map = new LinkedHashMap<>();
		for (DcaKpiIdx item : dcaKpiIdxList) {
			LinkedHashMap<String, DcaKpiIdxResult> tempMap = new LinkedHashMap<>();
			// 绩效指标类型
			String idxType = item.getIdxType();
			// 绩效指标类型名称
			String idxTypeName = item.getIdxTypeName();
			// 绩效指标Id
			String idxId = item.getIdxId();
			// 绩效指标Id
			String idxName = item.getIdxName();

			if (null == map.get(idxType)) { // 指标类型在map中不存在
				// 指标Id在tempMap中不存在
				if (null == tempMap.get(idxId)) {
					DcaKpiIdxResult resultItem = new DcaKpiIdxResult();
					resultItem.setIdxType(idxType);
					resultItem.setIdxId(idxId);
					resultItem.setIdxName(idxName);
					resultItem.setIdxTypeName(idxTypeName);
					if (null != item.getCriticalityValue()) {
						resultItem.getDataList().add(item);
					}
					tempMap.put(idxId, resultItem);
					// 指标Id在tempMap中存在
				} else {
					tempMap.get(idxId).getDataList().add(item);
				}
				map.put(idxType, tempMap);

			} else { // 指标类型在map中已经存在
				tempMap = map.get(idxType);
				// 指标Id在tempMap中不存在
				if (null == tempMap.get(idxId)) {
					DcaKpiIdxResult resultItem = new DcaKpiIdxResult();
					resultItem.setIdxType(idxType);
					resultItem.setIdxId(idxId);
					resultItem.setIdxName(idxName);
					if (null != item.getCriticalityValue()) {
						resultItem.getDataList().add(item);
					}
					tempMap.put(idxId, resultItem);
					// 指标Id在tempMap中存在
				} else {
					tempMap.get(idxId).getDataList().add(item);
				}

				map.put(idxType, tempMap);
			}

		}

		List<DcaKpiIdxDataResult> resultList = new ArrayList<DcaKpiIdxDataResult>();

		for (String key : map.keySet()) {
			LinkedHashMap<String, DcaKpiIdxResult> itemMap = map.get(key);
			// 类型
			DcaKpiIdxDataResult result = new DcaKpiIdxDataResult();
			result.setIdxType(key);
			// 每个类型的 项目列表
			List<DcaKpiIdxResult> dcaKpiIdxResultList = new ArrayList<DcaKpiIdxResult>();

			for (String tempKey : itemMap.keySet()) {
				// 每个项目的指标结果列表
				// id 名称，数据list
				DcaKpiIdxResult dcaKpiIdxResult = new DcaKpiIdxResult();
				dcaKpiIdxResult.setIdxId(tempKey);

				dcaKpiIdxResultList.add(itemMap.get(tempKey));
			}
			result.setDcaKpiIdxResult(dcaKpiIdxResultList);

			resultList.add(result);
		}

		return resultList;
	}

	/**
	 * 保存数据
	 * 
	 * @param dcaKpiIdxEntity
	 * @return
	 */
	@Transactional(readOnly = false)
	public void saveData(DcaKpiIdx dcaKpiIdxEntity) {

		String idxId = ""; // 考核指标ID
		if (StringUtils.isNotBlank(dcaKpiIdxEntity.getIdxId())) {
			idxId = dcaKpiIdxEntity.getIdxId();
		} else {
			idxId = IdGen.uuid();
		}

		List<DcaKpiIdx> kpiList = new ArrayList<>();
		// 绩效临界值
		Map<String, String> dataMap = (Map<String, String>) JsonMapper.fromJsonString(dcaKpiIdxEntity.getDataMap(),
				Map.class);
		for (String key : dataMap.keySet()) {
			DcaKpiIdx dcaKpiIdx = new DcaKpiIdx();
			dcaKpiIdx.setUuId(IdGen.uuid());
			dcaKpiIdx.setIdxId(idxId); // 考核指标ID
			dcaKpiIdx.setIdxType(dcaKpiIdxEntity.getIdxType()); // 指标名称
			dcaKpiIdx.setIdxName(dcaKpiIdxEntity.getIdxName()); // 绩效指标类型
			dcaKpiIdx.setIdxResult(key); // 指标结果
			String criticalityValue = dataMap.get(key);
			dcaKpiIdx.setCriticalityValue(Double.valueOf(criticalityValue));// 临界值
			dcaKpiIdx.setCreatePerson(UserUtils.getUser().getId());
			dcaKpiIdx.setUpdatePerson(UserUtils.getUser().getId());
			kpiList.add(dcaKpiIdx);
		}

		if (StringUtils.isNotBlank(dcaKpiIdxEntity.getIdxId())) {
			// 删除原有数据
			dcaKpiIdxDao.deleteDataByIdxId(dcaKpiIdxEntity);
			// 修改考核表中相关数据
			DcaKpi dcaKpi = new DcaKpi();
			dcaKpi.setIdxId(dcaKpiIdxEntity.getIdxId()); // 考核指标ID
			dcaKpi.setIdxName(dcaKpiIdxEntity.getIdxName()); // 指标名称
			dcaKpi.setIdxType(dcaKpiIdxEntity.getIdxType()); // 指标类型
			dcaKpi.setUpdatePerson(UserUtils.getUser().getId()); // 更新人
			dcaKpiDao.updateNameAndType(dcaKpi);
		}

		// 批量保存
		dcaKpiIdxDao.insertBatch(kpiList);
	}

	/**
	 * 根据idxId查询
	 * 
	 * @param dcaKpiIdx
	 * @return
	 */
	public List<DcaKpiIdx> getByIdxId(DcaKpiIdx dcaKpiIdx) {
		return dcaKpiIdxDao.getByIdxId(dcaKpiIdx);
	}

	/**
	 * 删除
	 * 
	 * @param dcaKpiIdx
	 */
	@Transactional(readOnly = false)
	public void deleteByIdxId(DcaKpiIdx dcaKpiIdx) {
		// 删除绩效考核指标表
		dcaKpiIdxDao.deleteByIdxId(dcaKpiIdx);
		// 删除考核表
		DcaKpi dcaKpi = new DcaKpi();
		dcaKpi.setIdxId(dcaKpiIdx.getIdxId());
		dcaKpiDao.deleteByIdxId(dcaKpi);
	}

	/**
	 * 获取绩效考核类型
	 * 
	 * @return pang huidan 20170109
	 */
	public List<DcaKpiIdx> findNameList(DcaKpi dcaKpi) {
		return dao.findNameList(dcaKpi);
	}

	/**
	 * 根据指标类型和指标名称查询数据
	 * 
	 * @param dcaKpi
	 * @return
	 */
	public List<DcaKpiIdx> findByIdxTypeAndIdxName(DcaKpiIdx dcaKpiIdx) {
		return dao.findByIdxTypeAndIdxName(dcaKpiIdx);
	}

}