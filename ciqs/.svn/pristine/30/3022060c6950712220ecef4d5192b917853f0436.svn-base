package com.dpn.ciqqlc.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.service.LicenseDecDbService;

/**
 * LicenseDecDb
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
@Repository("licenseDecDbService")
public class LicenseDecDb implements LicenseDecDbService{

   /**
    * sqlSession.
    * @since 1.0.0
    */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;

	public List<LicenseDecDTO> findLicenseDecs(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findLicenseDecs",map);
	}
	
	public int findLicenseDecsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findLicenseDecsCount", map);
	}

	public void doApproval(Map<String, String> map) {
		sqlSession.update("SQL.XK.doApproval", map);
	}

	public List<LicenseDecDTO> findAddpesons(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findAddpesons",map);
	}

	public int findAddpesonsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findAddpesonsCount",map);
	}
	
	public List<LicenseDecDTO> findAddpesons2(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findAddpesons2",map);
	}

	public int findAddpesonsCount2(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findAddpesonsCount2",map);
	}
	
	public Object findByPseon(ExpFoodProdPsnRdmDTO dto) {
		return sqlSession.selectList("SQL.XK.findByPseon",dto);
	}

	public int findPersonCount(ExpFoodProdPsnRdmDTO dto) {
		return sqlSession.selectOne("SQL.XK.findByPseonCount",dto);
	}
	
	public List<ExpFoodProdPsnRdmDTO> findAllPseon(ExpFoodProdPsnRdmDTO dto) {
		return sqlSession.selectList("SQL.XK.findAllPseon", dto);	
	}

	public List<LicenseDecDTO> findReviews(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findReviews", map);	
	}

	public int findReviewsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findReviewsCount",map);
	}

	public void updateApprovalUsers(Map<String, Object> map) {
		sqlSession.update("SQL.XK.updateApprovalUsers",map);
	}

	public void doReview(Map<String, String> map) {
		sqlSession.update("SQL.XK.doReview",map);
	}

	public String getFilePath(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.getFilePath",map);
	}

	public List<LicenseDecDTO> findLicenseDecsList(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findLicenseDecsList",map);
	}

	public List licenseDecsInfo(Map<String, String> paramrMap) {
		return sqlSession.selectList("SQL.XK.licenseDecsInfo",paramrMap);
	}

	public LicenseDecDTO getLicenseDec(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.getLicenseDec",map);
	}

	public String selectfilePath(Map<String, String> map) {
		map.put("type", "4");
		return sqlSession.selectOne("SQL.XK.selectfilePath",map);
	}

	public String selectZgfilePath(Map<String, String> map) {
		map.put("type", "5");
		return sqlSession.selectOne("SQL.XK.selectfilePath",map);
	}

	public int insterPersonRdm(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {
		foodProdPsnRdmDTO.setRdm_date(new Date());
		return sqlSession.insert("SQL.XK.insertPeson", foodProdPsnRdmDTO);
	}

	public List<ExpFoodProdPsnRdmDTO> findByBasePseon(
			ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {		
			List<ExpFoodProdPsnRdmDTO> list =	sqlSession.selectList("SQL.XK.findByBasePseon", foodProdPsnRdmDTO);
			if(list !=null && list.size() >0){
				return list;
			}
				return null;
	}

	public List<LicenseDecDTO> findScs(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findScs",map);
	}

	public int findScsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findScsCount",map);
	}

	public void doExamination(Map<String, String> map) {
		sqlSession.update("SQL.XK.doExamination",map);
	}
	
	public void doExamination1(Map<String, String> map) {
		sqlSession.update("SQL.XK.doExamination1",map);
	}
	
	public void setTy(Map<String, Object> map) {
		sqlSession.update("SQL.XK.setTy",map);
	}

	public List<LicenseDecDTO> findyScs(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findyScs",map);
	}

	public int findyScsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findyScsCount",map);
	}

	public List<LicenseDecDTO> findDoReviews(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findDoReviews",map);
	}

	public int findDoReviewsCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findDoReviewsCount",map);
	}

	public List<LicenseDecDTO> findReviewsSp(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findReviewsSp",map);
	}

	public int findReviewsSpCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findReviewsSpCount",map);
	}

	public void doReviewSp(Map<String, String> map) {
		sqlSession.update("SQL.XK.doReviewSp",map);	
	}

	public void insertEvent(Map<String, String> map) {
		sqlSession.insert("SQL.XK.insertEvent",map);
	}

	public void doSubmit(Map<String, String> map) {
		sqlSession.update("SQL.XK.doSubmit",map);	
	}

	public List findByBasePseon2(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {
			List<ExpFoodProdPsnRdmDTO> list =	sqlSession.selectList("SQL.XK.findByBasePseon2", foodProdPsnRdmDTO);
			if(list !=null && list.size() >0){
				return list;
			}
			return null;
	}

	public List getOrgList() {
		return sqlSession.selectList("SQL.XK.getOrgList");
	}

	public List<LicenseDecDTO> bfList(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.bfList",map);
	}

	public int bfCounts(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.bfCounts",map);
	}

	public void updateDStatus(String on, int i) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("status", i);
		map.put("license_dno", on);
		sqlSession.update("SQL.XK.updateDStatus",map);
		
	}

	public int findAddpesonsCountSp(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findAddpesonsCountSp",map);
	}

	public List<LicenseDecDTO> findAddpesonsSp(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findAddpesonsSp",map);
	}

	@Override
	public void updateApprovalUsersName(Map<String, Object> map) {
		sqlSession.update("SQL.XK.updateApprovalUsersName",map);	
	}

	@Override
	public void updateDocApprovalUsersName(Map<String, Object> map) {
		sqlSession.update("SQL.XK.updateDocApprovalUsersName",map);	
	}

	@Override
	public String getbelScope(String psn_name) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("psn_name", psn_name);
		return sqlSession.selectOne("SQL.XK.getbelScope",map);
	}

	public List<LicenseDecDTO> findScs1(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.findScs1",map);
	}

	public int findScs1Count(Map<String, String> map) {
		return sqlSession.selectOne("SQL.XK.findScs1Count",map);
	}

	@Override
	public ExpFoodProdPsnRdmDTO getPseonInfo(Map<String, Object> map) {
		return sqlSession.selectOne("SQL.XK.getPseonInfo",map);
	}

	@Override
	public void insertSeal(Map<String, String> map) {
		sqlSession.insert("SQL.XK.insertSeal",map);
	}

	@Override
	public List getSealList(Map<String, String> map) {
		return sqlSession.selectList("SQL.XK.getSealList",map);
	}

	@Override
	public void updateSeal(Map<String, String> map) {
		sqlSession.update("SQL.XK.updateSeal",map);
	}




}
