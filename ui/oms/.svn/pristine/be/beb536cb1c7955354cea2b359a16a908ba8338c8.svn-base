package cn.rkylin.oms.system.role.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CachePut;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageInfo;

import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.menu.dao.IMenuDAO;
import cn.rkylin.oms.system.privilege.dao.IMenuGrantDAO;
import cn.rkylin.oms.system.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import cn.rkylin.oms.system.role.dao.IRoleDAO;
import cn.rkylin.oms.system.role.domain.WF_ORG_ROLE;
import cn.rkylin.oms.system.role.vo.RoleVo;
import cn.rkylin.oms.system.unit.dao.IUnitDAO;
import cn.rkylin.oms.system.unit.domain.WF_ORG_UNIT;
import cn.rkylin.oms.system.user.dao.IUserDAO;
import cn.rkylin.oms.system.user.domain.WF_ORG_USER;

@Service("roleService")
public class RoleServiceImple extends ApolloService implements IRoleService{
	@Autowired
	private IRoleDAO iroleDAO;
	@Autowired
	private IUnitDAO iunitDAO;
	@Autowired
	private IUserDAO iuserDAO;
	@Autowired
	private IMenuDAO imenuDAO;
	@Autowired
	IMenuGrantDAO iMenuGrantDAO;
	
	public PageInfo<RoleVo> findByWhere(int page, int rows, RoleVo roleVo) throws Exception{
		PageInfo<RoleVo> roleVOList = findPage(page, rows, "getRoleByCondition", roleVo);
		
		return roleVOList;
		
		
	}

	@Override
	public WF_ORG_ROLE getRoleDetail(String roleID) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}


	
	@Transactional
	@CachePut(value="role", key="T(String).valueOf('role:').concat(#roleVo.roleId)")
	public void insert(RoleVo roleVo) throws Exception{
		
		WF_ORG_ROLE role = new WF_ORG_ROLE();
//		BeanUtils.copyProperties(roleVo, role);
		iroleDAO.insert("insertRole", roleVo);
	}
	

	@Transactional
	public void delete(String roleId) throws Exception{
		
		try{
			List<String> listid = Arrays.asList(roleId.split(","));
			for(int i=0;i<listid.size();i++)
			{
				iroleDAO.delete("deleteRole", listid.get(i));
				
				WF_ORG_RESOURCE_AUTHORITY auth = new WF_ORG_RESOURCE_AUTHORITY();
				auth.setRoleId(listid.get(i));
				iMenuGrantDAO.deletePrivileges(auth);
			
			}
		}catch(BusinessException ex)
		{
			ex.printStackTrace();
			throw new Exception("角色已被使用,不能删除！");
		}
		//iroleDAO.delete("deleteRoleUnit", roleId);
		// 删除角色下的所有人员
		//iroleDAO.delete("deleteRoleUser", roleId);
	}
	
	public WF_ORG_ROLE selectRoleDetail(String roleId) throws Exception
	{
		
//		WF_ORG_ROLE roleModel = iroleDAO.findByid("getRoleByCondition", roleId);
		WF_ORG_ROLE roleModel = iroleDAO.findByid("selectByPrimaryKeyRole", roleId);
		
		WF_ORG_USER user = new WF_ORG_USER();
		user.setRoleId(roleId);
		roleModel.setRoleUsersList(iuserDAO.getUserByCondition(user));
		WF_ORG_UNIT unit = new WF_ORG_UNIT();
		unit.setRoleId(roleId);
		roleModel.setRoleManageUnitList(iunitDAO.getUnitByCondition(unit));
		
		
		return roleModel;
		
		
	}
	
	public void update(RoleVo roleVo)throws Exception{

		iroleDAO.delete("deleteRoleUnit", roleVo.getRoleId());
		// 删除角色下的所有人员
		iroleDAO.delete("deleteRoleUser", roleVo.getRoleId());
		iroleDAO.update(roleVo);
		
	}

	@SuppressWarnings("rawtypes")
	@Override
	public List getAllRoles(WF_ORG_ROLE roleVO) throws Exception{
		List returnList = new ArrayList();
		try {
			returnList = iroleDAO.getAllRoles(roleVO);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception(ex.getMessage());
		}
		return returnList;
	}
}
