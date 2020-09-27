package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.common.util.StringUtils;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.HygieneLicenseEventDto;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.service.LicenseWorkService;

@Repository("licenseWorkService")
public class LicenseWork implements LicenseWorkService{
	
	/**
	    * sqlSession.
	    * @since 1.0.0
	    */
	@Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;

	
	//受理局
	public List<CodeLibraryDTO> findPortOrgCode() {
		return sqlSession.selectList("SQL.WORK.findPortOrgCode");
	}
	/*****************************工作提醒*******************************/
	public List<LicenseDecDTO> findWorkAlert(Map<String, String> map) {
		return sqlSession.selectList("SQL.WORK.findWorkAlert",map);
	}
	public int findCounts(Map<String, String> map){
		if(sqlSession.selectOne("SQL.WORK.findCounts", map)==null){
			return 0;
		}else{
			return sqlSession.selectOne("SQL.WORK.findCounts", map);
		}
	}
	//延时
	public void updateProlong(Map<String,String> map){
		sqlSession.insert("SQL.WORK.updateProlong", map);
	}
	/****************************工作流程*******************************/
	public List<LicenseDecDTO> findWorkFlow(Map<String, String> map) {
		return sqlSession.selectList("SQL.WORK.findWorkFlow",map);
	}
	public int findFlowCounts(Map<String, String> map){
		if(sqlSession.selectOne("SQL.WORK.findFlowCounts", map)==null){
			return 0;
		}else{
			return sqlSession.selectOne("SQL.WORK.findFlowCounts", map);
		}
	}
	public List<LicenseDecDTO> selectFlowCard(String license_dno) {
		List<LicenseDecDTO> list=sqlSession.selectList("SQL.WORK.selectFlowCard0",license_dno);
//		for(LicenseDecDTO d:list){
//			if(StringUtils.isNotEmpty(d.getApproval_user())){
//				UsersDTO user=sqlSession.selectOne("findUsersByCode", d.getApproval_user());
//				d.setApproval_user(user.getName());
//			}
//			if(StringUtils.isNotEmpty(d.getExam_user())){
//				UsersDTO user2=sqlSession.selectOne("findUsersByCode", d.getExam_user());
//				d.setExam_user(user2.getName());
//			}
//		}
		return list;
	}
	
	public List<HygieneLicenseEventDto> selectHygieneCard(String licence_id) {
		List<HygieneLicenseEventDto> list=sqlSession.selectList("SQL.WORK.selectFlowCard",licence_id);
		for(HygieneLicenseEventDto l:list){
			if(StringUtils.isNotEmpty(l.getOpr_psn())){
				UsersDTO user=sqlSession.selectOne("findUsersByCode",l.getOpr_psn());
				if(StringUtils.isNotEmpty(user)){
					l.setOpr_psn(user.getName());
				}
			}
		}
		return list;
	}
	
	@Override
	public String getLicenseNoByOptionList(Map<String, String> map) {
		return sqlSession.selectOne("SQL.WORK.getLicenseNoByOptionList", map);
	}
	
}
