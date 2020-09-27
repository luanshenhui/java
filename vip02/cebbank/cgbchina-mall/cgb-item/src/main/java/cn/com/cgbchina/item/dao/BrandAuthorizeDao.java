package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class BrandAuthorizeDao extends SqlSessionDaoSupport {

	public Integer update(BrandAuthorizeModel brandAuthorizeModel) {
		return getSqlSession().update("BrandAuthorizeModel.update", brandAuthorizeModel);
	}

	public Integer insert(BrandAuthorizeModel brandAuthorizeModel) {
		return getSqlSession().insert("BrandAuthorizeModel.insert", brandAuthorizeModel);
	}

	public List<BrandAuthorizeModel> findAll() {
		return getSqlSession().selectList("BrandAuthorizeModel.findAll");
	}

	public BrandAuthorizeModel findById(Long id) {
		return getSqlSession().selectOne("BrandAuthorizeModel.findById", id);
	}

	public Pager<BrandAuthorizeModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("BrandAuthorizeModel.count", params);
		if (total == 0) {
			return Pager.empty(BrandAuthorizeModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<BrandAuthorizeModel> data = getSqlSession().selectList("BrandAuthorizeModel.pager", paramMap);
		return new Pager<BrandAuthorizeModel>(total, data);
	}

	/**
	 * 查找所有品牌授权信息
	 */
	public Pager<BrandAuthorizeModel> findByPageQuery(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("BrandAuthorizeModel.count", params);
		if (total == 0) {
			return Pager.empty(BrandAuthorizeModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<BrandAuthorizeModel> data = getSqlSession().selectList("BrandAuthorizeModel.pagerQuery", paramMap);
		return new Pager<BrandAuthorizeModel>(total, data);
	}

	public Integer delete(BrandAuthorizeModel brandAuthorizeModel) {
		return getSqlSession().delete("BrandAuthorizeModel.delete", brandAuthorizeModel);
	}

	/**
	 * 查找需要审核的品牌的个数 add by zhangc
	 *
	 * @return 个数
	 */
	public Integer findBrandCount() {
		return getSqlSession().selectOne("BrandAuthorizeModel.findBrandCount");
	}

	/**
	 * 查询所有品牌信息（供应商新增商品时用）
	 *
	 * @return
	 * @Add by chenle
	 */
	public List<BrandAuthorizeModel> findBrandListForVendor(Map<String, Object> params) {
		return getSqlSession().selectList("BrandAuthorizeModel.findBrandListForVendor", params);
	}

	/**
	 *
	 * @param brandName
	 * @return
	 */
	public BrandAuthorizeModel findIsAuthroizeByName(String brandName, String orderType) {
		BrandAuthorizeModel brandAuthorizeModel = new BrandAuthorizeModel();
		brandAuthorizeModel.setBrandName(brandName);
		brandAuthorizeModel.setOrdertypeId(orderType);
		return getSqlSession().selectOne("BrandAuthorizeModel.findIsAuthroizeByName", brandAuthorizeModel);
	}

	/**
	 * 删除前再次确认是否被使用确保一致性
	 * @param brandId
	 * @return
	 */
	public BrandAuthorizeModel findIsAuthroizeById(Long brandId) {
		return  getSqlSession().selectOne("BrandAuthorizeModel.findIsAuthroizeById", brandId);
	}

	public BrandAuthorizeModel findBrandAuthorizeByVendorId(String brandName,String vendorId){
		Map<String,Object> params = Maps.newHashMap();
		params.put("brandName",brandName);
		params.put("vendorId",vendorId);
		return getSqlSession().selectOne("BrandAuthorizeModel.findBrandAuthorizeByVendorId",params);
	}
	/**
	 * 更新品牌授权表所有该品牌
	 */
	public Integer updateAll(BrandAuthorizeModel brandAuthorizeModel) {
		return getSqlSession().update("BrandAuthorizeModel.updateAll", brandAuthorizeModel);
	}

	public List<BrandAuthorizeModel> checkAuthroizeCan(String brandname, String ordertypeId) {
		Map<String,Object> paramMap = new HashMap<String ,Object>();
		paramMap.put("brandName",brandname);
		paramMap.put("ordertypeId",ordertypeId);
		return getSqlSession().selectList("BrandAuthorizeModel.checkAuthroizeCan", paramMap);
	}
}