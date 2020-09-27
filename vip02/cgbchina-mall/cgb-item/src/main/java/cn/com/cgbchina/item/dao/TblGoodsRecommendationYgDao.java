package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblGoodsRecommendationYgDao extends SqlSessionDaoSupport {

	public Integer update(TblGoodsRecommendationYgModel tblGoodsRecommendationYg) {
		return getSqlSession().update("TblGoodsRecommendationYgModel.update", tblGoodsRecommendationYg);
	}

	public Integer insert(TblGoodsRecommendationYgModel tblGoodsRecommendationYg) {
		return getSqlSession().insert("TblGoodsRecommendationYgModel.insert", tblGoodsRecommendationYg);
	}

	public List<TblGoodsRecommendationYgModel> findAll() {
		return getSqlSession().selectList("TblGoodsRecommendationYgModel.findAll");
	}

	public TblGoodsRecommendationYgModel findById(Integer id) {
		return getSqlSession().selectOne("TblGoodsRecommendationYgModel.findById", id);
	}

	public Pager<TblGoodsRecommendationYgModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblGoodsRecommendationYgModel.count", params);
		if (total == 0) {
			return Pager.empty(TblGoodsRecommendationYgModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblGoodsRecommendationYgModel> data = getSqlSession().selectList("TblGoodsRecommendationYgModel.pager",
				paramMap);
		return new Pager<TblGoodsRecommendationYgModel>(total, data);
	}

	public Integer delete(TblGoodsRecommendationYgModel tblGoodsRecommendationYg) {
		return getSqlSession().delete("TblGoodsRecommendationYgModel.delete", tblGoodsRecommendationYg);
	}

	/**
	 * 查询数据总和
	 *
	 * @return
	 */
	public Integer findGoodsCommendationCount() {
		Integer total = getSqlSession().selectOne("TblGoodsRecommendationYgModel.count");
		return total;
	}
	/**
	 * 查询最大排序数
	 *
	 * @return
	 */
	public Integer findGoodsSeqMax() {
		return getSqlSession().selectOne("TblGoodsRecommendationYgModel.maxSeq");
	}
	/**
	 * 根据商品ID查询网银商品推荐商品
	 *
	 * @param stringList
	 * @return
	 */
	public List<TblGoodsRecommendationYgModel> findGoodsRecommendation(List<String> stringList) {
		List<TblGoodsRecommendationYgModel> data = getSqlSession()
				.selectList("TblGoodsRecommendationYgModel.findGoodsRecommendation", stringList);
		return data;
	}

	/**
	 * 删除网银商品推荐
	 *
	 * @param goodsId
	 * @return
	 */
	public Integer deleteGoodsRe(String goodsId) {
		return getSqlSession().update("TblGoodsRecommendationYgModel.deleteGoodsRe", goodsId);
	}

	/**
	 * 交换顺序
	 *
	 * @param currentMap
	 * @return
	 */
	public Integer changeCurrent(Map<String, Object> currentMap) {
		return getSqlSession().update("TblGoodsRecommendationYgModel.changeCurrent", currentMap);
	}

	/**
	 * 交换顺序
	 *
	 * @param changeMap
	 * @return
	 */
	public Integer changeChange(Map<String, Object> changeMap) {
		return getSqlSession().update("TblGoodsRecommendationYgModel.changeChange", changeMap);
	}

	/**
	 * 校验商品Id是否重复
	 *
	 * @param code
	 * @return
	 */
	public Integer findCountById(String code) {
		return getSqlSession().selectOne("TblGoodsRecommendationYgModel.findCountById", code);
	}
	
	public List<TblGoodsRecommendationYgModel> findGoodsRecommendationByType(String typeId){
		return getSqlSession().selectList("TblGoodsRecommendationYgModel.findGoodsRecommendationByType", typeId);
	}
}