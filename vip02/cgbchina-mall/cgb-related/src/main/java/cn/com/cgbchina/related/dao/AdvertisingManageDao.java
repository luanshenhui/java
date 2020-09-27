package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.AdvertisingManageModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AdvertisingManageDao extends SqlSessionDaoSupport {

	public Integer update(AdvertisingManageModel advertisingManage) {
		return getSqlSession().update("AdvertisingManageModel.update", advertisingManage);
	}

	public Integer insert(AdvertisingManageModel advertisingManage) {
		return getSqlSession().insert("AdvertisingManageModel.insert", advertisingManage);
	}

	public List<AdvertisingManageModel> findAll() {
		return getSqlSession().selectList("AdvertisingManageModel.findAll");
	}

	public AdvertisingManageModel findById(Integer id) {
		return getSqlSession().selectOne("AdvertisingManageModel.findById", id);
	}

	public Pager<AdvertisingManageModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("AdvertisingManageModel.count", params);
		if (total == 0) {
			return Pager.empty(AdvertisingManageModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<AdvertisingManageModel> data = getSqlSession().selectList("AdvertisingManageModel.pager", paramMap);
		return new Pager<AdvertisingManageModel>(total, data);
	}

	/**
	 * 广告管理审核和拒绝
	 * 
	 * @param advertisingManageModel
	 * @return
	 */
	public Integer changeCheckStatus(AdvertisingManageModel advertisingManageModel) {
		return getSqlSession().update("AdvertisingManageModel.changeCheckStatus", advertisingManageModel);
	}

	/**
	 * 逻辑删除 niufw
	 *
	 * @param id
	 * @return
	 */
	public Integer updateForDelete(Long id) {
		return getSqlSession().update("AdvertisingManageModel.updateForDelete", id);
	}
}