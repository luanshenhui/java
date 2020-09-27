package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.AuthoritiesDTO;
import com.dpn.ciqqlc.standard.model.DeptmentsDTO;
import com.dpn.ciqqlc.standard.model.OrganizesDTO;
import com.dpn.ciqqlc.standard.model.Res_rolesDTO;
import com.dpn.ciqqlc.standard.model.ResourcesDTO;
import com.dpn.ciqqlc.standard.model.RolesDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.service.UserManageDbService;
/**
 * UserManageDb.
 * 
 * @author
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务实现。
 ********************************************************************************
 * 变更履历
 * -> 
 ***************************************************************************** */
@Repository("userManageDbServ")
public class UserManageDb implements UserManageDbService {
	 /**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
    
    //组织
	public List<OrganizesDTO> findOrganizes(Map<String,String> map) throws Exception {
		return sqlSession.selectList("findOrganizes", map);
	}

	public int findOrganizeCount(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("findOrganizeCount", map);
	}

	public void addOrganizes(Map<String, String> map) throws Exception {
		sqlSession.insert("addOrganizes", map);
	}

	public void delOrganizes(String orgcode) throws Exception {
		sqlSession.delete("delOrganizes", orgcode);
	}

	public OrganizesDTO findOrganizesByCode(String orgcode) throws Exception {
		return sqlSession.selectOne("findOrganizesByCode", orgcode);
	}

	public void updateOrganizes(Map<String, String> map) throws Exception {
		sqlSession.update("updateOrganizes", map);
	}
	
	public List<UsersDTO> selectUserOrg(Map<String, String> map) throws Exception {
		return sqlSession.selectList("selectUserOrg", map);
	}

	//用户
	public List<UsersDTO> findUsers(Map<String, String> map)throws Exception {
		return sqlSession.selectList("findUsers", map);
	}

	public int findUsersCount(Map<String, String> map)throws Exception {
		return sqlSession.selectOne("findUsersCount", map);
	}

	public List<OrganizesDTO> getAllOrgList() throws Exception {
		return sqlSession.selectList("getAllOrgList");
	}

	public List<DeptmentsDTO> getAllDeptList() throws Exception {
		return sqlSession.selectList("getAllDeptList");
	}

	public void addUsers(Map<String, String> map) throws Exception {
		sqlSession.insert("addUsers", map);
	}

	public UsersDTO findUsersByCode(String uid) throws Exception {
		return sqlSession.selectOne("findUsersByCode", uid);
	}

	public void updateUsers(Map<String, String> map) throws Exception {
		sqlSession.update("updateUsers", map);
	}
	
	public void updateUsersFlagOp(Map<String, String> map) throws Exception {
        sqlSession.update("updateUsersFlagOp", map);
    }

	public void delUsers(String uid) throws Exception {
		sqlSession.delete("delUsers", uid);
	}

	public void resetPwd(Map<String, String> map) throws Exception {
		sqlSession.update("resetPwd",map);
	}

	//角色
	public List<RolesDTO> findRoles(Map<String, String> map) throws Exception {
		return sqlSession.selectList("findRoles", map);
	}

	public int findRolesCount(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("findRolesCount", map);
	}

	public void addRoles(Map<String, String> map) throws Exception {
		sqlSession.insert("addRoles", map);
	}

	public void delRoles(String code) throws Exception {
		sqlSession.delete("delRoles", code);
	}
	
	public void setRole(Map<String,String> map) throws Exception {
		sqlSession.insert("addResRole", map);
	}

	//资源
	public List<RolesDTO> findRes(Map<String, String> map) throws Exception {
		return sqlSession.selectList("findRes", map);
	}

	public int findResCount(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("findResCount", map);
	}

	public ResourcesDTO findResByCode(String code) throws Exception {
		return sqlSession.selectOne("findResByCode", code);
	}

	public void updateRes(Map<String, String> map) throws Exception {
		sqlSession.update("updateRes", map);
	}

	public void delRes(String code) throws Exception {
		sqlSession.delete("delRes", code);
	}

	public void addRes(Map<String, String> map) throws Exception {
		sqlSession.insert("addRes", map);
	}

	public void addAuthRoles(Map<String,String> map) throws Exception {
		sqlSession.insert("addAuthRoles",map);
	}
	
	public List<ResourcesDTO> getUserUrl(String id)throws Exception {
		return sqlSession.selectList("getUserUrl", id);
	}	

	//权限
	public List<AuthoritiesDTO> findAuths(Map<String, String> map) throws Exception {
		return sqlSession.selectList("findAuths", map);
	}

	public int findAuthCounts(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("findAuthCounts", map);
	}

	public void delAuth(Map<String, String> map) throws Exception {
		sqlSession.delete("delAuth", map);
	}

	public UsersDTO userLogin(Map<String,String> map) throws Exception {
		return sqlSession.selectOne("userLogin", map);
	}

	public List<RolesDTO> toAddUserAuth(String userId) throws Exception {
		return sqlSession.selectList("selectUnAuthRole", userId);
	}

	public int selectAuthor(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("selectAuthor", map);
	}

	public void addUserAuth(Map<String, String> map) throws Exception {
		sqlSession.insert("addUserAuth", map);
	}

	//角色-资源
	public List<Res_rolesDTO> findResRole(String code) throws Exception {
		return sqlSession.selectList("getRes_role", code);
	}

	public List<RolesDTO> findRolesByCode(Map<String, String> map) throws Exception {
		return sqlSession.selectList("find_Roles", map);
	}

	public void delResRole(String resId) throws Exception {
		sqlSession.delete("delResRole",resId);
	}

	public int resetPwdByUser(Map<String, String> map) throws Exception {
		return sqlSession.update("resetPwdByUser", map);
	}

	public List<OrganizesDTO> findOrganizesByType(String type) throws Exception {
		return sqlSession.selectList("findOrganizesByType", type);
	}

	public List<UsersDTO> findUserListByOrgCode(Map<String, String> map) throws Exception {
		return sqlSession.selectList("findUserListByOrgCode", map);
	}

	public int selectUserOrgCount(Map<String, String> map) {
		return sqlSession.selectOne("selectUserOrgCount", map);
	}

	public int findResRoleCount(String code) {
		return sqlSession.selectOne("findResRoleCount", code);
	}
	
	public UsersDTO findUsersByCodeLogin(String uid) {
		return sqlSession.selectOne("findUsersByCodeLogin", uid);
	}
}