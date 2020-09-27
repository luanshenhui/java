<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生处理现场操作检查考核评分表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div{
    width:700px;
    text-align: center;    
    margin: 0 auto;
    font-size:20px;
}
table{
    width:100%;
}
tr{
    height:30px; 
}
td{
    border: 1px solid #000; 
    padding:3px; 
}
tr td:nth-last-child(3){
    text-align: left;
}
.title_style{
    font-size:30px;
    font-weight: 600;
}
.subtitle_style{
    font-size:25px;
}
.tableline_1 td,.tablelinesecond_1 td,.tablelinethird_1 td  {
    height:100px;
    text-align:center !important;
}
.tableline_1_1,.tableline_1_4,.tableline_1_5,.tableline_2_2,.tablelinesecond_1_1,.tablelinesecond_1_4,.tablelinesecond_1_5,.tablelinesecond_2_2,.tablelinethird_1_1,.tablelinethird_1_4,.tablelinethird_1_5,.tablelinethird_2_2{
    width:60px;
}
.tableline_30 td,.tablelinesecond_29 td,.tablelinethird_14 td{
    text-align:center !important;
}
</style>
</head>
<body>
<div>	
	<div class="title_style"><span>质量监督检验检疫</span></div>
	<div class="subtitle_style"><span>行政许可文书送达回证</span></div>
	<table>
		<tbody>	
		    <tr>
				<td style="width:100px;height: 26px">受送达人</td>
				<td style="width:300px;height: 26px"></td>
			</tr>	
			<tr>
				<td>送达文书名称</td>
				<td></td>
			</tr>
			<tr>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>3</td>
				<td></td>
			</tr>
			<tr>
				<td>送达方式</td>
				<td></td>
			</tr>
			<tr>
				<td>送达日期</td>
				<td></td>
			</tr>
			<tr>
				<td>送达人员</td>
				<td></td>
			</tr>
			<tr>
				<td style="width:100px;height: 210px">收件人签名或盖章</td>
				<td></td>
			</tr>
			<tr>
				<td style="width:100px;height: 210px">备注</td>
				<td></td>
			</tr>
		</tbody>
    </table>
</div>
</body>
</html>