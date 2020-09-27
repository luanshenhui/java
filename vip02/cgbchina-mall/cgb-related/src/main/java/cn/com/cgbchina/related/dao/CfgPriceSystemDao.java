package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class CfgPriceSystemDao extends SqlSessionDaoSupport {

    public Integer update(CfgPriceSystemModel cfgPriceSystem) {
        return getSqlSession().update("CfgPriceSystemModel.update", cfgPriceSystem);
    }

	/**
	 * 逻辑删除
	 *
	 * @param cfgPriceSystem
	 * @return
	 */
	public Integer updateForDel(CfgPriceSystemModel cfgPriceSystem) {
		return getSqlSession().update("CfgPriceSystemModel.updateForDel", cfgPriceSystem);
	}

	public Integer insert(CfgPriceSystemModel cfgPriceSystem) {
		return getSqlSession().insert("CfgPriceSystemModel.insert", cfgPriceSystem);
	}

	public List<CfgPriceSystemModel> findAll() {
		return getSqlSession().selectList("CfgPriceSystemModel.findAll");
	}

	public CfgPriceSystemModel findById(Integer id) {
		return getSqlSession().selectOne("CfgPriceSystemModel.findById", id);
	}

    public List<CfgPriceSystemModel> findByPriceSystemId(String priceSystemId) {
        return getSqlSession().selectList("CfgPriceSystemModel.findByPriceSystemId", priceSystemId);
    }

	public Pager<CfgPriceSystemModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("CfgPriceSystemModel.count", params);
		if (total == 0) {
			return Pager.empty(CfgPriceSystemModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<CfgPriceSystemModel> data = getSqlSession().selectList("CfgPriceSystemModel.pager", paramMap);
		return new Pager<CfgPriceSystemModel>(total, data);
	}


    public Integer delete(CfgPriceSystemModel cfgPriceSystem) {
        return getSqlSession().delete("CfgPriceSystemModel.delete", cfgPriceSystem);
    }

    public List<CfgPriceSystemModel> findlListByPricesystemId(String pricesystemId) {
        return getSqlSession().selectList("CfgPriceSystemModel.findByPricesystemId", pricesystemId);
    }

}