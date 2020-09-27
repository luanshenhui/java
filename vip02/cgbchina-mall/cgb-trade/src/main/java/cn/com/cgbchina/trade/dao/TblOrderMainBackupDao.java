package cn.com.cgbchina.trade.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class TblOrderMainBackupDao extends SqlSessionDaoSupport {

	public Integer update(TblOrderMainBackupModel tblOrderMainBackup) {
		return getSqlSession().update("TblOrderMainBackupModel.update", tblOrderMainBackup);
	}

	public Integer insert(TblOrderMainBackupModel tblOrderMainBackup) {
		return getSqlSession().insert("TblOrderMainBackupModel.insert", tblOrderMainBackup);
	}

	public List<TblOrderMainBackupModel> findAll() {
		return getSqlSession().selectList("TblOrderMainBackupModel.findAll");
	}

	public TblOrderMainBackupModel findById(String ordermainId) {
		return getSqlSession().selectOne("TblOrderMainBackupModel.findById", ordermainId);
	}

	public Pager<TblOrderMainBackupModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblOrderMainBackupModel.count", params);
		if (total == 0) {
			return Pager.empty(TblOrderMainBackupModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblOrderMainBackupModel> data = getSqlSession().selectList("TblOrderMainBackupModel.pager", paramMap);
		return new Pager<TblOrderMainBackupModel>(total, data);
	}

	public Integer delete(TblOrderMainBackupModel tblOrderMainBackup) {
		return getSqlSession().delete("TblOrderMainBackupModel.delete", tblOrderMainBackup);
	}

	/**
	 * MAL105 CC积分商城订单列表查询接口 niufw
	 *
	 * @param params
	 * @return
	 */
	public List<TblOrderMainBackupModel> findForCC(Map<String, Object> params) {
		return getSqlSession().selectList("TblOrderMainBackupModel.findForCC", params);
	}
	
	public List<TblOrderMainBackupModel> findOrdersByList(Map<String, Object> params) {
		return getSqlSession().selectList("TblOrderMainBackupModel.findOrdersByList", params);
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