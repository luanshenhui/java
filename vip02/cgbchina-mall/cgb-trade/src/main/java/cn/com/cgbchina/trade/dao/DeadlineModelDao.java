package cn.com.cgbchina.trade.dao;

import cn.com.cgbchina.trade.model.DeadlineModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class DeadlineModelDao extends SqlSessionDaoSupport {

	public Integer update(DeadlineModel deadlineModel) {
		return getSqlSession().update("DeadlineModel.updateAll", deadlineModel);
	}

	public Integer insert(DeadlineModel deadlineModel) {
		return getSqlSession().insert("DeadlineModel.insert", deadlineModel);
	}

	public List<DeadlineModel> findAll() {
		return getSqlSession().selectList("DeadlineModel.findAll");
	}

	public DeadlineModel findById(Long id) {
		return getSqlSession().selectOne("DeadlineModel.findById", id);
	}

	public Pager<DeadlineModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("DeadlineModel.count", params);
		if (total == 0) {
			return Pager.empty(DeadlineModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<DeadlineModel> data = getSqlSession().selectList("DeadlineModel.pager", paramMap);
		return new Pager<DeadlineModel>(total, data);
	}

	public Integer delete(DeadlineModel deadlineModel) {
		return getSqlSession().delete("DeadlineModel.delete", deadlineModel);
	}

}