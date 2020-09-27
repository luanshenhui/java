package cn.com.cgbchina.trade.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class TblOrdermainHistoryDao extends SqlSessionDaoSupport {

	public Integer update(TblOrdermainHistoryModel tblOrdermainHistory) {
		return getSqlSession().update("TblOrdermainHistoryModel.update", tblOrdermainHistory);
	}

	public Integer insert(TblOrdermainHistoryModel tblOrdermainHistory) {
		return getSqlSession().insert("TblOrdermainHistoryModel.insert", tblOrdermainHistory);
	}

	public List<TblOrdermainHistoryModel> findAll() {
		return getSqlSession().selectList("TblOrdermainHistoryModel.findAll");
	}

	public TblOrdermainHistoryModel findById(String ordermainId) {
		return getSqlSession().selectOne("TblOrdermainHistoryModel.findById", ordermainId);
	}

	public Pager<TblOrdermainHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblOrdermainHistoryModel.count", params);
		if (total == 0) {
			return Pager.empty(TblOrdermainHistoryModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblOrdermainHistoryModel> data = getSqlSession().selectList("TblOrdermainHistoryModel.pager", paramMap);
		return new Pager<TblOrdermainHistoryModel>(total, data);
	}

	public Integer delete(TblOrdermainHistoryModel tblOrdermainHistory) {
		return getSqlSession().delete("TblOrdermainHistoryModel.delete", tblOrdermainHistory);
	}

	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 *
	 * @param params
	 * @return
	 */
	public List<TblOrdermainHistoryModel> findForCC(Map<String, Object> params) {
		return getSqlSession().selectList("TblOrdermainHistoryModel.findForCC", params);
	}

	public List<TblOrdermainHistoryModel> findOrdersByList(Map<String, Object> params) {
		return getSqlSession().selectList("TblOrdermainHistoryModel.findOrdersByList", params);
	}

	/**
	 * xiewl 20161018
	 * MAL113 查询订单信息
	 * @param params
	 * @return
	 */
	public List<String> findOrderMainfor113(Map<String,Object> params){
		return getSqlSession().selectList("TblOrdermainHistoryModel.findOrderMainfor113",params);
	}

}