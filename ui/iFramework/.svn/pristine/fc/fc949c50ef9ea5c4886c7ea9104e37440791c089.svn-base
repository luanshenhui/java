package com.dhc.authorization.resource.privilege.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.dhc.authorization.resource.menu.domain.WF_ORG_MENU;
import com.dhc.authorization.resource.menu.service.MenuService;
import com.dhc.authorization.resource.privilege.service.PrivilegeService;
import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.web.struts.SessionCheckBaseDispatchAction;
import com.dhc.organization.config.OrgI18nConsts;

/**
 * brief description
 * <p>
 * Date : 2010/05/11
 * </p>
 * <p>
 * Module : 权限管理
 * </p>
 * <p>
 * Description: 权限管理action
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
public class PrivilegeAction extends SessionCheckBaseDispatchAction {
	/**
	 * 权限业务服务对象
	 */
	private PrivilegeService privilegeService;
	/**
	 * 菜单管理业务服务对象
	 */
	private MenuService menuService;

	/**
	 * 构造函数
	 */
	public PrivilegeAction() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取角色/岗位所有可使用的“资源”（仅菜单项）
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
	public void getMenuTreePrivilege(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取角色/岗位菜单项下所有菜单项的可用性
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
	public ActionForward getPageElementPrivilege(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "type,id,menuID,isAdminRole")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		// 授权类型：role，position，unit
		String type = request.getParameter("type");
		// 授权类型的具体ID
		String id = request.getParameter("id");
		id = id.replaceAll("@ROLE", "");
		id = id.replaceAll("@UNIT", "");
		id = id.replaceAll("@STATION", "");
		// 当前所选menu的ID
		String menuID = request.getParameter("menuID");
		menuID = (menuID == null || menuID.equals("")) ? null : menuID;
		if (menuID != null) {
			menuID = menuID.replaceAll("@MENU", "");
			menuID = menuID.replaceAll("@STATION", "");
			menuID = menuID.replaceAll("@PAGE", "");
		}
		// 是否管理授权(即是否是可授权,true表示可授权，false表示可分配)
		String isAssignable = request.getParameter("isAdminRole");
		isAssignable = isAssignable == null || isAssignable.equals("") ? "false" : isAssignable;

		Map authMap = null;

		if (privilegeService == null)
			privilegeService = (PrivilegeService) getBaseService().getServiceFacade("TP_PrivilegeService");

		try {
			writer = response.getWriter();

			// 如果是“管理授权”
			if (isAssignable.equals("true")) {
				authMap = privilegeService.getElementPrivByMenuIDRoleID(id, type, menuID, "assignable");
			} else {
				authMap = privilegeService.getElementPrivByMenuIDRoleID(id, type, menuID, "available");
			}
			if (authMap.containsKey(null)) {
				authMap.remove(null);
			}
			if (authMap != null && authMap.size() > 0) {
				jsonObject.put("authMap", authMap);
			}
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
	 * 描述: 根据页面id，获取该页面下的元素可用性
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
	public ActionForward getPEP(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "id")) {
			return mapping.findForward("unpermitted-character");
		}
		// 获取子菜单分类的条件(子系统名称)，作为菜单查询的参数
		Object obj = request.getSession().getServletContext().getAttribute("APP_NAME");
		String menuCategory = (obj == null || obj.toString().equalsIgnoreCase("iFramework")
				|| obj.toString().equals("")) ? null : obj.toString();

		menuService = (MenuService) getBaseService().getServiceFacade("TP_MenuService");
		List list = null;
		String returnValue = "";
		String parentMenuCode = request.getParameter("id").toString();
		parentMenuCode = parentMenuCode.substring(0,
				(parentMenuCode.lastIndexOf("@") == -1 ? parentMenuCode.length() : parentMenuCode.lastIndexOf("@")));
		try {
			String userID = null;
			SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
			userID = securityUser.getUserBean().getId();
			// authorityType为available，表示取可使用的，而不 是可分配的
			list = menuService.getFormElementList(null, parentMenuCode, "available", menuCategory);
			if (list != null) {
				for (int i = 0; i < list.size(); i++) {
					WF_ORG_MENU menu = (WF_ORG_MENU) list.get(i);
					if (i == list.size() - 1)
						returnValue = returnValue + menu.getMenuElementId();
					else
						returnValue = returnValue + menu.getMenuElementId() + ",";
				}
			}
			response.getWriter().write(returnValue);
			// } else {
			// response.getWriter().write("<item/>");
			// }
		} catch (ServiceException e1) {
			e1.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存用户对权限的修改
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
	public ActionForward savePrivileges(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "type,id,resIDs4Add,resIDs4Del," + "isAdminRole")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		// 授权类型：role，position，unit，user
		String type = request.getParameter("type");
		// 授权类型的具体ID
		String id = request.getParameter("id");

		// 新添加的授权
		String resIDs4Add = request.getParameter("resIDs4Add");
		resIDs4Add = resIDs4Add.replaceAll("@MENU", "");
		resIDs4Add = resIDs4Add.replaceAll("@ELEMENT", "");
		resIDs4Add = resIDs4Add.replaceAll("@PAGE", "");
		resIDs4Add = resIDs4Add.replaceAll("RootMenu,", "");
		resIDs4Add = resIDs4Add.replaceAll(",RootMenu", "");
		resIDs4Add = resIDs4Add.replaceAll("RootMenu", "");

		// 删除掉的授权
		String resIDs4Del = request.getParameter("resIDs4Del");
		resIDs4Del = resIDs4Del.replaceAll("@MENU", "");
		resIDs4Del = resIDs4Del.replaceAll("@ELEMENT", "");
		resIDs4Del = resIDs4Del.replaceAll("@PAGE", "");
		resIDs4Del = resIDs4Del.replaceAll("RootMenu,", "");
		resIDs4Del = resIDs4Del.replaceAll(",RootMenu", "");
		resIDs4Del = resIDs4Del.replaceAll("RootMenu", "");

		// 保存类型（业务授权保存？还是管理授权保存?）
		String isAssignableSave = request.getParameter("isAdminRole");
		isAssignableSave = isAssignableSave == null || isAssignableSave.equals("") ? "false" : isAssignableSave;
		isAssignableSave = isAssignableSave.equals("true") ? "assignable" : "available";

		if (privilegeService == null)
			privilegeService = (PrivilegeService) getBaseService().getServiceFacade("TP_PrivilegeService");

		try {
			writer = response.getWriter();
			privilegeService.savePrivileges(id, type, resIDs4Add, resIDs4Del, isAssignableSave);

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
	 * 描述: 获取角色/岗位所有“可分配”的“资源”（仅菜单项）
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
	public void getMenuTreeRegrantable(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

	}

	public void setPrivilegeService(PrivilegeService privilegeService) {
		this.privilegeService = privilegeService;
	}

	public PrivilegeService getPrivilegeService() {
		return privilegeService;
	}
}
