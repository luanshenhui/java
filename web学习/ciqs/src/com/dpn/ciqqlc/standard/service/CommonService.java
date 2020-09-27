package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.CheckResultModel;
import com.dpn.ciqqlc.standard.model.ChkRckModel;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.CountryDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;

public interface CommonService {
	
	
	/**
	 * 结果保存
	 * */
	
	void insertConfirm(ChkRckModel chkRckModel) throws Exception;
	List<CheckResultModel> selectCheckResult(CheckResultModel checkResult);
	
	/**
	 * 移动端上传图片
	 * @param VideoEventModel
	 * @return 0新增失败，1新增成功
	 */
	int save (VideoEventModel VideoEventModel);
	
	/**
	 * 单据数据存储
	 * @throws Exception 
	 * */
	void insertDocs(CheckDocsRcdModel checkDocsRcdModel) throws Exception;
	/**
	 * 查询国家列表
	 * */
	List<CountryDTO> getCountryList(CountryDTO country);
	/**
	 * 获取CodeLibrary代码
	 * @param map   键：type（类型）；port_org_code（当前用户的port_org_code）
	 * @return
	 * @throws Exception
	 */
	List<CodeLibraryDTO> getCodeLibrary(Map<String, String> map);
	
	/**
	 * 获取系统登录人的分支局名称
	 * @param map 
	 * @return
	 * @throws Exception
	 */
	String getDzOrgName(Map<String, Object> map);
	
	/**
	 * 根据主键修改doc
	 * @param checkDocsRcd
	 */
	void updateDocs(CheckDocsRcdModel checkDocsRcd);
	
	/**
	 * 根据业务主键+文档类型删除记录
	 * @param checkDocsRcdModel
	 * @return
	 */
	int deleteDocsByDocTypeNProcMainId(CheckDocsRcdModel checkDocsRcdModel);
	
	String getOrg_code(String create_user);
	
	String getDirecty_under_org(String create_user);
	void updateDocsByApplyNo(CheckDocsRcdModel checkDocsRcdModel);
	/**
	 * 根据业务主键和环节删除event表
	 * @param v
	 */
	void deleteEvent(VideoEventModel v);
	
	String getCiqsIp(Map queryMap);

	public Boolean isDirectyUnderOrg(HttpServletRequest request);
	
	public String getOrg_code(HttpServletRequest request) ;
	
	String getOrgType(HttpServletRequest request, String sealPdfType);
}
