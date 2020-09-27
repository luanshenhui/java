package com.dhc.organization.role.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.ecside.table.limit.Limit;
import org.ecside.util.RequestUtil;

import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.web.struts.SessionCheckBaseDispatchAction;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.organization.role.domain.WF_ORG_ROLE;
import com.dhc.organization.role.service.RoleService;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;
import com.dhc.organization.user.domain.WF_ORG_USER;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 角色管理
 * </p>
 * <p>
 * Description: 角色管理Action类
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 * 			------------------------------------------------------------
 *          </p>
 *          <p>
 *          修改历史
 *          </p>
 *          <p>
 *          序号 日期 修改人 修改原因
 *          </p>
 *          <p>
 *          1
 *          </p>
 */
public class RoleAction extends SessionCheckBaseDispatchAction {
	/**
	 * 角色业务服务对象
	 */
	private RoleService roleService;
	protected static int DEFAULT_PAGE_SIZE = 10;

	/**
	 * 构造函数
	 */
	public RoleAction() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据查询条件获取角色
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward getRole(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		// 跳转方向
		String strForward = request.getParameter("forward");
		strForward = (strForward == null || strForward.equals("")) ? "listPage" : strForward;
		if (SecurityUtil.existUnavailableChar(request, "roleName,isAdminRole")) {
			request.setAttribute("roleList", new ArrayList());
			return mapping.findForward(strForward);
		}

		try {
			String roleName = request.getParameter("roleName");
			roleName = (roleName == null || roleName.equals("") || roleName == "%%") ? null : roleName;
			String isAdminRole = request.getParameter("isAdminRole");
			if (isAdminRole != null && !isAdminRole.equals("")) {
				isAdminRole = isAdminRole.equalsIgnoreCase("true") ? "是" : "否";
			} else {
				isAdminRole = null;
			}

			List returnRoleList = new ArrayList();
			WF_ORG_ROLE roleParam = new WF_ORG_ROLE();
			roleParam.setRoleName(roleName);
			roleParam.setIsAdminrole(isAdminRole);
			// adminUser可以看所有的角色，其它管理员只能看自己的角色
			SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
			if (securityUser.getUserBean() != null
					&& !securityUser.getUserBean().getId().equalsIgnoreCase("adminUser")) {
				WF_ORG_ROLE adminRole = securityUser.getUserBean().getAdminRole();
				if (adminRole != null) {
					roleParam.setParentRoleId(adminRole.getRoleId());
				}
			}
			// Over

			if (roleService == null)
				roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
			// 这里应该取count
			int totalRows = roleService.getRoleCount(roleParam);
			Limit limit = RequestUtil.getLimit(request, totalRows, DEFAULT_PAGE_SIZE);
			int offset = 0;
			int[] rowStartEnd = new int[] { limit.getRowStart() + offset, limit.getRowEnd() + offset };
			roleParam.setStartRow(rowStartEnd[0]);
			roleParam.setEndRow(rowStartEnd[1]);
			// 下面参数用于支持MySQL分页
			roleParam.setPageSize(limit.getCurrentRowsDisplayed());
			// 这里newList 应该根据start end 来重新取一下
			List newList = roleService.getRoleByCondition(roleParam);
			// RequestUtil.initLimit(request,
			// returnRoleList.size(),DEFAULT_PAGE_SIZE);
			request.setAttribute("roleList", newList);
		} catch (ServiceException e) {
			request.setAttribute("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			request.setAttribute("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		}

		return mapping.findForward(strForward);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存角色（新建保存、修改保存）。根据saveType来确定是新建保存还是修改保存
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward saveRole(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request,
				"opFlag,roleId,roleDescription," + "isAdminrole,isUnique,roleName,roleMax,roleUnits,roleUsers")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		String saveType = request.getParameter("opFlag");

		// roleVO赋值
		WF_ORG_ROLE roleVO = new WF_ORG_ROLE();
		if (saveType == null || saveType.equals("0"))
			roleVO.setRoleId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
		else
			roleVO.setRoleId(request.getParameter("roleId"));
		roleVO.setRoleDescription(request.getParameter("roleDescription"));
		roleVO.setIsAdminrole(request.getParameter("isAdminrole"));
		String isUnique = request.getParameter("isUnique");
		roleVO.setIsUnique(isUnique == null ? 0 : Short.parseShort(isUnique));
		roleVO.setRoleName(request.getParameter("roleName"));
		String userNumbers = request.getParameter("roleMax");
		roleVO.setUserNumbers(userNumbers == null ? -1L : Long.parseLong(userNumbers));
		String roleUnits = request.getParameter("roleUnits");
		if (roleUnits != null && !roleUnits.equals("")) {
			if (roleUnits.substring(0, 1).equals(","))
				roleUnits = roleUnits.substring(1);
			if (roleUnits.substring(roleUnits.length() - 1, roleUnits.length()).equals(","))
				roleUnits = roleUnits.substring(roleUnits.length() - 1);
			roleVO.setRoleManageUnitList(Arrays.asList(roleUnits.split(",")));
		} else {
			roleVO.setRoleManageUnitList(null);
		}
		String roleUsers = request.getParameter("roleUsers");
		if (roleUsers != null && !roleUsers.equals("")) {
			if (roleUsers.substring(0, 1).equals(","))
				roleUsers = roleUsers.substring(1);
			if (roleUsers.substring(roleUsers.length() - 1, roleUsers.length()).equals(","))
				roleUsers = roleUsers.substring(roleUsers.length() - 1);
			roleVO.setRoleUsersList(Arrays.asList(roleUsers.split(",")));
		} else {
			roleVO.setRoleUsersList(null);
		}
		// 待做roleVO.setRoleUsersList(request.getParameter("roleDescription"));

		if (roleService == null)
			roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");

		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();

			// 具有管理角色的用户只能看自己添加的角色
			SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
			if (securityUser.getUserBean() != null) {
				WF_ORG_ROLE adminRole = securityUser.getUserBean().getAdminRole();
				if (adminRole != null) {
					roleVO.setParentRoleId(adminRole.getRoleId());
				} else {
					// 除非是模拟url提交，否则不会进入
					throw new ServiceException(OrgI18nConsts.MUST_BE_ADMIN_ROLE);
				}
			}
			// Over
			roleService.saveRole(roleVO, saveType);
			String roleDetail = JSONObject.fromObject(roleVO).toString();
			jsonObject.put("roleDetail", roleDetail);
		} catch (ServiceException e) {
			if (e.getMessage().lastIndexOf("角色的用户数超过上限") > -1)
				jsonObject.put("errorMessage", OrgI18nConsts.ROLE_USER_OVERLOAD);
			else
				jsonObject.put("errorMessage", OrgI18nConsts.ROLE_NAME_ALEADY_EXIST);
			e.printStackTrace();
		} catch (Exception e) {
			jsonObject.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		} finally {
			writer.println(jsonObject.toString());
			writer.flush();
			writer.close();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除角色，如果角色已经被使用，则该组织单元不能被删除
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward deleteRole(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "roleIds")) {
			return mapping.findForward("unpermitted-character");
		}

		String roleID = request.getParameter("roleIds");
		PrintWriter writer = null;
		JSONObject returnJSON = new JSONObject();
		if (roleService == null)
			roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			List delRoleIdList = Arrays.asList(roleID.split(","));
			roleService.deleteRole(delRoleIdList);
		} catch (ServiceException e) {
			returnJSON.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			returnJSON.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		} finally {
			writer.println(returnJSON.toString());
			writer.flush();
			writer.close();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取角色明细
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward getRoleDetail(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "roleID")) {
			return mapping.findForward("unpermitted-character");
		}

		String roleID = request.getParameter("roleID");
		PrintWriter writer = null;
		JSONObject returnJSON = new JSONObject();
		if (roleService == null)
			roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			WF_ORG_ROLE roleDetail = roleService.getRoleDetail(roleID);
			if (roleDetail == null) {
				returnJSON.put("errorMessage", OrgI18nConsts.ROLE_NOT_EXIST);
			} else {
				// 拼出角色下的人员~~~~~~~~~~~~~~~~~~
				String roleManageUnitsKEY = "";
				String roleManageUnitsVALUE = "";
				if (roleDetail.getRoleManageUnitList() != null && roleDetail.getRoleManageUnitList().size() > 0) {
					for (int i = 0; i < roleDetail.getRoleManageUnitList().size(); i++) {
						WF_ORG_UNIT unitVO = (WF_ORG_UNIT) roleDetail.getRoleManageUnitList().get(i);
						roleManageUnitsKEY += unitVO.getUnitId();
						roleManageUnitsVALUE += unitVO.getUnitName();
						// 最后一个字符串后面就不要加“,”了
						if (i == roleDetail.getRoleManageUnitList().size() - 1)
							break;
						roleManageUnitsKEY += ",";
						roleManageUnitsVALUE += ",";
					}
				}
				returnJSON.put("roleManageUnitsKEY", roleManageUnitsKEY);
				returnJSON.put("roleManageUnitsVALUE", roleManageUnitsVALUE);

				// 拼出角色可以管理的组织~~~~~~~~~~~~~~~~~~
				String roleUsersKEY = "";
				String roleUsersVALUE = "";
				if (roleDetail.getRoleUsersList() != null && roleDetail.getRoleUsersList().size() > 0) {
					for (int i = 0; i < roleDetail.getRoleUsersList().size(); i++) {
						WF_ORG_USER UserVO = (WF_ORG_USER) roleDetail.getRoleUsersList().get(i);
						roleUsersKEY += UserVO.getUserId();
						roleUsersVALUE += UserVO.getUserFullname();
						// 最后一个字符串后面就不要加“,”了
						if (i == roleDetail.getRoleUsersList().size() - 1)
							break;
						roleUsersKEY += ",";
						roleUsersVALUE += ",";
					}
				}
				returnJSON.put("roleUsersKEY", roleUsersKEY);
				returnJSON.put("roleUsersVALUE", roleUsersVALUE);

				roleDetail.setRoleManageUnitList(null);
				roleDetail.setRoleUsersList(null);
				returnJSON.put("roleDetail", JSONObject.fromObject(roleDetail).toString());

			}
		} catch (ServiceException e) {
			returnJSON.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			returnJSON.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		} finally {
			writer.println(returnJSON.toString());
			writer.flush();
			writer.close();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有角色，用于角色选择下接列表
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward getAllRoles(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (roleService == null)
			roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
		try {
			WF_ORG_ROLE roleVO = new WF_ORG_ROLE();
			// adminUser可以看所有的角色，其它管理员只能看自己的角色
			SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
			if (securityUser.getUserBean() != null
					&& !securityUser.getUserBean().getId().equalsIgnoreCase("adminUser")) {
				WF_ORG_ROLE adminRole = securityUser.getUserBean().getAdminRole();
				if (adminRole != null) {
					roleVO.setParentRoleId(adminRole.getRoleId());
				}
			}
			// Over
			List roleList = roleService.getAllRoles(roleVO);

			request.setAttribute("roleList", roleList);
		} catch (ServiceException e) {
			request.setAttribute("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			request.setAttribute("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		}

		return mapping.findForward("roleSelect");
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有角色，用于角色选择下接列表
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward getAllRolesJSON(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "isAdminRole")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();

		if (roleService == null)
			roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
		try {
			String isAdminRole = request.getParameter("isAdminRole");
			isAdminRole = (isAdminRole == null || isAdminRole.equals("")) ? null : isAdminRole;
			if (isAdminRole != null)
				isAdminRole = isAdminRole.equalsIgnoreCase("true") ? "是" : "否";
			writer = response.getWriter();
			WF_ORG_ROLE roleVO = new WF_ORG_ROLE();
			roleVO.setIsAdminrole(isAdminRole);
			// adminUser可以看所有的角色，其它管理员只能看自己的角色
			SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
			if (securityUser.getUserBean() != null
					&& !securityUser.getUserBean().getId().equalsIgnoreCase("adminUser")) {
				WF_ORG_ROLE adminRole = securityUser.getUserBean().getAdminRole();
				if (adminRole != null) {
					roleVO.setParentRoleId(adminRole.getRoleId());
				}
			}
			// Over
			List roleList = roleService.getAllRoles(roleVO);
			jsonObject.put("roleList", roleList);
			request.setAttribute("roleList", roleList);
		} catch (ServiceException e) {
			jsonObject.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			jsonObject.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		} finally {
			writer.println(jsonObject.toString());
			writer.flush();
			writer.close();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据role获取角色列表，不分页
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward getRolesInRoleIds(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "roleIds")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		String roleIds = request.getParameter("roleIds");
		roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
		List returnRolelist = null;
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			WF_ORG_ROLE roleVO = new WF_ORG_ROLE();
			// 将传入的roleIds格式化成“'sdfdf','3333','4444'”
			String[] idArray = roleIds.split(",");
			List<String> idList = Arrays.asList(idArray);

			roleVO.setRoleIds(idList);
			String roleNames = "";
			if (idArray.length <= 0) {
				returnRolelist = null;
			} else {
				returnRolelist = roleService.getRoleByIDs(roleVO);
				for (int j = 0; j < returnRolelist.size(); j++) {
					WF_ORG_ROLE role = (WF_ORG_ROLE) returnRolelist.get(j);
					roleNames += role.getRoleName();
					if (j < returnRolelist.size() - 1)
						roleNames += ",";
				}
			}
			jsonObject.put("roleNames", roleNames);
			writer = response.getWriter();
		} catch (ServiceException e) {
			jsonObject.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			jsonObject.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		} finally {
			writer.println(jsonObject.toString());
			writer.flush();
			writer.close();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有管理角色，用于角色选择下接列表
	 * </p>
	 * <p>
	 * 备注: 详见顺序图<br>
	 * </p>
	 * 
	 * @param mapping
	 *            - Struts的ActionMapping对象，包含了请求映射的基本信息。
	 * @param form
	 *            - Struts的ActionForm对象，包含了请求页面要提交的数据(只在配置了FormBean标签时有效)
	 * @param request
	 *            - jsp请求对象
	 * @param response
	 *            - jsp答复对象
	 * @throws 无
	 */
	public ActionForward getAllAdminRoles(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "roleID")) {
			return mapping.findForward("unpermitted-character");
		}

		String roleID = request.getParameter("roleID");
		PrintWriter writer = null;
		JSONObject returnJSON = new JSONObject();
		if (roleService == null)
			roleService = (RoleService) getBaseService().getServiceFacade("TP_RoleService");
		try {
			WF_ORG_ROLE roleVO = new WF_ORG_ROLE();
			roleVO.setIsAdminrole("是");
			roleService.getAllRoles(roleVO);
			writer = response.getWriter();
		} catch (ServiceException e) {
			returnJSON.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} catch (IOException e) {
			returnJSON.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		} finally {
			writer.flush();
			writer.close();
		}
		return null;
	}

	public void setRoleService(RoleService roleService) {
		this.roleService = roleService;
	}

	public RoleService getRoleService() {
		return roleService;
	}
}
