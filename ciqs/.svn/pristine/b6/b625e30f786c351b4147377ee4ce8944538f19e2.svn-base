package com.dpn.ciqqlc.service;

import java.util.Date;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.service.PhysicalExamService;

@Repository("docsServer")
public class PhysicalExam implements PhysicalExamService{
	
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession = null;
	
	public void insertDocs(CheckDocsRcdModel checkDocsRcdModel) {
		String uuid =	UUID.randomUUID().toString();
		checkDocsRcdModel.setDocId(uuid.replace("-",""));
//		checkDocsRcdModel.setDecUser("创建人");
//		checkDocsRcdModel.setDocType("1");
		checkDocsRcdModel.setDecDate(new Date());
		this.sqlSession.insert("SQL.DOCS.insertDocs", checkDocsRcdModel);
	}
	
	
}
