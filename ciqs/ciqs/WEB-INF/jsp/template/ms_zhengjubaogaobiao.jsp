<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>证据报告表</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css">
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css">
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css">
<style type="text/css">
body div{
   width:1000px;
   margin: 5px auto;
}
.tableheadLine {
	border: 1px solid #000;
	font-weight:bold;
}
div{
   overflow:auto;
   font-size: 22px;
}
.chatTitle{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
}
.littleTitle{
	text-align: center;
    font-size: 20px;
    font-weight: 300;
   
}
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
</style>
</head>
<body>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<div>
	<div class="chatTitle">证据报告表</div>
	<div class="basicInformation">
		
		<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
			<tr>
				<td height="44" width="980"  align="center" class="tableheadLine"  colspan="8">
											证据报告表<br/>
						证据报告表用于支持船舶卫生证书，列明所发现证据和所采取控制措施<br/>
						当作为SSC附件时，此表的每页都应经检验检疫机构签字、盖章和标注日期。<br/>
						如果此表作为已签发SSC的附件，应在SSC中以加盖“见附件”印章等方式注明。<br/>
					
				</td>
			</tr>
			<tr>
				<td height="44" width="490"  align="left" class="tableheadLine"  colspan="4">
						船名、国际海事组织（IMO）号或注册号：<br/>
					
				</td>
				<td height="44" width="490"  align="left" class="tableheadLine"  colspan="4">
						船长姓名和签字：<br/>
					
				</td>
			</tr>
				<tr>
				<td height="44" width="490"  align="left" class="tableheadLine"  colspan="4">
						签发机关：<br/>
					
				</td>
				<td height="44" width="490"  align="left" class="tableheadLine"  colspan="4">
						签发机关：实际检查日期（dd/mm/yyyy）：<br/>
				</td>
			</tr>
				<tr>
				<td height="44" width="490"  align="left" class="tableheadLine"  colspan="4">
						所涉及船舶卫生证书（SSC）签发日期（dd/mm/yyyy）：<br/>
					
				</td>
				<td height="44" width="490"  align="left" class="tableheadLine"  colspan="4">
						所涉及船舶卫生证书（SSC）签发港：<br/>
					
				</td>
			</tr>
			<tr>
				<td height="44" width="980"  align="left" class="tableheadLine"  colspan="8">
						标明没有检查的区域：<br/>
					<input type="checkbox"/>宿舱 <input type="checkbox"/>厨房、配餐间和服务区 <input type="checkbox"/>库房 <input type="checkbox"/>保育设施<br/>
					<input type="checkbox"/>医疗设施<input type="checkbox"/>游泳池或水疗间<input type="checkbox"/>固体废物和医疗废物<input type="checkbox"/>轮机舱<br/>
					<input type="checkbox"/>饮用水<input type="checkbox"/>污水<input type="checkbox"/>压舱水<input type="checkbox"/>货舱<br/>
					<input type="checkbox"/>其它（如洗衣房和洗衣机）
					   
			</td>
				
			</tr>
			<tr>
				<td height="44"   align="left" class="tableheadLine"  >
				证据代码
				</td>
				<td height="44"   align="left" class="tableheadLine"  colspan="3" >
				发现的证据(按照WHO检查列表简要描述）
				</td>
			
				<td height="44"   align="left" class="tableheadLine"  >
				强制
				</td>
			
				<td height="44"   align="left" class="tableheadLine" >
				推荐
				</td>
			
				<td height="44"   align="left" class="tableheadLine" >
				采取的措施
				</td>
			
				<td height="44"   align="left" class="tableheadLine" >
				措施有效实施（复查机关盖章和签字）
				</td>
			</tr>
			<tr>
				<td height="44"   align="left" class="tableheadLine" colspan="8" >
				
				</td>
			</tr>
			<tr>
				<td height="44"   align="left" class="tableheadLine"  >
				
				</td>
				<td height="44"   align="left" class="tableheadLine"  colspan="3" >
				
				</td>
			
				<td height="44"   align="left" class="tableheadLine"  >
			
				</td>
			
				<td height="44"   align="left" class="tableheadLine" >
				
				</td>
			
				<td height="44"   align="left" class="tableheadLine" >
				
				</td>
			
				<td height="44"   align="left" class="tableheadLine" >
				
				</td>
			</tr>
			<tr>
				<td height="44"   align="left" class="tableheadLine"  colspan="2">
					签发官员姓名：
				</td>
				<td height="44"   align="left" class="tableheadLine"  colspan="2" >
					签发官员签名：
				</td>
				<td height="44"   align="left" class="tableheadLine"  colspan="2" >
					签发机构盖章：
				</td>
				<td height="44"   align="left" class="tableheadLine"  colspan="2" >
				第页<br/>
				总页数：
				</td>
			</tr>
		</table>	
	</div>
	   <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>	
</body>
</html>
