<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>口岸传染病可疑病例医学排查记录表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
h1{
    text-align: center;
    font-size: 30px;
}
table{
    margin-top: 30px;
    font-size: 25px;
    line-height:32px;    
}
table tr td{
    text-align:left;
}
.tableLine_2_1 span,.tableLine_2_3 span,.tableLine_3_1 span,.tableLine_3_3 span{
    float:right;
}
.tableLine_2_2,.tableLine_2_4{
    width:230px
}
.tableLine_2_2 input,.tableLine_3_4 input,.tableLine_24_2 input{
    width:170px;
    height:21px;
}
.tableLine_2_4 select{
    height:25px;
}
.tableLine_3_2 select{
    width:175px;
    height:25px;
}
.tableLine_5_1{
    height:180px;
    border: 1px solid #000;
}
.tableLine_12_1,.tableLine_15_1,.tableLine_18_1,.tableLine_21_1,.tableLine_26_1,.tableLine_30_1,.tableLine_32_1{
   height:60px
}
.tableLine_1_1,.tableLine_4_1,.tableLine_6_1,.tableLine_10_1,.tableLine_20_1,.tableLine_23_1,.tableLine_28_1,.tableLine_31_1{
   font-weight: 600;
}
</style>
<script type="text/javascript">
	function loading(){
		location.href="downQuartnPdf"+location.search+"&index=2";
	}
</script>
</head>
<body>
    <h1>口岸传染病可疑病例医学排查记录表</h1>
    <table>
     <tr>
       <td colspan="4" class="tableLine_1_1">一、基本情况</td>
     </tr>
     <tr>
        <td class="tableLine_2_1">姓名<span>：</span></td>
        <td class="tableLine_2_2">${dddtl2.option1}</td>
        <td class="tableLine_2_3">性别<span>：</span></td>
        <td class="tableLine_1_4">${dddtl2.option2==0?"男":"女"}</td>
     </tr>
      <tr>
        <td class="tableLine_3_1">身份证件类型<span>：</span></td>
        <td class="tableLine_3_2">${dddtl2.option3}</td>
        <td class="tableLine_3_3">号码<span>：</span></td>
        <td class="tableLine_3_4">${dddtl2.option4}</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_4_1">二、病例主述</td>
     </tr>
     <tr>
      <td colspan="4" class="tableLine_5_1">${dddtl2.option5}</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_6_1">三、体格检查</td>
     </tr>
     <tr>
       <td class="tableLine_7_1">体温℃:</td>
       <td class="tableLine_7_2">${dddtl2.option6}</td>
       <td class="tableLine_7_3">脉搏次/分:</td>
       <td class="tableLine_7_4">${dddtl2.option7}</td>
     </tr>
     <tr>
       <td class="tableLine_8_1">呼吸次/分:</td>
       <td class="tableLine_8_2">${dddtl2.option8}</td>
       <td class="tableLine_8_3">血压/mmHg:</td>
       <td class="tableLine_8_4">${dddtl2.option9}</td>
     </tr>
     <tr>
       <td class="tableLine_9_1">其他：</td>
       <td colspan="3" class="tableLine_9_2">${dddtl2.option10}</td>
     </tr>
     <tr>
       <td class="tableLine_13_1">检疫人员签名：</td>
	   <td class="tableLine_13_1">
       		<c:if test="${not empty dddtl2.option11}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option11}" alt="xx" /> 
       		</c:if>
	   </td>
       <td class="tableLine_13_1">日期：</td>
       <td class="tableLine_13_1">${dddtl2.option12}</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_10_1">四、实验室检查（如果有）:</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_11_1">（一）血常规检查结果 </td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_12_1">${dddtl2.option13}</td>
     </tr>
      <tr>
       <td class="tableLine_13_1">检疫人员签名：</td>
       <td class="tableLine_13_1">
        <c:if test="${not empty dddtl2.option14}">
 		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option14}" alt="" />   
 		</c:if>  
       </td>
       <td class="tableLine_13_1">日期：</td>
       <td class="tableLine_13_1">${dddtl2.option15}</td>
     </tr>
      <tr>
       <td colspan="4" class="tableLine_14_1">（二）快速试剂检测结果: </td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_15_1">${dddtl2.option16}</td>
     </tr>
      <tr>
       <td class="tableLine_16_1">检疫人员签名：</td>
       <td class="tableLine_16_2">
        <c:if test="${not empty dddtl2.option17}">
      	<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option17}" alt="" /> 
      	</c:if>
       </td>
       <td class="tableLine_16_3">日期：</td>
       <td class="tableLine_16_4">${dddtl2.option18}</td>
     </tr>
      <tr>
       <td colspan="4" class="tableLine_17_1">（三）X光检查（如果有） </td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_18_1">${dddtl2.option19}</td>
     </tr>
      <tr>
       <td class="tableLine_19_1">检疫人员签名：</td>
       <td class="tableLine_19_1">
        <c:if test="${not empty dddtl2.option20}">
       	<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option20}" alt="" /> 
       </c:if>
       </td>
       <td class="tableLine_19_1">日期：</td>
       <td class="tableLine_19_1">${dddtl2.option21}</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_20_1">五、初步诊断意见及病例处理意见</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_21_1">${dddtl2.option22}</td>
     </tr>
      <tr>
       <td class="tableLine_22_1">检疫人员签名：</td>
       <td class="tableLine_22_2">
       <c:if test="${not empty dddtl2.option23}">
       	<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option23}" alt="" />
       </c:if>
       </td>
       <td class="tableLine_22_3">日期：</td>
       <td class="tableLine_22_4">${dddtl2.option24}</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_23_1">六、如果送医院</td>
     </tr>
     <tr>
	     <td colspan="2" class="tableLine_24_1">专用救护车接病人时间:</td>
	     <td colspan="2" class="tableLine_24_2">${dddtl2.option25}</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_25_1">医院最终诊断结果：</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_26_1">${dddtl2.option26}</td>
     </tr>
     <tr>
       <td class="tableLine_27_1">核实人员签名：</td>
       <td class="tableLine_27_2">
       <c:if test="${not empty dddtl2.option27}">
       	<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option27}" alt="" />
       </c:if>
       </td>
       <td class="tableLine_27_3">日期：</td>
       <td class="tableLine_27_4">${dddtl2.option28}</td>
    </tr>
     <tr>
       <td colspan="4" class="tableLine_28_1">七、如果确诊为传染病病例</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_29_1">密切接触者追踪及后续监管情况：</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_30_1">${dddtl2.option29}</td>
     </tr>
     <tr>
       <td class="tableLine_30_1">负责人员签名：</td>
       <td class="tableLine_30_2">
        <c:if test="${not empty dddtl2.option30}">
        <img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option30}" alt="" />
        </c:if>
       </td>
       <td class="tableLine_30_3">日期：</td>
       <td class="tableLine_30_4">${dddtl2.option31}</td>
    </tr>
     <tr>
       <td colspan="4" class="tableLine_31_1">八、消毒处理情况</td>
     </tr>
     <tr>
       <td colspan="4" class="tableLine_32_1">${dddtl2.option32}</td>
     </tr>
     <tr>
       <td class="tableLine_33_1">负责人员签名：</td>
       <td class="tableLine_33_2">
        <c:if test="${not empty dddtl2.option33}">
	       <img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${dddtl2.option33}" alt="" />
	    </c:if>
       </td>
       <td class="tableLine_33_3">日期：</td>
       <td class="tableLine_34_4">${dddtl2.option34}</td>
    </tr>
    </table>
    <div style="text-align: center;margin: auto;margin-top: 10px;width:400px;padding-bottom: 10px;">
			<input type="button" class="search-btn" style="display: inline;" value="下载"  onclick="loading()"/>
			<input type="button" class="search-btn" style="display: inline;" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
</body>
</html>