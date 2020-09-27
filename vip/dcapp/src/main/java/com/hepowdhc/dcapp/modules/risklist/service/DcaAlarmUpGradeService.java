/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.modules.risklist.service;

import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.modules.alarm.dao.DcaAlarmDetailDao;
import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.risklist.dao.DcaAlarmUpGradeDao;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmUpGrade;
import com.thinkgem.jeesite.common.persistence.Page;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.IdGen;
import com.thinkgem.jeesite.modules.sys.dao.DcaTraceUserRoleDao;
import com.thinkgem.jeesite.modules.sys.entity.DcaTraceUserRole;
import com.thinkgem.jeesite.modules.sys.entity.User;
import com.thinkgem.jeesite.modules.sys.utils.UserUtils;

/**
 * 告警上报管理Service
 * 
 * @author dhc
 * @version 2016-11-15
 */
@Service
@Transactional(readOnly = true)
public class DcaAlarmUpGradeService extends CrudService<DcaAlarmUpGradeDao, DcaAlarmUpGrade> {

	@Autowired
	public DcaAlarmUpGradeDao dcaAlarmUpGradeDao;
	@Autowired
	public DcaAlarmDetailDao dcaAlarmDetailDao;
	@Autowired
	private DcaTraceUserRoleDao dcaTraceUserRoleDao;

	public DcaAlarmUpGrade get(String id) {
		return super.get(id);
	}

	public List<DcaAlarmUpGrade> findList(DcaAlarmUpGrade dcaAlarmUpGrade) {
		return super.findList(dcaAlarmUpGrade);
	}

	public Page<DcaAlarmUpGrade> findPage(Page<DcaAlarmUpGrade> page, DcaAlarmUpGrade dcaAlarmUpGrade) {
		return super.findPage(page, dcaAlarmUpGrade);
	}

	@Transactional(readOnly = false)
	public void save(DcaAlarmUpGrade dcaAlarmUpGrade) {
		if (dcaAlarmUpGrade != null) {
			String id = dcaAlarmUpGrade.getUuid();
			User user = UserUtils.getUser();
			if (StringUtils.isNotBlank(id)) {
				// 更新
				dcaAlarmUpGrade.setUpdatePerson(user.getId());

				updateData(dcaAlarmUpGrade);
			} else {
				// 新建
				dcaAlarmUpGrade.setUuid(IdGen.uuid());
				dcaAlarmUpGrade.setCreatePerson(user.getId());
				dcaAlarmUpGrade.setUpdatePerson(user.getId());

				dcaAlarmUpGradeDao.insert(dcaAlarmUpGrade);
			}
		}
	}

	/**
	 * 获取分页列表
	 * 
	 * @param page
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	public Page<DcaAlarmUpGrade> getPage(Page<DcaAlarmUpGrade> page, DcaAlarmUpGrade dcaAlarmUpGrade) {

		dcaAlarmUpGrade.setPage(page);

		List<DcaAlarmUpGrade> list = dcaAlarmUpGradeDao.getList(dcaAlarmUpGrade);
		for (DcaAlarmUpGrade item : list) {
			// 获取上报岗位name
			String gradeOrgPostName = getGradeOrgPostName(item);
			item.setOrgName(gradeOrgPostName);
		}
		page.setList(list);

		return page;
	}

	/**
	 * 通过id获取该条风险上报数据
	 * 
	 * @param id
	 * @return
	 */
	public DcaAlarmUpGrade getDcaAlarmUpGradeForm(String id) {
		DcaAlarmUpGrade result = dcaAlarmUpGradeDao.getDcaAlarmUpGradeForm(id);
		if (result != null) {
			// 获取上报岗位name
			String gradeOrgPostName = getGradeOrgPostName(result);
			result.setGradeOrgPostName(gradeOrgPostName);
		}
		return result;
	}

	/**
	 * 获取上报岗位name
	 * 
	 * @param form
	 * @return
	 */
	private String getGradeOrgPostName(DcaAlarmUpGrade form) {

		StringBuffer sb = new StringBuffer();
		if (form != null) {
			// 获取岗位id（以逗号分隔的字符串）
			String idString = form.getGradeOrgPost();
			if (StringUtils.isNotBlank(idString)) {
				// 将岗位id串转成数组
				String[] ids = idString.split(",");
				for (int i = 0; i < ids.length; i++) {

					// 通过岗位id，获取岗位name
					DcaTraceUserRole dcaTraceUserRole = dcaTraceUserRoleDao.findById(ids[i]);
					if (dcaTraceUserRole != null) {
						String name = dcaTraceUserRole.getRoleName();

						// 将岗位name拼成用逗号分隔的字符串
						if (i != ids.length - 1) {
							sb.append(String.valueOf(name)).append(",");
						} else {
							sb.append(String.valueOf(name));
						}
					}
				}
			}
		}
		return sb.toString();
	}

	/**
	 * 删除
	 * 
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	@Transactional(readOnly = false)
	public void delete(DcaAlarmUpGrade dcaAlarmUpGrade) {

		if (dcaAlarmUpGrade != null) {

			DcaAlarmUpGrade form = dcaAlarmUpGradeDao.getDcaAlarmUpGradeForm(dcaAlarmUpGrade.getUuid());

			if (form != null) {
				// 待删除的岗位ids
				String gradeOrgPost = form.getGradeOrgPost();
				if (StringUtils.isNotBlank(gradeOrgPost)) {
					// 通过【权力】【业务角色】【告警等级】项目选定【告警信息表】中的一类数据
					List<DcaAlarmDetail> alarmList = dcaAlarmDetailDao.getAlarmDetailListByUpGrade(form);

					// 删除【可视范围】中与【上报部门岗位】字段中相同数据
					for (DcaAlarmDetail alarmDetail : alarmList) {
						String visualScope = alarmDetail.getVisualScope();
						if (StringUtils.isNotBlank(visualScope)) {
							// 处理数组字符
							String arrResult = deleteArrContrast(visualScope, gradeOrgPost);
							alarmDetail.setVisualScope(arrResult);
							// 更新【可视范围】
							dcaAlarmDetailDao.update(alarmDetail);
						}
					}
					// 将【风险预警上报设置表】中待删除的数据项目【del_flag】置为1
					super.delete(dcaAlarmUpGrade);
				}
			}
		}
	}

	/**
	 * 更新
	 * 
	 * @param dcaAlarmUpGrade
	 * @return
	 */
	private void updateData(DcaAlarmUpGrade dcaAlarmUpGrade) {

		// 通过【权力】【业务角色】【告警等级】项目选定【告警信息表】中的一类数据
		List<DcaAlarmDetail> alarmList = dcaAlarmDetailDao.getAlarmDetailListByUpGrade(dcaAlarmUpGrade);

		// 修改前的【上报部门岗位】
		String gradeOrgPostOld = dcaAlarmUpGrade.getGradeOrgPostOld();
		// 修改后的【上报部门岗位】
		String gradeOrgPostNew = dcaAlarmUpGrade.getGradeOrgPost();

		// 更新【可视范围】中与【上报部门岗位】字段中相同数据
		for (DcaAlarmDetail alarmDetail : alarmList) {
			String visualScope = alarmDetail.getVisualScope();
			if (StringUtils.isNotBlank(visualScope)) {
				// 处理数组字符
				String arrResult = updateArrContrast(visualScope, gradeOrgPostOld, gradeOrgPostNew);
				alarmDetail.setVisualScope(arrResult);
				// 更新【预警信息表】中的【可视范围】
				dcaAlarmDetailDao.update(alarmDetail);
			}
		}
		// 更新【风险预警上报设置表】中【上报部门岗位】
		dcaAlarmUpGradeDao.modify(dcaAlarmUpGrade);
	}

	/**
	 * 处理数组字符：删除string1中string2内的元素
	 * 
	 * @param string1
	 * @param string2
	 * @return
	 */
	private static String deleteArrContrast(String string1, String string2) {

		String[] arr1 = string1.split(",");
		String[] arr2 = string2.split(",");

		List<String> list = new LinkedList<String>();
		// 处理第一个数组,list里面的值
		for (String str : arr1) {
			if (!list.contains(str)) {
				list.add(str);
			}
		}
		// 如果第二个数组存在和第一个数组相同的值，就删除
		for (String str : arr2) {
			if (list.contains(str)) {
				list.remove(str);
			}
		}
		// 创建空数组
		String[] result = {};
		String[] arrResult = list.toArray(result);

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < arrResult.length; i++) {
			// 拼成用逗号分隔的字符串
			if (i != arrResult.length - 1) {
				sb.append(arrResult[i]).append(",");
			} else {
				sb.append(arrResult[i]);
			}
		}

		return sb.toString();
	}

	/**
	 * 处理数组字符：将string1中string2内的元素替换成string3内元素
	 * 
	 * @param string1
	 * @param string2
	 * @param string3
	 * @return
	 */
	private static String updateArrContrast(String string1, String string2, String string3) {

		String[] arr1 = string1.split(",");
		String[] arr2 = string2.split(",");
		String[] arr3 = string3.split(",");

		List<String> list = new LinkedList<String>();
		// 处理第一个数组,list里面的值
		for (String str : arr1) {
			if (!list.contains(str)) {
				list.add(str);
			}
		}
		// 如果第二个数组存在和第一个数组相同的值，就删除
		for (String str : arr2) {
			if (list.contains(str)) {
				list.remove(str);
			}
		}
		// 如果第三个数组不存在和第一个数组相同的值，就添加
		for (String str : arr3) {
			if (!list.contains(str)) {
				list.add(str);
			}
		}
		// 创建空数组
		String[] result = {};
		String[] arrResult = list.toArray(result);

		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < arrResult.length; i++) {
			// 拼成用逗号分隔的字符串
			if (i != arrResult.length - 1) {
				sb.append(arrResult[i]).append(",");
			} else {
				sb.append(arrResult[i]);
			}
		}

		return sb.toString();
	}

}