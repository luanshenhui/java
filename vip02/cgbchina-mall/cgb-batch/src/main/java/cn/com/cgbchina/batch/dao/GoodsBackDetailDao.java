package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.GoodsBackDetail;

/**
 * 退货细节数据层
 * 
 * @author xiewl
 * @version 2016年5月12日 上午10:17:21
 */
@Repository
public class GoodsBackDetailDao extends SqlSessionDaoSupport {

	public List<GoodsBackDetail> queryForMutil(Map<String, Object> params) {
		return getSqlSession().selectList("queryForMutil", params);
	}
}
