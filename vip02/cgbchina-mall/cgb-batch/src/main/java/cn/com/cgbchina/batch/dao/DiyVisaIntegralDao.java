package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;

import cn.com.cgbchina.batch.model.IntegralDiyVisa;

/**
 * 积分兑换（DIY卡免还款签账额）
 * 
 * @author huangcy on 2016年6月3日
 */
public class DiyVisaIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralDiyVisa> getDiyVisaIntegrals(Map<String, Object> params) {
		return getSqlSession().selectList("DiyVisaIntegralDaoImpl.findDiyVisaIntegrals", params);
	}

}
