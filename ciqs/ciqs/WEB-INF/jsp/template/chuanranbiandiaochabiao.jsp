<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>口岸传染病可疑病例流行病学调查表</title>
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
.paragraphTitle_1,.paragraphTitle_2,.paragraphTitle_3,.paragraphTitle_4,.paragraphTitle_5,.paragraphTitle_6{
    font-size: 30px;
    height: 40px;
}
.basicInformation div,.basicInformation_find div{
    float:left;
    width:auto;
    margin-right:80px;
}
。basicInformation div span,.basicInformation div input,.basicInformation div select{
    display: inline-block;
    float: right;
}
.basicInformation div input{
    height:25px;
}
.basicInformation div select{
    height: 29px;
    width: 45px;
}
.adressLine{
    display:inline-block;
    border-bottom:1px solid #000;
    width:50px;
}
.basicInformation_find div input{
   width:22px;
   height:22px;
   margin-left:9px;
   display:inline-block;
   float:left;
   margin-top: 6px;
}
.basicInformation_find div span{
   display:inline-block;
   float:left;
}
.clinicalFeature div div{
   width:500px;
   float:left;
}
.clinicalFeature div div:first{
   margin-right:80px;
}
.clinicalFeature_1_2 span,.clinicalFeature_1_2 input{
  display:inline-block;
  float:left;
  
}
 span{
   display:inline-block;
   margin-right:10px; 
   float:left;
   height:30px;
}
 input[type='checkbox']{
   margin-right:25px; 
   display:inline-block;
   float:left;
   height:22px;
   width:22px;
   margin-top:6px;
}
.clinicalFeature_1_2 input{
  height:25px;
  margin-top: 0px;
  width: 170px;
  display:inline-block;
}
.clinicalFeature_other span,.clinicalFeature_other input{
   display:inline-block;
   margin-right:15px; 
   float:left;
}
.clinicalFeature_other input{
    height: 25px;
    width: 600px;
}
table{
    margin-left: 0px;
    width: 1000px;
}
table tr{
   height:35px;
}
table tr td{
     border: 1px solid #000;
}
.linewidth{
     width:600px;
     border-bottom: 1px solid #000;
}
</style>
</head>
<body>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<div>
    <div class="chatTitle">口岸传染病可疑病例流行病学调查表</div>
    <div class="paragraphTitle_1">一、基本信息</div>
    <div class="basicInformation">
        <div><span>姓名：</span><input type="text" value="${results.option_1}" disabled="disabled"/></div>
        <div><span>性别：</span><c:if test="${results.option_2 == '1'}">男</c:if> <c:if test="${results.option_2 == '2'}">女</c:if></div>
        <div><span>出生年月：</span><input type="text" value="${results.option_3}" disabled="disabled"/></div>
        <div><span>国籍/地区：</span><input type="text" value="${results.option_4}" disabled="disabled"/></div>
        <div><span>职业：</span><input type="text" value="${results.option_5}" disabled="disabled"/></div>
        <div><span>出入境时间：</span><input type="text" value="${results.option_6}" disabled="disabled"/></div>
        <div><span>车（船）次/航班号：</span><input type="text" value="${results.option_7}" disabled="disabled"/></div>
        <div><span>车厢（牌）号座（铺）位号：</span><input type="text" value="${results.option_8}" disabled="disabled"/></div>
        <div><span>身份证件类型/号码：</span><input type="text" value="${results.option_9}" disabled="disabled"/></div>
        <div><span>联系电话：</span><input type="text" value="${results.option_10}" disabled="disabled"/></div>
        <div><span>工作单位：</span><span class="adressLine" style="width:600px">${results.option_11}</span></div>
        <div><span>境内居住地：</span><span class="adressLine">${province}</span><span>省</span><span class="adressLine">${city}</span><span>市县（区）</span><span class="adressLine">${area}</span><span>乡（街道）村</span></div>
    </div>
    <div><span>个案发现渠道：</span> </div>
    <div class="basicInformation_find">
        <div><span>测温发现</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_13 == '1'}"> checked="checked" </c:if> /></div>
        <div><span>交通工具负责人申报</span><input type="checkbox" disabled="disabled"  <c:if test="${results.option_13 == '2'}"> checked="checked" </c:if> /></div>      
        <div><span>医学巡查发现</span><input type="checkbox" value="3" disabled="disabled" <c:if test="${results.option_13 == '3'}"> checked="checked" </c:if> /></div>
        <div><span>个人申报</span><input type="checkbox" value="4" disabled="disabled" <c:if test="${results.option_13 == '4'}"> checked="checked" </c:if> /></div>
        <div><span>疫情通报</span><input type="checkbox" value="5" disabled="disabled" <c:if test="${results.option_13 == '5'}"> checked="checked" </c:if> /></div>
        <div><span>其他</span><input type="checkbox" value="6" disabled="disabled" <c:if test="${results.option_13 == '6'}"> checked="checked" </c:if> /></div>
    </div>
    <div class="paragraphTitle_2"><span>二、临床表现</span></div>
    <div class="clinicalFeature" id="chkDiv">
        <div>
             <div><span>腋下体温测量(℃):</span><span>${results.option_14}</span></div>
             <div class="clinicalFeature_1_2"><span>发病时间:</span><input type="text" value="${results.option_65}" disabled="disabled"/></div>
        </div>
        <div>
             <div><span>A．畏寒</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_15 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_15 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_15 == 3}"> checked="checked" </c:if> /></div>
             <div><span>B．呼吸困难</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_16 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_16 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_16 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>C．咳嗽</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_17 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_17 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_17 == 3}"> checked="checked" </c:if> /></div>
             <div><span>D．咳血</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_18 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_18 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_18 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>E．胸痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_19 == '1'}"> checked="checked" </c:if>/><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_19 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_19 == 3}"> checked="checked" </c:if> /></div>
             <div><span>F．呕吐</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_20 == '1'}"> checked="checked" </c:if>/><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_20 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_20 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>G．腹泻</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_21 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_21 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_21 == 3}"> checked="checked" </c:if> /></div>
             <div><span>H．腹痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_22 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_22 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_22 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>I．头痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_23 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_23 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_23 == 3}"> checked="checked" </c:if> /></div>
             <div><span>J．肌肉痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_24 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_24 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_24 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>K．关节痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_25 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_25 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_25 == 3}"> checked="checked" </c:if> /></div>
             <div><span>L．眼眶痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_26 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_26 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_26 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>M．面色潮红</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_27 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_27 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_27 == 3}"> checked="checked" </c:if> /></div>
             <div><span>N．皮疹</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_28 =='1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_28 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_28 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>O．黄疸</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_29 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_29 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_29 == 3}"> checked="checked" </c:if> /></div>
             <div><span>P．淤血（淤斑）</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_30 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_30 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_30 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>Q．淋巴结肿大</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_31 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_31 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_31 == 3}"> checked="checked" </c:if> /></div>
             <div><span>R．盗汗</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_32 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_32 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_32 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>S．颈项强直</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_33 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_33 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_33 == 3}"> checked="checked" </c:if> /></div>
        </div>
    </div>
    <div>
        <div class="clinicalFeature_other"><span>其他特异性症状:</span><input type="text" value="${results.option_34}" disabled="disabled"/></div>
    </div>
    <div class="paragraphTitle_3"><span>三、流行病学因素调查</span></div>
    <div>
         <div>
         	  <span>1. 发病前4周内旅行史，以及所来自国家/地区是否流行同类症状的疾病：</span><span><input type="text" value="${results.option_35}" disabled="disabled"/></span>
         </div>
         <div><span>2.发病前2周内是否接触过类似症状的病人：</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_36 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_36 == '2'}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_36 == 3}"> checked="checked" </c:if> /></div>
         <c:if test="${results.option_36 == '1'}">
         	<div><span>如果有，填写类似症状病人情况表：</span></div>
	         <div>
	             <table>
	                  <tr><td>病人姓名</td><td>发病时间</td><td>临床诊断</td><td>与本人关系</td><td>最后接触时间</td><td>接触方式</td><td>接触频率</td><td>接触地点</td></tr>
	                  <c:if test="${not empty results.option_37 }"><tr><c:forTokens items="${results.option_37}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_38 }"><tr><c:forTokens items="${results.option_38}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_39 }"><tr><c:forTokens items="${results.option_39}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_40 }"><tr><c:forTokens items="${results.option_40}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_41 }"><tr><c:forTokens items="${results.option_41}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_42 }"><tr><c:forTokens items="${results.option_42}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_43 }"><tr><c:forTokens items="${results.option_43}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_44 }"><tr><c:forTokens items="${results.option_44}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	                  <c:if test="${not empty results.option_45 }"><tr><c:forTokens items="${results.option_45}" delims="," var="option"><td>${option}</td></c:forTokens></tr></c:if>
	             </table>
	         </div>
	         <div><span>填表说明</span></div>
	         <div><span>与本人关系：（1）家庭成员（2）同事（3）社会交往（4）共用交通工具（5）其他</span></div>
	         <div style="height:58px;"><span>接触方式：（1）与病人同进餐（2）与病人同处一室（3）与病人同一病区（4）与病人共用食具、茶具、毛巾、玩具等</span></div>
	         <div><span>（5）接触病人分泌物、排泄物等（6）诊治、护理（7）探视病人（8）其他接触</span></div>
	         <div><span>接触频率：（1）经常（2）有时（3）偶尔</span></div>
	         <div><span>接触地点：（1）家（2）工作单位（3）学校（4）集体宿舍（5）医院（6）室内公共场所（7）其他</span></div>
         </c:if>
         <div><span>3．有无怀孕？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_46 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_46 == '2'}"> checked="checked" </c:if> /></div>
         <div><span>4．有无晕机（车、船）史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_47 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_47 == '2'}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_47 == 3}"> checked="checked" </c:if> /></div>
         <div><span>5．近期有无用药？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_48 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_48 == '2'}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_48 == 3}"> checked="checked" </c:if> /></div>
         <div><span>如果有，用药情况</span><span class="linewidth">${results.option_49}</span></div>
         <div><span>6．既往有无传染病史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_50 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_50 == '2'}"> checked="checked" </c:if> /></div>
         <div><span>如果有，具体情况</span><span class="linewidth">${results.option_51}</span></div>
         <div><span>7．是否曾住院诊断？</span><span>是</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_52 == '1'}"> checked="checked" </c:if> /><span>否</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_52 == '2'}"> checked="checked" </c:if> /></div>
         <div><span>如果是，诊断结果</span><span class="linewidth">${results.option_53}</span></div>
         <div><span>8．是否从事动物饲养、宰杀、捕捉或标本制作工作？</span><span>是</span><input type="checkbox"  disabled="disabled" <c:if test="${results.option_54 == '1'}"> checked="checked" </c:if> /><span>否</span><input type="checkbox"  disabled="disabled" <c:if test="${results.option_54 == '2'}"> checked="checked" </c:if> /></div>
         <div><span>如果是，具体情况</span><span class="linewidth">${results.option_55}</span></div>
         <div><span>9.是否为从事病原生物学研究或医务工作？</span><span>是</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_56 == '1'}"> checked="checked" </c:if> /><span>否</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_56 == '2'}"> checked="checked" </c:if> /></div> 
         <div><span>10.有无蚊虫叮咬史？</span><span class="linewidth">${results.option_67}</span></div>
         <div><span>11.近期有无输血献血？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_58 == '1'}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${results.option_58 == '2'}"> checked="checked" </c:if> /></div>
         <div><span>如果有，具体情况</span><span class="linewidth">${results.option_59}</span></div>
         <div><span>其他相关因素调查：</span><span class="linewidth">${results.option_60}</span></div>
         <div><span class="linewidth"></span></div>
    </div>
    <div class="paragraphTitle_4"><span>四、初步判断及病例处理意见</span></div>
    <c:set value=",${results.option_61}," var="fourth_option"></c:set>
    <div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${fn:contains(fourth_option,',1,')==true}"> checked="checked" </c:if> /></span>1．排除传染病可能，放行；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${fn:contains(fourth_option,',2,')==true}"> checked="checked" </c:if> /></span>2．按照呼吸道传播途径传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${fn:contains(fourth_option,',3,')==true}"> checked="checked" </c:if> /></span>3．按照消化道传播途径传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${fn:contains(fourth_option,',4,')==true}"> checked="checked" </c:if> /></span>4．按照蚊媒传播途径传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${fn:contains(fourth_option,',5,')==true}"> checked="checked" </c:if> /></span>5．按照其他途径（${results.option_65}）传播传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${fn:contains(fourth_option,',6,')==true}"> checked="checked" </c:if> /></span>6．其他
         </div>
         <div>
                                           检疫人员签名：<span></span>${results.option_63}&nbsp;&nbsp;&nbsp;日期:<span></span>${results.option_64}
         </div>
         <div style="text-align: center;margin: auto;margin-top: 10px;width:400px;padding-bottom: 10px;">
		    <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
         </div>
    </div>
</div>

</body>
</html>