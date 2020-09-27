package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.MenuMagModel;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableMultimap;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MenuMagDao extends SqlSessionDaoSupport {

	public Integer update(MenuMagModel menuMag) {
		return getSqlSession().update("MenuMagModel.update", menuMag);
	}

	public Integer insert(MenuMagModel menuMag) {
		return getSqlSession().insert("MenuMagModel.insert", menuMag);
	}

	public List<MenuMagModel> findAll() {
		return getSqlSession().selectList("MenuMagModel.findAll");
	}

	public MenuMagModel findById(Long id) {
		return getSqlSession().selectOne("MenuMagModel.findById", id);
	}

	public Pager<MenuMagModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MenuMagModel.count", params);
		if (total == 0) {
			return Pager.empty(MenuMagModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MenuMagModel> data = getSqlSession().selectList("MenuMagModel.pager", paramMap);
		return new Pager<MenuMagModel>(total, data);
	}

	public Integer delete(MenuMagModel menuMag) {
		return getSqlSession().delete("MenuMagModel.delete", menuMag);
	}

	public List<MenuMagModel> findChildById(Long id) {
		return getSqlSession().selectList("MenuMagModel.findChildById", id);
	}

	public List<Long> findAllEnabledMenu() {
		return getSqlSession().selectList("MenuMagModel.allEnabledMenu");
	}

	public List<MenuMagModel> findByIds(List<Long> menuIds) {
		return getSqlSession().selectList("MenuMagModel.findByIds",  ImmutableMap.of("ids", menuIds));
	}
}