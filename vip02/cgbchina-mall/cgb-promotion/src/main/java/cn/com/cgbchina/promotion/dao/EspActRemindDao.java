package cn.com.cgbchina.promotion.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

import cn.com.cgbchina.promotion.model.EspActRemindModel;

@Repository
public class EspActRemindDao extends SqlSessionDaoSupport {
    //1
	public Integer update(EspActRemindModel espActRemind) {
		return getSqlSession().update("EspActRemindModel.update", espActRemind);
	}

	public Integer insert(EspActRemindModel espActRemind) {
		return getSqlSession().insert("EspActRemindModel.insert", espActRemind);
	}

	public List<EspActRemindModel> findAll() {
		return getSqlSession().selectList("EspActRemindModel.findAll");
	}

	public EspActRemindModel findById(Long id) {
		return getSqlSession().selectOne("EspActRemindModel.findById", id);
	}

	public Pager<EspActRemindModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspActRemindModel.count", params);
		if (total == 0) {
			return Pager.empty(EspActRemindModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspActRemindModel> data = getSqlSession().selectList("EspActRemindModel.pager", paramMap);
		return new Pager<EspActRemindModel>(total, data);
	}

	public Integer delete(EspActRemindModel espActRemind) {
		return getSqlSession().delete("EspActRemindModel.delete", espActRemind);
	}

	/**
	 * 根据参数逻辑删除
	 * 
	 * @param paramMap 删除参数
	 * @return 删除结果
	 *
	 *         geshuo 20160722
	 */
	public Integer deleteRemindByParams(Map<String, Object> paramMap) {
		return getSqlSession().update("EspActRemindModel.deleteRemindByParams", paramMap);
	}
	
	
	/**
	 * 查询商品设置提醒次数 
	 * @param EspActRemindModel
	 * @return isRemind
	 * */
	public Integer findIsRemidByGoods(EspActRemindModel espActRemindModel) {
		return getSqlSession().selectOne("EspActRemindModel.findIsRemidByGoods", espActRemindModel);
	}
	
}