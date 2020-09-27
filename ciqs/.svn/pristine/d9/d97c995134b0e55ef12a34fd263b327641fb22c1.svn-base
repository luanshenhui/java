<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>进出境旅客携带物全过程执法记录</title>
<%@ include file="/common/resource_show.jsp"%>
<link rel="stylesheet" href="${ctx}/static/viewer/assets/css/bootstrap.min.css" />
<link rel="stylesheet" href="${ctx}/static/viewer/dist/viewer.css" />
<link rel="stylesheet" href="${ctx}/static/viewer/demo/css/main.css" />	
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

<script type="text/javascript">
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
	$("#imgd1").hide();
	$("#CuPlayerMiniV").hide();
	
	$.ajax({	
		url : "/ciqs/Belongings/videoFileEventList?card_no=" + $("#card_no").val(),
		method : "post",
		success: function(result){
            var proc_xcjy_user_name = "";
			var proc_dzhc_user_name = "";
			var proc_xcyy_user_name = "";
			var proc_fc_user_name = "";
			var proc_jc_user_name = "";
			var proc_xcjy_date = "";
			var proc_dzhc_date = "";
			var proc_xcyy_date = "";
			var proc_fc_date = "";
			var proc_jc_date = "";
			var v_lkxdw_c_m_1_count=0;
			var v_lkxdw_c_m_2_count=0;
			var v_lkxdw_c_m_3_count=0;
			var v_lkxdw_c_m_4_count=0;
			var v_lkxdw_c_m_5_count=0;
			var v_lkxdw_c_m_6_count=0;
			var v_lkxdw_c_m_7_count=0;
			var v_lkxdw_c_m_8_count=0;
			var v_lkxdw_c_m_9_count=0;
			var v_lkxdw_c_m_10_count=0;
			var v_lkxdw_c_m_11_count=0;
			var v_lkxdw_c_m_12_count=0;
			var v_lkxdw_c_m_13_count=0;
			var yjw_status = $("#yjw_status").val();
	   	    var bldw_status = $("#bldw_status").val();
	   	    if(yjw_status == 1){
	   	      	yjw_status = "合格";
	   	    }else{
	   	      	yjw_status = "不合格";
	   	    }
	   	    if(bldw_status == 1){
	   	      	bldw_status = "合格";
	   	    }else{
	   	      	bldw_status = "不合格";
	   	    }
			
		    if(result.videoFileEventList.length>0){
		        $.each(result.videoFileEventList,function(i,data){
		       
		            // **************************** 查看图片和视频部分 *******************************
		            // 现场查验检疫犬截获动植物产品记录表
		            if(data.proc_type == "V_DD_P_C_3"){
		            	$("#tr1").html("");
			      		var str = "<tr>";
			      		if(v_lkxdw_c_m_1_count==0){
		    				str+="<td id='v_lkxdw_c_m_1_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>《检疫犬截获动植物产品记录表》</td>";
	    	            }
	    	            str+="<td style='text-align:left;padding-left:300px;border-top: 1px solid #CCC;'>查验时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
				    	+"</tr>";
				    	$("#tab1").append(str);
				    	if(proc_xcjy_date < data.create_date_str){
				    		proc_xcjy_date = data.create_date_str;
                            proc_xcjy_user_name = data.create_user;
				    	}
				    	v_lkxdw_c_m_1_count+=1;
			    	}
			    	// 照片查看
			    	if(data.proc_type == "V_DD_P_C_2"){
		            	$("#tr13").html("");
			      		var str = "<tr>";
			      		if(v_lkxdw_c_m_13_count==0){
		    				str+="<td id='v_lkxdw_c_m_13_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    	            }
	    	            str+="<td style='text-align:left;padding-left:300px;border-top: 1px solid #CCC;'>查验时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
				    	+"</tr>";
				    	$("#tab1").append(str);
				    	if(proc_xcjy_date < data.create_date_str){
				    		proc_xcjy_date = data.create_date_str;
                            proc_xcjy_user_name = data.create_user;
				    	}
				    	v_lkxdw_c_m_13_count+=1;
			    	}
			    	
                    // 现场查验视频查看
			    	if(data.proc_type == "V_DD_P_C_1"){
						$("#tr2").html("");
						var str = "<tr>";
		          		if(v_lkxdw_c_m_2_count==0){
	    					str+="<td id='v_lkxdw_c_m_2_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
	    				}
	    				str+="<td style='text-align:left;padding-left:300px;border-top: 1px solid #CCC;'>查验时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;检疫官:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				+"<td width='60' align='center' valign='middle' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab1").append(str);
      					if(proc_xcjy_date < data.create_date_str){
				    		proc_xcjy_date = data.create_date_str;
                            proc_xcjy_user_name = data.create_user;
				    	}
				    	v_lkxdw_c_m_2_count+=1;
			    	}
			    	
			    	// 现场查验其他材料
			    	if(data.proc_type == "V_DD_P_C_4"){
			    		  $("#tr3").html("");
		          		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_3_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_3_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>其他材料</td>";
	    				  }
	    	              str+="<td style='text-align:left;padding-left:300px;border-top: 1px solid #CCC;'>查验时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;检疫官:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab1").append(str);
     					  if(proc_xcjy_date < data.create_date_str){
				    		proc_xcjy_date = data.create_date_str;
                            proc_xcjy_user_name = data.create_user;
				    	  }
				    	  v_lkxdw_c_m_3_count+=1;
			    	}
			    	
  			    	// 出入境人员携带物现场检疫查验记录单
			    	/* if(data.proc_type == "V_DD_P_C_5"){
			    		  $("#tr4").html("");
		          		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_4_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_4_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>《出入境人员携带物现场检疫查验记录单》</td>";
	    				  }
	    	              str+="<td style='border-top: 1px solid #CCC;'>记录时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab1").append(str);
     					  if(proc_dzhc_date < data.create_date_str){
				    		proc_dzhc_date = data.create_date_str;
                            proc_dzhc_user_name = data.create_user;
				    	 }
				    	 v_lkxdw_c_m_4_count+=1;
			    	} */
			    	// 应检物照片
			    	if(data.proc_type == "V_DD_P_C_6"){
			    		  $("#tr5").html("");
			    		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_5_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_5_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>携带物检疫</td>";
	    				  }
	    	              str+="<td style='text-align:left;padding-left:300px;border-top: 1px solid #CCC;'>"+yjw_status+"&nbsp;&nbsp;&nbsp;&nbsp;检疫时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;检疫人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab3").append(str);
     					  if(proc_xcyy_date < data.create_date_str){
				    		proc_xcyy_date = data.create_date_str;
                            proc_xcyy_user_name = data.create_user;
				    	  }
				    	  v_lkxdw_c_m_5_count+=1;
			    	}
			    	// 伴侣动物临床查验
			    	/* if(data.proc_type == "V_DD_P_C_7"){
			    		  $("#tr6").html("");
			    		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_6_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_6_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>伴侣动物临床查验</td>";
	    				  }
	    	              str+="<td style='border-top: 1px solid #CCC;'>"+bldw_status+"&nbsp;&nbsp;&nbsp;&nbsp;查验时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab3").append(str);
     					  if(proc_xcyy_date < data.create_date_str){
				    		proc_xcyy_date = data.create_date_str;
                            proc_xcyy_user_name = data.create_user;
				    	  }
				    	  v_lkxdw_c_m_6_count+=1;
			    	} */
                    // 封存、截留决定照片
                    if(data.proc_type == "V_DD_P_C_8" || data.proc_type == "V_DD_P_C_9"){
			    		  $("#tr7").html("");
		          		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_7_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_7_td' width='170' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				  }
	    	              str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>封存、截留时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab4").append(str);
     					  if(proc_fc_date < data.create_date_str){
				    		proc_fc_date = data.create_date_str;
                            proc_fc_user_name = data.create_user;
				    	 }
				    	 v_lkxdw_c_m_7_count+=1;
			    	}
                    // 封存、截留决定视频
                    /* if(data.proc_type == "V_LKXDW_C_M_8"){
                    	$("#tr8").html("");
                    	var str = "<tr>";
		          		if(v_lkxdw_c_m_8_count==0){
	    					str+="<td id='v_lkxdw_c_m_8_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>封存、截留决定视频查看</td>";
	    				}
	    				str+="<td align='left' style='padding-left:150px'>封存、截留时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				+"<td width='280' align='right' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab4").append(str);
      					if(proc_fc_date < data.create_date_str){
				    		proc_fc_date = data.create_date_str;
                            proc_fc_user_name = data.create_user;
				    	}
				    	v_lkxdw_c_m_8_count+=1;
      				} */
                    // 封存、截留实施照片
                    /* if(data.proc_type == "V_DD_P_C_9"){
			    		  $("#tr9").html("");
		          		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_9_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_9_td' width='170' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				  }
	    	              str+="<td style='border-top: 1px solid #CCC;'>封存、截留时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab4").append(str);
     					  if(proc_fc_date < data.create_date_str){
				    		proc_fc_date = data.create_date_str;
                            proc_fc_user_name = data.create_user;
				    	  }
				    	 v_lkxdw_c_m_9_count+=1;
			    	} */
                    // 封存、截留实施视频
                   /*  if(data.proc_type == "V_LKXDW_C_M_10"){
                    	$("#tr10").html("");
                    	var str = "<tr>";
		          		if(v_lkxdw_c_m_10_count==0){
	    					str+="<td id='v_lkxdw_c_m_10_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>封存、截留实施视频查看</td>";
	    				}
	    				str+="<td align='left' style='padding-left:150px'>封存、截留时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				+"<td width='280' align='right' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab4").append(str);
      					if(proc_fc_date < data.create_date_str){
				    		proc_fc_date = data.create_date_str;
                            proc_fc_user_name = data.create_user;
				    	}
				    	v_lkxdw_c_m_10_count+=1;
      				} */
      				// 解除封存、截留照片查看
      				if(data.proc_type == "V_DD_P_C_10"){
			    		  $("#tr11").html("");
			    		  var str = "<tr>";
		          		  if(v_lkxdw_c_m_11_count==0){
	    				  	str+="<td id='v_lkxdw_c_m_11_td' width='170' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				  }
	    	              str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>解除封存、截留时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				  +"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
     					  $("#tab5").append(str);
     					  if(proc_jc_date < data.create_date_str){
				    		proc_jc_date = data.create_date_str;
                            proc_jc_user_name = data.create_user;
				    	  }
				    	  v_lkxdw_c_m_11_count+=1;
			    	}
      				// 解除封存、截留视频查看
      				if(data.proc_type == "V_DD_P_C_11"){
                    	$("#tr12").html("");
                    	var str = "<tr>";
		          		if(v_lkxdw_c_m_12_count==0){
	    					str+="<td id='v_lkxdw_c_m_12_td' width='170' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
	    				}
	    				str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>解除封存、截留时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;记录人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab5").append(str);
      					if(proc_jc_date < data.create_date_str){
				    		proc_jc_date = data.create_date_str;
                            proc_jc_user_name = data.create_user;
				    	}
				    	v_lkxdw_c_m_12_count+=1;
      				}
		          });
		      

		       }
		        // 合并视频查看等单元格
			    $("#v_lkxdw_c_m_1_td").attr("rowspan",v_lkxdw_c_m_1_count);
			    $("#v_lkxdw_c_m_2_td").attr("rowspan",v_lkxdw_c_m_2_count);
			    $("#v_lkxdw_c_m_3_td").attr("rowspan",v_lkxdw_c_m_3_count);
			    $("#v_lkxdw_c_m_4_td").attr("rowspan",v_lkxdw_c_m_4_count);
			    $("#v_lkxdw_c_m_5_td").attr("rowspan",v_lkxdw_c_m_5_count);
			    $("#v_lkxdw_c_m_6_td").attr("rowspan",v_lkxdw_c_m_6_count);
			    $("#v_lkxdw_c_m_7_td").attr("rowspan",v_lkxdw_c_m_7_count);
			    $("#v_lkxdw_c_m_8_td").attr("rowspan",v_lkxdw_c_m_8_count);
			    $("#v_lkxdw_c_m_9_td").attr("rowspan",v_lkxdw_c_m_9_count);
			    $("#v_lkxdw_c_m_10_td").attr("rowspan",v_lkxdw_c_m_10_count);
			    $("#v_lkxdw_c_m_11_td").attr("rowspan",v_lkxdw_c_m_11_count);
			    $("#v_lkxdw_c_m_12_td").attr("rowspan",v_lkxdw_c_m_12_count);
			    $("#v_lkxdw_c_m_13_td").attr("rowspan",v_lkxdw_c_m_13_count);
	            // **************************** 上传按钮部分 *******************************
		        // 上传按钮
		        $("#tab1").append("<tr>"
				    +"<td width='150'  class='bg-gary flow-td-bord'>视频上传</td>"
				    +"<td align='right' colspan='3'>"
				    +"<form id='uploadForm1' method='post' enctype='multipart/form-data'>"
				    +"<input id='file1' type='file' name='file' style='margin:0px 0px 0px 0px;'/>"
				    +"<button id='upload1' style='width:170px;height:24px;line-height:21px;margin:2px 95px 0px 0px;' onclick='fileSubmit(\"uploadForm1\",\"file1\",\"V_DD_P_C_1\",\"2\")'>上传</button>"
				    +"</form>"
				    +"</td>"
				+"</tr>");
			 
			    $("#tab5").append("<tr>"
				    +"<td width='170'  class='bg-gary flow-td-bord'>视频上传</td>"
				    +"<td align='right' colspan='3'>"
				    +"<form id='uploadForm2' method='post' enctype='multipart/form-data'>"
				    +"<input id='file2' type='file' name='file' style='margin:0px 0px 0px 0px;'/>"
				    +"<button id='upload2' style='width:170px;height:24px;line-height:21px;margin:2px 95px 0px 0px;' onclick='fileSubmit(\"uploadForm2\",\"file2\",\"V_DD_P_C_11\",\"2\")'>上传</button>"
				    +"</form>"
				    +"</td>"
				+"</tr>");

                /* ****************** 页面顶部环节图标信息 ****************** */
				// 操作人姓名
				$("#proc_xcjy_user_name").text(proc_xcjy_user_name);
				$("#proc_dzhc_user_name").text(proc_dzhc_user_name); 
				$("#proc_xcyy_user_name").text(proc_xcyy_user_name); 
				$("#proc_fc_user_name").text(proc_fc_user_name); 
				$("#proc_jc_user_name").text(proc_jc_user_name);
				// 操作时间
				$("#proc_xcjy_date").text(proc_xcjy_date.substring(0,proc_xcjy_date.length-3));
				$("#proc_dzhc_date").text(proc_dzhc_date.substring(0,proc_dzhc_date.length-3)); 
				$("#proc_xcyy_date").text(proc_xcyy_date.substring(0,proc_xcyy_date.length-3)); 
				$("#proc_fc_date").text(proc_fc_date.substring(0,proc_fc_date.length-3)); 
				$("#proc_jc_date").text(proc_jc_date.substring(0,proc_jc_date.length-3));  
				// 操作时间间隔数（小时）
				if(proc_xcjy_date !="" && proc_xcyy_date !=""){
					$("#proc_xcjy_hour").text("+"+getHour(proc_xcjy_date,proc_xcyy_date));
				}else{
					$("#proc_xcjy_hour").text("-");
				}
				/* if(proc_dzhc_date !="" && proc_xcyy_date !=""){
					$("#proc_dzhc_hour").text("+"+getHour(proc_dzhc_date,proc_xcyy_date));
				}else{
					$("#proc_dzhc_hour").text("-");
				} */
				if(proc_xcyy_date !="" && proc_fc_date !=""){
					$("#proc_xcyy_hour").text("+"+getHour(proc_xcyy_date,proc_fc_date));
				}else{
					$("#proc_xcyy_hour").text("-");
				}
				if(proc_fc_hour !="" && proc_jc_date !=""){
					$("#proc_fc_hour").text("+"+getHour(proc_fc_date,proc_jc_date));
				}else{
					$("#proc_fc_hour").text("-");
				}
				if(proc_xcjy_date !="" && proc_jc_date !=""){
					$("#z_hour").text(getZhour(proc_xcjy_date,proc_jc_date));
				}else if(proc_xcjy_date !="" && proc_jc_date ==""){
					//$("#z_hour").text(getZhour(proc_xcjy_date,null));
					$("#z_hour").text("");
					$("#z_hour_title").text("");					
				}else{
					$("#z_hour").text("");
					$("#z_hour_title").text("");
				}
				// 环节显示颜色
				if(proc_xcjy_date != ""){
					$("#xcjy").attr("class","icongreen");
				}
				if(proc_dzhc_date != ""){
					$("#dzhc").attr("class","icongreen");
				}
				if(proc_xcyy_date != "" ){
					$("#xcyy").attr("class","icongreen");
				}
				if(proc_fc_date != ""){
					$("#fc").attr("class","icongreen");
				}
				if(proc_jc_date != ""){
					$("#jc").attr("class","icongreen");
				}
				// 如果没有图片或视频不存在就删除环节
			    if(v_lkxdw_c_m_1_count == 0 && v_lkxdw_c_m_13_count == 0
			    && v_lkxdw_c_m_2_count==0 && v_lkxdw_c_m_3_count==0){
			    	$("#div1").remove();
			    	$("#div01").remove();
			    }
			    if(v_lkxdw_c_m_4_count == 0){
			    	$("#div2").remove();
			    	$("#div02").remove();
			    }
			    if(v_lkxdw_c_m_5_count == 0 && v_lkxdw_c_m_6_count==0){
			    	$("#div4").remove();
			    	$("#div04").remove();
			    }
			    if(v_lkxdw_c_m_7_count == 0 && v_lkxdw_c_m_9_count==0){
			    	$("#div3").remove();
			    	$("#div03").remove();
			    }
			    if(v_lkxdw_c_m_11_count == 0 && v_lkxdw_c_m_12_count==0){
			    	$("#div5").remove();
			    	$("#div05").remove();
			    }
			    // 显示电子签名
			    var str1 = "<tr>";
         		str1+="<td width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>电子签名</td>";
  				str1+="<td style='border-top: 1px solid #CCC;'></td>"
  				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='查看' onclick='toImgDetail(\""+$("#qmpath1").val()+"\")'/></td>"
  				+"</tr>";
  				$("#tab1").append(str1);
			    var str2 = "<tr>";
         		str2+="<td width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>电子签名</td>";
  				str2+="<td style='border-top: 1px solid #CCC;'></td>"
  				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='查看' onclick='toImgDetail(\""+$("#qmpath2").val()+"\")'/></td>"
  				+"</tr>";
  				$("#tab3").append(str2);
  				var str3 = "<tr>";
         		str3+="<td width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>电子签名</td>";
  				str3+="<td style='border-top: 1px solid #CCC;'></td>"
  				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='查看' onclick='toImgDetail(\""+$("#qmpath3").val()+"\")'/></td>"
  				+"</tr>";
  				$("#tab4").append(str3);
  				var str4 = "<tr>";
         		str4+="<td width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>电子签名</td>";
  				str4+="<td style='border-top: 1px solid #CCC;'></td>"
  				+"<td style='border-top: 1px solid #CCC;' width='60' align='center' valign='middle'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='查看' onclick='toImgDetail(\""+$("#qmpath4").val()+"\")'/></td>"
  				+"</tr>";
  				$("#tab5").append(str4);
		},
		error : function(result) {
			alert("操作失败");
		}		
	});
});

// 历史时间计算
function getZhour(startDate,endDate){
    if(startDate !=null && endDate !=null){
		startDate=startDate.substring(0, startDate.length-3);
		endDate=endDate.substring(0, endDate.length-3);
	}
    var day="";
	var hour = "";
	var mm = "";
    if(endDate == null){
    	var date1 = new Date(startDate);
    	var date2 = new Date(); 
    	day = 
    	hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60 );
    	mm = ((date2.getTime() - date1.getTime())/(1000 * 60 ));
    }else{
    	var date1 = new Date(startDate);
    	var date2 = new Date(endDate); 
    	hour = (date2.getTime() - date1.getTime())/(1000 * 60 * 60);
    	mm = ((date2.getTime() - date1.getTime())/(1000 * 60 ));
    }
    day = Math.floor((Math.floor(mm))/60/24);
	var jnum = ((Math.floor(mm))/60).toFixed(0);
	hour = parseInt(jnum%24);
	mm = (Math.floor(mm))%60;
	if(day == 0){
		day ="00";
	}
	if(day < 10 && day>=1){
		day ="0"+day;
	}
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
    return day+"天"+hour+"小时"+mm+"分钟";
}

function getmPlace(place_number){
	window.scroll(0, document.getElementById(place_number).offsetTop-1200+910);
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

/**
 * 显示图片浏览
 * path 数据库保存的图片地址 E:/201708/20170823/1B083FEA24D6E00004df8.jpg
 * wangzhy
 */
function toImgDetail(path){
	 if(path == ""){
		 return;
	 }
	//path=path.substring(path.indexOf('/')+1,path.length);
	url = "/ciqs/showVideo?imgPath="+path;
	$("#imgd1").attr("src",url);
	$("#imgd1").click();
}

/**
 * 关闭视频
 * wangzhy
 */
function hideVideo(){
	$("#CuPlayerMiniV").hide();
}
/**
 * 图片和视频文件上传
 * formId form表单Id
 * uploadFileId input file标签Id
 * procType 环节类型
 * fileType 文件类型 1图片 2视频 3音频
 * wangzhy
 */
function fileSubmit(formId,uploadFileId,procType,fileType){
	if(typeof $("#"+uploadFileId).val() == 'undefined' || $("#"+uploadFileId).val() == ''){
		alert("请选择一个文件!");
		return;
	}
	var path = $("#"+uploadFileId).val();
	/*var type = path.substring(path.lastIndexOf('.')+1,path.length);
 	if((procType == 'V_KB_C_M_2' || procType == 'V_JL_C_M_2') 
		&& (type == 'jpg' || type == 'jpeg' || type == 'png' || type == 'gif' || type == 'bmp')){
		alert("请选择一个视频文件!");
		return;
	}
	if((procType == 'V_JL_C_M_3' || procType == 'V_CYSJ_C_M_3') 
		&& (type != 'jpg' && type != 'jpeg' && type != 'png' && type != 'gif' && type != 'bmp')){
		alert("请选择一个图片文件!");
		return;
	} */
	try {
		var url ='/ciqs/Belongings/fileVideoOrImg?id='+$("#prod_main_id").val()+'&procType='+procType+'&fileType='+fileType+'&package_no='+$("#card_no").val();
		$("#"+formId).attr("action",url);
		$("#"+formId).submit();
		alert("上传成功!");
	} catch (e) {
		alert("上传失败!");
	}
}

</script>
<input type="hidden" id="card_no" value="${card_no}"/>
<input type="hidden" id="prod_main_id" value="${prod_main_id}"/>
<input type="hidden" id="qmpath1" value="${qmpath1}"/>
<input type="hidden" id="qmpath2" value="${qmpath2}"/>
<input type="hidden" id="qmpath3" value="${qmpath3}"/>
<input type="hidden" id="qmpath4" value="${qmpath4}"/>
<div class="freeze_div_dtl" style="position: fixed;top:0px;width:100%">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a" href="/ciqs/Belongings/Intercepe">进出境旅客携带物检疫</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg"  style=" height:235px;background-color: #f0f2f5;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<li style="width:150px">现场查验</li>
<!-- <li style="width:150px">单证核查</li> -->
<li style="width:150px">现场检疫</li>
<li style="width:190px">封存、截留决定及实施</li>
<li style="width:190px">解除封存、截留</li>
<li></li>
</ul>
<ul class="flow-icon">
  <li style="width:150px" id="xcjy" class="iconyellow"><div class="hour white font-12px"><span id="proc_xcjy_hour" ></span></div><a onclick="getmPlace('div1')"><img src="${ctx}/static/show/images/Belongings/belongings1.png" width="80" height="80" /></a></li>
  <%-- <li style="width:150px" id="dzhc" class="iconyellow"><div class="hour white font-12px"><span id="proc_dzhc_hour" ></span></div><a onclick="getmPlace('div2')"><img src="${ctx}/static/show/images/Belongings/belongings2.png" width="80" height="80" /></a></li> --%>
  <li style="width:150px" id="xcyy" class="iconyellow"><div class="hour white font-12px"><span id="proc_xcyy_hour" ></span></div><a onclick="getmPlace('div3')"><img src="${ctx}/static/show/images/Belongings/belongings3.png" width="80" height="80" /></a></li>
  <li style="width:190px" id="fc" class="iconyellow"><div class="hour white font-12px"><span id="proc_fc_hour" ></span></div><a onclick="getmPlace('div4')"><img src="${ctx}/static/show/images/Belongings/belongings4.png" width="80" height="80" /></a></li>
  <li style="width:190px" id="jc" class="iconyellow"><div class="hour white font-12px"></div><a onclick="getmPlace('div5')"><img src="${ctx}/static/show/images/Belongings/belongings5.png" width="80" height="80" /></a></li>
  <li style="width:500px" class="white font-18px font-weight" > <br />
  <span id="z_hour_title" >历时：</span><span id="z_hour" ></span></li>
</ul>
<ul class="flow-info" >
<li style="width:150px"><span id="proc_xcjy_user_name" ></span><br />
  <span class="font-10px" ><span id="proc_xcjy_date" ></span></span>
</li>
<!-- <li style="width:150px"><span id="proc_dzhc_user_name" ></span><br />
  <span class="font-10px" ><span id="proc_dzhc_date" ></span></span></li> -->
<li style="width:150px"><span id="proc_xcyy_user_name" ></span><br />
  <span class="font-10px" ><span id="proc_xcyy_date" ></span></span></li>
<li style="width:190px"><span id="proc_fc_user_name" ></span><br />
  <span class="font-10px" ><span id="proc_fc_date" ></span></span></li>
<li style="width:190px"><span id="proc_jc_user_name" ></span><br />
  <span class="font-10px" ><span id="proc_jc_date" ></span></span>
</li>
<li class="font-18px"></li>
<li class="font-18px"></li>
</ul>
</div>
</div>
</div>
<div class="blank_div_dtl" style="margin-top:290px;">
</div>
<div class="title-cxjg" align="left">人员信息</div>
<div class="margin-chx">
	 <c:if test="${not empty list }">
		<c:forEach items="${list}" var="details" begin="0" end="0">
		<input type="hidden" id="yjw_status" value="${details.yjw_status}"/>
		<input type="hidden" id="bldw_status" value="${details.bldw_status}"/>
 		 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		    <tr class="table_xqlbbj">
		      <td width="200" height="35" align="center" valign="bottom">护照号码</td>
		      <td width="150" height="35" align="center" valign="bottom">姓名</td>
		      <td width="150" height="35" align="center" valign="bottom">性别</td>
		      <td width="150" height="35" align="center" valign="bottom">出生日期</td>
		      <td width="150" height="35" align="center" valign="bottom">国家、地区</td>
		      <td width="150" height="35" align="center" valign="bottom">地址</td>
		      <td width="150" height="35" align="center" valign="bottom">证件照片</td>
		      <td width="150" height="35" align="center" valign="bottom"></td>
		    </tr>
		    <tr class="table_xqlbnr">
		   	  <td width="200" height="90" align="center" class="font-18px">${details.card_no}</td>
		      <td width="150" height="90" align="center">${details.name}</td>
		      <td width="150" height="90" align="center">${details.sex}</td>
              <td width="150" height="90" align="center"><fmt:formatDate value="${details.birth}" type="both" pattern="yyyy-MM-dd"/></td>
		      <td width="150" height="90" align="center">${details.cnname}</td>
 		      <td width="150" height="90" align="center">${details.live_plc}</td>
		      <td width="150" height="90" align="center">${details.card_pic}</td> 
		      <td width="150" height="35" align="center" valign="bottom"></td> 
		    </tr>
 		 </table>
 		 </c:forEach>
	</c:if>
	</div>
	
 	<c:if test="${not empty list }">
		<c:forEach items="${list}" var="details"> 
		<div class="title-cxjg" align="left">携带物信息</div>
		<div class="margin-chx">
   		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		    <tr class="table_xqlbbj">
		      <td width="200" height="35" align="center" valign="bottom">检疫记录编号</td>
		      <td width="150" height="35" align="center" valign="bottom">检疫官</td>
		      <td width="150" height="35" align="center" valign="bottom">交通工具号</td>
		      <td width="150" height="35" align="center" valign="bottom">登记日期</td>
		      <td width="150" height="35" align="center" valign="bottom">物品种类</td>
		      <td width="150" height="35" align="center" valign="bottom">禁止进境物</td>
		      <td width="150" height="35" align="center" valign="bottom">品名</td>
		      <td width="150" height="35" align="center" valign="bottom">不合格原因</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center" class="font-18px">${details.chk_rcd_no}</td>
		      <td width="150" height="90" align="center">${details.insp_opr}</td>
		      <td width="150" height="90" align="center">${details.tra_tool_no}</td>
		      <td width="150" height="90" align="center"><fmt:formatDate value="${details.reg_date}" type="both" pattern="yyyy-MM-dd"/></td>
		      <td width="150" height="90" align="center">${details.cag_type}</td>
		      <td width="150" height="90" align="center">${details.prhb_enter}</td>
		      <td width="150" height="90" align="center">${details.cag_name}</td>
		      <td width="150" height="90" align="center">${details.unqf_rsn}</td>
		      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
		    </tr>
		    <tr class="table_xqlbbj">
		      <td width="200" height="35" align="center" valign="bottom">数量及单位</td>
		      <td width="150" height="35" align="center" valign="bottom">重量及单位</td>
		      <td width="150" height="35" align="center" valign="bottom">是否送样</td>
		      <td width="150" height="35" align="center" valign="bottom">收样部门</td>
		      <td width="150" height="35" align="center" valign="bottom">检疫项目</td>
		      <td width="150" height="35" align="center" valign="bottom">来自地</td>
		      <td width="150" height="35" align="center" valign="bottom">截获方式</td>
		      <td width="150" height="35" align="center" valign="bottom">物品照片</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center" class="font-18px">${details.num_unit}</td>
		      <td width="150" height="90" align="center">${details.weight_unit}</td>
		      <td width="150" height="90" align="center">${details.is_samp}</td>
		      <td width="150" height="90" align="center">${details.rsv_samp_dpt}</td>
		      <td width="150" height="90" align="center">${details.check_item}</td>
		      <td width="150" height="90" align="center">${details.from_plc}</td>
		      <td width="150" height="90" align="center">${details.its_type}</td>
		      <td width="150" height="90" align="center">${details.cag_pic}</td>
		   
		      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
		    </tr>
 		 </table>
 		 </div>
 		 </c:forEach>
	</c:if>
	
 	<c:if test="${not empty list }">
		<c:forEach items="${list}" var="details" begin="0" end="0">
 		 <div class="title-cxjg" align="left">处置信息</div>
 		 <div class="margin-chx">
 		 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		    <tr class="table_xqlbbj">
		      <td width="200" height="35" align="center" valign="bottom">截留凭证编号</td>
		      <td width="150" height="35" align="center" valign="bottom">处理说明</td>
		      <td width="150" height="35" align="center" valign="bottom">在华联系地址</td>
		      <td width="150" height="35" align="center" valign="bottom">在华联系电话</td>
		      <td width="150" height="35" align="center" valign="bottom">处置日期</td>
		      <td width="150" height="35" align="center" valign="bottom">用途</td>
		      <td width="150" height="35" align="center" valign="bottom">截获流水号</td>
		      <td width="150" height="35" align="center" valign="bottom">处理方式</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center" class="font-18px">${details.voc_no}</td>
		      <td width="150" height="90" align="center">${details.deal_disc}</td>
		      <td width="150" height="90" align="center">${details.plc_cn}</td>
		      <td width="150" height="90" align="center">${details.plc_tel}</td>
		      <td width="150" height="90" align="center">${details.deal_date}</td>
		      <td width="150" height="90" align="center">${details.use_to}</td>
		      <td width="150" height="90" align="center">${details.its_no}</td>
		      <td width="150" height="90" align="center">${details.deal_type}</td>
		      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
		    </tr>
		    <tr class="table_xqlbbj">
		      <td width="200" height="35" align="center" valign="bottom" colspan="8">备注</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="200" height="90" align="center" class="font-18px" colspan="8">${details.rmk}</td>
		      <!-- <td height="90" align="center" valign="middle"><span class="data-btn margin-auto">详细+</span></td> -->
		    </tr>
 		 </table>
 		 </div>
 		 </c:forEach>
	</c:if>
	
 	<c:if test="${not empty tgoods }">
		 <div class="title-cxjg" align="left">疫情信息</div>
		 <div class="margin-chx">
 		 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
		    <tr class="table_xqlbbj">	    
		      <td width="100" height="35" align="center" valign="bottom">业务流水号</td>
		      <td width="150" height="35" align="center" valign="bottom">CIQ码</td>
		      <td width="150" height="35" align="center" valign="bottom">旅客携带物中文名</td>
		      <td width="150" height="35" align="center" valign="bottom">数量</td>
		      <td width="150" height="35" align="center" valign="bottom">入境口岸</td>
		      <td width="150" height="35" align="center" valign="bottom">入境时间</td>
		      <td width="150" height="35" align="center" valign="bottom">启运地（中文）</td>
		      <td width="150" height="35" align="center" valign="bottom">启运地（英文）</td>
		    </tr>
		    <tr class="table_xqlbnr">
		      <td height="90" align="center">${tgoods.ID}</td>
		      <td height="90" align="center">${tgoods.CODE}</td>
		      <td height="90" align="center">${tgoods.CNAME}</td>
		      <td height="90" align="center">${tgoods.QUANTITY}</td>
		      <td height="90" align="center">${tgoods.ENTERPORT}</td>
		      <td height="90" align="center">${tgoods.ENTERDATE }</td>
		      <td height="90" align="center">${tgoods.STARTADD }</td>
		      <td height="90" align="center">${tgoods.STARTADDEN }</td>
		    </tr>
		    <tr class="table_xqlbbj">
			   <td width="180" height="35" align="center" valign="bottom">来源国/地区（中文）</td>
			   <td width="150" height="35" align="center" valign="bottom">航号/航班号</td>
			   <td width="150" height="35" align="center" valign="bottom">货物为禁止进境物</td>
			   <td width="180" height="35" align="center" valign="bottom">混有的禁止进境物名称</td>
			   <td width="150" height="35" align="center" valign="bottom">无进境检疫许可证</td>
			   <td width="150" height="35" align="center" valign="bottom">其他</td>
			   <td width="150" height="35" align="center" valign="bottom">采取措施</td>
			   <td width="150" height="35" align="center" valign="bottom">处理方法</td>   
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="180" height="90" align="center">${tgoods.ORIGNATION}</td>
		      <td width="150" height="90" align="center">${tgoods.CONVEYANCENO }</td>
		      <td width="150" height="90" align="center"><c:if test="${not empty tgoods.DEREGDISENTER }">${tgoods.DEREGDISENTER =="false"?'否':'是'}</c:if></td>
		      <td width="150" height="90" align="center">${tgoods.DEREGMIXDISENTER }</td>
		      <td width="150" height="90" align="center"><c:if test="${not empty tgoods.DEREGNOPERMITQC }">${tgoods.DEREGNOPERMITQC =="false"?'否':'是'}</c:if></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center">${tgoods.MEASURE }</td>
		      <td width="150" height="90" align="center">${tgoods.TREATMENT }</td>
		    </tr>
		    <tr class="table_xqlbbj">
			   <td width="100" height="35" align="center" valign="bottom">处理日期</td>
			   <td width="150" height="35" align="center" valign="bottom"></td>
			   <td width="150" height="35" align="center" valign="bottom"></td>
			   <td width="150" height="35" align="center" valign="bottom"></td>
			   <td width="150" height="35" align="center" valign="bottom"></td>
			   <td width="150" height="35" align="center" valign="bottom"></td>
			   <td width="150" height="35" align="center" valign="bottom"></td>
			   <td width="150" height="35" align="center" valign="bottom"></td>   
		    </tr>
		    <tr class="table_xqlbnr">
		      <td width="100" height="90" align="center">${tgoods.TREATDATE }</td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		      <td width="150" height="90" align="center"></td>
		    </tr>
 		 </table>
 		 </div>
	</c:if>

<c:forEach items="${list}" var="details" begin="0" end="0">
<div id="div1" class="title-cxjg" >现场查验</div>
<div id="div01" class="margin-chx">
<table id="tab1" width="100%" border="0" class="table-xqlb">
</table>
</div>
</c:forEach>

<div id="div2" class="title-cxjg" >单证核查环节</div>
<div id="div02" class="margin-chx">
<table id="tab2" width="100%" border="0" class="table-xqlb">
</table>
</div>

<div id="div3" class="title-cxjg" >现场检疫</div>
<div id="div03" class="margin-chx">
<table id="tab3" width="100%" border="0" class="table-xqlb">
</table>
</div>

<div id="div4" class="title-cxjg" >封存、截留决定及实施</div>
<div id="div04" class="margin-chx">
<table id="tab4" width="100%" border="0" class="table-xqlb">
</table>
</div>

<div id="div5" class="title-cxjg" >解除封存、截留</div>
<div id="div05" class="margin-chx">
<table id="tab5" width="100%" border="0" class="table-xqlb">
</table>
</div>
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
		<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
	</div>

<div class="title-cxjg" style="height:430px;"></div>
<!-- 图片查看 -->
<div class="row" style="z-index:200000;">
 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
      <div class="docs-galley" style="z-index:200000;">
        	<ul class="docs-pictures clearfix" style="z-index:200000;">
          	<li>
          	<img id="imgd1" style="z-index:200000;" src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
          	</li>
        	</ul>
      </div>
   	</div> 
</div> 
<%@ include file="/common/player.jsp"%>
</body>
</html>
