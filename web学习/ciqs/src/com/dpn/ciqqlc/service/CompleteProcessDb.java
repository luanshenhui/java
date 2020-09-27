package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.LicenseEventDTO;
import com.dpn.ciqqlc.standard.service.CompleteProcessDbService;

/**
 * CompleteProcessDb
 * 
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务实现。
 ********************************************************************************
 * 变更履历
 * -> 
 ***************************************************************************** */
@Repository("completeProcessDbService")
public class CompleteProcessDb implements CompleteProcessDbService{

   /**
    * sqlSession.
    * @since 1.0.0
    */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
	    
	public List<LicenseDecDTO> findLists(Map<String, String> map) {
		return sqlSession.selectList("SQL.CP.findLists",map);
	}

	public int findListsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.CP.findListsCount",map);
	}

	public LicenseDecDTO findById(Map<String, String> map) {
		return sqlSession.selectOne("SQL.CP.findById",map);
	}

	public String getDptFileuploadDate(String license_dno) {
		return sqlSession.selectOne("SQL.CP.getDptFileuploadDate",license_dno);
	}

	public String getFilePath(Map<String, String> map) {
		return sqlSession.selectOne("SQL.CP.getFilePath",map);
	}

	public CheckDocsRcdDTO dfbWinShow(Map<String, String> map) {
		return sqlSession.selectOne("SQL.CP.dfbWinShow",map);
	}

	public LicenseDecDTO getBgYx(Map<String, String> yxmap) {
		return sqlSession.selectOne("SQL.CP.getBgYx",yxmap);
	}

	public String getzzResult(Map<String, String> yxmap) {
		return sqlSession.selectOne("SQL.CP.getzzResult",yxmap);
	}

	public String getzxResult(Map<String, String> yxmap) {
		return sqlSession.selectOne("SQL.CP.getzxResult",yxmap);
	}

	@Override
	public List getScbList(Map<String, String> map) {
		return sqlSession.selectList("SQL.CP.getScbList",map);
	}

	@Override
	public List getVolist(Map<String, String> map) {
		return sqlSession.selectList("SQL.CP.getVolist",map);
	}
	
	@Override
	public LicenseEventDTO getBzInfo(Map<String, String> map) {
		List  list = sqlSession.selectList("SQL.CP.getBzInfo",map);
		if(list !=null && list.size() > 0){
			return (LicenseEventDTO) list.get(0);
		}
		return null;
	}

	@Override
	public LicenseEventDTO getBzInfo2(Map<String, String> map) {
		List  list = sqlSession.selectList("SQL.CP.getBzInfo2",map);
		if(list !=null && list.size() > 0){
			return (LicenseEventDTO) list.get(0);
		}
		return null;
	}
}
