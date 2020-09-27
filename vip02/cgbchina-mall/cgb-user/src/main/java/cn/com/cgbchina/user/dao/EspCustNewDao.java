package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.EspCustNewModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspCustNewDao extends SqlSessionDaoSupport {

	public Integer update(EspCustNewModel espCustNewModel) {
		return getSqlSession().update("EspCustNew.update", espCustNewModel);
	}

	public Integer insert(EspCustNewModel espCustNewModel) {
		return getSqlSession().insert("EspCustNew.insert", espCustNewModel);
	}

	public List<EspCustNewModel> findAll() {
		return getSqlSession().selectList("EspCustNew.findAll");
	}

	public EspCustNewModel findById(String custId) {
		return getSqlSession().selectOne("EspCustNew.findById", custId);
	}

	public Pager<EspCustNewModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspCustNew.count", params);
		if (total == 0) {
			return Pager.empty(EspCustNewModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspCustNewModel> data = getSqlSession().selectList("EspCustNew.pager", paramMap);
		return new Pager<EspCustNewModel>(total, data);
	}

	public Integer delete(EspCustNewModel espCustNewModel) {
		return getSqlSession().delete("EspCustNew.delete", espCustNewModel);
	}

	public Integer updateBirthUsedCount(String custId) {
		return getSqlSession().update("EspCustNew.updateBirthUsedCount", custId);
	}

	/**
	 * 根据参数查询列表
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public List<EspCustNewModel> findCustNewByParams(Map<String,Object> paramMap){
		return getSqlSession().selectList("EspCustNew.findCustNewByParams",paramMap);
	}

	/**
	 * 根据参数更新数据
	 * @param paramMap 更新参数
	 * @return 更新结果
	 *
	 * geshuo 20160721
	 */
	public Integer updateCustNewByParams(Map<String,Object> paramMap){
		return getSqlSession().update("EspCustNew.updateCustNewByParams", paramMap);
	}
	/**
	 * 根据参数更新数据
	 * @param paramMap 更新参数
	 * @return 更新结果
	 */
	public Integer updateCustNewByCustId(Map<String,Object> paramMap){
		return getSqlSession().update("EspCustNew.updateCustNewByCustId", paramMap);
	}

}