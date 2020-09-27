package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.CommonGiftSaleDetail;

/**
 * 每日普通礼品销售详细数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:25:05
 */
@Repository
public class CommonGiftSaleDetailForDayDao extends SqlSessionDaoSupport {

	public List<CommonGiftSaleDetail> queryForDay(Map<String, Object> params) {
		return getSqlSession().selectList("queryForDay", params);
	}
}
