package org.apache.jsp.view.authorization.menu;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.common.consts.CommonConsts;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;

public final class MenuMain_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(2);
    _jspx_dependants.add("/view/base/common/i18nConsts.jsp");
    _jspx_dependants.add("/WEB-INF/tld/struts-bean.tld");
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.release();
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			"/ErrorNormal.jsp", true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");

	boolean hasAdminRole = false;
	String language = CommonConsts.LANGUAGE;
	
	try {
		SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
		hasAdminRole = securityUser.getUserBean().hasAdminRole();
	} catch (Exception ex) {
		hasAdminRole = false;
	}
	if (!hasAdminRole)
		response.sendRedirect(webpath + "/accessDenied.jsp");

      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n");
      out.write("<title>");
      if (_jspx_meth_bean_005fmessage_005f0(_jspx_page_context))
        return;
      out.write("</title>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

//ä¼è¯è¶æ¶åè·³è½¬å°ç»å½é¡µé¢
SecurityUser securityUser = SecurityUserHoder.getCurrentUser();
if (securityUser.getUserBean() == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
}

      out.write("\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(request.getContextPath());
      out.write("/view/base/plugin/page.set.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar MESSAGE_BOX = \"");
      out.print(OrgI18nConsts.MESSAGE_BOX);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar CONFIRM_BOX = \"");
      out.print(OrgI18nConsts.CONFIRM_BOX);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar SAVE_OK = \"");
      out.print(OrgI18nConsts.SAVE_OK);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELETE_OK = \"");
      out.print(OrgI18nConsts.DELETE_OK);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar NET_FAILD = \"");
      out.print(OrgI18nConsts.NET_FAILD);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PROMPT_SAVE_BUTTON = \"");
      out.print(CommonConsts.BUTTON_SAVE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PROMPT_CLOSE_BUTTON = \"");
      out.print(CommonConsts.BUTTON_CLOSE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PROMPT_OK_BUTTON = \"");
      out.print(CommonConsts.BUTTON_OK);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PROMPT_RESET_BUTTON = \"");
      out.print(CommonConsts.BUTTON_RESET);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PROMPT_CANCEL_BUTTON = \"");
      out.print(CommonConsts.BUTTON_CANCEL);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PROMPT_CONFIRM_DELETE = \"");
      out.print(CommonConsts.PROMPT_CONFIRM_DELETE);
      out.write("\";\r\n");
      out.write("\t\r\n");
      out.write("\tvar ROLE_DETAIL = \"");
      out.print(OrgI18nConsts.ROLE_DETAIL);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar ROLE_ROLE_SELECT = \"");
      out.print(OrgI18nConsts.ROLE_ROLE_SELECT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar ROLE_BIZROLE_SELECT = \"");
      out.print(OrgI18nConsts.ROLE_BIZROLE_SELECT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar ROLE_ADMINROLE_SELECT = \"");
      out.print(OrgI18nConsts.ROLE_ADMINROLE_SELECT);
      out.write("\";\r\n");
      out.write("\t\r\n");
      out.write("\tvar SELECT_ROLE_TO_EDIT = \"");
      out.print(OrgI18nConsts.SELECT_ROLE_TO_EDIT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar ADMINROLE_CANT_DELETE = \"");
      out.print(OrgI18nConsts.ADMINROLE_CANT_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar SELECT_ROLE_TO_DELETE = \"");
      out.print(OrgI18nConsts.SELECT_ROLE_TO_DELETE);
      out.write("\";\r\n");
      out.write("\t\r\n");
      out.write("\tvar ROLENAME_PROMPT_INFO = \"");
      out.print(OrgI18nConsts.ROLENAME_PROMPT_INFO);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar ROLEDESC_PROMPT_INFO = \"");
      out.print(OrgI18nConsts.ROLEDESC_PROMPT_INFO);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MAXUSERS_PROMPT_INFO = \"");
      out.print(OrgI18nConsts.MAXUSERS_PROMPT_INFO);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MUST_BE_ADMIN_ROLE = \"");
      out.print(OrgI18nConsts.MUST_BE_ADMIN_ROLE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar ROLE_NAME_ALEADY_EXIST = \"");
      out.print(OrgI18nConsts.ROLE_NAME_ALEADY_EXIST);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_USER_SELECT = \"");
      out.print(OrgI18nConsts.STAT_USER_SELECT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_STAT_DETAIL = \"");
      out.print(OrgI18nConsts.STAT_STAT_DETAIL);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_STAT_MNGT = \"");
      out.print(OrgI18nConsts.STAT_STAT_MNGT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_FILL_STATNAME = \"");
      out.print(OrgI18nConsts.STAT_FILL_STATNAME);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_STAT_LONG = \"");
      out.print(OrgI18nConsts.STAT_STAT_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_STATDESC_LONG = \"");
      out.print(OrgI18nConsts.STAT_STATDESC_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_MAXUSERS_MANDATORY = \"");
      out.print(OrgI18nConsts.STAT_MAXUSERS_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_NUMBER_INVALID = \"");
      out.print(OrgI18nConsts.STAT_NUMBER_INVALID);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_UPDATE_OK = \"");
      out.print(OrgI18nConsts.STAT_UPDATE_OK);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_SELECT_ORG = \"");
      out.print(OrgI18nConsts.STAT_SELECT_ORG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_SELECT_STATION = \"");
      out.print(OrgI18nConsts.STAT_SELECT_STATION);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_DETAIL = \"");
      out.print(OrgI18nConsts.USER_DETAIL);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_ADJUST_PRIVILEGE = \"");
      out.print(OrgI18nConsts.USER_ADJUST_PRIVILEGE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_USERNAME_INVALID = \"");
      out.print(OrgI18nConsts.USER_USERNAME_INVALID);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_PASSWORD_INVALID = \"");
      out.print(OrgI18nConsts.USER_PASSWORD_INVALID);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_ACCOUNT_INVALID = \"");
      out.print(OrgI18nConsts.USER_ACCOUNT_INVALID);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_USERDESC_INVALID = \"");
      out.print(OrgI18nConsts.USER_USERDESC_INVALID);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_INPUT_LONG = \"");
      out.print(OrgI18nConsts.USER_INPUT_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_SELECT_USER_FIRST = \"");
      out.print(OrgI18nConsts.USER_SELECT_USER_FIRST);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_SELECT_USER_TO_EDIT = \"");
      out.print(OrgI18nConsts.USER_SELECT_USER_TO_EDIT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_ADMIN_USER_CANT_DELETE = \"");
      out.print(OrgI18nConsts.USER_ADMIN_USER_CANT_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_CHOOSE_USER_TO_DELETE = \"");
      out.print(OrgI18nConsts.USER_CHOOSE_USER_TO_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_CONFIRM_USER_DELETE = \"");
      out.print(OrgI18nConsts.USER_CONFIRM_USER_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_LOCK_USER = \"");
      out.print(OrgI18nConsts.USER_LOCK_USER);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_UNLOCK_USER = \"");
      out.print(OrgI18nConsts.USER_UNLOCK_USER);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_CONFIRM_UNLOCK_USER = \"");
      out.print(OrgI18nConsts.USER_CONFIRM_UNLOCK_USER);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_CONFIRM_LOCK_USER = \"");
      out.print(OrgI18nConsts.USER_CONFIRM_LOCK_USER);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar USER_SUCCESS = \"");
      out.print(OrgI18nConsts.USER_SUCCESS);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_MENU_UNDER_MENU = \"");
      out.print(OrgI18nConsts.MENU_MENU_UNDER_MENU);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ALLOW_ADD_MENU = \"");
      out.print(OrgI18nConsts.MENU_ALLOW_ADD_MENU);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ELEMENT_MUST_UNDER_PAGE = \"");
      out.print(OrgI18nConsts.MENU_ELEMENT_MUST_UNDER_PAGE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_PAGE_MUST_UNDER_MENU = \"");
      out.print(OrgI18nConsts.MENU_PAGE_MUST_UNDER_MENU);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_CURRENT_NODE_CANT_DELETE = \"");
      out.print(OrgI18nConsts.MENU_CURRENT_NODE_CANT_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_SELECT_NODE_TO_DELETE = \"");
      out.print(OrgI18nConsts.MENU_SELECT_NODE_TO_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_HAVE_SUB_NODES_CANT_DELETE = \"");
      out.print(OrgI18nConsts.MENU_HAVE_SUB_NODES_CANT_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_PLEASE_SELECT_NODE = \"");
      out.print(OrgI18nConsts.MENU_PLEASE_SELECT_NODE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_NAME_MANDATORY = \"");
      out.print(OrgI18nConsts.MENU_NAME_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_NAME_LONG = \"");
      out.print(OrgI18nConsts.MENU_NAME_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_IMG_LONG = \"");
      out.print(OrgI18nConsts.MENU_IMG_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_URL_LONG = \"");
      out.print(OrgI18nConsts.MENU_URL_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_LOCATION_MANDATORY = \"");
      out.print(OrgI18nConsts.MENU_LOCATION_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_LOCATION_LONG = \"");
      out.print(OrgI18nConsts.MENU_LOCATION_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_PLEASE_SELECT_ELEMENT = \"");
      out.print(OrgI18nConsts.MENU_PLEASE_SELECT_ELEMENT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ELEMENT_ID_MANDATORY = \"");
      out.print(OrgI18nConsts.MENU_ELEMENT_ID_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ELEMENT_ID_LONG = \"");
      out.print(OrgI18nConsts.MENU_ELEMENT_ID_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ELEMENT_NAME_MANDATORY = \"");
      out.print(OrgI18nConsts.MENU_ELEMENT_NAME_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ELEMENT_NAME_LONG = \"");
      out.print(OrgI18nConsts.MENU_ELEMENT_NAME_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_DESC_LONG = \"");
      out.print(OrgI18nConsts.MENU_DESC_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_PAGE_ID_MANDATORY = \"");
      out.print(OrgI18nConsts.MENU_PAGE_ID_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_PAGE_ID_LONG = \"");
      out.print(OrgI18nConsts.MENU_PAGE_ID_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_ONE_NODE_CANT_MOVE = \"");
      out.print(OrgI18nConsts.MENU_ONE_NODE_CANT_MOVE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_FIRST_NODE_CANT_MOVEUP = \"");
      out.print(OrgI18nConsts.MENU_FIRST_NODE_CANT_MOVEUP);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar MENU_LAST_NODE_CANT_MOVEDOWN = \"");
      out.print(OrgI18nConsts.MENU_LAST_NODE_CANT_MOVEDOWN);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar BG_PLZ_SELECT_ROLE_OR_STAT = \"");
      out.print(OrgI18nConsts.BG_PLZ_SELECT_ROLE_OR_STAT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar BG_DATA_NO_CHANGE = \"");
      out.print(OrgI18nConsts.BG_DATA_NO_CHANGE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_PRIVILEGE_DETAIL = \"");
      out.print(OrgI18nConsts.DELEGATE_PRIVILEGE_DETAIL);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_TRUSTOR_MANDATORY = \"");
      out.print(OrgI18nConsts.DELEGATE_TRUSTOR_MANDATORY);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_DELE_NAME_LONG = \"");
      out.print(OrgI18nConsts.DELEGATE_DELE_NAME_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_PLZ_SELECT_TRUSTEE = \"");
      out.print(OrgI18nConsts.DELEGATE_PLZ_SELECT_TRUSTEE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_TRUSTEE_LONG = \"");
      out.print(OrgI18nConsts.DELEGATE_TRUSTEE_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_TRUSTOR_TRUSTEE_CANT_SAME = \"");
      out.print(OrgI18nConsts.DELEGATE_TRUSTOR_TRUSTEE_CANT_SAME);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_END_TIME_LESS_THEN_START_TIME = \"");
      out.print(OrgI18nConsts.DELEGATE_END_TIME_LESS_THEN_START_TIME);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_PLZ_FILL_END_TIME = \"");
      out.print(OrgI18nConsts.DELEGATE_PLZ_FILL_END_TIME);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_SAVE_RECORD_WAS_FOUND = \"");
      out.print(OrgI18nConsts.DELEGATE_SAVE_RECORD_WAS_FOUND);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_SELECT_DELE_TO_EDIT = \"");
      out.print(OrgI18nConsts.DELEGATE_SELECT_DELE_TO_EDIT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_SELECT_DELE_TO_DELETE = \"");
      out.print(OrgI18nConsts.DELEGATE_SELECT_DELE_TO_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_CONFIRM_USER_DELETE = \"");
      out.print(OrgI18nConsts.DELEGATE_CONFIRM_USER_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_CONFIRM_DELEGATE_DELETE = \"");
      out.print(OrgI18nConsts.DELEGATE_CONFIRM_DELEGATE_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_PLZ_SELECT = \"");
      out.print(OrgI18nConsts.DELEGATE_PLZ_SELECT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_DESC_LONG = \"");
      out.print(OrgI18nConsts.DELEGATE_DESC_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar STAT_SELECT_ORG = \"");
      out.print(OrgI18nConsts.STAT_SELECT_ORG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar CANT_EDIT_OTHERS_DELEGATE = \"");
      out.print(OrgI18nConsts.CANT_EDIT_OTHERS_DELEGATE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar PLZ_SELECT_PRIVILEGE = \"");
      out.print(OrgI18nConsts.PLZ_SELECT_PRIVILEGE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar CANT_DEL_OTHERS_DELEGATE = \"");
      out.print(OrgI18nConsts.CANT_DEL_OTHERS_DELEGATE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar DELEGATE_NOT_EXIST = \"");
      out.print(OrgI18nConsts.DELEGATE_NOT_EXIST);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("    var UNIT_SELECT_NODE_FIRST = \"");
      out.print(OrgI18nConsts.UNIT_SELECT_NODE_FIRST);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("    var UNIT_NO_PRIVILEGES = \"");
      out.print(OrgI18nConsts.UNIT_NO_PRIVILEGES);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_SELECT_NODE_TO_DELETE = \"");
      out.print(OrgI18nConsts.UNIT_SELECT_NODE_TO_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_NODE_CANT_DELETE = \"");
      out.print(OrgI18nConsts.UNIT_NODE_CANT_DELETE);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_USERACCOUNT = \"");
      out.print(OrgI18nConsts.UNIT_USERACCOUNT);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_USERNAME = \"");
      out.print(OrgI18nConsts.UNIT_USERNAME);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_TEXT_TOO_LONG = \"");
      out.print(OrgI18nConsts.UNIT_TEXT_TOO_LONG);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_SELECT_DATA = \"");
      out.print(OrgI18nConsts.UNIT_SELECT_DATA);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_FILL_ORGUNITNAME = \"");
      out.print(OrgI18nConsts.UNIT_FILL_ORGUNITNAME);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_LEADER_STATION = \"");
      out.print(OrgI18nConsts.UNIT_LEADER_STATION);
      out.write("\";\r\n");
      out.write("\r\n");
      out.write("\tvar UNIT_NAME = \"");
      out.print(OrgI18nConsts.UNIT_NAME);
      out.write("\";\r\n");
      out.write("\t\r\n");
      out.write("\tvar ITEM_DELETE_CONFIRM = \"");
      out.print(OrgI18nConsts.ITEM_DELETE_CONFIRM);
      out.write("\";\r\n");
      out.write("</script>");
      out.write("\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\"\r\n");
      out.write("\thref=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/main.css\" />\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\"\r\n");
      out.write("\thref=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/jquery.ui.all.css\" />\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\"\r\n");
      out.write("\thref=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ui.form.css\" />\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\"\r\n");
      out.write("\thref=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/dhtmlxtree/css/MenuSkins/dhtmlxmenu_dhx_blue.css\" />\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\"\r\n");
      out.write("\thref=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/dhtmlxtree/css/dhtmlxtree.css\" />\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/dhtmlxtree/dhtmlxcommon.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/dhtmlxtree/dhtmlxtree.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/dhtmlxtree/dhtmlxmenu.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/scripts/jquery-1.4.2.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/minified/jquery.ui.core.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery.ui.draggable.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery.ui.resizable.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery.ui.dialog.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery.effects.core.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery.effects.highlight.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/minified/jquery.ui.widget.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jsplit/jsplit.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" \r\n");
      out.write("    src=\"");
      out.print(webpath );
      out.write("/view/base/plugin/utils/MessageBox_jQuery.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"MenuMain.js\"></script>\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar webpath = \"");
      out.print(webpath);
      out.write("\";\r\n");
      out.write("\tvar jQuery = $;\r\n");
      out.write("\tvar $jQuery = $;\r\n");
      out.write("</script>\r\n");
      out.write("\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jquerytools/tooltip.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/validate/jquery.validate.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/validate/localization/messages_");
      out.print(language);
      out.write(".js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/validate/jquery.validate.ext.js\"></script>\r\n");
      out.write("\r\n");
      out.write("</head>\r\n");
      out.write("<body>  \r\n");
      out.write("<div style=\"padding:10px 0 0px 6px;background:#fff;height:400px; width:600px;border:0px\">\r\n");
      out.write("\t<table>\r\n");
      out.write("\t\t<tr>\r\n");
      out.write("\t\t\t<td>\r\n");
      out.write("\t\t\t    <div id=\"splitter\" style=\"border:1px solid #ccc;background:#ffffff;width:250px;overflow:auto;\">\r\n");
      out.write("\t\t\t    <table style=\"width:100%;\" cellspacing=0 cellpadding=0 border=\"0\">\r\n");
      out.write("\t\t\t        <tr>\r\n");
      out.write("\t\t\t           <td height=\"25px\" style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\">\r\n");
      out.write("\t\t\t\t\t\t\t<font style=\"padding:5px 0 0px 0;margin:0; font-size:13px;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t");
      if (_jspx_meth_bean_005fmessage_005f1(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t</font>\r\n");
      out.write("\t\t\t\t\t  </td>\r\n");
      out.write("\t\t\t        </tr>\r\n");
      out.write("\t\t\t        <tr>\r\n");
      out.write("\t\t\t           <td>\r\n");
      out.write("\t\t\t               <div id=\"menuTree\" style=\"height:370px;overflow:auto;\"></div>\r\n");
      out.write("\t\t\t           </td>\r\n");
      out.write("\t\t\t        </tr>\r\n");
      out.write("\t\t\t    </table>\t\t\r\n");
      out.write("\t\t\t\t</div>\t\r\n");
      out.write("\t\t\t</td>\r\n");
      out.write("\t\t\t<td>\r\n");
      out.write("\t\t\t\t<div id=\"form\" style=\"border:1px solid #ccc; border-left:0;height:395px;width:500px\">\r\n");
      out.write("\t\t\t\t   <form name=\"menuDetail\" id=\"menuDetail\">\r\n");
      out.write("\t\t\t\t      <table style=\"font-size: 12px; width:100%\" cellspacing=0 cellpadding=0 border=\"0\">\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td height=\"25px\" style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\"\r\n");
      out.write("\t\t\t\t\t\t\t colspan=\"2\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<font style=\"padding:5px 0 0px 0;margin:0; font-size:13px;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
      if (_jspx_meth_bean_005fmessage_005f2(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</font>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t </tr>\r\n");
      out.write("\t\t\t\t\t\t </table>\r\n");
      out.write("\t\t\t\t\t\t <table style=\"font-size: 12px;cellspacing:0;cellpadding:0; border:0\">\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f3(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"menuName\" name=\"menuName\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td >");
      if (_jspx_meth_bean_005fmessage_005f4(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"menuImg\" name=\"menuImg\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td >");
      if (_jspx_meth_bean_005fmessage_005f5(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"menuDes\" name=\"menuDes\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f6(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"menuLocal\" name=\"menuLocal\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr style=\"display: none\">\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f7(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"menuArea\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f8(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <select id=\"menuDis\" style=\"width:200px\">\r\n");
      out.write("\t\t\t\t                 <option value =\"0\" selected>");
      if (_jspx_meth_bean_005fmessage_005f9(_jspx_page_context))
        return;
      out.write("</option>\r\n");
      out.write("\t\t\t\t                 <option value =\"1\">");
      if (_jspx_meth_bean_005fmessage_005f10(_jspx_page_context))
        return;
      out.write("</option>\r\n");
      out.write("\t\t\t\t               </select> \r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t \r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t\t\t   <td colspan=\"2\" align=\"right\" >\r\n");
      out.write("\t\t\t\t\t\t       <input class=\"jt_botton_table2\" type=\"button\" id=\"btn_menuReset\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f11(_jspx_page_context))
        return;
      out.write("\" onClick=\"menuDetail.reset();\">\r\n");
      out.write("\t\t\t\t\t           <input class=\"jt_botton_table2\" type=\"button\" id=\"btn_menuSave\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f12(_jspx_page_context))
        return;
      out.write("\" onclick=\"saveMenu()\"> \r\n");
      out.write("\t\t\t\t\t        </td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t      </table>\r\n");
      out.write("\t\t\t\t   </form>\r\n");
      out.write("\t\t\t\t   <form name=\"elementDetail\" id=\"elementDetail\" class=\"jqueryui\">\r\n");
      out.write("\t\t\t\t      <table style=\"font-size: 12px; width:100%;\" cellspacing=0 cellpadding=0 border=\"0\">\r\n");
      out.write("\t\t\t\t      <tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td height=\"25px\" style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\" colspan=\"2\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<font style=\"padding:5px 0 0px 0;margin:0; font-size:13px;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
      if (_jspx_meth_bean_005fmessage_005f13(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</font>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t </tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t<table style=\"font-size: 12px; cellspacing:0; cellpadding:0; border:0\">\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f14(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"eleId\" name=\"eleId\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f15(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"eleName\" name=\"eleName\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f16(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"eleImg\" name=\"eleImg\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f17(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <select id=\"eleType\" type=\"eleType\" style=\"width:200px\"></select>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f18(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"eleDes\" name=\"eleDes\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t\t\t   <td colspan=\"2\" align=\"right\">\r\n");
      out.write("\t\t\t\t\t\t       <input class=\"jt_botton_table2\" type=\"button\" id=\"btn_eleReset\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f19(_jspx_page_context))
        return;
      out.write("\" onClick=\"elementDetail.reset()\">\r\n");
      out.write("\t\t\t\t\t           <input class=\"jt_botton_table2\" type=\"button\" id=\"btn_eleSave\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f20(_jspx_page_context))
        return;
      out.write("\" onclick=\"saveEle()\">   \r\n");
      out.write("\t\t\t\t\t        </td>\r\n");
      out.write("\t\t\t\t\t\t</tr>         \t\t\t\t         \t\t\t\t         \t\t\t         \r\n");
      out.write("\t\t\t\t      </table>\r\n");
      out.write("\t\t\t\t   </form>\r\n");
      out.write("\t\t\t\t    <form name=\"pageDetail\" id=\"pageDetail\" class=\"jqueryui\">\r\n");
      out.write("\t\t\t\t      <table style=\"font-size: 12px; width:100%\" cellspacing=0 cellpadding=0 border=\"0\">\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td height=\"25px\" style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\"\r\n");
      out.write("\t\t\t\t\t\t\t colspan=\"2\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<font style=\"padding:5px 0 0px 0;margin:0; font-size:13px;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
      if (_jspx_meth_bean_005fmessage_005f21(_jspx_page_context))
        return;
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</font>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t </tr>\r\n");
      out.write("\t\t\t\t\t\t </table>\r\n");
      out.write("\t\t\t\t\t\t <table style=\"font-size: 12px;cellspacing:0; cellpadding:0; border:0;\">\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f22(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"pageId\" name=\"pageId\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f23(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"pageName\" name=\"pageName\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td >");
      if (_jspx_meth_bean_005fmessage_005f24(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"pageImg\" name=\"pageImg\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td >");
      if (_jspx_meth_bean_005fmessage_005f25(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"pageDes\" name=\"pageDes\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f26(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"pageLocal\" name=\"pageLocal\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr style=\"display: none\">\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f27(_jspx_page_context))
        return;
      out.write(":\r\n");
      out.write("\t\t\t\t            \t&nbsp;<font color=\"#ff0000\">*</font>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <input type=\"text\" id=\"pageArea\" style=\"width:200px\"/>\r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t\r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t            <td>");
      if (_jspx_meth_bean_005fmessage_005f28(_jspx_page_context))
        return;
      out.write(":</td>\r\n");
      out.write("\t\t\t\t            <td>\r\n");
      out.write("\t\t\t\t               <select id=\"pageDis\" style=\"width:200px\">\r\n");
      out.write("\t\t\t\t                 <option value =\"0\" selected>");
      if (_jspx_meth_bean_005fmessage_005f29(_jspx_page_context))
        return;
      out.write("</option>\r\n");
      out.write("\t\t\t\t                 <option value =\"1\">");
      if (_jspx_meth_bean_005fmessage_005f30(_jspx_page_context))
        return;
      out.write("</option>\r\n");
      out.write("\t\t\t\t               </select> \r\n");
      out.write("\t\t\t\t            </td>\r\n");
      out.write("\t\t\t\t         </tr>\t \r\n");
      out.write("\t\t\t\t         <tr>\r\n");
      out.write("\t\t\t\t\t\t   <td colspan=\"2\" align=\"right\" >\r\n");
      out.write("\t\t\t\t\t\t       <input class=\"jt_botton_table2\" type=\"button\" id=\"btn_pageReset\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f31(_jspx_page_context))
        return;
      out.write("\" onClick=\"pageDetail.reset();\">\r\n");
      out.write("\t\t\t\t\t           <input class=\"jt_botton_table2\" type=\"button\" id=\"btn_pageSave\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f32(_jspx_page_context))
        return;
      out.write("\" onclick=\"savePage()\"> \r\n");
      out.write("\t\t\t\t\t        </td>\r\n");
      out.write("\t\t\t\t\t\t</tr> \t\t\t\t         \t\t\t\t         \t\t\t\t         \t\t\t         \r\n");
      out.write("\t\t\t\t      </table>\r\n");
      out.write("\t\t\t\t   </form>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</td>\r\n");
      out.write("\t\t</tr>\r\n");
      out.write("\t</table>\r\n");
      out.write("</div>\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else log(t.getMessage(), t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }

  private boolean _jspx_meth_bean_005fmessage_005f0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f0 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f0.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f0.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(29,7) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f0.setKey("stat.title.stat_mngt");
      int _jspx_eval_bean_005fmessage_005f0 = _jspx_th_bean_005fmessage_005f0.doStartTag();
      if (_jspx_th_bean_005fmessage_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f1(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f1 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f1.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f1.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(93,8) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f1.setKey("menu.element.func_menu");
      int _jspx_eval_bean_005fmessage_005f1 = _jspx_th_bean_005fmessage_005f1.doStartTag();
      if (_jspx_th_bean_005fmessage_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f1);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f2(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f2 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f2.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f2.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(113,9) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f2.setKey("menu.element.menu_detail_info");
      int _jspx_eval_bean_005fmessage_005f2 = _jspx_th_bean_005fmessage_005f2.doStartTag();
      if (_jspx_th_bean_005fmessage_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f2);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f3(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f3 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f3.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f3.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(120,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f3.setKey("menu.element.name");
      int _jspx_eval_bean_005fmessage_005f3 = _jspx_th_bean_005fmessage_005f3.doStartTag();
      if (_jspx_th_bean_005fmessage_005f3.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f3);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f4(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f4 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f4.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f4.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(128,21) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f4.setKey("menu.element.img_path");
      int _jspx_eval_bean_005fmessage_005f4 = _jspx_th_bean_005fmessage_005f4.doStartTag();
      if (_jspx_th_bean_005fmessage_005f4.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f4);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f5(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f5 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f5.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f5.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(134,21) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f5.setKey("menu.element.desc");
      int _jspx_eval_bean_005fmessage_005f5 = _jspx_th_bean_005fmessage_005f5.doStartTag();
      if (_jspx_th_bean_005fmessage_005f5.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f5);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f6(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f6 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f6.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f6.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(140,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f6.setKey("menu.element.url");
      int _jspx_eval_bean_005fmessage_005f6 = _jspx_th_bean_005fmessage_005f6.doStartTag();
      if (_jspx_th_bean_005fmessage_005f6.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f6);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f7(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f7 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f7.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f7.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(146,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f7.setKey("menu.element.target_area");
      int _jspx_eval_bean_005fmessage_005f7 = _jspx_th_bean_005fmessage_005f7.doStartTag();
      if (_jspx_th_bean_005fmessage_005f7.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f7);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f8(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f8 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f8.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f8.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(154,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f8.setKey("menu.element.default_display");
      int _jspx_eval_bean_005fmessage_005f8 = _jspx_th_bean_005fmessage_005f8.doStartTag();
      if (_jspx_th_bean_005fmessage_005f8.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f8);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f9(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f9 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f9.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f9.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(157,49) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f9.setKey("role.element.no");
      int _jspx_eval_bean_005fmessage_005f9 = _jspx_th_bean_005fmessage_005f9.doStartTag();
      if (_jspx_th_bean_005fmessage_005f9.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f9);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f10(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f10 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f10.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f10.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(158,40) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f10.setKey("role.element.yes");
      int _jspx_eval_bean_005fmessage_005f10 = _jspx_th_bean_005fmessage_005f10.doStartTag();
      if (_jspx_th_bean_005fmessage_005f10.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f10);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f11(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f11 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f11.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f11.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(164,85) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f11.setKey("common.button.reset");
      int _jspx_eval_bean_005fmessage_005f11 = _jspx_th_bean_005fmessage_005f11.doStartTag();
      if (_jspx_th_bean_005fmessage_005f11.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f11);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f12(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f12 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f12.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f12.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(165,87) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f12.setKey("common.button.save");
      int _jspx_eval_bean_005fmessage_005f12 = _jspx_th_bean_005fmessage_005f12.doStartTag();
      if (_jspx_th_bean_005fmessage_005f12.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f12);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f13(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f13 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f13.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f13.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(175,9) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f13.setKey("menu.element.element_detail_info");
      int _jspx_eval_bean_005fmessage_005f13 = _jspx_th_bean_005fmessage_005f13.doStartTag();
      if (_jspx_th_bean_005fmessage_005f13.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f13);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f14(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f14 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f14.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f14.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(182,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f14.setKey("menu.element.element_id");
      int _jspx_eval_bean_005fmessage_005f14 = _jspx_th_bean_005fmessage_005f14.doStartTag();
      if (_jspx_th_bean_005fmessage_005f14.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f14);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f15(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f15 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f15.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f15.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(190,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f15.setKey("menu.element.element_name");
      int _jspx_eval_bean_005fmessage_005f15 = _jspx_th_bean_005fmessage_005f15.doStartTag();
      if (_jspx_th_bean_005fmessage_005f15.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f15);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f16(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f16 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f16.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f16.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(198,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f16.setKey("menu.element.img_path");
      int _jspx_eval_bean_005fmessage_005f16 = _jspx_th_bean_005fmessage_005f16.doStartTag();
      if (_jspx_th_bean_005fmessage_005f16.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f16);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f17(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f17 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f17.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f17.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(204,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f17.setKey("menu.element.element_type");
      int _jspx_eval_bean_005fmessage_005f17 = _jspx_th_bean_005fmessage_005f17.doStartTag();
      if (_jspx_th_bean_005fmessage_005f17.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f17);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f18(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f18 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f18.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f18.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(212,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f18.setKey("menu.element.desc");
      int _jspx_eval_bean_005fmessage_005f18 = _jspx_th_bean_005fmessage_005f18.doStartTag();
      if (_jspx_th_bean_005fmessage_005f18.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f18);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f19(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f19 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f19.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f19.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(219,84) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f19.setKey("common.button.reset");
      int _jspx_eval_bean_005fmessage_005f19 = _jspx_th_bean_005fmessage_005f19.doStartTag();
      if (_jspx_th_bean_005fmessage_005f19.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f19);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f20(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f20 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f20.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f20.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(220,86) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f20.setKey("common.button.save");
      int _jspx_eval_bean_005fmessage_005f20 = _jspx_th_bean_005fmessage_005f20.doStartTag();
      if (_jspx_th_bean_005fmessage_005f20.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f20);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f21(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f21 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f21.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f21.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(231,9) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f21.setKey("menu.element.page_detail");
      int _jspx_eval_bean_005fmessage_005f21 = _jspx_th_bean_005fmessage_005f21.doStartTag();
      if (_jspx_th_bean_005fmessage_005f21.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f21);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f22(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f22 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f22.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f22.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(238,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f22.setKey("menu.element.page_id");
      int _jspx_eval_bean_005fmessage_005f22 = _jspx_th_bean_005fmessage_005f22.doStartTag();
      if (_jspx_th_bean_005fmessage_005f22.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f22);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f23(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f23 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f23.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f23.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(246,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f23.setKey("menu.element.page_name");
      int _jspx_eval_bean_005fmessage_005f23 = _jspx_th_bean_005fmessage_005f23.doStartTag();
      if (_jspx_th_bean_005fmessage_005f23.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f23);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f24(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f24 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f24.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f24.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(254,21) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f24.setKey("menu.element.img_path");
      int _jspx_eval_bean_005fmessage_005f24 = _jspx_th_bean_005fmessage_005f24.doStartTag();
      if (_jspx_th_bean_005fmessage_005f24.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f24);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f25(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f25 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f25.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f25.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(260,21) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f25.setKey("menu.element.desc");
      int _jspx_eval_bean_005fmessage_005f25 = _jspx_th_bean_005fmessage_005f25.doStartTag();
      if (_jspx_th_bean_005fmessage_005f25.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f25);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f26(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f26 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f26.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f26.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(266,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f26.setKey("menu.element.url");
      int _jspx_eval_bean_005fmessage_005f26 = _jspx_th_bean_005fmessage_005f26.doStartTag();
      if (_jspx_th_bean_005fmessage_005f26.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f26);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f27(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f27 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f27.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f27.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(272,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f27.setKey("menu.element.target_area");
      int _jspx_eval_bean_005fmessage_005f27 = _jspx_th_bean_005fmessage_005f27.doStartTag();
      if (_jspx_th_bean_005fmessage_005f27.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f27);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f28(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f28 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f28.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f28.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(280,20) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f28.setKey("menu.element.default_display");
      int _jspx_eval_bean_005fmessage_005f28 = _jspx_th_bean_005fmessage_005f28.doStartTag();
      if (_jspx_th_bean_005fmessage_005f28.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f28);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f29(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f29 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f29.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f29.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(283,49) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f29.setKey("role.element.no");
      int _jspx_eval_bean_005fmessage_005f29 = _jspx_th_bean_005fmessage_005f29.doStartTag();
      if (_jspx_th_bean_005fmessage_005f29.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f29);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f30(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f30 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f30.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f30.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(284,40) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f30.setKey("role.element.yes");
      int _jspx_eval_bean_005fmessage_005f30 = _jspx_th_bean_005fmessage_005f30.doStartTag();
      if (_jspx_th_bean_005fmessage_005f30.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f30);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f31(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f31 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f31.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f31.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(290,85) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f31.setKey("common.button.reset");
      int _jspx_eval_bean_005fmessage_005f31 = _jspx_th_bean_005fmessage_005f31.doStartTag();
      if (_jspx_th_bean_005fmessage_005f31.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f31);
    }
    return false;
  }

  private boolean _jspx_meth_bean_005fmessage_005f32(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f32 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f32.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f32.setParent(null);
      // /view/authorization/menu/MenuMain.jsp(291,87) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f32.setKey("common.button.save");
      int _jspx_eval_bean_005fmessage_005f32 = _jspx_th_bean_005fmessage_005f32.doStartTag();
      if (_jspx_th_bean_005fmessage_005f32.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f32);
    }
    return false;
  }
}
