package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.GoodsConsultModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class GoodsConsultDao extends SqlSessionDaoSupport {

	public Integer update(GoodsConsultModel goodsConsultModel) {
		return getSqlSession().update("GoodsConsult.update", goodsConsultModel);
	}

	public Integer insert(GoodsConsultModel goodsConsultModel) {
		return getSqlSession().insert("GoodsConsult.insert", goodsConsultModel);
	}

	public List<GoodsConsultModel> findAll() {
		return getSqlSession().selectList("GoodsConsult.findAll");
	}

	public GoodsConsultModel findById(Long id) {
		return getSqlSession().selectOne("GoodsConsult.findById", id);
	}

	public Pager<GoodsConsultModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("GoodsConsult.count", params);
		if (total == 0) {
			return Pager.empty(GoodsConsultModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<GoodsConsultModel> data = getSqlSession().selectList("GoodsConsult.pager", paramMap);
		return new Pager<GoodsConsultModel>(total, data);
	}

	public Integer delete(GoodsConsultModel goodsConsultModel) {
		return getSqlSession().delete("GoodsConsult.delete", goodsConsultModel);
	}

	/**
	 * 更新，商品资讯管理，显示或隐藏
	 *
	 * @param params
	 * @return
	 */
	public Integer updateIsShowByIds(Map params) {
		return getSqlSession().update("GoodsConsult.updateIsShowByIds", params);
	}

	/**
	 * 回复功能
	 *
	 * @param params
	 * @return
	 */
	public Integer updateReplyContent(Map params) {
		return getSqlSession().update("GoodsConsult.updateReplyContent", params);
	}

	/**
	 * 添加咨询
	 * 
	 * @param goodsConsultModel
	 * @return
	 */
	public Integer insertGoodsConsult(GoodsConsultModel goodsConsultModel) {
		return getSqlSession().update("GoodsConsult.insertGoodsConsult", goodsConsultModel);
	}

	/**
	 * 按goodCode查询
	 * 
	 * @param params
	 * @param offset
	 * @param limit
	 * @return
	 */
	public Pager<GoodsConsultModel> findByPageByCode(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("GoodsConsult.countByCode", params);
		if (total == 0) {
			return Pager.empty(GoodsConsultModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<GoodsConsultModel> data = getSqlSession().selectList("GoodsConsult.pagerByCode", paramMap);
		return new Pager<GoodsConsultModel>(total, data);
	}

}