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
	<div class="subtitle_style"><span>交通工具熏蒸操作（除虫、除鼠）</span></div>
	<table>
		<thead>
	        <tr class="tableline_1">
				<td class="tableline_1_1">序号</td>
				<td class="tableline_1_2" colspan="2">考核项目</td>
				<td class="tableline_1_4">分值</td>
				<td class="tableline_1_5">得分下拉：0、分值数值（默认）、N/A</td>
			</tr>	
		</thead>
		<tbody>	
			<tr>
				<td>1</td>
				<td rowspan="4" class="tableline_2_2">准备</td>
				<td>了解处理目的、要求和注意事项（如货物包装标志标识）</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>2</td>
				<td>制定处理方案（处理目的、对象、方法、药物名称和用药标准、器械）</td>
				<td>5</td>
				<td></td>
			</tr>
			<tr>
				<td>3</td>
				<td>人员、药品、工具、记录单证等齐全</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>4</td>
				<td>配备救护人员（可兼职）和急救箱</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>5</td>
				<td rowspan="19">操作</td>
				<td>到达现场通知被处理单位做好配合</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>6</td>
				<td>检查处理对象与通知单相符合</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>7</td>
				<td>设置警示标识和应急撤离通道</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>8</td>
				<td>检查使用的药品符合要求</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>9</td>
				<td>检查使用的仪器设备符合要求</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>10</td>
				<td>正确选择个人防护用品完好、有效</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>11</td>
				<td>封糊（完整无漏气点）</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>12</td>
				<td>设置投药点</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>13</td>
				<td>布投药管</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>14</td>
				<td>布测毒管</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>15</td>
				<td>正确佩戴防护用具</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>16</td>
				<td>投药(两人操作、上风口，徐徐打开阀门)</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>17</td>
				<td>用药称量准确，关闭阀门</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>18</td>
				<td>预热药物浓度测试仪器</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>19</td>
				<td>测量投药有效浓度（是否补充投药，有测浓度记录）</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>20</td>
				<td>测量是否有漏气现象（如有补封）</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>21</td>
				<td>药物作用时间符合要求</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>22</td>
				<td>散毒（先下风、后上风）</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>23</td>
				<td>药物残留测定方法正确，有记录</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>24</td>
				<td colspan="2">清理毒毙昆虫、死鼠并计数</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>25</td>
				<td colspan="2">正确脱防护用品</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>26</td>
				<td colspan="2">各项操作熟练</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>27</td>
				<td colspan="2">整理用具</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>28</td>
				<td colspan="2">现场操作原始记录准确、完整（1.5分），规范签发处理报告书（1.5分）</td>
				<td>3</td>
				<td></td>
			</tr>
			<tr>
				<td>29</td>
				<td colspan="2">个人清洁措施</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr class="tableline_30">
				<td colspan="3">合计</td>
				<td>30</td>
				<td></td>
			</tr>
		</tbody>
	</table>
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
				<td></td>
			</tr>
			<tr>
				<td>2</td>
				<td>制定处理方案（处理目的、对象、方法、药物名称和用药标准、器械</td>
				<td>5</td>
				<td></td>
			</tr>
			<tr>
				<td>3</td>
				<td>人员、药品、工具、记录单证等齐全</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>4</td>
				<td>检查药品在有效期内，浓度符合药品说明书规定</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>5</td>
				<td colspan="2">检查处理对象与通知单相符合</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>6</td>
				<td rowspan="3">配药</td>
				<td>计算配药量准确</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>7</td>
				<td>准备称量用具</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>8</td>
				<td>检查使用的仪器设备是否符合要求</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>9</td>
			    <td rowspan="7">正确穿戴防护用品</td>
				<td>准备称量用具</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>10</td>
				<td>由外到里</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>11</td>
				<td>从左到右</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>12</td>
				<td>从上到下</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>13</td>
				<td>喷洒均匀</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>14</td>
				<td>重叠不大于5cm</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>15</td>
				<td>无漏喷区</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>16</td>
			    <td rowspan="5">超低容量喷雾</td>
				<td>检查喷头、盛药罐、机械式预热</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>17</td>
				<td>由外到里</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>18</td>
				<td>从左到右</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>19</td>
				<td>从上到下</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>20</td>
				<td>由里到外</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>21</td>
				<td colspan="2">喷药量适当</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>22</td>
				<td colspan="2">评价喷雾效果</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>23</td>
				<td colspan="2">采集虫样送检</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>24</td>
				<td colspan="2">正确脱防护用品</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>25</td>
				<td colspan="2">各项操作熟练</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>26</td>
				<td colspan="2">整理用具</td>
				<td>0.5</td>
				<td></td>
			</tr>
			<tr>
				<td>27</td>
				<td colspan="2">现场操作原始记录准确、完整（1分），规范签发处理报告书（1分）</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>28</td>
				<td colspan="2">个人清洁措施</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr class="tablelinesecond_29">
				<td colspan="3">合计</td>
				<td>30</td>
				<td></td>
			</tr>
		</tbody>
    </table>
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
				<td></td>
			</tr>
			<tr>
				<td>2</td>
				<td>使用浓度符合药品说明书规定</td>
				<td>4</td>
				<td></td>
			</tr>
			<tr>
				<td>3</td>
				<td>配药地点符合规定、配药时做好个人防护</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>4</td>
				<td>药品浓度稀释配制正确</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>5</td>
				<td>检查所使用器械性能状态良好</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>6</td>
				<td rowspan="3">操作</td>
				<td>正确穿戴个人防护</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>7</td>
				<td>在上风向操作</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>8</td>
				<td>喷洒彻底（消毒剂和垃圾、废弃物充分接触)</td>
				<td>5</td>
				<td></td>
			</tr>
			<tr>
				<td>9</td>
				<td colspan="2">正确脱掉防护</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>10</td>
				<td colspan="2">操作熟练</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr>
				<td>11</td>
				<td colspan="2">清洗器械</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>12</td>
				<td colspan="2">交通工具卫生除害处理记录规范、完整</td>
				<td>2</td>
				<td></td>
			</tr>
			<tr>
				<td>13</td>
				<td colspan="2">个人清洁措施</td>
				<td>1</td>
				<td></td>
			</tr>
			<tr class="tablelinethird_14">
				<td colspan="3">合计</td>
				<td>30</td>
				<td></td>
			</tr>
	    </tbody>
	</table>
</div>
</body>
</html>