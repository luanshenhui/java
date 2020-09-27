package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.item.model.GoodsXidSeqModelModel;

@Repository
public class GoodsXidSeqModelDao extends SqlSessionDaoSupport {

	public Integer update(GoodsXidSeqModelModel goodsXidSeqModel) {
		return getSqlSession().update("GoodsXidSeqModelModel.update", goodsXidSeqModel);
	}

	public Integer insert(GoodsXidSeqModelModel goodsXidSeqModel) {
		return getSqlSession().insert("GoodsXidSeqModelModel.insert", goodsXidSeqModel);
	}

	public List<GoodsXidSeqModelModel> findAll() {
		return getSqlSession().selectList("GoodsXidSeqModelModel.findAll");
	}

	public GoodsXidSeqModelModel findById(Long goodsXidSeq) {
		return getSqlSession().selectOne("GoodsXidSeqModelModel.findById", goodsXidSeq);
	}

	public Pager<GoodsXidSeqModelModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("GoodsXidSeqModelModel.count", params);
		if (total == 0) {
			return Pager.empty(GoodsXidSeqModelModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<GoodsXidSeqModelModel> data = getSqlSession().selectList("GoodsXidSeqModelModel.pager", paramMap);
		return new Pager<GoodsXidSeqModelModel>(total, data);
	}

	public Integer delete(GoodsXidSeqModelModel goodsXidSeqModel) {
		return getSqlSession().delete("GoodsXidSeqModelModel.delete", goodsXidSeqModel);
	}

	public Integer findGoodsXidSeq() {
		return getSqlSession().selectOne("GoodsXidSeqModelModel.findGoodsXidSeq");
	}

	public Integer updateGoodsXidSeq() {
		return getSqlSession().update("GoodsXidSeqModelModel.updateGoodsXidSeq");
	}
}