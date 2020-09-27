<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>进出境货轮检疫</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css"/>
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css"/>	
<script src="${ctx}/static/viewer/dist/viewer.js"></script>
<script src="${ctx}/static/viewer/demo/js/main.js"></script>
<script type="text/javascript" src="/ciqs/cuplayer/Images/swfobject.js"></script>
<script type="text/javascript"> 
$(function(){
	
      $.ajax({
    			url:"findtransportone"+location.search,
    			type:"get",
    			dataType:"json",
    			success:function(data){
   			        if(data.status=="OK"){
             			var results=data.results;
             			// 设置第一行数据
   			             var childOne=$("table").eq(0).find("tr").eq(1).children();
   			             childOne.eq(0).text(results.vsl_cn_name==null?"":results.vsl_cn_name);
   			             childOne.eq(1).text(results.vsl_en_name==null?"":results.vsl_en_name);
   			             childOne.eq(2).text(results.country_cn_name==null?"":results.country_cn_name);
   			             childOne.eq(3).text(results.country_en_name==null?"":results.country_en_name);
   			             childOne.eq(4).text(results.call_sign==null?"":results.call_sign);
   			             childOne.eq(5).html((results.total_ton==null?"":results.total_ton)+"<span class='gary'>（总重）</span>");
   			             childOne.eq(6).html((results.net_ton==null?"":results.net_ton)+"<span class='gary'>（净重）</span>");
   			             childOne.eq(7).html(results.cur_cargo_sit==null?"":
   			             results.cur_cargo_sit);
   			       		// 设置第二行数据
   			             var childTwo=$("table").eq(0).find("tr").eq(3).children();
   			             childTwo.eq(0).html(results.his_cargo_sit==null?"":
   			             results.his_cargo_sit);
   			             childTwo.eq(1).text(results.shipper_psn_num==null?"":results.shipper_psn_num);
   			             childTwo.eq(2).text(results.visitor_psn_num==null?"":results.visitor_psn_num);
   			             childTwo.eq(3).html(results.start_ship_sit==null?"":
   			             results.start_ship_sit);
   			             childTwo.eq(4).text(results.est_arriv_date==null?"":new Date(results.est_arriv_date).format("yyyy-MM-dd hh:mm:ss"));
   			             childTwo.eq(5).html(results.last_four_port==null?"":
   			             results.last_four_port);
   			             childTwo.eq(6).html(results.ship_sanit_cert==null?"":
   			             results.ship_sanit_cert);
   			             childTwo.eq(7).html(results.traf_cert==null?"":(results.traf_cert.split(",")[0]+"</br>"+results.traf_cert.split(",")[1]));
   			             
   			       // 设置第三行数据
   			             var childThree=$("table").eq(0).find("tr").eq(5).children();
   			             childThree.eq(0).text(results.having_patient==null?"":(results.having_patient=='Y'?"有":"无"));
   			             childThree.eq(1).text(results.having_corpse==null?"":(results.having_corpse=='Y'?"有":"无"));
   			             childThree.eq(2).text(results.having_mdk_mdi_cps==null?"":(results.having_mdk_mdi_cps=='Y'?"有":"无"));
    			       
   			       // 设置第四行数据
   			             var childFour=$("table").eq(1).find("tr").eq(1).children();
   			             childFour.eq(0).text(results.dec_date==null?"":new Date(results.dec_date).format("yyyy-MM-dd hh:mm:ss"));
   			             childFour.eq(1).text(results.dec_user==null?"":results.dec_user);
   			             childFour.eq(2).text(results.check_type_dec_cn==null?"":results.check_type_dec_cn);
   			             
   			       // 设置第五行数据
   			             var childFive=$("table").eq(1).find("tr").eq(3).children();
   			             childFive.eq(0).text(results.aprv_date==null?"":new Date(results.aprv_date).format("yyyy-MM-dd hh:mm:ss"));
   			             childFive.eq(1).text(results.aprv_user==null?"":results.aprv_user);
   			             childFive.eq(2).text(results.check_type_aprv_cn==null?"":results.check_type_aprv_cn);
    			             
   			       // 循环找id所匹配的图片或视频
   			             var transportFiles=data.transportFiles;
		                 if(transportFiles!=""){
                            for(var i=0;i<transportFiles.length;i++){
                                console.log($("#"+transportFiles[i].proc_type).html())
                            	var html_content="<div style='width:100%;height:60px;line-height:60px;border-bottom:1px solid #CCC'>"+
											     "<div style='float:left;margin-left:80px;width:200px;height:60px;line-height:60px;'>"+transportFiles[i].create_date_str+"</div>"+
											     "<div style='float:left;margin-left:30px'>由 </div>"+
												 "<div style='float:left;margin-left:20px;color:#008cd6;min-width:50px;height:60px'>"+(transportFiles[i].create_user==undefined?"":transportFiles[i].create_user)+"</div>"+
												 "<div style='float:left;margin-left:20px'>上传</div>"+
                                                  "<div style='float:right;margin-right:60px;line-height:60px'>";
                                 if(transportFiles[i].file_type==1){
                                      html_content+="<img src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' onclick='showPic(\""+transportFiles[i].file_name+"\")'/>";
                                 }else{
                                      html_content+="<img src='/ciqs/static/show/images/video-btn.png' width='42' height='42' onclick='showVideo(\""+transportFiles[i].file_name+"\")'/>";
                                 }
                                 html_content+="</div>"+"</div>";
                                 $("#"+transportFiles[i].proc_type).append(html_content);
                             }             
                          }
		                  var transportDocs=data.transportDocs;    
		               // 循环找所匹配的文件
		                  if(transportDocs!=""){
                             var doc_type_flag="-1";
                             var group_id_flag="-1";
                             for(var k=0;k<transportDocs.length;k++){
                            	 // 如果group_id 在之前出现了（因为查询时候是排序的）就放到同一个id下
                              	if(transportDocs[k].group_id!=null&&transportDocs[k].group_id==group_id_flag){
                                   $("#"+doc_type_flag).append("<div style='width:100%;height:61px;'>"+
							          "<div style='float:left;margin-left:80px;width:200px;height:60px;line-height:60px;'>"+transportDocs[k].dec_date_str+"</div>"+
							          "<div style='float:left;margin-left:30px;line-height:60px'>由 </div>"+
								      "<div style='float:left;margin-left:20px;color:#008cd6;min-width:50px;height:60px;line-height:60px'>"+(transportDocs[k].dec_user==undefined?"":transportDocs[k].dec_user)+"</div>"+
								      "<div style='float:left;margin-left:20px;line-height:60px'>上传</div>"+
                                      "<div style='float:right;margin-right:60px;line-height:60px' id='"+transportDocs[k].doc_type+transportDocs[k].group_id+"'>"+
                                      "<a href='javascript:void(0)' width='42' height='42' onclick='showTemplate(\""+transportDocs[k].doc_id+"\")'>"+transportDocs[k].name+"</a>"+
                                      "</div>"+ "</div>");
 			                     }else{
	                             	var html_content="<div style='width:100%;height:60px;line-height:60px;border-bottom:1px solid #CCC'>"+
											        "<div style='float:left;margin-left:80px;width:200px;height:60px;line-height:60px;'>"+transportDocs[k].dec_date_str+"</div>"+
											        "<div style='float:left;margin-left:30px;line-height:60px'>由 </div>"+
												    "<div style='float:left;margin-left:20px;color:#008cd6;min-width:50px;height:60px;line-height:60px'>"+(transportDocs[k].dec_user==undefined?"":transportDocs[k].dec_user)+"</div>"+
												    "<div style='float:left;margin-left:20px;line-height:60px'>上传</div>"+
                                                       "<div style='float:right;margin-right:60px;line-height:60px' id='"+transportDocs[k].doc_type+transportDocs[k].group_id+"'>"+
                                                          "<a href='javascript:void(0)' width='42' height='42' onclick='showTemplate(\""+transportDocs[k].doc_id+"\")'>"+transportDocs[k].name+"</a>"+
                                                    "</div>" + "</div>";
		                             $("#"+transportDocs[k].doc_type).append(html_content);
			                          doc_type_flag=transportDocs[k].doc_type;
			                          group_id_flag=transportDocs[k].group_id;
 			                     }
 			                  }             
 			               }
 			                  //设置大圈颜色和间隔时间
 			                  var totalSss = 0;
 			                  var addHour = 0;
								$(".writeHour").each(function(){
									var id = this.id;
									var index = id.substring(4);
									
									if((data.procArray)[index-1] != null && (data.procArray)[index-1].create_date_str != null){
										$("#psn"+index).text((data.procArray)[index-1].create_user);
										$("#date"+index).text((data.procArray)[index-1].create_date_str);
										$("#icon"+index).addClass("icongreen");
									}else{
										$("#psn"+index).text("");
										$("#date"+index).text('');
										$("#icon"+index).addClass("iconyellow");
									}
											
									if(index > 1){
										var dateText = $("#date"+index).text();
										var dateText0 = $("#date"+(index-1)).text();
										if(dateText != '' && dateText0 != ''){
											addHour = getHour(dateText0, dateText);
											$("#hour"+(index-1)).text("+"+addHour);
										}else{
											$("#hour"+(index-1)).text("-");
										}
									}
								});
								// 计算历时
								 var str = ciqFormatTime(2,6,"date");
								 $("#totalHour").text(str);   
								
								// 单一设置 与上面不符合规则的数据
								if(data.doc1 != null){
								
									$("#V_JC_T_T_22").prepend((data.doc1.option_1 == 0) ? "<span style='float:left;padding-left:40px; line-height:60px;'>是</span>" : "<span style='float:left;padding-left:40px;  line-height:60px;'>否</span>");
									$("#V_JC_T_T_23").prepend((data.doc1.option_2 == '0') ? "<span style='float:left;padding-left:40px; line-height:60px;'>是</span>" : "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>");
									$("#V_JC_T_T_24").prepend((data.doc1.option_3 == '0') ? "<span style='float:left;padding-left:40px; line-height:60px; line-height:60px;'>是</span>" : "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>");
									$("#V_JC_T_T_25").prepend((data.doc1.option_4 == '0') ? "<span style='float:left;padding-left:40px; line-height:60px;'>是</span>" : "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>");
									 
									// 设置有是否时间样式
									$("#V_JC_T_T_22").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
									$("#V_JC_T_T_23").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
									$("#V_JC_T_T_24").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
									$("#V_JC_T_T_25").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
								}
								if(data.doc2 != null){
									$("#isBroken").prepend((data.doc2.option_1 == '0') ? "<span style='float:left;padding-left:40px; line-height:60px;'>是</span>" : "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>");
									// TODO 添加数据之检疫查验
									var yes = "<span style='float:left;padding-left:40px; line-height:60px;'>是</span>";
									var no = "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>";
									var shiji = "<span style='float:left;padding-left:40px; line-height:60px;'>试剂："+data.doc2.option_5+"</span>";
									var jieguo = "<span style='float:left;padding-left:40px; line-height:60px;'>结果："+data.doc2.option_6+"</span>";
									var chuliduixiang = "<span style='float:left;padding-left:40px; line-height:60px;'>处理对象："+data.doc2.option_8+"</span>"
									var chulifangshi = "<span style='float:left;padding-left:40px; line-height:60px;'>处理方式："+data.doc2.option_9+"</span>"
									var chulizhizheng = "<span style='float:left;padding-left:40px; line-height:60px;'>卫生处理指征："+data.doc2.option_10+"</span>"
									$("#V_JC_T_T_35").prepend((data.doc2.option_2 == '0') ? "<span><span style='float:left;padding-left:40px; line-height:60px;'>是</span><span style='float:left;padding-left:40px; line-height:60px;'>"+data.doc2.option_3+"</span></span>" : "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>");
									$("#V_JC_T_T_d2").prepend((data.doc2.option_4 == '0') ? (yes + shiji +jieguo) : no);
									$("#V_JC_T_T_d3").prepend((data.doc2.option_7 == '0') ? (yes + chuliduixiang + chulifangshi + chulizhizheng) : no);
									
									// 设置有是否时间样式
									$("#V_JC_T_T_35").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
									$("#V_JC_T_T_d2").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
									$("#V_JC_T_T_d3").html($("#V_JC_T_T_22").html().replace(/float\:left;margin-left\:80px;width\:200px;height\:60px;line-height\:60px;/, "float:left;margin-left:26px;width:200px;height:60px;line-height:60px;"));
								}
								
								// 申报无异常事项数据天假
								if(data.doc3 != null){
									for(var i=0; i<20; i++){
										var key = 'option_'+i
										var isChck = data.doc3[key];
										if(isChck == '0'){
											$("#fileExamine1").html('<span style="float:left;padding-left:40px; line-height:60px;">是</span>');
											break;
										}
									}
								}
								
								// 卫生监督是否需要采样数据添加
								if(data.doc4 != null){
									var flag = data.doc4['option_1'];
									$("#V_JC_T_T_37").prepend((data.doc4.option_1 == '0') ? ("<span style='float:left;padding-left:40px; line-height:60px;'>是</span><span style='float:left;padding-left:40px; line-height:60px;'>"+data.doc4.option_2+"</span>"): "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>")
									var yes = "<span style='float:left;padding-left:40px; line-height:60px;'>是</span>";
									var no = "<span style='float:left;padding-left:40px; line-height:60px;'>否</span>";
									var chuliduixiang = "<span style='float:left;padding-left:40px; line-height:60px;'>处理对象："+data.doc4.option_4+"</span>"
									var chulifangshi = "<span style='float:left;padding-left:40px; line-height:60px;'>处理方式："+data.doc4.option_5+"</span>"
									var chulizhizheng = "<span style='float:left;padding-left:40px; line-height:60px;'>卫生处理指征："+data.doc4.option_6+"</span>"
									$("#weishengjd4").prepend((data.doc4.option_3 == '0') ? (yes + chuliduixiang +chulifangshi+chulizhizheng) : no);
								}
								
								$(".table_xqlbbj2").each(function(){
									var tr = $(this).parent();
									var vid = tr.find("td").eq(1).attr("id");
										if(tr.find("td").eq(1).text() == ""){
											tr.remove();
										}
								});
								
								$(".margin-chx").each(function(){
									if($(this).find("tr").length == 0){
										$(this).remove();
									}
								});
								
								$(".title-cxjg").each(function(){
									if($(this).next().attr("class") != "margin-chx"){
										$(this).remove();
									}
								});
    			        }
    			}
      });
});

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
	var date1 = new Date(startDate); 
	var date2 = new Date(endDate);
	var hour = "";
	hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
	hour = hour.toFixed(2);
    return hour;
}

/**
 * 计算2个日期毫秒差
 */
function getSss(startDate,endDate){
	var date1 = new Date(startDate); 
	var date2 = new Date(endDate);
	var sss = 0;
	sss = date2.getTime() - date1.getTime();
    return sss;
}

function formatSss(sss){
	var hours = parseInt(sss / (1000*60*60));
	var minutes = parseInt(sss % (1000*60*60) / (1000*60));
	var seconds = parseInt(sss % (1000*60) / 1000);
	return (hours < 10 ? "0"+hours : hours) + ":" + (minutes < 10 ? "0"+minutes : minutes);// + (seconds < 10 ? "0"+seconds : seconds);
}

function formatTimes(times){
	var day = Math.floor(times / 86400000);
	times = times - 86400000 * day;
	var hour = Math.floor(times / 3600000);
	times = times - 3600000 * hour;
	var min = Math.floor(times / 60000);
	if(day > 0 && day < 10){
		day = '0'+day;
	}
	if(hour > 0 && hour < 10){
		hour = '0'+hour;
	}
	if(min > 0 && min < 10){
		min = '0'+min;
	}
	return day + '天' + hour + '小时' + min + '分钟';
}

//图片预览
function showPic(path){
    $("#imgd1").attr("src","/ciqs/showVideo?imgPath="+path);
    $("#imgd1").click();
}
//打开模板表格
function showTemplate(doc_id){
window.open("transportstemplate?doc_id="+doc_id);
}
//视频观看
// function showVideo(path){
//     $("#CuPlayerMiniV").show();
//     var so = new SWFObject("/ciqs/cuplayer/CuPlayerMiniV3_Black_S.swf","CuPlayer","600","400","9","#000000");
// 	so.addParam("allowfullscreen","true");
// 	so.addParam("allowscriptaccess","always");
// 	so.addParam("wmode","opaque");
// 	so.addParam("quality","high");
// 	so.addParam("salign","lt");
// 	so.addVariable("CuPlayerFile","http://localhost:7001/ciqs/showVideo?imgPath="+path);
// 	so.addVariable("CuPlayerImage","/ciqs/cuplayer/Images/flashChangfa2.jpg");
// 	so.addVariable("CuPlayerLogo","/ciqs/cuplayer/Images/Logo.png");
// 	so.addVariable("CuPlayerShowImage","true");
// 	so.addVariable("CuPlayerWidth","600");
// 	so.addVariable("CuPlayerHeight","400");
// 	so.addVariable("CuPlayerAutoPlay","false");
// 	so.addVariable("CuPlayerAutoRepeat","false");
// 	so.addVariable("CuPlayerShowControl","true");
// 	so.addVariable("CuPlayerAutoHideControl","false");
// 	so.addVariable("CuPlayerAutoHideTime","6");
// 	so.addVariable("CuPlayerVolume","80");
// 	so.addVariable("CuPlayerGetNext","false");
// 	so.write("CuPlayer");
// }
//关闭视频
// function hideVideo(){
// 	$("#CuPlayerMiniV").hide();
// }
function getPlace(place_number){
window.scroll(0, document.getElementById(place_number).offsetTop-306);
}
</script>
</head>
<body  class="bg-gary" id="body">
	<div class="freeze_div_dtl" style="position: fixed;width: 100%;background-color:#f0f2f5;top:0px;height:290px;">
	    <div class="title-bg" >
	        <div class=" title-position margin-auto white">
                <div class="title"><span class="font-24px" style="color:white;">行政确认 /</span><a href="showtransports_jsp" style="color:white;">进出境货轮检疫</a></div>
					<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
            </div>
        </div>
	    <div class="flow-bg"  style="height:220px;">
			<div class="flow-position2 margin-auto"  style="height:220px;" >
				<ul class="white font-18px flow-height font-weight">
					<li>审批</li>
					<li>检疫查验</li>
					<li>卫生监督</li>
					<li>卫生处理</li>
					<li>证书签发</li>
					<li>归档</li>
					<li></li>
					<li></li>
					<li></li>
				</ul>
				<ul class="flow-icon">
				    <li id="icon1" class="iconyellow"><div class="hour white font-12px"><span id="hour1" class="writeHour"></span></div><a href="#tab1"><img src="${ctx}/static/show/images/affirm/affirm1.png" width="80" height="80" onclick="getPlace('module_second')"/></a></li>
				  	<li id="icon2" class="iconyellow"><div class="hour white font-12px"><span id="hour2" class="writeHour"></span></div><a href="#tab2"><img src="${ctx}/static/show/images/affirm/affirm2.png" width="80" height="80" onclick="getPlace('module_fifth')"/></a></li>
				  	<li id="icon3" class="iconyellow"><div class="hour white font-12px"><span id="hour3" class="writeHour"></span></div><a href="#tab3"><img src="${ctx}/static/show/images/affirm/affirm3.png" width="80" height="80" onclick="getPlace('module_eighth')"/></a></li>
				  	<li id="icon4" class="iconyellow"><div class="hour white font-12px"><span id="hour4" class="writeHour"></span></div><a href="#tab4"><img src="${ctx}/static/show/images/affirm/affirm4.png" width="80" height="80" onclick="getPlace('module_wscl')"/></a></li>
				  	<li id="icon5" class="iconyellow"><div class="hour white font-12px"><span id="hour5" class="writeHour"></span></div><a href="#tab5"><img src="${ctx}/static/show/images/affirm/affirm5.png" width="80" height="80" onclick="getPlace('module_eleventh')"/></a></li>
				  	<li id="icon6" class="iconyellow"><div class="hour white font-12px"><span id="hour6" class="writeHour"></span></div><a href="#tab6"><img src="${ctx}/static/show/images/affirm/affirm6.png" width="80" height="80" onclick="getPlace('module_twelfth')"/></a></li>
				  	<li></li>
				    <li></li>
				    <li style="white-space: nowrap; display:inline-block" class="white font-14px font-weight" > <br />历时：<span id="totalHour">0</span></li>
				</ul>
				<ul class="flow-info" >
					<li><span id="psn1" ></span><br />
					  <span class="font-10px" ><span id="date1" ></span></span>
					</li>
					<li><span id="psn2" ></span><br />
					  <span class="font-10px" ><span id="date2" ></span></span>
					</li>
					<li><span id="psn3" ></span><br />
					  <span class="font-10px" ><span id="date3" ></span></span>
					</li>
					<li><span id="psn4" ></span><br />
					  <span class="font-10px" ><span id="date4" ></span></span>
					</li>
					<li><span id="psn5" ></span><br />
					  <span class="font-10px" ><span id="date5" ></span></span>
					</li>
					<li><span id="psn6" ></span><br />
					  <span class="font-10px" ><span id="date6" ></span></span>
					</li>
					<li></li>
					<li></li>
				</ul>
			</div>
	    </div>
   </div>
   
   <div class="blank_div_dtl" style="margin-top:280px;"></div>

   <div class="margin-chx">
	   <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		    <tr class="table_xqlbbj">
		      <td width="148px"  align="center" valign="bottom">中文船名</td>
		      <td width="148px"  align="center" valign="bottom">英文船名</td>
		      <td width="148px"  align="center" valign="bottom">中文国籍</td>
		      <td width="148px"  align="center" valign="bottom">英文国籍</td>
		      <td width="148px"  align="center" valign="bottom">呼号</td>
		      <td width="148px"  align="center" valign="bottom">总吨</td>
		      <td width="148px"  align="center" valign="bottom">净吨</td>
		      <td width="148px"  align="center" valign="bottom">载货种类数量及预靠泊地点</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center"></td>
		      <td width="100" height="90" align="center"></td>
		      <td width="200" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="100" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td height="90" align="center" valign="middle"></td>
		    </tr>
		    <tr class="table_xqlbbj">
		      <td width="148px"  align="center" >上航次载货种类数量及本次到港作业任务</td>
		      <td width="148px"  align="center" valign="bottom">船员人数</td>
		      <td width="148px"  align="center" valign="bottom">旅客人数</td>
		      <td width="148px"  align="center" valign="bottom">发航港及出发日期</td>
		      <td width="148px"  align="center" valign="bottom">预计抵达日期及时间</td>
		      <td width="148px"  align="center" valign="bottom">近四周寄港及日期</td>
		      <td width="148px"  align="center" valign="bottom">船舶免予卫生控制措施证书/船舶卫生控制措施证书签发港及日期</td>
		      <td width="148px"  align="center" valign="bottom">交通工具卫生证书签发港及日期</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center"></td>
		      <td width="100" height="90" align="center"></td>
		      <td width="200" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="100" height="90" align="center" class=" green">
		      	<!--<fmt:formatDate value="${results.est_arriv_date}" type="both" pattern="yyyy-MM-dd hh:mm:ss"/>-->
		      </td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td height="90" align="center" valign="middle"></td>
		    </tr>
		    <tr class="table_xqlbbj">
		      <td width="148px"  align="center" valign="bottom">船上有无病人</td>
		      <td width="148px"  align="center" valign="bottom">船上是否有人非因意外死亡</td>
		      <td width="148px"  align="center" valign="bottom">在航海中船上是否有鼠类或其它医学媒介生物反常死亡</td>
		      <td width="148px"  align="center" valign="bottom"></td>
		      <td width="148px"  align="center" valign="bottom"></td>
		      <td width="148px"  align="center" valign="bottom"></td>
		      <td width="148px"  align="center" valign="bottom"></td>
		      <td width="148px"  align="center" valign="bottom"></td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center"></td>
		      <td width="100" height="90" align="center"></td>
		      <td width="200" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="100" height="90" align="center" class=" green"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td height="90" align="center" valign="middle"><span></span></td>
		    </tr>	    
	  </table>
   </div>
	
	<div class="title-cxjg" id="module_second">审批</div>
	<div class="margin-chx">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
			<tr class="table_xqlbbj">
		      <td width="33%"  align="center" valign="bottom">申报时间</td>
		      <td width="33%"  align="center" valign="bottom">申报人员</td>
		      <td align="center" valign="bottom">检疫方式（申报）</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td align="center"></td>
		      <td align="center"></td>
		      <td align="center"></td>
		    </tr>
		    <tr class="table_xqlbbj">
		      <td width="33%"  align="center" valign="bottom">审批时间</td>
		      <td width="33%"  align="center" valign="bottom">审批人员</td>
		      <td align="center" valign="bottom">检疫方式（审批）</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td align="center"></td>
		      <td align="center"></td>
		      <td align="center"></td>
		    </tr>
		</table>
	</div>
	 
	<div class="title-cxjg" id="module_fifth">检疫查验</div>
	<div class="margin-chx">
	    <div height="35" align="left" style="padding-left:40px;">登轮前检查</div>
		<table width="100%" border="0" class="table-xqlb">
			  <tr>
		         <td width='100' class="table_xqlbbj2">船舶基本信息是否与申报一致</td>
			     <td width='600' align='right' valign='middle' id="V_JC_T_T_22" style="padding:0!important"></td>    
			  </tr>
			  <tr>
		         <td width='100' class="table_xqlbbj2" style="padding:0!important">船舶是否悬挂检疫黄旗和检疫信号灯</td>
			     <td width='600' align='right' valign='middle' id="V_JC_T_T_23" style="padding:0!important"></td>    
			  </tr>
			  <tr>
		         <td width='100' class="table_xqlbbj2">船舶是否采取悬挡鼠板等病媒生物防控措施</td>
			     <td width='600' align='right' valign='middle' id="V_JC_T_T_24" style="padding:0!important"></td>    
			  </tr>
			  <tr>
		         <td width='100' class="table_xqlbbj2">船舶是否存在未经检疫合格人员及货物上下的情况</td>
			     <td width='600' align='right' valign='middle' id="V_JC_T_T_25" style="padding:0!important"></td>    
			  </tr>
		</table>
	</div>
	
	<div class="margin-chx">
		<div height="35" align="left" style="padding-left:40px;">登轮后文件审核</div>
		<table width="100%" border="0" class="table-xqlb">
			  <tr>
		         <td width='100' class="table_xqlbbj2">文件审核是否发现问题</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_4_td" id="fileExamine1">
					<span style="float:left;padding-left:40px; line-height:60px;">否</span>
				</td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">申报无异常事项</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_4_td" id="D_JC_T_T_12"></td>    
			  </tr>
		</table>
	</div>
	
		
	<div class="margin-chx">
		<div height="35" align="left" style="padding-left:40px;">检疫查验</div>
		<table width="100%" border="0" class="table-xqlb">
		      <tr>
		         <td width='100' class="table_xqlbbj2">检疫查验照片</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_5"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">检疫查验视频</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_6"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">检疫查验记录</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="D_JC_T_T_0"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">是否发现病人</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="isBroken"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">疫情疫病初步排查-照片</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_7"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">疫情疫病初步排查-视频</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_8"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2" style='padding:0px!important'><span style="line-height: 25px;">口岸传染病可疑病例流行病学调查表</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="D_JC_T_T_2"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">是否需要采样</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_35"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">是否进行现场快速检测</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_d2"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">是否需要卫生处理</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_d3"></td>    
			  </tr>
			  
			  <tr>
			     <td width='100' class="table_xqlbbj2">疫情疫病医学排查-照片</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_9"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">疫情疫病医学排查-视频</td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_10"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2" style='padding:0px!important'><span style="line-height: 25px;">口岸传染病可疑病例医学排查记录表</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_11"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">采样知情同意书</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_12"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">口岸传染病疑似病例转诊单</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_13"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">就诊方便卡</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px!important' class="proc_5_td" id="V_JC_T_T_14"></td>    
			  </tr>
		</table>
	</div>
	
	<div class="title-cxjg" id="module_eighth">卫生监督</div>
	<div class="margin-chx">
		<table width="100%" border="0" class="table-xqlb">
		  <tbody>
		      <tr>
		         <td width='100' class="table_xqlbbj2">卫生监督照片</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_15"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">卫生监督视频</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_16"></td>    
			  </tr>
			  
			  <tr>
			     <td width='100' class="table_xqlbbj2">船舶卫生监督评分表</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="D_JC_T_T_14"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">证据报告表照片</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_36"></td>    
			  </tr>
			  
			  <tr>
			     <td width='100' class="table_xqlbbj2">卫生监督记录</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="D_JC_T_T_1"></td>    
			  </tr>
			  
			  <tr>
			     <td width='100' class="table_xqlbbj2">是否需要采样</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_37"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">是否需要卫生处理</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="weishengjd4"></td>    
			  </tr>
			  
	       </tbody>
		</table>
	</div>
	
	
	
	<div class="title-cxjg" id="module_wscl">卫生处理</div>
	<div class="margin-chx">
		<div height="35" align="left" style="padding-left:40px;">卫生处理准备</div>
		<table width="100%" border="0" class="table-xqlb">
		  <tbody>
			  <tr>
		   		 <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">检疫处理通知书照片</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_17"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2" style='padding:0px'><span style="line-height: 25px;">卫生处理单位卫生处理单据照片</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_18"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2"><span style="line-height: 25px;">处理单位及相关人员处理资质的确定照片</span></td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_38"></td>    
			  </tr>
	       </tbody>
		</table>
	</div>
	
	<div class="margin-chx">
		<div height="35" align="left" style="padding-left:40px;">卫生处理监督及评价</div>
		<table width="100%" border="0" class="table-xqlb">
		  <tbody>
			  <tr>
		     	<td width='100' class="table_xqlbbj2">卫生处理监督及评价照片</td>
		     	<td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_19"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">卫生处理监督及评价视频</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="V_JC_T_T_20"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2" style='padding:0px'>交通工具熏蒸操作(除虫、除鼠)检查考核</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="D_JC_T_T_4"></td>    
			  </tr>
			  <tr>
			     <td width='100' class="table_xqlbbj2">交通工具喷洒操作(消毒、除虫)检查考核</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="D_JC_T_T_5"></td>    
		     </tr>
			 <tr>
			     <td width='100' class="table_xqlbbj2" style='padding:0px'>交通工具垃圾(废弃物)消毒操作检查考核</td>
			     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_6_td" id="D_JC_T_T_6"></td>    
			  </tr>
	       </tbody>
		</table>
	</div>
	<div class="title-cxjg" id="module_eleventh">证书签发</div>
	<div class="margin-chx">
	<table width="100%" border="0" class="table-xqlb">
	  <tbody>
	      <tr>
	         <td width='100' class="table_xqlbbj2">证书签发照片</td>
		     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_7_td" id="V_JC_T_T_21"></td>    
		  </tr>
	  </tbody>
	</table>
	</div>
	
	<div class="title-cxjg" id="module_twelfth">归档</div>
	<div class="margin-chx">
	<table width="100%" border="0" class="table-xqlb">
	  <tbody>
	      <tr>
	         <td width='100' class="table_xqlbbj2">归档列表</td>
		     <td width='600' align='right' valign='middle' style='padding:0px' class="proc_8_td" id="D_JC_T_T_9"></td>    
		  </tr>
	  </tbody>
	</table>
	</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
			<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>	
	<!-- 图片 -->
	<div class="row" style="z-index:200000;">
	 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
	      <div class="docs-galley" style="z-index:200000;">
	        	<ul class="docs-pictures clearfix" style="z-index:200000;">
	          	<li>
	          	<img id="imgd1" style="z-index:200000;display:none;"src="/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
	          	</li>
	        	</ul>
	      </div>
	   	</div>
	</div>
	
	<!--酷播迷你 CuPlayerMiniV3.0 代码开始-->
<!-- 	<div id="CuPlayerMiniV" style="width:620px;height:500px;position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;visibility: hidden;"> -->
<!-- 		<div style="width:30px;margin:0px 500px 0px 602px;background:white;cursor: pointer;" onclick="hideVideo()">关闭</div> -->
<!-- 		<div id="CuPlayer" style="position: fixed;left:35%;top:30%;margin:-100px 0px 0px -100;z-index:300000;"></div>  -->
<!-- 		<strong>提示：您的Flash Player版本过低！</strong>  -->
<!-- 	</div> -->
</body>
<%@ include file="/common/player.jsp"%>
</html>