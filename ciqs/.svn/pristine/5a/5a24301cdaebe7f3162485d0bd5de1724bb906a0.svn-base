package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;
import com.dpn.ciqqlc.standard.model.EventLogDTO;
import com.dpn.ciqqlc.standard.model.OrganizesDTO;
import com.dpn.ciqqlc.standard.model.UserInfoAppDTO;


/**
 * CommonUtilDbService.
 * 
 * @author
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
public interface CommonUtilDbService {
	    
	    // select.*******************************************************************
		/**
		 * 页面用组织名称ajax获取组织代码的功能
		 * @param orgName
		 * @return
		 * @throws Exception
		 */
		List<OrganizesDTO> ajaxOrganize(String orgName)  throws Exception;
		
		/**
		 * 获取CodeLibrary代码
		 * @param map   键：type（类型）；port_org_code（当前用户的port_org_code）
		 * @return
		 * @throws Exception
		 */
		List<CodeLibraryDTO> getCodeLibrary(Map<String,String> map)  ;
		
		/**
		 * 插入EventLog
		 * @param map
		 * @throws Exception
		 */
		void addEventLog(Map<String,String> map) throws Exception;
		
		/**
		 * 获取全部组织机构
		 * @return
		 */
		public Map<String,OrganizesDTO> findAllOrganize();
		
		/**
		 * 小时集合
		 */
		public List<String> hoursList();
		
		/**
		 * 分集合
		 */
		public List<String> minuteList();
		
		/**
		 * 根据uid获取此用户所属机构下的所有用户集合
		 */
		public List<UserInfoAppDTO> findUserListByUid(String uid) throws Exception;
		
		/**
		 * 根据uid获取UserInfoAppDTO
		 */
		public UserInfoAppDTO findUserInfoAppByUid(String uid) throws Exception;
		
		/**
		 * 自增工作序号
		 */
		public String selectDecMasterId();
		
		List<OrganizesDTO> findOrganizeAll() throws Exception;
		
		public void insertEventLog(EventLogDTO event);
}
