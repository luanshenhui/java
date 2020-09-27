package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.AuthoritiesDTO;
import com.dpn.ciqqlc.standard.model.DeptmentsDTO;
import com.dpn.ciqqlc.standard.model.OrganizesDTO;
import com.dpn.ciqqlc.standard.model.Res_rolesDTO;
import com.dpn.ciqqlc.standard.model.ResourcesDTO;
import com.dpn.ciqqlc.standard.model.RolesDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;
/**
 * UserManageService.
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
public interface UserManageDbService {
	    
	    // select.*******************************************************************
		/**
		 * 用户登录
		 * @param map
		 * @return
		 * @throws Exception
		 */
		public UsersDTO userLogin(Map<String, String> map)  throws Exception;

		/**
		 * 获取用户URL
		 * @param object
		 * @return
		 * @throws Exception
		 */
		public List<ResourcesDTO> getUserUrl(String id)  throws Exception;
	
		/**
		 * 分页查询组织列表
		 * @param map
		 * @return
		 * @throws Exception
		 */
		List<OrganizesDTO> findOrganizes(Map<String,String> map) throws Exception;

		/**
		 * 查询组织表页数
		 * @param map
		 * @return
		 * @throws Exception
		 */
		int findOrganizeCount(Map<String, String> map) throws Exception;

		/**
		 * 按组织代码查询组织
		 * @param orgcode
		 * @return
		 * @throws Exception
		 */
		OrganizesDTO findOrganizesByCode(String orgcode) throws Exception;
		
		/**
		 * 查询用户列表
		 * @param map
		 * @return
		 */
		List<UsersDTO> findUsers(Map<String, String> map)throws Exception;
		
		/**
		 * 查询用户列表记录数
		 * @param map
		 * @return
		 */
		int findUsersCount(Map<String, String> map)throws Exception;
	   
		/**
		 * 获取组织代码信息
		 * @return
		 * @throws Exception
		 */
		List<OrganizesDTO> getAllOrgList() throws Exception;
		
		/**
		 *查询用户组织信息
		 * @param map 用户名或组织代码
		 * @return
		 * @throws Exception
		 */
		List<UsersDTO> selectUserOrg (Map<String,String> map) throws Exception;	    	
		
		/**
		 * 获取科室代码信息
		 * @return
		 */
		List<DeptmentsDTO> getAllDeptList() throws Exception;
		
		/**
		 * 查询单个用户
		 * @param uid
		 * @return
		 * @throws Exception
		 */
		UsersDTO findUsersByCode(String uid) throws Exception;
		
		/**
		 * 查询角色列表
		 * @param map
		 * @return
		 * @throws Exception
		 */
		List<RolesDTO> findRoles(Map<String, String> map) throws Exception;
		
		/**
		 * 查询角色个数
		 * @param map
		 * @return
		 * @throws Exception
		 */
		int findRolesCount(Map<String, String> map) throws Exception;
		
		
		/**
		 * 查询资源列表
		 * @param map
		 * @return
		 * @throws Exception
		 */
		List<RolesDTO> findRes(Map<String, String> map) throws Exception;
		
		/**
		 * 查询资源列表个数
		 * @param map
		 * @return
		 * @throws Exception
		 */
		int findResCount(Map<String, String> map) throws Exception;
		
		/**
		 * 查询单个资源
		 * @param code
		 * @return
		 * @throws Exception
		 */
		ResourcesDTO findResByCode(String code) throws Exception;
		
		/**
		 * 查询单个用户ID对应的权限
		 * @param userId
		 * @return
		 * @throws Exception
		 */
		 List<RolesDTO> toAddUserAuth(String userId) throws Exception;
		 
		/**
		 * 查询权限列表
		 * @param map
		 * @return
		 */
		List<AuthoritiesDTO> findAuths(Map<String, String> map) throws Exception;

		/**
		 * 查询权限个数
		 * @param map
		 * @return
		 * @throws Exception
		 */
		int findAuthCounts(Map<String, String> map) throws Exception;		 

		 /**
		  * 查询当前用户已赋予的角色个数
		  * @param map
		  * @return
		  * @throws Exception
		  */
		int selectAuthor(Map<String, String> map) throws Exception;
		
		
		/**
		 * 查询资源CODE查询对应的角色列表
		 * @param code
		 * @return
		 * @throws Exception
		 */
		List<Res_rolesDTO> findResRole(String code)throws Exception;

		/**
		 * 查询当前资源下未被赋予的角色ID列表
		 * @param map
		 * @return
		 * @throws Exception
		 */
		List<RolesDTO> findRolesByCode(Map<String, String> map) throws Exception;		
		
		/**
		 * 登录时查询单个用户
		 * @param uid
		 * @return
		 * @throws Exception
		 */
		UsersDTO findUsersByCodeLogin(String uid) throws Exception;

		
		
		// insert.*****************************************************************
		/**
		 * 新增组织
		 * @param map
		 * @throws Exception
		 */
		void addOrganizes(Map<String, String> map) throws Exception;
		
		/**
		 * 新增用户
		 * @param map
		 * @throws Exception
		 */
	    void addUsers(Map<String, String> map) throws Exception;
	    
	    /**
	     * 新增角色
	     * @param map
	     * @throws Exception
	     */
	    void addRoles(Map<String, String> map) throws Exception;
	    
		/**
		 * 新增角色给用户
		 * @param map
		 * @throws Exception
		 */
		void addAuthRoles(Map<String,String> map) throws Exception;
	    
	    /**
	     * 新增资源
	     * @param map
	     * @throws Exception
	     */
	    void addRes(Map<String, String> map) throws Exception;
	    
	    /**
	     * 新增资源给角色
	     * @param map
	     */
	    void setRole(Map<String,String> map) throws Exception;
	    
	    /**
	     * 新增权限
	     * @param map
	     * @throws Exception
	     */
		void addUserAuth(Map<String, String> map) throws Exception;		
		
	    
	    
	    // update.*****************************************************************
		/**
		 * 编辑组织
		 * @param map
		 */
		void updateOrganizes(Map<String, String> map)throws Exception;
	    
		/**
		 * 编辑用户
		 * @param map
		 */
		void updateUsers(Map<String, String> map)throws Exception;
		
		/**
		 * 用户启/停用
		 */
		void updateUsersFlagOp(Map<String, String> map)throws Exception;
		
		/**
		 * 重置密码
		 * @param map
		 */
		void resetPwd(Map<String, String> map) throws Exception;
		
		/**
		 * 用户修改密码
		 * @param map
		 * @return
		 * @throws Exception
		 */
		int resetPwdByUser(Map<String, String> map) throws Exception;
		
		/**
		 * 修改资源
		 * @param map
		 * @throws Exception
		 */
		void updateRes(Map<String, String> map) throws Exception;
	    // delete.*****************************************************************
		/**
		 * 删除组织
		 * @param orgcode
		 * @throws Exception
		 */
		void delOrganizes(String orgcode) throws Exception;

		/**
		 * 删除用户
		 * @param uid
		 * @throws Exception
		 */
		void delUsers(String uid) throws Exception;

		/**
		 * 删除角色
		 * @param code
		 */
		void delRoles(String code) throws Exception;

		/**
		 * 删除资源
		 * @param code
		 */
		void delRes(String code) throws Exception;


		/**
		 * 删除权限
		 * @param map
		 */
		void delAuth(Map<String, String> map) throws Exception;

		
		/**
		 * 删除角色和资源对应关系
		 * @param resid
		 * @throws Exception
		 */
		void delResRole(String resid) throws Exception;
		
		/**
		 * 根据type获取组织集合
		 * @param type
		 * @return
		 * @throws Exception
		 */
		List<OrganizesDTO> findOrganizesByType(String type) throws Exception;

		/**
		 * 根据组织代码获取当前科室所有人员
		 * @param orgCode
		 * @return
		 * @throws Exception
		 */
		List<UsersDTO> findUserListByOrgCode(Map<String, String> map) throws Exception;

		public int selectUserOrgCount(Map<String, String> map);

		public int findResRoleCount(String code);
}
