package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dpn.ciqqlc.standard.model.UserConfigurationDTO;
import com.dpn.ciqqlc.standard.model.UserConfigurationModel;
import com.dpn.ciqqlc.standard.model.UserVisit;
import com.dpn.ciqqlc.standard.model.VisitConfigurationDTO;
import com.dpn.ciqqlc.standard.service.UserConfigDbService;

@Repository("userConfigDbServ")
public class UserConfigDb implements UserConfigDbService{

	 /**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
    
	@Override
	public int insertUserConfiguration(UserConfigurationDTO dto) {
		return sqlSession.insert("SQL.USERCONFIG.insertUserConfiguration", dto);
	}

	@Override
	public int updateUserConfiguration(UserConfigurationDTO dto) {
		return sqlSession.update("SQL.USERCONFIG.updateUserConfiguration",dto);
	}

	@Override
	public int delUserConfiguration(UserConfigurationDTO dto) {
		return sqlSession.delete("SQL.USERCONFIG.delUserConfiguration", dto);
	}

	@Override
	public int bathcDelUserConfiguration(Map<String, Object> map) {
		return sqlSession.delete("SQL.USERCONFIG.bathcDelUserConfiguration",map);
	}

	@Override
	public int insertVisitConf(VisitConfigurationDTO dto) {
		return sqlSession.insert("SQL.USERCONFIG.insertVisitConf", dto);
	}

	@Override
	public int UpdateVisitConf(VisitConfigurationDTO dto) {
		return sqlSession.update("SQL.USERCONFIG.UpdateVisitConf", dto);
	}

	@Override
	public int batchDelVisitConf(Map<String, Object> map) {
		return sqlSession.delete("SQL.USERCONFIG.batchDelVisitConf", map);
	}

	@Override
	public List<UserConfigurationModel> findUserConfigList(
			UserConfigurationModel um) {
		return sqlSession.selectList("SQL.USERCONFIG.findUserConfigList", um);
	}

	@Override
	public int findUserConfigListCount(
			UserConfigurationModel um) {
		return sqlSession.selectOne("SQL.USERCONFIG.findUserConfigListCount", um);
	}
	
	@Override
	public List<VisitConfigurationDTO> findVisitConfigList(
			VisitConfigurationDTO dto) {
		return sqlSession.selectList("SQL.USERCONFIG.findVisitConfigList", dto);
	}

	@Override
	public VisitConfigurationDTO findVisitConfigById(VisitConfigurationDTO dto) {
		return sqlSession.selectOne("SQL.USERCONFIG.findVisitConfigById", dto);
	}
	
	//用户
	public List<UserVisit> findUsersV(Map<String, String> map)throws Exception {
		return sqlSession.selectList("SQL.USERCONFIG.findUsersV", map);
	}

	public int findUsersCountV(Map<String, String> map)throws Exception {
		return sqlSession.selectOne("SQL.USERCONFIG.findUsersCountV", map);
	}

}
