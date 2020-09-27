package com.dpn.ciqqlc.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.http.form.WarningLinkRuleForm;
import com.dpn.ciqqlc.standard.service.WarningLinkRuleService;

@Repository("warningLinkRuleService")
public class WarningLinkRuleDb implements WarningLinkRuleService{
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;
	
	@Override
	public List<WarningLinkRuleForm> findBillList(WarningLinkRuleForm warningLinkRuleForm) throws Exception {
		return sqlSession.selectList("SQL.WARNING_LINK_RULE.findList", warningLinkRuleForm);
	}
}
