package cn.com.cgbchina.user.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.user.model.CardPro;

@Repository
public class CardProDao extends SqlSessionDaoSupport {

	public Integer update(CardPro cardPro) {
		return getSqlSession().update("CardPro.update", cardPro);
	}

	public Integer updateIsBinding(CardPro cardPro) {
		return getSqlSession().update("CardPro.updateIsBinding", cardPro);
	}

	public Integer updateUnBinding(String formatId) {
		return getSqlSession().update("CardPro.updateUnBinding", formatId);
	}

	public Integer insert(CardPro cardPro) {
		return getSqlSession().insert("CardPro.insert", cardPro);
	}

	public List<CardPro> findAll() {
		return getSqlSession().selectList("CardPro.findAll");
	}

	public CardPro findById(Long id) {
		return getSqlSession().selectOne("CardPro.findById", id);
	}

	public Pager<CardPro> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("CardPro.count", params);
		if (total == 0) {
			return Pager.empty(CardPro.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<CardPro> data = getSqlSession().selectList("CardPro.pager", paramMap);
		return new Pager<CardPro>(total, data);
	}

	public Integer delete(CardPro cardPro) {
		return getSqlSession().delete("CardPro.delete", cardPro);
	}

	public Pager<CardPro> findCardProProCode(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("CardPro.counts", params);
		if (total == 0) {
			return Pager.empty(CardPro.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<CardPro> data = getSqlSession().selectList("CardPro.findCardProProCode", paramMap);
		return new Pager<CardPro>(total, data);
	}

	public Pager<CardPro> findAllCardPro(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("CardPro.countSecond", params);
		if (total == 0) {
			return Pager.empty(CardPro.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<CardPro> data = getSqlSession().selectList("CardPro.pagers", paramMap);
		return new Pager<CardPro>(total, data);
	}

}