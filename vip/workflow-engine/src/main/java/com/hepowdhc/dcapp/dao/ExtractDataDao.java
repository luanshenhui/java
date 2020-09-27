package com.hepowdhc.dcapp.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.hepowdhc.dcapp.bean.MapperBean;
import com.hepowdhc.dcapp.engine.instance.Instance;
import com.hepowdhc.dcapp.utils.GenUUID;

/**
 * 抽取数据dao
 *
 * geshuo 20161219
 */
@Repository
public class ExtractDataDao extends BaseDao {

	@Autowired
	@Qualifier("extract_data")
	private MapperBean dataMapper;

	@Autowired
	@Qualifier("find_user_role")
	private MapperBean userRoleMapper;

	@Autowired
	@Qualifier("dca_workflow")
	private MapperBean workFlowMapper;

	@Autowired
	@Qualifier("dca_alarm_detail")
	private MapperBean alarmMapper;

	@Autowired
	@Qualifier("dca_risk_manage")
	private MapperBean riskMapper;

	@Autowired
	@Qualifier("extract_oa_data_by_wf_id")
	private MapperBean oaDataMapper;

	@Autowired
	@Qualifier("dca_power_instance_count")
	private MapperBean powerInstanceMapper;

	@Autowired
	@Qualifier("dca_power_biz_data_count")
	private MapperBean powerBizDataMapper;

	@Autowired
	@Qualifier("dca_phy_instance_index_update")
	private MapperBean oaIndexUpdateMapper;

	@Autowired
	@Qualifier("dca_phy_instance_detail_update")
	private MapperBean oaDataUpdateMapper;
	
	@Autowired
	@Qualifier("dca_alarm_detail_update")
	private MapperBean alarmUpdateMapper;

	@Autowired
	@Qualifier("hr_work_holiday_select")
	private MapperBean workHolidayMapper;

	@Autowired
	@Qualifier("hr_work_holiday_exception_select")
	private MapperBean holidayMapper;

	@Autowired
	@Qualifier("dca_workflow_compute_result")
	private MapperBean computeResultMapper;

	/**
	 * 抽取所有 dca&oa 系统数据
	 * 
	 * @return 查询结果
	 * @throws Exception
	 *
	 *             geshuo 20161219
	 */
	public List<Map<String, Object>> findAllBusinessData() throws Exception {
		logger.debug(
				"抽取所有 dca&oa 系统数据 ExtractDataDao.findAllBusinessData start------------->" + dataMapper.getFields());
		String sql = dataMapper.getSqls().get("select");
		List<Map<String, Object>> mapList = query(sql, dataMapper);
		logger.debug("抽取所有 dca&oa 系统数据 ExtractDataDao.findAllBusinessData end ------------->" + new Date());
		return mapList;

	}

	/**
	 * 查询所有用户岗位数据
	 * 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> findUserRoleList() {
		logger.debug("查询所有用户岗位数据 ExtractDataDao.findUserRoleList start ------------->" + userRoleMapper.getFields());
		String sql = userRoleMapper.getSqls().get("select");
		List<Map<String, Object>> userRoleList = query(sql, userRoleMapper);
		logger.debug("查询所有用户岗位数据 ExtractDataDao.findUserRoleList end ------------->" + new Date());
		return userRoleList;
	}

	/**
	 * 查询所有工作流数据 （dca流程图）
	 * 
	 * @return
	 */
	public List<Map<String, Object>> findAllWorkFlow() {
		logger.debug(
				"查询所有工作流数据 （dca流程图）ExtractDataDao.findAllWorkFlow start ------------->" + workFlowMapper.getFields());
		String sql = workFlowMapper.getSqls().get("select");
		List<Map<String, Object>> workFlowList = query(sql, workFlowMapper);
		logger.debug("查询所有工作流数据 （dca流程图） end ------------->" + new Date());
		return workFlowList;
	}

	/**
	 * 插入风险数据
	 */
	public void insertRisk(Map<String, Object> riskMap) {
		logger.debug("插入风险数据 ExtractDataDao.insertRisk start ------------->" + riskMapper.getFields());
		String sql = riskMapper.getSqls().get("insertRisk");
		insert(sql, riskMap, riskMapper);
		logger.debug("插入风险数据 end ");
	}

	/**
	 * 插入预警数据
	 */
	public void insertAlarm(Map<String, Object> alarmMap) {
		logger.debug("插入预警数据 ExtractDataDao.insertAlarm start ------------->" + alarmMapper.getFields());
		String sql = alarmMapper.getSqls().get("insertAlarm");
		insert(sql, alarmMap, alarmMapper);
		logger.debug("插入预警数据 end");
	}
	
	
	/**
	 * 批量插入风险数据
	 */
	public void insertRiskList(Map<String, Object>[] params) {
		logger.debug("批量插入风险数据 ExtractDataDao.insertRiskList start ------------->" + riskMapper.getFields());
		String sql = riskMapper.getSqls().get("insertRiskList");
		batchInsert(sql, params, riskMapper);
		logger.debug("批量插入风险数据 end ------------->" + new Date());
	}

	/**
	 * 批量插入预警数据
	 */
	public void insertAlarmList(Map<String, Object>[] params) {
		logger.debug("批量插入预警数据 ExtractDataDao.insertAlarmList start ------------->" + alarmMapper.getFields());
		String sql = alarmMapper.getSqls().get("insertAlarmList");
		batchInsert(sql, params, alarmMapper);
		logger.debug("批量插入预警数据 end ------------->" + new Date());
	}

	/**
	 * 根据工作流id查询业务数据 （oa数据）
	 * 
	 * @return
	 */
	public List<Map<String, Object>> findOADataByWfId(String wfId) {
		logger.debug("根据工作流id查询业务数据 ExtractDataDao.findOADataByWfId start ------------->" + oaDataMapper.getFields());
		String sql = oaDataMapper.getSqls().get("select");
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("wfId", wfId);
		List<Map<String, Object>> instanceList = queryByParams(sql, oaDataMapper, paramMap);
		logger.debug("根据工作流id查询业务数据 end ------------->" + new Date());
		return instanceList;
	}

	@Autowired
	@Qualifier("dca_biz_instance_by_id")
	private MapperBean instanceSelectMapper;

	@Autowired
	@Qualifier("dca_biz_instance_insert")
	private MapperBean instanceInsertMapper;

	@Autowired
	@Qualifier("dca_biz_node_log_insert")
	private MapperBean nodeLogInsertMapper;

	@Autowired
	@Qualifier("dca_biz_instance_update")
	private MapperBean instanceUpdateMapper;

	/**
	 * 根据实例id查询实例数据 （dca数据）
	 * 
	 * @return
	 */
	public List<Map<String, Object>> findInstanceByInstanceId(String bizInstanceId) {
		logger.debug("根据实例id查询实例数据 （dca数据） ExtractDataDao.findInstanceByInstanceId start ------------->"
				+ instanceSelectMapper.getFields());
		String sql = instanceSelectMapper.getSqls().get("select");
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("bizInstanceId", bizInstanceId);// 实例id
		List<Map<String, Object>> instanceList = queryByParams(sql, instanceSelectMapper, paramMap);
		logger.debug("根据实例id查询实例数据 （dca数据） end ------------->" + new Date());
		return instanceList;
	}

	/**
	 * 插入实例数据
	 * 
	 * @return
	 */
	public void insertSingleBizInstance(Instance instance) {
		logger.debug("插入单个实例数据 ExtractDataDao.insertSingleBizInstance start ------------->"
				+ instanceInsertMapper.getFields());
		// 构造插入数据
		Map<String, Object> instanceMap = new HashMap<>();
		instanceMap.put("uuid", GenUUID.uuid());
		instanceMap.put("bizInstanceId", instance.getInstanceId());
		instanceMap.put("bizInstanceName", instance.getInstanceName());
		instanceMap.put("wfId", instance.getFlowId());
		instanceMap.put("powerId", instance.getPowerId());
		instanceMap.put("instanceStartTime",instance.getStartTime());

		String sql = instanceInsertMapper.getSqls().get("insertBizInstance");
		insert(sql, instanceMap, instanceInsertMapper);
		logger.debug("插入单个实例数据 end ------------->" + new Date());
	}

	/**
	 * 插入实例数据
	 * 
	 * @return
	 */
	public void insertBizInstance(Map<String, Object>[] instanceMapArray) {
		logger.debug("插入实例数据 ExtractDataDao.insertBizInstance start ------------->" + instanceInsertMapper.getFields());
		String sql = instanceInsertMapper.getSqls().get("insertBizInstance");
		batchInsert(sql, instanceMapArray, instanceInsertMapper);
		logger.debug("插入实例数据 end ------------->" + new Date());
	}

	/**
	 * 插入实例节点数据
	 * 
	 * @return
	 */
	public void insertBizNodeLog(Map<String, Object> nodeMap) {
		logger.debug("插入实例节点数据 ExtractDataDao.insertBizNodeLog start ------------->" + nodeLogInsertMapper.getFields());
		String sql = nodeLogInsertMapper.getSqls().get("insertBizNodeLog");
		insert(sql, nodeMap, nodeLogInsertMapper);
		logger.debug("插入实例节点数据 end ------------->" + new Date());
	}

	/**
	 * 更新实例数据处理状态
	 * 
	 * @return
	 */
	public void updateBizInstanceById(String bizInstanceId) {
		logger.debug("更新实例数据处理状态 ExtractDataDao.updateBizInstanceById start ------------->"
				+ instanceUpdateMapper.getFields());
		String sql = instanceUpdateMapper.getSqls().get("updateInstanceById");

		// 构造参数
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("bizInstanceId", bizInstanceId);

		// 执行更新
		update(sql, paramMap);
		logger.debug("更新实例数据处理状态 updateBizInstanceById end ------------->" + new Date());
	}

	/**
	 * 插入 权力实例统计表
	 * 
	 * @return
	 */
	public void insertPowerInstanceCount(Map<String, Object> powerInstanceMap) {
		logger.debug("插入 权力实例统计数据 ExtractDataDao.insertPowerInstanceCount start ------------->"
				+ powerInstanceMapper.getFields());
		String sql = powerInstanceMapper.getSqls().get("insert");
		insert(sql, powerInstanceMap, powerInstanceMapper);
		logger.debug("插入 权力实例统计数据 end ------------->" + new Date());
	}

	/**
	 * 插入 权力业务数据统计表
	 * 
	 * @return
	 */
	public void insertPowerBizDataCount(Map<String, Object> powerBizDataMap) {
		logger.debug(
				"插入 权力业务数据统计 数据 ExtractDataDao.insertPowerBizDataCount start -->" + powerBizDataMapper.getFields());
		String sql = powerBizDataMapper.getSqls().get("insert");
		insert(sql, powerBizDataMap, powerBizDataMapper);
		logger.debug("插入 权力业务数据统计数据 end ------------->" + new Date());
	}

	/**
	 * 批量插入 权力实例统计表
	 * 
	 * @return
	 */
	public void insertBatchPowerInstance(Map<String, Object>[] mapArray) {
		logger.debug(
				"批量插入 权力实例统计数据 ExtractDataDao.insertBatchPowerInstance start -->" + powerInstanceMapper.getFields());
		String sql = powerInstanceMapper.getSqls().get("insert");
		batchInsert(sql, mapArray, powerInstanceMapper);
		logger.debug("批量插入 权力实例统计数据 end ------------->" + new Date());
	}

	/**
	 * 批量插入 权力业务数据统计表
	 * 
	 * @return
	 */
	public void insertBatchPowerBizData(Map<String, Object>[] mapArray) {
		logger.debug(
				"批量插入 权力业务数据统计数据 ExtractDataDao.insertBatchPowerBizData start -->" + powerBizDataMapper.getFields());
		String sql = powerBizDataMapper.getSqls().get("insert");
		batchInsert(sql, mapArray, powerBizDataMapper);
		logger.debug("批量插入 权力业务数据统计数据 end ------------->" + new Date());
	}

	/**
	 * 更新oa实例处理状态
	 *
	 * @return
	 */
	public void updateOaInstanceById(String oaInstanceId) {
		logger.debug("更新oa实例处理状态 ExtractDataDao.updateOaInstanceById start ------------->"
				+ oaIndexUpdateMapper.getFields());
		String sql = oaIndexUpdateMapper.getSqls().get("update");

		// 构造参数
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("oaInstanceId", oaInstanceId);

		// 执行更新
		update(sql, paramMap);
		logger.debug("更新oa实例处理状态 updateOaInstanceById end ");
	}

	/**
	 * 更新oa实例数据处理状态
	 *
	 * @return
	 */
	public void updateOaDataById(String oaDataId) {
		logger.debug("更新oa实例数据处理状态 ExtractDataDao.updateOaDataById start ------------->"
				+ oaDataUpdateMapper.getFields());
		String sql = oaDataUpdateMapper.getSqls().get("update");

		// 构造参数
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("oaDataId", oaDataId);

		// 执行更新
		update(sql, paramMap);
		logger.debug("更新oa实例数据处理状态 updateOaDataById end ");
	}
	
	/**
	 * 更新节点告警状态，变为已消警
	 * @param bizDataIdList
	 * @author geshuo
	 * @date 2017年1月10日
	 */
	public void updateAlarmByDataIdList(List<String> bizDataIdList){
		logger.debug("更新节点告警状态，变为已消警 ExtractDataDao.updateAlarmByDataId start ------------->"
				+ alarmUpdateMapper.getFields());
		//参数类型转为数组
		Map[] paramArray = new Map[bizDataIdList.size()];
		
		for(int i = 0,len = bizDataIdList.size();i < len;i++){
			Map<String,Object> mapItem = new HashMap<>();
			mapItem.put("bizDataId", bizDataIdList.get(i));
			paramArray[i] = mapItem;
		}
		
		String sql = alarmUpdateMapper.getSqls().get("update");
		// 执行更新
		batchUpdate(sql, paramArray, alarmUpdateMapper);
		
		logger.debug("更新节点告警状态，变为已消警updateAlarmByDataId end ");
	}

	/**
	 * 查询正常周末休息日
	 * @return
	 * geshuo
	 * 20170111
	 */
	public Map<String,Object> findNormalWeekends(){
		logger.debug("查询正常周末ExtractDataDao.findNormalWeekends start ------------->" + workHolidayMapper.getFields());
		String sql = workHolidayMapper.getSqls().get("select");
		Map<String, Object> workHolidayMap = queryForMap(sql, workHolidayMapper, new HashMap<>());

		logger.debug("查询正常周末 end ");
		return workHolidayMap;
	}

	/**
	 * 查询节假日数据
	 * @return
	 *
	 * geshuo
	 * 20170111
	 */
	public List<Map<String,Object>> findHolidays(){
		logger.debug("查询节假日数据 ExtractDataDao.findHolidays start ------------->" + holidayMapper.getFields());
		String sql = holidayMapper.getSqls().get("select");

		List<Map<String,Object>> holidayList = query(sql, holidayMapper);

		logger.debug("查询节假日数据 end ");
		return holidayList;
	}

	/**
	 * 批量插入 工作流运算结果表
	 *
	 * @return
	 */
	public void insertComputeResult(Map<String, Object>[] mapArray) {
		logger.debug(
				"批量插入工作流运算结果表 ExtractDataDao.insertComputeResult start -->" + computeResultMapper.getFields());
		String sql = computeResultMapper.getSqls().get("insert");
		batchInsert(sql, mapArray, computeResultMapper);
		logger.debug("批量插入工作流运算结果表 end ");
	}
}
