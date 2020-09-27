<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%request.setCharacterEncoding("utf-8"); %>
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
<style type = "text/css">
		body{
			font-family:Arial;
			font-size:12pt;
			color:#FFE6CC;
			
		}
		#wholepage{
			background: url(img/log1.jpg) no-repeat 17% ;
		}
		.diary{
			padding-top:100pt;
			margin-left:60px;
			padding-left:100pt;
			font-size:15pt;
		}
		.button {
			font: 20px Arial, Helvetica, sans-serif;
			font-weight:bold;
			padding: 0 6px;
			color:#FA4588;
			background: url() no-repeat 50% 50%;
			/*for Mozilla*/
			outline: 3px solid #9999FF;
			border: 2px solid #FFFFFF !important;
			height: 37px !important;
			line-height: 22px !important;
		}
		#page{
			margin: 100px 0px;
			margin-left:160px;
			color:#FFFF99;
			font-size:15px;
		}
		.tr_1{
		font-size:17px;
		font-weight:bold;
		}
		.tiao{
		font-size:15pt;
		font-weight:bold;
		color:#CCE6FF;
		padding:0 5pt;
		}
		a:link {
		font-size: 18px;
		color: #98B9FF;
		text-decoration: none;
		font-weight: bold;
		}
		a:visited {
			font-size: 18px;
			color: #CCCCFF;
			text-decoration: none;
		}
		a:hover {
			font-size: 20px;
			color:#FA4588;
			text-decoration: none;
		}
		a:active {
			font-size: 18px;
			color: #FF0000;
			text-decoration: none;
		}
			#div_head{
			font-size:12pt;
			text-decoration:underline;
			color:#CCE6FF;
			margin-left:10pt;
			margin-top: -50pt;
		}
	</style>
	<script type="text/javascript" src="js/ajax.js"></script>
	<script type="text/javascript" src="js/json2.js"></script>
	<script type="text/javascript" src="js/jquery-1.4.3.js"></script>
	<script type="text/javascript">
	function toWrite(){
	location.href = "writelog.jsp";
	}
	function jump(){
	var pageIndex = document.getElementById("pageIndex");
	var pi = pageIndex.value-1;
	location.href = "log?pageIndex="+pi+"&pageSize=5";
	}
	</script>
  </head>
  <body onload="loadDiary();">
<div>
			<%@include file="plugin/head.jsp"%><br/>
		</div>
		<div id="wholepage">
   	<div class="diary">
   	<div id="div_head">日志</div>
	 		<table  cellSpacing=5px cellPadding=3px width="80%">
	 			<tbody>
	 			<tr>
	 				<td colspan="2" align="left"><SPAN style="font-size:20px;color:#CCE6FF;font-weight: bold;">文章列表</SPAN></td>
	 				<td>&nbsp;</td>
	 				<td>&nbsp;</td>
	 				<td><input class="button" type="submit" value="写日志" name="writeLog"
	 								onclick="toWrite();"/></td>
	 			</tr>
	 			<tr><td colspan="5"><hr/></td></tr>
	  			<tr style="font-size:14pt;color:#CCE6FF">
	  				<td><b>序号</b></td>
	  				<td><b>日志标题</b></td>
	  				<td><b>日期</b></td>
	  				<td>&nbsp;</td>
	  				<td>&nbsp;</td>
	  				<td>&nbsp;</td>
	  			</tr>
	  			<c:if test="${empty friend}">
	  			<c:forEach var="dia" items="${diarys}">
	  			<tr>
	  			<td></td><td><a href = "readLog?id=${dia.diaryID}">${dia.diaryTitle}</a></td><td>${dia.diaryDate}</td><td></td><td><a href = "sendToUpdate?id=${dia.diaryID}">修改</a></td><td><a href = "deleteLog?id=${dia.diaryID}">删除</a></td>	  			
	  			</tr>
	  			</c:forEach>
	  			</c:if>
	  			<c:if test="${!empty friend}">
	  			<c:forEach var="dia" items="${diarys}">
	  			<tr>
	  			<td></td><td><a href = "readLog?id=${dia.diaryID}">${dia.diaryTitle}</a></td><td>${dia.diaryDate}</td><td></td><td><a href = ""></a></td><td></td>	  			
	  			</tr>
	  			</c:forEach>
	  			</c:if>
	  			</tbody>
	  			<!-- </table>
	  			<table  cellSpacing=5px cellPadding=3px width="80%" id = "table">
	  			  <tbody id = "tb">
				  </tbody> -->
			</table>
		
		</div>
				<div id="page">
			<table width="80%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		        <td width="15" height="29"></td>
		        <td background="url()">
		    <table width="80%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
            	<td width="25%" height="29" nowrap="nowrap" style="font-size:15pt;"><span style="color:#98B9FF;font-weight:bold;">共<span style="color:#98B9FF;font-weight:bold;">${all}</span>条纪录，当前第<span style="color:#98B9FF;font-weight:bold;">${page+1}</span>/<span style="color:#98B9FF;font-weight:bold;">${s}</span>页，每页<span style="color:#98B9FF;font-weight:bold;">5</span>条纪录</span></td>
            	<td width="75%" valign="top" class="STYLE1"><div align="right">
          <table width="552" height="20" border="0" cellpadding="0" cellspacing="0">
            <tr class="tiao">
            <td width="60px" height="22" valign="middle"><div align="right"><a href = "log?pageIndex=0&pageSize=5">首页</a></div></td>
            <c:if test="${page==0}"><td width="60px" height="22" valign="middle"><div align="right">上一页</div></td></c:if>
            <c:if test="${!(page==0)}">
            <td width="60px" height="22" valign="middle"><div align="right"><a href = "log?pageIndex=${page-1}&pageSize=5">上一页</a></div></td>
            </c:if>
            <c:if test="${page==(s-1)}">
                <td width="60px" height="22" valign="middle"><div align="right">下一页</div></td>
            </c:if> 
            <c:if test="${!(page==(s-1))}">
              <td width="60px" height="22" valign="middle"><div align="right"><a href = "log?pageIndex=${page+1}&pageSize=5">下一页</a></div></td>
              </c:if> 
              <td width="60px" height="22" valign="middle"><div align="right"><a href = "log?pageIndex=${s-1}&pageSize=5">尾页</a></div></td>
              <td width="60px" height="22" valign="middle"><div align="right"class="STYLE1" style="font-size:15pt;color:#98B9FF;font-weight: bold;">转到第</div></td>
              <td width="60px" height="22" valign="middle">
                <input id = "pageIndex" type="text" style="height:15px; width:20px;" size="5" /><span style="color:#98B9FF">页</span>
                <a href="javascript:;" onclick="jump();">转</a>
              </td>
            	</tr>
            </table>
	        </div></td>
	          </tr>
	        </table></td>
	        <td width="30px">&nbsp;</td>
	      </tr>
	    </table>
		</div>	
			<div>
				<%@include file="plugin/foot.jsp"%>
			</div>
		</div>
  </body>
</html>
