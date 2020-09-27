package org.apache.jsp.view.authorization.privilege;

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

public final class PrivilegeMain_jsp extends org.apache.jasper.runtime.HttpJspBase
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
	if (SecurityUtil.existUnavailableChar(request,"isAdminRole"))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
	//bizAuthority（业务授权，即授权可使用）,mngAuthority（管理授权，即授权可分配）
	String isAdminRole = request.getParameter("isAdminRole");
	isAdminRole = isAdminRole == null || isAdminRole.equals("") ? "" : isAdminRole;
	
    boolean hasAdminRole = false;
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
      out.write("/view/base/theme/css/redmond/dhtmlxtree/css/dhtmlxtree.css\" />\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\"\r\n");
      out.write("\thref=\"");
      out.print(webpath );
      out.write("/view/base/theme/css/redmond/msdropdown/css/dd.css\" />\r\n");
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
      out.print(webpath );
      out.write("/view/base/plugin/msdropdown/jquery.dd.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" \r\n");
      out.write("    src=\"");
      out.print(webpath );
      out.write("/view/base/plugin/utils/Arraylist.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" \r\n");
      out.write("    src=\"");
      out.print(webpath );
      out.write("/view/base/plugin/utils/MessageBox_Dollar.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath );
      out.write("/view/authorization/privilege/PrivilegeMain.js\"></script>\r\n");
      out.write("\r\n");
      out.write("<style>\r\n");
      out.write("\t#splitter{background:#efefef;width:100%;height:400px;top:0; left:0px!important; left:3px; border:1px solid #ccc;}\r\n");
      out.write("</style>\r\n");
      out.write("\r\n");
      out.write("<script language=\"javascript\">\r\n");
      out.write("\tvar webpath = \"");
      out.print(webpath);
      out.write("\";\r\n");
      out.write("\tvar isAdminRole = \"");
      out.print(isAdminRole);
      out.write("\";\r\n");
      out.write("\t//记录展开菜单树结点前结点出的记录数\r\n");
      out.write("\tvar beforeOpenSubNodes = -1;\r\n");
      out.write("\t//左侧列表中选择的当前“类型”\r\n");
      out.write("\tcurrSelType = null;\r\n");
      out.write("\t//左侧列表中选择的当前“ID”\r\n");
      out.write("\tcurrSelID = null;\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<div style=\"padding:10px 0 0px 6px;background:#fff; width:800px; height:400px;border:0px\">\r\n");
      out.write("\t<table>\r\n");
      out.write("\t\t<tr>\r\n");
      out.write("\t\t\t<td>\r\n");
      out.write("\t\t\t\t<!-- 下面是左侧角色、岗位选择区域 -->\r\n");
      out.write("\t\t\t\t<div id=\"splitter\" style=\"border:1px solid #ccc;background:#ffffff;width:250px;height:400px;overflow:hidden;\">\r\n");
      out.write("\t\t\t\t\t<table style=\"width:100%;\" cellspacing=0 cellpadding=0 border=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td height=\"25px\"  style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\">\r\n");
      out.write("\t\t\t\t\t\t\t<font style=\"padding:5px 0 0px 0;margin:0; font-size:13px;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t");
      if (_jspx_meth_bean_005fmessage_005f1(_jspx_page_context))
        return;
      out.write(":</font>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t<tr>\r\n");
      out.write("\t\t\t\t\t\t\t<td>\r\n");
      out.write("\t\t\t\t\t\t\t<div id=\"tabs\" style=\"height:96%;width:96%;border:0px;font-size:13px;overflow:hidden;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<ul>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<li><a href=\"#tabs-1\">");
      if (_jspx_meth_bean_005fmessage_005f2(_jspx_page_context))
        return;
      out.write("</a></li>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
if (isAdminRole.equals("")) { 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<li><a href=\"#tabs-2\">");
      if (_jspx_meth_bean_005fmessage_005f3(_jspx_page_context))
        return;
      out.write("</a></li> \r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
} 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</ul>\r\n");
      out.write("\t\t\t\t\t\t\t\t<div id=\"tabs-1\" style=\"border:0px;padding:0px 0 0px 0;margin:0;width:100%;height:100%;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<select name=\"listbox\" id=\"listbox\" size=\"15\" onclick=\"roleSelect('listbox')\" \r\n");
      out.write("\t\t\t\t\t\t\t\t\t\tstyle=\"display:none;border:0px;padding:0px 0 0px 0;margin:0;width:100%;height:100%;\">\r\n");
      out.write("\t\t\t\t\t\t            </select>\r\n");
      out.write("\t\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t\t<div id=\"tabs-2\" style=\"padding:5px 5px 5px 5px;margin:0;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
if (isAdminRole.equals("")) { 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t\t<div id=\"orgTree\" style=\"height:96%;width:96%;overflow:auto;\"></div>\r\n");
      out.write("\t\t\t\t\t\t\t\t\t");
} 
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t</div>\t\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</td>\r\n");
      out.write("\t\t\t<td>\r\n");
      out.write("\t\t\t\t<!-- 下面是右侧选择树区域 -->\r\n");
      out.write("\t\t\t\t<div style=\"border:1px solid #ccc; border-left:2;height:400px; width:500px\">\r\n");
      out.write("\t\t\t\t<form class=\"jqueryui\">\r\n");
      out.write("\t\t\t\t\t<table style=\"font-size: 12px; width:100%\" cellspacing=0 cellpadding=0 border=\"0\">\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"25px\">\r\n");
      out.write("\t\t\t\t\t\t\t<td  style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<font style=\"padding:5px 0 0px 0;margin:0; font-size:13px;\">\r\n");
      out.write("\t\t\t\t\t\t\t\t");
      if (_jspx_meth_bean_005fmessage_005f4(_jspx_page_context))
        return;
      out.write(":</font>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t\t<td align=\"right\"  style=\"background-image:url(");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/images/headerBg.gif);\">\r\n");
      out.write("\t\t\t\t\t\t\t    <input class=\"jt_botton_table2\" type=\"button\" id=\"btnClean\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f5(_jspx_page_context))
        return;
      out.write("\" onClick=\"cleanSubnode()\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<input class=\"jt_botton_table2\" type=\"button\" id=\"btnExpand\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f6(_jspx_page_context))
        return;
      out.write("\" onClick=\"expandAll()\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<input class=\"jt_botton_table2\" type=\"button\" id=\"btnClose\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f7(_jspx_page_context))
        return;
      out.write("\" onClick=\"closeAll()\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<input class=\"jt_botton_table2\" type=\"button\" id=\"btnSave\" value=\"");
      if (_jspx_meth_bean_005fmessage_005f8(_jspx_page_context))
        return;
      out.write("\" onclick=\"savePrivileges()\">\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"100%\" valign=\"top\" >\r\n");
      out.write("\t\t\t\t\t\t\t<td height=\"100%\" colspan=\"2\" width=\"100%\">\r\n");
      out.write("\t\t\t\t\t\t\t\t<div id=\"menuTree\" style=\"height:370px;overflow:auto;\"></div>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t</form>\r\n");
      out.write("\t\t\t\t</div>\r\n");
      out.write("\t\t\t</td>\r\n");
      out.write("\t\t</tr>\r\n");
      out.write("\t</table>\r\n");
      out.write("</div>\t\t\r\n");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(30,7) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f0.setKey("role.title.role_mngt");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(101,8) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f1.setKey("bg.element.role_stat");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(108,31) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f2.setKey("bg.element.role");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(110,31) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f3.setKey("bg.element.station");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(137,8) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f4.setKey("bg.element.useable_menu");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(140,78) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f5.setKey("bg.button.empty_sub_nodes");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(141,76) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f6.setKey("bg.button.expend_all");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(142,75) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f7.setKey("bg.button.collaspane_all");
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
      // /view/authorization/privilege/PrivilegeMain.jsp(143,74) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f8.setKey("common.button.save");
      int _jspx_eval_bean_005fmessage_005f8 = _jspx_th_bean_005fmessage_005f8.doStartTag();
      if (_jspx_th_bean_005fmessage_005f8.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f8);
    }
    return false;
  }
}
