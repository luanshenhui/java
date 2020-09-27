package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class MemberBrowseHistoryDao extends SqlSessionDaoSupport {

	public Integer update(MemberBrowseHistoryModel memberBrowseHistory) {
		return getSqlSession().update("MemberBrowseHistoryModel.update", memberBrowseHistory);
	}

	public Integer updateBrowse(MemberBrowseHistoryModel memberBrowseHistory) {
		return getSqlSession().update("MemberBrowseHistoryModel.updateBrowse", memberBrowseHistory);
	}

	public Integer insert(MemberBrowseHistoryModel memberBrowseHistory) {
		return getSqlSession().insert("MemberBrowseHistoryModel.insert", memberBrowseHistory);
	}

	public List<MemberBrowseHistoryModel> findAll() {
		return getSqlSession().selectList("MemberBrowseHistoryModel.findAll");
	}

	public MemberBrowseHistoryModel findById(Long id) {
		return getSqlSession().selectOne("MemberBrowseHistoryModel.findById", id);
	}

	public Pager<MemberBrowseHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MemberBrowseHistoryModel.count", params);
		if (total == 0) {
			return Pager.empty(MemberBrowseHistoryModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		paramMap.put("delFlag", 0);

		List<MemberBrowseHistoryModel> data = getSqlSession().selectList("MemberBrowseHistoryModel.pagerByDate",
				paramMap);
		return new Pager<MemberBrowseHistoryModel>(total, data);
	}

	public Integer delete(MemberBrowseHistoryModel memberBrowseHistory) {
		return getSqlSession().delete("MemberBrowseHistoryModel.delete", memberBrowseHistory);
	}

	public List<MemberBrowseHistoryModel> findBrowseHistoryLimitByNum(String num) {
		return getSqlSession().selectList("MemberBrowseHistoryModel.findBrowseHistoryLimitByNum");
	}

	/**
	 * 
	 * Description : 会员报表统计
	 * 
	 * @param offset
	 * @param limit
	 * @param params
	 * @return
	 */
	public List<MemberBrowseHistoryModel> findBrowseHistoryByPager(int offset, int limit, Map<String, Object> params) {
		params.put("offset", offset);
		params.put("limit", limit);
		return getSqlSession().selectList("MemberBrowseHistoryModel.pagerCountHistory", params);
	}

	public List<MemberBrowseHistoryModel> getUserBrowsHistory(String goodsCode, String custId) {
		MemberBrowseHistoryModel memberBrowseHistoryModel = new MemberBrowseHistoryModel();
		memberBrowseHistoryModel.setGoodsCode(goodsCode);
		memberBrowseHistoryModel.setCustId(custId);
		return getSqlSession().selectList("MemberBrowseHistoryModel.getUserBrowsHistory", memberBrowseHistoryModel);
	}
}