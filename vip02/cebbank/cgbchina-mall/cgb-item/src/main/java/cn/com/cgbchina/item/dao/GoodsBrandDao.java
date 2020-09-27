package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsBrandModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsBrandDao extends SqlSessionDaoSupport {

	public Integer update(GoodsBrandModel goodsBrandModel) {
		return getSqlSession().update("GoodsBrandModel.update", goodsBrandModel);
	}

	public Integer insert(GoodsBrandModel goodsBrandModel) {
		return getSqlSession().insert("GoodsBrandModel.insert", goodsBrandModel);
	}

	public List<GoodsBrandModel> findAll() {
		return getSqlSession().selectList("GoodsBrandModel.findAll");
	}

	public List<GoodsBrandModel> findAllBrandsSpecial(Map<String, Object> params) {
		return getSqlSession().selectList("GoodsBrandModel.findAllBrandsSpecial", params);
	}

	public GoodsBrandModel findById(Long id) {
		return getSqlSession().selectOne("GoodsBrandModel.findById", id);
	}

	public Pager<GoodsBrandModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("GoodsBrandModel.count", params);
		if (total == 0) {
			return Pager.empty(GoodsBrandModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<GoodsBrandModel> data = getSqlSession().selectList("GoodsBrandModel.pager", paramMap);
		return new Pager<GoodsBrandModel>(total, data);
	}

	/**
	 * 查询品牌数量
	 * @param params
	 * @return
	 * geshuo 20160710
	 */
	public Long findBrandCountByParam(Map<String, Object> params){
		return getSqlSession().selectOne("GoodsBrandModel.count", params);
	}

	public Boolean delete(Long id) {
		return getSqlSession().delete("GoodsBrandModel.delete", id) == 1;
	}

	/**
	 * 根据brandId取得品牌名称
	 *
	 * @param id
	 * @return
	 * @author tanliang
	 * @since 2016-4-22
	 */
	public GoodsBrandModel findBrandInfoById(Long id) {
		return getSqlSession().selectOne("GoodsBrandModel.findBrandInfoById", id);
	}

	/**
	 * 根据品牌名称 取得信息
	 *
	 * @param params 查询条件 增加 ordertypeId 业务ID的条件
	 * @return
	 * @author tanliang
	 */
	public GoodsBrandModel findBrandIdByName(Map<String, Object> params) {
		return getSqlSession().selectOne("GoodsBrandModel.findBrandIdByName", params);
	}

	/**
	 * 校验品牌名称
	 * @param goodsBrandModel
	 * @return
	 */
	public GoodsBrandModel checkBrandName(GoodsBrandModel goodsBrandModel){
		return getSqlSession().selectOne("GoodsBrandModel.checkBrandName", goodsBrandModel);
	}

	/**
	 * 根据品牌名称 模糊查询brandId
	 *
	 * @param brandName
	 * @return
	 */
	public List<Long> findBrandIdListByName(String brandName) {
		return getSqlSession().selectList("GoodsBrandModel.findBrandIdListByName", brandName);
	}

	/**
	 * 新增品牌
	 *
	 * @return id
	 */
	public Long insertReturnId(GoodsBrandModel goodsBrandModel) {
		getSqlSession().insert("GoodsBrandModel.insert", goodsBrandModel);
		return goodsBrandModel.getId();
	}

	/**
	 * 查询所有品牌的名字和品牌模糊查询（产品用）
	 *
	 * @param params
	 * @param limit
	 * @return add by TanLiang
	 */
	public Pager<GoodsBrandModel> findByPages(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("GoodsBrandModel.counts", params);
		if (total == 0) {
			return Pager.empty(GoodsBrandModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<GoodsBrandModel> data = getSqlSession().selectList("GoodsBrandModel.pagers", paramMap);
		return new Pager<GoodsBrandModel>(total, data);
	}

	public List<GoodsBrandModel> findByIds(Iterable<Long> ids) {
		return getSqlSession().selectList("GoodsBrandModel.findByIds", ids);
	}

	public List<GoodsBrandModel> findBrandListByName(Map<String, Object> paramMap) {
		return getSqlSession().selectList("GoodsBrandModel.findBrandByParam", paramMap);
	}
}