package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.LicenseEventDTO;

/**
 * CompleteProcessDbService.
 * 
 * @author wangzhongyan
 * @since 1.0.0 
 * @version 1.0.0 
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务接口。
********************************************************************************
 * 变更履历
 * -> 1.0.0 2017-09-26 wangzhongyan : 初建。
***************************************************************************** */
public interface CompleteProcessDbService {

	List<LicenseDecDTO> findLists(Map<String, String> map);

	int findListsCount(Map<String, String> map);

	LicenseDecDTO findById(Map<String, String> map);

	String getDptFileuploadDate(String license_dno);

	String getFilePath(Map<String, String> map);

	CheckDocsRcdDTO dfbWinShow(Map<String, String> map);

	LicenseDecDTO getBgYx(Map<String, String> yxmap);

	String getzzResult(Map<String, String> yxmap);

	String getzxResult(Map<String, String> yxmap);

	List getScbList(Map<String, String> map2);

	LicenseEventDTO getBzInfo(Map<String, String> map2);

	List getVolist(Map<String, String> map);

	LicenseEventDTO getBzInfo2(Map<String, String> map5);

}
