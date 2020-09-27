package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.StagesReqCash;

/**
 * 分期请款数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:13:31
 */
@Repository
public class StagesAskForDao extends SqlSessionDaoSupport {
	public List<StagesReqCash> queryStageReqCashForDay(Map<String, Object> params) {
		return getSqlSession().selectList("StagesAskForDaoImpl.findStageReqCashOfDay", params);
	}
}
