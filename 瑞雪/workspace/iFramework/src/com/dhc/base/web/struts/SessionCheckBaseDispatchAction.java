package com.dhc.base.web.struts;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public abstract class SessionCheckBaseDispatchAction extends BaseDispatchAction {
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		if (session != null && session.getAttribute("SPRING_SECURITY_CONTEXT") == null) {
			if (request.getHeader("X-requested-with") != null
					&& request.getHeader("X-requested-with").equals("XMLHttpRequest")) {
				response.setHeader("sessionStatus", "invalid");
				response.setHeader("webapp", request.getContextPath());
				// 往前台打印超时内容信息
				PrintWriter writer = null;
				JSONObject returnJSON = new JSONObject();
				response.setContentType("text/json");
				response.setCharacterEncoding("UTF-8");
				writer = response.getWriter();
				returnJSON.put("errorMessage", "session timeout");
				writer.println(returnJSON.toString());
				writer.flush();
				writer.close();
				return null;
			} else {
				return mapping.findForward("session-invalidate");
			}

		} else {
			return super.execute(mapping, form, request, response);
		}
	}
}
