package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.XnlpLXSYModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class XnlpLXSYDao extends SqlSessionDaoSupport {

	public List<XnlpLXSYModel> findLXSYByCert(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpLXSYModel.findLXSYByCert", params);
	}

	public List<XnlpLXSYModel> findByNo(Map<String, Object> params) {
		return getSqlSession().selectList("XnlpLXSYModel.findByNo",params);
	}
}