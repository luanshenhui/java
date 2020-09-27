package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralInsurance;

/**
 * 保险类积分兑换报表Dao层
 * 
 * @author huangcy on 2016年5月10日
 */
@Repository
public class InsuranceIntegralDao extends SqlSessionDaoSupport {
	public List<IntegralInsurance> getInsuranceIntegrals(Map<String, Object> params) {
		return getSqlSession().selectList("InsuranceIntegralDaoImpl.findInsuranceIntegrals", params);
	}
}
