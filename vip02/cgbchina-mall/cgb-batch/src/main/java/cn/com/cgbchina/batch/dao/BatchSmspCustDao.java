package cn.com.cgbchina.batch.dao;

import cn.com.cgbchina.batch.model.BatchSmspCustModel;
import cn.com.cgbchina.batch.model.IntegralAirlineMileage;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 南航里程积分兑换
 * 
 * @author huangcy
 */
@Repository
public class BatchSmspCustDao extends SqlSessionDaoSupport {
	public List<BatchSmspCustModel> findSmspCustInfo(Map<String, Object> paramMap, int offset, int limit) {
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		return getSqlSession().selectList("BatchSmspCustModel.findSmspCustInfo", paramMap);
	}
}
