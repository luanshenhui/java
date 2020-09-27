package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.VendorTranscorpModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorTranscorpDao extends SqlSessionDaoSupport {

	public Integer update(VendorTranscorpModel vendorTranscorpModel) {
		return getSqlSession().update("VendorTranscorp.update", vendorTranscorpModel);
	}

	public Integer insert(VendorTranscorpModel vendorTranscorpModel) {
		return getSqlSession().insert("VendorTranscorp.insert", vendorTranscorpModel);
	}

	public List<VendorTranscorpModel> findAll() {
		return getSqlSession().selectList("VendorTranscorp.findAll");
	}

	public VendorTranscorpModel findById(Long id) {
		return getSqlSession().selectOne("VendorTranscorp.findById", id);
	}

	public Pager<VendorTranscorpModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorTranscorp.count", params);
		if (total == 0) {
			return Pager.empty(VendorTranscorpModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorTranscorpModel> data = getSqlSession().selectList("VendorTranscorp.pager", paramMap);
		return new Pager<VendorTranscorpModel>(total, data);
	}

	public Integer delete(VendorTranscorpModel vendorTranscorpModel) {
		return getSqlSession().delete("VendorTranscorp.delete", vendorTranscorpModel);
	}
}