package com.dhc.organization.position.action;

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
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.exception.ServiceException;
import com.dhc.base.web.struts.SessionCheckBaseDispatchAction;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.organization.position.domain.WF_ORG_STATION;
import com.dhc.organization.position.service.StationService;
import com.dhc.organization.user.domain.WF_ORG_USER;

/**
 * brief description
 * <p>
 * Date : 2010/05/06
 * </p>
 * <p>
 * Module : 岗位管理
 * </p>
 * <p>
 * Description: 岗位管理Action类
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
public class StationAction extends SessionCheckBaseDispatchAction {
	/**
	 * 岗位业务服务对象
	 */
	private StationService stationService;

	/**
	 * 构造函数
	 */
	public StationAction() {

	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 获取组织单元下面的职位
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
	public ActionForward getStationInUnit(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "unitId")) {
			return mapping.findForward("unpermitted-character");
		}

		String unitId = request.getParameter("unitId");
		unitId = unitId.substring(0, unitId.lastIndexOf("@"));
		stationService = (StationService) getBaseService().getServiceFacade("TP_StationService");
		try {
			List list = stationService.getPositionInUnit(unitId);
			String strStaXml = null;
			if (list.size() != 0) {
				strStaXml = this.parseStation2XMLString(list);
				response.setContentType("text/xml");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write(strStaXml);
			} else {
				response.setContentType("text/xml");
				response.setCharacterEncoding("UTF-8");
				response.getWriter().write("");
			}

		}
		// catch (ServiceException e1) {
		// e1.printStackTrace();
		// }
		catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 把岗位列表中的数据转换成为xml字符串用于前台显示岗位树
	 * </p>
	 * <p>
	 * 备注: 详见顺序图
	 * </p>
	 * 
	 * @param org_station
	 *            - 组织机构树
	 * @return 岗位树xml字符串
	 * @throws Exception
	 */
	private String parseStation2XMLString(List org_station) {
		// Document document = DocumentHelper.createDocument();
		// Element itemsElement = document.addElement("tree");
		// itemsElement.addAttribute("id", "0");
		// String StrStaXML = "";
		// for(int i=0;i<org_station.size();i++){
		// Element itemElement = itemsElement.addElement("item");
		// WF_ORG_STATION staVO = (WF_ORG_STATION)org_station.get(i);
		// itemElement.addAttribute("text",staVO.getStationName());
		// itemElement.addAttribute("id",staVO.getStationId());
		// StrStaXML = document.asXML();
		// }
		// return StrStaXML;

		// 用于存所有的根组织
		List rootStaList = new ArrayList();
		// 用于存所有的子组织
		List subStaList = new ArrayList();
		// 用于存组织树的xml内容
		String StrOrgXML = "";
		// 把根组织和子组织分开
		for (int i = 0; i < org_station.size(); i++) {
			WF_ORG_STATION staVO = (WF_ORG_STATION) org_station.get(i);
			if (staVO.getParentStationId() == null)
				rootStaList.add(staVO);
			else
				subStaList.add(staVO);
		}
		// 循环每一个根组织，把它的子组织灌满
		try {
			Document document = DocumentHelper.createDocument();
			Element itemsElement = document.addElement("tree");
			itemsElement.addAttribute("id", "0");
			for (int j = 0; j < rootStaList.size(); j++) {
				WF_ORG_STATION staVO = (WF_ORG_STATION) rootStaList.get(j);
				Element pageElement = itemsElement.addElement("item");
				pageElement.addAttribute("text", staVO.getStationName());
				pageElement.addAttribute("id", staVO.getStationId());
				// pageElement.addAttribute("open", "1");
				pageElement.addAttribute("im0", "WF_ORG_STATION.gif");
				pageElement.addAttribute("im1", "WF_ORG_STATION.gif");
				pageElement.addAttribute("im2", "WF_ORG_STATION.gif");
				// pageElement.addAttribute("call", "1");
				// pageElement.addAttribute("select", "1");
				String StrunitId = (String) staVO.getStationId();
				StalistToXML(subStaList, StrunitId, pageElement);
				StrOrgXML = document.asXML();
			}
		} catch (Exception ex) {
			StrOrgXML = "0";
		}
		// System.out.println(StrOrgXML);
		return StrOrgXML;
	}

	/*
	 * 根据传入的parentid，找它下面的所有子结点 递推，一直找下去，直到子结点不再有子结点，方法开始递归
	 * 
	 * @param staList - 完整的“子结点列表”
	 * 
	 * @param unitId - 父结点id
	 * 
	 * @param itemsElements - 父结点element对象
	 */
	private void StalistToXML(List orgList, String unitId, Element itemsElements) throws Exception {
		try {
			for (int i = 0; i < orgList.size(); i++) {
				WF_ORG_STATION staVO = (WF_ORG_STATION) orgList.get(i);
				if (staVO.getParentStationId().equals(unitId)) {
					Element pageElement = itemsElements.addElement("item");
					pageElement.addAttribute("text", staVO.getStationName());
					pageElement.addAttribute("id", staVO.getStationId());
					pageElement.addAttribute("im0", "WF_ORG_STATION.gif");
					pageElement.addAttribute("im1", "WF_ORG_STATION.gif");
					pageElement.addAttribute("im2", "WF_ORG_STATION.gif");
					String StrunitId = (String) staVO.getStationId();
					StalistToXML(orgList, StrunitId, pageElement);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * 方法简要描述信息.
	 * <p>
	 * 描述: 保存岗位（新建保存、修改保存）。根据saveType来确定是新建保存还是修改保存
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
	public ActionForward saveStation(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request,
				"staName,staDes,staNum,staUser," + "itemId,stationId,parStaId,itemId")) {
			return mapping.findForward("unpermitted-character");
		}

		JSONObject jsonObject = new JSONObject();
		PrintWriter writer = null;

		String saveType = request.getParameter("flag");
		String stationName = request.getParameter("staName").toString();
		String stationDescription = request.getParameter("staDes").toString();
		String userNumbers = request.getParameter("staNum").toString();
		String stationUser = request.getParameter("staUser").toString();
		String unitId = request.getParameter("itemId").toString();
		String stationId = request.getParameter("stationId").toString();
		String parentStationId = request.getParameter("parStaId").toString();
		unitId = unitId.substring(0, unitId.lastIndexOf("@"));
		WF_ORG_STATION staVO = new WF_ORG_STATION();

		staVO.setStationName(stationName);
		staVO.setStationDescription(stationDescription);
		staVO.setUnitId(unitId);
		staVO.setParentStationId(parentStationId.equals("") ? null : parentStationId);
		staVO.setUserNumbers(userNumbers == null ? -1L : Long.parseLong(userNumbers));
		if (saveType.equals("0")) {
			stationId = java.util.UUID.randomUUID().toString().replaceAll("-", "");
			staVO.setStationId(stationId);
		} else if (saveType.equals("1")) {
			staVO.setStationId(stationId);
		}
		if (!stationUser.equals("")) {
			staVO.setStationUser(Arrays.asList(stationUser.split(",")));
		} else {
			staVO.setStationUser(null);
		}

		stationService = (StationService) getBaseService().getServiceFacade("TP_StationService");
		try {
			response.setContentType("text/json");
			response.setCharacterEncoding("UTF-8");
			writer = response.getWriter();

			stationService.saveStation(staVO, saveType);
			unitId = request.getParameter("itemId").toString();
			staVO.setUnitId(unitId); // 将页面原始数据取出，替换截串后的数据，再返回给页面
			String staDetail = JSONObject.fromObject(staVO).toString();
			jsonObject.put("staDetail", staDetail);

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
	 * 描述: 获取给定岗位的明细信息
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
	public ActionForward getStationDetail(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "staId")) {
			return mapping.findForward("unpermitted-character");
		}

		JSONObject jsonObject = new JSONObject();
		PrintWriter writer = null;
		stationService = (StationService) getBaseService().getServiceFacade("TP_StationService");
		String stationID = request.getParameter("staId").toString();
		try {
			writer = response.getWriter();
			List staDetail = stationService.getStationDetail(stationID);
			String userNameStr = "";
			String userIdStr = "";
			WF_ORG_STATION station = (WF_ORG_STATION) staDetail.get(0);
			List stationList = station.getStationUser();
			if (stationList != null && stationList.size() > 0) {
				for (int i = 0; i < stationList.size(); i++) {
					WF_ORG_USER user = (WF_ORG_USER) stationList.get(i);
					userNameStr += user.getUserFullname();
					userIdStr += user.getUserId();
					if (i < stationList.size() - 1) {
						userNameStr += ",";
						userIdStr += ",";
					}
				}
			}
			station.setStationUsers(userNameStr);
			station.setUserId(userIdStr);
			String staDetail2 = JSONObject.fromObject(station).toString();
			jsonObject.put("staDetail", staDetail2);
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
	 * 描述: 删除岗位
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
	public ActionForward deleteStation(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		if (SecurityUtil.existUnavailableChar(request, "staId")) {
			return mapping.findForward("unpermitted-character");
		}

		JSONObject jsonObject = new JSONObject();
		PrintWriter writer = null;
		stationService = (StationService) getBaseService().getServiceFacade("TP_StationService");
		String stationId = request.getParameter("staId").toString();
		WF_ORG_STATION stationVO = new WF_ORG_STATION();
		stationVO.setStationId(stationId);
		try {
			writer = response.getWriter();
			stationService.deleteStation(stationVO);
			String staDetail = JSONObject.fromObject(stationVO).toString();
			jsonObject.put("staDetail", staDetail);
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
}
