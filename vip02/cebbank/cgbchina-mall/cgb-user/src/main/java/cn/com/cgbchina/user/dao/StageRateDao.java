package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.StageRateModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class StageRateDao extends SqlSessionDaoSupport {

	public Integer update(StageRateModel stageRateModel) {
		return getSqlSession().update("StageRate.update", stageRateModel);
	}

	/**
	 * 根据vendorId做逻辑删除
	 *
	 * @param vendorId
	 * @return
	 */
	public Integer update(String vendorId) {
		return getSqlSession().update("StageRate.updateById", vendorId);
	}

	public Integer insert(StageRateModel stageRateModel) {
		return getSqlSession().insert("StageRate.insert", stageRateModel);
	}

	public List<StageRateModel> findAll() {
		return getSqlSession().selectList("StageRate.findAll");
	}

	public StageRateModel findById(Long id) {
		return getSqlSession().selectOne("StageRate.findById", id);
	}

	public List<StageRateModel> findStageByVendorId(String vendorId) {
		return getSqlSession().selectList("StageRate.findStageByVendorId", vendorId);
	}

	public StageRateModel findByVendorId(String vendorId) {
		return getSqlSession().selectOne("StageRate.findByVendorId", vendorId);
	}

	public Pager<StageRateModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("StageRate.", params);
		if (total == 0) {
			return Pager.empty(StageRateModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<StageRateModel> data = getSqlSession().selectList("StageRate.pager", paramMap);
		return new Pager<StageRateModel>(total, data);
	}

	public Integer delete(StageRateModel stageRateModel) {
		return getSqlSession().delete("StageRate.delete", stageRateModel);
	}

	// 逻辑删除分期费率
	public Integer updateForDelete(Long id) {
		return getSqlSession().update("StageRate.updateForDelete", id);
	}
}