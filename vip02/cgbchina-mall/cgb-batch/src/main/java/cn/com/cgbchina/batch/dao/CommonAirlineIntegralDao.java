package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

import cn.com.cgbchina.batch.model.IntegralCommonAirline;

/**
 * 普通积分兑换报表（南航里程） 数据层
 * 
 * @author huangcy on 2016年6月3日
 */
public class CommonAirlineIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralCommonAirline> getCommonAirline(Map<String, Object> params) {
		return getSqlSession().selectList("CommonAirlineIntegralDaoImpl.findCommonAirlines", params);
	}

}
