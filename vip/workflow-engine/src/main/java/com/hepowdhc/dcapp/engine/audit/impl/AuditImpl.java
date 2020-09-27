package com.hepowdhc.dcapp.engine.audit.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import com.hepowdhc.dcapp.engine.instance.Instance;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.hepowdhc.dcapp.dao.ExtractDataDao;
import com.hepowdhc.dcapp.engine.audit.AbsAudit;
import com.hepowdhc.dcapp.utils.GenUUID;
import com.hepowdhc.dcapp.utils.MD5Util;

/**
 * Created by fzxs on 16-12-24.
 */
@Component
public class AuditImpl extends AbsAudit {

	/**
	 * 实例节点标志位 1-实例 2-节点
	 */
	private static final int FLAG_INSTANCE = 1;
	private static final int FLAG_NODE = 2;

	private static final String ENGINE = "workflow-engine";// 创建人 ：工作流引擎

	@Autowired
	protected ExtractDataDao extractDataDao;

	/**
	 * 实例统计map
	 */
	private Map<String, AuditInstanceBean> auditInstanceMap = new HashMap<>();

	/**
	 * 业务数据统计map
	 */
	private Map<String, AuditDataBean> auditDataMap = new HashMap<>();

	/**
	 * 权力和工作流对应的 [实例数量] 统计
	 * 
	 * @param instance
	 * geshuo 20161224
	 */
	@Override
	public void powerWorkFlowAudit(Instance instance) {
		addCount(instance.getFlowId(),instance.getPowerId(), FLAG_INSTANCE);
	}

	/**
	 * 权力和工作流对应的 [实例节点数量] 统计
	 * 
	 * @param mapData
	 * geshuo 20161224
	 */
	@Override
	public void powerWorkFlowNodeAudit(Map<String, Object> mapData) {
		String wfId = String.valueOf(mapData.get("dcaWfId"));
		String powerId = String.valueOf(mapData.get("dcaPowerId"));
		addCount(wfId,powerId, FLAG_NODE);
	}

	/**
	 * 统计数量+1
	 *
	 * @param wfId
	 * @param powerId 权利id
	 * @param instanceFlag 实例标志：1-实例 2-节点
	 */
	private void addCount(String wfId,String powerId, int instanceFlag) {
		String key = MD5Util.getMD5Str(wfId + powerId);// 工作流id+权力id作为key

		AuditInstanceBean instanceBean;
		// 判断数据是否存在
		if (Objects.isNull(auditInstanceMap.get(key))) {
			// 不存在，创建新对象
			instanceBean = new AuditInstanceBean();
			instanceBean.setWfId(wfId);
			instanceBean.setPowerId(powerId);
			logger.debug("a new instance is added --> wfId = " + wfId + " ; powerId = " + powerId);
		} else {
			// 数据存在，实例数+1
			instanceBean = auditInstanceMap.get(key);
			logger.debug("an exist instance is added --> wfId = " + wfId + " ; powerId = " + powerId);
		}
		if (instanceFlag == FLAG_INSTANCE) {
			instanceBean.setInstanceCount(instanceBean.getInstanceCount() + 1);// 实例数量+1
			logger.debug("instance count added --> wfId = " + wfId + " ; powerId = " + powerId);
		} else if (instanceFlag == FLAG_NODE) {
			instanceBean.setInstanceNodeCount(instanceBean.getInstanceNodeCount() + 1);// 实例的节点数量+1
			logger.debug("node count added --> wfId = " + wfId + " ; powerId = " + powerId);
		}
		auditInstanceMap.put(key, instanceBean);// 将对象放入实例map中
	}

	/**
	 * 权力和工作流对应的实例节点数据数量 统计
	 * 
	 * @param mapData geshuo 20161224
	 */
	@Override
	public void powerWorkFlowNodeDataAudit(Map<String, Object> mapData) {
		String wfId = String.valueOf(mapData.get("dcaWfId"));
		String powerId = String.valueOf(mapData.get("dcaPowerId"));
		String taskId = String.valueOf(mapData.get("dcaTaskId"));// 工作流的节点id；dca
		String taskName = String.valueOf(mapData.get("dcaTaskName"));// 工作流的节点名称；dca
		String key = MD5Util.getMD5Str(wfId + powerId + taskId);// 工作流id+权力id + 工作流的节点id 作为key
		AuditDataBean dataBean;

		// 判断数据是否存在
		if (Objects.isNull(auditDataMap.get(key))) {
			// 不存在，创建新对象
			dataBean = new AuditDataBean();
			dataBean.setWfId(wfId);
			dataBean.setPowerId(powerId);
			dataBean.setTaskId(taskId);
			dataBean.setTaskName(taskName);
			logger.debug(
					"a new data is added --> wfId = " + wfId + " ; powerId = " + powerId + " ; taskId = " + taskId);
		} else {
			// 数据存在，实例数+1
			dataBean = auditDataMap.get(key);
			logger.debug(
					"an exist data is added --> wfId = " + wfId + " ; powerId = " + powerId + " ; taskId = " + taskId);
		}
		dataBean.setDataCount(dataBean.getDataCount() + 1);// 实例节点的业务数据 数量+1
		auditDataMap.put(key, dataBean);// 将对象放入 实例节点的业务数据map 中
	}

	/**
	 * 插入统计数据
	 */
	@Override
	public void save() {
		Date createDate = new Date();

		saveInstanceCount(createDate);//保存实例统计数据

		saveDataCount(createDate);//保存节点统计数据
	}

	/**
	 * 保存实例统计数据
	 */
	private void saveInstanceCount(Date createDate){
		if(MapUtils.isEmpty(auditInstanceMap)){
			return;
		}
		// 解析实例数据
		List<Map<String, Object>> instanceList = new ArrayList<>();
		auditInstanceMap.forEach((key, instanceBean) -> {
			Map<String, Object> instanceMap = new HashMap<String, Object>();
			try {
				instanceMap.put("uuid", GenUUID.uuid());// 主键
				instanceMap.put("wfId", instanceBean.getWfId());
				instanceMap.put("powerId", instanceBean.getPowerId());
				instanceMap.put("instanceCount", instanceBean.getInstanceCount());
				instanceMap.put("instanceNodeCount", instanceBean.getInstanceNodeCount());
				instanceMap.put("createDate", createDate);
				instanceMap.put("updateDate", createDate);
				instanceMap.put("createPerson", ENGINE);
				instanceMap.put("updatePerson", ENGINE);
				instanceList.add(instanceMap);// 放到实例数组中，用于插入
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("解析实例统计数据异常:" + e.fillInStackTrace());
			}
		});

		Map<String, Object>[] instanceArray = new HashMap[instanceList.size()];
		instanceList.toArray(instanceArray);

		// 插入实例统计数据
		extractDataDao.insertBatchPowerInstance(instanceArray);
		logger.debug("batch insert power instance");

		// 清空数据
		auditInstanceMap.clear();
	}

	/**
	 * 保存节点数据
	 * @param createDate
	 */
	private void saveDataCount(Date createDate){
		if(MapUtils.isEmpty(auditDataMap)){
			return;
		}

		// 解析实例的节点业务数据
		List<Map<String, Object>> dataList = new ArrayList<>();
		auditDataMap.forEach((key, dataBean) -> {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			try {
				dataMap.put("uuid", GenUUID.uuid());// 主键
				dataMap.put("wfId", dataBean.getWfId());
				dataMap.put("powerId", dataBean.getPowerId());
				dataMap.put("taskId", dataBean.getTaskId());
				dataMap.put("taskName", dataBean.getTaskName());
				dataMap.put("dataCount", dataBean.getDataCount());
				dataMap.put("createDate",createDate);
				dataMap.put("createPerson", ENGINE);
				dataMap.put("updateDate",createDate);
				dataMap.put("updatePerson", ENGINE);
				dataList.add(dataMap);// 放到实例的节点业务数据 数组中，用于插入
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("解析实例节点的业务数据统计异常:" + e.fillInStackTrace());
			}
		});

		Map<String, Object>[] dataArray = new HashMap[dataList.size()];
		dataList.toArray(dataArray);

		// 插入实例节点的业务数据统计 数据
		extractDataDao.insertBatchPowerBizData(dataArray);
		logger.debug("batch insert power biz data");

		auditDataMap.clear();
	}

	private class AuditInstanceBean {

		private String wfId;// 工作流id；dca

		private String powerId;// 权力id；dca

		private Integer instanceCount = 0;// 实例 数量

		private Integer instanceNodeCount = 0;// 实例节点数量

		public String getWfId() {
			return wfId;
		}

		public void setWfId(String wfId) {
			this.wfId = wfId;
		}

		public String getPowerId() {
			return powerId;
		}

		public void setPowerId(String powerId) {
			this.powerId = powerId;
		}

		public Integer getInstanceNodeCount() {
			return instanceNodeCount;
		}

		public void setInstanceNodeCount(Integer instanceNodeCount) {
			this.instanceNodeCount = instanceNodeCount;
		}

		public Integer getInstanceCount() {
			return instanceCount;
		}

		public void setInstanceCount(Integer instanceCount) {
			this.instanceCount = instanceCount;
		}
	}

	private class AuditDataBean {

		private String wfId;// 工作流id；dca

		private String powerId;// 权力id；dca

		private String taskId;// 节点id；dca

		private String taskName;// 节点名称 dca

		private Integer dataCount = 0;// 节点业务数据数量

		public String getWfId() {
			return wfId;
		}

		public void setWfId(String wfId) {
			this.wfId = wfId;
		}

		public String getPowerId() {
			return powerId;
		}

		public void setPowerId(String powerId) {
			this.powerId = powerId;
		}

		public String getTaskId() {
			return taskId;
		}

		public void setTaskId(String taskId) {
			this.taskId = taskId;
		}

		public String getTaskName() {
			return taskName;
		}

		public void setTaskName(String taskName) {
			this.taskName = taskName;
		}

		public Integer getDataCount() {
			return dataCount;
		}

		public void setDataCount(Integer dataCount) {
			this.dataCount = dataCount;
		}
	}

}
