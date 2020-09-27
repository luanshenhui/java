package com.dhc.authorization.delegate.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
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

import com.dhc.authorization.delegate.domain.WF_ORG_DELEGATE;
import com.dhc.authorization.delegate.domain.WF_ORG_DELEITEM;
import com.dhc.authorization.delegate.service.DelegateService;
import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.web.struts.SessionCheckBaseDispatchAction;
import com.dhc.organization.config.OrgI18nConsts;

/**
 * brief description
 * <p>
 * Date : 2010/07/09
 * </p>
 * <p>
 * Module : 权限委托管理
 * </p>
 * <p>
 * Description: 权限委托管理Action类
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
public class DelegateAction extends SessionCheckBaseDispatchAction {
	/**
	 * 权限委托业务服务对象
	 */
	private DelegateService delegateService;
	/**
	 * 默认每页行数
	 */
	protected static int DEFAULT_PAGE_SIZE = 10;

	/**
	 * 构造函数
	 */
	public DelegateAction() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 根据查询条件获取权限委托
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
	public ActionForward getDelegate(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		// 跳转方向
		String strForward = request.getParameter("forward");
		strForward = (strForward == null || strForward.equals("")) ? "listPage" : strForward;
		if (SecurityUtil.existUnavailableChar(request, "delegateName,delegateUser,trustorUser")) {
			request.setAttribute("delegateList", new ArrayList());
			return mapping.findForward(strForward);
		}

		String delegateName = request.getParameter("delegateName");
		String delegateUser = request.getParameter("delegateUser");
		String trustorUser = request.getParameter("trustorUser");

		WF_ORG_DELEGATE delegateVO = new WF_ORG_DELEGATE();
		if (delegateName == null || delegateName.equals("")) {
			delegateVO.setDeleName(null);
		} else {
			delegateVO.setDeleName(delegateName);
		}
		if (delegateUser == null || delegateUser.equals("")) {
			delegateVO.setUserId(null);
		} else {
			delegateVO.setUserId(delegateUser);
		}
		if (trustorUser == null || trustorUser.equals("")) {
			delegateVO.setTrustorId(null);
		} else {
			delegateVO.setTrustorId(trustorUser);
		}
		SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
		delegateVO.setCurrentUserId(securityUser.getUserBean().getId());

		try {
			if (delegateService == null)
				delegateService = (DelegateService) getBaseService().getServiceFacade("TP_DelegateService");
			// 这里应该取count
			int totalRows = delegateService.getDelegateCount(delegateVO);
			Limit limit = RequestUtil.getLimit(request, totalRows, DEFAULT_PAGE_SIZE);
			int offset = 0;
			int[] rowStartEnd = new int[] { limit.getRowStart() + offset, limit.getRowEnd() + offset };
			delegateVO.setStartRow(rowStartEnd[0]);
			delegateVO.setEndRow(rowStartEnd[1]);
			// 这里newList 应该根据start end 来重新取一下
			List newList = delegateService.getDelegateByCondition(delegateVO);
			// RequestUtil.initLimit(request,
			// returnRoleList.size(),DEFAULT_PAGE_SIZE);
			request.setAttribute("delegateList", newList);
		} catch (Exception e) {
			request.setAttribute("errorMessage", OrgI18nConsts.EXCEPTION_UNKNOWN);
			e.printStackTrace();
		}

		return mapping.findForward(strForward);
	}

	public ActionForward checkDelegate(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "deleId,delegateUserId,trustorId")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();

		WF_ORG_DELEGATE delegateVO = new WF_ORG_DELEGATE();
		String deleId = request.getParameter("deleId");
		delegateVO.setDeleId(deleId == null || deleId.equals("") ? null : deleId);
		delegateVO.setUserId(request.getParameter("delegateUserId"));
		delegateVO.setTrustorId(request.getParameter("trustorId"));
		delegateVO.setCurrentUserId(delegateVO.getUserId());
		if (delegateService == null)
			delegateService = (DelegateService) getBaseService().getServiceFacade("TP_DelegateService");
		try {
			writer = response.getWriter();
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			int rowCount = delegateService.getDelegateCount(delegateVO);
			Map map = new HashMap();
			map.put("number", rowCount);
			String num = JSONObject.fromObject(map).toString();
			jsonObject.put("num", num);
			// response.getWriter().write(rowCount);
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
	 * 描述: 保存权限委托（新建保存、修改保存）。根据saveType来确定是新建保存还是修改保存
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
	public ActionForward saveDelegate(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request,
				"opFlag,delegateId,delegateName," + "delegateUserId,trustorId,allPrivil,description,roleValueStr,"
						+ "roleIdStr,staValueStr,staIdStr,unitValueStr,unitIdStr")) {
			return mapping.findForward("unpermitted-character");
		}

		PrintWriter writer = null;
		JSONObject jsonObject = new JSONObject();
		String saveType = request.getParameter("opFlag");

		WF_ORG_DELEGATE delegateVO = new WF_ORG_DELEGATE();
		if (saveType == null || saveType.equals("0"))
			delegateVO.setDeleId(java.util.UUID.randomUUID().toString().replaceAll("-", ""));
		else
			delegateVO.setDeleId(request.getParameter("delegateId"));
		delegateVO.setDeleName(request.getParameter("delegateName"));
		delegateVO.setUserId(request.getParameter("delegateUserId"));
		delegateVO.setTrustorId(request.getParameter("trustorId"));
		String timeBeginStr = request.getParameter("timeStart");
		if (timeBeginStr != null)
			timeBeginStr = timeBeginStr.equals("") ? null : timeBeginStr;
		String timeEndStr = request.getParameter("timeEnd");
		if (timeEndStr != null)
			timeEndStr = timeEndStr.equals("") ? null : timeEndStr;
		delegateVO.setDeleTimeBegin(timeBeginStr);
		delegateVO.setDeleTimeEnd(timeEndStr);

		String allPrivil = request.getParameter("allPrivil").toString();
		delegateVO.setDeleAllPrivil(allPrivil);
		delegateVO.setDeleDescription(request.getParameter("description"));

		if (allPrivil.equals("0")) {
			String roleValueStr = request.getParameter("roleValueStr");
			String roleIdStr = request.getParameter("roleIdStr");
			if (!roleIdStr.equals("")) {
				List roleValueList = Arrays.asList(roleValueStr.split(","));
				List roleIdList = Arrays.asList(roleIdStr.split(","));
				for (int i = 0; i < roleValueList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = new WF_ORG_DELEITEM();
					deleitemVO.setDeleId(delegateVO.getDeleId());
					deleitemVO.setDiPrivType("ROLE");
					deleitemVO.setDiPrivId(roleIdList.get(i).toString());
					deleitemVO.setDiPrivName(roleValueList.get(i).toString());
					if (delegateVO.getRoleItemList() == null)
						delegateVO.setRoleItemList(new ArrayList());
					delegateVO.getRoleItemList().add(deleitemVO);
				}
			}

			String staValueStr = request.getParameter("staValueStr");
			String staIdStr = request.getParameter("staIdStr");
			if (!staIdStr.equals("")) {
				// 岗位
				List staValueList = Arrays.asList(staValueStr.split(","));
				List staIdList = Arrays.asList(staIdStr.split(","));
				for (int i = 0; i < staValueList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = new WF_ORG_DELEITEM();
					deleitemVO.setDeleId(delegateVO.getDeleId());
					deleitemVO.setDiPrivType("STATION");
					deleitemVO.setDiPrivId(staIdList.get(i).toString());
					deleitemVO.setDiPrivName(staValueList.get(i).toString());
					if (delegateVO.getStationItemList() == null)
						delegateVO.setStationItemList(new ArrayList());
					delegateVO.getUnitItemList().add(deleitemVO);
				}
			}

			String unitValueStr = request.getParameter("unitValueStr");
			String unitIdStr = request.getParameter("unitIdStr");
			if (!unitIdStr.equals("")) {
				List unitValueList = Arrays.asList(unitValueStr.split(","));
				List unitIdList = Arrays.asList(unitIdStr.split(","));
				// 组织
				for (int i = 0; i < unitValueList.size(); i++) {
					WF_ORG_DELEITEM deleitemVO = new WF_ORG_DELEITEM();
					deleitemVO.setDeleId(delegateVO.getDeleId());
					deleitemVO.setDiPrivType("ORG");
					deleitemVO.setDiPrivId(unitIdList.get(i).toString());
					deleitemVO.setDiPrivName(unitValueList.get(i).toString());
					if (delegateVO.getUnitItemList() == null)
						delegateVO.setUnitItemList(new ArrayList());
					delegateVO.getUnitItemList().add(deleitemVO);
				}
			}
		}

		if (delegateService == null)
			delegateService = (DelegateService) getBaseService().getServiceFacade("TP_DelegateService");
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			delegateService.saveDelegate(delegateVO, saveType);
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
	 * 描述: 删除权限委托
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
	public ActionForward deleteDelegate(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "deleIds")) {
			return mapping.findForward("unpermitted-character");
		}

		JSONObject returnJSON = new JSONObject();
		PrintWriter writer = null;
		try {
			String deleId = request.getParameter("deleIds");
			List delDeleIdList = Arrays.asList(deleId.split(","));
			delegateService.deleteDelegate(delDeleIdList);
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
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
	 * 描述: 获取权限委托明细
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
	public ActionForward getDelegateDetail(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "deleId")) {
			return mapping.findForward("unpermitted-character");
		}

		String delegateID = request.getParameter("deleId");
		PrintWriter writer = null;
		JSONObject returnJSON = new JSONObject();
		if (delegateService == null)
			delegateService = (DelegateService) getBaseService().getServiceFacade("TP_RoleService");
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();
			// WF_ORG_DELEGATE delegateVO = new WF_ORG_DELEGATE();
			// delegateVO.setDeleId(deleId);
			WF_ORG_DELEGATE deleDetail = delegateService.getDelegateDetail(delegateID);
			if (deleDetail == null) {
				returnJSON.put("errorMessage", OrgI18nConsts.DELEGATE_NOT_EXIST);
			} else {
				returnJSON.put("delegateDetail", JSONObject.fromObject(deleDetail).toString());
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
}
