package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.item.model.PromotionModel;

@Repository
public class PromotionDao extends SqlSessionDaoSupport {

	public Integer update(PromotionModel promotion) {
		return getSqlSession().update("PromotionModel.update", promotion);
	}

	public Integer insert(PromotionModel promotion) {
		return getSqlSession().insert("PromotionModel.insert", promotion);
	}

	public List<PromotionModel> findAll() {
		return getSqlSession().selectList("PromotionModel.findAll");
	}

	public PromotionModel findById(Integer id) {
		return getSqlSession().selectOne("PromotionModel.findById", id);
	}

	public Pager<PromotionModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionModel.count", params);
		if (total == 0) {
			return Pager.empty(PromotionModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionModel> data = getSqlSession().selectList("PromotionModel.pager", paramMap);
		return new Pager<PromotionModel>(total, data);
	}

	public Pager<PromotionModel> findBySelectNamePage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionModel.countBySelectName", params);
		if (total == 0) {
			return Pager.empty(PromotionModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionModel> data = getSqlSession().selectList("PromotionModel.pagerBySelectName", paramMap);
		return new Pager<PromotionModel>(total, data);
	}

	public Pager<PromotionModel> findBySelectNameForAdminPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("PromotionModel.countBySelectNameForAdmin", params);
		if (total == 0) {
			return Pager.empty(PromotionModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<PromotionModel> data = getSqlSession().selectList("PromotionModel.pagerBySelectNameForAdmin", paramMap);
		return new Pager<PromotionModel>(total, data);
	}

	public Integer delete(PromotionModel promotion) {
		return getSqlSession().delete("PromotionModel.delete", promotion);
	}

	public Pager<PromotionModel> findByAdminPage(Map<String, Object> params) {
		Long total = getSqlSession().selectOne("PromotionModel.adminPageCount", params);
		if (total == 0) {
			return Pager.empty(PromotionModel.class);
		}
		List<PromotionModel> data = getSqlSession().selectList("PromotionModel.adminPage", params);
		return new Pager<>(total, data);
	}

	public PromotionModel vendorFindByCode(String promCode) {
		return getSqlSession().selectOne("PromotionModel.vendorFindByCode", promCode);
	}

	public Integer insertAdminPromotion(PromotionModel promotionModel) {
		return getSqlSession().insert("PromotionModel.adminAdd", promotionModel);
	}

	public Integer updateAdminPromotion(PromotionModel promotionModel) {
		return getSqlSession().update("PromotionModel.adminUpdate", promotionModel);
	}

	public PromotionModel findSeckillPromById(Map<String, Object> params) {
		return getSqlSession().selectOne("PromotionModel.findSeckillPromById", params);
	}

	public Integer updateCheckStatus(Map<String, Object> map) {
		return getSqlSession().update("PromotionModel.updateCheckStatus", map);
	}

	public Integer updateCheckStatusForVendor(Map<String, Object> map) {
		return getSqlSession().update("PromotionModel.updateCheckStatusForVendor", map);
	}

	public List<PromotionModel> findByPromIds(Map<String, Object> params) {
		return getSqlSession().selectList("PromotionModel.findByPromIds", params);
	}

	public List<PromotionModel> findPromotionByIds(List<Integer> promotionIds) {
		return getSqlSession().selectList("PromotionModel.findPromotionByIds", promotionIds);
	}

	public List<PromotionModel> findCheckManager(Map<String, Object> queryMap) {
		return getSqlSession().selectList("PromotionModel.checkManager", queryMap);
	}

	public List<PromotionModel> findDoubleCheckManager(Map<String, Object> queryMap) {
		return getSqlSession().selectList("PromotionModel.doubleCheckManager", queryMap);
	}

	public Integer offAndDelete(Map<String, Object> map) {
		return getSqlSession().update("PromotionModel.offAndDelete", map);
	}

	public Integer checkManagerCount(Map<String, Object> map) {
		return getSqlSession().selectOne("PromotionModel.checkManagerCount", map);
	}

	public Integer doubleCheckManagerCount(Map<String, Object> map) {
		return getSqlSession().selectOne("PromotionModel.doubleCheckManagerCount", map);
	}

	// 获取供应商当前正在参加活动的promotionIdlist集合
	public List<Integer> findPromotionIds(Map<String, Object> paramMap) {
		return getSqlSession().selectList("PromotionModel.findPromotionIds", paramMap);
	}

	/**
	 * 查询当前有效的活动
	 * 
	 * @param paramMap 查询参数
	 * @return 返回结果
	 *
	 *         geshuo 20160807
	 */
	public List<Integer> findAvailablePromotionIds(Map<String, Object> paramMap) {
		return getSqlSession().selectList("PromotionModel.findAvailablePromotionIds", paramMap);
	}

	/**
	 * 获取最近一场已经结束的活动
	 *
	 * @param paramMap 查询参数
	 * @return 返回结果
	 *         <p>
	 *         geshuo 20160723
	 */
	public PromotionModel findLastPromotion(Map<String, Object> paramMap) {
		return getSqlSession().selectOne("PromotionModel.findLastPromotion", paramMap);
	}

	/**
	 * 根据参数查询活动列表
	 *
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *         <p>
	 *         geshuo 20160723
	 */
	public List<PromotionModel> findPromotionByParams(Map<String, Object> paramMap) {
		return getSqlSession().selectList("PromotionModel.findPromotionByParams", paramMap);
	}

	public Integer updateOffLine(Map<String, Object> map) {
		return getSqlSession().update("PromotionModel.updateOffLine", map);
	}

	public List<Integer> findAvaliable(Map<String, Object> map) {
		return getSqlSession().selectList("PromotionModel.findAvaliable", map);
	}

	public List<Integer> getRidOfIds(List<Integer> list) {
		return getSqlSession().selectList("PromotionModel.getRidOfIds", list);
	}

	public PromotionModel findPromStatistics(Integer param) {
		return getSqlSession().selectOne("PromotionModel.findPromStatisticsById", param);
	}

	/**
	 * 根据活动列表和类型查询活动
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160906
	 */
	public List<PromotionModel> findByIdListAndType(Map<String,Object> paramMap){
		return getSqlSession().selectList("PromotionModel.findByIdListAndType", paramMap);
	}
	public Long findWorkPromByIds(List<Integer> ids){
		return getSqlSession().selectOne("PromotionModel.findWorkPromByIds",ids);
	}
}