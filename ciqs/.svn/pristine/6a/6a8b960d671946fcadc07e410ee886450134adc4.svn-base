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
});

</script>
</head>
<body>
<div>
	<div class="title_style" style="margin-bottom: 5px;"><span>检验检疫处理通知书</span></div>
<!-- 	<div class="subtitle_style"  style="margin-bottom: 5px;"><span>EngLish</span></div> -->
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 100px;margin-left: 372px;">编号：</div>
		<div style="border-bottom:1px solid #000;width: 200px;display: inline-block">${obj.decl_no}</div>
	</div>
	<div class="subtitle_style" style="border-bottom:4px solid #000;"></div>
	<div style="margin-bottom: 15px;">
		<div><span id="comp_name_text"></span></div>
		<div style="border-bottom:1px solid #000;width:360px;display: inline-block;margin-left: -320px;margin-top:30px;">${book.dec_org_name}</div>
	</div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 365px;margin-left: 0px;">根据中华人民共和国有关法律法规，经对</div>
		<div style="border-bottom:1px solid #000;width: 225px;display: inline-block">${goods}</div>
	</div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 125px;margin-left: -110px;">检验检疫,因</div>
		<div style="border-bottom:1px solid #000;width: 465px;display: inline-block">${obj.deal_rsn}</div>
	</div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 125px;margin-left: -110px;">需做</div>
		<div style="border-bottom:1px solid #000;width: 350px;display: inline-block">${obj.deal}</div>
		<div style="display: inline-block;width: 166px;">处理，特此通知。</div>
	</div>

	<div style="display: inline-block;width: 754px;margin-left: 0px;">we hereby notify you that in accordance with the relevant laws</div>
	<div style="display: inline-block;width: 754px;margin-left: 0px;">and regulations of the People's Republic of</div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 125px;margin-left: -110px;">China</div>
		<div style="border-bottom:1px solid #000;width: 150px;display: inline-block">*******</div>
		<div style="display: inline-block;width: 166px;">should be</div>
		<div style="border-bottom:1px solid #000;width: 150px;display: inline-block">**********</div>
	</div>
	<div style="margin-bottom: 15px;">
		<div style="display: inline-block;width: 125px;margin-left: -220px;">due to</div>
		<div style="border-bottom:1px solid #000;width:360px;display: inline-block">***********</div>
	</div>
	
	 <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>
</body>
</html>