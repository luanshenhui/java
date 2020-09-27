package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.VendorSaleStatistics;

/**
 * 商户销售统计数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:11:23
 */
@Repository
public class VendorSaleStatisticsDao extends SqlSessionDaoSupport {

	public List<VendorSaleStatistics> querySaleStatisticsForDay(Map<String, Object> params) {
		return getSqlSession().selectList("querySaleStatisticsForDay", params);
	}

	public List<VendorSaleStatistics> querySaleStatisticsForMutil(Map<String, Object> params) {
		return getSqlSession().selectList("querySaleStatisticsForMutil", params);
	}
}
