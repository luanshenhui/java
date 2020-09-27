package com.dpn.ciqqlc.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.http.form.IntercepeForm;
import com.dpn.ciqqlc.http.form.TravCarryObjForm;
import com.dpn.ciqqlc.standard.model.IntercepeModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.BelongingsService;

@Repository("belongingsService")
public class Belongings implements BelongingsService{
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession = null;
	
	/**
	 * 查询拦截物
	 * */
	public List<IntercepeModel> selectIntercepe(Map<String, String> map) {	
		return  this.sqlSession.selectList("SQL.BELONGINGS.selectIntercepe", map);
	}
	/**
	 * 查询详细信息
	 * */
	public List<IntercepeModel> selectIntercepeDetails(Map<String, String> map) {
		return sqlSession.selectList("SQL.BELONGINGS.selectIntercepeDetails",map);
	}
	/**
	 * 查询拦截物移动端
	 * */
	public  List<IntercepeModel> selectMoveIntercepe(IntercepeForm intercepeForm) {
		return this.sqlSession.selectList("SQL.BELONGINGS.selectMoveIntercepe", intercepeForm);
	}
	/**
	 * 查询详细信息移动端
	 * */
	public List<IntercepeModel> selectMoveDetails(Map<String, Object> map) {
		return sqlSession.selectList("SQL.BELONGINGS.selectMoveDetails",map);
	}

	/**
	 * option
	 * */
	public List<SelectModel> allOrgList() {
		return sqlSession.selectList("SQL.BELONGINGS.allOrgList");
	}

	public List<SelectModel> allDepList() {
		return sqlSession.selectList("SQL.BELONGINGS.allDepList");
	}
	
	public List<SelectModel> allGoodsTypeList() {
		return sqlSession.selectList("SQL.BELONGINGS.allGoodsTypeList");
	}

	public void insertItravCarryObj(Map map) {
		this.sqlSession.insert("SQL.BELONGINGS.insertItravCarryObj", map);
	}
	
	public int findIntercepeCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.BELONGINGS.findIntercepeCount",map);
	}

	public List<VideoFileEventModel> videoFileEventList(Map<String, String> map) {
		return sqlSession.selectList("SQL.BELONGINGS.videoFileEventList",map);
	}
	
	public void updateItravCarryObj(Map<String, Object> map) {
		this.sqlSession.update("SQL.BELONGINGS.updateItravCarryObj", map);
	}
	
	public List<IntercepeModel> selectMoveIntercepeByCardNo(
			IntercepeForm intercepeForm) {
		return sqlSession.selectList("SQL.BELONGINGS.selectMoveIntercepeByCardNo",intercepeForm);
	}
	
	public void updateImgYjwStatus(Map<String, Object> map) {
		this.sqlSession.update("SQL.BELONGINGS.updateImgYjwStatus", map);
	}
	
	public void updateImgBldwStatus(Map<String, Object> map) {
		this.sqlSession.update("SQL.BELONGINGS.updateImgBldwStatus", map);	
	}

	public String getDzqm(Map<String, String> map) {
		return this.sqlSession.selectOne("SQL.BELONGINGS.getDzqm",map);
	}

	public void insertDzqm(Map<String, Object> paramMap) {
		this.sqlSession.insert("SQL.BELONGINGS.insertDzqm", paramMap);	
	}
	
	
	
	
}
