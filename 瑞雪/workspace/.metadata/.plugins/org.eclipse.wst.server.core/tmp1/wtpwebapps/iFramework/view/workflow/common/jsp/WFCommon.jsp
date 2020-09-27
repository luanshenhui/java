<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/struts-bean.tld" prefix="bean"%>


<%
	String webpath = request.getContextPath();
	String userLang = "zh";
%>
<script type="text/javascript">
	//定义js全局变量WEB_CTX_PATH 
	var webpath = "<%=webpath%>";
  
	
</script>

<link rel="stylesheet" type="text/css" href="<%=webpath%>/view/common/css/style2013/Style.css"/>

<%-- 引入jQuery文件 --%>
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery-1.10.2.min.js"></script>
 
<script type="text/javascript">
	var jQuery = $;
	var $jQuery = $;
</script>
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="<%=webpath%>/view/common/scripts/js/jquery.validate.ext.js"></script>


<script type="text/javascript" Charset="UTF-8" src="<%=webpath%>/view/workflow/common/script/js/WFCommon.js"></script>

