package org.apache.jsp.view.organization.user;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.ArrayList;
import com.dhc.base.common.consts.CommonConsts;
import com.dhc.organization.role.domain.WF_ORG_ROLE;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.base.common.util.SecurityUtil;
import com.dhc.base.common.consts.CommonConsts;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.base.security.SecurityUser;
import com.dhc.base.security.SecurityUserHoder;

public final class UserSelect_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(3);
    _jspx_dependants.add("/view/base/common/i18nConsts.jsp");
    _jspx_dependants.add("/WEB-INF/tld/struts-bean.tld");
    _jspx_dependants.add("/WEB-INF/tld/ecside.tld");
  }

  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fec_005ftable_0026_005fxlsFileName_005fvar_005fuseAjax_005ftoolbarContent_005fsortable_005frowsDisplayed_005fretrieveRowsCallback_005fpageSizeList_005fminHeight_005flistWidth_005fitems_005fheight_005fcsvFileName_005faction;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fec_005frow;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005fviewsAllowed_005fvalue_005fstyle_005fheaderCell_005fcell_005falias_005fnobody;
  private org.apache.jasper.runtime.TagHandlerPool _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fec_005ftable_0026_005fxlsFileName_005fvar_005fuseAjax_005ftoolbarContent_005fsortable_005frowsDisplayed_005fretrieveRowsCallback_005fpageSizeList_005fminHeight_005flistWidth_005fitems_005fheight_005fcsvFileName_005faction = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fec_005frow = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005fviewsAllowed_005fvalue_005fstyle_005fheaderCell_005fcell_005falias_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
    _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.release();
    _005fjspx_005ftagPool_005fec_005ftable_0026_005fxlsFileName_005fvar_005fuseAjax_005ftoolbarContent_005fsortable_005frowsDisplayed_005fretrieveRowsCallback_005fpageSizeList_005fminHeight_005flistWidth_005fitems_005fheight_005fcsvFileName_005faction.release();
    _005fjspx_005ftagPool_005fec_005frow.release();
    _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005fviewsAllowed_005fvalue_005fstyle_005fheaderCell_005fcell_005falias_005fnobody.release();
    _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.release();
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
      response.setContentType("text/html;charset=UTF-8");
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
      out.write("\r\n");
      out.write("\r\n");

	//防跨站脚本编制
	String webpath = request.getContextPath();
	if (SecurityUtil.existUnavailableChar(request,null))
		response.sendRedirect(webpath + "/WebContent/view/base/error/SecurityError.jsp");
	
    String language = CommonConsts.LANGUAGE;
    String needAllUser = request.getParameter("needAllUser");
    
    //页面打开时，选中已有的用户(把checkbox控件选中)
    String selectedUsers = request.getParameter("stationUserIDs");
    if (selectedUsers == null || selectedUsers.equals("")) {
    	selectedUsers = "";
    }

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
      out.write("<link rel=\"stylesheet\" type=\"text/css\" \r\n");
      out.write("    href=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/ecside/css/ecside_style.css\" />\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath );
      out.write("/view/base/common/DivDialogUtil.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/scripts/jquery-1.4.2.min.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.js\"></script>\r\n");
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
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar jQuery = $;\r\n");
      out.write("\tjQuery().ready(function(){    \r\n");
      out.write("\t\tjQuery('body').bind('keydown',shieldCommon);\r\n");
      out.write("\t});\r\n");
      out.write("</script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/ecside/ecside_msg_utf8_");
      out.print(language);
      out.write(".js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/ecside/prototype_mini.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\"\r\n");
      out.write("\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/ecside/ecside.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" \r\n");
      out.write("    src=\"");
      out.print(webpath );
      out.write("/view/base/plugin/utils/MessageBox_Dollar.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\">\r\n");
      out.write("\tvar webpath = \"");
      out.print(webpath);
      out.write("\";\r\n");
      out.write("\t");
 if (!selectedUsers.equals("")){
      out.write("\r\n");
      out.write("\t\t//把页面初始化数据放到hashTable中，用于给已选的项打挑\r\n");
      out.write("\t\thashTable.put(999999,'");
      out.print(selectedUsers);
      out.write("'.split(\",\"));\r\n");
      out.write("\t");
 }
      out.write("\r\n");
      out.write("\t//保存选择的结果\r\n");
      out.write("\tfunction confirmUserSelect(){\r\n");
      out.write("\t\tvar returnObj = new Object();\r\n");
      out.write("\t\tvar returnValue;\r\n");
      out.write("\t\t//用于存放当前页的id，历史页的id不在这里存放\r\n");
      out.write("\t\tvar currentPageIDs =\"\";\r\n");
      out.write("\t\tvar allcheckarray =ECSideUtil.getPageCheckValue(\"checkBoxID\");\r\n");
      out.write("\t\tif(allcheckarray)\r\n");
      out.write("\t\t\tcurrentPageIDs = allcheckarray.join(\",\");\r\n");
      out.write("\t\t//表示hashtable中没有数据\r\n");
      out.write("\t\tif (hashTable.hashtable.length == 0){\r\n");
      out.write("\t\t\treturnObj.itemIds = currentPageIDs;\r\n");
      out.write("\t\t} else {\r\n");
      out.write("\t\t\tvar idString = \"\";\r\n");
      out.write("\t\t\t//把每一页中选定的那些id都拼成一个串\r\n");
      out.write("\t\t\tfor(i=0; i<hashTable.hashtable.length; i++){\r\n");
      out.write("\t\t\t\tif (hashTable.hashtable[i]){\r\n");
      out.write("\t\t\t\t\tidString += hashTable.hashtable[i];\r\n");
      out.write("\t\t\t\t\t//alert(idString);\r\n");
      out.write("\t\t\t\t\tif (i<hashTable.hashtable.length-1){\r\n");
      out.write("\t\t\t\t\t\tidString += \",\";\r\n");
      out.write("\t\t\t\t\t}\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t\tif (ECSideUtil.trimString(currentPageIDs) != \"\")\r\n");
      out.write("\t\t\t\tidString += (\",\" + currentPageIDs);\r\n");
      out.write("\t\t\tidString = idString.split(\",\").uniq().join(\",\");\r\n");
      out.write("\t\t\t//有的时候，一次uniq不行，还要再uniq一次\r\n");
      out.write("\t\t\tidString = idString.split(\",\").uniq().join(\",\");\r\n");
      out.write("\t\t\t//alert(idString);\r\n");
      out.write("\t\t\treturnObj.itemIds = idString;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t//alert(returnObj.itemIds);\r\n");
      out.write("\t\tvar sURL1 = webpath + \"/UserAction.do?method=getUsersInUserIds\";\r\n");
      out.write("\t\tjQuery.ajax( {\r\n");
      out.write("\t\t\turl : sURL1,\r\n");
      out.write("\t\t\ttype : \"post\",\r\n");
      out.write("\t\t\tasync : false,\r\n");
      out.write("\t\t\tdataType : \"json\",\r\n");
      out.write("\t\t\tdata : {\r\n");
      out.write("\t\t\t\tuserIds : returnObj.itemIds\r\n");
      out.write("\t\t\t},\r\n");
      out.write("\t\t\tsuccess : function(data) {\r\n");
      out.write("\t\t\t\tif(data.errorMessage == undefined){\r\n");
      out.write("\t\t\t\t\t//alert(data.userNames);\r\n");
      out.write("\t\t\t\t\treturnObj.itemTexts = data.userNames;\r\n");
      out.write("\t\t\t\t\t//alert(returnObj.itemIds);\r\n");
      out.write("\t\t\t\t\t//alert(returnObj.itemTexts);\r\n");
      out.write("\t\t\t\t\t//window.returnValue = returnObj;\r\n");
      out.write("\t\t\t\t\treturnValue = returnObj;\t\t\t\t\t\r\n");
      out.write("\t\t\t\t\t//window.close();\r\n");
      out.write("\t\t\t\t} else {\r\n");
      out.write("\t\t\t\t\talert(data.errorMessage);\r\n");
      out.write("\t\t\t\t}\r\n");
      out.write("\t\t\t},\r\n");
      out.write("\t\t\terror : function(XMLHttpRequest,textStatus,errorThrown){\r\n");
      out.write("\t\t\t\talert(NET_FAILD);\r\n");
      out.write("\t\t\t\t// 通常 textStatus 和 errorThrown 之中 \r\n");
      out.write("\t\t\t    // 只有一个会包含信息 \r\n");
      out.write("\t\t\t    //this;  调用本次AJAX请求时传递的options参数\r\n");
      out.write("\t\t\t}\r\n");
      out.write("\t\t});\r\n");
      out.write("\t\treturn returnValue;\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("\tfunction closeWin(){\r\n");
      out.write("\t\twindow.returnValue=null;\r\n");
      out.write("\t\twindow.close();\r\n");
      out.write("\t}\r\n");
      out.write("\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("<body style=\"padding:0px 0px 0px 5px;margin:0; border:0;\">\r\n");
      out.write("<div style=\"width:97%\">\r\n");
      out.write("\t");
      //  ec:table
      org.ecside.tag.TableTag _jspx_th_ec_005ftable_005f0 = (org.ecside.tag.TableTag) _005fjspx_005ftagPool_005fec_005ftable_0026_005fxlsFileName_005fvar_005fuseAjax_005ftoolbarContent_005fsortable_005frowsDisplayed_005fretrieveRowsCallback_005fpageSizeList_005fminHeight_005flistWidth_005fitems_005fheight_005fcsvFileName_005faction.get(org.ecside.tag.TableTag.class);
      try {
        _jspx_th_ec_005ftable_005f0.setPageContext(_jspx_page_context);
        _jspx_th_ec_005ftable_005f0.setParent(null);
        // /view/organization/user/UserSelect.jsp(151,1) name = items type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setItems(new String("userList"));
        // /view/organization/user/UserSelect.jsp(151,1) name = var type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setVar("record");
        // /view/organization/user/UserSelect.jsp(151,1) name = retrieveRowsCallback type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setRetrieveRowsCallback("limit");
        // /view/organization/user/UserSelect.jsp(151,1) name = toolbarContent type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setToolbarContent("navigation|pagejump|pagesize|status");
        // /view/organization/user/UserSelect.jsp(151,1) name = useAjax type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setUseAjax("true");
        // /view/organization/user/UserSelect.jsp(151,1) name = action type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setAction((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}/UserAction.do?method=getUser&needAllUser=<%=needAllUser %>", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
        // /view/organization/user/UserSelect.jsp(151,1) name = xlsFileName type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setXlsFileName("UserList.xls");
        // /view/organization/user/UserSelect.jsp(151,1) name = csvFileName type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setCsvFileName("UserList.csv");
        // /view/organization/user/UserSelect.jsp(151,1) name = listWidth type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setListWidth("100%");
        // /view/organization/user/UserSelect.jsp(151,1) name = sortable type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setSortable("true");
        // /view/organization/user/UserSelect.jsp(151,1) name = pageSizeList type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setPageSizeList("5,10,20,50,100,200,500");
        // /view/organization/user/UserSelect.jsp(151,1) name = rowsDisplayed type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setRowsDisplayed("10");
        // /view/organization/user/UserSelect.jsp(151,1) name = minHeight type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setMinHeight("230");
        // /view/organization/user/UserSelect.jsp(151,1) name = height type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
        _jspx_th_ec_005ftable_005f0.setHeight("230");
        int[] _jspx_push_body_count_ec_005ftable_005f0 = new int[] { 0 };
        try {
          int _jspx_eval_ec_005ftable_005f0 = _jspx_th_ec_005ftable_005f0.doStartTag();
          if (_jspx_eval_ec_005ftable_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
            do {
              out.write("\r\n");
              out.write("\t\t");
              //  ec:row
              org.ecside.tag.RowTag _jspx_th_ec_005frow_005f0 = (org.ecside.tag.RowTag) _005fjspx_005ftagPool_005fec_005frow.get(org.ecside.tag.RowTag.class);
              try {
                _jspx_th_ec_005frow_005f0.setPageContext(_jspx_page_context);
                _jspx_th_ec_005frow_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_ec_005ftable_005f0);
                int[] _jspx_push_body_count_ec_005frow_005f0 = new int[] { 0 };
                try {
                  int _jspx_eval_ec_005frow_005f0 = _jspx_th_ec_005frow_005f0.doStartTag();
                  if (_jspx_eval_ec_005frow_005f0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
                    if (_jspx_eval_ec_005frow_005f0 != javax.servlet.jsp.tagext.Tag.EVAL_BODY_INCLUDE) {
                      out = _jspx_page_context.pushBody();
                      _jspx_push_body_count_ec_005frow_005f0[0]++;
                      _jspx_th_ec_005frow_005f0.setBodyContent((javax.servlet.jsp.tagext.BodyContent) out);
                      _jspx_th_ec_005frow_005f0.doInitBody();
                    }
                    do {
                      out.write("\r\n");
                      out.write("\t\t    ");
                      if (_jspx_meth_ec_005fcolumn_005f0(_jspx_th_ec_005frow_005f0, _jspx_page_context, _jspx_push_body_count_ec_005frow_005f0))
                        return;
                      out.write(" \r\n");
                      out.write("\t\t\t");
                      //  ec:column
                      org.ecside.tag.ColumnTag _jspx_th_ec_005fcolumn_005f1 = (org.ecside.tag.ColumnTag) _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.get(org.ecside.tag.ColumnTag.class);
                      try {
                        _jspx_th_ec_005fcolumn_005f1.setPageContext(_jspx_page_context);
                        _jspx_th_ec_005fcolumn_005f1.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_ec_005frow_005f0);
                        // /view/organization/user/UserSelect.jsp(159,3) name = width type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f1.setWidth("20%");
                        // /view/organization/user/UserSelect.jsp(159,3) name = style type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f1.setStyle("text-align:center;");
                        // /view/organization/user/UserSelect.jsp(159,3) name = property type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f1.setProperty("userAccount");
                        // /view/organization/user/UserSelect.jsp(159,3) name = title type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f1.setTitle(OrgI18nConsts.USER_ACCOUNT );
                        int[] _jspx_push_body_count_ec_005fcolumn_005f1 = new int[] { 0 };
                        try {
                          int _jspx_eval_ec_005fcolumn_005f1 = _jspx_th_ec_005fcolumn_005f1.doStartTag();
                          if (_jspx_th_ec_005fcolumn_005f1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
                            return;
                          }
                        } catch (Throwable _jspx_exception) {
                          while (_jspx_push_body_count_ec_005fcolumn_005f1[0]-- > 0)
                            out = _jspx_page_context.popBody();
                          _jspx_th_ec_005fcolumn_005f1.doCatch(_jspx_exception);
                        } finally {
                          _jspx_th_ec_005fcolumn_005f1.doFinally();
                        }
                      } finally {
                        _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.reuse(_jspx_th_ec_005fcolumn_005f1);
                      }
                      out.write("\r\n");
                      out.write("\t\t\t");
                      //  ec:column
                      org.ecside.tag.ColumnTag _jspx_th_ec_005fcolumn_005f2 = (org.ecside.tag.ColumnTag) _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.get(org.ecside.tag.ColumnTag.class);
                      try {
                        _jspx_th_ec_005fcolumn_005f2.setPageContext(_jspx_page_context);
                        _jspx_th_ec_005fcolumn_005f2.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_ec_005frow_005f0);
                        // /view/organization/user/UserSelect.jsp(160,3) name = width type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f2.setWidth("30%");
                        // /view/organization/user/UserSelect.jsp(160,3) name = style type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f2.setStyle("text-align:center;");
                        // /view/organization/user/UserSelect.jsp(160,3) name = property type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f2.setProperty("userFullname");
                        // /view/organization/user/UserSelect.jsp(160,3) name = title type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f2.setTitle(OrgI18nConsts.USER_USERNAME );
                        int[] _jspx_push_body_count_ec_005fcolumn_005f2 = new int[] { 0 };
                        try {
                          int _jspx_eval_ec_005fcolumn_005f2 = _jspx_th_ec_005fcolumn_005f2.doStartTag();
                          if (_jspx_th_ec_005fcolumn_005f2.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
                            return;
                          }
                        } catch (Throwable _jspx_exception) {
                          while (_jspx_push_body_count_ec_005fcolumn_005f2[0]-- > 0)
                            out = _jspx_page_context.popBody();
                          _jspx_th_ec_005fcolumn_005f2.doCatch(_jspx_exception);
                        } finally {
                          _jspx_th_ec_005fcolumn_005f2.doFinally();
                        }
                      } finally {
                        _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.reuse(_jspx_th_ec_005fcolumn_005f2);
                      }
                      out.write("\r\n");
                      out.write("\t\t\t");
                      //  ec:column
                      org.ecside.tag.ColumnTag _jspx_th_ec_005fcolumn_005f3 = (org.ecside.tag.ColumnTag) _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.get(org.ecside.tag.ColumnTag.class);
                      try {
                        _jspx_th_ec_005fcolumn_005f3.setPageContext(_jspx_page_context);
                        _jspx_th_ec_005fcolumn_005f3.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_ec_005frow_005f0);
                        // /view/organization/user/UserSelect.jsp(161,3) name = width type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f3.setWidth("45%");
                        // /view/organization/user/UserSelect.jsp(161,3) name = style type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f3.setStyle("text-align:center;");
                        // /view/organization/user/UserSelect.jsp(161,3) name = property type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f3.setProperty("userUnits");
                        // /view/organization/user/UserSelect.jsp(161,3) name = title type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
                        _jspx_th_ec_005fcolumn_005f3.setTitle(OrgI18nConsts.USER_UNIT );
                        int[] _jspx_push_body_count_ec_005fcolumn_005f3 = new int[] { 0 };
                        try {
                          int _jspx_eval_ec_005fcolumn_005f3 = _jspx_th_ec_005fcolumn_005f3.doStartTag();
                          if (_jspx_th_ec_005fcolumn_005f3.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
                            return;
                          }
                        } catch (Throwable _jspx_exception) {
                          while (_jspx_push_body_count_ec_005fcolumn_005f3[0]-- > 0)
                            out = _jspx_page_context.popBody();
                          _jspx_th_ec_005fcolumn_005f3.doCatch(_jspx_exception);
                        } finally {
                          _jspx_th_ec_005fcolumn_005f3.doFinally();
                        }
                      } finally {
                        _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005ftitle_005fstyle_005fproperty_005fnobody.reuse(_jspx_th_ec_005fcolumn_005f3);
                      }
                      out.write("\r\n");
                      out.write("\t\t");
                      int evalDoAfterBody = _jspx_th_ec_005frow_005f0.doAfterBody();
                      if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
                        break;
                    } while (true);
                    if (_jspx_eval_ec_005frow_005f0 != javax.servlet.jsp.tagext.Tag.EVAL_BODY_INCLUDE) {
                      out = _jspx_page_context.popBody();
                      _jspx_push_body_count_ec_005frow_005f0[0]--;
                    }
                  }
                  if (_jspx_th_ec_005frow_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
                    return;
                  }
                } catch (Throwable _jspx_exception) {
                  while (_jspx_push_body_count_ec_005frow_005f0[0]-- > 0)
                    out = _jspx_page_context.popBody();
                  _jspx_th_ec_005frow_005f0.doCatch(_jspx_exception);
                } finally {
                  _jspx_th_ec_005frow_005f0.doFinally();
                }
              } finally {
                _005fjspx_005ftagPool_005fec_005frow.reuse(_jspx_th_ec_005frow_005f0);
              }
              out.write('\r');
              out.write('\n');
              out.write('	');
              int evalDoAfterBody = _jspx_th_ec_005ftable_005f0.doAfterBody();
              if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
                break;
            } while (true);
          }
          if (_jspx_th_ec_005ftable_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
            return;
          }
        } catch (Throwable _jspx_exception) {
          while (_jspx_push_body_count_ec_005ftable_005f0[0]-- > 0)
            out = _jspx_page_context.popBody();
          _jspx_th_ec_005ftable_005f0.doCatch(_jspx_exception);
        } finally {
          _jspx_th_ec_005ftable_005f0.doFinally();
        }
      } finally {
        _005fjspx_005ftagPool_005fec_005ftable_0026_005fxlsFileName_005fvar_005fuseAjax_005ftoolbarContent_005fsortable_005frowsDisplayed_005fretrieveRowsCallback_005fpageSizeList_005fminHeight_005flistWidth_005fitems_005fheight_005fcsvFileName_005faction.reuse(_jspx_th_ec_005ftable_005f0);
      }
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("<table border=0  width=\"98%\">\r\n");
      out.write("<!-- \r\n");
      out.write("<tr><td align=\"right\">\r\n");
      out.write("<input id=\"btnSave\" class=\"jt_button\" type=\"button\" value=\"保存 \"\r\n");
      out.write("\tonclick=\"confirmUserSelect()\" /> \r\n");
      out.write("<input id=\"btnClose\" class=\"jt_button\"\r\n");
      out.write("\ttype=\"button\" value=\"关闭\" onClick=\"closeWin()\" />\r\n");
      out.write("</td></tr>\r\n");
      out.write(" -->\r\n");
      out.write("</table>\r\n");
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
      // /view/organization/user/UserSelect.jsp(27,7) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f0.setKey("stat.title.user_select");
      int _jspx_eval_bean_005fmessage_005f0 = _jspx_th_bean_005fmessage_005f0.doStartTag();
      if (_jspx_th_bean_005fmessage_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f0);
    }
    return false;
  }

  private boolean _jspx_meth_ec_005fcolumn_005f0(javax.servlet.jsp.tagext.JspTag _jspx_th_ec_005frow_005f0, PageContext _jspx_page_context, int[] _jspx_push_body_count_ec_005frow_005f0)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  ec:column
    org.ecside.tag.ColumnTag _jspx_th_ec_005fcolumn_005f0 = (org.ecside.tag.ColumnTag) _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005fviewsAllowed_005fvalue_005fstyle_005fheaderCell_005fcell_005falias_005fnobody.get(org.ecside.tag.ColumnTag.class);
    try {
      _jspx_th_ec_005fcolumn_005f0.setPageContext(_jspx_page_context);
      _jspx_th_ec_005fcolumn_005f0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_ec_005frow_005f0);
      // /view/organization/user/UserSelect.jsp(157,6) name = width type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setWidth("5%");
      // /view/organization/user/UserSelect.jsp(157,6) name = style type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setStyle("text-align:center;");
      // /view/organization/user/UserSelect.jsp(157,6) name = cell type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setCell("checkbox");
      // /view/organization/user/UserSelect.jsp(157,6) name = headerCell type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setHeaderCell("checkbox");
      // /view/organization/user/UserSelect.jsp(157,6) name = alias type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setAlias("checkBoxID");
      // /view/organization/user/UserSelect.jsp(157,6) name = value type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setValue((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${record.userId}", java.lang.Object.class, (PageContext)_jspx_page_context, null, false));
      // /view/organization/user/UserSelect.jsp(157,6) name = viewsAllowed type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_ec_005fcolumn_005f0.setViewsAllowed("html");
      int[] _jspx_push_body_count_ec_005fcolumn_005f0 = new int[] { 0 };
      try {
        int _jspx_eval_ec_005fcolumn_005f0 = _jspx_th_ec_005fcolumn_005f0.doStartTag();
        if (_jspx_th_ec_005fcolumn_005f0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
          return true;
        }
      } catch (Throwable _jspx_exception) {
        while (_jspx_push_body_count_ec_005fcolumn_005f0[0]-- > 0)
          out = _jspx_page_context.popBody();
        _jspx_th_ec_005fcolumn_005f0.doCatch(_jspx_exception);
      } finally {
        _jspx_th_ec_005fcolumn_005f0.doFinally();
      }
    } finally {
      _005fjspx_005ftagPool_005fec_005fcolumn_0026_005fwidth_005fviewsAllowed_005fvalue_005fstyle_005fheaderCell_005fcell_005falias_005fnobody.reuse(_jspx_th_ec_005fcolumn_005f0);
    }
    return false;
  }
}
