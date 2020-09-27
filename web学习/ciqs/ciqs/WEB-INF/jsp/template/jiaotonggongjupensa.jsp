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
	<div class="subtitle_style"><span>交通工具喷洒操作（消毒、除虫）</span></div>
	<table>
		<thead>
	        <tr class="tablelinesecond_1">
				<td class="tablelinesecond_1_1">序号</td>
				<td class="tablelinesecond_1_2" colspan="2">考核项目</td>
				<td class="tablelinesecond_1_4">分值</td>
				<td class="tablelinesecond_1_5">得分下拉：0、分值数值（默认）、N/A</td>
			</tr>	
		</thead>
		<tbody>	
			<tr>
				<td>1</td>
				<td rowspan="4" class="tablelinesecond_2_2">准备</td>
				<td>了解处理目的、要求和注意事项</td>
				<td>1</td>
				<td>${results.option_1}</td>
			</tr>
			<tr>
				<td>2</td>
				<td>制定处理方案（处理目的、对象、方法、药物名称和用药标准、器械</td>
				<td>5</td>
				<td>${results.option_2}</td>
			</tr>
			<tr>
				<td>3</td>
				<td>人员、药品、工具、记录单证等齐全</td>
				<td>0.5</td>
				<td>${results.option_3}</td>
			</tr>
			<tr>
				<td>4</td>
				<td>检查药品在有效期内，浓度符合药品说明书规定</td>
				<td>0.5</td>
				<td>${results.option_4}</td>
			</tr>
			<tr>
				<td>5</td>
				<td colspan="2">检查处理对象与通知单相符合</td>
				<td>0.5</td>
				<td>${results.option_5}</td>
			</tr>
			<tr>
				<td>6</td>
				<td rowspan="3">配药</td>
				<td>计算配药量准确</td>
				<td>1</td>
				<td>${results.option_6}</td>
			</tr>
			<tr>
				<td>7</td>
				<td>准备称量用具</td>
				<td>1</td>
				<td>${results.option_7}</td>
			</tr>
			<tr>
				<td>8</td>
				<td>检查使用的仪器设备是否符合要求</td>
				<td>1</td>
				<td>${results.option_8}</td>
			</tr>
			<tr>
				<td>9</td>
			    <td rowspan="7">正确穿戴防护用品</td>
				<td>准备称量用具</td>
				<td>1</td>
				<td>${results.option_9}</td>
			</tr>
			<tr>
				<td>10</td>
				<td>由外到里</td>
				<td>0.5</td>
				<td>${results.option_10}</td>
			</tr>
			<tr>
				<td>11</td>
				<td>从左到右</td>
				<td>0.5</td>
				<td>${results.option_11}</td>
			</tr>
			<tr>
				<td>12</td>
				<td>从上到下</td>
				<td>0.5</td>
				<td>${results.option_12}</td>
			</tr>
			<tr>
				<td>13</td>
				<td>喷洒均匀</td>
				<td>0.5</td>
				<td>${results.option_13}</td>
			</tr>
			<tr>
				<td>14</td>
				<td>重叠不大于5cm</td>
				<td>1</td>
				<td>${results.option_14}</td>
			</tr>
			<tr>
				<td>15</td>
				<td>无漏喷区</td>
				<td>1</td>
				<td>${results.option_15}</td>
			</tr>
			<tr>
				<td>16</td>
			    <td rowspan="5">超低容量喷雾</td>
				<td>检查喷头、盛药罐、机械式预热</td>
				<td>1</td>
				<td>${results.option_16}</td>
			</tr>
			<tr>
				<td>17</td>
				<td>由外到里</td>
				<td>1</td>
				<td>${results.option_17}</td>
			</tr>
			<tr>
				<td>18</td>
				<td>从左到右</td>
				<td>1</td>
				<td>${results.option_18}</td>
			</tr>
			<tr>
				<td>19</td>
				<td>从上到下</td>
				<td>1</td>
				<td>${results.option_19}</td>
			</tr>
			<tr>
				<td>20</td>
				<td>由里到外</td>
				<td>1</td>
				<td>${results.option_20}</td>
			</tr>
			<tr>
				<td>21</td>
				<td colspan="2">喷药量适当</td>
				<td>1</td>
				<td>${results.option_21}</td>
			</tr>
			<tr>
				<td>22</td>
				<td colspan="2">评价喷雾效果</td>
				<td>1</td>
				<td>${results.option_22}</td>
			</tr>
			<tr>
				<td>23</td>
				<td colspan="2">采集虫样送检</td>
				<td>1</td>
				<td>${results.option_23}</td>
			</tr>
			<tr>
				<td>24</td>
				<td colspan="2">正确脱防护用品</td>
				<td>2</td>
				<td>${results.option_24}</td>
			</tr>
			<tr>
				<td>25</td>
				<td colspan="2">各项操作熟练</td>
				<td>2</td>
				<td>${results.option_25}</td>
			</tr>
			<tr>
				<td>26</td>
				<td colspan="2">整理用具</td>
				<td>0.5</td>
				<td>${results.option_26}</td>
			</tr>
			<tr>
				<td>27</td>
				<td colspan="2">现场操作原始记录准确、完整（1分），规范签发处理报告书（1分）</td>
				<td>2</td>
				<td>${results.option_27}</td>
			</tr>
			<tr>
				<td>28</td>
				<td colspan="2">个人清洁措施</td>
				<td>1</td>
				<td>${results.option_28}</td>
			</tr>
			<tr class="tablelinesecond_29">
				<td colspan="3">合计</td>
				<td>${results.option_31}</td>
				<td>${results.option_30}</td>
			</tr>
		</tbody>
    </table>
</div>
</body>
</html>