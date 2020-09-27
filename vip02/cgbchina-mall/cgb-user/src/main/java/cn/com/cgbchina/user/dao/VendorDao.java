package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.user.dto.VendorInfoDto;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.user.model.VendorModel;

@Repository
public class VendorDao extends SqlSessionDaoSupport {

	public Integer update(VendorModel vendorModel) {
		return getSqlSession().update("Vendor.update", vendorModel);
	}
    public Integer updateAll(VendorModel vendorModel) {
        return getSqlSession().update("Vendor.updateAll", vendorModel);
    }
	/**
	 * 根据vendorId做逻辑删除
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer update(String vendorId) {
		return getSqlSession().update("Vendor.updateById", vendorId);
	}

	/**
	 * 根据vendorId修改审核状态
	 *
	 * @param vendorId
	 * @return
	 */

	public Integer vendorCheck(String vendorId) {
		return getSqlSession().update("Vendor.vendorCheck", vendorId);
	}

	public Integer insert(VendorModel vendorModel) {
		return getSqlSession().insert("Vendor.insert", vendorModel);
	}

	public List<VendorModel> findAll() {
		return getSqlSession().selectList("Vendor.findAll");
	}

	public VendorModel findById(Long id) {
		return getSqlSession().selectOne("Vendor.findById", id);
	}
    public VendorModel findByNameCode(String code) {
        return getSqlSession().selectOne("Vendor.findByNameCode",code);
    }

	/**
	 * 根据供应商id查询父id
	 *
	 * @param vendorId
	 * @return
	 */
	public Long findParIdByVenId(String vendorId) {
		return getSqlSession().selectOne("Vendor.findParIdByVenId", vendorId);
	}

	/**
	 * 根据供应商ID停用该供应商下所有子帐号
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer updateByParentId(String vendorId) {
		return getSqlSession().update("Vendor.updateByParentId", vendorId);
	}

	/**
	 * 根据供应商Id删除子帐号
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer deleteByParentId(String vendorId) {
		return getSqlSession().update("Vendor.deleteByParentId", vendorId);
	}

	public Pager<VendorModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("Vendor.countLike", params);
		if (total == 0) {
			return Pager.empty(VendorModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorModel> data = getSqlSession().selectList("Vendor.pager", paramMap);
		return new Pager<VendorModel>(total, data);
	}

	public Pager<VendorModel> findByParentId(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("Vendor.accountTotal", params);
		if (total == 0) {
			return Pager.empty(VendorModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<VendorModel> data = getSqlSession().selectList("Vendor.findByParentId", paramMap);
		return new Pager<VendorModel>(total, data);
	}

	public VendorModel findByVendorId(String vendorId) {
		return getSqlSession().selectOne("Vendor.findByVendorId", vendorId);
	}

	public VendorModel findByVendorCode(String code) {
		return getSqlSession().selectOne("Vendor.findByVendorCode", code);
	}

	public Integer delete(VendorModel vendorModel) {
		return getSqlSession().delete("Vendor.delete", vendorModel);
	}

	/**
	 * 登录成功后 跟新密码
	 *
	 * @param vendorModel
	 * @return
	 */
	public Integer updatePwdByCode(VendorModel vendorModel) {
		return getSqlSession().update("Vendor.updatePwdByCode", vendorModel);
	}

	/**
	 * 供应商用户账号管理 启用未启用状态修改
	 *
	 * @param vendorModel
	 * @return
	 */
	public Integer changeStatus(VendorModel vendorModel) {
		return getSqlSession().update("Vendor.changeStatus", vendorModel);
	}

	/**
	 * 根据code校验
	 *
	 * @param vendorCode
	 * @return
	 */
	public VendorModel checkByCode(String vendorCode) {
		return getSqlSession().selectOne("Vendor.checkByCode", vendorCode);
	}

	/**
	 * 查询主帐号的信息
	 *
	 * @param vendorModel
	 * @return
	 */
	public VendorModel findVendor(VendorModel vendorModel) {
		return getSqlSession().selectOne("Vendor.findVendor", vendorModel);
	}

	/**
	 * 查询主账号信息forListbyId
	 * @return
	 */
	public List<VendorModel> findVendorByListId(List<String> vendorList){
		return getSqlSession().selectList("Vendor.findVendorByListId",vendorList);
	}
}