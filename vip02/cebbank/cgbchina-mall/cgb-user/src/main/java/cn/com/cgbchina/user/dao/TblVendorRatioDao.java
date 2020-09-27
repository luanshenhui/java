package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.user.model.TblVendorRatioModel;

@Repository
public class TblVendorRatioDao extends SqlSessionDaoSupport {

	public Integer update(TblVendorRatioModel tblVendorRatio) {
		return getSqlSession().update("TblVendorRatioModel.update", tblVendorRatio);
	}

	public Integer insert(TblVendorRatioModel tblVendorRatio) {
		return getSqlSession().insert("TblVendorRatioModel.insert", tblVendorRatio);
	}

	public List<TblVendorRatioModel> findAll() {
		return getSqlSession().selectList("TblVendorRatioModel.findAll");
	}

	public TblVendorRatioModel findById(Long id) {
		return getSqlSession().selectOne("TblVendorRatioModel.findById", id);
	}

	public Pager<TblVendorRatioModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblVendorRatioModel.count", params);
		if (total == 0) {
			return Pager.empty(TblVendorRatioModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblVendorRatioModel> data = getSqlSession().selectList("TblVendorRatioModel.pager", paramMap);
		return new Pager<TblVendorRatioModel>(total, data);
	}

	public Integer delete(TblVendorRatioModel tblVendorRatio) {
		return getSqlSession().delete("TblVendorRatioModel.delete", tblVendorRatio);
	}

	public List<TblVendorRatioModel> findVendorRatioInfo(Map<String, Object> params) {
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		List<TblVendorRatioModel> data = getSqlSession().selectList("TblVendorRatioModel.findVendorRatioInfo",
				paramMap);
		return data;
	}

	/**
	 * 根据供应商id查询比率信息
	 * 
	 * @param vendorId
	 * @return
	 */
	public List<TblVendorRatioModel> findRaditListByVendorId(String vendorId) {
		return getSqlSession().selectList("TblVendorRatioModel.findRaditListByVendorId", vendorId);
	}

	// 逻辑删除分期费率
	public Integer updateForDelete(Long id) {
		return getSqlSession().update("TblVendorRatioModel.updateForDelete", id);
	}

	/**
	 * 供应商编辑查询分期费率
	 * 
	 * @param vendorId
	 * @return
	 */
	public List<TblVendorRatioModel> findStageByVendorId(String vendorId) {
		return getSqlSession().selectList("TblVendorRatioModel.findStageByVendorId", vendorId);
	}
}