package org.apache.jsp.web;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

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
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\r');
      out.write('\n');

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("<base href=\"");
      out.print(basePath);
      out.write("\">\r\n");
      out.write("<!-- 标题在这里设定 -->\r\n");
      out.write("<title>\r\n");
      out.write("登陆界面\r\n");
      out.write("</title>\r\n");
      out.write("<link rel=\"stylesheet\" rev=\"stylesheet\" href=\"web/css/style.css\" type=\"text/css\" />\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body bgcolor=\"#cccccc\">\r\n");
      out.write("\r\n");
      out.write("\t<div id=\"bodyDiv\">\r\n");
      out.write("\t\t<div id=\"headerLink\">\r\n");
      out.write("\t\t\t<!-- 页眉的上部链接部分 -->\r\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/web/page/branch/headerLink.jsp", out, false);
      out.write(" \r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<div id=\"header\">\r\n");
      out.write("\t\t\t<!-- 页眉 -->\r\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/web/page/branch/header.jsp", out, false);
      out.write(" \r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<div id=\"menubarBlank\">\r\n");
      out.write("\t\t\t<!-- 横向菜单栏下部的粉红留空区域 -->\r\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/web/page/branch/menubarBlank.jsp", out, false);
      out.write(" \r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<div id=\"content\">\r\n");
      out.write("\t\t\t<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\" height=\"100%\" style=\"table-layout:fixed;word-wrap:break-word;word-break;break-all;\">\r\n");
      out.write("\t\t\t\t<tr>\t\r\n");
      out.write("\t\t\t\t\t<td valign=\"top\">\r\n");
      out.write("\t\t\t\t\t\t<!-- 内容区域 -->\t\r\n");
      out.write("\t\t\t\t\t\t<div id=\"conceptDiv\">\t\t\r\n");
      out.write("\t\t\t\t\t\t\t\r\n");
      out.write("\r\n");
      out.write("<div class=\"conceptBlockTitle\">\r\n");
      out.write("\t<img src=\"/erp/web/img/start.gif\"/>&nbsp;登陆系统\r\n");
      out.write("\t\r\n");
      out.write("\t");
 if (request.getAttribute("login_error") != null) { 
      out.write("\r\n");
      out.write("\t\t<font color=\"red\">");
      out.print(request.getAttribute("login_error"));
      out.write("</font>\r\n");
      out.write("\t");
 } 
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("\t");
 if (request.getAttribute("success") != null) { 
      out.write("\r\n");
      out.write("\t\t<b>");
      out.print(request.getAttribute("success"));
      out.write("</b>\r\n");
      out.write("\t");
 } 
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("<div class=\"conceptBlockConcept\">\r\n");
      out.write("\r\n");
      out.write("\t\t<table border=\"0\" width=100% height=100%>\r\n");
      out.write("\t\t\t<tr>\r\n");
      out.write("\t\t\t\t<td valign=\"middle\">\r\n");
      out.write("\t\t\t\t<form action=\"/erp/login\" method=\"post\" onsubmit=\"return check()\">\r\n");
      out.write("\t\t\t\t\t<table class=\"block\" cellspacing=\"1\" cellpadding=\"0\"\r\n");
      out.write("\t\t\t\t\t\tbgcolor=\"#f7f7f7\" align=\"center\">\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"30\">\r\n");
      out.write("\t\t\t\t\t\t\t<td colspan=\"4\" bgcolor=\"#d6e0ef\">&nbsp;<font face=webdings\r\n");
      out.write("\t\t\t\t\t\t\t\tcolor=#ff8c00>8</font><b>&nbsp;欢迎登录本系统</b></td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"20\">\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" width=\"200\" align=\"right\"></td>\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" align=\"left\">\r\n");
      out.write("\t\t\t\t\t\t\t<div id=\"msg\">\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t\t</div>\r\n");
      out.write("\t\t\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"40\">\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" width=\"200\" align=\"right\">用户名</td>\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" align=\"left\"><input id=\"username\" type=\"text\"\r\n");
      out.write("\t\t\t\t\t\t\t\tname=\"username\" size=\"16\" maxlength=\"16\"\r\n");
      out.write("\t\t\t\t\t\t\t\tonfocus=\"this.style.backgroundColor='#e6e6e6'\"\r\n");
      out.write("\t\t\t\t\t\t\t\tonblur=\"this.style.backgroundColor='#ffffff'\" /> <font color=red>&nbsp;(必填)</font>\r\n");
      out.write("\t\t\t\t\t\t\t<span id=\"nameMsg\" class=\"feedbackHide\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\r\n");
      out.write("\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\r\n");
      out.write("\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"40\">\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" width=\"200\" align=\"right\">密码</td>\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" align=\"left\"><input id=\"password\" type=\"password\"\r\n");
      out.write("\t\t\t\t\t\t\t\tname=\"password\" size=\"16\" maxlength=\"16\"\r\n");
      out.write("\t\t\t\t\t\t\t\tonfocus=\"this.style.backgroundColor='#e6e6e6'\"\r\n");
      out.write("\t\t\t\t\t\t\t\tonblur=\"this.style.backgroundColor='#ffffff'\" /> <font color=red>&nbsp;(必填)</font>\r\n");
      out.write("\t\t\t\t\t\t\t<span id=\"pswdMsg\" class=\"feedbackHide\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\r\n");
      out.write("\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\r\n");
      out.write("\t\t\t\t\t\t\t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\r\n");
      out.write("\t\t\t\t\t\t\t</span></td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"40\">\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" width=\"200\" align=\"right\"></td>\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" align=\"left\"><input type=\"submit\" value=\"登录系统\" /></td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t<tr height=\"40\">\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" width=\"200\" align=\"right\"></td>\r\n");
      out.write("\t\t\t\t\t\t\t<td bgcolor=\"#f7f7f7\" align=\"left\">如无用户点击<a\r\n");
      out.write("\t\t\t\t\t\t\t\thref='web/register.jsp'>这里</a>注册</td>\r\n");
      out.write("\t\t\t\t\t\t</tr>\r\n");
      out.write("\t\t\t\t\t</table>\r\n");
      out.write("\t\t\t\t\t<br />\r\n");
      out.write("\t\t\t\t</form></td>\r\n");
      out.write("\t\t\t</tr>\r\n");
      out.write("\t\t</table>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\t\t\t\t\t\t</div>\t\t\r\n");
      out.write("\t\t\t\t\t</td>\r\n");
      out.write("\t\t\t\t</tr>\r\n");
      out.write("\t\t\t</table>\r\n");
      out.write("\t\t</div>\r\n");
      out.write("\t\t<div id=\"footer\">\r\n");
      out.write("\t\t\t<!-- 页脚 -->\r\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "/web/page/branch/footer.jsp", out, false);
      out.write(" \r\n");
      out.write("\t\t</div>\t\t\r\n");
      out.write("\t</div>\r\n");
      out.write("\t\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
