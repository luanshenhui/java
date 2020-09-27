package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.dto.AdminRoleDto;
import cn.com.cgbchina.user.model.AdminRoleModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AdminRoleDao extends SqlSessionDaoSupport {

	public Integer update(AdminRoleModel role) {
		return getSqlSession().update("AdminRole.update", role);
	}

	public Integer insert(AdminRoleModel role) {
		return getSqlSession().insert("AdminRole.insert", role);
	}

	public List<AdminRoleModel> findAll() {
		return getSqlSession().selectList("AdminRole.findAll");
	}

	public AdminRoleModel findById(Long id) {
		return getSqlSession().selectOne("AdminRole.findById", id);
	}

	public Pager<AdminRoleModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("AdminRole.count", params);
		if (total == 0) {
			return Pager.empty(AdminRoleModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<AdminRoleModel> data = getSqlSession().selectList("AdminRole.pager", paramMap);
		return new Pager<AdminRoleModel>(total, data);
	}

	public Integer delete(Long role) {
		return getSqlSession().delete("AdminRole.delete", role);
	}

	public Long duplicateCheck(String name) {
		return getSqlSession().selectOne("AdminRole.duplicateCheck", name);
	}

	public Integer updateRole(Map<String, Object> map) {
		return getSqlSession().update("AdminRole.updateRole", map);
	}

	public List<AdminRoleDto> getRoleByRoleIds(List<Long> roleIds) {
		return getSqlSession().selectList("AdminRole.getRoleByRoleIds", roleIds);
	}

	public List<AdminRoleDto> allEnabledRoleDtos() {
		return getSqlSession().selectList("AdminRole.allEnabledRoleDtos");
	}

	public Integer logicDelete(Long id) {
		return getSqlSession().update("AdminRole.logicDelete", id);
	}

    public List<Integer> findByName(String name) {
        return getSqlSession().selectList("AdminRole.findByName",name);
    }
}