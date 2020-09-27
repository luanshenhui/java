package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.SpecialPointsRateDto;
import cn.com.cgbchina.item.model.SpecialPointScaleModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class SpecialPointScaleDao extends SqlSessionDaoSupport {
	/**
	 * 根据id更新
	 * 
	 * @param specialPointScaleModel
	 * @return
	 */
	public Integer update(SpecialPointScaleModel specialPointScaleModel) {
		return getSqlSession().update("SpecialPointScaleModel.updateById", specialPointScaleModel);
	}

	/**
	 * 根据type和typeId进行更新
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	public Integer updateByTypeId(SpecialPointScaleModel specialPointScaleModel) {
		return getSqlSession().update("SpecialPointScaleModel.updateByTypeId", specialPointScaleModel);
	}

	public Integer insert(SpecialPointScaleModel specialPointScale) {
		return getSqlSession().insert("SpecialPointScaleModel.insert", specialPointScale);
	}

	public List<SpecialPointScaleModel> findAll() {
		return getSqlSession().selectList("SpecialPointScaleModel.findAll");
	}

	public SpecialPointScaleModel findById(Long id) {
		return getSqlSession().selectOne("SpecialPointScaleModel.findById", id);
	}

	public Pager<SpecialPointScaleModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("SpecialPointScaleModel.count", params);
		if (total == 0) {
			return Pager.empty(SpecialPointScaleModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<SpecialPointScaleModel> data = getSqlSession().selectList("SpecialPointScaleModel.pager", paramMap);
		return new Pager<SpecialPointScaleModel>(total, data);
	}

	public Integer delete(SpecialPointScaleModel specialPointScale) {
		return getSqlSession().delete("SpecialPointScaleModel.delete", specialPointScale);
	}

	public Integer deleteAll(Map<String, Object> paramMap) {
		return getSqlSession().update("SpecialPointScaleModel.deleteAll", paramMap);
	}

	/**
	 * typeVal唯一性校验
	 *
	 * @param specialPointScaleModel
	 * @return
	 */
	public List<SpecialPointScaleModel> typeValCheck(SpecialPointScaleModel specialPointScaleModel) {
		return getSqlSession().selectList("SpecialPointScaleModel.typeValCheck", specialPointScaleModel);
	}

	/**
	 * 根据参数查询数据
	 *
	 * @param paramMap 查询参数
	 * @return 查询结果
	 * geshuo 20160816
	 */
	public List<SpecialPointScaleModel> findByParams(Map<String,Object> paramMap) {
		return getSqlSession().selectList("SpecialPointScaleModel.findByParams",paramMap);
	}
}