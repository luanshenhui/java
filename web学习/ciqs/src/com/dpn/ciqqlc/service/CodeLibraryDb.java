package com.dpn.ciqqlc.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.service.CodeLibraryService;

/**
 * QlcCodeLibrary
 * @author xwj
 *
 */
@Repository("codeLibraryDb")
public class CodeLibraryDb implements CodeLibraryService {
	
	@Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
	
	public List<CodeLibraryDTO> findCodeLibraryList(String type){
		return sqlSession.selectList("SQL.COMM.queryCodeLibrary", type);
	}
}
