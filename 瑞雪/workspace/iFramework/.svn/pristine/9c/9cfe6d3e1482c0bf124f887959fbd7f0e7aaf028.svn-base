package com.dhc.base.menu.action;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.userdetails.UserDetails;

import com.dhc.authorization.resource.facade.ResourceBean;
import com.dhc.authorization.resource.facade.exception.PrivilegeFacadeException;
import com.dhc.base.common.JTConsts;
import com.dhc.base.log.FrameWorkLogger;
import com.dhc.base.menu.service.MenuTreeService;
import com.dhc.base.menu.vo.MenuTreeVO;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.web.struts.BaseDispatchAction;

public class MenuTreeAction extends BaseDispatchAction {

	private MenuTreeService menuTreeService;

	public ActionForward getMenuTree(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {

		String username = getUserName();
		String appName = (String) request.getSession().getServletContext().getAttribute("APP_NAME");
		menuTreeService = (MenuTreeService) getBaseService().getServiceFacade("menuTreeService");
		List favouriteList = null;
		List rbList = null;
		try {
			favouriteList = menuTreeService.getFavouriteMenuList(username);
			rbList = menuTreeService.getUserAvailableMenus(username, appName);
		} catch (PrivilegeFacadeException e) {
			e.printStackTrace();
		}

		try {
			String json = getMenuTreeJSON(favouriteList, rbList);
			if (json != null) {
				byte[] bs = json.getBytes("utf-8");
				response.setContentLength(bs.length);
				OutputStream os = response.getOutputStream();
				os.write(bs);
				os.flush();
				os.close();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			FrameWorkLogger.error("更新密码获取writer异常", e);
		}

		return null;
	}

	public ActionForward addFavMenu(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		String resultValue = "";
		PrintWriter writer = null;
		String username = getUserName();
		if (username != null && !username.equalsIgnoreCase("")) {
			String targetMenuId = (String) request.getParameter("targetMenuId");
			if (targetMenuId != null && !targetMenuId.equalsIgnoreCase("")) {
				String[] menuIdInfo = targetMenuId.split("@");
				MenuTreeVO vo = menuTreeService.getNewFavMenuInfo(menuIdInfo[0], username);
				if (vo == null) {
					resultValue = JTConsts.MESSAGE_FAVMENU_INVALID_PATH;
				} else {
					MenuTreeVO existVO = menuTreeService.getFavMenuInof(vo);

					if (existVO != null) {
						resultValue = JTConsts.MESSAGE_FAVMENU_PATH_EXIST;
					} else {
						try {
							menuTreeService.insertMenuTree(vo);
							resultValue = JTConsts.MESSAGE_FAVMENU_ADD_SUCCESS;
						} catch (Exception e) {
							FrameWorkLogger.error(JTConsts.MESSAGE_FAVMENU_ADD_FAILED, e);
							resultValue = JTConsts.MESSAGE_FAVMENU_ADD_FAILED;
						}
					}
				}
			} else {
				resultValue = JTConsts.MESSAGE_FAVMENU_ADD_FAILED_INDEX;
			}
		} else {
			resultValue = JTConsts.MESSAGE_FAVMENU_ADD_FAILED_ANONYMOUS;
		}

		try {
			writer = response.getWriter();
			writer.println(resultValue);
		} catch (IOException e) {
			FrameWorkLogger.error(JTConsts.MESSAGE_FAVMENU_ADD_FAILED, e);
		} finally {
			writer.flush();
			writer.close();
		}
		return null;
	}

	public ActionForward updateFavMenu(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) {
		String resultValue = "";
		PrintWriter writer = null;

		String username = getUserName();
		if (username != null && !username.equalsIgnoreCase("")) {
			String operateInfo = (String) request.getParameter("operateInfo");
			String[] menuInfo = operateInfo.split("~");
			if (menuInfo != null && menuInfo.length != 0) {
				List voList = new ArrayList();
				int length = menuInfo.length;
				MenuTreeVO tmpVo = null;
				for (int i = 0; i < length; i++) {
					tmpVo = new MenuTreeVO();
					if (menuInfo[i] != null && menuInfo[i].length() > 0) {
						String[] detail = menuInfo[i].split(":");
						tmpVo.setMenuCode(detail[0]);
						tmpVo.setMenuLocation("blank");
						tmpVo.setMenuName("blank");
						tmpVo.setFavouriteOrder(Integer.valueOf(detail[1]));
						tmpVo.setUserID(username);

						voList.add(tmpVo);
					}
				}
				try {
					menuTreeService.updateMenuTree(voList, username);
					resultValue = JTConsts.MESSAGE_FAVMENU_UPDATE_SUCCESS;
				} catch (Exception e) {
					FrameWorkLogger.error("更新我的收藏异常", e);
					resultValue = JTConsts.MESSAGE_FAVMENU_UPDATE_FAILED;
				}
			} else {
				resultValue = JTConsts.MESSAGE_FAVMENU_UPDATE_FAILED;
			}
		} else {
			resultValue = JTConsts.MESSAGE_FAVMENU_UPDATE_FAILED;
		}

		try {
			writer = response.getWriter();
			writer.println(resultValue);
		} catch (IOException e) {
			FrameWorkLogger.error("更新我的收藏异常", e);
		} finally {
			writer.flush();
			writer.close();
		}
		return null;
	}

	private String getMenuTreeJSON(List favouriteMenuList, List rbList) {
		JSONArray baseArray = new JSONArray();
		Object obj = (Object) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		if (obj instanceof SecurityUser) {

			try {
				convertFavMenu2JSON(baseArray, favouriteMenuList);
				convertHeadPage2JSON(baseArray, rbList);
				convertVO2JSON(baseArray, rbList, null);
				return baseArray.toString();
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return null;

	}

	private void convertFavMenu2JSON(JSONArray baseArray, List favouriteMenuList) {
		boolean hasFavMenu = false;
		if (favouriteMenuList != null) {
			hasFavMenu = true;
		}
		JSONObject favouriteMenuRootObj = new JSONObject();
		favouriteMenuRootObj.put("id", "favMenu");
		favouriteMenuRootObj.put("text", JTConsts.LABEL_FAVOURITE_MENU);
		favouriteMenuRootObj.put("value", "");
		favouriteMenuRootObj.put("hasChildren", hasFavMenu);

		if (hasFavMenu) {
			Iterator<MenuTreeVO> fmRootIdIt = favouriteMenuList.iterator();
			JSONArray subArray = new JSONArray();
			while (fmRootIdIt.hasNext()) {
				MenuTreeVO menuTreeVO = (MenuTreeVO) fmRootIdIt.next();

				JSONObject favouriteMenuObj = new JSONObject();
				favouriteMenuObj.put("id", menuTreeVO.getMenuCode());
				favouriteMenuObj.put("text", menuTreeVO.getMenuName());
				favouriteMenuObj.put("value", menuTreeVO.getMenuLocation());
				favouriteMenuObj.put("hasChildren", false);
				favouriteMenuObj.put("ChildNodes", null);
				favouriteMenuObj.put("complete", false);

				subArray.add(favouriteMenuObj);
			}
			favouriteMenuRootObj.put("ChildNodes", subArray);
			favouriteMenuRootObj.put("complete", true);
		} else {
			favouriteMenuRootObj.put("ChildNodes", null);
			favouriteMenuRootObj.put("complete", false);
		}
		baseArray.add(favouriteMenuRootObj);
	}

	private void convertHeadPage2JSON(JSONArray baseArray, List rbList) {

		String fullName = null;

		try {
			Object obj = (Object) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			if (obj instanceof SecurityUser) {
				fullName = ((SecurityUser) obj).getUserBean().getFullName();
			} else if (obj == null) {
				fullName = null;
			} else if (obj instanceof UserDetails) {
				fullName = null;// ((UserDetails) obj).getUsername();
			}
		} catch (Exception e) {
			FrameWorkLogger.error("获取user信息失败", e);
			fullName = null;
		}

		Iterator<ResourceBean> firstRootIdIt = rbList.iterator();
		boolean existHeadPage = false;
		if (fullName != null) {
			while (firstRootIdIt.hasNext()) {
				ResourceBean rootRb = (ResourceBean) firstRootIdIt.next();

				if ("1@MENU".equalsIgnoreCase(rootRb.getResourceID())) {
					JSONObject baseObject = new JSONObject();
					baseObject.put("id", rootRb.getResourceID());
					baseObject.put("text", rootRb.getResourceName());
					baseObject.put("value", rootRb.getResourceLocation());
					baseObject.put("welcomeName", fullName);
					baseObject.put("hasChildren", false);
					baseObject.put("ChildNodes", null);
					baseObject.put("complete", false);

					firstRootIdIt.remove();

					baseArray.add(baseObject);
					existHeadPage = true;
					break;
				}
			}

			if (!existHeadPage) {
				JSONObject baseObject = new JSONObject();
				baseObject.put("id", "headPage");
				baseObject.put("text", JTConsts.LABEL_HEAD_PAGE);
				baseObject.put("value", "#");
				baseObject.put("welcomeName", fullName);
				baseObject.put("hasChildren", false);
				baseObject.put("ChildNodes", null);
				baseObject.put("complete", false);

				baseArray.add(baseObject);
			}
		}
	}

	private JSONArray convertVO2JSON(JSONArray baseArray, List rbList, String rootId) {

		Iterator rbIt = rbList.iterator();
		List rootRbList = new ArrayList();

		while (rbIt.hasNext()) {
			ResourceBean tmprb = (ResourceBean) rbIt.next();
			String parentId = tmprb.getParentResourceID();

			if (((rootId == null || rootId.equalsIgnoreCase("")) && (parentId == null || parentId.equalsIgnoreCase(""))
					|| parentId.equalsIgnoreCase("RootMenu@MENU"))
					|| (parentId != null && parentId.equalsIgnoreCase(rootId))) {
				rootRbList.add(tmprb);

				rbIt.remove();
			}
		}

		Iterator rootRbIt = rootRbList.iterator();

		while (rootRbIt.hasNext()) {
			ResourceBean rootRb = (ResourceBean) rootRbIt.next();
			String theRootId = rootRb.getResourceID();

			JSONObject baseObject = new JSONObject();
			baseObject.put("id", rootRb.getResourceID());
			baseObject.put("text", rootRb.getResourceName());
			baseObject.put("value", rootRb.getResourceLocation());

			boolean hasChild = false;

			Iterator leftRbIt = rbList.iterator();

			while (leftRbIt.hasNext()) {
				ResourceBean tmprb = (ResourceBean) leftRbIt.next();
				String parentId = tmprb.getParentResourceID();

				if (theRootId.equalsIgnoreCase(parentId)) {
					hasChild = true;
				}
			}

			if (hasChild) {
				baseObject.put("hasChildren", true);
				baseObject.put("ChildNodes", convertVO2JSON(new JSONArray(), rbList, theRootId));
				baseObject.put("complete", true);
			} else {
				baseObject.put("hasChildren", false);
				baseObject.put("ChildNodes", null);
				baseObject.put("complete", false);
			}
			baseArray.add(baseObject);
		}
		return baseArray;
	}

	private String getUserName() {
		String username = "";
		try {
			Object obj = (Object) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
			if (obj instanceof UserDetails) {
				username = ((UserDetails) obj).getUsername();
			} else {
				username = obj.toString();
			}
		} catch (Exception e) {
			FrameWorkLogger.error("获取user信息失败", e);
			username = "";
		}

		return username;
	}

}
