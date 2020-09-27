package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

import cn.com.cgbchina.batch.model.IntegralSmartCard;

/**
 * @author huangcy on 2016年6月3日
 */
public class SmartCardIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralSmartCard> getSmartCardIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("SmartCardIntegralDaoImpl.findSmartCardIntegrals", params);
	}

}
