package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.dto.VendorInfoIdDto;
import cn.com.cgbchina.user.model.VendorInfoModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class VendorInfoDao extends SqlSessionDaoSupport {

	public Integer update(VendorInfoModel vendorInfoModel) {
		return getSqlSession().update("VendorInfo.update", vendorInfoModel);
	}

	/**
	 * 根据vendorId做逻辑删除
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer update(String vendorId) {
		return getSqlSession().update("VendorInfo.updateById", vendorId);
	}

	public Integer insert(VendorInfoModel vendorInfoModel) {
		return getSqlSession().insert("VendorInfo.insert", vendorInfoModel);
	}

	public List<VendorInfoModel> findAll(VendorInfoModel vendorInfoModel) {
		return getSqlSession().selectList("VendorInfo.findAll",vendorInfoModel);
	}

	public List<VendorInfoModel> findAllVendor(Map<String, Object> params) {
		return getSqlSession().selectList("VendorInfo.findAllVendor", params);
	}

	public List<String> findIdByName(String simpleName) {
		return getSqlSession().selectList("VendorInfo.findIdByName", simpleName);
	}

	public VendorInfoModel findById(String vendorId) {
		return getSqlSession().selectOne("VendorInfo.findById", vendorId);
	}

	public VendorInfoModel findByVendorId(String vendorId) {
		return getSqlSession().selectOne("VendorInfo.findByVendorId", vendorId);
	}

	public Pager<VendorInfoModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("VendorInfo.countLike", params);
		if (total == 0) {
			return Pager.empty(VendorInfoModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorInfoModel> data = getSqlSession().selectList("VendorInfo.pager", paramMap);
		return new Pager<VendorInfoModel>(total, data);
	}

	public Integer delete(VendorInfoModel vendorInfoModel) {
		return getSqlSession().delete("VendorInfo.delete", vendorInfoModel);
	}

	/**
	 * 根据供应商名称模糊查询
	 * 
	 * @param vendorName
	 * @return
	 */
	public List<String> findVendorInfoByVendorName(String vendorName) {
		return getSqlSession().selectList("VendorInfo.findVendorInfoByVendorName", vendorName);
	}

	/**
	 * 根据Id校验
	 * 
	 * @param vendorId
	 * @return
	 */
	public VendorInfoModel checkById(String vendorId) {
		return getSqlSession().selectOne("VendorInfo.checkById", vendorId);
	}

	/**
	 * 根据vendorId列表查询
	 * 
	 * @param vendorIds
	 * @return
	 */
	public List<VendorInfoModel> findByVendorIds(List<String> vendorIds) {
		return getSqlSession().selectList("VendorInfo.findByVendorIds", vendorIds);
	}

	public List<VendorInfoIdDto> findVenDtoByName(String name) {
		return getSqlSession().selectList("VendorInfo.findVenDtoByName", name);
	}

	public List<VendorInfoIdDto> findVenDtoByVendorIds(List<String> list) {
		return getSqlSession().selectList("VendorInfo.findVenDtoByVendorIds", list);
	}
	/**
	 * 根据vendorId查询信息
	 *
	 * @param params
	 * @return
	 */
	public List<String> findVendorInfoByVendorId(Map<String, Object> params) {
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		return getSqlSession().selectList("VendorInfo.findVendorInfoByVendorId", paramMap);
	}

	public VendorInfoModel findVendorInfosByVendorId(String vendor_Id) {
		return getSqlSession().selectOne("VendorInfo.findVendorInfosByVendorId", vendor_Id);
	}

	public List<VendorInfoModel> findVendorInfoByVendorIds(List<String> vendorIdsList) {
		return getSqlSession().selectList("VendorInfo.findVendorInfoByVendorIds", vendorIdsList);
	}

	public VendorInfoModel findInfoByConditions(String vendor_Id) {
		return getSqlSession().selectOne("VendorInfo.findInfoByConditions", vendor_Id);
	}

	public VendorInfoModel findVendorRoleByConditions(String vendor_Id) {
		return getSqlSession().selectOne("VendorInfo.findVendorRoleByConditions", vendor_Id);
	}

	/**
	 * 查询需要推送的数量
	 * @param vendorIdList 供应商id列表
	 * @return 数量
	 *
	 * geshuo 20160824
	 */
	public Long findNeedActionCount(List<String> vendorIdList){
		return getSqlSession().selectOne("VendorInfo.findNeedActionCount", vendorIdList);
	}
	public List<VendorInfoModel> findByVendorIdsForBrandAuth(List<String> vendorIds){
		return getSqlSession().selectList("VendorInfo.findByVendorIdsForBrandAuth",vendorIds);
	}
}