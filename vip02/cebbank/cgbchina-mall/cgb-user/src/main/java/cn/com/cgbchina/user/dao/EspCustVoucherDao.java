package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.EspCustVoucherModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class EspCustVoucherDao extends SqlSessionDaoSupport {

	public Integer update(EspCustVoucherModel espCustVoucherModel) {
		return getSqlSession().update("EspCustVoucher.update", espCustVoucherModel);
	}

	public Integer insert(EspCustVoucherModel espCustVoucherModel) {
		return getSqlSession().insert("EspCustVoucher.insert", espCustVoucherModel);
	}

	public List<EspCustVoucherModel> findAll() {
		return getSqlSession().selectList("EspCustVoucher.findAll");
	}

	public EspCustVoucherModel findById(String voucherNo) {
		return getSqlSession().selectOne("EspCustVoucher.findById", voucherNo);
	}

	public Pager<EspCustVoucherModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("EspCustVoucher.count", params);
		if (total == 0) {
			return Pager.empty(EspCustVoucherModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<EspCustVoucherModel> data = getSqlSession().selectList("EspCustVoucher.pager", paramMap);
		return new Pager<EspCustVoucherModel>(total, data);
	}

	public Integer delete(EspCustVoucherModel espCustVoucherModel) {
		return getSqlSession().delete("EspCustVoucher.delete", espCustVoucherModel);
	}
}