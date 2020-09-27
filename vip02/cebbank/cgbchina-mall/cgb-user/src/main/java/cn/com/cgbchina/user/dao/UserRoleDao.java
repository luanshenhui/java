package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.model.UserRoleModel;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class UserRoleDao extends SqlSessionDaoSupport {

	public Integer update(UserRoleModel userRole) {
		return getSqlSession().update("UserRoleModel.update", userRole);
	}

	public Integer insert(UserRoleModel userRole) {
		return getSqlSession().insert("UserRoleModel.insert", userRole);
	}

	public List<UserRoleModel> findAll() {
		return getSqlSession().selectList("UserRoleModel.findAll");
	}

	public UserRoleModel findById(Long id) {
		return getSqlSession().selectOne("UserRoleModel.findById", id);
	}

	public Integer delete(UserRoleModel userRole) {
		return getSqlSession().delete("UserRoleModel.delete", userRole);

	}

	public List<Long> getRoleIdByUserId(String userId) {
		return getSqlSession().selectList("UserRoleModel.getRoleIdByUserId", userId);
	}

    public List<String> findByIdList(List<Integer> roleId) {
        return getSqlSession().selectList("UserRoleModel.findByIdList", roleId);
    }

	public Integer insertUserRole(UserRoleDto userRoleDto) {
		return getSqlSession().insert("UserRoleModel.insertUserRole", userRoleDto);
	}

	public Integer deleteUserRole(Map<String, Object> map) {
		return getSqlSession().delete("UserRoleModel.deleteUserRole", map);
	}

	public Integer roleExists(Long id) {
		return getSqlSession().selectOne("UserRoleModel.roleExists", id);
	}
}