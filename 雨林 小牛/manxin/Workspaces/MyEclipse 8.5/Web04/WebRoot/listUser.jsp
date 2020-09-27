<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html >
<head>
<title>搜索</title>
<style type="text/css">
#div1{
margin-right: 100px;
}
#ftable{
				float: left;
				display: block;
				margin-left:200px;
				width:650px;
				text-align:left;
				padding: 0 10px;
				font-size: 20px;
				font-weight: bold;
				text-decoration: none;
				color: #b4b5ff;
		}
		a:HOVER {
		color: #bbfffd;
}
</style>
</head>
<body>
<%@include file="plugin/head.jsp" %>
 <table id="ftable" border=0 cellSpacing=2px cellPadding=2px width="100%">
    			<tr><td colspan="5" style="font-size:20px;">搜索结果</td></tr>
    			<tr><td width="100px">
    		<a href="gomain.do?fid=">

								<img id="image" width="80px" height="88px" src="upload/none.jpg"/><br/>
				
								<img id="image" width="80px" height="88px" src="upload/pic/"/>
				
    			</a>
    			</td>
    			<td width="100px">mingzi </td>
    			<td width="100px">xingbie</td>
    			<td width="100px">dizhi</td>
    				
    					<td width="100px">离线</td>
    					
    					<td width="100px" style="color:#ffff34; ">在线</td>
    					<td width="100px" style="color:red;">冻结</td>
    		
    			</tr>
    			<tr><td colspan="5">-------------------------------------------------------------</td></tr>
    		
    </table>
<div id="div1">
<%@include file="plugin/foot.jsp" %>
</div>
</body>
</html>

