package com.dpn.ciqqlc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.apache.ws.security.util.UUIDGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.common.util.FileUtil;
import com.dpn.ciqqlc.http.form.DcForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.LicenseDecDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.DeclareService;

@Repository("declareService")
public class DeclareDbService implements DeclareService{

	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession = null;

	public int getLicenseDecsCount(Map<String, Object> map) {
		return sqlSession.selectOne("SQL.DC.getLicenseDecsCount",map);
	}

	public List<LicenseDecDTO> getLicenseDecsList(Map<String, Object> map) {
		return sqlSession.selectList("SQL.DC.getLicenseDecsList", map);
	}

	public void addLicenseDec(Map<String, Object> map) {
		sqlSession.insert("SQL.DC.addLicenseDec",map);
	}

	public void licenseDecsDelete(String license_dno) {
		sqlSession.delete("SQL.DC.licenseDecsDelete",license_dno);
	}

	public void saveUploadPath(VideoEventModel video) {
		sqlSession.insert("SQL.DC.saveUploadPath", video);
	}

	public LicenseDecDTO getLicenseDec(Map<String, Object> map) {
		return (LicenseDecDTO)sqlSession.selectOne("SQL.DC.getLicenseDec",map);
	}

	public void licenseDecUpdate(Map<String, Object> map) {
		sqlSession.update("SQL.DC.licenseDecUpdate",map);
	}

	public List<LicenseDecDTO> licenseDecsInfo(Map<String, Object> map) {
		return sqlSession.selectList("SQL.DC.licenseDecsInfo",map);
	}

	public String selectfilePath(String license_dno, int file_type) {
		Map map = new HashMap();
		map.put("file_type",file_type);
		map.put("proc_main_id",license_dno);
		return (String)sqlSession.selectOne("SQL.DC.selectfilePath",map);
	}

	public boolean isUploadPath(String license_dno, String fileType) {
		Map map = new HashMap();
		map.put("proc_main_id",license_dno);
		map.put("file_type",fileType);
		List<VideoEventModel> list = sqlSession.selectList("SQL.DC.isUploadPath",map);
		if(list != null && list.size() > 0){
			return false;
		}else{
			return true;
		}
		
	}

	public void updateUploadPath(VideoEventModel video) {
		sqlSession.update("SQL.DC.updateUploadPath",video);
	}

	public void applyUpdate(Map<String, Object> map) {
		sqlSession.update("SQL.DC.applyUpdate",map);
	}

	public CheckDocsRcdDTO getOptionList(Map<String, Object> map) {
		List list = sqlSession.selectList("SQL.DC.getOptionList",map);
		if(list !=null && list.size() > 0){
			return (CheckDocsRcdDTO)list.get(0);
		}
		return null;
	}

	public void saveUploadPath(DcForm form, String uploadPath,
			UserInfoDTO user, String fileType) {
		if(uploadPath!=null && !"".equals(uploadPath)){
			// 把文件的路径信息保存到数据库中
			VideoFileEventModel video = new VideoFileEventModel();
			video.setId(String.valueOf(new UUIDGenerator()));
			video.setProc_main_id(form.getLicense_dno());
			video.setFile_name(uploadPath);
			video.setFile_type(fileType);
			video.setCreate_user(user.getId());
			sqlSession.insert("saveUploadPath",video);
		}
		
	}

	public String saveUpload(HttpServletRequest request, String colum) throws Exception {
		List<Map<String, String>> filePaths = FileUtil.upXkloadFile(request,false);
        if(filePaths != null && filePaths.size() > 0){
        	Map<String, String> map = (Map)filePaths.get(0);
        	return map.get("filePath");
        }
		return null;
	}

	@Override
	public List<SelectModel> getOrganizeCiq() {
		return sqlSession.selectList("SQL.DC.getorganize_ciq");
	}

	@Override
	public LicenseDecDTO gethxzzInfo(Map<String, Object> map) {
		return sqlSession.selectOne("SQL.DC.gethxzzInfo",map);
	}

	@Override
	public Object getOprDate(String string, String license_dno) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("status", string);
		map.put("license_dno", license_dno);
		return sqlSession.selectOne("SQL.DC.getOprDate",map);
	}


}
