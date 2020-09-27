package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.dhc.base.common.consts.CommonConsts;
import com.dhc.organization.config.OrgI18nConsts;
import com.dhc.base.security.SecurityUserHoder;
import com.dhc.base.security.SecurityUser;
import org.springframework.security.context.SecurityContextHolder;
import com.dhc.base.common.util.SystemConfig;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(1);
    _jspx_dependants.add("/WEB-INF/tld/struts-bean.tld");
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
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
      			null, true, 8192, true);
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
      out.write("\r\n");

	// 获得应用上下文
	String webpath = request.getContextPath();
	String user = SecurityUserHoder.getCurrentUser().getUsername();
	String system_title = SystemConfig.getSystemTitle();
	String system_short_title = SystemConfig.getSystemShortTitle();

      out.write("\r\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
      out.write("<head>\r\n");
      out.write("\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">\r\n");
      out.write("\t<meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\" />\r\n");
      out.write("\r\n");
      out.write("\t<METAHTTP-EQUIV=\"Pragma\"CONTENT=\"no-cache\">\r\n");
      out.write("\t<METAHTTP-EQUIV=\"Cache-Control\"CONTENT=\"no-cache\">\r\n");
      out.write("\t<METAHTTP-EQUIV=\"Expires\"CONTENT=\"0\">\r\n");
      out.write("\t<title>");
      out.print(system_title );
      out.write("</title>\r\n");
      out.write("\t<!-- <title>TSD系统主页面</title>-->\r\n");
      out.write("\t");
      out.write("\t\r\n");
      out.write("\t<link href=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/main.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
      out.write("\t<link href=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/skin.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
      out.write("\t<!--[if IE 6]>\r\n");
      out.write("\t<script src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/DD_belatedPNG.js\" type=\"text/javascript\"></script>    \r\n");
      out.write("\t\t<script>\r\n");
      out.write("\t\t\tDD_belatedPNG.fix('.png,img');\r\n");
      out.write("\t\t</script>\r\n");
      out.write("    <![endif]-->\r\n");
      out.write("\t");
      out.write("\r\n");
      out.write(" \t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/scripts/jquery-1.4.2.min.js\"></script>\r\n");
      out.write(" \t");
      out.write("\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jquery.tree.js\"></script>\r\n");
      out.write("\t<link href=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/tree/jquery.tree.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
      out.write("\t");
      out.write("\t\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/indexSize.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/consts_");
      out.print(CommonConsts.LANGUAGE);
      out.write(".js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/menu.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/updatePassword.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/index.js\"></script>\r\n");
      out.write("\t\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jquery.bgiframe-2.1.1.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.core.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\"\r\n");
      out.write("\t\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery-ui-1.8.1.custom.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\"\r\n");
      out.write("\t\tsrc=\"");
      out.print(webpath);
      out.write("/view/base/plugin/jqueryui/jquery.ui.dialog.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.widget.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.mouse.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.draggable.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.position.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.resizable.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.dialog.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/ui/minified/jquery.ui.sortable.min.js\"></script>\r\n");
      out.write("\t<script type=\"text/javascript\">\r\n");
      out.write("\t\tvar BUTTON_SAVE = \"");
      out.print(CommonConsts.BUTTON_SAVE);
      out.write("\";\r\n");
      out.write("\t\tvar BUTTON_CLOSE = \"");
      out.print(CommonConsts.BUTTON_CLOSE);
      out.write("\";\r\n");
      out.write("\t\tvar MESSAGE_BOX = \"");
      out.print(OrgI18nConsts.MESSAGE_BOX);
      out.write("\";\r\n");
      out.write("\t\tvar BUTTON_OK = \"");
      out.print(CommonConsts.BUTTON_OK);
      out.write("\";\r\n");
      out.write("\t\tvar CONFIRM_BOX = \"");
      out.print(OrgI18nConsts.CONFIRM_BOX);
      out.write("\";\r\n");
      out.write("\t\tvar BUTTON_CANCEL = \"");
      out.print(CommonConsts.BUTTON_CANCEL);
      out.write("\";\r\n");
      out.write("\t</script>\r\n");
      out.write("\t<script src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/page.set.js\"></script>\r\n");
      out.write("<style>\r\n");
      out.write("html,body{height:100%}\r\n");
      out.write(".addFavMenu{position:absolute;right:22px;top:124px; height:18px; width:90px;text-align:center;}\r\n");
      out.write("</style>\r\n");
      out.write("<style type=\"text/css\">\r\n");
      out.write("\t#sortableFav { list-style-type: none; margin: 0; padding: 0; width: 80%; }\r\n");
      out.write("\t#sortableFav li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }\r\n");
      out.write("\t#sortableFav li span { position: absolute; margin-left: -1.3em; }\r\n");
      out.write("\t</style>\r\n");
      out.write("<style type=\"text/css\">\r\n");
      out.write("\t\tbody { font-size: 62.5%; }\r\n");
      out.write("\t\tlabel, input { display:block; }\r\n");
      out.write("\t\tinput.text { margin-bottom:12px; width:95%; padding: .4em; }\r\n");
      out.write("\t\tfieldset { padding:0; border:0; margin-top:25px; }\r\n");
      out.write("\t\th1 { font-size: 1.2em; margin: .6em 0; }\r\n");
      out.write("\t\tdiv#users-contain { width: 350px; margin: 20px 0; }\r\n");
      out.write("\t\tdiv#users-contain table { margin: 1em 0; border-collapse: collapse; width: 100%; }\r\n");
      out.write("\t\tdiv#users-contain table td, div#users-contain table th { border: 1px solid #eee; padding: .6em 10px; text-align: left; }\r\n");
      out.write("\t\t.ui-dialog .ui-state-error { padding: .3em; }\r\n");
      out.write("\t\t.validateTips { border: 1px solid transparent; padding: 0.3em; }\r\n");
      out.write("\t\t\r\n");
      out.write("\t</style>\r\n");
      out.write("</head>\r\n");
      out.write("<body oncontextmenu=\"self.event.returnValue=false\" >\r\n");
      out.write("<input  id=\"webpath\" value=\"");
      out.print(webpath);
      out.write("\" type=\"hidden\"/>\r\n");
      out.write("<div id=\"container\" >\r\n");
      out.write("<header>\r\n");
      out.write("  <div id=\"header\" class=\"png\" >\r\n");
      out.write("\t<div class=\"logo\"><img src=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/images1009/frame/logo.png\" /></div>\r\n");
      out.write("\t<div class=\"info link_01 png\">\r\n");
      out.write("\t  <ul>\r\n");
      out.write("\t    <li id=\"userShowInfo\"></li>\r\n");
      out.write("\t\t<li><a href=\"#\" id=\"toLogonPage\"></a></li>\r\n");
      out.write("\t\t<li><a href=\"#\" id=\"toChangePassword\"></a></li>\r\n");
      out.write("\t\t<!--<li><a href=\"#\" id=\"toOtherSystem\"></a></li>-->\r\n");
      out.write("\t\t<li><a href=\"#\" id=\"toHelpPage\"></a></li>\r\n");
      out.write("\t  </ul>\r\n");
      out.write("\t</div>\r\n");
      out.write("  </div>\r\n");
      out.write("<div id=\"header_hide\" class=\"png\"></div>\r\n");
      out.write("</header>\r\n");
      out.write("\r\n");
      out.write("<nav>\r\n");
      out.write("  <div id=\"nav\">\r\n");
      out.write("    <ul class=\"menu_tab\" id=\"menuDiv\"></ul>\r\n");
      out.write("\t<div class=\"q_menu png\" id=\"qButtonDiv\">\r\n");
      out.write("\t  <img src=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/images1009/frame/q_menu.png\" />\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div class=\"q_menu_list Shadow png\" id=\"qMenuListDiv\">\r\n");
      out.write("\t  <ul id=\"qMenuDiv\">\r\n");
      out.write("\t    </ul>\r\n");
      out.write("\t</div>\r\n");
      out.write("  </div>\r\n");
      out.write("  <div id=\"nav2\">\r\n");
      out.write("    <ul class=\"menu\">\r\n");
      out.write("       <li><a href=\"#\"></a></li>\r\n");
      out.write("    </ul>\r\n");
      out.write("  </div>  \r\n");
      out.write("  <div id=\"nav_bottom\"></div>\r\n");
      out.write("</nav>\r\n");
      out.write("  <div id=\"mainContent\">\r\n");
      out.write("    <div id=\"sidebar\">    \r\n");
      out.write("\t<div class=\"menu\" id=\"left\">\r\n");
      out.write("\t<input id=\"activeMenuNum\" value=\"0\" type=\"hidden\"/>\r\n");
      out.write("\t </div>\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div class=\"sidebar_hide png\" id=\"left-ar\">\r\n");
      out.write("       <div class=\"arrow2 png\" id=\"leftArrow\"></div>\r\n");
      out.write("\t</div>\r\n");
      out.write("    <div id=\"siteinfo\">\r\n");
      out.write("\t  <div class=\"location\" id=\"navId\">");
      out.print(system_short_title );
      out.write("＞<span>Home</span></div>\r\n");
      out.write("\t  <div class=\"favorite\"><div class=\"back\"  id=\"favMenu\">\r\n");
      out.write("\t  <!--<div class=\"content link_01\"><a href=\"#\" id=\"addFavMenu\">加入收藏</a></div>\r\n");
      out.write("\t  --></div></div>\r\n");
      out.write("\t  <!-- <div class=\"time\">现在时间：2010年9月18日 18:00</div>-->\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div id=\"content\">\r\n");
      out.write("\t  <iframe id=\"centreFrameId\" height=\"100%\" width=\"100%\" frameborder=\"0\" src=\"black.html\"></iframe>\r\n");
      out.write("\t</div>\r\n");
      out.write("  </div>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"passwordDiv\" style=\"display:none\">\r\n");
      out.write("\t<p id=\"error\" class=\"validateTips\" style=\"border:0\"></p>\r\n");
      out.write("\t<form>\r\n");
      out.write("\t<fieldset>\r\n");
      out.write("\t\t<label for=\"oldPassword\">旧密码</label>\r\n");
      out.write("\t\t<input type=\"password\" name=\"oldPassword\" id=\"oldPassword\" class=\"text ui-widget-content ui-corner-all\" />\r\n");
      out.write("\t\t<label for=\"newPassword\">新密码</label>\r\n");
      out.write("\t\t<input type=\"password\" name=\"newPassword\" id=\"newPassword\" value=\"\" class=\"text ui-widget-content ui-corner-all\" />\r\n");
      out.write("\t\t<label for=\"password\">新密码确认</label>\r\n");
      out.write("\t\t<input type=\"password\" name=\"confirm_password\" id=\"confirm_password\" value=\"\" class=\"text ui-widget-content ui-corner-all\" />\r\n");
      out.write("\t</fieldset>\r\n");
      out.write("\t</form>\r\n");
      out.write("\t</div>\r\n");
      out.write("<div id=\"editFavDiv\" style=\"display:none;\">\r\n");
      out.write("\t<ul id=\"sortableFav\"></ul>\r\n");
      out.write("</div>\r\n");
      out.write("<div id=\"logOut\" style=\"display:none\"></div>\r\n");
      out.write("<div style=\"display:none\">\r\n");
      out.write("\t<div id=\"PopupBox_L2\" title=\"hello\" style=\"padding:0px 0px 0px 0px;margin:0;border:0;\">\r\n");
      out.write("\t\t<iframe id=\"PopupBoxIframe_L2\" src=\"\" ></iframe>\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div id=\"PopupBox_L3\" title=\"hello\" style=\"padding:0px 0px 0px 0px;margin:0;border:0;\">\r\n");
      out.write("\t\t<iframe id=\"PopupBoxIframe_L3\" src=\"\" ></iframe>\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div id=\"MessageBox\" title=\"hello\" style=\"padding:0px 0px 0px 0px;margin:0;border:0;\">\r\n");
      out.write("\t\t<iframe id=\"MessageBoxIframe\" src=\"\" ></iframe>\r\n");
      out.write("\t</div>\r\n");
      out.write("</div>\r\n");
      out.write("<input id=\"menuCount\" type=\"hidden\"/>\r\n");
      out.write("<input id=\"targetMenu\" type=\"hidden\"/>\r\n");
      out.write("<input id=\"favEditFlag\" value=\"0\" type=\"hidden\"/>\r\n");
      out.write("<input id=\"topHiddenFlag\" value=\"0\" type=\"hidden\"/>\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
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
}
