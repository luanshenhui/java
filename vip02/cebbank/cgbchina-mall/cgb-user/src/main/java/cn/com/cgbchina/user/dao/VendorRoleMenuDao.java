package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.VendorRoleMenuModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorRoleMenuDao extends SqlSessionDaoSupport {

	public Integer update(VendorRoleMenuModel vendorRoleMenuModel) {
		return getSqlSession().update("VendorRoleMenu.update", vendorRoleMenuModel);
	}

	public Integer insert(Map<String, Object> map) {
		return getSqlSession().insert("VendorRoleMenu.insert", map);
	}

	public List<VendorRoleMenuModel> findAll() {
		return getSqlSession().selectList("VendorRoleMenu.findAll");
	}

	public VendorRoleMenuModel findById(Long id) {
		return getSqlSession().selectOne("VendorRoleMenu.findById", id);
	}

	public Pager<VendorRoleMenuModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorRoleMenu.count", params);
		if (total == 0) {
			return Pager.empty(VendorRoleMenuModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorRoleMenuModel> data = getSqlSession().selectList("VendorRoleMenu.pager", paramMap);
		return new Pager<>(total, data);
	}

	public Integer delete(Map<String, Object> map) {
		return getSqlSession().delete("VendorRoleMenu.delete", map);
	}

	public List<Long> getMenuByRoleId(List<Long> roleIds) {
		return getSqlSession().selectList("VendorRoleMenu.getMenuByRoleId", roleIds);
	}

	public Integer deleteByRoleId(Long roleId) {
		return getSqlSession().delete("VendorRoleMenu.deleteByRoleId", roleId);
	}
}