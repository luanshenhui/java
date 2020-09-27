package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralLinkCard;

/**
 * 联通卡积分兑换
 * 
 * @author huangcy on 2016年5月10日
 */
@Repository
public class LinkedCardIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralLinkCard> getLinkedCardIntegrals(Map<String, Object> params) {
		return getSqlSession().selectList("LinkedCardIntegralDaoImpl.finkLinkedCardIntegrals", params);
	}

}
