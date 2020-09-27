package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.user.model.ShopinfOutsystemModel;

@Repository
public class ShopinfOutsystemDao extends SqlSessionDaoSupport {

	public Integer update(ShopinfOutsystemModel shopinfOutsystemModel) {
		return getSqlSession().update("ShopinfOutsystem.update", shopinfOutsystemModel);
	}

	public Integer insert(ShopinfOutsystemModel shopinfOutsystemModel) {
		return getSqlSession().insert("ShopinfOutsystem.insert", shopinfOutsystemModel);
	}

	public List<ShopinfOutsystemModel> findAll() {
		return getSqlSession().selectList("ShopinfOutsystem.findAll");
	}

	public ShopinfOutsystemModel findById(Long id) {
		return getSqlSession().selectOne("ShopinfOutsystem.findById", id);
	}

	public Pager<ShopinfOutsystemModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ShopinfOutsystem.count", params);
		if (total == 0) {
			return Pager.empty(ShopinfOutsystemModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ShopinfOutsystemModel> data = getSqlSession().selectList("ShopinfOutsystem.pager", paramMap);
		return new Pager<ShopinfOutsystemModel>(total, data);
	}

	public Integer delete(ShopinfOutsystemModel shopinfOutsystemModel) {
		return getSqlSession().delete("ShopinfOutsystem.delete", shopinfOutsystemModel);
	}

	public ShopinfOutsystemModel findMallKey() {
		return getSqlSession().selectOne("ShopinfOutsystem.findMallKey");
	}

	public ShopinfOutsystemModel findByVendorId(String vendorId) {
		return getSqlSession().selectOne("ShopinfOutsystem.findByVendorId", vendorId);
	}

	public ShopinfOutsystemModel findByOutSysId(String outSysId) {
		return getSqlSession().selectOne("ShopinfOutsystem.findByOutSysId", outSysId);
	}

	public ShopinfOutsystemModel findInfoById(Long id) {
		return getSqlSession().selectOne("ShopinfOutsystem.findInfoById", id);
	}
}