package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.ShopMemberModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ShopMemberDao extends SqlSessionDaoSupport {

	public Integer update(ShopMemberModel shopMemberModel) {
		return getSqlSession().update("ShopMember.update", shopMemberModel);
	}

	public Integer insert(ShopMemberModel shopMemberModel) {
		return getSqlSession().insert("ShopMember.insert", shopMemberModel);
	}

	public List<ShopMemberModel> findAll() {
		return getSqlSession().selectList("ShopMember.findAll");
	}

	public ShopMemberModel findById(Long id) {
		return getSqlSession().selectOne("ShopMember.findById", id);
	}

	public Pager<ShopMemberModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ShopMember.count", params);
		if (total == 0) {
			return Pager.empty(ShopMemberModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ShopMemberModel> data = getSqlSession().selectList("ShopMember.pager", paramMap);
		return new Pager<ShopMemberModel>(total, data);
	}

	public Integer delete(ShopMemberModel shopMemberModel) {
		return getSqlSession().delete("ShopMember.delete", shopMemberModel);
	}
}