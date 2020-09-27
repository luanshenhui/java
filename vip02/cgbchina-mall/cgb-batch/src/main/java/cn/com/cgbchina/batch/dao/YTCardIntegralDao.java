package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralYTCard;

/**
 * 人保粤通卡积分兑换
 * 
 * @author huangcy on 2016年5月11日
 */
@Repository
public class YTCardIntegralDao extends SqlSessionDaoSupport {

	public List<IntegralYTCard> getYTCardIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("YTCardIntegralDaoImpl.findYTCardIntegrals", params);
	}

}
