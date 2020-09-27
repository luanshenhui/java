<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@ include file="/common/resource_show.jsp"%>
  	<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"></link>
  	<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"></link>
  	<style>
  	.muy{
  		border-bottom: 1px solid #dcdcdc;
  		padding-right: 20px;
  		height: 60px;
   		line-height: 50px;
  	}
  	
  	.muy2{
  		border-bottom: 1px solid #dcdcdc;
  		height: 60px;
  		line-height: 50px;
  		padding-top: 5px;
  	}
  	
  	#title_a{color:#ccc}
 	#title_a:hover{
 		color:white;	
 	}
	</style>
  	<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
	<script src="${ctx}/static/viewer/assets/js/bootstrap.min.js"></script>
	<script src="${ctx}/static/viewer/dist/viewer.js"></script>
	<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<!-- 	<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script> -->
	
	<script type="text/javascript">
		$(function(){
			$("#imgd1").hide();
			$("#CuPlayerMiniV").hide();
			  $.ajax({
    			url:"getData"+location.search+"&math="+Math.random(),
    			type:"get",
    			scriptCharset:"utf-8",
    			dataType:"json",
    			success:function(data){
    			var info=data.data[0];
//     			$("#name_1").text(info.DEC_ORG_NAME);
//     			$("#time_1").text(info.APPLY_DATE);
//     			$("#name_2").text(info.CONSIGNEE_CNAME);
//     			$("#time_2").text(info.RECEIPT_DATE);
//     			$("#name_3").text(info.CONSIGNEE_CNAME);
//     			$("#time_3").text(info.RECEIPT_DATE);
    			
    			/* 	$("table").eq(1).children().find("td").eq(0).html("<span>"+info.DEC_ORG_NAME+"</span>");
    				$("table").eq(1).children().find("td").eq(1).html("<span>"+info.APPLY_DATE+"</span>");
    				$("table").eq(1).children().find("td").eq(2).html("<span>"+info.ORG_REG_NO+"</span>");
    				$("table").eq(1).children().find("td").eq(3).html("<span>"+info.CERT_NO+"</span>");
    				$("table").eq(1).children().find("td").eq(4).html("<span>"+info.CERT_TYPE+"</span>");
    				$("table").eq(1).children().find("td").eq(5).html("<span>"+info.ORG_CODE+"</span>");
    				$("table").eq(1).children().find("td").eq(6).html("<span>"+info.DEPT_CODE+"</span>");
    				$("table").eq(1).children().find("td").eq(7).html("<span>"+info.RECEIPT_NO+"</span>");
    				$("table").eq(1).children().find("td").eq(8).html("<span>"+info.CONSIGNEE_CNAME+"</span>");
    				$("#table").eq(1).children().find("td").eq(9).html("<span>"+info.DEST_COUNTRY+"</span>");
    				$("table").eq(1).children().find("td").eq(10).html("<span>"+info.SHIPPING_DATE+"</span>"); */
    				$("#procMainId").val(info.MAIN_ID);
    				var url ="/ciqs/origplace/jumpText?id="+info.ID+"&main_id="+info.MAIN_ID;
    				var url2 ="/ciqs/origplace/myinfo?id="+info.ID+"&main_id="+info.MAIN_ID;
    				$("#myhref").attr("href",url);
    				$(".myinfo").attr("href",url2+"&type=1");
    				$("#fpxin").attr("href",url2+"&type=2");
    				$("#zsxx").attr("href",url2+"&type=3");
    				//申情书信息
    				$("#dest_country").append("<span>"+info.DEST_COUNTRY+"</span>");
    				$("#dec_org_name").append("<span>"+info.DEC_ORG_NAME+"</span>");
    				$("#cert_no").append("<span>"+info.CERT_NO+"</span>");
    				$("#cert_type").append("<span>"+info.CERT_TYPE+"</span>");
//     				$("#receipt_no").append("<span>"+info.RECEIPT_NO+"</span>");
//     				$("#apply_fob_val").append("<span>"+info.APPLY_FOB_VAL+"</span>");
//     				$("#org_reg_no").append("<span>"+info.ORG_REG_NO+"</span>");
    				$("#transfer_country").append("<span>"+info.TRANSFER_COUNTRY+"</span>");
    				$("#trade_mode").append("<span>"+info.TRADE_MODE+"</span>");
//     				$("#shipping_date").append("<span>"+info.SHIPPING_DATE+"</span>");
    				/********************************************改动*******************************************/
    				$("#cag_seq").append("<span>"+info.CAG_SEQ+"</span>");
    				$("#hs_code").append("<span>"+info.HS_CODE+"</span>");
    				$("#cag_name").append("<span>"+info.CAG_NAME+"</span>");
    				$("#cag_imp_comp").append("<span>"+info.CAG_IMP_COMP+"</span>");
    				$("#num_weight").append("<span>"+info.NUM_WEIGHT+"</span>");
    				$("#fob_val").append("<span>"+info.FOB_VAL+"</span>");
    				for(var i=0;i<1;i++){
    				var tr="<tr>"+
    				 "<td width='16%' height='5' align='center' valign='bottom'>"+info.CAG_SEQ+"</td>"+
    				 "<td width='16%' height='5' align='center' valign='bottom'>"+info.HS_CODE+"</td>"+
    				 "<td width='16%' height='5' align='center' valign='bottom'>"+info.CAG_NAME+"</td>"+
    				 "<td width='16%' height='5' align='center' valign='bottom'>"+info.CAG_IMP_COMP+"</td>"+
    				 "<td width='16%' height='5' align='center' valign='bottom'>"+info.NUM_WEIGHT+"</td>"+
    				 "<td width='16%' height='5' align='center' valign='bottom'>"+info.FOB_VAL+"</td><tr>";
    				$("#listtd").append(tr);
    				}
    				/********************************************改动*******************************************/
    				$("#prod_comp").append("<span>"+info.PROD_COMP+"</span>");
    				
    				$("#consignee_cname").append("<span>"+info.CONSIGNEE_CNAME+"</span>");
    				
    				//发票信息
    				$("#cert_no2").append("<span>"+info.CERT_NO+"</span>");
    				$("#receipt_no2").append("<span>"+info.RECEIPT_NO+"</span>");
    				$("#receipt_date").append("<span>"+info.RECEIPT_DATE+"</span>");
//     				$("#mat_no").append("<span>"+info.MAT_NO+"</span>");
//     				$("#num_cag_disc").append("<span>"+info.NUM_CAG_DISC+"</span>");
    				$("#pric_item").append("<span>"+info.PRIC_ITEM+"</span>");
    				$("#cag_pric").append("<span>"+info.CAG_PRIC+"</span>");
//     				$("#spec_item").append("<span>"+info.SPEC_ITEM+"</span>");
    				
    				$("#exp_comp").append("<span>"+info.EXP_COMP+"</span>");
    				$("#consignee_cname3").append("<span>"+info.CONSIGNEE_CNAME+"</span>");
    				$("#prod_comp3").append("<span>"+info.PROD_COMP+"</span>");
    				$("#trans_type").append("<span>"+info.TRANS_TYPE+"</span>");
    				$("#purpose_country").append("<span>"+info.PURPOSE_COUNTRY+"</span>");
    				$("#mat_no3").append("<span>"+info.MAT_NO+"</span>");
    				$("#cag_name3").append("<span>"+info.CAG_NAME+"</span>");
    				$("#pack_num").append("<span>"+info.PACK_NUM+"</span>");
    				$("#hs_code3").append("<span>"+info.HS_CODE+"</span>");
    				$("#orig_place_std").append("<span>"+info.ORIG_PLACE_STD+"</span>");
    				$("#m_weight").append("<span>"+info.M_WEIGHT+"</span>");
    				$("#receipt_no_receipt_date").append("<span>"+info.RECEIPT_NO+","+info.RECEIPT_DATE+"</span>");
//     				$("#exp_stat").append("<span>"+info.EXP_STAT+"</span>");
//     				$("#visa_stat").append("<span>"+info.VISA_STAT+"</span>");
//     				$("#rmk").append("<span>"+info.RMK+"</span>");
    				
    				$("#look").html("<img src='/ciqs/static/show/images/photo-btn.png'  onclick='toImgDetail(\""+info.CERT_FILE+"\")'/>");
    				$("#file_date").html("<span>"+info.FILE_DATE+"</span>");//归档时间
    				$("#fiel_psn").html("<span>"+info.FIEL_PSN+"</span>");
    				
    				$("#time_5").html(info.FILE_DATE?info.FILE_DATE.substring(0,16):"");
					$("#name_5").text(info.FIEL_PSN);
    				
    				var video=data.video;
						  for(var i=0;i<video.length;i++){
						  	  if(video[i].procType=="V_OC_C_M_11"){//书面调查
// 						  		var h= "<div style='text-align:center'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_11").append("<div style='height:32px;padding-right: 20px;line-height:32px'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
						  	 	video[i].createTime+
						  	 	"<a href='javaScript:void()' style='margin-right: -50px;padding-left: 40px;'>查看</a></div>");
// 						  	 	$("#V_OC_C_M_11").append("<a href='javaScript:void()'>查看</a>");
						  	 	httm("2",video[i]);
						  	 }
						  	 if(video[i].procType=="V_OC_C_M_1"){//原材料和零配件
						  		var h= "<div class='muy2' style='text-align:center'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_1").append("<div class='muy' style='text-align:center' style='height:52px;padding-right: 20px;line-height:50px'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
								video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_1").next().append(h);
						  	 	httm("2",video[i]);
						  	 }
						  	  if(video[i].procType=="V_OC_C_M_2"){//主要加工工序
						  		var h= "<div class='muy2' style='text-align:center'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_2").append("<div class='muy' style='text-align:center' style='height:52px;padding-right: 20px;line-height:50px'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
								video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_2").next().append(h);
						  	 	httm("2",video[i]);
						  	 }
						  	  if(video[i].procType=="V_OC_C_M_3"){//成品
						  		var h= "<div class='muy2' style='width:60px;text-align:center'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_3").append("<div class='muy' style='text-align:center' style='height:52px;padding-right: 20px;line-height:50px'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
						  	 	video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_3").next().append(h);
						  	 	httm("2",video[i]);
						  	 }
						  	  if(video[i].procType=="V_OC_C_M_4"){//包装及唛头
						  		var h= "<div class='muy2'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_4").append("<div class='muy'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
						  	 	video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_4").next().append(h);
						  	 	httm("2",video[i]);
						  	 }
							if(video[i].procType=="V_OC_C_M_7"){//其他
						  		var h= "<div class='muy2' style='text-align:center'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_7").append("<div class='muy' style='text-align:center' style='height:52px;padding-right: 20px;line-height:50px'><span style='float: left;margin-left:12px'>"+video[i].name+"</span>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
						  	 	video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_7").next().append(h);
						  	 	httm("2",video[i]);
						  	 }
						  	 
						  	 
						  	  if(video[i].procType=="V_OC_C_M_10"){//视频查看
						  		var h= "<div  class='muy2'><img src='/ciqs/static/show/images/video-btn.png' onclick='showVideo(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_10").append("<div  class='muy'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
						  	 	video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_10").next().append(h);
						  	 	httm("2",video[i]);
						  	 }
						  	  if(video[i].procType=="V_OC_C_M_5"){//签发证书
						  		var h= "<div class='muy2' style='text-align:center'><img src='/ciqs/static/show/images/photo-btn.png' onclick='toImgDetail(\""+video[i].fileName+"\")'/></div>";
						  	 	$("#V_OC_C_M_5").append("<div class='muy' style='text-align:center' style='height:52px;padding-right: 20px;line-height:50px'>调查人员:  "+video[i].createUser +
						  	 	"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调查时间:  "+
						  	 	video[i].createTime+
						  	 	"</div>");
						  	 	$("#V_OC_C_M_5").next().append(h);
						  		httm("4",video[i]);
						  	 }

						  }    
 			        if($("#alert").val() && $("#alert").val()=="success"){
 			        	alert("上传成功");
 			        }  
 			        if($("#alert").val() && $("#alert").val()=="error"){
 			        	alert("上传失败");
 			        }  
 			        $("#alert").val(""); 
/* // 					$("#flow_color").children().eq(0).find("div").getHour($("#time_1").text(),$("#time_2").text(),"+");
					$("#flow_color").children().eq(1).find("div").getHour($("#time_2").text(),$("#time_4").text(),"+");
					$("#flow_color").children().eq(2).find("div").getHour($("#time_4").text(),$("#time_5").text(),"+");
// 					$("#flow_color").children().eq(3).find("div").getHour($("#time_5").text(),$("#time_6").text(),"+");
					var b=false;
					if(!$("#time_5").text()){b=true;}
 			        $("#flow_origplace").getHour($("#time_2").text(),$("#time_5").text()==""?nowDate():$("#time_5").text(),null,b); 
 			        var totelHour=$("#flow_origplace").text(); 
 			        if(totelHour && totelHour.toString().split(".").length>1){
	 			        totelHour= totelHour.toString().split(".");
	 			        totelHour=totelHour[0]+":"+(parseInt(totelHour[1])*0.6).toFixed(0);
	 			        $("#flow_origplace").text(totelHour);
 			        } */
 			        
 			        if($("#time_2").text().toString().length==0){
 			       		 $(".del-2").remove();
 			        }
 			        if($("#time_4").text().toString().length==0){
 			         $(".del-3").remove();
 			        }
 			        if($("#time_5").text().toString().length==0){
 			         $(".del-4").remove();
 			        }
//  			        if($("#time_6").text().toString().length==0){
//  			         $(".del-4").remove();
//  			        }
    				$(".muy").parent().css("padding","0px");
	    				$("span").each(function(k,v){
							if($(v).text()=='undefined' || $(v).text()=='null'){
								$(v).text("");
							}
	    				});
	    				
	    				$("span[id^='time_']").each(function(){	
	    					if($(this).text()){
	    					var dataid=$(this)[0].getAttribute('id');
	    						$("li[data-id='"+dataid+"']").attr("class","icongreen");
	    					}else{
// 	    						var dataid=$(this)[0].getAttribute('id');
// 	    						$("li[data-id='"+dataid+"']").attr("class","iconyellow");
	    					}
	    				});
	    				
    				}
    			});
		});
	
		function nowDate(){
			var dd=new Date().toLocaleDateString().replace("年","-").replace("月","-").replace("日","");
			var ss=new Date().toLocaleTimeString().replace("上午"," ").replace("下午"," ");
			return dd+" "+ss;
		}

		function httm(id, o) {
			if (!$("#time_"+id).text()) {
				$("#name_"+id).html(o.createUser);
				$("#time_"+id).text(o.createTime?o.createTime.substring(0,16):"");
			} else if (new Date(o.createTime) > new Date($("#time_"+id).text())) {
				$("#name_"+id).html(o.createUser);
				$("#time_"+id).text(o.createTime?o.createTime.substring(0,16):"");
			}
		}

		function toImgDetail(path) {
			// 			path=path.substring(path.indexOf('/')+1,path.length);
			url = "/ciqs/showVideo?imgPath=" + path;
			$("#imgd1").attr("src", url);
			$("#imgd1").click();
		}
/* 
		function showVideo(path) {
// 					    path=path.substring(path.indexOf('/')+1,path.length);
// 			$("#CuPlayerMiniV").show();
// 			CuPlayerMiniV(path);
			viweConta(path);
		}

		function hideVideo() {
			$("#CuPlayerMiniV").hide();
		}
 */
		function fileSubmit(e) {
			if(typeof $(e).parent().children().eq(0).val() == 'undefined' || $(e).parent().children().eq(0).val() == ''){
				 alert("请选择一个文件!");
				 return;
			}
			var path = $(e).parent().children().eq(0).val();
			var type = path.substring(path.lastIndexOf('.')+1,path.length);
			if(type != '3gp' &&  type != 'mp4'){
				alert("请选择3gp或MP4格式视频文件!");
				return;
			}
			var f=$("#file")[0];
			if(f.files[0].size>=524288000){
				alert("视频超大,请上传低于400M文件");
				return 
			}
			$("#uploadForm").attr("action", "addVideoEventModel");
			$("#uploadForm").submit();
		}
		
		function getPlace(place_number){
			window.scroll(0, document.getElementById(place_number).offsetTop-306);
		}
	</script>
<title>原产地证书签发行政确认全过程执法记录</title>
<style>
.table-flow tr td {
    height: 60px;
    line-height: 30px;
    padding-left: 30px;
    padding-right: 30px;
}
</style>
</head>
<body  class="bg-gary">
<%@ include file="myOrig.jsp"%>
<div class="blank_div_dtl"></div>
<div class="margin-auto width-1200  data-box">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="gary">
    <tr>
      <td width="8%" height="35" align="center" valign="bottom">申请单位</td>
	      <td width="8%" height="35" align="center" valign="bottom">申请日期</td>
	      <td width="8%" height="35" align="center" valign="bottom">企业备案号</td>
	      <td width="8%" height="35" align="center" valign="bottom">证书号</td>
	      <td width="8%" height="35" align="center" valign="bottom">证书种类</td>
	      <td width="8%" height="35" align="center" valign="bottom">直属局</td>
	      <td width="8%" height="35" align="center" valign="bottom">分支机构</td>
	      <td width="8%" height="35" align="center" valign="bottom">发票号</td>
	      <td width="8%" height="35" align="center" valign="bottom">收货人</td>
	      <td width="8%" height="35" align="center" valign="bottom">目的国家</td>
	      <td width="8%" height="35" align="center" valign="bottom">出运日期</td>
      <td height="35" align="center" valign="bottom">&nbsp;<input type="hidden" id="alert" value="${alert}"/></td>
    </tr>
  </table>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-data">
			<tr>
				<td width="8%" height="90" align="center" class="font-18px"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center" class=" green"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td width="8%" height="90" align="center"></td>
				<td></td>
			</tr>
		</table>
</div>
<div class="title-cxjg" style="margin-top:170px;" id="module_1">电子审单环节</div>
<div class="margin-chx"><div><span  style="margin-left: 35px;">申请书信息</span><a style="margin-left: 30px;" class="myinfo" href="javaScript:void()">查看</a></div>
<table width="100%" border="0" class="table-xqlb" id="info">
  <tr class="table_xqlbbj">
  	<td width="17%" >申请单位</td>
  	<td width="17%" >证书号</td>
  	<td width="17%" >证书种类</td>
  	<td width="17%" >最终目的国/地区 </td>
  	<td width="16%" >中转国/地区  </td>
  	<td width="16%" >贸易方式 </td>
<!--   	<td>申情书信息查看</td> -->
  </tr>
  <tr class="table_xqlbnr">
  	<td id="dec_org_name"></td>
  	<td id="cert_no"></td>
  	<td id="cert_type"></td>
  	<td id="dest_country"></td>
  	<td id="transfer_country"></td>
  	<td id="trade_mode"></td>
<!--   	<td><a class="myinfo" href="javaScript:void()">查看</a></td> -->
  </tr>
<!--   <tr class="table_xqlbbj"> -->
<!--   	<td>发票号码</td> -->
<!--   	<td>商品FOB总值（美元）</td> -->
<!--   	<td>企业备案号 </td> -->
<!--   </tr> -->
<!--   <tr class="table_xqlbnr"> -->
<!--   	<td id="receipt_no"></td> -->
<!--   	<td id="apply_fob_val"></td> -->
<!--   	<td id="org_reg_no"></td> -->
<!--   </tr> -->
<!--   <tr class="table_xqlbbj"> -->
<!--   	<td>最终目的国/地区 </td> -->
<!--   	<td>中转国/地区  </td> -->
<!--   	<td>贸易方式 </td> -->
<!--   </tr> -->
<!--   <tr class="table_xqlbnr"> -->
<!--   	<td id="dest_country"></td> -->
<!--   	<td id="transfer_country"></td> -->
<!--   	<td id="trade_mode"></td> -->
<!--   </tr> -->
<!--   <tr class="table_xqlbbj">	 -->
<!--   	<td colspan="2">出运日期 </td> -->
<!--   	<td colspan="1">申情书信息查看</td> -->
<!--   </tr>  -->
<!--   <tr class="table_xqlbnr">	 -->
<!--   	<td id="shipping_date" colspan="2"></td> -->
<!--   	<td><a href="javaScript:void()">查看</a></td> -->
<!--   </tr>  -->
</table>
<!-- </div> -->

<!-- <div class="margin-chx"> -->
<table id="listtd" width="100%" border="0" class="table-xqlb">
    <tr class="table_xqlbbj">
      <td width="17%">产品序号</td>
      <td width="17%">HS编码 </td>
      <td width="17%">商品名称</td>
      <td width="17%">产品进口成份 </td>
      <td width="16%">数/重量及单位</td>
      <td width="16%">FOB值(USD)</td>
    </tr>
</table>
</div>	

<!-- <div class="title-cxjg">发票信息</div> -->
<div class="margin-chx"><div><span  style="margin-left: 35px;">发票信息</span><a style="margin-left: 30px;" id="fpxin" href="javaScript:void()">查看</a></div>
<table width="100%" border="0" class="table-xqlb">
 <tr class="table_xqlbbj">
<!--   	<td width="35%">收货人</td> -->
	<td >证书号</td>
	<td >发票号</td>
	<td>发票日期</td>
	<td>价格条款</td>
	<td>货物单价及总值</td>
<!-- 	<td>发票信息查看</td> -->
 </tr> 
 <tr class="table_xqlbnr">
<!--   	<td id="consignee_cname"></td> -->
	<td id="cert_no2"></td>
	<td id="receipt_no2"></td>
	<td id="receipt_date"></td>
	<td id="pric_item"></td>
	<td id="cag_pric"></td>
<!-- 	<td><a id="fpxin" href="javaScript:void()">查看</a></td> -->
 </tr> 
<!--  <tr class="table_xqlbbj">		 -->
<!-- 	<td>发票日期</td> -->
<!-- 	<td>唛头及包装号</td> -->
<!-- 	<td>数量及货物描述</td> -->
<!--  </tr>  -->
<!--  <tr class="table_xqlbnr">		 -->
<!-- 	<td id="receipt_date"></td> -->
<!-- 	<td id="mat_no"></td> -->
<!-- 	<td id="num_cag_disc"></td> -->
<!--  </tr>  -->
<!--  <tr class="table_xqlbbj">	 -->
<!-- 	<td>价格条款</td> -->
<!-- 	<td>货物单价及总值</td> -->
<!-- 	<td>特殊条款</td> -->
<!--  </tr> -->
<!--  <tr class="table_xqlbnr">	 -->
<!-- 	<td id="pric_item"></td> -->
<!-- 	<td id="cag_pric"></td> -->
<!-- 	<td id="spec_item"></td> -->
<!--  </tr> -->
 
<!--   <tr class="table_xqlbbj">	 -->
<!-- 	<td>发票信息查看</td> -->
<!-- 	<td></td> -->
<!-- 	<td></td> -->
<!--  </tr> -->
<!--  <tr class="table_xqlbnr">	 -->
<!-- 	<td><a href="javaScript:void()">查看</a></td> -->
<!-- 	<td></td> -->
<!-- 	<td></td> -->
<!--  </tr> -->
</table>
</div>

<!-- <div class="title-cxjg">证书信息</div> -->
<div class="margin-chx"><div><span  style="margin-left: 35px;">证书信息</span><a style="margin-left: 30px;" id="zsxx" href="/ciqs/tmpforshow/certificateoforigin.jsp">查看</a></div>
<table width="100%" border="0" class="table-xqlb">
  <tr class="table_xqlbbj">
	<td width="35%">出口商</td>
	<td width="35%">收货人</td>
	<td width="30%">生产商</td>
	<td>运输方式和路线</td>
	<td>目的国家</td>
	<td>唛头及包装号</td>
<!-- 	<td>证书信息查看</td> -->
  </tr> 
  <tr class="table_xqlbnr">
	<td id="exp_comp"></td>
	<td id="consignee_cname3"></td>
	<td id="prod_comp3"></td>
	<td id="trans_type"></td>
	<td id="purpose_country"></td>
	<td id="mat_no3"></td>
<!-- 	<td><a id="zsxx" href="/ciqs/tmpforshow/certificateoforigin.jsp">查看</a></td> -->
  </tr>
<!--   <tr class="table_xqlbbj">	 -->
<!-- 	<td>运输方式和路线</td> -->
<!-- 	<td>目的国家</td> -->
<!-- 	<td>唛头及包装号</td> -->
<!--   </tr> -->
<!--   <tr class="table_xqlbnr">	 -->
<!-- 	<td id="trans_type"></td> -->
<!-- 	<td id="purpose_country"></td> -->
<!-- 	<td id="mat_no3"></td> -->
<!--   </tr>  -->
  <tr class="table_xqlbbj">	
	<td>商品名称</td>
	<td>包装数量及种类</td>
	<td>HS编码</td>
	<td>原产地标准</td>
	<td>毛重或其他数量</td>
	<td>发票号码及日期</td>
  </tr> 
  <tr class="table_xqlbnr">	
	<td id="cag_name3"></td>
	<td id="pack_num"></td>
	<td id="hs_code3"></td>
	<td id="orig_place_std"></td>
	<td id="m_weight"></td>
	<td id="receipt_no_receipt_date"></td>
  </tr>
<!--   <tr class="table_xqlbbj">	 -->
<!-- 	<td>原产地标准</td> -->
<!-- 	<td>毛重或其他数量</td> -->
<!-- 	<td>发票号码及日期</td> -->
<!--   </tr>   -->
<!--   <tr class="table_xqlbnr">	 -->
<!-- 	<td id="orig_place_std"></td> -->
<!-- 	<td id="m_weight"></td> -->
<!-- 	<td id="receipt_no_receipt_date"></td> -->
<!--   </tr> -->
<!--   <tr class="table_xqlbbj">	 -->
<!-- 	<td>出口商申明</td> -->
<!-- 	<td>签证当局证明</td> -->
<!-- 	<td>证书信息查看</td> -->
<!--   </tr>  -->
<!--   <tr class="table_xqlbnr">	 -->
<!-- 	<td id="exp_stat"></td> -->
<!-- 	<td id="visa_stat"></td> -->
<!-- 	<td><a href="/ciqs/tmpforshow/certificateoforigin.jsp">查看</a></td> -->
<!--   </tr> -->
<!--    <tr class="table_xqlbbj">	 -->
<!-- 	<td>备注</td> -->
<!-- 	<td></td> -->
<!-- 	<td></td> -->
<!--   </tr>  -->
<!--   <tr class="table_xqlbnr">	 -->
<!-- 	<td id="rmk" style="height: 50px;"></td> -->
<!-- 	<td></td> -->
<!-- 	<td></td> -->
<!--   </tr> -->
</table>
</div>

<!-- <div class="title-cxjg del-1">签证调查环节</div> -->
<!-- <div class="margin-chx del-1"> -->
<!-- 	<table width="100%" border="0" class="table-xqlb"> -->
<!-- 		  <tr> -->
<!-- 		    <td width="300" class="table_xqlbbj2">书面调查</td> -->
<!-- 		   	<td class="flow-td-bord" id="V_OC_C_M_11"></td> -->
<!--     		<td width="60" align="center" ></td> -->
<!-- 		  </tr> -->
<!-- 	</table> -->
<!-- </div> -->

<div class="title-cxjg del-2"  id="module_2">签证调查环节</div>
<div class="margin-chx del-2"><div><span  style="margin-left: 35px;">书面调查</span></div>
	<table width="100%" border="0" class="table-xqlb">	  
		  <tr>
		    <td width="300" class="table_xqlbbj2">书面调查内容</td>
		   	<td class="flow-td-bord" id="V_OC_C_M_11" colspan="2"></td>
		  </tr>
	</table>
</div>		 
<div class="margin-chx del-2"><div><span  style="margin-left: 35px;">实地调查</span></div>	 
	<table width="100%" border="0" class="table-xqlb">	  	  
    	  <tr>
	    	<td width="300" class="table_xqlbbj2" style="padding: 0px">原材料和零配件的存放情况、外包装上品名及生产企业名称、进口报关单及采购发票</td>
		   	<td class="flow-td-bord" id="V_OC_C_M_1"></td>
    		 <td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
    		</td>
		  </tr>
    	  <tr>
	    	<td width="300" class="table_xqlbbj2">主要加工工序</td>
		   	<td class="flow-td-bord" id="V_OC_C_M_2"></td>
    		 <td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
    		</td>
		  </tr>
    	  <tr>
	    	<td width="300" class="table_xqlbbj2">成品</td>
		   	<td class="flow-td-bord" id="V_OC_C_M_3"></td>
    		 <td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
    		</td>
		  </tr>
    	  <tr>
	    	<td width="300" class="table_xqlbbj2">包装及唛头</td>
		  	<td class="flow-td-bord" style="padding: 0px"  id="V_OC_C_M_4"></td>
    		 <td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
    		</td>
		  </tr>
		  <tr>
	    	<td width="300" class="table_xqlbbj2">其他</td>
		  	<td class="flow-td-bord" style="padding: 0px"  id="V_OC_C_M_7"></td>
    		 <td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
    		</td>
		  </tr>
		   <tr>
		    <td width="300" class="table_xqlbbj2">原产地业务实地调查记录单</td>
			<td class="flow-td-bord"><a id="myhref" href="/ciqs/origplace/jumpText?id=&main_id=">原产地业务实地调查记录单</a></td>
		    <td width="60" align="center" valign="middle"  class="flow-td-bord"></td>
		  </tr>
		   <tr>
			    <td width="300" class="table_xqlbbj2">异常或争议视频上传</td>
			    <td align="right" valign="middle" colspan="2">
			  		<form id="uploadForm" method="post" enctype="multipart/form-data">
			    		<input id="file" type="file" name="file" style="margin-left: 510px;float: left;"/>
			    		<input id="procMainId" type="hidden" name="procMainId" value=""/>
			    		<input id="id" type="hidden" name="id" value="${id}"/>
			    		<input id="procType" type="hidden" name="procType" value="V_OC_C_M_10"/>
			    		<input id="fileType" type="hidden" name="fileType" value="2"/>
			    		<input id="upload" style="margin-right: 20px;" type="button" onclick="fileSubmit(this)" value="上传"/>
			    	</form>
			    </td>
		  </tr>
    	 <tr>
		    <td width="300" class="table_xqlbbj2">视频查看</td>
		   	<td class="flow-td-bord" style="padding: 0px"  id="V_OC_C_M_10"></td>
		    <td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
		    </td>
		  </tr>
	</table>
</div>
	
	<div class="title-cxjg del-3"  id="module_3">签证环节</div>
	<div class="margin-chx del-3">
	<table width="100%" border="0" class="table-xqlb">
    	  <tr>
	    	<td width="300" class="table_xqlbbj2">签发证书</td>
		    <td class="flow-td-bord" id="V_OC_C_M_5"></td>
    		<td width="60" align="center" valign="middle"  class="flow-td-bord" style="padding: 0px">
    		</td>
		  </tr>
	</table>
	</div>
	
	<div class="title-cxjg del-4"  id="module_4">证书发放及归档环节</div>
	<div class="margin-chx del-4">
	<table width="100%" border="0" class="table-xqlb">
		  <tr>
		    <td width="300" class="table_xqlbbj2">归档时间</td>
		    <td class="flow-td-bord" id="file_date"></td>
		    <td width="60" align="center" valign="middle"  class="flow-td-bord"></td>
		  </tr>
		  <tr>
		    <td width="300" class="table_xqlbbj2">归档人员</td>
		    <td class="flow-td-bord" id="fiel_psn"></td>
		    <td width="60" align="center" valign="middle"  class="flow-td-bord"></td>
		  </tr>
		   <tr>
		    <td width="300" class="table_xqlbbj2">证书查看</td>
		    <td class="flow-td-bord" style="color: green;">查看证书</td>
		    <td width="60" align="center" valign="middle"  class="flow-td-bord" id="look">
		    </td>
		  </tr>
	</table>
	</div>
	<div class="margin-auto width-1200 tips" ></div>
	<!-- 图片查看 -->
	<div class="row" style="z-index:200000;">
	 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
	      <div class="docs-galley" style="z-index:200000;">
	        	<ul class="docs-pictures clearfix" style="z-index:200000;">
	          	<li>
	          	<img id="imgd1" style="z-index:200000;"
	          	src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg"  />
	          	</li>
	        	</ul>
	      </div>
	   	</div>
	</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
		<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>
<%@ include file="/common/player.jsp"%>
</body>
</html>
