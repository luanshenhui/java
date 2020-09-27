<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>检疫处理报告单</title>
<%@ include file="/common/resource_show.jsp"%>
<style type="text/css">
<!--
.tableLine {
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
	padding-left: 3px;
	padding-right: 3px;
}
.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px; 
}
.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}
.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}

.title a:link, a:visited {
	    color:white;
	    text-decoration: none;
	    }
</style>
</head>
<body  class="bg-gary">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">检疫处理报告单</span></a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="blank_div_dtl">
</div>
<div class="margin-auto width-1200  data-box">
<div><h1 style="margin-left:366px;font-size: 208%">检疫处理报告单</h1>
	  <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
    	 <tr>
              <td width="167" height="44" colspan="2" align="left" class="tableLine">报检号：</td>
              <td width="167" colspan="2" align="left" class="tableLine" >申请单位：</td>
     	 </tr>
      	 <tr>
              <td width="167" height="44" colspan="2" align="left" class="tableLine">联系人：</td>
              <td width="167" colspan="2" align="left" class="tableLine" >联系电话：</td>
     	 </tr>
     	 <tr>
              <td width="167" height="44" colspan="4" align="left" class="tableLine">检疫处理实施单位：</td>
     	 </tr>
     	 <tr>
              <td width="167" height="44" colspan="4" align="center" class="tableLine">检疫处理对象：</td>
     	 </tr>
     	 <tr>
              <td width="60" height="44" colspan="1" align="left" class="tableLine">对象名称：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
              <td width="60" colspan="1" align="left" class="tableLine" >货物名称：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
     	 </tr>
     	 <tr>
              <td width="60" height="44" colspan="1" align="left" class="tableLine">对象标识：</td>
              <td width="107" height="44" colspan="3" align="left" class="tableLine"></td>
     	 </tr>
     	 <tr>
              <td width="60" height="44" colspan="1" align="left" class="tableLine">对象规格/数量：</td>
              <td width="107" height="44" colspan="3" align="left" class="tableLine"></td>
     	 </tr>
     	  <tr>
              <td width="60" height="44" colspan="1" align="left" class="tableLine">处理范围：</td>
              <td width="107" height="44" colspan="3" align="left" class="tableLine"></td>
     	 </tr>
     	  <tr>
              <td width="60" height="74" colspan="1" align="left" class="tableLine">备注：</td>
              <td width="107" height="74" colspan="3" align="left" class="tableLine"></td>
     	 </tr>
     	  <tr>
              <td width="167" height="44" colspan="4" align="center" class="tableLine">处理情况：</td>
     	 </tr>
     	 <tr>
     	  	  <td width="60" height="44" colspan="1" align="left" class="tableLine">处理方式：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
              <td width="60" colspan="1" align="left" class="tableLine" >使用药品：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
     	 </tr>
     	  <tr>
     	  	  <td width="60" height="44" colspan="1" align="left" class="tableLine">使用浓度剂量：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
              <td width="60" colspan="1" align="left" class="tableLine" >稀释比：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
     	 </tr>
		 <tr>
     	  	  <td width="60" height="44" colspan="1" align="left" class="tableLine">总用药量：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
              <td width="60" colspan="1" align="left" class="tableLine" >作用时间：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
     	 </tr>
     	  <tr>
     	  	  <td width="60" height="44" colspan="1" align="left" class="tableLine">作业人员：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
              <td width="60" colspan="1" align="left" class="tableLine" >实施地点：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine"></td>
     	 </tr>
 		<tr>
              <td width="60" height="44" colspan="1" align="left" class="tableLine">作业时间：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine_noright">开始：</td>
              <td width="167" height="44" colspan="2" align="left" class="tableLine_noleft">结束：</td>
     	 </tr>
     	 <tr>
              <td width="60" height="44" colspan="1" align="left" class="tableLine">作业条件：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine_noright">温度：</td>
              <td width="60" height="44" colspan="1" align="left" >湿度：</td>
              <td width="107" height="44" colspan="1" align="left" class="tableLine_noleft">风速：</td>
     	 </tr>
 		<tr>
              <td width="167" height="194" colspan="4" align="left">处理结果：</td>
     	 </tr>
     	 <tr>
              <td width="107" height="44" colspan="2" align="left" >作业部门负责人签字：</td>
              <td width="167" height="44" colspan="2" align="left" >盖章：</td>
     	 </tr>
 		<tr>
              <td width="107" height="44" colspan="1" align="left" class="tableLine_noright">报告人：</td>
              <td width="60" height="44" colspan="1" align="left" >签发人：</td>
              <td width="107" height="44" colspan="2" align="left" class="tableLine_noleft">签发日期：</td>
     	 </tr>
      </table>
    </div> 
     <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>
</body>
</html>
