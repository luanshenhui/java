package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.ClearingDetail;

/**
 * 结算详细
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:14:38
 */
@Repository
public class SettlementDetailDao extends SqlSessionDaoSupport {
	public List<ClearingDetail> queryForDay(Map<String, Object> params) {
		return getSqlSession().selectList("queryForDay", params);
	}
}
