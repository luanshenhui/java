package com.dhc.organization.user.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.ecside.table.limit.Limit;
import org.ecside.util.RequestUtil;

import sun.misc.BASE64Encoder;

import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.web.struts.SessionCheckBaseDispatchAction;
import com.dhc.organization.config.BizTypeDefine;
import com.dhc.organization.config.ElementDefine;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.organization.config.OrgnizationConfig;
import com.dhc.organization.position.domain.WF_ORG_STATION;
import com.dhc.organization.role.domain.WF_ORG_ROLE;
import com.dhc.organization.unit.domain.WF_ORG_UNIT;
import com.dhc.organization.user.domain.WF_ORG_USER;
import com.dhc.organization.user.service.UserService;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 人员管理
 * </p>
 * <p>
 * Description: 人员管理Action类
 * </p>
 * <p>
 * Remark :
 * </p>
 * 
 * @author 王潇艺
 * @version
 *          <p>
 *          ------------------------------------------------------------
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
public class UserAction extends SessionCheckBaseDispatchAction {
	/**
	 * 用户业务服务对象
	 */
	private UserService userService;
	protected static int DEFAULT_PAGE_SIZE = 10;

	/**
	 * 构造函数
	 */
	public UserAction() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取所有用户，用于用户选择表格
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
	public void getAllUsers(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据查询条件获取用户
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
	public ActionForward getUser(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		String forward = request.getParameter("forward");
		if (forward == null || forward == "")
			forward = "userDetail";
		if (SecurityUtil.existUnavailableChar(request,
				"itemId,sendflag,checkId,userAccount," + "userName,needUserRole,userType")) {
			request.setAttribute("userList", new ArrayList());
			return mapping.findForward(forward);
		}

		// 收集前台查询参数
		String unitID = request.getParameter("itemId");
		unitID = (unitID == null || unitID.equals("")) ? null : unitID; 
		String userAccount = request.getParameter("userAccount");
		userAccount = (userAccount == null || userAccount.equals("")) ? null : userAccount;
		String userName = request.getParameter("userName");
		userName = (userName == null || userName.equals("")) ? null : userName;
		boolean needUserRole = (request.getParameter("needUserRole") == null
				|| request.getParameter("needUserRole").equals("")) ? false : true;
		String userType = request.getParameter("userType");
		userType = (userType == null || userType.equals("")) ? null : userType;
		String lockFlag = request.getParameter("cmbLockFlag");
		lockFlag = (lockFlag == null || lockFlag.equals("")) ? null : (lockFlag.equalsIgnoreCase("true") ? "1" : "0");
		boolean needAllUser = false;
		String tempAllUser = request.getParameter("needAllUser");
		tempAllUser = (tempAllUser == null || tempAllUser.equals("")) ? "false" : tempAllUser;
		needAllUser = tempAllUser.equalsIgnoreCase("true") ? true : false;
		// 岗位里的用户id字符串(见StationDetail.js)
		String stationUserIDs = request.getParameter("stationUserIDs");
		stationUserIDs = (stationUserIDs == null || stationUserIDs.equals("")) ? "" : stationUserIDs;

		userService = (UserService) getBaseService().getServiceFacade("TP_UserService");

		List returnUserlist = null;
		try {
			SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
			String currentUserID = securityUser.getUserBean().getId();
			if (needAllUser)
				currentUserID = "adminUser";
			WF_ORG_ROLE adminRole = securityUser.getUserBean().getAdminRole();
			String adminRoleID = adminRole == null ? null : adminRole.getRoleId();
			int totalRows = userService.getUserCount(null, userAccount, userName, unitID, null, adminRoleID,
					currentUserID, lockFlag);
			Limit limit = RequestUtil.getLimit(request, totalRows, DEFAULT_PAGE_SIZE);
			int offset = 0;
			int[] rowStartEnd = new int[] { limit.getRowStart() + offset, limit.getRowEnd() + offset };
			WF_ORG_USER userVO = new WF_ORG_USER();
			userVO.setUnitID(unitID);
			userVO.setStartRow(rowStartEnd[0]);
			userVO.setEndRow(rowStartEnd[1]);
			userVO.setPageSize(limit.getCurrentRowsDisplayed());
			userVO.setUserAccount(userAccount);
			userVO.setUserFullname(userName);
			userVO.setUserType(userType);
			userVO.setAdminRoleID(adminRoleID);
			userVO.setCurrentLoginUserID(currentUserID);
			userVO.setUserAccountLocked(lockFlag);

			returnUserlist = userService.getUserByCondition(userVO, true, false, needUserRole, false);

			// 给所有user拼接用户的所有组织单元（因为基本都是分页的情况，所以不会有性能问题）
			for (int i = 0; i < returnUserlist.size(); i++) {
				WF_ORG_USER user = (WF_ORG_USER) returnUserlist.get(i);
				List unitList = user.getUserUnitList();
				String unitString = "";
				if (unitList != null && unitList.size() > 0) {
					for (int j = 0; j < unitList.size(); j++) {
						WF_ORG_UNIT unit = (WF_ORG_UNIT) unitList.get(j);
						unitString += unit.getUnitName();
						if (j < unitList.size() - 1)
							unitString += ",";
					}
				}
				user.setUserUnits(unitString);
			}

			// 给所有user拼接用户的所有角色
			for (int i = 0; i < returnUserlist.size(); i++) {
				WF_ORG_USER user = (WF_ORG_USER) returnUserlist.get(i);
				List roleList = user.getUserRoleList();
				String roleString = "";
				if (roleList != null && roleList.size() > 0) {
					for (int j = 0; j < roleList.size(); j++) {
						WF_ORG_ROLE role = (WF_ORG_ROLE) roleList.get(j);
						roleString += role.getRoleName();
						if (j < roleList.size() - 1)
							roleString += ",";
					}
				}
				user.setUserRoles(roleString);
			}
			request.setAttribute("userList", returnUserlist);
			request.setAttribute("stationUserIDs", stationUserIDs);
		} catch (ServiceException e) {
			request.setAttribute("errorMessage", e.getMessage());
		} catch (Exception e) {
			request.setAttribute("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		}
		return mapping.findForward(forward);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据userid获取用户列表，不分页
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
	public ActionForward getUsersInUserIds(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		if (SecurityUtil.existUnavailableChar(request, "userIds")) {
			return mapping.findForward("unpermitted-character");
		}
		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		String userIds = request.getParameter("userIds");
		userService = (UserService) getBaseService().getServiceFacade("TP_UserService");
		List returnUserlist = null;
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			WF_ORG_USER userVO = new WF_ORG_USER();
			// 将传入的userIds格式化成“'sdfdf','3333','4444'”
			String[] idArray = userIds.split(",");
			List<String> idList = Arrays.asList(idArray);

			userVO.setUserIds(idList);
			String userNames = "";
			if (idArray.length <= 0) {
				returnUserlist = null;
			} else {
				returnUserlist = userService.getUserByIDs(userVO);
				for (int j = 0; j < returnUserlist.size(); j++) {
					WF_ORG_USER user = (WF_ORG_USER) returnUserlist.get(j);
					userNames += user.getUserFullname();
					if (j < returnUserlist.size() - 1)
						userNames += ",";
				}
			}
			jsonObject.put("userNames", userNames);
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
	 * 描述: 保存用户（新建保存、修改保存）。根据saveType来确定是新建保存还是修改保存
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
	public ActionForward saveUser(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request,
				"opFlag,userId,userDesc," + "userPass,userName,userAccount,userUnits,termId")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		String saveType = request.getParameter("opFlag");

		// userVO赋值
		WF_ORG_USER userVO = new WF_ORG_USER();
		if (saveType == null || saveType.equals("0")) {
			userVO.setUserId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
			userVO.setUserAccountEnabled("1");
			userVO.setUserAccountLocked("0");
			userVO.setUserAccountCreated(new Date());
		} else {
			userVO.setUserId(request.getParameter("userId"));
		}

		userVO.setUserDescription(request.getParameter("userDesc"));
		String password = request.getParameter("userPass");
		if (password == null || password.equals("")) {
			password = null;
		}
		userVO.setUserPassword(password);// md5Encrypt(request.getParameter("userPass"),OrgnizationConfig.CRYPTOGRAM_ALGORITHM));
		userVO.setUserFullname(request.getParameter("userName"));
		userVO.setUserAccount(request.getParameter("userAccount"));

		String userUnits = request.getParameter("userUnits");
		// 处理用户的组织单元和岗位
		if (userUnits != null && !userUnits.equals("")) {
			List unitAndStationList = Arrays.asList(userUnits.split(","));
			List unitStringList = new ArrayList();
			List stationStringList = new ArrayList();
			if (unitAndStationList != null && unitAndStationList.size() > 0) {
				for (int i = 0; i < unitAndStationList.size(); i++) {
					String temp = (String) unitAndStationList.get(i);
					if (temp.indexOf("@") < 0)
						unitStringList.add(temp);
					else if (temp.indexOf("@UNIT") >= 0)
						unitStringList.add(temp.substring(0, temp.lastIndexOf("@UNIT")));
					else if (temp.indexOf("@STATION") >= 0)
						stationStringList.add(temp.substring(0, temp.lastIndexOf("@STATION")));
				}
				userVO.setUserUnitList(unitStringList);
				userVO.setUserStationList(stationStringList);
			}
		} else {
			userVO.setUserUnitList(null);
			userVO.setUserStationList(null);
		}
		// 处理用户的角色
		String userRoles = request.getParameter("userRoles");
		if (userRoles != null && !userRoles.equals("")) {
			userVO.setUserRoleList(Arrays.asList(userRoles.split(",")));
		} else {
			userVO.setUserRoleList(null);
		}

		String extInfo = request.getParameter("extInfo"); // 获取扩展信息
		Map map = new HashMap();
		String info[] = extInfo.split("&");
		for (int j = 0; j < info.length; j++) {
			int s = info[j].lastIndexOf("=");
			map.put(info[j].substring(0, s), info[j].substring(s + 1, info[j].length()));
		}

		BizTypeDefine bizTypeDefine = OrgnizationConfig.getBizTypeDefine("user");
		ArrayList list = bizTypeDefine.getElementList();
		Map finalElementMap = new HashMap();
		String idColumnName = "";
		for (int i = 0; i < list.size(); i++) {
			ElementDefine ed = (ElementDefine) list.get(i);
			Iterator mapIter = map.keySet().iterator();
			if (ed.getName().equalsIgnoreCase("id")) {
				idColumnName = ed.getColumn();
			}
			while (mapIter.hasNext()) {
				String extInfoName = mapIter.next().toString().trim();
				if (extInfoName.equals(ed.getName().trim())) {
					if (ed.getType().equalsIgnoreCase("DateField")) {
						String temp = map.get(extInfoName).toString();
						temp = temp.replaceAll("[+]", " ");
						// temp = temp.replaceAll("%3A", ":");
						finalElementMap.put(ed.getColumn(), temp);
					} else {
						finalElementMap.put(ed.getColumn(), map.get(extInfoName));
					}

				}
			}
		}
		userVO.setExtInfoMap(finalElementMap);// 扩展信息hashMap

		if (userService == null)
			userService = (UserService) getBaseService().getServiceFacade("TP_UserService");

		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			userService.saveUser(userVO, saveType, bizTypeDefine.getTable(), idColumnName);
			String userDetail = JSONObject.fromObject(userVO).toString();
			jsonObject.put("userDetail", userDetail);
		} catch (ServiceException e) {
			if (e.getMessage().lastIndexOf("数据库操作异常") >= 0)
				jsonObject.put("errorMessage", OrgI18nConsts.ACCOUNT_EXIST);
			else
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
	 * 描述: 把输入的字符串进行md5加密
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param strPassword
	 *            - 未加密的密码
	 * @param strALGORITHM
	 *            - 加密算法
	 * @return 使用md5加密后的密码
	 * @throws Exception
	 */
	private String md5Encrypt(String strPassword, String strALGORITHM) {
		MessageDigest messagedigest = null;
		try {
			messagedigest = MessageDigest.getInstance(strALGORITHM);
		} catch (NoSuchAlgorithmException nosuchalgorithmexception) {
			nosuchalgorithmexception.printStackTrace();
		}
		messagedigest.reset();
		byte abyte0[] = strPassword.getBytes();
		byte abyte1[] = messagedigest.digest(abyte0);
		BASE64Encoder base64encoder = new BASE64Encoder();
		return base64encoder.encode(abyte1);
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 删除用户，如果角色已经被使用，则该组织单元不能被删除
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
	public ActionForward deleteUser(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		if (SecurityUtil.existUnavailableChar(request, "userIds")) {
			return mapping.findForward("unpermitted-character");
		}

		String userID = request.getParameter("userIds");
		PrintWriter writer = null;
		// 扩展表的表名
		String extTableName = "";
		// 扩展表的主键字段名
		String idColumnName = "";
		JSONObject returnJSON = new JSONObject();
		if (userService == null)
			userService = (UserService) getBaseService().getServiceFacade("TP_UserService");
		try {
			BizTypeDefine bizTypeDefine = OrgnizationConfig.getBizTypeDefine("user");
			extTableName = bizTypeDefine.getTable();
			if (bizTypeDefine.getElementList() != null || bizTypeDefine.getElementList().size() > 0) {
				for (int j = 0; j < bizTypeDefine.getElementList().size(); j++) {
					ElementDefine ed = (ElementDefine) bizTypeDefine.getElementList().get(j);
					if (ed.getName().equalsIgnoreCase("id")) {
						idColumnName = ed.getColumn();
						break;
					}
				}
			}

			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			List delUserIdList = Arrays.asList(userID.split(","));
			userService.deleteUser(delUserIdList, extTableName, idColumnName);
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
	 * 描述: 锁定用户
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
	public ActionForward lockUser(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		if (SecurityUtil.existUnavailableChar(request, "userId,isLocked")) {
			return mapping.findForward("unpermitted-character");
		}
		String userID = request.getParameter("userId");
		String isLocked = request.getParameter("isLocked");
		PrintWriter writer = null;
		JSONObject returnJSON = new JSONObject();
		if (userService == null)
			userService = (UserService) getBaseService().getServiceFacade("TP_UserService");
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			userService.lockUser(userID, isLocked);
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
	 * 描述: 获取用户明细
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
	public ActionForward getUserDetail(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "userID")) {
			return mapping.findForward("unpermitted-character");
		}

		String userID = request.getParameter("userID");
		PrintWriter writer = null;
		JSONObject returnJSON = new JSONObject();
		if (userService == null)
			userService = (UserService) getBaseService().getServiceFacade("TP_UserService");
		try {
			String userAdminRoleID = "";
			String userAdminRoleName = "";
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			WF_ORG_USER userDetail = userService.getUserDetail(userID);
			if (userDetail == null) {
				returnJSON.put("errorMessage", OrgI18nConsts.USER_NOT_EXIST);
			} else {
				// 拼出人员角色~~~~~~~~~~~~~~~~~~
				String userRolesKEY = "";
				String userRolesVALUE = "";
				if (userDetail.getRoleList() != null && userDetail.getRoleList().size() > 0) {
					// 从角色列表中取出业务角色
					List bizRoleList = new ArrayList();
					for (int i = 0; i < userDetail.getRoleList().size(); i++) {
						WF_ORG_ROLE roleVO = (WF_ORG_ROLE) userDetail.getRoleList().get(i);
						if (roleVO.getIsAdminrole().equals("否")) {
							bizRoleList.add(roleVO);
						} else {
							userAdminRoleID = roleVO.getRoleId();
							userAdminRoleName = roleVO.getRoleName();
						}
					}
					for (int i = 0; i < bizRoleList.size(); i++) {
						WF_ORG_ROLE roleVO = (WF_ORG_ROLE) bizRoleList.get(i);
						userRolesKEY += roleVO.getRoleId();
						userRolesVALUE += roleVO.getRoleName();
						// 最后一个字符串后面就不要加“,”了
						if (i == bizRoleList.size() - 1)
							break;
						userRolesKEY += ",";
						userRolesVALUE += ",";
					}
				}
				returnJSON.put("userRolesKEY", userRolesKEY);
				returnJSON.put("userRolesVALUE", userRolesVALUE);
				returnJSON.put("userAdminRoleKEY", userAdminRoleID);
				returnJSON.put("userAdminRoleVALUE", userAdminRoleName);
				// 拼出用户所属的组织~~~~~~~~~~~~~~~~~~
				String userUnitsKEY = "";
				String userUnitsVALUE = "";
				if (userDetail.getUnitList() != null && userDetail.getUnitList().size() > 0) {
					for (int i = 0; i < userDetail.getUnitList().size(); i++) {
						WF_ORG_UNIT unitVO = (WF_ORG_UNIT) userDetail.getUnitList().get(i);
						userUnitsKEY += unitVO.getUnitId() + "@UNIT";
						userUnitsVALUE += unitVO.getUnitName();
						// 最后一个字符串后面就不要加“,”了
						if (i == userDetail.getUnitList().size() - 1)
							break;
						userUnitsKEY += ",";
						userUnitsVALUE += ",";
					}
				}
				// 拼出用户所属的岗位~~~~~~~~~~~~~~~~~~
				String userStationsKEY = "";
				String userStationsVALUE = "";
				if (userDetail.getStationList() != null && userDetail.getStationList().size() > 0) {
					for (int i = 0; i < userDetail.getStationList().size(); i++) {
						WF_ORG_STATION unitVO = (WF_ORG_STATION) userDetail.getStationList().get(i);
						userStationsKEY += unitVO.getStationId() + "@STATION";
						userStationsVALUE += unitVO.getStationName();
						// 最后一个字符串后面就不要加“,”了
						if (i == userDetail.getStationList().size() - 1)
							break;
						userStationsKEY += ",";
						userStationsVALUE += ",";
					}
				}
				if (!userStationsKEY.equals("")) {
					returnJSON.put("userUnitsKEY",
							userUnitsKEY.equals("") ? userStationsKEY : userUnitsKEY + "," + userStationsKEY);
					returnJSON.put("userUnitsVALUE",
							userUnitsVALUE.equals("") ? userStationsVALUE : userUnitsVALUE + "," + userStationsVALUE);
				} else {
					returnJSON.put("userUnitsKEY", userUnitsKEY);
					returnJSON.put("userUnitsVALUE", userUnitsVALUE);
				}

				userDetail.setUnitList(null);
				userDetail.setRoleList(null);
				returnJSON.put("userDetail", JSONObject.fromObject(userDetail).toString());

			}
			// 测试代码
			// BizTypeDefine bizTypeDefine =
			// OrgnizationConfig.getBizTypeDefine("user");
			// returnJSON.put("BizTypeDefine",
			// JSONObject.fromObject(bizTypeDefine));
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

	public ActionForward getExtendDetail(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		if (SecurityUtil.existUnavailableChar(request, "type")) {
			return mapping.findForward("unpermitted-character");
		}
		JSONObject jsonObject = new JSONObject();
		String type = request.getParameter("type").toString();
		if (type.equals("user")) {
			BizTypeDefine bizTypeDefine = OrgnizationConfig.getBizTypeDefine(type);
			jsonObject.put("BizTypeDefine", bizTypeDefine);
			try {
				response.getWriter().println(jsonObject.toString());
			} catch (IOException e) {
				jsonObject.put("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
				e.printStackTrace();
			}
		}
		return null;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public UserService getUserService() {
		return userService;
	}
}
