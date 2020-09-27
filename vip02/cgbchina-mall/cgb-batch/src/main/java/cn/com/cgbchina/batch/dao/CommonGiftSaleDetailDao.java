package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.CommonGiftSaleDetail;

/**
 * 普通礼品销售统计数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:26:21
 */
@Repository
public class CommonGiftSaleDetailDao extends SqlSessionDaoSupport {
	public List<CommonGiftSaleDetail> queryForMutil(Map<String, Object> params) {
		return getSqlSession().selectList("queryForMutil", params);
	}
}
