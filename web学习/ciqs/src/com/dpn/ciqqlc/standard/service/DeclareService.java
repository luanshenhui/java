package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.dpn.ciqqlc.http.form.DcForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;

public interface DeclareService {

	public void addLicenseDec(Map<String, Object> map);

	public int getLicenseDecsCount(Map<String, Object> map);

	public List<LicenseDecDTO> getLicenseDecsList(Map<String, Object> map);

	public void licenseDecsDelete(String license_dno);

	public void saveUploadPath(DcForm form, String uploadPath, UserInfoDTO user,String fileType);

	public String saveUpload(HttpServletRequest request,String colum) throws Exception;

	public LicenseDecDTO getLicenseDec(Map<String, Object> map);

	public void licenseDecUpdate(Map<String, Object> map);

	public List<LicenseDecDTO> licenseDecsInfo(Map<String, Object> paramrMap);

	public String selectfilePath(String license_dno, int i);

	public void applyUpdate(Map<String, Object> map);

	public CheckDocsRcdDTO getOptionList(Map<String, Object> map);

	public List<SelectModel> getOrganizeCiq();

	public LicenseDecDTO gethxzzInfo(Map<String, Object> map);

	public Object getOprDate(String string, String license_dno);

}
