package cn.com.cgbchina.batch.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.batch.model.MemberGoodsFavorite;

/**
 * 会员收藏夹 数据层
 * 
 * @author huangcy on 2016年5月31日
 */
@Repository
public class MemberFavoriteDao extends SqlSessionDaoSupport {
	public List<MemberGoodsFavorite> queryMemberFavorites(Map<String, Object> params) {
		return getSqlSession().selectList("MemberFavoriteDaoImpl.findMemberFavorites", params);
	}
}
