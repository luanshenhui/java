<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>进境邮寄物全过程执法记录</title>
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
<script type="text/javascript">
/**
 * 页面初始化加载
 * wangzhy
 */
$(function(){
	$("#imgd1").hide();
	$.ajax({	
		url : "/ciqs/mail/videoFileEventList?package_no=" + $("#package_no").val(),
		method : "post",
		success: function(result){
			var proc_kbq_user_name = "";
			var proc_bq_user_name = "";
			var proc_fh_user_name = "";
			var proc_jl_user_name = "";
			var proc_cysj_user_name = "";
			var proc_th_user_name="";
			var proc_xh_user_name="";
			var proc_kbq_date = "";
			var proc_bq_date = "";
			var proc_fh_date = "";
			var proc_jl_date = "";
			var proc_cysj_date = "";
			var proc_th_date= "";
			var proc_xh_date ="";
			var v_kbq_c_m_1_count=0;
			var v_kbq_c_m_2_count=0;
			var v_kb_c_m_1_count=0;
			var v_kb_c_m_2_count=0;
			var v_fx_c_m_1_count=0;
			var v_fx_c_m_2_count=0;
			var v_jl_c_m_3_count=0;
			var v_cysj_c_m_1_count=0;
			var v_cysj_c_m_2_count=0;
			var v_cysj_c_m_3_count=0;
			var v_th_c_m_5_count=0;
			var v_th_c_m_5_02_count=0;
			var v_xh_c_m_6_count=0;
			var v_xh_c_m_6_02_count=0;
			
			var xharr =[];
			var xhflag ="";
			
		    if(result.videoFileEventList.length>0){
		        $.each(result.videoFileEventList,function(i,data){
		            // **************************** 查看图片和视频部分 *******************************
		            // 信息采集验照片查看
		            if(data.proc_type == "V_KBQ_C_M_1" && data.file_type == "1"){
		            	var str = "<tr>";
		            	if(v_kbq_c_m_1_count == 0){
		            		str+="<td id='tab1_v_kbq_c_m_1_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
		            	}
				        str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
				        +"<td style='border-top: 1px solid #CCC;' width='60' align='center'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
				    	+"</tr>";
				    	$("#tab1").append(str);
				    	
				    	if(proc_kbq_date < data.create_date_str){
				    		proc_kbq_date = data.create_date_str;
                            proc_kbq_user_name = data.create_user;
				    	}
				    	v_kbq_c_m_1_count+=1;
			    	}
			    	
			    	// 信息采集验视频查看
		            if(data.proc_type == "V_KBQ_C_M_1" && data.file_type == "2"){
		            	var str = "<tr>";
		            	if(v_kbq_c_m_2_count == 0){
		            		str+="<td id='tab1_v_kbq_c_m_2_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
		            	}
				         str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					  +"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
				    	$("#tab1").append(str);
				    	
				    	if(proc_kbq_date < data.create_date_str){
				    		proc_kbq_date = data.create_date_str;
                            proc_kbq_user_name = data.create_user;
				    	}
				    	v_kbq_c_m_2_count+=1;
			    	} 
			    	
                    // 开包查验照片查看
			    	if(data.proc_type == "V_KB_C_M_1" && data.file_type == "1"){
						var str = "<tr>";
		          		if(v_kb_c_m_1_count == 0){
	    					str+="<td id='tab1_v_kb_c_m_1_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				}
    					str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab2").append(str);
      					
      					if(proc_bq_date < data.create_date_str){
				    		proc_bq_date = data.create_date_str;
                            proc_bq_user_name = data.create_user;
				    	}
				    	v_kb_c_m_1_count+=1;
			    	}
			    	
			    	// 开包查验视频查看
			    	if(data.proc_type == "V_KB_C_M_2" && data.file_type == "2"){
			    		  $("#tr3").html("");
			    		  var tab2_str = "<tr>";
			    		  if(v_kb_c_m_2_count == 0){
	    				  	tab2_str+="<td id='tab2_left_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
	    				  }
	    				  tab2_str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					  +"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
		          		  $("#tab2").append(tab2_str);

     					  if(proc_bq_date < data.create_date_str){
				    		proc_bq_date = data.create_date_str;
                            proc_bq_user_name = data.create_user;
				    	  }
				    	  v_kb_c_m_2_count +=1;
				    	  
			    	}
			    	
			    	// 截留收件人补充材料拍照查看
			    	if(data.proc_type == "V_JL_C_M_3"){
		          		var str ="<tr>";
		          		if(v_jl_c_m_3_count == 0){
		          			str+="<td id='v_jl_c_m_3_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>收件人补充材料查看</td>";
		          		}
    					str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='收件人补充材料查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
		          		+"</tr>";
		          		$("#tab4").append(str);
		          		if(proc_jl_date < data.create_date_str){
				    		proc_jl_date = data.create_date_str;
                            proc_jl_user_name = data.create_user;
				    	}
				    	v_jl_c_m_3_count+=1;
			    	}
			    	
			    	// 抽样送检拍照查看
			    	if(data.proc_type == "V_CYSJ_C_M_1"){
			    		$("#tr8").html("");
		          		var str="<tr>";
		          		if(v_cysj_c_m_1_count==0){
		          			str+="<td id='v_cysj_c_m_1_td' width='180' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>拍照查看</td>";
		          		}
    					str+="<td style='text-align:left;padding-left:250px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='收件人补充材料查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
		          		+"</tr>";
		          		$("#tab5").append(str);
		          		if(proc_cysj_date < data.create_date_str){
				    		proc_cysj_date = data.create_date_str;
                            proc_cysj_user_name = data.create_user;
				        }
				    	v_cysj_c_m_1_count+=1;
			    	}
			    	
			    	// 抽样送检视频查看
			    	if(data.proc_type == "V_CYSJ_C_M_2"){
			    		$("#tr9").html("");
			    		var str="<tr>";
		          		if(v_cysj_c_m_2_count==0){
		          			str+="<td id='v_cysj_c_m_2_td' width='180' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
		          		}
    					str+="<td style='text-align:left;padding-left:250px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
		          		+"</tr>";
		          		$("#tab5").append(str);
		          		if(proc_cysj_date < data.create_date_str){
				    		proc_cysj_date = data.create_date_str;
                            proc_cysj_user_name = data.create_user;
				        }
				        v_cysj_c_m_2_count+=1;
			    	}
			    	
			    	// 抽样送检《检验报告》拍照查看
			    	if(data.proc_type == "V_CYSJ_C_M_3"){
			    		$("#tr10").html("");
		          		var str="<tr>";
		          		if(v_cysj_c_m_3_count==0){
		          			str+="<td id='v_cysj_c_m_3_td' width='180' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>《检验报告》拍照查看</td>";
		          		}
    					str+="<td style='text-align:left;padding-left:250px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='收件人补充材料查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
		          		+"</tr>";
		          		$("#tab5").append(str);
		          		if(proc_cysj_date < data.create_date_str){
				    		proc_cysj_date = data.create_date_str;
                            proc_cysj_user_name = data.create_user;
				    	}
				    	v_cysj_c_m_3_count+=1;
			    	} 
			    	
			    	// 放行照片查看
			    	if(data.proc_type == "V_KB_C_M_4" && data.file_type == "1"){
                        var str = "<tr>";
                        if(v_fx_c_m_1_count==0){
	    					str+="<td id='v_fx_c_m_1_count_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				}
    					str+="<td style='text-align:left;padding-left:250px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab3").append(str);
      					if(proc_fh_date < data.create_date_str){
				    		proc_fh_date = data.create_date_str;
                            proc_fh_user_name = data.create_user;
				    	}
				    	v_fx_c_m_1_count+=1;
			    	}
			    	
  					// 放行视频查看
                    if(data.proc_type == "V_KB_C_M_4" && data.file_type == "2"){
                        var str = "<tr>";
                        if(v_fx_c_m_2_count==0){
	    					str+="<td id='v_fx_c_m_2_count_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				}
    					 str+="<td style='text-align:left;padding-left:250px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					  +"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
      					$("#tab3").append(str);
      					if(proc_fh_date < data.create_date_str){
				    		proc_fh_date = data.create_date_str;
                            proc_fh_user_name = data.create_user;
				    	}
				    	v_fx_c_m_2_count+=1;
			    	}
			    	
			    	// 退回视频查看
					if(data.proc_type == "V_TH_C_M_5" && data.file_type == "2"){
                        var str = "<tr>";
                        if(v_th_c_m_5_count==0){
	    					str+="<td id='v_th_c_m_5_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
	    				}
    					str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					  +"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
     					  +"</tr>";
      					$("#tab6").append(str);
      					if(proc_th_date < data.create_date_str){
				    		proc_th_date = data.create_date_str;
                            proc_th_user_name = data.create_user;
				    	}
				    	v_th_c_m_5_count+=1;
			    	}
				    // 退回照片查看
				    if(data.proc_type == "V_TH_C_M_5" && data.file_type == "1"){
                        var str = "<tr>";
                        if(v_th_c_m_5_02_count==0){
	    					str+="<td id='v_th_c_m_5_02_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				}
    					str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab6").append(str);
      					if(proc_th_date < data.create_date_str){
				    		proc_th_date = data.create_date_str;
                            proc_th_user_name = data.create_user;
				    	}
				    	v_th_c_m_5_02_count+=1;
			    	}
				    // 集中销毁照片查看
				    if(data.proc_type == "V_XH_C_M_6" && data.file_type == "1"){
                        var str = "<tr>";
                        if(v_xh_c_m_6_count==0){
	    					str+="<td id='v_xh_c_m_6_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>照片查看</td>";
	    				}
    					str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
    					+"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/photo-btn.png' width='42' height='42' title='照片查看' onclick='toImgDetail(\""+data.file_name+"\")'/></td>"
      					+"</tr>";
      					$("#tab7").append(str);
      					if(proc_xh_date < data.create_date_str){
				    		proc_xh_date = data.create_date_str;
                            proc_xh_user_name = data.create_user;
				    	}
				    	v_xh_c_m_6_count+=1;
			    	}
				  
				    // 集中销毁视频查看
				    if(data.proc_type == "V_XH_C_M_6" && data.file_type == "2"){
				    	
				    	xhflag = true;
				    	for (var i = 0; i < xharr.length; i++) {
							if(xharr[i] == data.file_name){
								xhflag = false;
							}
						}
				    	if(xhflag){
	                        var str = "<tr>";
	                        if(v_xh_c_m_6_02_count==0){
		    					str+="<td id='v_xh_c_m_6_02_td' width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>视频查看</td>";
		    				}
	    					str+="<td style='text-align:left;padding-left:280px;border-top: 1px solid #CCC;'>操作时间:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_date_str+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;查验人员:&nbsp;&nbsp;&nbsp;&nbsp;<span class='blue'>"+data.create_user+"</span></td>"
	    					  +"<td width='60px' align='center' style='border-top: 1px solid #CCC;'><img style='cursor: pointer;' src='/ciqs/static/show/images/video-btn.png' width='42' height='42' title='视频查看' onclick='showVideo(\""+data.file_name+"\")'/></td>"
	     					  +"</tr>";
	      					$("#tab7").append(str);
	      					if(proc_xh_date < data.create_date_str){
					    		proc_xh_date = data.create_date_str;
	                            proc_xh_user_name = data.create_user;
					    	}
					    	v_xh_c_m_6_02_count+=1;
				    	}
				    	xharr.push(data.file_name);
				    		
			    	}
		        });
		    }
		    
		    if(v_xh_c_m_6_02_count > 0){
		    	$.ajax({	
		    		url : "/ciqs/mail/xhList?ditroy_id=" + $("#ditroy_id").val(),
		    		method : "post",
		    		success: function(result){
		    			var str2 ="<tr><td width='150' style='border-top: 1px solid #CCC;' class='table_xqlbbj2'>销毁列表</td>";
						str2+="<td style='border-top: 1px solid #CCC;' colspan='2'>";
						//str2+="<div class='margin-auto width-1200  data-box'>";
						str2+="<div style='width:100%;padding:10px' class='margin-cxjg'>";
						str2+="<table style='width:100%' class='margin-cxjg_table' border='0' cellspacing='0' cellpadding='0'>";
						str2+="<tr class='thead'>";
						str2+="<td>邮件单号</td>";
						str2+="<td>截获时间</td>";
						str2+="</tr>";
						if(result.xhList.length>0){
		    		        $.each(result.xhList,function(i,data){
							    // 销毁列表
							    str2+="<tr>";
							    str2+="<td style='width:100px;height:0px;' align='center'>"+data.package_no+"</td>";
							    str2+="<td style='width:100px;height:0px;' align='center'>"+data.intrcept_date_str+"</td>";
								str2+="</tr>";
		    		      });
		    		    }
		    		    str2+="</table>";
						str2+="</div>";
						//str2+="</div>";
						str2+="</td></tr>";
						$("#tab7").append(str2);
		    		}
		    	});
		    }
				
		    var dxstr = "";
	    	// 退回-短信通知收件人、销毁-短信通知收件人、补充材料-短信通知收件人
	    	
	    	if($("#deal_type").val() == "TH"){
   				dxstr+="<tr><td width='170' style='padding:15px 0px 15px 0px;border-top: 1px solid #CCC;' class='table_xqlbbj2'>退回-短信通知收件人</td>";
  				dxstr+="<td style='border-top: 1px solid #CCC;' colspan='2'>"+$("#message_content").val()+"</td></tr>";
    					
	    	}else if($("#deal_type").val() == "XH"){
	    		dxstr+="<tr><td width='170' style='padding:15px 0px 15px 0px;border-top: 1px solid #CCC;' class='table_xqlbbj2'>销毁-短信通知收件人</td>";
  				dxstr+="<td style='border-top: 1px solid #CCC;' colspan='2'>"+$("#message_content").val()+"</td></tr>";
	    	}else{
	    	    dxstr+="<tr><td width='170' style='padding:15px 0px 15px 0px;border-top: 1px solid #CCC;' class='table_xqlbbj2'>补充材料-短信通知收件人</td>";
  				dxstr+="<td style='border-top: 1px solid #CCC;' colspan='2'>"+$("#message_content").val()+"</td></tr>";
	    	} 
	    	$("#tab4").append(dxstr);
	    	
	    	// 如果没有图片或视频不存在就删除环节
/* 		    if(v_kbq_c_m_1_count == 0 && v_kbq_c_m_2_count == 0){
		    	$("#div1").remove();
		    	$("#div01").remove();
		    }
		    if(v_kb_c_m_1_count == 0 && v_kb_c_m_2_count == 0){
		    	$("#div2").remove();
		    	$("#div02").remove();
		    }
		    if(v_jl_c_m_3_count == 0 && $("#message_content").val() == ""){
		    	$("#div4").remove();
		    	$("#div04").remove();
		    }
		    if(v_fx_c_m_2_count == 0 && v_fx_c_m_1_count==0){
		    	$("#div3").remove();
		    	$("#div03").remove();
		    }
		    if(v_cysj_c_m_1_count == 0 && v_cysj_c_m_2_count == 0 && v_cysj_c_m_3_count==0){
		    	$("#div5").remove();
		    	$("#div05").remove();
		    }
		    if(v_th_c_m_5_count == 0 && v_th_c_m_5_02_count == 0 ){
		    	$("#div6").remove();
		    	$("#div06").remove();
		    }
		    if(v_xh_c_m_6_count == 0 && v_xh_c_m_6_02_count == 0 ){
		    	$("#div7").remove();
		    	$("#div07").remove();
		    } */
		    // 合并视频查看等单元格
		    $("#tab1_v_kbq_c_m_1_td").attr("rowspan", v_kbq_c_m_1_count);
			$("#tab1_v_kbq_c_m_2_td").attr("rowspan", v_kbq_c_m_2_count);
			$("#tab1_v_kb_c_m_1_td").attr("rowspan",  v_kb_c_m_1_count);
			$("#tab2_left_td").attr("rowspan",  v_kb_c_m_2_count);
			$("#v_jl_c_m_3_td").attr("rowspan",  v_jl_c_m_3_count);
			$("#v_cysj_c_m_1_td").attr("rowspan", v_cysj_c_m_1_count);
			$("#v_cysj_c_m_2_td").attr("rowspan", v_cysj_c_m_2_count);
			$("#v_cysj_c_m_3_td").attr("rowspan",  v_cysj_c_m_3_count);
			$("#v_fx_c_m_1_count_td").attr("rowspan", v_fx_c_m_1_count);
			$("#v_fx_c_m_2_count_td").attr("rowspan", v_fx_c_m_2_count);
			$("#v_th_c_m_5_td").attr("rowspan", v_th_c_m_5_count);
			$("#v_th_c_m_5_02_td").attr("rowspan", v_th_c_m_5_02_count);
			$("#v_xh_c_m_6_td").attr("rowspan", v_xh_c_m_6_count);
			$("#v_xh_c_m_6_02_td").attr("rowspan",  v_xh_c_m_6_02_count);
		    // **************************** 上传按钮部分 *******************************
		    
		        // 开包查验视频上传按钮
		        $("#tab2").append("<tr>"
				    +"<td width='150' class='table_xqlbbj2'>视频上传</td>"
				    +"<td align='right' colspan='3'>"
				   
				    +"<form id='uploadForm' method='post' enctype='multipart/form-data'>"
				    +"<input id='file' type='file' name='file' style='margin:0px 0px 0px 0px;'/>"
				    +"<button id='upload' style='width:170px;height:24px;line-height:21px;margin:2px 95px 0px 0px;' onclick='fileSubmit(\"uploadForm\",\"file\",\"V_KB_C_M_2\",\"2\")'>上传</button>"
				    +"</form>"
				    +"</td>"
				+"</tr>");
			 	// 截留补充材料上传按钮
			 	$("#tab4").append("<tr>"
				    +"<td width='150' class='table_xqlbbj2'>补充材料上传</td>"
				    +"<td align='right' colspan='3'>"
				  
				    +"<form id='uploadForm4' method='post' enctype='multipart/form-data'>"
				    +"<input id='file4' type='file' name='file' style='margin:0px 0px 0px 0px;'/>"
				    +"<button id='upload4' style='width:170px;height:24px;line-height:21px;margin:2px 95px 0px 0px;' onclick='fileSubmit(\"uploadForm4\",\"file4\",\"V_JL_C_M_3\",\"2\")'>上传</button>"
				    +"</form>"
				    +"</td>"
				+"</tr>");
				
				// 抽样送检《检验报告》上传按钮
				/* $("#tab5").append("<tr>"
				    +"<td width='150' class='table_xqlbbj2'>《检验报告》上传</td>"
				    +"<td align='right' colspan='3'>"
				    
				    +"<form id='uploadForm3' method='post' enctype='multipart/form-data'>"
				    +"<input id='file3' type='file' name='file' style='margin:0px 0px 0px 0px;'/>"
				    +"<button id='upload' style='width:170px;height:24px;line-height:21px;margin:2px 95px 0px 0px;' onclick='fileSubmit(\"uploadForm3\",\"file3\",\"V_CYSJ_C_M_3\",\"2\")'>上传</button>"
				    +"</form>"
				    +"</td>"
				+"</tr>"); */
				
				$("#tab5").append("<tr>"
					    +"<td width='150' class='table_xqlbbj2'>抽样凭证</td>"
					    +"<td align='left' style='padding-left:10px;' colspan='3'>"
					    +"<input type='button' value='抽样凭证' onclick='toCypz()'/>"
					    +"</td>"
				+"</tr>");
				
				$("#tab5").append("<tr>"
					    +"<td width='150' class='table_xqlbbj2'>委托检验申请单</td>"
					    +"<td align='left' style='padding-left:10px;' colspan='3'>"
					    +"<input type='button' value='委托检验申请单' onclick='toWtjy()'/>"
					    +"</td>"
				+"</tr>");
				
				/* ****************** 页面顶部环节图标信息 ****************** */
				// 操作人姓名
				$("#proc_kbq_user_name").text(proc_kbq_user_name);
				$("#proc_bq_user_name").text(proc_bq_user_name); 
				$("#proc_jl_user_name").text(proc_jl_user_name); 
				$("#proc_cysj_user_name").text(proc_cysj_user_name);
				$("#proc_fh_user_name").text(proc_fh_user_name); 
				$("#proc_th_user_name").text(proc_th_user_name);
				$("#proc_xh_user_name").text(proc_xh_user_name);
				// 操作时间
				$("#time_1").text(proc_kbq_date.substring(0,proc_kbq_date.length-3));
				$("#time_2").text(proc_bq_date.substring(0,proc_bq_date.length-3)); 
				$("#time_3").text(proc_jl_date.substring(0,proc_jl_date.length-3)); 
				$("#time_4").text(proc_cysj_date.substring(0,proc_cysj_date.length-3)); 
				$("#time_5").text(proc_fh_date.substring(0,proc_fh_date.length-3)); 
				$("#time_6").text(proc_th_date.substring(0,proc_th_date.length-3)); 
				$("#time_7").text(proc_xh_date.substring(0,proc_xh_date.length-3)); 
				
				// 操作时间间隔数（小时）
				if(proc_kbq_date !="" && proc_bq_date !=""){
					$("#proc_kbq_hour").text("+"+getHour(proc_kbq_date,proc_bq_date));
				}else{
					$("#proc_kbq_hour").text("-");
				}
				if(proc_bq_date !="" && proc_jl_date !=""){
					$("#proc_kb_hour").text("+"+getHour(proc_bq_date,proc_jl_date));
				}else{
					$("#proc_kb_hour").text("-");
				}
				if(proc_jl_date !="" && proc_cysj_date !=""){
					$("#proc_jl_hour").text("+"+getHour(proc_jl_date,proc_cysj_date));
				}else{
					$("#proc_jl_hour").text("-");
				}
				if(proc_cysj_date !="" && proc_fh_date !=""){
					$("#proc_cysj_hour").text("+"+getHour(proc_cysj_date,proc_fh_date));
				}else{
					$("#proc_cysj_hour").text("-");
				}
				if(proc_th_date !="" && proc_fh_date !=""){
					$("#proc_fh_hour").text("+"+getHour(proc_fh_date,proc_th_date));
				}else{
					$("#proc_fh_hour").text("-");
				}
				if(proc_xh_date !="" && proc_th_date !=""){
					$("#proc_th_hour").text("+"+getHour(proc_th_date,proc_xh_date));
				}else{
					$("#proc_th_hour").text("-");
				}
				/* if(proc_kbq_date !="" && proc_xh_date !=""){
					$("#z_hour").text(getZhour(proc_kbq_date,proc_xh_date));
				}else if(proc_kbq_date !="" && proc_th_date !=""){
					$("#z_hour").text(getZhour(proc_kbq_date,proc_th_date));
				}else if(proc_kbq_date !="" && proc_fh_date !=""){
					$("#z_hour").text(getZhour(proc_kbq_date,proc_fh_date));
				}else if(proc_kbq_date !="" && proc_cysj_date !=""){
					$("#z_hour").text(getZhour(proc_kbq_date,proc_cysj_date));
				}else if(proc_kbq_date !="" && proc_jl_date !=""){
					$("#z_hour").text(getZhour(proc_kbq_date,proc_jl_date));
				}else if(proc_kbq_date !="" && proc_bq_date !=""){
					$("#z_hour").text(getZhour(proc_kbq_date,proc_bq_date));
				}else if(proc_kbq_date !="" && proc_xh_date ==""
						&& proc_bq_date =="" && proc_jl_date ==""
						&& proc_cysj_date =="" && proc_fh_date ==""
						&& proc_th_date =="" && proc_xh_date ==""){
					//$("#z_hour").text(getZhour(proc_kbq_date,null));
					$("#z_hour").text("");
					$("#z_hour_title").text("");
				}else{
					$("#z_hour").text("");
					$("#z_hour_title").text("");
				} */
				var time = ciqFormatTime(1,7);
				
				if(time ==""){
					$("#z_hour").text("");
					$("#z_hour_title").text("");
				}else{
					$("#z_hour").text(time);
				}
				// 环节显示颜色
				if(proc_kbq_date != ""){
					$("#kbq").attr("class","icongreen");
				}
				if(proc_bq_date != "" ){
					$("#kb").attr("class","icongreen");
				}
				if(proc_fh_date != "" ){
					$("#fh").attr("class","icongreen");
				}
				if(proc_jl_date != "" ){
					$("#jl").attr("class","icongreen");
				}
				if(proc_cysj_date != "" ){
					$("#cysj").attr("class","icongreen");
				}
				if(proc_th_date != "" ){
					$("#th").attr("class","icongreen");
				}
				if(proc_xh_date != "" ){
					$("#xh").attr("class","icongreen");
				}
				if($("#deal_status").val() == "1" ){
					$("#gd").attr("class","icongreen");
				}
				
		},
		error : function(result) {
			alert("操作失败");
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

/**
 * 显示图片浏览
 * path 数据库保存的图片地址 E:/201708/20170823/1B083FEA24D6E00004df8.jpg
 * wangzhy
 */
function toImgDetail(path){
	url = "/ciqs/showVideo?imgPath="+path;
	$("#imgd1").attr("src",url);
	$("#imgd1").click();
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
	/* var path = $("#"+uploadFileId).val();
	var type = path.substring(path.lastIndexOf('.')+1,path.length);
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
		var url ='fileVideoOrImg?id='+$("#mailId").val()+'&procType='+procType+'&fileType='+fileType+'&package_no='+$("#package_no").val();
		$("#"+formId).attr("action",url);
		$("#"+formId).submit();
		alert("上传成功!");
	} catch (e) {
		alert("上传失败!");
	}
}

function getmPlace(place_number){
	window.scroll(0, document.getElementById(place_number).offsetTop-290);
}

function toCypz(){
	var package_no = $("#package_no").val();
	var id= $("#mailId").val();
	window.open("${ctx}/mail/toCypz?id="+id+"&package_no="+package_no);
}

function toWtjy(){
	var package_no = $("#package_no").val();
	var id= $("#mailId").val();
	window.open("${ctx}/mail/toWtjy?id="+id+"&package_no="+package_no);
}
</script>
<input type="hidden" id="package_no" value="${mail.package_no}"/>
<input type="hidden" id="mailId" value="${mail.id}"/>
<input type="hidden" id="deal_type" value="${mail.deal_type}"/>
<input type="hidden" id="message_content" value="${mail.message_content}"/>
<input type="hidden" id="deal_status" value="${mail.deal_status}"/>
<input type="hidden" id="ditroy_id" value="${mail.ditroy_id}"/>
<div class="freeze_div_dtl" style="position: fixed;top:0px;width:100%" >
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><span class="font-24px" style="color:white;">行政确认 /</span><a id="title_a" href="/ciqs/mail/findMail">进境邮寄物检疫</a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="flow-bg"  style=" height:235px;background-color: #f0f2f5;" >
<div class="flow-position2 margin-auto"  style=" height:235px;" >

<ul class="white font-18px flow-height font-weight">
<li>信息采集</li>
<li>开包查验</li>
<li>截留</li>
<li>抽样送检</li>
<li>放行</li>
<li>退回</li>
<li>集中销毁</li>
<li>归档</li>
<li></li>
</ul>
<ul class="flow-icon">
  <li id="kbq" class="iconyellow">
	  <div class="hour white font-12px">
	 	<span id="proc_kbq_hour" ></span>
	  </div>
	  <a onclick="getmPlace('div1')">
	  	<img src="${ctx}/static/show/images/mail/mail1.png" width="80" height="80" />
	  </a>
  </li>
  <li id="kb" class="iconyellow">
	  <div class="hour white font-12px">
	  	<span id="proc_kb_hour" ></span>
	  </div>
	  <a onclick="getmPlace('div2')">
	  	<img src="${ctx}/static/show/images/mail/mail2.png" width="80" height="80" />
	  </a>
  </li>
  <li id="jl" class="iconyellow">
	  <div class="hour white font-12px">
	  	<span id="proc_jl_hour" ></span>
	  </div>
	  <a onclick="getmPlace('div4')">
	  	<img src="${ctx}/static/show/images/mail/mail3.png" width="80" height="80" />
	  </a>
  </li>
  <li id="cysj" class="iconyellow">
	  <div class="hour white font-12px">
	  	<span id="proc_cysj_hour" ></span>
	  </div>
	  <a onclick="getmPlace('div5')">
	  	<img src="${ctx}/static/show/images/mail/mail4.png" width="80" height="80" />
	  </a>
  </li>
  <li id="fh" class="iconyellow">
  	<div class="hour white font-12px">
  		<span id="proc_fh_hour" ></span>
  	</div>
  	<a onclick="getmPlace('div3')">
  		<img src="${ctx}/static/show/images/mail/mail5.png" width="80" height="80" />
  	</a>
  	</li>
  <li id="th" class="iconyellow">
    <div class="hour white font-12px">
  		<span id="proc_th_hour" ></span>
  	</div>
  	<a onclick="getmPlace('div6')">
  		<img src="${ctx}/static/show/images/mail/mail6.png" width="80" height="80" />
  	</a>
  	</li>
  <li id="xh" class="iconyellow">
  	<div class="hour white font-12px">
  		<span id="proc_xh_hour" ></span>
  	</div>
  	<a onclick="getmPlace('div7')">
  		<img src="${ctx}/static/show/images/mail/mail7.png" width="80" height="80" />
  	</a>
  </li>
  <li id="gd" class="iconyellow">
  	<div class="hour white font-12px">
  		
  	</div>
  	<a>
  		<img src="${ctx}/static/show/images/mail/mail8.png" width="80" height="80" />
  	</a>
  </li>
  <li style="width:130px" class="white font-12px font-weight" >
    	<span id="z_hour_title" >历时：</span><br/>
    	<span id="z_hour" ></span>
  </li>
</ul>
<ul class="flow-info" >
<li style="z-index:16000">
  <span id="proc_kbq_user_name" ></span><br />
  <span class="font-10px" ><span id="time_1" ></span></span>
</li>
<li>
  <span id="proc_bq_user_name" ></span><br />
  <span class="font-10px" ><span id="time_2" ></span></span>
</li>
<li>
  <span id="proc_jl_user_name" ></span><br />
  <span class="font-10px" ><span id="time_3" ></span></span>
</li>
<li>
  <span id="proc_cysj_user_name" ></span><br />
  <span class="font-10px" ><span id="time_4" ></span></span>
</li>
<li>
  <span id="proc_fh_user_name" ></span><br />
  <span class="font-10px" ><span id="time_5" ></span></span>
</li>
<li>
  <span id="proc_th_user_name" ></span><br />
  <span class="font-10px" ><span id="time_6" ></span></span>
</li>
<li>
  <span id="proc_xh_user_name" ></span><br />
  <span class="font-10px" ><span id="time_7" ></span></span>
</li>

</ul>
</div>
</div>
</div>
<div class="blank_div_dtl"  style="margin-top:290px;">
</div>

<div class="margin-chx">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table-xqlb">
    <tr class="table_xqlbbj">
      <td width="150" height="35" align="center" valign="bottom">邮件单号</td>
      <td width="100" height="35" align="center" valign="bottom">入境口岸</td>
      <td width="150" height="35" align="center" valign="bottom">截获时间</td>
      <td width="150" height="35" align="center" valign="bottom">寄件国/地区</td>
      <td width="100" height="35" align="center" valign="bottom">收件人姓名</td>
      <td width="150" height="35" align="center" valign="bottom">收件人电话</td>
      <td width="150" height="35" align="center" valign="bottom">收件人地址</td>
      <td width="150" height="35" align="center" valign="bottom">寄件人姓名</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="150" height="90" align="center" class="font-18px">${mail.package_no}</td>
      <td width="100" height="90" align="center">${mail.entry_port}</td>
      <td width="150" height="90" align="center"><fmt:formatDate value="${mail.intrcept_date}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/></td>
      <td width="150" height="90" align="center">${mail.consignor_country}</td>
      <td width="100" height="90" align="center">${mail.consignee_name}</td>
      <td width="150" height="90" align="center">${mail.consignee_tel}</td>
      <td width="150" height="90" align="center">${mail.package_plc}</td>
      <td width="150" height="90" align="center">${mail.sender_name}</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="200" height="35" align="center" valign="bottom">寄件人电话</td>
      <td width="120" height="35" align="center" valign="bottom">寄件人地址</td>
      <td width="120" height="35" align="center" valign="bottom">物品名称</td>
      <td width="150" height="35" align="center" valign="bottom">截获物来源地</td>
      <td width="100" height="35" align="center" valign="bottom">物品数量</td>
      <td width="100" height="35" align="center" valign="bottom">物品重量</td>
      <td width="150" height="35" align="center" valign="bottom">处理方式</td>
      <td width="140" height="35" align="center" valign="bottom">检疫人员</td>
    </tr>
    <tr class="table_xqlbnr">
      <td width="200" height="90" align="center" class="font-18px">${mail.send_tel}</td>
      <td width="120" height="90" align="center">${mail.sender_addr}</td>
      <td width="120" height="90" align="center">${mail.cago_name}</td>
      <td width="150" height="90" align="center">${mail.carrier_source}</td>
      <td width="100" height="90" align="center">${mail.cago_num}</td>
      <td width="100" height="90" align="center">${mail.cago_weight}</td>
      <td width="150" height="90" align="center">${mail.deal_name}</td>
      <td width="140" height="90" align="center">${mail.insp_user}</td>
    </tr>
    <tr class="table_xqlbbj">
      <td width="100" height="35" align="left" style="padding-left:70px" valign="bottom" colspan="7">物品类别</td>
      <td width="100" height="35" align="center" valign="bottom" >相关部门移送</td>
    </tr>
    <tr class="table_xqlbnr">      
      <td width="380" height="90" align="left" style="padding-left:70px" colspan="7">${mail.cago_type_name}</td>
      <td height="90" align="center" >
	      <c:if test="${mail.isxgbmys == 1}">
	      	是
	      </c:if>
	      <c:if test="${mail.isxgbmys == 0}">
	      	否
	      </c:if>
      </td>
    </tr>
  </table>
</div>

<div id="div1" class="title-cxjg" >信息采集</div>
<div id="div01" class="margin-chx">
	<table id="tab1" width="100%" border="0" class="table-xqlb">	
	</table>
</div>
<div id="div2" class="title-cxjg" >开包查验</div>
<div id="div02" class="margin-chx">
	<table id="tab2" width="100%" border="0" class="table-xqlb">
	</table>
</div>
<div id="div4" class="title-cxjg" >截留</div>
<div id="div04" class="margin-chx">
	<table id="tab4" width="100%" border="0" class="table-xqlb">
	</table>
</div>
<div id="div5" class="title-cxjg" >抽样送检</div>
<div id="div05" class="margin-chx">
	<table id="tab5" width="100%" border="0" class="table-xqlb" >
	</table>
</div>
<div id="div3" class="title-cxjg" >放行</div>
<div id="div03" class="margin-chx">
	<table id="tab3" width="100%" border="0" class="table-xqlb">
	</table>
</div>
<div id="div6" class="title-cxjg" >退回</div>
<div id="div06" class="margin-chx">
	<table id="tab6" width="100%" border="0" class="table-xqlb">
	</table>
</div>
<div id="div7" class="title-cxjg" >集中销毁</div>
<div id="div07" class="margin-chx">
	<table id="tab7" width="100%" border="0" class="table-xqlb">
	</table>
</div>
<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
	<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
</div>

<div class="title-cxjg" style="height:400px;"></div>
<!-- 图片查看 -->
<div class="row" style="z-index:200000;">
 	<div class="col-sm-8 col-md-6" style="z-index:200000;">
      <div class="docs-galley" style="z-index:200000;">
        	<ul class="docs-pictures clearfix" style="z-index:200000;">
          	<li>
          	<img id="imgd1" style="z-index:200000;" <%-- data-original="${ctx}/static/viewer/assets/img/tibet-1.jpg" --%> 
          	src="${ctx}/static/viewer/assets/img/thumbnails/tibet-3.jpg" alt="Cuo Na Lake" />
          	</li>
        	</ul>
      </div>
   	</div>
</div>
<%@ include file="/common/player.jsp"%>
</body>
</html>
