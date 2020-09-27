package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.TblEspCustCartModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblEspCustCartDao extends SqlSessionDaoSupport {

	public Integer update(TblEspCustCartModel tblEspCustCart) {
		return getSqlSession().update("TblEspCustCartModel.update", tblEspCustCart);
	}

	public Integer insert(TblEspCustCartModel tblEspCustCart) {
		return getSqlSession().insert("TblEspCustCartModel.insert", tblEspCustCart);
	}

	//
	// public List<TblEspCustCartModel> findAll() {
	// return getSqlSession().selectList("TblEspCustCartModel.findAll");
	// }

	public TblEspCustCartModel findById(String id) {
		return getSqlSession().selectOne("TblEspCustCartModel.findById", id);
	}

	public List<TblEspCustCartModel> findCartItemsByIds(List<String> ids) {
		return getSqlSession().selectList("TblEspCustCartModel.findCartItemsByIds", ids);
	}

	public Pager<TblEspCustCartModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblEspCustCartModel.count", params);
		if (total == 0) {
			return Pager.empty(TblEspCustCartModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblEspCustCartModel> data = getSqlSession().selectList("TblEspCustCartModel.pager", paramMap);
		return new Pager<TblEspCustCartModel>(total, data);
	}

	public Integer delete(TblEspCustCartModel tblEspCustCart) {
		return getSqlSession().delete("TblEspCustCartModel.delete", tblEspCustCart);
	}

	public Integer deleteByIds(List<String> ids) {
		return getSqlSession().delete("TblEspCustCartModel.deleteByIds", ids);
	}

	/**
	 * 按用户名检索购物车信息
	 * 
	 * @param params
	 * @return
	 */
	public List<TblEspCustCartModel> findByCustId(Map<String, Object> params) {
		return getSqlSession().selectList("TblEspCustCartModel.findByCustId", params);
	}

	/**
	 * 按条件检索判断购物车内该条信息
	 * 
	 * @param params
	 * @return
	 */
	public TblEspCustCartModel findByCustInfo(Map<String, Object> params) {
		return getSqlSession().selectOne("TblEspCustCartModel.findByCustInfo", params);
	}

	/**
	 * 按条件检出购物车条数
	 */
	public Integer findCountByUser(String custId) {
		Integer total = getSqlSession().selectOne("TblEspCustCartModel.userBuyCount", custId);
		return total;
	}

	/**
	 * 按条件检出购物车条数
	 */
	public Integer findCountByUserItem(String custId, String itemCode) {
		Map<String,String> param = Maps.newHashMap();
		param.put("custId",custId);
		param.put("itemCode",itemCode);
		Integer total = getSqlSession().selectOne("TblEspCustCartModel.userItemBuyCount", param);
		return total;
	}

}