package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.dto.GoodsFavoriteDto;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MemberGoodsFavoriteDao extends SqlSessionDaoSupport {

	public Integer update(MemberGoodsFavoriteModel memberGoodsFavorite) {
		return getSqlSession().update("MemberGoodsFavorite.update", memberGoodsFavorite);
	}

	public Integer insert(MemberGoodsFavoriteModel memberGoodsFavorite) {
		return getSqlSession().insert("MemberGoodsFavorite.insert", memberGoodsFavorite);
	}

	public List<MemberGoodsFavoriteModel> findAll() {
		return getSqlSession().selectList("MemberGoodsFavorite.findAll");
	}

	public MemberGoodsFavoriteModel findById(Long id) {
		return getSqlSession().selectOne("MemberGoodsFavorite.findById", id);
	}

	public Pager<MemberGoodsFavoriteModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MemberGoodsFavorite.count", params);
		if (total == 0) {
			return Pager.empty(MemberGoodsFavoriteModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MemberGoodsFavoriteModel> data = getSqlSession().selectList("MemberGoodsFavorite.pager", paramMap);
		return new Pager<MemberGoodsFavoriteModel>(total, data);
	}

	public Pager<MemberGoodsFavoriteModel> findByPageForNoRepeat(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MemberGoodsFavorite.countForNoRepeat", params);
		if (total == 0) {
			return Pager.empty(MemberGoodsFavoriteModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MemberGoodsFavoriteModel> data = getSqlSession().selectList("MemberGoodsFavorite.pagerForNoRepeat", paramMap);
		return new Pager<MemberGoodsFavoriteModel>(total, data);
	}

	public Integer delete(MemberGoodsFavoriteModel memberGoodsFavorite) {
		return getSqlSession().delete("MemberGoodsFavorite.delete", memberGoodsFavorite);
	}

	public List<MemberGoodsFavoriteModel> findTop(Map<String, Object> params) {
		return getSqlSession().selectList("MemberGoodsFavorite.findTop", params);
	}

	public List<MemberGoodsFavoriteModel> findByCustIdAndItemCode(Map<String, Object> params) {
		return getSqlSession().selectList("MemberGoodsFavorite.findByCustIdAndItemCode", params);
	}
}