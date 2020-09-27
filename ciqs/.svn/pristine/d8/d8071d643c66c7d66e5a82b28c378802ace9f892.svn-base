package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ProsasModel;
import com.dpn.ciqqlc.standard.model.QuartnModel;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;


@Service
public class Quartn {
	
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;

	public int save(QuartnModel quartnModel) {
		quartnModel.setCreateDate(DateUtil.newDate());
		return this.sqlSession.insert("SQL.QUARTN.insert", quartnModel);
	}

	public List<QuartnModel> findListPack(QuartnModel quartnModel) throws Exception {
		List<QuartnModel> list =this.sqlSession.selectList("SQL.QUARTN.findByList", quartnModel);
		if(list!=null && list.size() >0){
			return list;
		}
		return null;
	}

	public ProsasModel findById(String id) {
		ProsasModel model =sqlSession.selectOne("SQL.QUARTN.findById", id);
		return model;
	}

	public List<VideoEventModel> findByFileEvent(Map<?, ?> map) {
		List<VideoEventModel> list =this.sqlSession.selectList("SQL.QUARTN.findByFileEvent", map);
		for(VideoEventModel v:list){
			v.setCreateStrDate(DateUtil.DateToString(v.getCreateDate(),"yyyy-MM-dd HH:mm"));
			UsersDTO user=sqlSession.selectOne("findUsersByCode", v.getCreateUser());
			if(null!=user){
				v.setCreateUser(user.getName());
			}
		}
		return list;
	}

	public CheckDocsRcdModel findByDoc(Map<?, ?> map) {
		List<CheckDocsRcdModel> list=this.sqlSession.selectList("SQL.DOCS.findByDoc", map);
		if(null!=list && !list.isEmpty()){
			CheckDocsRcdModel docsRcdModel=list.get(0);
			UsersDTO user=sqlSession.selectOne("findUsersByCode", docsRcdModel.getDecUser());
			if(null!=user){
				docsRcdModel.setDecUser(user.getName());
			}
			return docsRcdModel;
		}
		return null;		
	}

	public CheckDocsRcdModel findByDocId(String id) {
		return this.sqlSession.selectOne("SQL.DOCS.findById", id);
	}

	public int findQuartnCount(QuartnModel quartnModel) {
		return this.sqlSession.selectOne("SQL.QUARTN.findQuartnCount", quartnModel);
	}

	public List<QuartnModel> findQuartnList(QuartnModel quartnModel) {
		return this.sqlSession.selectList("SQL.QUARTN.findQuartnList", quartnModel);
	}

	public void updateQtList(QuartnModel quartnModel) throws Exception {
		sqlSession.update("SQL.QUARTN.updateQuartnCheck", quartnModel);
		sqlSession.update("SQL.QUARTN.updateProsas", quartnModel);
	}

	public CheckDocsRcdModel findOnlyDoc(Map<String, Object> map) {
		List<CheckDocsRcdModel> list=this.sqlSession.selectList("SQL.DOCS.findOnlyDoc", map);
		if(!list.isEmpty()){
			if(null!=list.get(0).getDecUser()){
				UsersDTO user=sqlSession.selectOne("findUsersByCode", list.get(0).getDecUser());
				list.get(0).setDecUser(null!=user?user.getName():"");
			}
			return list.get(0);
		}
		return null;
	}
	
}
