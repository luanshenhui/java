package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.XnlpCZBXModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class XnlpCZBXDao extends SqlSessionDaoSupport {

	public List<XnlpCZBXModel> findCZBXByCertAndCard(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpCZBXModel.findCZBXByCertAndCard", params);
	}

	public List<XnlpCZBXModel> findByNo(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpCZBXModel.findByNo",params);
	}

}