package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.MemberBrowseHistory;

/**
 * 会员足迹 数据层
 * 
 * @author huangcy on 2016年5月31日
 */
@Repository
public class MemberBrowseHisDao extends SqlSessionDaoSupport {
	public List<MemberBrowseHistory> queryBrowseHistories(Map<String, Object> params) {
		return getSqlSession().selectList("MemberBrowseHisDaoImpl.findBrowseHistories", params);
	}
}
