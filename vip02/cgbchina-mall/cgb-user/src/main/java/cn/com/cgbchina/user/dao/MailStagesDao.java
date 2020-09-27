package cn.com.cgbchina.user.dao;

import cn.com.cgbchina.user.model.MailStagesModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class MailStagesDao extends SqlSessionDaoSupport {

	public Integer update(MailStagesModel mailStages) {
		return getSqlSession().update("MailStages.update", mailStages);
	}

	public Integer insert(MailStagesModel mailStages) {
		return getSqlSession().insert("MailStages.insert", mailStages);
	}

	public List<MailStagesModel> findAll() {
		return getSqlSession().selectList("MailStages.findAll");
	}

	public MailStagesModel findById(Long id) {
		return getSqlSession().selectOne("MailStages.findById", id);
	}

	public Pager<MailStagesModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("MailStages.count", params);
		if (total == 0) {
			return Pager.empty(MailStagesModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<MailStagesModel> data = getSqlSession().selectList("MailStages.pager", paramMap);
		return new Pager<MailStagesModel>(total, data);
	}

	public Integer delete(MailStagesModel mailStages) {
		return getSqlSession().delete("MailStages.delete", mailStages);
	}

	public List<MailStagesModel> findMailStagesListByVendorId(String vendorId) {
		return getSqlSession().selectList("MailStages.findMailStagesListByVendorId", vendorId);
	}

	// 逻辑删除邮购分期
	public Integer updateForDelete(Long id) {
		return getSqlSession().update("MailStages.updateForDelete", id);
	}


	public MailStagesModel findMailStageByCode(Map<String,Object> params){
		return getSqlSession().selectOne("MailStages.findMailStageByCode",params);
	}
}