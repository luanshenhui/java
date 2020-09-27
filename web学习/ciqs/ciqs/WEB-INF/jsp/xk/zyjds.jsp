<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>质量监督检验检疫准予行政许可决定书</title>
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
<script type="text/javascript">
$(function(){
   var comp_name = $("#comp_name").val();
   var legal_name = $("#legal_name").val();
   var management_addr = $("#management_addr").val();
   var declare_date = new Date($("#declare_date").val());
   var approval_date = new Date($("#approval_date").val());
   var nowate =new Date();
   var declare_date_text = declare_date.getFullYear() +"年"+ (declare_date.getMonth()+1) +"月"+ declare_date.getDate() +"日";
   var approval_date_text = approval_date.getFullYear() +"年"+ (approval_date.getMonth()+1) +"月"+ approval_date.getDate() +"日";
   var nowate_text = nowate.getFullYear() +"年"+ (nowate.getMonth()+1) +"月"+ nowate.getDate() +"日";
   $("#comp_name_text").text(comp_name);
   $("#legal_name_text").text(legal_name);
   $("#management_addr_text").text(management_addr);
   $("#declare_date_text").text(declare_date_text);
   $("#approval_date_text").text(approval_date_text);
   $("#nowate_text").text(nowate_text);
});

</script>
</head>
<body>
<input type ="hidden" id="comp_name" value="${comp_name}" />
<input type ="hidden" id="legal_name" value="${legal_name}" />
<input type ="hidden" id="management_addr" value="${management_addr}" />
<input type ="hidden" id="declare_date" value="${declare_date}" />
<input type ="hidden" id="approval_date" value="${approval_date}" />
<div>
	<div class="title_style" style="margin-bottom: 5px;"><span>质量监督检验检疫</span></div>
	<div class="subtitle_style"  style="margin-bottom: 5px;"><span>准予行政许可决定书</span></div>
	<div class="subtitle_style"  style="margin-bottom: 5px;"><span>
	（&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;）<span style="text-decoration:line-through;">质</span>检
	 （&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;）许准字
	 〔&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;〕3号</span></div>
	<div class="subtitle_style" style="border-bottom:4px solid #000;"></div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 100px;margin-left: -172px;">申请人：</div>
		<div style="border-bottom:1px solid #000;width: 400px;display: inline-block"><span id="comp_name_text"></span></div>
	</div>
	<div style="margin-left: -50px;margin-bottom: 5px;">（境内申请人）身份证号或者统一社会信用代码/营业执照编号：</div>
	<div style="border-bottom:1px solid #000;width: 525px;height:24px;margin-left: 40px;margin-bottom: 15px;">     </div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 265px;margin-left: -93px;">住址/住所或商业登记地址：</div>
		<div style="border-bottom:1px solid #000;width: 320px;display: inline-block"><span id="management_addr_text"></span></div>
	</div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 445px;">（企业或者其他组织）法定代表人（负责人）：</div>
		<div style="border-bottom:1px solid #000;width: 240px;display: inline-block"><span id="legal_name_text"></span></div>
	</div>
	<div style="text-align: left;margin-top: 40px;">
		申请人于 <span id="declare_date_text"></span>向本局提出
		<div style="border-bottom:1px solid #000;width: 300px;display: inline-block"> 制造计量器具许可证核发</div>行政许可申请。
		本局于<span id="approval_date_text"></span>受理。经审查，该申请符合法定条件、标准，依照《中华人民共和国行政许可法》第三十八条第一款和
		<div style="border-bottom:1px solid #000;width: 300px;display: inline-block">《中华人民共和国计量法》</div>第
		<div style="border-bottom:1px solid #000;width: 60px;display: inline-block">  十二 </div> 条第
		<div style="border-bottom:1px solid #000;width: 30px;display: inline-block"> /</div> 款第 
		<div style="border-bottom:1px solid #000;width: 30px;display: inline-block">/ </div>项的规定，决定准予申请人
		<div style="border-bottom:1px solid #000;width: 300px;display: inline-block">制造计量器具许可证核发行政许可</div>。行政许可有效期至 
		<div style="border-bottom:1px solid #000;width: 50px;display: inline-block">2020</div>年 
		<div style="border-bottom:1px solid #000;width: 30px;display: inline-block">3</div> 月
		<div style="border-bottom:1px solid #000;width: 30px;display: inline-block"> 1</div> 日。
	</div>
	<div style="margin-left: 125px;">（行政机关印章）</div>
	<div>
		<div style="width: 260px;float: left;">
			<span id="nowate_text"></span>
		</div>
	</div>
</div>
<div style="margin-top:100px;text-align: center;" class="noprint">
	       <span> 
	        <input onClick="javascript:history.back();" type="button" class="btn" value="返回" />
	            <input type="button" value="打印" id="print" class="btn" onClick="javascript:window.print()" />
	      </span>
</div>
</body>
</html>