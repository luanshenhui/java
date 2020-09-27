package cn.com.cgbchina.batch.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.IntegralGiftCode;

/**
 * 录入组赠品代码积分兑换
 * 
 * @author huangcy on 2016年5月10日
 */
@Repository
public class GoodsCodeIntegralDao extends SqlSessionDaoSupport {
	public List<IntegralGiftCode> getGoodsCodeIntegral(Map<String, Object> params) {
		return getSqlSession().selectList("GiftCodeIntegralDaoImpl.findGoodsCodeIntegrals", params);
	}
}
