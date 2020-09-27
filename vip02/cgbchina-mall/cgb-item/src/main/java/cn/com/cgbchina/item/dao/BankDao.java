package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.Bank;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BankDao extends SqlSessionDaoSupport {

	public Integer update(Bank bank) {
		return getSqlSession().update("Bank.update", bank);
	}

	public Integer insert(Bank bank) {
		return getSqlSession().insert("Bank.insert", bank);
	}

	public List<Bank> findAll() {
		return getSqlSession().selectList("Bank.findAll");
	}

	public Bank findById(Long id) {
		return getSqlSession().selectOne("Bank.findById", id);
	}

	public Pager<Bank> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("Bank.count", params);
		if (total == 0) {
			return Pager.empty(Bank.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<Bank> data = getSqlSession().selectList("Bank.pager", paramMap);
		return new Pager<Bank>(total, data);
	}

	public Integer delete(Bank bank) {
		return getSqlSession().delete("Bank.delete", bank);
	}
}