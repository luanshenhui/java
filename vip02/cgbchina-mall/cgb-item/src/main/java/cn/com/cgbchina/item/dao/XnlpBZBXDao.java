package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.XnlpBZBXModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class XnlpBZBXDao extends SqlSessionDaoSupport {

	public List<XnlpBZBXModel> findBZBXByCertAndCard(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpBZBXModel.findBZBXByCertAndCard", params);
	}

	public List<XnlpBZBXModel> findByNo(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpBZBXModel.findByNo",params);
	}
}