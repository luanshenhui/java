package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.MemberLogonHistoryModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MemberLogonHistoryDao extends SqlSessionDaoSupport {

	public Integer update(MemberLogonHistoryModel memberLogonHistoryModel) {
		return getSqlSession().update("MemberLogonHistory.update", memberLogonHistoryModel);
	}

	/**
	 * 更新退出时间
	 * @param id
	 * @return
	 */
	public Integer updateLogoutTime(Long id) {
		return getSqlSession().update("MemberLogonHistory.updateLogoutTime", id);
	}

	public Integer insert(MemberLogonHistoryModel memberLogonHistoryModel) {
		return getSqlSession().insert("MemberLogonHistory.insert", memberLogonHistoryModel);
	}

	public List<MemberLogonHistoryModel> findAll() {
		return getSqlSession().selectList("MemberLogonHistory.findAll");
	}

	public MemberLogonHistoryModel findById(Long id) {
		return getSqlSession().selectOne("MemberLogonHistory.findById", id);
	}

	public Pager<MemberLogonHistoryModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MemberLogonHistory.count", params);
		if (total == 0) {
			return Pager.empty(MemberLogonHistoryModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MemberLogonHistoryModel> data = getSqlSession().selectList("MemberLogonHistory.pager", paramMap);
		return new Pager<MemberLogonHistoryModel>(total, data);
	}

	public Integer delete(MemberLogonHistoryModel memberLogonHistoryModel) {
		return getSqlSession().delete("MemberLogonHistory.delete", memberLogonHistoryModel);
	}

	public List<MemberLogonHistoryModel> findLogonHistory(Map<String, Object> paramMap) {
		return getSqlSession().selectList("MemberLogonHistory.findLogonHistory", paramMap);
	}

	/**
	 * 登录时，添加一条记录
	 *
	 * @param memberLogonHistoryModel
	 * @return
	 */
	public Integer insertLogon(MemberLogonHistoryModel memberLogonHistoryModel) {
		return getSqlSession().insert("MemberLogonHistory.insertLogon", memberLogonHistoryModel);
	}

	/**
	 *
	 * @param CustId
	 * @return
	 */
	public List<MemberLogonHistoryModel> findSuccessByCustId(String CustId) {
		return getSqlSession().selectList("MemberLogonHistory.findSuccessByCustId", CustId);
	}

	public MemberLogonHistoryModel findByCustId(String id) {
		return getSqlSession().selectOne("MemberLogonHistory.findByCustId", id);
	}
}