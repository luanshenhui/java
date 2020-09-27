package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.XnlpZQBXModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class XnlpZQBXDao extends SqlSessionDaoSupport {

	public List<XnlpZQBXModel> findZQBXByCertAndCard(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpZQBXModel.findZQBXByCertAndCard", params);
	}

	public List<XnlpZQBXModel> findByNo(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpZQBXModel.findByNo",params);
	}
}