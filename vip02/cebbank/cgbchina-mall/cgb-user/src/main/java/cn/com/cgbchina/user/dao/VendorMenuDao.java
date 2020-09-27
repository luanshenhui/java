package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.VendorMenuModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorMenuDao extends SqlSessionDaoSupport {

	public Integer update(VendorMenuModel vendorMenuModel) {
		return getSqlSession().update("VendorMenu.update", vendorMenuModel);
	}

	public Integer insert(VendorMenuModel vendorMenuModel) {
		return getSqlSession().insert("VendorMenu.insert", vendorMenuModel);
	}

	public List<VendorMenuModel> findAll() {
		return getSqlSession().selectList("VendorMenu.findAll");
	}

	public VendorMenuModel findById(Long id) {
		return getSqlSession().selectOne("VendorMenuModel.findById", id);
	}

	public Pager<VendorMenuModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorMenu.count", params);
		if (total == 0) {
			return Pager.empty(VendorMenuModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorMenuModel> data = getSqlSession().selectList("VendorMenu.pager", paramMap);
		return new Pager<VendorMenuModel>(total, data);
	}

	public Integer delete(VendorMenuModel vendorMenuModel) {
		return getSqlSession().delete("VendorMenu.delete", vendorMenuModel);
	}

	public List<VendorMenuModel> findChildById(Long id) {
		return getSqlSession().selectList("VendorMenu.findChildById", id);
	}

	public List<VendorMenuModel> getAllResources() {
		return getSqlSession().selectList("VendorMenu.getAllResources");
	}
}