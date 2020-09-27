<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生处理效果评价工作记录表</title>
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
.tableline_3_3,.tableline_3_4,.tableline_3_5,.tableline_3_6,.tableline_3_7{
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
     <div class="title_style"><span>卫生处理效果评价工作记录表</span></div>
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
                     <td class="tableline_3_3">交通工具名称</td>
                     <td class="tableline_3_4">集装箱号</td>
                     <td class="tableline_3_5">货物名称</td>
                     <td class="tableline_3_6">报检号</td>
                     <td class="tableline_3_7">口岸场所名称</td>
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
                     <td>实施单位</td>
                     <td colspan="2">${results.option_20}</td>
                 </tr>
                 <tr>
                     <td rowspan="12">评果</td>
                     <td rowspan="2">机构</td>
                     <td colspan="2">${results.option_21}</td>
                     <td></td>
                     <td colspan="3"></td>
                 </tr>
                 <tr>
                     <td colspan="2"></td>
                     <td></td>
                     <td colspan="3"></td>
                 </tr>
                 <tr>
                     <td rowspan="4">过程评价</td>
                     <td colspan="3">选用的药品器械是否符合总局的相关要求</td>
                     <td colspan="3" class="checkboxstyle" style="padding-left:10%"><c:if test="${results.option_22=='0'}"><span>是</span></c:if><c:if test="${results.option_22=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="3">现场操作人员是否有资质</td>
                     <td colspan="3" class="checkboxstyle" style="padding-left:10%"><c:if test="${results.option_23=='0'}"><span>是</span></c:if><c:if test="${results.option_23=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="3">操作时间、用药剂量、封闭操作等是否符合国家相关部门制定的规定或技术标准</td>
                     <td colspan="3" class="checkboxstyle" style="padding-left:10%"><c:if test="${results.option_24=='0'}"><span>是</span></c:if><c:if test="${results.option_24=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="3">处理效果是否符合卫生要求</td>
                     <td colspan="3" class="checkboxstyle" style="padding-left:10%"><c:if test="${results.option_25=='0'}"><span>是</span></c:if><c:if test="${results.option_25=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td rowspan="2" >验证检测</td>
                     <td>检测时间：</td>
                     <td colspan="5">${results.option_26}</td>
                 </tr>
                 <tr>
                     <td>检测部位</td>
                     <td colspan="2"><span>${results.option_27}</span></td>
                     <td>检测浓度</td>
                     <td colspan="2"><span>${results.option_28}</span></td>
                 </tr>
                 <tr>
                     <td>感官验证</td>
                     <td colspan="6">经肉眼观察，${results.option_33} :${results.option_34}<c:if test="${results.option_29=='0'}"><span style="border-bottom: 1px solid #000;width: 50px;height: 29px;margin-bottom: 2px;">是</span></c:if><c:if test="${results.option_29=='1'}"><span style="border-bottom: 1px solid #000;width: 50px;height: 29px;margin-bottom: 2px;">否</span></c:if>杀灭。</td>
                 </tr>
                 <tr>
                     <td>卫生处理效果判定</td>
                     <td colspan="4">本次卫生处理是否达到要求? </td>
                     <td colspan="2" class="checkboxstyle" style="padding-left:5%"><c:if test="${results.option_30=='0'}"><span>是</span></c:if><c:if test="${results.option_30=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td>其他</td>
                     <td colspan="6">${results.option_31}</td>
                 </tr>
                 <tr>
                     <td colspan="2">效果评价人员签字</td>
                     <td colspan="5">${results.option_32}</td>
                 </tr>
           </tbody>
     </table>
     <div class="leftstyle"><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：1. 请在□内打√。2. 处理标识可以填一至多项。3. 现场监管评价有一项为“否”，结果判定为“不合格”。结果判定依据附件2推荐的各项操作检查表(口岸分支机构亦可自制现场操作检查表)。满分30分，得分大于等于28分为良；大于等于25分，小于28分为合格，25分以下为不合格。</span></div>
     
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
</div>
</body>
</html>