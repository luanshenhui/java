<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>船舶卫生监督登记表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div{
   width:1000px;
   margin: 5px auto;
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
	<div class="chatTitle">船舶卫生监督登记表</div>
	<div class="basicInformation">
		 监督日期：默认当天操作时间
		<table width="980"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
			 <tr>
			 <td  height="44" align="center" class="tableLine" rowspan="2">
				船名
			</td>
			 <td  height="44" align="center" class="tableLine" >
				中文
			</td>
			<td  height="44" align="center" class="tableLine" width="200px">
				
			</td>
			 <td  height="44" align="center" class="tableLine" rowspan="2">
				国籍
			</td>
			<td  height="44" align="center" class="tableLine" >
				中文
			</td>
			<td  height="44" align="center" class="tableLine" colspan="3" >
				
			</td>
			</tr>
			<tr>
			 <td  height="44" align="center" class="tableLine" >
				英文
			</td>
			<td  height="44" align="center" class="tableLine" >
				
			</td>
			 <td  height="44" align="center" class="tableLine" >
				英文
			</td>
			<td  height="44" align="center" class="tableLine" colspan="3" >
				
			</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				吨位
				</td>
				<td  height="44" align="center" class="tableLine" >
				总吨
				</td>
				<td  height="44" align="center" class="tableLine" width="200px">
				</td>
				<td  height="44" align="center" class="tableLine" width="200px">
				船舶呼号
				</td>
				<td  height="44" align="center" class="tableLine" width="200px">
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2" >
				船舶代理
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2" colspan="2">
				申报单位
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				净吨
				</td>
				<td  height="44" align="center" class="tableLine" width="200px">
				</td>
				<td  height="44" align="center" class="tableLine" width="200px">
				船舶类型
				</td>
				<td  height="44" align="center" class="tableLine" width="200px">
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				IMO编号
				</td>
				<td  height="44" align="center" class="tableLine" colspan="3">
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				船龄
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" rowspan="4">
				航线
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="3">
				国际
				</td>
				<td  height="44" align="center" class="tableLine" >
				来自港
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				受染地区
				</td>
				<td  height="44" align="center" class="tableLine"  >
				是     否
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				注：
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				检疫港
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				动植物疫区
				</td>
				<td  height="44" align="center" class="tableLine" colspan="3">
				是     否
				</td>
				
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				检疫日期
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				入境检疫证
				</td>
				<td  height="44" align="center" class="tableLine" colspan="3">
				PRATIQUE / FREE PRATIQUE
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				国内
				</td>
				<td  height="44" align="center" class="tableLine" >
				来自港
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				受染地区
				</td>
				<td  height="44" align="center" class="tableLine" >
				是     否
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				注：
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="3">
				SSC / SSCEC
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				签发港
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				签发日期
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="3">
				交通工具卫生证书
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				船员
				</td>
				<td  height="44" align="center" class="tableLine" >
				中籍
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				旅客
				</td>
				<td  height="44" align="center" class="tableLine" >
				中籍
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2" >
				健康情况
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2" colspan="2" >
				
				</td>
				
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				外籍
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				外籍
				</td>
				<td  height="44" align="center" class="tableLine" >
				
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				装载货物
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				数量（吨）
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				装载港
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				</td>
				<td  height="44" align="center" class="tableLine" >
				卫生处理
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				是    否
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				放射性物质
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				是    否
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				压载水(吨)
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				装载港
				</td>
				<td  height="44" align="center" class="tableLine" rowspan="2">
				
				</td>
				<td  height="44" align="center" class="tableLine" >
				受染地区
				</td>
				<td  height="44" align="center" class="tableLine" >
				是   否
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2">
				注： 
				</td>
			</tr>
			<tr>
			<td height="44" align="center" class="tableLine">
			控制措施
			</td>
			<td height="44" align="center" class="tableLine" colspan="3">
			封    消    无
			</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" >
				食品装载港
				</td>
				<td height="44" align="center" class="tableLine">
			
				</td>
				<td height="44" align="center" class="tableLine">
				采样
				</td>
				<td height="44" align="center" class="tableLine">
				是  否
				</td>
				<td height="44" align="center" class="tableLine">
				卫生控制
				</td>
				<td height="44" align="center" class="tableLine">
				有   无
				</td>
				<td height="44" align="center" class="tableLine" rowspan="2">
				本港是否采购伙食
				</td>
				<td height="44" align="center" class="tableLine" rowspan="2">
				是  否
				</td>
				
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine">
				饮水装载港
				</td>
				<td height="44" align="center" class="tableLine">
			
				</td>
				<td height="44" align="center" class="tableLine">
				采样
				</td>
				<td height="44" align="center" class="tableLine">
				是  否
				</td>
				<td height="44" align="center" class="tableLine">
				卫生控制
				</td>
				<td height="44" align="center" class="tableLine">
				有   无
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				卫生检查项目
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				卫生评价
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				卫生检查项目
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				卫生评价
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				厨房餐厅
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				配餐间
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				食品库
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				货舱
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				住舱区
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				饮用水
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				排污设施
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				完好  污染
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				压载水阀门
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				关    开 
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				废物排放和储存
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				安全  否
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				不流动水
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				无    有 
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2">
				机舱
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				医疗设施
				</td>
				<td height="44" align="center" class="tableLine" colspan="2">
				良 中 差
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				医学媒介生物监测情况
				</td>
				<td  height="44" align="center" class="tableLine" colspan="6">
				鼠（   ）只  蚊 （    ）只  蝇（   ）只  蜚蠊（   ）只
				蜱（   ）只  螨 （    ）只  蠓（   ）只  其它（   ）只
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				备注
				</td>
				<td  height="44" align="left" class="tableLine" colspan="6">
				建议项：<br/>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;文本录入<br/>
				整改项：
				</td>
			</tr>
			<tr>
				<td height="44" align="center" class="tableLine" >
					监督地点
				</td>
				<td height="44" align="center" class="tableLine" colspan="2" >
					
				</td>
				<td height="44" align="center" class="tableLine" >
					处理地点
				</td>
				<td height="44" align="center" class="tableLine" colspan="2" >
					
				</td>
				<td height="44" align="center" class="tableLine" >
					有无违规	
				</td>
				<td height="44" align="center" class="tableLine" >
					有、无
				</td>
			</tr>
			<tr>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				监督人员
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				电子签名
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				查验/审核人员
				</td>
				<td  height="44" align="center" class="tableLine" colspan="2" >
				电子签名
				</td>
				
			</tr>
		</table>	
	</div>
	   <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>	
</body>
</html>
