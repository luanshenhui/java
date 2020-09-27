package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.http.form.MailObjCheckForm;
import com.dpn.ciqqlc.standard.model.MailObjCheckModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;

/**
 * MailObjCheckDbService.
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
public interface MailObjCheckDbService {

	void createMail(Map<String, Object> createMailMap);

	List<MailObjCheckModel> findMail(Map<String, String> map);

	int findMainCount(Map<String, String> map);

	List allDealType();

	MailObjCheckModel findUMailById(Map<String, String> map);

	List<SelectModel> allOrgList();

	List<SelectModel> allDepList();

	List<VideoFileEventModel> videoFileEventList(Map<String, String> map);

	List<MailObjCheckModel> selectMail(Map<String, Object> paramMap);

	List<MailObjCheckModel> selectMailDetail(Map<String, Object> paramMap);

	void updateMail(MailObjCheckModel mailObjCheckModel);

	void updateStatus(Map<String, Object> map);

	boolean getIsImg(Map<String, Object> map);

	Object ydxhList(Map<String, Object> map);

	void updateMailObjCheckDitroyId(Map<String, Object> map);

	List<MailObjCheckModel> xhList(Map<String, String> map);

}
