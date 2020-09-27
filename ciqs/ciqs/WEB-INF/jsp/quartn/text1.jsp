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
		location.href="downQuartnPdf"+location.search+"&index=3";
	}
</script>
</head>
<body>
    <h1>口岸传染病疑似病例转诊单</h1>
    <div style="margin-left: 80px;margin-right: 80px;">
    <table style="border: 1px solid #000;height:150px;width: 100%">
     <tr>
     <td class="tableLine">序号</td> <td class="tableLine">病例姓名</td> <td class="tableLine">性别</td> <td class="tableLine">国籍</td> <td class="tableLine">护照号/证件号码</td><td class="tableLine">检疫人员排查结果</td>
      </tr>
      <tr>
    	 <td class="tableLine">${obj.option1}</td><td class="tableLine">${obj.option2}</td><td class="tableLine">${obj.option3}</td><td class="tableLine">${obj.option4}</td><td class="tableLine">${obj.option5}</td><td class="tableLine">${obj.option6}</td>
      </tr>
       <tr>
    	 <td class="tableLine">${obj.option7}</td> <td class="tableLine">${obj.option8}</td><td class="tableLine">${obj.option9}</td><td class="tableLine">${obj.option10}</td><td class="tableLine">${obj.option11}</td><td class="tableLine">${obj.option12}</td>
      </tr>
       <tr>
    	 <td class="tableLine">${obj.option13}</td> <td class="tableLine">${obj.option14}</td><td class="tableLine">${obj.option15}</td><td class="tableLine">${obj.option16}</td><td class="tableLine">${obj.option17}</td><td class="tableLine">${obj.option18}</td>
      </tr>
       <tr>
    	 <td class="tableLine">${obj.option19}</td> <td class="tableLine">${obj.option20}</td><td class="tableLine">${obj.option21}</td><td class="tableLine">${obj.option22}</td><td class="tableLine">${obj.option23}</td><td class="tableLine">${obj.option24}</td>
      </tr>
      </table>
     <table style="margin: auto;width: 100%">
     <tr>
       <td class="tableLine_7_1">交通工具名称/航班号</td>
       <td class="tableLine_7_2" colspan="2">${obj.option25}/${obj.option26}</td>
       <td class="tableLine_7_3">出入境日期</td>
       <td class="tableLine_7_4" colspan="2">${obj.option43}/${obj.option27}</td>
     </tr>
     <tr>
       <td class="tableLine_8_1">检疫医师（签字）:</td>
       <td class="tableLine_8_2" colspan="2">
       		<c:if test="${not empty obj.option28}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option28}" alt="xx" /> 
       		</c:if>
       
       </td>
       <td class="tableLine_8_3">电话:</td>
       <td class="tableLine_8_4" colspan="2">${obj.option29}</td>
     </tr>
     <tr>
       <td class="tableLine_8_1">救护车号:</td>
       <td class="tableLine_8_2">${obj.option30}</td>
       <td class="tableLine_8_3">离开时间:</td>
       <td class="tableLine_8_4">${obj.option31}</td>
       <td class="tableLine_8_3">拟送医院:</td>
       <td class="tableLine_8_4">${obj.option32}</td>
     </tr>
     <tr>
       <td class="tableLine_8_1">救护车医师（签字）:</td>
       <td class="tableLine_8_2" colspan="2">
       		<c:if test="${not empty obj.option33}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option33}" alt="xx" /> 
       		</c:if>
      </td>
       <td class="tableLine_8_3">电话:</td>
       <td class="tableLine_8_4" colspan="2">${obj.option34}</td>
     </tr>
     <tr>
       <td colspan="6" class="tableLine_8_1">接受医院名称接诊医师（签字）:
       		<c:if test="${not empty obj.option35}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option35}" alt="xx" /> 
       		</c:if>
       </td>
     </tr>
     <tr>
       <td colspan="6" class="tableLine_11_1">诊断结果及处理意见 :${obj.option36}</td>
     </tr>
     <tr>
       <td colspan="6" class="tableLine_12_1">如果拒接受转诊，请填写原因：${obj.option37}</td>
     </tr>
      <tr>
       <td class="tableLine_8_1">主检医师（签字）:</td>
       <td class="tableLine_8_2">
       		<c:if test="${not empty obj.option38}">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${obj.option38}" alt="xx" /> 
       		</c:if>
       
       </td>
       <td class="tableLine_8_3">电话:</td>
       <td class="tableLine_8_4">${obj.option39}</td>
       <td class="tableLine_8_3">日期:</td>
       <td class="tableLine_8_4">${obj.option40}</td>
     </tr>
      <tr>
       <td colspan="6" class="tableLine_14_1">请病人接受医院做出诊断及处理意见后立即将此单传真至出入境检验检疫局，以便做好疫情后续管理工作。 </td>
     </tr>
   	 <tr>
       <td class="tableLine_8_1">传真号码:</td>
       <td class="tableLine_8_2" colspan="2">${obj.option41}</td>
       <td class="tableLine_8_3">联系电话:</td>
       <td class="tableLine_8_4" colspan="2">${obj.option42}</td>
     </tr>
       <tr>
       <td colspan="6" class="tableLine_14_1">
       本转诊单一式两联，一份由检验检疫局机构保存，另一联请救护车医师转交给接受医院转诊医师 </td>
     </tr>
    </table>
    </div>
    <div style="text-align: center;margin: auto;margin-top: 10px;width:400px;padding-bottom: 10px;">
			<input type="button" class="search-btn" style="display: inline;" value="下载"  onclick="loading()"/>
			<input type="button" class="search-btn" style="display: inline;" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
</body>
</html>