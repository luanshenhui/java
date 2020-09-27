package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.StageReturnGoods;

/**
 * 分期退货明细数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:12:33
 */
@Repository
public class StagesBackDetailDao extends SqlSessionDaoSupport {

	public List<StageReturnGoods> queryForDay(Map<String, Object> params) {
		return getSqlSession().selectList("queryForDay", params);
	}

	public List<StageReturnGoods> queryForWeek(Map<String, Object> params) {
		return getSqlSession().selectList("queryForWeek", params);
	}

	public List<StageReturnGoods> queryForMonth(Map<String, Object> params) {
		return getSqlSession().selectList("queryForMonth", params);
	}
}
