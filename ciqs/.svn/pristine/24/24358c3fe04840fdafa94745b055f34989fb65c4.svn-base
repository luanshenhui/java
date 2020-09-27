package com.dpn.ciqqlc.common.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;

public class CommonUtil {
	/*********************************************************************************************************************
	* 根据类型查询所有code
    * @param type
    * @return List
	*********************************************************************************************************************/
	public static List<CodeLibraryDTO> queryCodeLibrary(String type,HttpServletRequest request) throws IOException{
		 SqlSessionTemplate sqlSession = (SqlSessionTemplate)WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext()).getBean("blankSST");
		 return sqlSession.selectList("SQL.COMM.queryCodeLibrary", type); 
	}
	
	/*********************************************************************************************************************
	* List<CodeLibraryDTO>中每一个对象的直属局code是否包含该该flag值
    * @param List<Map<String,String>> String 
    * @return boolean
	*********************************************************************************************************************/
	public static boolean OrganizesContains(List<CodeLibraryDTO> list,String flag) {
		
		   for(CodeLibraryDTO codeLibraryDTO:list){
			   if(codeLibraryDTO.getCode().equals(flag)){
				   return true;
			   }
		   }
           return false;
	}
	
	/*********************************************************************************************************************
	* Map泛型转化
    * @param Map<String,String[]>
    * @return Map<String,String>
	*********************************************************************************************************************/
	public static Map<String,String> getParamsToMap(Map<String,String[]> map) {
		
		  HashMap<String, String> hashMap = new HashMap<String, String>();
		  for (Entry<String, String[]> entry : map.entrySet()) {
				String key = entry.getKey().toString();
				String[] value = map.get(key);
				if (StringUtils.isEmpty(value[0])){
					hashMap.put(key, "");
				}else{
					hashMap.put(key, value[0]);
				}
		   }
           return hashMap;
	}
	
	/**
	 * 根据 【业务主键】+【环节类型】+【顶层环节类型】（【顶层环节类型】不使用则传null）查询文件
	 * @param procMainId
	 * @param procType
	 * @param topProcType
	 * @param request
	 * @return
	 * @throws IOException
	 */
	public static List<VideoFileEventModel> queryVideoFileEvent(String procMainId, String procType, String topProcType, HttpServletRequest request) throws IOException{
		SqlSessionTemplate sqlSession = (SqlSessionTemplate)WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext()).getBean("blankSST");
		Map<String,String> map = new HashMap<String,String>();
		map.put("proc_main_id", procMainId);
		map.put("proc_type", procType);
		map.put("top_proc_type", topProcType);
		return sqlSession.selectList("SQL.COMM.queryVideoFileEvent", map); 
	}
	
	public static List<VideoFileEventModel> queryVideoFileEventByGroupId(String procMainId, String procType, String topProcType, String groupId,HttpServletRequest request) throws IOException{
		SqlSessionTemplate sqlSession = (SqlSessionTemplate)WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext()).getBean("blankSST");
		Map<String,String> map = new HashMap<String,String>();
		map.put("proc_main_id", procMainId);
		map.put("proc_type", procType);
		map.put("top_proc_type", topProcType);
		map.put("group_id", groupId);
		return sqlSession.selectList("SQL.COMM.queryVideoFileEvent", map); 
	}
	
	/**
	 * 查询doc文档
	 * @param procMainId
	 * @param procType
	 * @param request
	 * @return
	 */
	public static CheckDocsRcdDTO queryDoc(String procMainId, String docType, HttpServletRequest request){
		SqlSessionTemplate sqlSession = (SqlSessionTemplate)WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext()).getBean("blankSST");
		Map<String,String> map = new HashMap<String,String>();
		map.put("proc_main_id", procMainId);
		map.put("doc_type", docType);
		List<CheckDocsRcdDTO> docs = sqlSession.selectList("SQL.COMM.queryDoc", map); 
		if(null != docs && docs.size() > 0){
			return docs.get(0);
		}
		return null;
	}
	
	/**
	 * 根据环节类型将附件保存至request对象
	 * 保存方式：request.setAttribute(proc_type, List<VideoFileEventModel>)
	 * @param vList 附件列表，按环节类型proc_type排序
	 * @param request
	 */
	public static void setFileEventToReqByProcType(List<VideoFileEventModel> vList, HttpServletRequest request){
		String proc_type = "";
		List<VideoFileEventModel> subList = new ArrayList<VideoFileEventModel>();
		for(VideoFileEventModel v : vList){
			if( !proc_type.equals(v.getProc_type())){
				request.setAttribute(proc_type, subList.toArray());
				subList.clear();
				proc_type = v.getProc_type();
			}
			subList.add(v);
		}
		request.setAttribute(proc_type, subList.toArray());//last one
	}
	
	/**
	 * 根据环节类型集合，查询某些环节类型中照片/视频最大上传时间
	 * @param request
	 * @param proc_main_id
	 * @param fileProcTypes
	 * @param docProcTypes
	 * @return
	 */
	public static VideoFileEventModel getMaxDateFileInProcTypes(HttpServletRequest request, String proc_main_id, String[] fileProcTypes, String[] docProcTypes){
		SqlSessionTemplate sqlSession = (SqlSessionTemplate)WebApplicationContextUtils.getRequiredWebApplicationContext(request.getSession().getServletContext()).getBean("blankSST");
		VideoFileEventModel maxDateFile = null;
		VideoFileEventModel maxDateDoc = null;
		Map<String,Object> map = new HashMap<String,Object>();
		
		if(null != fileProcTypes){
			map.put("proc_main_id", proc_main_id);
			map.put("proc_type_array", fileProcTypes);
			List<VideoFileEventModel> vList = sqlSession.selectList("SQL.COMM.getMaxDateFileInProcTypes", map);
			if(null != vList && vList.size() > 0){
				maxDateFile = vList.get(0);
			}
			map.clear();
		}
		if(null != docProcTypes){
			map.put("proc_main_id", proc_main_id);
			map.put("proc_type_array", docProcTypes);
			List<VideoFileEventModel> vList = sqlSession.selectList("SQL.COMM.getMaxDateDocInProcTypes", map);
			if(null != vList && vList.size() > 0){
				maxDateDoc = vList.get(0);
			}
		}
		
		if(null != maxDateFile && null != maxDateDoc){
			if(maxDateFile.getCreate_date_str().compareTo(maxDateDoc.getCreate_date_str()) < 0){
				return maxDateDoc;
			}else{
				return maxDateFile;
			}
		}else{
			if(null != maxDateFile){
				return maxDateFile;
			}else if(null != maxDateDoc){
				return maxDateDoc;
			}
		}
		return null;
	}
}
