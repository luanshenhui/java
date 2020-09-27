package cn.com.cgbchina.batch.dao;

import java.util.Map;
import java.util.List;

import org.mybatis.spring.support.SqlSessionDaoSupport;

import cn.com.cgbchina.batch.model.MemberAmount;

/**
 * 商城会员统计数
 * 
 * @author xiewl
 * @version 2016年5月31日 下午3:12:36
 */
public class MemberAmountDao extends SqlSessionDaoSupport {

	public List<MemberAmount> queryForMutilDays(Map<String, Object> params) {
		return getSqlSession().selectList("queryForMutilDays", params);
	}
}
