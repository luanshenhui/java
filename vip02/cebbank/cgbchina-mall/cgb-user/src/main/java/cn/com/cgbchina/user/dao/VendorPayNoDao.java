package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorPayNoModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorPayNoDao extends SqlSessionDaoSupport {

	public Integer update(VendorPayNoModel vendorPayNoModel) {
		return getSqlSession().update("VendorPayNo.update", vendorPayNoModel);
	}

	public Integer insert(VendorPayNoModel vendorPayNoModel) {
		return getSqlSession().insert("VendorPayNo.insert", vendorPayNoModel);
	}

	public List<VendorPayNoModel> findAll() {
		return getSqlSession().selectList("VendorPayNo.findAll");
	}

	public VendorPayNoModel findById(Long id) {
		return getSqlSession().selectOne("VendorPayNo.findById", id);
	}

	public Pager<VendorPayNoModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorPayNo.count", params);
		if (total == 0) {
			return Pager.empty(VendorPayNoModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorPayNoModel> data = getSqlSession().selectList("VendorPayNo.pager", paramMap);
		return new Pager<VendorPayNoModel>(total, data);
	}

	public Integer delete(VendorPayNoModel vendorPayNoModel) {
		return getSqlSession().delete("VendorPayNo.delete", vendorPayNoModel);
	}

	public List<VendorPayNoModel> findVendorPayNoInfo(Map<String, Object> params) {
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		List<VendorPayNoModel> data = getSqlSession().selectList("VendorPayNo.findVendorPayNoInfo", paramMap);
		return data;
	}
}