package cn.com.cgbchina.batch.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralPlatinumAF;

/**
 * 白金卡年费积分兑换
 * 
 * @author huangcy on 2016年5月11日
 */
@Repository
public class PlatinumAFIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralPlatinumAF> getPlatinumAFIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("PlatinumAFIntegralDaoImpl.findPlatinumAFIntegrals", params);
	}

}
