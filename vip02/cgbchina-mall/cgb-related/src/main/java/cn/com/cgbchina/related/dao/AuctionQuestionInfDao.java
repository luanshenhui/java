package cn.com.cgbchina.related.dao;

import cn.com.cgbchina.related.model.AuctionQuestionInfModel;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class AuctionQuestionInfDao extends SqlSessionDaoSupport {

	public Integer update(AuctionQuestionInfModel auctionQuestionInf) {
		return getSqlSession().update("AuctionQuestionInfModel.update", auctionQuestionInf);
	}

	public Integer insert(AuctionQuestionInfModel auctionQuestionInf) {
		return getSqlSession().insert("AuctionQuestionInfModel.insert", auctionQuestionInf);
	}

	public List<AuctionQuestionInfModel> findAll() {
		return getSqlSession().selectList("AuctionQuestionInfModel.findAll");
	}

	public AuctionQuestionInfModel findById(Long id) {
		return getSqlSession().selectOne("AuctionQuestionInfModel.findById", id);
	}

	public Pager<AuctionQuestionInfModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("AuctionQuestionInfModel.count", params);
		if (total == 0) {
			return Pager.empty(AuctionQuestionInfModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<AuctionQuestionInfModel> data = getSqlSession().selectList("AuctionQuestionInfModel.pager",
				paramMap);
		return new Pager<AuctionQuestionInfModel>(total, data);
	}

	public Integer delete(AuctionQuestionInfModel auctionQuestionInf) {
		return getSqlSession().delete("AuctionQuestionInfModel.delete", auctionQuestionInf);
	}

	public Integer updateDelFlag(Long id) {
		return getSqlSession().update("AuctionQuestionInfModel.updateDelFlag", id);
	}

	public Integer findLinkUrl(String linkUrl,Integer type) {
		Map<String,Object> params = Maps.newHashMap();
		params.put("linkUrl",linkUrl);
		params.put("type",type);
		return getSqlSession().selectOne("AuctionQuestionInfModel.findLinkUrl", params);
	}

	public List<String> findAllUrl(){
		return getSqlSession().selectList("AuctionQuestionInfModel.findAllUrl");
	}
}