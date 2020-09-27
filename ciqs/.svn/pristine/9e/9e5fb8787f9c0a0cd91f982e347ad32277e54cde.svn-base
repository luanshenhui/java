package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.HygieneLicenseEventDto;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
/**
 * LicenseDecDbService.
 * 
 * @author LiuChao
 * @since 1.0.0
 * @version 1.0.0
 */
public interface LicenseWorkService {
	
	List<LicenseDecDTO> findWorkAlert(Map<String, String> map);
	
	List<CodeLibraryDTO> findPortOrgCode();
	
	public int findCounts(Map<String, String> map);
	
	void updateProlong(Map<String,String> map);
	
	List<LicenseDecDTO> findWorkFlow(Map<String, String> map);
	
	public int findFlowCounts(Map<String, String> map);
	
	List<LicenseDecDTO> selectFlowCard(String license_dno);

	List<HygieneLicenseEventDto> selectHygieneCard(String licence_id);

	String getLicenseNoByOptionList(Map<String, String> map);
	
	
}
