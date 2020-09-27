package com.dhc.base.web.struts;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.dhc.base.common.util.SecurityUtil;

/**
 * brief description
 * <p>
 * Date : 2010-11-23
 * </p>
 * <p>
 * Module : web安全控制
 * </p>
 * <p>
 * Description: 重写execute方法，检查发现request中有非法字符，跳转到错误页面
 * </p>
 * <p>
 * Remark :
 * </p>
 * <p>
 * --------------------------------------------------------------
 * </p>
 * <p>
 * 修改历史
 * </p>
 * <p>
 * 序号 日期 修改人 修改原因
 * </p>
 */
public abstract class SecurityBaseDispatchAction extends BaseDispatchAction {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		if (!SecurityUtil.httpRequestSecurityCheck(request)) {
			throw new com.dhc.base.exception.SecurityException("Unpermitted character or key word");
			// return mapping.findForward("unpermitted-character");
		} else {
			return super.execute(mapping, form, request, response);
		}

	}

}
