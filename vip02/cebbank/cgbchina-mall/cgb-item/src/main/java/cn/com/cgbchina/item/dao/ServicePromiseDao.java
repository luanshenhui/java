package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.model.ServicePromiseModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ServicePromiseDao extends SqlSessionDaoSupport {

	public Integer update(ServicePromiseModel servicePromise) {
		return getSqlSession().update("ServicePromiseModel.update", servicePromise);
	}

	public Integer insert(ServicePromiseModel servicePromise) {
		return getSqlSession().insert("ServicePromiseModel.insert", servicePromise);
	}

	public List<ServicePromiseModel> findAll() {
		return getSqlSession().selectList("ServicePromiseModel.findAll");
	}

	public ServicePromiseModel findById(Long code) {
		return getSqlSession().selectOne("ServicePromiseModel.findById", code);
	}

	public Pager<ServicePromiseModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ServicePromiseModel.count", params);
		if (total == 0) {
			return Pager.empty(ServicePromiseModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ServicePromiseModel> data = getSqlSession().selectList("ServicePromiseModel.pager", paramMap);
		return new Pager<ServicePromiseModel>(total, data);
	}

	public Integer delete(ServicePromiseModel servicePromise) {
		return getSqlSession().delete("ServicePromiseModel.delete", servicePromise);
	}

	/**
	 * 服务承诺重复校验
	 * 
	 * @param name
	 * @return
	 */
	public Long findNameByName(String name) {
		Long total = getSqlSession().selectOne("ServicePromiseModel.findNameByName", name);
		return total;
	}

	/**
	 * 服务承诺顺序重复校验
	 * 
	 * @param sort
	 * @return
	 */
	public Long findSortBySort(Integer sort) {
		Long total = getSqlSession().selectOne("ServicePromiseModel.findSortBySort", sort);
		return total;
	}
}