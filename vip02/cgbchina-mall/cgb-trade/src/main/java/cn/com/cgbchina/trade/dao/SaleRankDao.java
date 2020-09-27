package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.trade.model.SaleRankModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SaleRankDao extends SqlSessionDaoSupport {

	public Integer update(SaleRankModel saleRank) {
		return getSqlSession().update("SaleRankModel.update", saleRank);
	}

	public Integer insert(SaleRankModel saleRank) {
		return getSqlSession().insert("SaleRankModel.insert", saleRank);
	}

	public List<SaleRankModel> findAll() {
		return getSqlSession().selectList("SaleRankModel.findAll");
	}

	public SaleRankModel findById(Long id) {
		return getSqlSession().selectOne("SaleRankModel.findById", id);
	}

	public Pager<SaleRankModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("SaleRankModel.count", params);
		if (total == 0) {
			return Pager.empty(SaleRankModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<SaleRankModel> data = getSqlSession().selectList("SaleRankModel.pager", paramMap);
		return new Pager<SaleRankModel>(total, data);
	}

	public Integer delete(SaleRankModel saleRank) {
		return getSqlSession().delete("SaleRankModel.delete", saleRank);
	}

	/**
	 * Description : 根据积分类型获取排行对象
	 * 
	 * @param jfType
	 * @return
	 */
	public List<SaleRankModel> findByJfType(String jfType) {
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("jfType", jfType);
		paramMap.put("delFlag", Contants.DEL_FLAG_1);
		return getSqlSession().selectList("SaleRankModel.findByJfType", paramMap);
	}
}