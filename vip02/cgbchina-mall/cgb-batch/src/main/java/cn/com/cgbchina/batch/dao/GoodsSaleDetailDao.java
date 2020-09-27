package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.GoodsSaleDetail;

/**
 * 商品销售明细数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:16:39
 */
@Repository
public class GoodsSaleDetailDao extends SqlSessionDaoSupport {
	public List<GoodsSaleDetail> queryGoodsSaleDetailForDay(Map<String, Object> params) {
		return getSqlSession().selectList("queryGoodsSaleDetailForDay", params);
	}

	public List<GoodsSaleDetail> queryGoodsSaleDetailForMutil(Map<String, Object> params) {
		return getSqlSession().selectList("queryGoodsSaleDetailForMutil", params);
	}
}
