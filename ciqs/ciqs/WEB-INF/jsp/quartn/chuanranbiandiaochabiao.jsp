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
<script type="text/javascript">
	function loading(){
		location.href="downQuartnPdf"+location.search+"&index=1";
	}
</script>
<div>
    <div class="chatTitle">口岸传染病可疑病例流行病学调查表</div>
    <div class="paragraphTitle_1">一、基本信息</div>
    <div class="basicInformation">
        <div><span>姓名：</span><input type="text" value="${dddtl1.option1}" disabled="disabled"/></div>
        <div><span>性别：</span>${dddtl1.option2==0?"男":"女"}</div>
        <div><span>出生年月：</span><input type="text" value="${dddtl1.option3}" disabled="disabled"/></div>
        <div><span>国籍/地区：</span><input type="text" value="${dddtl1.option4}" disabled="disabled"/></div>
        <div><span>职业：</span><input type="text" value="${dddtl1.option5}" disabled="disabled"/></div>
        <div><span>出入境时间：</span><input type="text" value="${dddtl1.option6}" disabled="disabled"/></div>
        <div><span>车（船）次/航班号：</span><input type="text" value="${dddtl1.option7}" disabled="disabled"/></div>
        <div><span>车厢（牌）号座（铺）位号：</span><input type="text" value="${dddtl1.option8}" disabled="disabled"/></div>
<!--         <div><span>：</span><input type="text" value="${dddtl1.option8}" disabled="disabled"/></div> -->
        <div><span>身份证件类型/号码：</span><input type="text" value="${dddtl1.option9}" disabled="disabled"/></div>
        <div><span>联系电话：</span><input type="text" value="${dddtl1.option10}" disabled="disabled"/></div>
        <div><span>境内居住地：</span><span class="adressLine">${area}</span><span>省</span><span class="adressLine">${city}</span><span>市县（区）</span><span class="adressLine">${street}</span><span>乡（街道）村</span></div>
        <div><span>其他联系人及其关系：</span><input type="text" value="${dddtl1.option12}" disabled="disabled"/></div>
        <div><span>联系方式：</span><input type="text" value="${dddtl1.option66}" disabled="disabled"/></div>
    </div>
    <div><span>个案发现渠道：</span> </div>
    <div class="basicInformation_find">
        <div><span>交通工具负责人报告</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option13 == 1}"> checked="checked" </c:if> /></div>
        <div><span>旅客主动申报</span><input type="checkbox" disabled="disabled"  <c:if test="${dddtl1.option13 == 2}"> checked="checked" </c:if> /></div>      
        <div><span>体温检测</span><input type="checkbox" value="3" disabled="disabled" <c:if test="${dddtl1.option13 == 3}"> checked="checked" </c:if> /></div>
        <div><span>医学巡查</span><input type="checkbox" value="4" disabled="disabled" <c:if test="${dddtl1.option13 == 4}"> checked="checked" </c:if> /></div>
        <div><span>口岸区域内报告</span><input type="checkbox" value="5" disabled="disabled" <c:if test="${dddtl1.option13 == 5}"> checked="checked" </c:if> /></div>
        <div><span>境外官方机构通报</span><input type="checkbox" value="6" disabled="disabled" <c:if test="${dddtl1.option13 == 6}"> checked="checked" </c:if> /></div>
        <div><span>境外检测哨点通报</span><input type="checkbox" value="7" disabled="disabled" <c:if test="${dddtl1.option13 == 7}"> checked="checked" </c:if> /></div>
        <div><span>其他方式通报或发现</span><input type="checkbox" value="8" disabled="disabled" <c:if test="${dddtl1.option13 == 8}"> checked="checked" </c:if> /></div>
    </div>
    <div class="paragraphTitle_2"><span>二、临床表现</span></div>
    <div class="clinicalFeature" id="chkDiv">
        <div>
             <div><span>腋下体温测量(℃):</span><span>${dddtl1.option14}</span></div>
             <div class="clinicalFeature_1_2"><span>发病时间:</span><input type="text" value="${dddtl1.option67}" disabled="disabled"/></div>
        </div>
        <div>
             <div><span>A．畏寒</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option15 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option15 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option15 == 3}"> checked="checked" </c:if> /></div>
             <div><span>B．呼吸困难</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option16 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option16 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option16 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>C．咳嗽</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option17 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option17 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option17 == 3}"> checked="checked" </c:if> /></div>
             <div><span>D．咳血</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option18 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option18 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option18 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>E．胸痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option19 == 1}"> checked="checked" </c:if>/><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option19 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option19 == 3}"> checked="checked" </c:if> /></div>
             <div><span>F．呕吐</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option20 == 1}"> checked="checked" </c:if>/><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option20 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option20 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>G．腹泻</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option21 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option21 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option21 == 3}"> checked="checked" </c:if> /></div>
             <div><span>H．腹痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option22 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option22 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option22 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>I．头痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option23 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option23 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option23 == 3}"> checked="checked" </c:if> /></div>
             <div><span>J．肌肉痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option24 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option24 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option24 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>K．关节痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option25 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option25 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option25 == 3}"> checked="checked" </c:if> /></div>
             <div><span>L．眼眶痛</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option26 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option26 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option26 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>M．面色潮红</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option27 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option27 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option27 == 3}"> checked="checked" </c:if> /></div>
             <div><span>N．皮疹</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option28 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option28 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option28 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>O．黄疸</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option29 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option29 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option29 == 3}"> checked="checked" </c:if> /></div>
             <div><span>P．淤血（淤斑）</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option30 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option30 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option30 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>Q．淋巴结肿大</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option31 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option31 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option31 == 3}"> checked="checked" </c:if> /></div>
             <div><span>R．盗汗</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option32 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option32 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option32 == 3}"> checked="checked" </c:if> /></div>
        </div>
        <div>
             <div><span>S．颈项强直</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option33 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option33 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option33 == 3}"> checked="checked" </c:if> /></div>
        </div>
    </div>
    <div>
        <div class="clinicalFeature_other"><span>其他特异性症状:</span><input type="text" value="${dddtl1.option34}" disabled="disabled"/></div>
    </div>
    <div class="paragraphTitle_3"><span>三、流行病学因素调查</span></div>
    <div>
         <div style="float:left"><span>1．既往有无传染病病史？
<%--         <c:if test="${dddtl1.option35==1}"> --%>
<!--     	（有） -->
<%--     	 </c:if>   --%>
<%--     	 <c:if test="${dddtl1.option35==2}"> --%>
<!--     	 （无） -->
<%--     	 </c:if>      --%>
         </span>
         <span>有</span>
         <input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option35 == 1}"> checked="checked" </c:if>/>
         <span>无</span>
         <input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option35 == 2}"> checked="checked" </c:if> />
         </div>
         <div><span>如果有，具体情况:</span><input type="text" style="width:580px;height:25px" value="${dddtl1.option36}" disabled="disabled" /></div>
         <div><span>2. 发病前4周内旅行史，以及所来自国家/地区是否流行同类症状的疾病：</span></div>
         <div><input type="text" style="width:77%;height:25px" value="${dddtl1.option37}" disabled="disabled"/></div>
         <div><span>3．发病前2周内是否接触过类似症状的病人：</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option38 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option38 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option38 == 3}"> checked="checked" </c:if> /></div>
		 <c:if test="${dddtl1.option38 == 1}">
         <div><span>如果有，填写类似症状病人情况表：</span></div>
         <div>
             <table>
                  <tr><td>序号</td><td>病人姓名</td><td>发病时间</td><td>临床诊断</td><td>与本人关系</td><td>最后接触时间</td><td>接触方式</td><td>接触频率</td><td>接触地点</td></tr>
	              <c:if test="${not empty op39 }">
                  	<tr><td>1</td>
	                  	<c:forEach items="${op39}" var="row">
	                  		<td>${row}</td>
	                  	</c:forEach>
				 	</tr>	
	              </c:if>
	               <c:if test="${empty op39 }">
		              <tr>
	                  	<td>1</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
	                  </tr>
		           </c:if>
		           
                   <c:if test="${not empty op68 }">
                  	<tr><td>2</td>
	                  	<c:forEach items="${op68}" var="row">
	                  		<td>${row}</td>
	                  	</c:forEach>
				 	</tr>	
	              </c:if>
	               <c:if test="${empty op68 }">
		              <tr>
	                  	<td>2</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
	                  </tr>
		           </c:if>
		           
		           <c:if test="${not empty op69 }">
                  	<tr><td>3</td>
	                  	<c:forEach items="${op69}" var="row">
	                  		<td>${row}</td>
	                  	</c:forEach>
				 	</tr>	
	              </c:if>
	               <c:if test="${empty op69}">
		              <tr>
	                  	<td>3</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
	                  </tr>
		           </c:if>
             </table>
         </div>
         <div><span>填表说明</span></div>
         <div><span>与本人关系：（1）家庭成员（2）同事（3）社会交往（4）共用交通工具（5）其他</span></div>
         <div><span>接触方式：（1）与病人同进餐（2）与病人同处一室（3）与病人同一病区</span></div>
         <div><span>（4）与病人共用食具、茶具、毛巾、玩具等（5）接触病人分泌物、排泄物等</span></div>
         <div><span>（6）诊治、护理（7）探视病人（8）其他接触</span></div>
         <div><span>接触频率：（1）经常（2）有时（3）偶尔</span></div>
         <div><span>接触地点：（1）家（2）工作单位（3）学校（4）集体宿舍（5）医院（6）室内公共场所（7）其他</span></div>
       	</c:if>
         <div><span>4. 发病前2周内是否有野生动物、禽鸟类接触史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option40 == 1}"> checked="checked" </c:if>/><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option40 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option40 == 3}"> checked="checked" </c:if> /></div>
         <div><span>如果有，填写具体接触情况：</span><span class="linewidth">${dddtl1.option41}</span></div>
         <div><span>5. 发病前2周内有无感染环境暴露史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option42 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option42 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option42 == 3}"> checked="checked" </c:if> /></div>
         <div><span>如果有，填写具体接触情况：</span><span class="linewidth">${dddtl1.option43}</span></div>
         <div><span>6. 有无蚊虫叮咬史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option44 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option44 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option44 == 3}"> checked="checked" </c:if> /></div>
         <div><span>7．是否从事动物饲养、宰杀、捕捉或标本制作工作？</span><span>是</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option45 == 1}"> checked="checked" </c:if> /><span>否</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option45 == 2}"> checked="checked" </c:if> /></div>
         <div><span>如果是，具体情况：</span><span class="linewidth">${dddtl1.option46}</span></div>
         <div><span>8．是否为从事病原生物学研究或医务工作？</span><span>是</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option47 == 1}"> checked="checked" </c:if> /><span>否</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option47 == 2}"> checked="checked" </c:if> /></div>
         <div><span>如果是，具体情况：</span><span class="linewidth">${dddtl1.option48}</span></div>
         <div><span>9. 有无重点关注传染病预防接种史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option51 == 1}"> checked="checked" </c:if>/><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option51 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option51 == 3}"> checked="checked" </c:if> /></div>
         <div><span>如果有，请填写重点关注传染病预防接种情况：</span><span class="linewidth">${dddtl1.option52}</span></div> 
         <div><span>10．有无怀孕？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option53 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option53 == 2}"> checked="checked" </c:if> /></div>
         <div><span>11．有无晕机（车、船）史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option54 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option54 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option54 == 3}"> checked="checked" </c:if> /></div>
         <div><span>12．近期有无用药？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option55 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option55 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option55 == 3}"> checked="checked" </c:if> /></div>
         <div><span>如果有，用药情况</span><span class="linewidth">${dddtl1.option56}</span></div>
         <div><span>13．是否曾住院诊断？</span><span>是</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option57 == 1}"> checked="checked" </c:if> /><span>否</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option57 == 2}"> checked="checked" </c:if> /></div>
         <div><span>如果是，诊断结果</span><span class="linewidth">${dddtl1.option58}</span></div>
         <div><span>14．近期有无输血献血？</span><span>有</span><input type="checkbox"  disabled="disabled" <c:if test="${dddtl1.option59 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox"  disabled="disabled" <c:if test="${dddtl1.option59 == 2}"> checked="checked" </c:if> /></div>
         <div><span>如果有，具体情况</span><span class="linewidth">${dddtl1.option60}</span></div>
         <div><span>15.有无过敏史？</span><span>有</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option61 == 1}"> checked="checked" </c:if> /><span>无</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option61 == 2}"> checked="checked" </c:if> /><span>不详</span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option61 == 3}"> checked="checked" </c:if> /></div> 
         <div><span>如果有，填写过敏情形：</span><span class="linewidth">${dddtl1.option62}</span></div>
         <div><span>16.其他相关因素调查：</span><span class="linewidth">${dddtl1.option63}</span></div>
         <div><span class="linewidth"></span></div>
    </div>
    <div class="paragraphTitle_4"><span>四、初步判断及病例处理意见</span></div>
    <div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option64 == 1}"> checked="checked" </c:if> /></span>1．排除传染病可能，放行；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option64 == 2}"> checked="checked" </c:if> /></span>2．按照呼吸道传播途径传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option64 == 3}"> checked="checked" </c:if> /></span>3．按照消化道传播途径传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option64 == 4}"> checked="checked" </c:if> /></span>4．按照蚊媒传播途径传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option64 == 5}"> checked="checked" </c:if> /></span>5．按照其他途径（${dddtl1.option65}）传播传染病进行排查和处置；
         </div>
         <div>
                    <span><input type="checkbox" disabled="disabled" <c:if test="${dddtl1.option64 == 6}"> checked="checked" </c:if> /></span>6．其他
         </div>
         <div>
                                           检疫人员签名：<span></span>${dddtl1.option70}日期:<span></span><fmt:formatDate value="${dddtl1.decDate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
         </div>
    </div>
</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:400px;padding-bottom: 10px;">
			<input type="button" class="search-btn" style="display: inline;" value="下载"  onclick="loading()"/>
			<input type="button" class="search-btn" style="display: inline;" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
</body>
</html>