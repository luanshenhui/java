<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="false" errorPage="/page/h4c2/error"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.dpn.com.cn/dpn" prefix="dpn"%>
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@ include file="/WEB-INF/jsp/meta.jsp" %>
    <title>电脑版</title>
    <%@ include file="/WEB-INF/jsp/style.jsp" %>
    <style type="text/css">
        div.dpn-content div.welcome
        {
            width         : 1000px;
            margin-top    : 0px;
            margin-right  : auto;
            margin-bottom : 0px;
            margin-left   : auto;
            padding-left  : 0px;
            text-align    : left;
        }
    </style>
    <script type="text/javascript">
        
    </script>
</head>
<body>
    <!-- **** head ********************************************************* -->
    <%@ include file="/WEB-INF/jsp/head.jsp" %>
    <!-- **** menu ********************************************************* -->
    <%@ include file="/WEB-INF/jsp/menu.jsp" %>
    <!-- **** content ****************************************************** -->
    <div id="dpn-content" style="width:1200px;height:750px" class="dpn-content">
        <c:if test="${not empty targetUrl }">
        	<iframe id="content_frame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${targetUrl }"></iframe>
        </c:if>
        <c:if test="${empty targetUrl }">
        	<div id="crumb" class="crumb">当前位置&nbsp;:&nbsp;系统首页</div>
        	<div id="welcome" class="welcome">
	            <img src="<dpn:path path="/static/dec/images/dpn.welcome.jpg" />" />
	        </div>
        	<iframe id="content_frame" scrolling="auto" frameborder="0" width="100%" height="100%"></iframe>
        </c:if>
    </div>

    <!-- **** javascript *************************************************** -->
    <script type="text/javascript">
        function changeContent(targetUrl){
            $("input[id^='parameter_']").val("");
            if (!targetUrl) {
                return;
            }
            if (targetUrl.indexOf('?') >= 0) {
                targetUrl += "&";
            } else {
                targetUrl += "?";
            }
            targetUrl += "a" + Math.floor(Math.random() * 100000) + "=" + Math.floor(Math.random() * 100000);
        	jQuery("#content_frame").attr("src", targetUrl);
        	jQuery("#crumb").hide();
        	jQuery("#welcome").hide();
        }
        
        jQuery(function(){
            changeContent("");
        });
    </script>
    <!-- **** foot ********************************************************* -->
    <%@ include file="/WEB-INF/jsp/foot.jsp" %>
</body>
</html>
