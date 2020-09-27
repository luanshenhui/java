package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.AdminRoleMenuModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AdminRoleMenuDao extends SqlSessionDaoSupport {

	public Integer update(AdminRoleMenuModel adminRoleMenu) {
		return getSqlSession().update("AdminRoleMenuModel.update", adminRoleMenu);
	}

	public Integer insert(Map<String, Object> map) {
		return getSqlSession().insert("AdminRoleMenuModel.insert", map);
	}

	public List<AdminRoleMenuModel> findAll() {
		return getSqlSession().selectList("AdminRoleMenuModel.findAll");
	}

	public AdminRoleMenuModel findById(Long id) {
		return getSqlSession().selectOne("AdminRoleMenuModel.findById", id);
	}

	public Pager<AdminRoleMenuModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("AdminRoleMenuModel.count", params);
		if (total == 0) {
			return Pager.empty(AdminRoleMenuModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<AdminRoleMenuModel> data = getSqlSession().selectList("AdminRoleMenuModel.pager", paramMap);
		return new Pager<AdminRoleMenuModel>(total, data);
	}

	public Integer delete(Map<String, Object> map) {
		return getSqlSession().update("AdminRoleMenuModel.delete", map);
	}

	public List<Long> getMenuByRoleId(List<Long> roleId) {
		return getSqlSession().selectList("AdminRoleMenuModel.getMenuByRoleId", roleId);
	}

	public Integer deleteByRoleId(Long roleId) {
		return getSqlSession().update("AdminRoleMenuModel.deleteByRoleId", roleId);
	}
}