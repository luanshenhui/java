package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.TblBankModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import com.spirit.mybatis.BaseDao;
import com.spirit.user.User;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class TblBankDao extends SqlSessionDaoSupport {

	public Integer update(TblBankModel tblBank) {
		return getSqlSession().update("TblBankModel.update", tblBank);
	}

	public Integer insert(TblBankModel tblBank) {
		return getSqlSession().insert("TblBankModel.insert", tblBank);
	}

	public List<TblBankModel> findAll() {
		return getSqlSession().selectList("TblBankModel.findAll");
	}

	public TblBankModel findById(Long id) {
		return getSqlSession().selectOne("TblBankModel.findById", id);
	}

	public Pager<TblBankModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblBankModel.count", params);
		if (total == 0) {
			return Pager.empty(TblBankModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblBankModel> data = getSqlSession().selectList("TblBankModel.pager", paramMap);
		return new Pager<TblBankModel>(total, data);
	}

	public Integer delete(TblBankModel tblBank) {
		return getSqlSession().delete("TblBankModel.delete", tblBank);
	}

	public Integer deleteAll(Map<String, Object> paramMap) {
		return getSqlSession().update("TblBankModel.deleteAll", paramMap);
	}

	/**
	 * 校验分行号和分行名称是否重复
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160819
	 */
	public Integer checkByCodeOrName(Map<String,Object> paramMap){
		return getSqlSession().selectOne("TblBankModel.checkByCodeOrName",paramMap);
	}
}