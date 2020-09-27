/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.hepowdhc.dcapp.batch.service;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.hepowdhc.dcapp.batch.dao.DcaAlarmBatchDao;
import com.hepowdhc.dcapp.modules.alarm.dao.DcaAlarmDetailDao;
import com.hepowdhc.dcapp.modules.alarm.entity.DcaAlarmDetail;
import com.hepowdhc.dcapp.modules.risklist.dao.DcaAlarmUpGradeDao;
import com.hepowdhc.dcapp.modules.risklist.entity.DcaAlarmUpGrade;
import com.thinkgem.jeesite.common.service.CrudService;
import com.thinkgem.jeesite.common.utils.DateUtils;

import org.apache.commons.lang3.StringUtils;

/**
 * 告警管理批处理Service
 * @author dhc
 * @version 2016-11-17
 */
@Service
@Transactional(readOnly = true)
public class DcaAlarmBatchService extends CrudService<DcaAlarmBatchDao, DcaAlarmDetail> {
	
	@Autowired
	public DcaAlarmBatchDao dcaAlarmBatchDao;
	@Autowired
	public DcaAlarmUpGradeDao dcaAlarmUpGradeDao;
	@Autowired
	public DcaAlarmDetailDao dcaAlarmDetailDao;
	
	@Transactional(readOnly = false)
	public void alarmBatchTimer() throws Exception {
		
		DcaAlarmUpGrade dcaAlarmUpGrade = new DcaAlarmUpGrade();
		// 获取【告警上报等级设置表】中的有效数据
		List<DcaAlarmUpGrade> alarmUpGradeList = dcaAlarmUpGradeDao.getAllFormList(dcaAlarmUpGrade);
		
		for(DcaAlarmUpGrade item : alarmUpGradeList){
			
			// 通过相同的【权力】【业务角色】【告警级别】，获取告警数据
			DcaAlarmDetail dcaAlarmDetail = new DcaAlarmDetail();
			dcaAlarmDetail.setPowerId(item.getPowerId());
			dcaAlarmDetail.setAlarmLevel(item.getAlarmLevel());
			
			List<DcaAlarmDetail> detailList = dcaAlarmBatchDao.getDetailInfo(dcaAlarmDetail);
			
			for(DcaAlarmDetail detail : detailList){
				
				boolean updateFlag = false;
				
				// 获取详细表中的业务角色ids
				String bizRoleId = detail.getBizRoleId();
				if(StringUtils.isNotBlank(bizRoleId)){
					// 详细表中的业务角色ids数组
					String[] bizRoleIds = bizRoleId.split("\\|\\|");
					for(String roleId : bizRoleIds){
						// 判断【告警上报等级设置表】中的bizRoleId是否包含在【告警详细表】中
						if(StringUtils.equals(roleId, item.getBizRoleId())){
							updateFlag = true;
						}
					}
				}
				if(updateFlag){
					// 获取【告警首次产生时间】
					Date alarmTime1st = detail.getAlarmTime1st();
					
					// 系统时间-告警首次产生时间【小时数】
					double hours = DateUtils.getDistanceOfTwoDateHours(alarmTime1st, new Date());
					String sumOutTime = item.getSumOutTime();
					if(StringUtils.isNotBlank(sumOutTime)){
						double temp = Double.parseDouble(sumOutTime);
						// (系统时间-告警首次产生时间)>=【累计超期时间】
						if(hours >= temp){
							// 同步给【预警信息表】的【可视范围】字段
							String visualScope = arrContrast(detail.getVisualScope(), item.getGradeOrgPost());
							detail.setVisualScope(visualScope);
							
							// 更新【预警信息表】中的【可视范围】
							dcaAlarmDetailDao.update(detail);
						}
					}
				}
				
			}
		}
		
	}
	
	/**
	 * 处理数组字符：将string1,string2内的元素合并去重
	 * @param string1
	 * @param string2
	 * @return
	 */
    private static String arrContrast(String string1, String string2){
    	

    	String[] arr1 = string1.split(",");
    	String[] arr2 = string2.split(",");
    	
        List<String> list = new LinkedList<String>();
        // 处理第一个数组,list里面的值
        for (String str : arr1) {                
            if (!list.contains(str)) {
                list.add(str);
            }
        }
        
        // 如果第二个数组不存在和第一个数组相同的值，就添加
        for (String str : arr2) {      
            if(!list.contains(str)){
                list.add(str);
            }
        }
        //创建空数组
        String[] result = {};
        String[] arrResult = list.toArray(result);
        
        StringBuffer sb = new StringBuffer();
		for(int i = 0; i < arrResult.length; i++){
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