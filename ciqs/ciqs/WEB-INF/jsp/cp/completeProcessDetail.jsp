<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>全过程查询</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>	
<style type="text/css">
 #title_a{color:#ccc}
 #title_a:hover{
 	color:white;
 }
</style>
</head>
<body  class="bg-gary">
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="${ctx}/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript">
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
/*  	 $.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId=${dto.license_dno}&DocType=D_PT_H_L_0",
    		type:"get",
    		dataType:"json",
    		success:function(data){
	    		if(data.status=="OK"){
					var license_dno="${dto.license_dno}";
					$("#jdnote").append("<a href='#this' style='padding-left:40px' onclick='openJdBook(\"" + license_dno + "\")'>决定书</a>");
	    		}
    		}
    	});  */
 	
	// 申报环节显示信息
	$("#declare_user_text").text($("#declare_user_hide").val());
	if($("#declare_date_hide").val() !=null && $("#declare_date_hide").val() !=""){
		$("#time_1").text($("#declare_date_hide").val().substring(0,$("#declare_date_hide").val().length-3));
	}
	// 受理环节显示信息
	if($("#approval_result").val() !="" && typeof $("#approval_result").val() != 'undefined'){
		$("#approval_user_text").text($("#approval_user_hide2").val());
	}
	if($("#approval_result").val() !=null && $("#approval_result").val() !=""){
		$("#time_2").text($("#approval_date_hide2").val().substring(0,$("#approval_date_hide2").val().length-3));
	}
	// 评审环节显示信息
	if($("#review_result_hide").val() != ""){
		$("#review_user_text").text($("#review_user_hide").val());
		if($("#review_date_hide").val() !=null && $("#review_date_hide").val() !=""){
			$("#time_3").text($("#review_date_hide").val().substring(0,$("#review_date_hide").val().length-3));
		}
	}
	// 终止环节
// 	if($("#zzdate").val() != ""){
// 		$("#user_text8").text($("#psn").val());
// 		if($("#zzdate").val() !=null && $("#zzdate").val() !=""){
// 			$("#date_text8").text($("#zzdate").val().substring(0,$("#zzdate").val().length-3));
// 		}
// 	}
	if($("#zzdate").val() != ""){
		$("#user_text8").text($("#psn").val());
		if($("#zzdate").val() !=null && $("#zzdate").val() !=""){
			$("#time_7").text($("#zzdate").val().substring(0,$("#zzdate").val().length-3));
		}
	}
	
	
	// 决定环节显示信息
	$("#jd_user_text").text($("#jd_user_hide").val());
	var jd_date_hide_str = $("#jd_date_hide").val();
	//jd_date_hide_str = jd_date_hide_str.substring(0, jd_date_hide_str.length - 2);
	if(jd_date_hide_str !=null && jd_date_hide_str !=""){
		$("#time_4").text(jd_date_hide_str.substring(0,jd_date_hide_str.length-3));
	}
	$("#jdsj").text(jd_date_hide_str);
	
	if($("#declare_date_hide").val() !="" && $("#approval_date_hide").val() !=""){
		$("#hour1").text("+"+getHour($("#declare_date_hide").val(),$("#approval_date_hide").val()));
	}else{
		$("#hour1").text("-");
	}
	
	if($("#approval_date_hide").val() !="" && $("#review_date_hide").val() !=""){
		$("#hour2").text("+"+getHour($("#approval_date_hide").val(),$("#review_date_hide").val()));
	}else{
		$("#hour2").text("-");
	}
	
	if($("#review_date_hide").val() !="" && jd_date_hide_str !=""){
		$("#hour3").text("+"+getHour($("#review_date_hide").val(),jd_date_hide_str));
	}else{
		$("#hour3").text("-");
	}
	
	/* if($("#declare_date_hide").val() !="" && jd_date_hide_str !=""){
		$("#z_hour").text(getZhour($("#declare_date_hide").val(),jd_date_hide_str));
	}else if($("#declare_date_hide").val() !="" && jd_date_hide_str ==""){
		$("#z_hour").text(getZhour($("#declare_date_hide").val(),null));
	}else{
		$("#z_hour").text("-");
	} */
	// 环节显示颜色
	if($("#declare_date_hide").val() != "" ){
		$("#kbq").attr("class","icongreen");
	}
	if($("#approval_result").val() != ""){
		$("#kb").attr("class","icongreen");
	}
	if($("#review_result_hide").val() !="" && $("#review_result_hide").val() !=null){
		$("#fh").attr("class","icongreen");
	}
	if(jd_date_hide_str != ""){
		$("#jl").attr("class","icongreen");
	}
	
	if($("#yqdate").val() != "" && typeof $("#yqdate").val() != 'undefined'){
		$("#qx").attr("class","icongreen");
		$("#user_text6").text($("#yquser").val());
	    $("#time_5").text($("#yqdate").val().substring(0,$("#yqdate").val().length-3));
	}
	/* if($("#bgtype").val() == "2" || $("#bgtype").val() == "3" || $("#bf_date").val() != ""){
		$("#bg").attr("class","icongreen");
		$("#user_text7").text($("#bgpsn").val());
		if($("#bf_date").val() != ""){
			$("#time_6").text($("#bf_date").val().substring(0,$("#bf_date").val().length-3));
		}else{
			$("#time_6").text($("#bgdate").val().substring(0,$("#bgdate").val().length-3));
		}
	} */
	//alert($("#apply_type").val());
	if (typeof($("#zztext").val()) != "undefined" && $("#zztext").val() !="" /* && $("#apply_type").val() !="2" && $("#apply_type").val() !="3" */) { 
  		$("#zzxh").attr("class","icongreen");
	}
	var time = ciqFormatTime(1,4);
	
	if(time ==""){
		$("#z_hour").text("");
		$("#z_hour_title").text("");
	}else{
		$("#z_hour").text(time);
	}
	// 如果没有图片或视频不存在就删除环节
    if($("#declare_date_hide").val() =="" || $("#declare_date_hide").val() ==null){
    	$("#tab1").remove();
    	$("#div01").remove();
    }
    
    if($("#approval_result").val() =="" || $("#approval_result").val() ==null){
    	$("#tab2").remove();
    	$("#div02").remove();
    }
    
    if($("#review_result_hide").val() =="" || $("#review_result_hide").val() ==null){
    	$("#tab3").remove();
    	$("#div03").remove();
    }
    if($("#jd_date_hide").val() =="" || $("#jd_date_hide").val() ==null){
    	$("#tab4").remove();
    	$("#div04").remove();
    }
    
	/* var ss=new Date()-new Date($("#lsh_approval_date").val());
    if(!$("#time_3").val() && ss>259254866){
    	$("#fh").attr("class","iconred");
    } */
    
});

function openJdBook(license_dno){
// 	  window.open("${ctx}/xk/toInformDoc?license_dno"+license_dno);
	  	window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+license_dno);
}


// 历史时间计算
function getZhour(startDate,endDate){
    if(startDate !=null && endDate !=null){
		startDate=startDate.substring(0, startDate.length-3);
		endDate=endDate.substring(0, endDate.length-3);
	}
	var hour = "";
	var mm = "";
    if(endDate == null){
    	var date1 = new Date(startDate);
    	var date2 = new Date(); 
    	hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
    	mm = ((date2.getTime() - date1.getTime())/(1000 * 60 ));
    }else{
    	var date1 = new Date(startDate);
    	var date2 = new Date(endDate); 
    	hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60);
    	mm = ((date2.getTime() - date1.getTime())/(1000 * 60 ));
    }
 
  	var jnum = ((Math.floor(mm))/60).toFixed(0);
	hour = parseInt(jnum);
	mm = (Math.floor(mm))%60;

	if(hour == 0){
		hour ="00";
	}
	if(hour < 10 && hour>=1){
		hour ="0"+hour;
	}
	if(mm == 0){
		mm ="00";
	}

	if(mm < 10 && mm>=1){
		mm ="0"+mm;
	}
    return hour+":"+mm;
}

function toSdhz(license_dno,doc_type){
	$.ajax({
		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType="+doc_type,
		type:"get",
		dataType:"json",
		success:function(data){
			if(data.status=="OK"){
				location = "${ctx}/xk/toSdhzShowDpf?license_dno="+license_dno+"&doc_type="+doc_type;
				//window.open("${ctx}/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
			}else{
				alert(data.results);
			}
		}
});
}

/* 申请受理不予告知*/
function byWinShow(id,license_dno,obj){
	$.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_BY_GZ",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
					location = "${ctx}/xk/toBysls?id="+id+"&license_dno="+license_dno+"&declare_date="+obj;
					//window.open("${ctx}/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
    			}else{
    				alert(data.results);
    			}
    		}
    });
}	
/* 申请受理不予告知*/
function byWinShow2(id,license_dno,obj){
	$.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_BY_GZ2",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
					location = "${ctx}/xk/toBysls2?id="+id+"&license_dno="+license_dno+"&declare_date="+obj;
					//window.open("${ctx}/xk/toByslsOld?id="+id+"&declare_date="+obj+"&license_dno="+license_dno+"&comp_name="+comp_name);
    			}else{
    				alert("暂时没有数据！");
    			}
    		}
    });
}	
/* 申请材料补正告知书 */	
function bzWinShow(id,license_dno,obj){
	$.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_SQ_BZ",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
					location = "${ctx}/xk/toBzgzs?id="+id+"&license_dno="+license_dno+"&declare_date="+obj;
    			}else{
    				alert(data.results);
    			}
    		}
    });	
}
/* 申请受理不予决定*/
function byWinShowOver(id,license_dno,comp_name,legal_name,management_addr,declare_date,approval_date){//不予告知
	$.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_BU_SL",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
    				location = "${ctx}/xk/byjdsShow?"
		 	+"id="+id
		 	+"&comp_name="+comp_name
		 	+"&legal_name="+legal_name
		 	+"&management_addr="+management_addr
		 	+"&declare_date="+declare_date
		 	+"&approval_date="+approval_date;
    			}else{
    				alert(data.results);
    			}
    		}
    });	
}	
/* 准予受理决定书 */
function zyWinShow(id,license_dno,comp_name,legal_name,management_addr,declare_date,approval_date){
 	$.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_SQ_SL",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
    				location = "${ctx}/xk/zyjdsShow?"
				 		+"id="+id
					 	+"&comp_name="+comp_name
					 	+"&legal_name="+legal_name
					 	+"&management_addr="+management_addr
					 	+"&declare_date="+declare_date
					 	+"&approval_date="+approval_date;
    			}else{
    				alert(data.results);
    			}
    		}
    });	
}
/* 准予受理告知书 */
function slWinShow(id,license_dno,comp_name,legal_name,management_addr,contacts_name,contacts_phone){
    $.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_SL_GZ",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
    				location = "${ctx}/xk/toSlgzs?"
				 	+"id="+id
				 	+"&license_dno="+license_dno
				 	+"&comp_name="+comp_name
				 	+"&legal_name="+legal_name
				 	+"&management_addr="+management_addr
				 	+"&contacts_name="+contacts_name
				 	+"&contacts_phone="+contacts_phone;
    			}else{
    				alert(data.results);
    			}
    		}
    });	
}

/**
 * 计算2个日期的天数
 */
function getDay(startDate){
	var date1 = new Date(startDate); 
	var date2 = new Date();
	var day = "";
	day = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 *24);
    return day;
}

/**
 * 计算2个日期小时差
 */
function getHour(startDate,endDate){
    if(startDate !=null && endDate !=null){
		startDate=startDate.substring(0, startDate.length-3);
		endDate=endDate.substring(0, endDate.length-3);
	}
	var hour = "";
	var mm = "";
    if(endDate == null){
    	var date1 = new Date(startDate);
    	var date2 = new Date(); 
    	//hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
    	mm = ((date2.getTime() - date1.getTime())/(1000 * 60 ))/60;
    }else{
    	var date1 = new Date(startDate);
    	var date2 = new Date(endDate); 
    	//hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60);
    	mm = ((date2.getTime() - date1.getTime())/(1000 * 60 ))/60;
    }
	
	if((mm+"").indexOf(".") != -1){
		mm = (mm+"").substring(0, (mm+"").indexOf(".")+3);
	}
	//mm = mm.toFixed(2);
	if(mm==0){
		mm="0.00";
	}
	if(startDate==null || startDate ==''){
		hour = "0.00";
	}
	
	hour = parseFloat(mm);
    return hour.toFixed(2);
}
function dfbWinShow(license_dno,id,doc_type){
	window.open("${ctx}/cp/dfbWinShow?license_dno="+license_dno+"&id="+id+"&doc_type="+doc_type);
}

function looktext(license_dno,id){
	window.open("${ctx}/cp/lookbook?license_dno="+license_dno+"&id="+id);
}

function sqsWinShow(id,license_dno){
	$.ajax({
		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_SQS",
		type:"get",
		dataType:"json",
		success:function(data){
			if(data.status=="OK"){
				location="${ctx}/xk/toSqsPdf?"
			 	+"id="+id
			 	+"&license_dno="+license_dno;
			}else{
				alert(data.results);
			}
		}
	});	
}

 function getBeforeDate(n,d){  
 	d=new Date(d);
    var year = d.getFullYear();  
    var mon=d.getMonth()+1;  
    var day=d.getDate();  
    if(day <= n){  
            if(mon>1) {  
               mon=mon-1;  
            }else {  
             year = year-1;  
             mon = 12;  
             };  
           }  
          d.setDate(d.getDate()-n);  
          year = d.getFullYear();  
          mon=d.getMonth()+1;  
          day=d.getDate();  
     s = year+"-"+(mon<10?('0'+mon):mon)+"-"+(day<10?('0'+day):day);  
     return s;  
  }  

function passResult(id,license_dno,str){
	    $.ajax({
    			url:"${ctx}/xk/getResult?id="+id+"&ProcMainId="+license_dno+"&DocType="+str+"&math="+Math.random(),
    			type:"get",
    			dataType:"json",
    			success:function(data){
	    			if(data.status=="OK"){
	    				location="/ciqs/xk/passResult?id="+id+"&ProcMainId="+license_dno+"&DocType="+str;
	    			}else{
	    				alert(data.results);
	    			}
    			}
    		}); 
    			
}


function pdfGz(id,license_dno,comp_name,legal_name,management_addr,contacts_name,contacts_phone){
    $.ajax({
    		url:"${ctx}/xk/getResult?ProcMainId="+license_dno+"&DocType=D_SL_GZ",
    		type:"get",
    		dataType:"json",
    		success:function(data){
    			if(data.status=="OK"){
    				location="${ctx}/xk/toSlgzsGz?"
				 	+"id="+id
				 	+"&license_dno="+license_dno
				 	+"&comp_name="+comp_name
				 	+"&legal_name="+legal_name
				 	+"&management_addr="+management_addr
				 	+"&contacts_name="+contacts_name
				 	+"&contacts_phone="+contacts_phone;
    			}else{
    				alert(data.results);
    			}
    		}
    });	
}

function getmPlace(place_number){
	window.scroll(0, document.getElementById(place_number).offsetTop-1200+910);
}

var onchangeWs_type = "";
function gaizhang(no,ws_type){
	if (typeof(ws_type) == "undefined") {
		ws_type = onchangeWs_type;
	}
	$.ajax({
		url:"${ctx}/xk/getResult?ProcMainId="+no+"&DocType="+ws_type,
		type:"get",
		dataType:"json",
		success:function(data){
			if(data.status == "OK"){
				location="<%=request.getContextPath()%>/xk/toDpf?license_dno="+no+"&doc_type="+ws_type;
			}else{
				alert("未保存文书数据!");
			}
		}
	});		
}

function zgsShow(no){
	$.ajax({
		url:"${ctx}/xk/getResult?ProcMainId="+no+"&DocType=D_PT_H_L_0",
		type:"get",
		dataType:"json",
		success:function(data){
			if(data.status == "OK"){
				window.open("<%=request.getContextPath()%>/xk/toInformDoc?license_dno="+no);
			}else{
				alert("暂无整改书!");
			}
		}
    });			
}

function sqsDpf(no,ws_type){
    location="<%=request.getContextPath()%>/xk/toDpf?license_dno="+no+"&doc_type="+ws_type;		
}

function look(license_dno){
	$.ajax({
		url : "/ciqs/expFoodPOF/findFile?main_id="+license_dno,
		type : "GET",
		dataType : "json",
		success : function(data) {
			if (data.status == "OK") {
				window.location.href="/ciqs/expFoodPOF/download?fileName="+data.path;
			} else {
				return alert("暂无附件！");
			}
		}
	});
}
</script>
<input type="hidden" id="package_no" value="${dto.license_dno}"/>
<input type="hidden" id="dtoId" value="${dto.id}"/>
<input type="hidden" id="declare_date_hide" value="<fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
<input type="hidden" id="declare_user_hide" value="${dto.declare_user}"/>
<input type="hidden" id="approval_user_hide" value="${dto.approval_user}"/>
<input type="hidden" id="approval_user_hide2" value="${dto.approval_user2}"/>
<input type="hidden" id="approval_date_hide" value="<fmt:formatDate value="${dto.approval_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
<input type="hidden" id="review_user_hide" value="${dto.approval_users_name}"/>
<input type="hidden" id="review_result_hide" value="${dto.review_result}"/>
<input type="hidden" id="jd_user_hide" value="${dto.jd_user}"/>
<input type="hidden" id="review_date_hide" value="${fileuploadDate}"/>
<input type="hidden" id="jd_date_hide" value="${dto.review_date}"/>
<input type="hidden" id="lsh_approval_date" value="${dto.approval_date}"/>
<input type="hidden" id="approval_date_hide2" value="<fmt:formatDate value="${dto.approval_date2}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
<input type="hidden" id="zztext" value="${zztext}"/>
<input type="hidden" id="approval_result" value="${dto.approval_result}"/>
<input type="hidden" id="bf_date" value="<fmt:formatDate value="${bf_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
<input type="hidden" id="apply_type" value="${dto.apply_type}" />
<input type="hidden" id="approval_result" value="${dto.approval_result}" />
<c:if test="${not empty licenseeventdto2_GS }">
	<input type="hidden" id="yqdate" value="<fmt:formatDate value="${licenseeventdto2_GS.opr_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
	<input type="hidden" id="yquser" value="${licenseeventdto2_GS.opr_psn}"/>
</c:if>

<div class="freeze_div_dtl" style="position: fixed;top:0px;width:100%">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><span class="font-24px" style="color:white;">行政许可 /</span><a id="title_a" href="${ctx}/cp/findLists">口岸卫生许可证核发</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg"  style=" height:235px;background-color: #f0f2f5;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<li>申报</li>
<li>受理</li>
<li>审查</li>
<li>决定与送达</li>
<li>期限与公示</li>
<!-- <li style="width:160px">变更、延续、补发</li> -->
<li style="width:160px">终止、撤销、注销</li>
<li></li>
<li></li>
</ul>
<ul class="flow-icon">
  <li id="kbq" class="iconyellow"><div style="width:160px" class="hour white font-12px"><span id="hour1" ></span></div><a onclick="getmPlace('tab1')"><img src="${ctx}/static/show/images/cp/cp1.png" width="80" height="80" /></a></li>
  <li id="kb" class="iconyellow"><div style="width:160px" class="hour white font-12px"><span id="hour2" ></span></div><a onclick="getmPlace('tab2')"><img src="${ctx}/static/show/images/cp/cp2.png" width="80" height="80" /></a></li>
  <li id="fh" class="iconyellow"><div style="width:160px" class="hour white font-12px"><span id="hour3" ></span></div><a onclick="getmPlace('tab3')"><img src="${ctx}/static/show/images/cp/cp3.png" width="80" height="80" /></a></li>
  <li id="jl" class="iconyellow"><div style="width:160px" class="hour white font-12px"><span id="proc_cysj_hour" ></span></div><a onclick="getmPlace('tab4')"><img src="${ctx}/static/show/images/cp/cp4.png" width="80" height="80" /></a></li>
  <li id="qx" class="iconyellow"><div style="width:160px" class="hour white font-12px"><span id="proc_cysj_hour" ></span></div><a onclick="getmPlace('tab5')"><img src="${ctx}/static/show/images/cp/cp5.png" width="80" height="80" /></a></li>
  <%-- <li id="bg" style="width:180px" class="iconyellow"><div style="width:180px" class="hour white font-12px"><span id="proc_cysj_hour" ></span></div><a onclick="getmPlace('tab6')"><img src="${ctx}/static/show/images/cp/cp6.png" width="80" height="80" /></a></li> --%>
  <li id="zzxh" class="iconyellow"><div style="width:180px" class="hour white font-12px"><span id="proc_7_hour" ></span></div><a onclick="getmPlace('tab5')"><img src="${ctx}/static/show/images/cp/cp7.png" width="80" height="80" /></a></li>
 
  <li style="width:280px" class="white font-16px font-weight" > <br />
   <span id="z_hour_title">历时：</span><span id="z_hour" ></span></li>
</ul>
<ul class="flow-info" >
<li>
  <span id="declare_user_text" ></span><br />
  <span class="font-10px" ><span id="time_1" ></span></span>
</li>
<li>
  <span id="approval_user_text" ></span><br />
  <span class="font-10px" ><span id="time_2" ></span></span>
</li>
<li>
  <span id="review_user_text" ></span><br />
  <span class="font-10px" ><span id="time_3" ></span></span>
</li>
<li>
  <span id="jd_user_text" ></span><br />
  <span class="font-10px" ><span id="time_4" ></span></span>
</li>
<li>
  <span id="user_text6" ></span><br />
  <span class="font-10px" ><span id="time_5" ></span></span>
</li>
<!-- <li style="width:180px">
  <span id="user_text7" ></span><br />
  <span class="font-10px" ><span id="time_6" ></span></span>
</li> -->
<li>
  <span id="user_text8" ></span><br />
  <span class="font-10px" ><span id="time_7" ></span></span>
</li>
<li class="font-18px"></li>
<li class="font-18px"></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_dtl" style="margin-top:290px;">
</div>

<div class="margin-chx">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
    <tr class="table_xqlbbj">
      <td width="200" height="35" align="center" valign="bottom">单位名称</td>
      <td width="100" height="35" align="center" valign="bottom">单位地址</td>
      <td width="150" height="35" align="center" valign="bottom">经营地址</td>
      <td width="150" height="35" align="center" valign="bottom">经营面积</td>
      <td width="100" height="35" align="center" valign="bottom">法定代表人</td>
      <td width="150" height="35" align="center" valign="bottom">联系人</td>
      <td width="150" height="35" align="center" valign="bottom">联系电话</td>
      <td width="150" height="35" align="center" valign="bottom">电子邮箱</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="200" height="90" align="center">${dto.comp_name}</td>
      <td width="100" height="90" align="center">${dto.comp_addr}</td>
      <td width="150" height="90" align="center">${dto.management_addr}</td>
      <td width="150" height="90" align="center">${dto.management_area}</td>
      <td width="100" height="90" align="center">${dto.legal_name}</td>
      <td width="150" height="90" align="center">${dto.contacts_name}</td>
      <td width="150" height="90" align="center">${dto.contacts_phone}</td>
      <td width="150" height="90" align="center">${dto.mailbox}</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="120" height="35" align="center" valign="bottom">传真</td>
      <td width="120" height="35" align="center" valign="bottom">从业人员人数</td>
      <td width="130" height="35" align="center" valign="bottom">通过体系认证</td>
      <td width="150" height="35" align="center" valign="bottom">经营类别</td>
      <td width="100" height="35" align="center" valign="bottom">申请经营范围</td>
      <td width="100" height="35" align="center" valign="bottom">申请类型</td>
      <td width="150" height="35" align="center" valign="bottom" colspan="2">原卫生证许可号</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="120" height="90" align="center">${dto.fax}</td>
      <td width="120" height="90" align="center">${dto.employee_num}</td>
      <td width="130" height="90" align="center">
    	<c:if test="${dto.certificate_numver == 0}">
			否
		</c:if>
		<c:if test="${dto.certificate_numver == 1}">
			是
		</c:if>
      </td>
      <td width="150" height="90" align="center">
     	<c:forEach items="${dto.management_type}" var="items" varStatus="aa">
			<c:if test="${aa.index != 0}">
				,
			</c:if>
			<c:if test="${items == 1}">
				食品生产
			</c:if>
			<c:if test="${items == 2}">
				食品流通
			</c:if>
			<c:if test="${items == 3}">
				餐饮服务
			</c:if>
			<c:if test="${items == 4}">
				饮用水供应
			</c:if>
			<c:if test="${items == 5}">
				公共场所
			</c:if>
		</c:forEach>
      </td>
      <td width="100" height="90" align="center">${dto.apply_scope}</td>
      <td width="100" height="90" align="center">
     	<c:if test="${dto.apply_type == 1}">
			初次
		</c:if>
		<c:if test="${dto.apply_type == 2}">
			变更
		</c:if>
		<c:if test="${dto.apply_type == 3}">
			延续
		</c:if>
		<c:if test="${dto.apply_type == 4}">
			临时经营
		</c:if>
		<c:if test="${dto.apply_type == 5}">
			公共场所
		</c:if>
      </td>
      <td width="150" height="90" align="center" colspan="2">${dto.hygiene_license_number}</td>
    </tr>
  </table>
</div>
<div id="tab1" class="title-cxjg" >申报</div>
<div id="div01" class="margin-chx">
<table  width="100%" border="0" class="table-xqlb">
	<tr id="tr1">
		<td width='150' class='bg-gary flow-td-bord'>申报</td>
		<td align='left' style="padding-left:25px">
		            申报时间: <span class='blue'><fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></span>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申报单位: <span class='blue'>${dto.comp_name}</span>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请类型: 
			<c:if test="${dto.apply_type == 1}">
				<span class='blue'>初次</span>
			</c:if>
			<c:if test="${dto.apply_type == 2}">
				<span class='blue'>变更</span>
			</c:if>
			<c:if test="${dto.apply_type == 3}">
				<span class='blue'>延续</span>
			</c:if>
			<c:if test="${dto.apply_type == 4}">
				<span class='blue'>临时经营</span>
			</c:if>
			<c:if test="${dto.apply_type == 5}">
				<span class='blue'>公共场所</span>
			</c:if>
		</td>
	</tr>
</table>
</div>
<div id="tab2" class="title-cxjg" >受理</div>
<div id="div02" class="margin-chx">
<table id="tab2" width="100%" border="0" class="table-xqlb">
	  <tr>
	    <td width="150" class="table_xqlbbj2">受理</td>
    	<td align='left' style="padding-left:25px">
    	<c:if test="${not empty dto.approval_result}">
	    	受理时间:<span class='blue'>
	    		<fmt:formatDate value="${dto.approval_date2}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
	    	</span>
	    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    	受理人员:
	    	<span class='blue'>${dto.approval_user2}</span>
	        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                        受理状态:
              <c:if test="${dto.approval_result == 1}">
					<span class='blue'>材料不全</span>
			  </c:if>		
			  <c:if test="${dto.approval_result == 2}">
					<span class='blue'>不符合受理条件</span>
			  </c:if>			
			  <c:if test="${dto.approval_result == 3}">
					<span class='blue'>符合受理条件</span>
			  </c:if>	
			  <c:if test="${dto.approval_result == 4}">
					<span class='blue'>不需要取得行政许可</span>
			  </c:if>				
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="toSdhz('${dto.license_dno}','D_SDHZ')">送达回证</a>
			<a href="#" onclick="gaizhang('${dto.license_dno}','D_SDHZ')">(盖章)</a>
			
			<c:if test="${dto.approval_result == 2}">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="byWinShow('${dto.id}','${dto.license_dno}','${dto.declare_date}')">不予受理决定书</a>
			<a href="#this" onclick="passResult('${dto.id}','${dto.license_dno}','D_BY_GZ')">(盖章)</a>
			</c:if>
			<c:if test="${dto.approval_result == 3}">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="slWinShow('${dto.id}','${dto.license_dno}','${dto.comp_name}',
											'${dto.legal_name}','${dto.management_addr}',
											'${dto.contacts_name}','${dto.contacts_phone}')">准予受理决定书</a>
<!-- 											<a href="#this" onclick="pdfGz('${dto.id}','${dto.license_dno}','${dto.comp_name}', -->
<!-- 											'${dto.legal_name}','${dto.management_addr}', -->
<!-- 											'${dto.contacts_name}','${dto.contacts_phone}')">(盖章)</a> -->
											<a href="#this" onclick="passResult('${dto.id}','${dto.license_dno}','D_SL_GZ')">(盖章)</a>

			</c:if>
		</c:if>	 
		</td>
      </tr>
</table>
<c:if test="${not empty licenseeventdto}">
<table width="100%" style="margin-top:5px" border="0" class="table-xqlb">
	  <tr>
	    <td width="150" class="table_xqlbbj2">材料补正</td>
    	<td align='left' style="padding-left:25px">
	    	受理时间:<span class='blue'>
	    		<fmt:formatDate value="${licenseeventdto.opr_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
	    	</span>
	    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    	受理人员:
	    	<span class='blue'>${licenseeventdto.opr_psn}</span>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="bzWinShow('${dto.id}','${dto.license_dno}','${dto.declare_date}')">申请材料补正告知书</a>
			<a href="#this" onclick="passResult('${dto.id}','${dto.license_dno}','D_SQ_BZ')">(盖章)</a>
		</td>
      </tr>
</table>
</c:if>
</div>
<div id="tab3" class="title-cxjg" >审查</div>
<div id="div03" class="margin-chx">
<table width="100%" border="0" class="table-xqlb">
	  <tr>
	    <td width="150" class="table_xqlbbj2">现场审查</td>
    	<td align='left' style="padding-left:25px">
    	<c:if test="${not empty dto.review_result}">
	    	审查时间:<span class='blue'>${fileuploadDate}</span>
	    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    	审查人员:<span class='blue'>${dto.approval_users_name}</span>
	        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	                        审查结果:
              <c:if test="${dto.review_result == 0}">
					<span class='blue'>合格</span>
			  </c:if>		
			  <c:if test="${dto.review_result == 1}">
					<span class='blue'>不合格</span>
			  </c:if>				
			<c:if test="${not empty dto.iszg}">			
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href = "#" onclick="zgsShow('${row.license_dno}')">整改书</a>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href = "#"  onclick="toSdhz('${row.license_dno}','D_PT_H_L_13')">送达回证</a>
				<a href="#" onclick="gaizhang('${dto.license_dno}','D_PT_H_L_13')">(盖章)</a>
			</c:if>
			
		</c:if>	 
    	<a href="#" style="margin-left: 30px;" onclick="looktext('${dto.license_dno}','${dto.id}')">电子笔录</a>
		</td>
      </tr>
</table>
<table width="100%" style="margin-top:5px" border="0" class="table-xqlb">
	  <tr>
	    <td width="150" class="table_xqlbbj2">现场审查表</td>
    	<td align='left' style="padding-left:25px">
	    	<c:forEach items="${dto.management_type}" var="items" varStatus="aa">
				<c:if test="${aa.index != 0}">
					<br/>
				</c:if>
				<c:if test="${items == 1}">
					<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_7')">食品生产现场审查表</a>
				</c:if>
				<c:if test="${items == 2}">
					<c:forEach items="${scbList}" var="cbitems" varStatus="cbitem">
						<c:if test="${cbitems == 'D_PT_H_L_8'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_8')">食品流通现场审查表(一)</a>
						</c:if>
						<c:if test="${cbitems == 'D_PT_H_L_9'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_9')">食品流通现场审查表(二)</a>
						</c:if>						
					</c:forEach>
				</c:if>
				<c:if test="${items == 3}">
					<c:forEach items="${scbList}" var="cbitems" varStatus="cbitem">
						<c:if test="${cbitems == 'D_PT_H_L_1'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_1')">餐饮服务现场审查表(一)</a>
						</c:if>
						<c:if test="${cbitems == 'D_PT_H_L_2'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_2')">餐饮服务现场审查表(二)</a>
						</c:if>
						<c:if test="${cbitems == 'D_PT_H_L_3'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_3')">餐饮服务现场审查表(三)</a>
						</c:if>
						<c:if test="${cbitems == 'D_PT_H_L_4'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_4')">餐饮服务现场审查表(四)</a>
						</c:if>
						<c:if test="${cbitems == 'D_PT_H_L_5'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_5')">餐饮服务现场审查表(五)</a>
						</c:if>
						<c:if test="${cbitems == 'D_PT_H_L_6'}">
							<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_6')">餐饮服务现场审查表(六)</a>
						</c:if>
					</c:forEach>	
				</c:if>
				<c:if test="${items == 4}">
					<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_10')">饮用水供应现场审查表</a>
				</c:if>
				<c:if test="${items == 5}">
					<a href="#" style="margin-right:60px;" onclick="dfbWinShow('${dto.license_dno}','${dto.id}','D_PT_H_L_11')">公共场所现场审查表</a>
				</c:if>
			</c:forEach>
		</td>
      </tr>
</table>
</div>
<div id="tab4" class="title-cxjg" >决定与送达</div>
<div id="div04" class="margin-chx">
<table width="100%" border="0" class="table-xqlb">
	  <tr>
	    <td width="150" class="table_xqlbbj2">决定</td>
    	<td align='left' style="padding-left:25px" id="jdnote">
    	<c:if test="${not empty dto.review_result}">
	    	决定时间:<span id="jdsj" class='blue'></span>
	    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    	决定人员:<span class='blue'>${dto.jd_user}</span>								
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href = "#"  onclick="toSdhz('${row.license_dno}','D_SDHZ2')">送达回证</a>
			<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ2')">(盖章)</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<c:if test="${dto.jd_result == 2 && dto.jd_sp != 1}">
            	<a href = "#this" onclick="byWinShowOver('${dto.id}','${dto.license_dno}','${dto.comp_name}',
				'${dto.legal_name}','${dto.management_addr}',
				'${dto.declare_date}','${dto.approval_date}')">不准予许可决定书</a>
				<a href="#this" onclick="passResult('${dto.id}','${dto.license_dno}','D_BU_SL')">(盖章)</a>
	        </c:if>
	        <c:if test="${dto.jd_sp == 1}">
            	<a href = "#this" onclick="zyWinShow('${dto.id}','${dto.license_dno}','${dto.comp_name}',
				'${dto.legal_name}','${dto.management_addr}',
				'${dto.declare_date}','${dto.approval_date}')">准予许可决定书</a>
				<a href="#this" onclick="passResult('${dto.id}','${dto.license_dno}','D_SQ_SL')">(盖章)</a>
	        </c:if>
	        <c:if test="${dto.jd_sp == 1}">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#this" onclick="sqsWinShow('${dto.id}','${dto.license_dno}')">申请书</a>
			<a href="#this" onclick="sqsDpf('${dto.license_dno}','D_SQS')">(盖章)</a>
			</c:if>
		</c:if>	 
		</td>
      </tr>	  
</table>
</div>

<c:if test="${not empty licenseeventdto2.opr_date}">
<div id="tab6" class="title-cxjg" >期限与公示</div>
<div id="div06" class="margin-chx">
<table width="100%" border="0" class="table-xqlb">
	  <tr>
	  	<td width="150" class="table_xqlbbj2">
		  	期限与公示
	  	</td>
    	<td align='left' style="padding-left:25px" id="jdnote">

    	操作时间 :	
		<span class='blue'>
			<fmt:formatDate value="${licenseeventdto2.opr_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
		</span>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	延长期理由: <span class='blue'>${dto.prolong}</span>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;								
    	操作人:<span class='blue'>${licenseeventdto2.opr_psn}</span>
    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
    	工作提醒附件：<input type="button" onclick="look('${dto.license_dno}')"  value="查看" />	
		</td>
      </tr>
</table>
</div>
</c:if>

<%-- <c:if test="${dto.apply_type == 2 || dto.apply_type == 3 || not empty bf_date}">
<div id="tab6" class="title-cxjg" >变更、延续、补发</div>
<div id="div06" class="margin-chx">
<table width="100%" border="0" class="table-xqlb">
	  <tr>
	  	<td width="150" class="table_xqlbbj2">
		  	<c:if test="${dto.apply_type == 2}">
				变更
			</c:if>
			<c:if test="${dto.apply_type == 3}">
				延续
			</c:if>
			<c:if test="${not empty bf_date}">
				补发
			</c:if>
	  	</td>
    	<td align='left' style="padding-left:25px" id="jdnote">
		    <input type="hidden" id="bgdate" value="<fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
		    <input type="hidden" id="bgpsn" value="${dto.declare_user}"/>
		    <input type="hidden" id="bgtype" value="${dto.apply_type}"/>
    	申请时间 :
    		<c:if test="${dto.apply_type == 2 || dto.apply_type == 3}">
				<span class='blue'>
					<fmt:formatDate value="${dto.declare_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				</span>
			</c:if>
			<c:if test="${not empty bf_date}">
				<span class='blue'>
					<fmt:formatDate value="${bf_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
				</span>
			</c:if>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<c:if test="${empty bf_result}">
    	审核结果: <span class='blue'>同意</span>
       	</c:if>
        <c:if test="${not empty bf_result}">
        	<span class='blue'>${bf_result}</span>
        </c:if>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;								
    	审核人:<span class='blue'>${dto.declare_user}</span>
		</td>
      </tr>
</table>
</div>
</c:if> --%>

<c:if test="${not empty zztext }">
<div id="tab5" class="title-cxjg" >终止、撤销、注销 </div>
<div id="div05" class="margin-chx">
<table width="100%" border="0" class="table-xqlb">
	  <tr>
	    <td id="textbg" width="150" class="table_xqlbbj2">
	    ${zztext}
	    <input type="hidden" id="zzdate" value="<fmt:formatDate value="${zzdate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
	    <input type="hidden" id="psn" value="${psn}"/>
	    </td>
    	<td align='left' style="padding-left:25px">
    	申请时间 :<span class='blue'><fmt:formatDate value="${zzdate}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></span>
    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	审核结果:
    	
    	<c:if test="${zztext =='终止'}" >
	    	<c:if test ="${result == 1}"><span class='blue'>申请事项依法不需要取得卫生许可</span></c:if>
			<c:if test ="${result == 2}"><span class='blue'>申请事项依法不属于本检验检疫机构职权范围</span></c:if>
			<c:if test ="${result == 3}"><span class='blue'>申请人未在规定期限内补正有关申请材料</span></c:if>
			<c:if test ="${result == 4}"><span class='blue'>申请人撤回卫生许可申请</span></c:if>
			<c:if test ="${result == 5}"><span class='blue'>其他依法应当终止办理卫生许可</span></c:if>				
	    	<br/>
	    	<a href="#" onclick="byWinShow2('${dto.id}','${dto.license_dno}','${dto.declare_date}')">不予受理决定书</a>
			<a href="#this" onclick="passResult('${dto.id}','${dto.license_dno}','D_BY_GZ2')">(盖章)</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href = "#"  onclick="toSdhz('${row.license_dno}','D_SDHZ5')">送达回证</a>
			<a href = "#"  onclick="gaizhang('${row.license_dno}','D_SDHZ5')">(盖章)</a>
    	</c:if>
    	<c:if test="${zztext =='注销'}" >
	    	<c:if test="${result == 1}"><span class='blue'>卫生许可有效期届满未延续</span></c:if>
	    	<c:if test="${result == 2}"><span class='blue'>法人或者其他组织依法终止</span></c:if>
	    	<c:if test="${result == 3}"><span class='blue'>被许可人申请注销卫生许可</span></c:if>
	    	<c:if test="${result == 4}"><span class='blue'>卫生许可依法被撤销、撤回，或者卫生许可证件依法被吊销</span></c:if>
	    	<c:if test="${result == 5}"><span class='blue'>因不可抗力导致卫生许可事项无法实施</span></c:if>
	    	<c:if test="${result == 6}"><span class='blue'>法律、法规规定的应当注销卫生许可的其他情形</span></c:if>
		</c:if>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;								
    	审核人:<span class='blue'>${psn}</span>
		</td>
      </tr>
</table>
</div>
</c:if>
<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
		<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
<div class="title-cxjg" style="height:540px;"></div>
</body>
</html>
