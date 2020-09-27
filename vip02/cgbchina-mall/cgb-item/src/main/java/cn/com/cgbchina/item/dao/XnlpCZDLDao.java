package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.XnlpCZDLModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class XnlpCZDLDao extends SqlSessionDaoSupport {

	public List<XnlpCZDLModel> findCZDLByCertAndCard(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpCZDLModel.findCZDLByCertAndCard", params);
	}

	public List<XnlpCZDLModel> findByNo(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpCZDLModel.findByNo",params);
	}

}