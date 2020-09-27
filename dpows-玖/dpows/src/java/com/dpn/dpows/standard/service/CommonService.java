package com.dpn.dpows.standard.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.dpn.dpows.common.util.UUIDHexGenerator;
import com.dpn.dpows.standard.repository.EventLogRepository;




/**
 * CommonService.
 *
 * @author zhaoqian@dpn.com.cn
 * @since 1.0.0 zhaoqian@dpn.com.cn
 * @version 1.0.0 zhaoqian@dpn.com.cn
 * Created by ZhaoQian on 2017-9-6 14:27:26.
**/
@Service("commonService")
public class CommonService {
	
	@Autowired
    @Qualifier("eventLog")
    private EventLogRepository eventLogRepository = null;
	
	

	/**
	 * 提交事件日志 ，用于记录delete、insert、update时的数据库操作，保存全部提交信息
	 * @param actionUser 操作人代码
	 * @param orgCode 操作人组织
	 * @param actionType 操作类型
	 * @param actionName 动作名称
	 * @param indexValue 操作功能主键编号
	 * @param strings 1-5的备注
	 * @throws Exception
	 */
	public void saveEventLog(String actionUser,String orgCode
			,String actionType,String actionName,String indexValue,String ...strings) throws Exception{
		Map<String,String> map = new HashMap<String,String>();	
		map.put("action_user", actionUser);
		map.put("action_org_code", orgCode);
		map.put("action_type", actionType);
		map.put("action_name", actionName);
		map.put("index_value", indexValue);
		if(strings != null){
			if(strings.length <=5){
				for (int i = 0; i < strings.length; i++) {
					map.put("details_"+(i+1), strings[i]);			
				}
			}else{
				new Exception("参数过长");
			}
		}		
		this.eventLogRepository.insertEventLog(map);
	}
	
	
	public void saveEventLog(String actionType,String indexValue,String ...strings) throws Exception{
		String id = null;
		if(StringUtils.isBlank(indexValue)){
			id = UUIDHexGenerator.getInstance().generate();
		}else{
			id = indexValue;
		}
		this.saveEventLog("sysuser", "sysorg", actionType, "dpows-approve", id, strings);
	}
	
}
