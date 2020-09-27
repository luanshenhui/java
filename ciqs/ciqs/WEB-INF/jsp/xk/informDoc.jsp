<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>限期卫生整改通知书</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div{
    width:700px;
    text-align: center;    
    margin: 0 auto;
    font-size:16px;
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
	text-align:	right;
    font-size:18px;
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
@media print {
.noprint{display:none}
}
</style>
<script language="javascript" type="text/javascript">

	$(function(){
	   if($("#ok").val()=="ok"){
	      alert("提交成功!");
	      window.close();
	   }
	});
</script>
</head>
<body>
<form action="<%=request.getContextPath()%>/dc/informSubmitDoc"  method="post">
<div>
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_ZGS" />
<input type ="hidden" name="DocId" value="${doc.docId}" />
<input type ="hidden" id="ok" value="${ok}" />
	<div class="title_style" style="margin-bottom: 5px;">
	  <p align="center" ><strong>限期卫生整改通知书</strong><strong> </strong></p>
	</div>
	<div class="subtitle_style" style="text-align:center;margin-bottom: 5px;">
	（&nbsp;&nbsp;&nbsp;${doc.option1}&nbsp;&nbsp;&nbsp;）检卫监字
	（&nbsp;&nbsp;&nbsp;${doc.option2}&nbsp;&nbsp;&nbsp;）第 
	 ${doc.option3}&nbsp;号 
	</div>
  	<div class="subtitle_style" style="border-bottom:4px solid #000;"></div>
	
<div style="margin-bottom: 15px;">
		<br />
		<div style="display: inline-block;text-align:left;width: 700px;margin-left: 50px;">
		  <p ><u>${dto.comp_name}</u>： </p>
  		</div>
  		<br />
  		<br />
		<div style="text-align:left;width: 700px;display: inline-block;margin-left: 60px;">
			经对你单位的卫生监督，发现存在下列问题: 
		</div>
	</div>
	<div style="margin-bottom: 15px;text-align:left;padding-left:10px;">

	  	${doc.option5}

    </div>
	<div style="text-align:left;width: 700px;display: inline-block;margin-left: -0px;">根据以上存在问题，特作如下处理：  </div>
	<div style="text-align:left;width: 700px;display: inline-block;margin-left: -0px;">
		<input type="checkbox"  id="option14" value="${doc.option14}"  <c:if test="${doc.option14 == '0'}"> checked="checked" </c:if>  name="option14" />请你单位于 ${doc.option6}年 ${doc.option7}月${doc.option8}日前进行整改，并提交整改报告。 
	</div>
    <div style="text-align:left;width: 700px;display: inline-block;margin-left: -0px;">
    	<input type="checkbox" id="option15"  name="option15" value="${doc.option15}" <c:if test="${doc.option15 == '0'}"> checked="checked" </c:if> />在整改合格前暂停开展检验检疫有关的业务。 
    </div>
  	<div style="text-align:left;width: 700px;height:40px;display: inline-block;margin-left: -0px;">
  		<input type="checkbox" id="option16" name="option16" value="${doc.option16}"  <c:if test="${doc.option16 == '0'}"> checked="checked" </c:if> />应采取的整改措施：
  	</div>
  	<div style="text-align:left;padding-left:10px;">
  		${doc.option9}
	  	
	</div>
    <div style="text-align:left;width: 700px;height:100px;display: inline-block;margin-left: -0px;">对不予整改或抵制卫生监督的行为，将根据《国境卫生检疫法》及相关规定进行处理。</div>
    <div style="text-align:center;width: 700px;display: inline-block;margin-left: -0px;">
      	被监督方签收：
      	<c:if test="${not empty doc.option10}">
      		<img src="/ciqs/showVideo?imgPath=${doc.option10}" width="50px" height="50px" />
      	</c:if>
      	监督员签字：
      	<c:if test="${not empty doc.option12}">
      		<img src="/ciqs/showVideo?imgPath=${doc.option12}"  width="50px" height="50px" />
      	</c:if>
    </div>
    <div style="text-align:center;width: 700px;display: inline-block;margin-left: -0px;">
      	<div style="float:left;width:100px;margin-left:180px">${doc.option11}</div>
   
      	<div style="float:left;width:100px;margin-left:75px">${doc.option13}</div>
    </div>
  <div class="subtitle_style" style="margin-top:40px;border-bottom:4px solid #000;"></div>
    <div>
		<div style="width: 260px;float: left;">
			<div style="width: 700px;text-align:left; inline-block">备注：本意见书一式两联，第一联监督机构留存，第二联交被监督单位。</div>  
		</div>
	</div>
</div>
<div style="text-align: center; margin-top:40px;" class="noprint">
      <span> 
            <input type="button" value="打印" id="print" class="btn" onclick="javascript:window.print()" />
            <!-- <input type="submit" value="提交" id="print" class="btn" /> -->
      </span>
</div>
</form>
</body>
</html>