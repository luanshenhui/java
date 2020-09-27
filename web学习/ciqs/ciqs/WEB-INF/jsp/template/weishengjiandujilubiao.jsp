<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生处理现场监督记录表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css"> 
body div{
    width:700px;
    text-align: center;    
    margin: 0 auto;
    font-size:22px;
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
.title_style{
    font-size:30px;
    font-weight: 600;
}
.tableline_1_1{
    width:40px;
}
.tableline_1_2{
    width:60px;
}
.tableline_4_3,.tableline_4_4,.tableline_4_5,.tableline_4_6,.tableline_4_7{
    width:110px;
}
.leftstyle{
    text-align:left;
}
input[type='text']{
    height: 23px;
}
.checkboxstyle input{
    height:22px;
    width:22px;
    display:block;
    float:left;
    margin-top: 5px;
    margin-bottom: 2px;
}
.checkboxstyle span{
    display:block;
    float:left;
    margin-bottom: 2px;
}
</style>
</head>
<body>
<div>
     <div class="title_style"><span>卫生处理现场监督记录表</span></div>
     <table>
           <tbody>
                 <tr>
                     <td rowspan="9" class="tableline_1_1">基本情况</td>
                     <td class="tableline_1_2">对象</td>
                     <td colspan="6" class="checkboxstyle">
                          <c:set value=",${results.option_1}," var="checkList"></c:set>
                          <div style="height:32px">
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',1,')==true}"> checked="checked"</c:if>/><span>船舶</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',2,')==true}"> checked="checked"</c:if>/><span>飞机</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',3,')==true}"> checked="checked"</c:if>/><span>汽车</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',4,')==true}"> checked="checked"</c:if>/><span>列车</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',5,')==true}"> checked="checked"</c:if>/><span>集装箱空箱</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',6,')==true}"> checked="checked"</c:if>/><span>集装箱重箱</span>
	                      </div>
	                      <div style="height:32px">
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',7,')==true}"> checked="checked"</c:if>/><span>散货</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',8,')==true}"> checked="checked"</c:if>/><span>行李</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',9,')==true}"> checked="checked"</c:if>/><span>邮包</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',10,')==true}"> checked="checked"</c:if>/><span>公共场所</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',11,')==true}"> checked="checked"</c:if>/><span>集装箱场站</span>
	                          <input type="checkbox" <c:if test="${fn:contains(checkList,',12,')==true}"> checked="checked"</c:if>/><span>其他</span><span style="border-bottom: 1px solid #000;width: 150px;height: 29px;margin-bottom: 2px;">${results.option_2}</span>
                          </div>
                     </td>
                 </tr>
                 <tr>
                     <td rowspan="2">标识</td>
                     <td class="tableline_4_3">交通工具名称</td>
                     <td class="tableline_4_4">集装箱号</td>
                     <td class="tableline_4_5">货物名称</td>
                     <td class="tableline_4_6">报检号</td>
                     <td class="tableline_4_7">口岸场所名称</td>
                     <td>其  他</td>
                 </tr>
                 <tr>
                     <td>${results.option_3}</td>
                     <td>${results.option_4}</td>
                     <td>${results.option_5}</td>
                     <td>${results.option_6}</td>
                     <td>${results.option_7}</td>
                     <td>${results.option_8}</td>
                 </tr>
                 <tr>
                     <td>目的</td>
                     <td colspan="6" class="checkboxstyle">
                          <input type="checkbox" <c:if test="${results.option_9 =='1'}"> checked="checked"</c:if>/><span>消毒</span>
                          <input type="checkbox" <c:if test="${results.option_9 =='2'}"> checked="checked"</c:if>/><span>除虫</span>
                          <input type="checkbox" <c:if test="${results.option_9 =='3'}"> checked="checked"</c:if>/><span>灭鼠</span>
                          <input type="checkbox" <c:if test="${results.option_9 =='4'}"> checked="checked"</c:if>/><span>除污</span>
                          <input type="checkbox" <c:if test="${not empty results.option_10}"> checked="checked"</c:if>/><span>其他</span><span style="border-bottom: 1px solid #000;width: 150px;height: 29px;margin-bottom: 2px;">${results.option_10}</span>
                     </td>
                 </tr>
                 <tr>
                     <td>方法</td>
                     <td colspan="6" class="checkboxstyle">
                          <input type="checkbox" <c:if test="${results.option_11 =='1'}"> checked="checked"</c:if>/><span>熏蒸</span>
                          <input type="checkbox" <c:if test="${results.option_11 =='2'}"> checked="checked"</c:if>/><span>喷洒</span>
                          <input type="checkbox" <c:if test="${results.option_11 =='3'}"> checked="checked"</c:if>/><span>毒饵</span>
                          <input type="checkbox" <c:if test="${results.option_11 =='4'}"> checked="checked"</c:if>/><span>器械</span>
                          <input type="checkbox" <c:if test="${not empty results.option_12}"> checked="checked"</c:if>/><span>其他</span><span style="border-bottom: 1px solid #000;width: 150px;height: 29px;margin-bottom: 2px;">${results.option_12}</span>
                     </td>
                 </tr>
                 <tr>
                     <td rowspan="2">药剂</td>
                     <td>名称</td>
                     <td>浓度</td>
                     <td colspan="2">作用面积</br>（喷洒,m2）</td>
                     <td>作用面积</br>（熏蒸.m3）</td>
                     <td>药量</td>
                 </tr>
                 <tr>
                     <td>${results.option_13}</td>
                     <td>${results.option_14}</td>
                     <td colspan="2">${results.option_15}</td>
                     <td>${results.option_16}</td>
                     <td>${results.option_17}</td>
                 </tr>
                 <tr>
                     <td>时间</td>
                     <td colspan="6">${results.option_18}</td>
                 </tr>
                 <tr>
                     <td>地点</td>
                     <td colspan="3">${results.option_19}</td>
                     <td>操作人员</td>
                     <td colspan="2">${results.option_20}</td>
                 </tr>
                 <tr>
                     <td rowspan="9">现场监督</td>
                     <td>监督机构</td>
                     <td colspan="3" class="leftstyle">${results.option_21}</td>
                     <td>监督时间</td>
                     <td colspan="2">${results.option_22}</td>
                 </tr>
                 <tr>
                     <td rowspan="4">现场监管评价</td>
                     <td colspan="4" class="leftstyle">依据和目的是否正确</td>
                     <td colspan="2" class="checkboxstyle" style="padding-left:5%"><c:if test="${results.option_23=='0'}"><span>是</span></c:if><c:if test="${results.option_23=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="4" class="leftstyle">方法和药械使用是否合理</td>
                     <td colspan="2" class="checkboxstyle" style="padding-left:5%"><c:if test="${results.option_24=='0'}"><span>是</span></c:if><c:if test="${results.option_24=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="4" class="leftstyle">现场操作是否规范</td>
                     <td colspan="2" class="checkboxstyle" style="padding-left:5%"><c:if test="${results.option_25=='0'}"><span>是</span></c:if><c:if test="${results.option_25=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="4" class="leftstyle">安全防护措施是否到位</td>
                     <td colspan="2" class="checkboxstyle" style="padding-left:5%"><c:if test="${results.option_26=='0'}"><span>是</span></c:if><c:if test="${results.option_26=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td>现场监管结果判定</td>
                     <td colspan="6" class="checkboxstyle" style="padding-left:30%"><c:if test="${results.option_27=='0'}"><span>良</span></c:if><c:if test="${results.option_27=='1'}"><span>合格</span></c:if><c:if test="${results.option_27=='2'}"><span>不合格</span></c:if></td>
                 </tr>
                  <tr>
                     <td>整改措施</td>
                     <td colspan="6" class="leftstyle">${results.option_28}</td>
                 </tr>
                  <tr>
                     <td>整改落实情况</td>
                     <td colspan="6" class="leftstyle">${results.option_29}</td>
                 </tr>
                  <tr>
                     <td>监督人员</td>
                     <td colspan="3">${results.option_30}</td>
                     <td colspan="2">卫生处理单位人员</td>
                     <td>${results.option_31}</td>
                 </tr>
           </tbody>
     </table>
     <div class="leftstyle"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：1. 请在□内打√。2. 处理标识可以填一至多项。3. 现场监管评价有一项为“否”，结果判定为“不合格”。结果判定依据附件2推荐的各项操作检查表(口岸分支机构亦可自制现场操作检查表)。满分30分，得分大于等于28分为良；大于等于25分，小于28分为合格，25分以下为不合格。</span></div>
</div>
</body>
</html>