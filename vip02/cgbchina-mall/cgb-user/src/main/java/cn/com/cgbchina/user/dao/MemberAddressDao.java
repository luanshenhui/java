package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.MemberAddressModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MemberAddressDao extends SqlSessionDaoSupport {

	public Integer update(MemberAddressModel memberAddressModel) {
		return getSqlSession().update("MemberAddress.update", memberAddressModel);
	}

	/**
	 * sql没写
	 *
	 * @param id
	 * @return
	 */
	public Integer update(Long id) {
		return getSqlSession().update("MemberAddress.update", id);
	}

	public Integer insert(MemberAddressModel memberAddressModel) {
		return getSqlSession().insert("MemberAddress.insert", memberAddressModel);
	}

	public List<MemberAddressModel> findAll(String custId) {
		return getSqlSession().selectList("MemberAddress.findAll", custId);
	}

	public MemberAddressModel findById(Long id) {
		return getSqlSession().selectOne("MemberAddress.findById", id);
	}

	public List<MemberAddressModel> findByCustId(String custId) {
		return getSqlSession().selectList("MemberAddress.findByCustId", custId);
	}

	public Pager<MemberAddressModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MemberAddress.count", params);
		if (total == 0) {
			return Pager.empty(MemberAddressModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MemberAddressModel> data = getSqlSession().selectList("MemberAddress.pager", paramMap);
		return new Pager<MemberAddressModel>(total, data);
	}

	public Integer delete(Long id) {
		return getSqlSession().delete("MemberAddress.delete", id);
	}

	public Integer setDefault(Long id) {
		return getSqlSession().update("MemberAddress.setDefault", id);
	}

	/**
	 * 根据用户id取得地址情报
	 *
	 * @param paramMap
	 * @return
	 * geshuo 20160714
	 */
	public List<MemberAddressModel> findByParams(Map<String, Object> paramMap) {
		return getSqlSession().selectList("MemberAddress.findByParams", paramMap);
	}

	/**
	 *  根据用户id将所有地址更新为 非默认地址
	 * @param custId 用户id
	 * @return 更新结果
	 *
	 * geshuo 20160809
	 */
	public Integer updateDefaultByCustId(String custId){
		return getSqlSession().update("MemberAddress.updateDefaultByCustId", custId);
	}
}