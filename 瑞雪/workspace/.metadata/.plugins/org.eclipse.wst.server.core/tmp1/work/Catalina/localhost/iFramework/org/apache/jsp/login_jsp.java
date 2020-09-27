package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.dhc.base.common.consts.CommonConsts;
import com.dhc.base.common.JTConsts;
import com.dhc.base.common.util.SystemConfig;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList(1);
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
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\r\n");
 
session.setAttribute("org.apache.struts.action.LOCALE",new java.util.Locale(CommonConsts.LANGUAGE));
//org.springframework.security.AuthenticationException  ex = (org.springframework.security.AuthenticationException)request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
//out.println(ex.getMessage());

org.springframework.security.AuthenticationException ex =(org.springframework.security.AuthenticationException) request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
String errorMessage = "";
if(ex!=null){	
	//out.println(ex.getMessage());
	request.getSession().removeAttribute("SPRING_SECURITY_LAST_EXCEPTION");
}
String webpath = request.getContextPath();

response.setHeader("Pragma","No-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires",1);
String system_title = SystemConfig.getSystemTitle();

      out.write("\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
      out.write("<head>\r\n");
      out.write("<link href=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/main.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
      out.write("<link href=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/skin.css\" rel=\"stylesheet\" type=\"text/css\" />\r\n");
      out.write("\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\r\n");
      out.write("<meta http-equiv=\"X-UA-Compatible\" content=\"IE=EmulateIE7\" />\r\n");
      out.write("<title>");
      out.print(system_title );
      out.write("</title>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/base/scripts/jquery-1.4.2.min.js\"></script>\r\n");
      out.write("<script src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/validate/jquery.validate.min.js\" type=\"text/javascript\"></script>\r\n");
      out.write("<script src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/login.js\"></script>\r\n");
      out.write("<script type=\"text/javascript\" src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/consts_");
      out.print(CommonConsts.LANGUAGE);
      out.write(".js\"></script>\r\n");
      out.write("<script src=\"");
      out.print(webpath);
      out.write("/view/base/plugin/page.set.js\"></script>\r\n");
      out.write("<!--[if lte IE 6]>\r\n");
      out.write("<script src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/DD_belatedPNG.js\" type=\"text/javascript\"></script>\r\n");
      out.write("<script>\t\r\n");
      out.write("  DD_belatedPNG.fix('.png,img');\r\n");
      out.write("</script>\r\n");
      out.write("<![endif]-->\r\n");
      out.write("\r\n");
      out.write("<style>\r\n");
      out.write("body,html { height:100%; text-align:center;}\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("</style>\r\n");
      out.write("\r\n");
      out.write("</head>\r\n");
      out.write("<input  id=\"webpath\" value=\"");
      out.print(webpath);
      out.write("\" type=\"hidden\"/>\r\n");
      out.write("<body class=\"login_body\"  onload=\"checkParent();belatedPNG();\" sroll=\"auto\">\r\n");
      out.write("\r\n");
      out.write("<form action=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (PageContext)_jspx_page_context, null, false));
      out.write("/j_spring_security_check\" onsubmit=\"javascript:return requiredCheck();\" id=\"loginForm\">\r\n");
      out.write("<div id=\"website_logo\"><img src=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/images1009/login/website_logo.jpg\" /></div>\r\n");
      out.write("\r\n");
      out.write("<div id=\"login\" class=\"png\">\r\n");
      out.write("<dl>\r\n");
      out.write("<dt>");
      if (_jspx_meth_bean_005fmessage_005f0(_jspx_page_context))
        return;
      out.write("：</dt><dd><input name=\"j_username\" title=\"");
      if (_jspx_meth_bean_005fmessage_005f1(_jspx_page_context))
        return;
      out.write("\" type=\"text\" class=\"input_out\" id=\"inp_name\" value=\"\" />\r\n");
      out.write("</dd>\r\n");
      out.write("<dt>");
      if (_jspx_meth_bean_005fmessage_005f2(_jspx_page_context))
        return;
      out.write("：</dt><dd><input name=\"j_password\" title=\"");
      if (_jspx_meth_bean_005fmessage_005f3(_jspx_page_context))
        return;
      out.write("\" type=\"password\" class=\"input_out\" id=\"inp_pw\" value=\"\" /></dd>\r\n");
      out.write("</dl>\r\n");
      out.write("<div class=\"err png\" id=\"errContainer\" style=\"display: none;\">\t\r\n");
      out.write("\t<ol>\r\n");
      out.write("\t\t<label for=\"j_username\" class=\"error\"></label>\r\n");
      out.write("\t\t<label for=\"j_password\" class=\"error\"></label>\r\n");
      out.write("\t</ol>\r\n");
      out.write("</div>\r\n");
      out.write("<div class=\"button png\"><input type=\"image\"  name=\"imgBtn\" src=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/images1009/login/login_button.png\" /></div>\r\n");
      out.write("<div class=\"title png\"><img src=\"");
      out.print(webpath);
      out.write("/view/base/theme/css/redmond/images1009/login/login_title.png\" /></div>\r\n");
      out.write("<div class=\"login_copyright\">Copyright © 2001-2011 DHC Corporation</div>\r\n");
      out.write("</div>\r\n");
      out.write("<input   type= \"submit \"   id= \"submit \"   style= \"display:none; \" > \r\n");
      out.write("<div id=\"login_hide\"></div>\r\n");
      out.write("<!--[if lte IE 6]>\r\n");
      out.write("<script src=\"");
      out.print(webpath);
      out.write("/view/mainframe/scripts/DD_belatedPNG.js\" type=\"text/javascript\"></script>\r\n");
      out.write("<![endif]-->\r\n");
      out.write("\r\n");
      out.write("</form>\r\n");
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

  private boolean _jspx_meth_bean_005fmessage_005f0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  bean:message
    org.apache.struts.taglib.bean.MessageTag _jspx_th_bean_005fmessage_005f0 = (org.apache.struts.taglib.bean.MessageTag) _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.get(org.apache.struts.taglib.bean.MessageTag.class);
    try {
      _jspx_th_bean_005fmessage_005f0.setPageContext(_jspx_page_context);
      _jspx_th_bean_005fmessage_005f0.setParent(null);
      // /login.jsp(60,4) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f0.setKey("iframework.label.username");
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
      // /login.jsp(60,93) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f1.setKey("iframework.message.missing_username");
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
      // /login.jsp(62,4) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f2.setKey("iframework.label.password");
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
      // /login.jsp(62,93) name = key type = null reqTime = true required = false fragment = false deferredValue = false expectedTypeName = null deferredMethod = false methodSignature = null
      _jspx_th_bean_005fmessage_005f3.setKey("iframework.message.missing_password");
      int _jspx_eval_bean_005fmessage_005f3 = _jspx_th_bean_005fmessage_005f3.doStartTag();
      if (_jspx_th_bean_005fmessage_005f3.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
        return true;
      }
    } finally {
      _005fjspx_005ftagPool_005fbean_005fmessage_0026_005fkey_005fnobody.reuse(_jspx_th_bean_005fmessage_005f3);
    }
    return false;
  }
}
