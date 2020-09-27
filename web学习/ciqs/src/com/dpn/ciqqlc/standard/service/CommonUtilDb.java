package com.dpn.ciqqlc.standard.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.CountryDTO;
import com.dpn.ciqqlc.standard.model.EventLogDTO;
import com.dpn.ciqqlc.standard.model.OrganizesDTO;
import com.dpn.ciqqlc.standard.model.PortCodeDTO;
import com.dpn.ciqqlc.standard.model.UserInfoAppDTO;
import com.dpn.ciqqlc.standard.service.CommonUtilDbService;
/**
 * UserManageDb.
 * 
 * @author
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
@Repository("commonUtilDbService")
public class CommonUtilDb implements CommonUtilDbService {
	 /**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
    

	public List<OrganizesDTO> ajaxOrganize(String orgName) throws Exception {
		return sqlSession.selectList("ajaxOrganize", orgName);
	}


	public List<CodeLibraryDTO> getCodeLibrary(Map<String, String> map)  {
		return sqlSession.selectList("getCodeLibrary", map);
	}


	public void addEventLog(Map<String, String> map) throws Exception {
		sqlSession.insert("addEventLog",map);
	}

	public Map<String,OrganizesDTO> findAllOrganize(){
		List<OrganizesDTO> list = sqlSession.selectList("findAllOrganize");
		Map<String,OrganizesDTO> map = new HashMap<String,OrganizesDTO>();
		for(OrganizesDTO dto : list){
			map.put(dto.getOrg_code(), dto);
		}
		return map;
	}

	public List<String> hoursList() {
		List<String> hoursList = new ArrayList<String>();
		for(int i=0;i<24;i++){
			if(i<10){
				hoursList.add("0"+i);
			}else{
				hoursList.add(i+"");
			}
		}
		return hoursList;
	}


	public List<String> minuteList() {
		List<String> minuteList = new ArrayList<String>();
		for(int i=0;i<60;i++){
			if(i<10){
				minuteList.add("0"+i);
			}else{
				minuteList.add(i+"");
			}
		}
		return minuteList;
	}


	public List<PortCodeDTO> ajaxPsspt(String portCName) throws Exception {
		return sqlSession.selectList("ajaxPsspt",portCName);
	}

	public List<PortCodeDTO> findPortCodeAll() throws Exception {
		return sqlSession.selectList("findPortCodeAll");
	}


	public List<UserInfoAppDTO> findUserListByUid(String uid)
			throws Exception {
		return sqlSession.selectList("findUserListByUid", uid);
	}


	public void insertEventLog(EventLogDTO event) {
		sqlSession.insert("addEventLog", event);
	}


	public UserInfoAppDTO findUserInfoAppByUid(String uid) throws Exception {
		return sqlSession.selectOne("findUserInfoAppByUid", uid);
	}


	public PortCodeDTO findPortCodeByCode(String code) {
		return sqlSession.selectOne("findPortCodeByCode",code);
	}


	public String selectDecMasterId() {
		return sqlSession.selectOne("selectDecMasterId");
	}
	
	public List<CountryDTO> ajaxCountry(String country) throws Exception {
		return sqlSession.selectList("ajaxCountry",country);
	}


	public List<CountryDTO> findCountryAll() {
		return sqlSession.selectList("findCountryAll");
	}


	public List<OrganizesDTO> findOrganizeAll() throws Exception {
		return sqlSession.selectList("findOrganizeAll");
	}
	
}
