package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;

/**
 * LicenseDecDbService.
 * 
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务接口。
********************************************************************************
 * 变更履历
 * -> 
***************************************************************************** */
public interface LicenseDecDbService {

	List<LicenseDecDTO> findLicenseDecs(Map<String, String> map);

	int findLicenseDecsCount(Map<String, String> map);

	void doApproval(Map<String, String> map);

	List<LicenseDecDTO> findAddpesons(Map<String, String> map);

	int findAddpesonsCount(Map<String, String> map);

	Object findByPseon(ExpFoodProdPsnRdmDTO dto);

	int findPersonCount(ExpFoodProdPsnRdmDTO dto);

	List<ExpFoodProdPsnRdmDTO> findAllPseon(ExpFoodProdPsnRdmDTO dto);

	List<LicenseDecDTO> findReviews(Map<String, String> map);

	int findReviewsCount(Map<String, String> map);

	void updateApprovalUsers(Map<String, Object> map);

	void doReview(Map<String, String> map);

	String getFilePath(Map<String, String> map);

	List<LicenseDecDTO> findLicenseDecsList(Map<String, String> map);

	List licenseDecsInfo(Map<String, String> paramrMap);

	LicenseDecDTO getLicenseDec(Map<String, String> map);

	String selectfilePath(Map<String, String> map);

	String selectZgfilePath(Map<String, String> map);

	int insterPersonRdm(ExpFoodProdPsnRdmDTO dto);

	List<ExpFoodProdPsnRdmDTO> findByBasePseon(ExpFoodProdPsnRdmDTO dto);

	List<LicenseDecDTO> findScs(Map<String, String> map);

	int findScsCount(Map<String, String> map);

	void doExamination(Map<String, String> map);

	void setTy(Map<String, Object> map);

	List<LicenseDecDTO> findyScs(Map<String, String> map);

	int findyScsCount(Map<String, String> map);

	List<LicenseDecDTO> findDoReviews(Map<String, String> map);

	int findDoReviewsCount(Map<String, String> map);

	List<LicenseDecDTO> findReviewsSp(Map<String, String> map);

	int findReviewsSpCount(Map<String, String> map);

	void doReviewSp(Map<String, String> map);

	void insertEvent(Map<String, String> eventmap);

	void doSubmit(Map<String, String> map);

	List findByBasePseon2(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO);

	List getOrgList();

	List<LicenseDecDTO> bfList(Map<String, String> map);

	int bfCounts(Map<String, String> map);

	void updateDStatus(String valueOf, int i);

	int findAddpesonsCountSp(Map<String, String> map);

	List<LicenseDecDTO> findAddpesonsSp(Map<String, String> map);

	void updateApprovalUsersName(Map<String, Object> map);

	void updateDocApprovalUsersName(Map<String, Object> map);

	Object getbelScope(String string);

	List<LicenseDecDTO> findScs1(Map<String, String> map);

	int findScs1Count(Map<String, String> map);

	void doExamination1(Map<String, String> map);

	ExpFoodProdPsnRdmDTO getPseonInfo(Map<String, Object> map);

	void insertSeal(Map<String, String> map);

	List getSealList(Map<String, String> map);

	void updateSeal(Map<String, String> map);
}
