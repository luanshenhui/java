package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.TblConfigModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblConfigDao extends SqlSessionDaoSupport {

	public Integer update(TblConfigModel tblConfig) {
		return getSqlSession().update("TblConfigModel.update", tblConfig);
	}

	/**
	 * 更新采购价格上浮指数
	 *
	 * @param tblConfig
	 * @return
	 */
	public Integer purchaseUpdate(TblConfigModel tblConfig) {
		return getSqlSession().update("TblConfigModel.purchaseUpdate", tblConfig);
	}

	public Integer insert(TblConfigModel tblConfig) {
		return getSqlSession().insert("TblConfigModel.insert", tblConfig);
	}

	public List<TblConfigModel> findAll() {
		return getSqlSession().selectList("TblConfigModel.findAll");
	}

	public TblConfigModel findById(Long id) {
		return getSqlSession().selectOne("TblConfigModel.findById", id);
	}

	/**
	 * 采购价上浮系数查询 niufw
	 *
	 * @param cfgType
	 * @return
	 */
	public TblConfigModel findByCfgType(String cfgType) {
		return getSqlSession().selectOne("TblConfigModel.findByCfgType", cfgType);
	}

	public Pager<TblConfigModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblConfigModel.count", params);
		if (total == 0) {
			return Pager.empty(TblConfigModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblConfigModel> data = getSqlSession().selectList("TblConfigModel.pager", paramMap);
		return new Pager<TblConfigModel>(total, data);
	}

	public Integer delete(TblConfigModel tblConfig) {
		return getSqlSession().delete("TblConfigModel.delete", tblConfig);
	}
}