package cn.com.cgbchina.item.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.item.model.TblGoodsPointRegionModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class TblGoodsPointRegionDao extends SqlSessionDaoSupport {

	public Integer update(TblGoodsPointRegionModel tblGoodsPointRegion) {
		return getSqlSession().update("TblGoodsPointRegionModel.update", tblGoodsPointRegion);
	}

	public Integer insert(TblGoodsPointRegionModel tblGoodsPointRegion) {
		return getSqlSession().insert("TblGoodsPointRegionModel.insert", tblGoodsPointRegion);
	}

	public List<TblGoodsPointRegionModel> findAll() {
		return getSqlSession().selectList("TblGoodsPointRegionModel.findAll");
	}

	public TblGoodsPointRegionModel findById(Integer regionId) {
		return getSqlSession().selectOne("TblGoodsPointRegionModel.findById", regionId);
	}

	public Pager<TblGoodsPointRegionModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblGoodsPointRegionModel.count", params);
		if (total == 0) {
			return Pager.empty(TblGoodsPointRegionModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblGoodsPointRegionModel> data = getSqlSession().selectList("TblGoodsPointRegionModel.pager", paramMap);
		return new Pager<TblGoodsPointRegionModel>(total, data);
	}

	public Integer delete(TblGoodsPointRegionModel tblGoodsPointRegion) {
		return getSqlSession().delete("TblGoodsPointRegionModel.delete", tblGoodsPointRegion);
	}
	//查找delFlag不等于1的 区间集合
	public List<TblGoodsPointRegionModel> getRegionFromBonus() {
		return getSqlSession().selectList("TblGoodsPointRegionModel.getRegionFromBonus");
	}
}