package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.dto.AdminRoleDto;
import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.dto.VendorRoleDto;
import cn.com.cgbchina.user.model.VendorRoleModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorRoleDao extends SqlSessionDaoSupport {

	public Integer update(VendorRoleModel vendorRoleModel) {
		return getSqlSession().update("VendorRole.update", vendorRoleModel);
	}

	public Integer insert(VendorRoleModel vendorRoleModel) {
		return getSqlSession().insert("VendorRole.insert", vendorRoleModel);
	}

	public List<VendorRoleModel> findAll() {
		return getSqlSession().selectList("VendorRole.findAll");
	}

	public VendorRoleModel findById(Long id) {
		return getSqlSession().selectOne("VendorRole.findById", id);
	}

	public Pager<VendorRoleModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorRole.count", params);
		if (total == 0) {
			return Pager.empty(VendorRoleModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorRoleModel> data = getSqlSession().selectList("VendorRole.pager", paramMap);
		return new Pager<>(total, data);
	}

	public Integer delete(Long id) {
		return getSqlSession().delete("VendorRole.delete", id);
	}

	public Long duplicateCheck(String name) {
		return getSqlSession().selectOne("VendorRole.duplicateCheck", name);
	}

	public Integer updateRole(Map<String, Object> map) {
		return getSqlSession().update("VendorRole.updateRole", map);
	}

	public List<VendorRoleDto> allEnabledRoleDtos(Map<String, Object> map) {
		return getSqlSession().selectList("VendorRole.allEnabledRoleDtos", map);
	}

    public List<VendorRoleDto> getRoleByRoleIds(List<Long> roleIds) {
        return getSqlSession().selectList("VendorRole.getRoleByRoleIds", roleIds);
    }

    public List<Integer> findByName(String name) {
        return getSqlSession().selectList("VendorRole.findByName",name);
    }

    public Integer insertUserRole(UserRoleDto userRoleDto) {
        return getSqlSession().insert("VendorRole.insertVendorRole", userRoleDto);
    }

    public Integer deleteVendorRole(Map<String, Object> map) {
        return getSqlSession().delete("VendorRole.deleteVendorRole", map);
    }
}