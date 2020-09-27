package com.dpn.ciqqlc.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.http.form.WarningLinkRuleForm;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.WarningRuleDto;
import com.dpn.ciqqlc.standard.model.WarningStandardEventDto;
import com.dpn.ciqqlc.standard.service.WarningService;

@Repository("warningServer")
public class WarningFlow implements WarningService{
	
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;

	@Override
	public List<WarningRuleDto> findWarningList(WarningRuleDto warningRuleDto) {
		return sqlSession.selectList("SQL.WARNING.findWarningList", warningRuleDto);
	}

	@Override
	public int findwarinCount(WarningRuleDto warningRuleDto) {
		return sqlSession.selectOne("SQL.WARNING.findWarinCount", warningRuleDto);
	}

	@Override
	public void insertWarning(WarningRuleDto warningRuleDto) {
		sqlSession.insert("SQL.WARNING.insertWarning", warningRuleDto);
	}

	@Override
	public void updateWarning(WarningRuleDto warningRuleDto) {
		sqlSession.update("SQL.WARNING.updateWarning", warningRuleDto);
		
	}

	@Override
	public void deleteWarning(WarningRuleDto warningRuleDto) {
		sqlSession.delete("SQL.WARNING.deleteWarning", warningRuleDto);
	}

	@Override
	public List<WarningStandardEventDto> findGuifanList(
			WarningStandardEventDto warningStandardEventDto) {
		return sqlSession.selectList("SQL.WARNING.findGuifanList", warningStandardEventDto);
	}

	@Override
	public int findGuifanCount(WarningStandardEventDto warningStandardEventDto) {
		return sqlSession.selectOne("SQL.WARNING.findGuifanCount", warningStandardEventDto);
	}

	@Override
	public List<SelectModel> findCodeLibrary(SelectModel model) {
		return sqlSession.selectList("SQL.WARNING.findCodeLibrary", model);
	}

	@Override
	public List<WarningLinkRuleForm> findGuifanWeihuList(
			WarningLinkRuleForm warningLinkRuleForm) {
		return sqlSession.selectList("SQL.WARNING.findGuifanWeihuList", warningLinkRuleForm);
	}

	@Override
	public int findGuifanWeihuCount(WarningLinkRuleForm warningLinkRuleForm) {
		return sqlSession.selectOne("SQL.WARNING.findGuifanWeihuCount", warningLinkRuleForm);
	}

	@Override
	public List<WarningLinkRuleForm> findTypeRuleList(
			WarningLinkRuleForm warningLinkRuleForm) {
		return sqlSession.selectList("SQL.WARNING.findTypeRuleList", warningLinkRuleForm);
	}

	@Override
	public Object findWarningLinkRuleFormById(WarningLinkRuleForm m) {
		return sqlSession.selectOne("SQL.WARNING.findWarningLinkRuleFormById", m);
	}

	@Override
	public void updateWeihu(WarningLinkRuleForm m) throws Exception {
		sqlSession.update("SQL.WARNING.updateWeihu", m);
		
	}

	
	
	public void chaoliucheng() {
		//查询超流程
		List<WarningRuleDto> list = sqlSession.selectList("SQL.WARNING.findTypeRuleList", null);
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
}
