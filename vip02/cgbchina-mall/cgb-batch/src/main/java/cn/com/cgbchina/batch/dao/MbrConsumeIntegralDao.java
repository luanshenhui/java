package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralMbrConsume;

/**
 * 积分兑换周报表（ALL常旅客会员消费）
 * 
 * @author huangcy on 2016年5月11日
 */
@Repository
public class MbrConsumeIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralMbrConsume> getMbrConsumeIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("MbrConsumeIntegralDaoImpl.findMbrConsumeIntegrals", params);
	}

}
