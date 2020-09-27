package cn.rkylin.oms.system.role.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CachePut;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.github.pagehelper.PageInfo;
import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.service.ApolloService;
import cn.rkylin.oms.system.privilege.dao.IMenuGrantDAO;
import cn.rkylin.oms.system.privilege.domain.WF_ORG_RESOURCE_AUTHORITY;
import cn.rkylin.oms.system.role.dao.IRoleDAO;
import cn.rkylin.oms.system.role.domain.WF_ORG_ROLE;
import cn.rkylin.oms.system.role.vo.RoleVo;
import cn.rkylin.oms.system.unit.dao.IUnitDAO;
import cn.rkylin.oms.system.unit.domain.WF_ORG_UNIT;
import cn.rkylin.oms.system.user.dao.IUserDAO;
import cn.rkylin.oms.system.user.domain.WF_ORG_USER;

/**
 * <p>
 * Module : 角色管理
 * </p>
 * <p>
 * Description: 角色业务对象
 * </p>
 * 
 */
@Service("roleService")
public class RoleServiceImple extends ApolloService implements IRoleService {
	
	/**
	 * 角色数据访问对象
	 */
	@Autowired
	private IRoleDAO iroleDAO;
	
	/**
	 * 岗位数据访问对象
	 */
	@Autowired
	private IUnitDAO iunitDAO;

	/**
	 * 用户数据访问对象
	 */
	@Autowired
	private IUserDAO iuserDAO;
	
	/**
	 * 授权管理数据访问对象
	 */
	@Autowired
	IMenuGrantDAO iMenuGrantDAO;

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 */
	public PageInfo<RoleVo> findByWhere(int page, int rows, RoleVo roleVo) throws Exception {
		PageInfo<RoleVo> roleVOList = findPage(page, rows, "getRoleByCondition", roleVo);

		return roleVOList;

	}


	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 添加角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 */
	@Transactional
	@CachePut(value = "role", key = "T(String).valueOf('role:').concat(#roleVo.roleId)")
	public void insert(RoleVo roleVo) throws Exception {
		if (roleVo.getUserNumbers() >= 0 && roleVo.getRoleUsersList() != null) {
			if (roleVo.getRoleUsersList().size() > roleVo.getUserNumbers()) {
				throw new Exception("角色的用户数超过上限");
			}
		}
		iroleDAO.insert("insertRole", roleVo);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除角色，如果角色已经被使用则不被删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 */
	@Transactional
	public void delete(String roleId) throws Exception {
		try {
			List<String> listid = Arrays.asList(roleId.split(","));
			for (int i = 0; i < listid.size(); i++) {
				iroleDAO.delete("deleteRole", listid.get(i));

				WF_ORG_RESOURCE_AUTHORITY auth = new WF_ORG_RESOURCE_AUTHORITY();
				auth.setRoleId(listid.get(i));
				iMenuGrantDAO.deletePrivileges(auth);
			}
		} catch (BusinessException ex) {
			ex.printStackTrace();
			throw new Exception("角色已被使用,不能删除！");
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 */
	public WF_ORG_ROLE selectRoleDetail(String roleId) throws Exception {

		// WF_ORG_ROLE roleModel = iroleDAO.findByid("getRoleByCondition",
		// roleId);
		WF_ORG_ROLE roleModel = iroleDAO.findByid("selectByPrimaryKeyRole", roleId);

		WF_ORG_USER user = new WF_ORG_USER();
		user.setRoleId(roleId);
		roleModel.setRoleUsersList(iuserDAO.getUserByCondition(user));
		WF_ORG_UNIT unit = new WF_ORG_UNIT();
		unit.setRoleId(roleId);
		roleModel.setRoleManageUnitList(iunitDAO.getUnitByCondition(unit));

		return roleModel;

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 修改角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 */
	public void update(RoleVo roleVo) throws Exception {
		if (roleVo.getUserNumbers() >= 0 && roleVo.getRoleUsersList() != null) {
			if (roleVo.getRoleUsersList().size() > roleVo.getUserNumbers()) {
				throw new Exception("角色的用户数超过上限");
			}
		}
		iroleDAO.delete("deleteRoleUnit", roleVo.getRoleId());
		// 删除角色下的所有人员
		iroleDAO.delete("deleteRoleUser", roleVo.getRoleId());
		iroleDAO.update(roleVo);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getAllRoles(WF_ORG_ROLE roleVO) throws Exception {
		List returnList = new ArrayList();
		try {
			returnList = iroleDAO.getAllRoles(roleVO);
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new Exception(ex.getMessage());
		}
		return returnList;
	}
	
	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据条件获取角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 *
	 * @param roleName
	 *            - 角色名称
	 * @param isAdminRole
	 *            - 角色类型：是，否
	 * @return 如果找到，返回List<JT_UNIT_ROLE> 如果没有找到，返回null
	 * @throws ServiceException
	 */
	public List getRoleByIDs(WF_ORG_ROLE roleVO) throws Exception {
		List resultList = new ArrayList();
		try {
			resultList = iroleDAO.getRoleByIDs(roleVO);
		} catch (Exception e) {
			throw new Exception(e.getMessage());
		}
		return resultList;
	}

	@Override
	public void enableFlg(String roleid, String roleEnable) throws Exception {
		iroleDAO.updateEnable(roleid, roleEnable);
	}

}
