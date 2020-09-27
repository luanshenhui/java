package cn.rkylin.oms.system.privilege.controller;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.rkylin.core.controller.ApolloController;
import cn.rkylin.oms.system.privilege.service.IPrivilegeService;
import net.sf.json.JSONObject;
@Controller
@RequestMapping("/privilege")
public class PrivilegeController extends ApolloController{
	@Autowired
	private IPrivilegeService privilegeService;
	
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
	@ResponseBody
	@RequestMapping(value = "/getPageElementPrivilege", method = RequestMethod.POST)
	public void getPageElementPrivilege(HttpServletRequest request,
			HttpServletResponse response) {
//		if (SecurityUtil.existUnavailableChar(request, "type,id,menuID,isAdminRole")) {
//			return mapping.findForward("unpermitted-character");
//		}
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
		} catch (Exception e) {
			jsonObject.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} finally {
			writer.println(jsonObject.toString());
			writer.flush();
			writer.close();
		}
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
	@ResponseBody
	@RequestMapping(value = "/savePrivileges", method = RequestMethod.POST)
	public void savePrivileges(HttpServletRequest request,
			HttpServletResponse response) {
//		if (SecurityUtil.existUnavailableChar(request, "type,id,resIDs4Add,resIDs4Del," + "isAdminRole")) {
//			return mapping.findForward("unpermitted-character");
//		}

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
		try {
			writer = response.getWriter();
			privilegeService.savePrivileges(id, type, resIDs4Add, resIDs4Del, isAssignableSave);
		} catch (Exception e) {
			jsonObject.put("errorMessage", e.getMessage());
			e.printStackTrace();
		} finally {
			writer.println(jsonObject.toString());
			writer.flush();
			writer.close();
		}
	}
}
