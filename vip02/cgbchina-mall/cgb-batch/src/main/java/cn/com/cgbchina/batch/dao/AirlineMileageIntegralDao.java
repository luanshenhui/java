package cn.com.cgbchina.batch.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralAirlineMileage;

/**
 * 南航里程积分兑换
 * 
 * @author huangcy
 */
@Repository
public class AirlineMileageIntegralDao extends SqlSessionDaoSupport {
	public List<IntegralAirlineMileage> queryAirlineIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("AirlineMileageIntegralDaoImpl.findAirlineIntegrals", params);
	}
}
