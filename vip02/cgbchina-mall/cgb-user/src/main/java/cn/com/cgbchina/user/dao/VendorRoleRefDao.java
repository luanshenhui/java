package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.dto.UserRoleDto;
import cn.com.cgbchina.user.model.VendorRoleRefModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorRoleRefDao extends SqlSessionDaoSupport {

	public Integer update(VendorRoleRefModel vendorRoleRefModel) {
		return getSqlSession().update("VendorRoleRefModel.update", vendorRoleRefModel);
	}

	public Integer insert(VendorRoleRefModel vendorRoleRefModel) {
		return getSqlSession().insert("VendorRoleRefModel.insert", vendorRoleRefModel);
	}

	public List<VendorRoleRefModel> findAll() {
		return getSqlSession().selectList("VendorRoleRefModel.findAll");
	}

	public VendorRoleRefModel findById(Long id) {
		return getSqlSession().selectOne("VendorRoleRefModel.findById", id);
	}

	public Pager<VendorRoleRefModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorRoleRefModel.", params);
		if (total == 0) {
			return Pager.empty(VendorRoleRefModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorRoleRefModel> data = getSqlSession().selectList("VendorRoleRefModel.pager", paramMap);
		return new Pager<VendorRoleRefModel>(total, data);
	}

	public Integer delete(VendorRoleRefModel vendorRoleRefModel) {
		return getSqlSession().delete("VendorRoleRefModel.delete", vendorRoleRefModel);
	}

	public List<Long> getRoleIdByUserId(String id) {
		return getSqlSession().selectList("VendorRoleRefModel.getRoleIdByUserId", id);
	}

	public Integer roleExists(Long id) {
		return getSqlSession().selectOne("VendorRoleRefModel.roleExists", id);
	}

	public Integer insertUserRole(UserRoleDto userRoleDto) {
		return getSqlSession().insert("VendorRoleRefModel.insertUserRole", userRoleDto);
	}

	public Integer deleteUserRole(Map<String, Object> map) {
		return getSqlSession().delete("VendorRoleRefModel.deleteUserRole", map);
	}

    public List<String> findByIdList(List<Integer> roleId) {
        return getSqlSession().selectList("VendorRoleRefModel.findByIdList", roleId);
    }

}