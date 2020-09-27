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
</head>
<body>
<form action="/ciqs/xk/submitDoc"  method="post">
<div>
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_ZGS" />
<input type ="hidden" name="DocId" value="${doc.docId}" />
	<div class="title_style" style="margin-bottom: 5px;">
	  <p align="center" ><strong>限期卫生整改通知书</strong><strong> </strong></p>
	</div>
	<div class="subtitle_style" style="text-align:center;margin-bottom: 5px;">
	（<input type="text" style="width:50px;border: none;outline: none" name="option1" value="${doc.option1}" placeholder="请填写" />）检卫监字
	（<input type="text" style="width:50px;border: none;outline: none" name="option2" value="${doc.option2}" placeholder="请填写" />）第 
	 <input type="text" style="width:50px;border: none;outline: none" name="option3" value="${doc.option3}" placeholder="请填写" />号 
	</div>
  	<div class="subtitle_style" style="border-bottom:4px solid #000;"></div>
	
<div style="margin-bottom: 15px;">
		<br />
		<div style="display: inline-block;text-align:left;width: 700px;margin-left: 50px;">
		  <p ><u>${comp_name}</u>： </p>
  		</div>
  		<br />
  		<br />
		<div style="text-align:left;width: 700px;display: inline-block;margin-left: 60px;">
			经对你单位的卫生监督，发现存在下列问题: 
		</div>
	</div>
	<div style="margin-bottom: 15px;">
	  <div>
	  	<textarea style="border: none;outline: none" rows="8" cols="80" name="option4" placeholder="请填写">
	  	${doc.option4}
	  	</textarea>
	  </div>
    </div>
	<div style="text-align:left;width: 700px;display: inline-block;margin-left: -0px;">根据以上存在问题，特作如下处理：  </div>
	<div style="text-align:left;width: 700px;display: inline-block;margin-left: -0px;">
		<input type="checkbox" name="option5" value="${doc.option5}" />请你单位于     年   月   日前进行整改，并提交整改报告。 
	</div>
    <div style="text-align:left;width: 700px;display: inline-block;margin-left: -0px;">
    	<input type="checkbox" name="option6" value="${doc.option6}" />在整改合格前暂停开展检验检疫有关的业务。 
    </div>
  	<div style="text-align:left;width: 700px;height:40px;display: inline-block;margin-left: -0px;">
  		<input type="checkbox" name="option7" value="${doc.option7}"/>应采取的整改措施：
  	</div>
  	<div>
	  	<textarea style="border: none;outline: none" rows="6" cols="80" name="option8" placeholder="请填写">
	  	${doc.option8}
	  	</textarea>
	</div>
    <div style="text-align:left;width: 700px;height:100px;display: inline-block;margin-left: -0px;">对不予整改或抵制卫生监督的行为，将根据《国境卫生检疫法》及相关规定进行处理。</div>
    <div style="text-align:center;width: 700px;display: inline-block;margin-left: -0px;">
      	被监督方签收：<input type="text" style="border: none; outline: none" size="4" name="option9" value="${doc.option9}" placeholder="请填写" />
      	监督员签字：<input type="text" style="border: none;outline: none" size="4" name="option10" value="${doc.option10}" placeholder="请填写" />
    </div>
    <div style="text-align:center;width: 700px;display: inline-block;margin-left: -0px;">
      	<input type="text" style="border: none;outline: none" size="2" name="option11" value="${doc.option11}" placeholder="yyyy" />年
      	<input type="text" style="border: none;outline: none" size="2" name="option12" value="${doc.option12}" placeholder="mm" />月
      	<input type="text" style="border: none;outline: none" size="2" name="option13" value="${doc.option13}" placeholder="dd" />日
      	&nbsp;
      	<input type="text" style="border: none;outline: none" size="2" name="option14" value="${doc.option14}" placeholder="yyyy" />年
      	<input type="text" style="border: none;outline: none" size="2" name="option15" value="${doc.option15}" placeholder="mm" />月
      	<input type="text" style="border: none;outline: none" size="2" name="option16" value="${doc.option16}" placeholder="dd" />日
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
            <input type="submit" value="提交" id="print" class="btn" />
      </span>
</div>
</form>
</body>
</html>