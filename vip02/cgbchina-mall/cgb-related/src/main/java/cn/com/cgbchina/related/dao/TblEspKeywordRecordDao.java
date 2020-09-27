package cn.com.cgbchina.related.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import cn.com.cgbchina.related.model.MemberSearchKeyWordModel;
import cn.com.cgbchina.related.model.TblEspKeywordRecordModel;

import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;

@Repository
public class TblEspKeywordRecordDao extends SqlSessionDaoSupport {

	public Integer update(TblEspKeywordRecordModel tblEspKeywordRecord) {
		return getSqlSession().update("TblEspKeywordRecordModel.update", tblEspKeywordRecord);
	}

	public Integer insert(TblEspKeywordRecordModel tblEspKeywordRecord) {
		return getSqlSession().insert("TblEspKeywordRecordModel.insert", tblEspKeywordRecord);
	}

	public List<TblEspKeywordRecordModel> findAll() {
		return getSqlSession().selectList("TblEspKeywordRecordModel.findAll");
	}

	public TblEspKeywordRecordModel findById(Long id) {
		return getSqlSession().selectOne("TblEspKeywordRecordModel.findById", id);
	}

	public TblEspKeywordRecordModel findByKeyWords(String keyWords) {
		return getSqlSession().selectOne("TblEspKeywordRecordModel.findByKeyWords", keyWords);
	}

	// 模糊查询
	public Pager<TblEspKeywordRecordModel> findLikeByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblEspKeywordRecordModel.countLike", params);
		if (total == 0) {
			return Pager.empty(TblEspKeywordRecordModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblEspKeywordRecordModel> data = getSqlSession()
				.selectList("TblEspKeywordRecordModel.pagerLike", paramMap);
		return new Pager<TblEspKeywordRecordModel>(total, data);
	}

	public Pager<TblEspKeywordRecordModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("TblEspKeywordRecordModel.count", params);
		if (total == 0) {
			return Pager.empty(TblEspKeywordRecordModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<TblEspKeywordRecordModel> data = getSqlSession().selectList("TblEspKeywordRecordModel.pager", paramMap);
		return new Pager<TblEspKeywordRecordModel>(total, data);
	}

	public Integer delete(TblEspKeywordRecordModel tblEspKeywordRecord) {
		return getSqlSession().delete("TblEspKeywordRecordModel.delete", tblEspKeywordRecord);
	}

	/**
	 * Description : 统计会员搜索关键字 用于报表：会员搜索记录报表
	 * 
	 * @param paramMap
	 * @return
	 */
	public List<MemberSearchKeyWordModel> findMemberSearchKeyWords(Map<String, Object> paramMap) {
		return getSqlSession().selectList("TblEspKeywordRecordModel.findMemberSearchKeyWords", paramMap);
	}
}