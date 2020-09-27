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
<div>
	<div class="title_style"><span>卫生处理现场操作检查考核评分表</span></div>
    <div class="subtitle_style"><span>交通工具垃圾（废弃物）消毒操作</span></div>
    <table>
		<thead>
	        <tr class="tablelinethird_1">
				<td class="tablelinethird_1_1">序号</td>
				<td class="tablelinethird_1_2" colspan="2">考核项目</td>
				<td class="tablelinethird_1_4">分值</td>
				<td class="tablelinethird_1_5">得分下拉：0、分值数值（默认）、N/A</td>
			</tr>	
		</thead>
		<tbody>	
			<tr>
				<td>1</td>
				<td rowspan="5" class="tablelinethird_2_2">准备</td>
				<td>检查所使用消毒剂在有效期内</td>
				<td>3</td>
				<td>${results.option_1}</td>
			</tr>
			<tr>
				<td>2</td>
				<td>使用浓度符合药品说明书规定</td>
				<td>4</td>
				<td>${results.option_2}</td>
			</tr>
			<tr>
				<td>3</td>
				<td>配药地点符合规定、配药时做好个人防护</td>
				<td>2</td>
				<td>${results.option_3}</td>
			</tr>
			<tr>
				<td>4</td>
				<td>药品浓度稀释配制正确</td>
				<td>2</td>
				<td>${results.option_4}</td>
			</tr>
			<tr>
				<td>5</td>
				<td>检查所使用器械性能状态良好</td>
				<td>2</td>
				<td>${results.option_5}</td>
			</tr>
			<tr>
				<td>6</td>
				<td rowspan="3">操作</td>
				<td>正确穿戴个人防护</td>
				<td>2</td>
				<td>${results.option_6}</td>
			</tr>
			<tr>
				<td>7</td>
				<td>在上风向操作</td>
				<td>2</td>
				<td>${results.option_7}</td>
			</tr>
			<tr>
				<td>8</td>
				<td>喷洒彻底（消毒剂和垃圾、废弃物充分接触）</td>
				<td>5</td>
				<td>${results.option_8}</td>
			</tr>
			<tr>
				<td>9</td>
				<td colspan="2">正确脱掉防护</td>
				<td>2</td>
				<td>${results.option_9}</td>
			</tr>
			<tr>
				<td>10</td>
				<td colspan="2">操作熟练</td>
				<td>1</td>
				<td>${results.option_10}</td>
			</tr>
			<tr>
				<td>11</td>
				<td colspan="2">清洗器械</td>
				<td>2</td>
				<td>${results.option_11}</td>
			</tr>
			<tr>
				<td>12</td>
				<td colspan="2">交通工具卫生除害处理记录规范、完整</td>
				<td>2</td>
				<td>${results.option_12}</td>
			</tr>
			<tr>
				<td>13</td>
				<td colspan="2">个人清洁措施</td>
				<td>1</td>
				<td>${results.option_13}</td>
			</tr>
			<tr class="tablelinethird_14">
				<td colspan="3">合计</td>
				<td>${results.option_31}</td>
				<td>${results.option_30}</td>
			</tr>
	    </tbody>
	</table>
	<input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
</div>
</body>
</html>