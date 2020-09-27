package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.VendorMessageModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorMessageDao extends SqlSessionDaoSupport {

	public Integer update(VendorMessageModel vendorMessageModel) {
		return getSqlSession().update("VendorMessage.update", vendorMessageModel);
	}

	public Integer insert(VendorMessageModel vendorMessageModel) {
		return getSqlSession().insert("VendorMessage.insert", vendorMessageModel);
	}

	public List<VendorMessageModel> findAll() {
		return getSqlSession().selectList("VendorMessage.findAll");
	}

	public VendorMessageModel findById(Long id) {
		return getSqlSession().selectOne("VendorMessage.findById", id);
	}

	public Pager<VendorMessageModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorMessage.count", params);
		if (total == 0) {
			return Pager.empty(VendorMessageModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorMessageModel> data = getSqlSession().selectList("VendorMessage.pager", paramMap);
		return new Pager<VendorMessageModel>(total, data);
	}

	public Integer delete(VendorMessageModel vendorMessageModel) {
		return getSqlSession().delete("VendorMessage.delete", vendorMessageModel);
	}

	public Long findNewCount(Map<String, Object> params) {
		return getSqlSession().selectOne("VendorMessage.findNewCount", params);
	}

	public Integer readAllMessage(Map<String, Object> params){
		return getSqlSession().update("VendorMessage.readAllMessage", params);
	}

	public Integer readMessage(String id){
		return getSqlSession().update("VendorMessage.readMessage", id);
	}
}