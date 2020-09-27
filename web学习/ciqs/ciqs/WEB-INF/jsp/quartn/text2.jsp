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
.tableLine {
	border: 1px solid #000;
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
		location.href="downQuartnPdf"+location.search+"&index=4";
	}
</script>
</head>
<body>
    <h1>采样知情同意书</h1>
     <table style="margin: auto;width: 665px">
     <tr>
       <td colspan="6" class="tableLine_10_1">旅客你好：</td>
     </tr>
      <tr>
       <td colspan="6" class="tableLine_14_1">
       由于你/您 的被监护人/你的同伴出现了以下一种或多种的症状：发热，咳嗽，呕吐，腹泻，计入痛等，检疫人员怀疑你/你的被监护人/你的同伴可能感染了传染病。为了保护你/你的被监护人
       /你的同伴及他人的身体健康，检疫人员需要从你/你的被监护人/你的同伴身上采集血液等样本进行实验检测，以排查传染病。采样及实验室检测不收任何费用。 </td>
     </tr>
   	 <tr>
       <td colspan="6" class="tableLine_10_1">请你阅读，理解以上内容并在下方签名。</td>
     </tr>
     <tr>
       <td colspan="6" class="tableLine_10_1">谢谢你的合作！</td>
     </tr>
      <tr>
       <td colspan="1" class="tableLine_10_1" valign="top">
       		<span>姓名：</span>
       </td>
        <td colspan="2" class="tableLine_10_1" valign="top">
        	<c:if test="${not empty obj.option1}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option1}" alt="xx" /> 
       		</c:if>
        </td>
       <td colspan="3" class="tableLine_10_1">日期：${obj.option2}</td>
     </tr>
    </table>
    <div style="height:100px"></div>
     <table style="margin: auto;width: 665px;padding-top:55px">
     <tr>
       <td colspan="6" class="tableLine_10_1">Dear passenger：</td>
     </tr>
      <tr>
       <td colspan="6" class="tableLine_14_1">Because you/your ward/your accompanier have one or more
       symptoms as follows:fever,cough,vomit,diarrhea,myalgia and so on,quarantine officials doubt that you/your
       ward may be infected with some kind of infectious disease.In order to protect you/your
       ward's and order person's health,quarantine officials need to take blood or other
       samples for the related lab tests.Sampling and laboratory testing does not change any fees
 </td>
     </tr>
   	 <tr>
       <td colspan="6" class="tableLine_10_1">if you understand the contents above,plase sign below</td>
     </tr>
     <tr>
       <td colspan="6" class="tableLine_10_1">thank you for your cooperation!</td>
     </tr>
      <tr>
       <td colspan="1" class="tableLine_10_1">Signature：
       <c:if test="${not empty obj.option3}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option3}" alt="xx" /> 
       		</c:if>
       </td>
       <td colspan="2" class="tableLine_10_1">
       <c:if test="${not empty obj.option3}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option3}" alt="xx" /> 
       		</c:if>
       </td>
       <td colspan="3" class="tableLine_10_1">Date：${obj.option4}</td>
     </tr>
    </table>
    <div style="text-align: center;margin: auto;margin-top: 10px;width:400px;padding-bottom: 10px;">
			<input type="button" class="search-btn" style="display: inline;" value="下载"  onclick="loading()"/>
			<input type="button" class="search-btn" style="display: inline;" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
</body>
</html>