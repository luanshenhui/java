package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralRoadRescue;

/**
 * 车主卡道路救援积分兑换
 * 
 * @author huangcy on 2016年5月11日
 */
@Repository
public class RoadServeIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralRoadRescue> getRoadServeIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("RoadServeIntegralDaoImpl.findRoadServeIntegrals", params);
	}

}
