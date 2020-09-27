<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品生产企业备案核准</title>
<%@ include file="/common/resource_new.jsp"%>
<style  type="text/css">
select,input{
    width:140px;
}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>出口食品生产企业备案核准</span><div>");
		$(".user-info").css("color","white");
	});
	
</script>

</head>
<body>
<%@ include file="/common/headMenuBa.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：出口食品生产企业备案
<!-- 			检查 &gt; <a href="${cxt}/ciqs/extxz/peson?apply_no=${apply_no}">随机人员</a> -->
		</div>
		<jsp:include page="/common/message.jsp" flush="true" />
		<div class="search">
			<div class="main">
				<form action="/ciqs/expFoodPOF/jumpAddpeson?apply_no=${apply_no}"  method="post">
					<table class="table_search" id="aa">
						<tr>
							<td align="left"></td>
							<td>分类:</td>
							<td>专长:</td>
							<td>其他专长:</td>
							<td>级别:</td>
							<td>是否在岗:</td>
						</tr>
						<tr>
							<td style="color:#1b5ea8"></td>
							<td align="left"><select name="psnType">
									<option></option>
									<c:if test="${not empty psnTypeCode}">
										<c:forEach items="${psnTypeCode}" var="row">
											<option value="${row.code}" <c:if test="${psnType == row.code}"> selected="selected" </c:if>>${row.name}</option>
										</c:forEach>
									</c:if>
							</select></td>
							<td align="left">
								<input type="text" name="psnExpertise" id="psnExpertise" size="8" 
								value="<c:if test='${ not empty psnExpertise}'>${psnExpertise}</c:if>" onclick="expertise(this,1)" />
							</td>
							<td align="left">
								<input type="text" name="psnExpertise_order" id="psnExpertise_order" size="8" 
								value="<c:if test='${ not empty psnExpertise_order}'>${psnExpertise_order}</c:if>" onclick="expertise2(this,1)" />
							</td>
							<td align="left"><select name="psnLevel">
									<option></option>
									<c:if test="${not empty psnLevelCode}">
										<c:forEach items="${psnLevelCode}" var="row">
											<option value="${row.code}" <c:if test="${psnLevel == row.code}"> selected="selected" </c:if>>${row.name}</option>
										</c:forEach>
									</c:if>
							</select></td>
							<td align="left"><select name="in_post">
									<option value="1"  <c:if test="${in_post == 1}">  selected="selected" </c:if>>是</option>
									<option value="0"  <c:if test="${in_post == 0}">  selected="selected" </c:if>>否</option>
							</select></td>
							<td ></td>
						</tr>
						<tr>
							<td></td>
							<td>一级部门:</td>
							<td>二级部门:</td>
							<td>三级部门:</td>
						</tr>
						<tr>
							<td></td>
							<td align="left">
								<input type="text" name="levelDept_1" id="levelDept_1" size="8" 
								value="<c:if test='${ not empty psnLevelDept_1Code}'>${levelDept_1}</c:if>" onclick="deptTop(this,2)" />
							</td>
							<td align="left">
								<input type="text" name="levelDept_2" id="levelDept_2" size="8" 
								value="<c:if test='${ not empty psnLevelDept_2Code}'>${levelDept_2}</c:if>" onclick="deptTop_2(this,2)" />
							</td>
							<td align="left">
								<input type="text" name="levelDept_3" id="levelDept_3" size="8" 
								value="<c:if test='${ not empty psnLevelDept_3Code}'>${levelDept_3}</c:if>" onclick="deptTop_3(this,2)" />
								<input type="hidden" name="id" value="${id}"/>
							</td>
						</tr>
						<tr>
							<td colspan="6" style="text-align: center;">
								<input type="submit" class="abutton" style="margin: 0px;"
								value="随机" />
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="reset" class="abutton" style="margin: 0px;"
								value="清空"  />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
 		<c:if test="${one!=null }"> 
		<form action="/ciqs/expFoodPOF/updateAddpeson"  method="post">
			<div class="table" >
				<div class="menu">
					<ul>
						<li></li>
					</ul>
				</div>
				<div class="main">
				<table>
						<thead>
							<tr>
								<td width="15%">姓名</td>
<!-- 								<td width="15%">级别</td> -->
								<td width="15%">专长</td>
								<td width="10%">是否在岗</td>
								<td width="20%">所在范围</td>
							</tr>
						</thead>
							<tr>
								<td>${one.psnName}</td>
<!-- 								<td> -->
<!-- 									<c:if test="${one.psnType=='0'}">组长</c:if> -->
<!-- 									<c:if test="${one.psnType=='1'}">组员</c:if> -->
<!-- 								</td> -->
								<td title="${one.expName}">${one.psnExpertise}</td>
								<td>
									<c:if test="${one.in_post=='1'}">是</c:if>
									<c:if test="${one.in_post!='1'}">否</c:if>
								</td>
								<td>
									<c:if test="${not empty one.levelDept_1}">${one.levelDept_1}</c:if>
									<c:if test="${not empty one.levelDept_2}">-${one.levelDept_2}</c:if>
									<c:if test="${not empty one.levelDept_3}">-${one.levelDept_3}</c:if>
									<input type="hidden" name="psn_id" value="${one.psnId}"/>
									<input type="hidden" name="id" value="${id}"/>
									<input type="hidden" name="apply_no" value="${apply_no}"/>
								</td>
							</tr>
					</table>
				</div>
			</div>
			<input class="mbutton" value="确认" type="submit"  />
			</form>
 		</c:if> 
	</div>
<div id="expertise" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">核心团队</div>
				<table style="height: auto;"  id="hxtd">
				<c:if test="${not empty expertiseCode1 }">
				<c:forEach items="${expertiseCode1}" var="row">
					<c:if test="${classic_type==核心团队}" >
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
					</c:if>
				</c:forEach>
				</c:if>
				</table>
				<div style="background-color: #999999;">专业团队</div>
				<table style="height: auto;" id="zytd">
				<c:if test="${not empty expertiseCode2 }">
				<c:forEach items="${expertiseCode2}" var="row">
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				<div style="background-color: #999999;">准专业团队</div>
				<table style="height: auto;" id="zzytd">
				<c:if test="${not empty expertiseCode3 }">
				<c:forEach items="${expertiseCode3}" var="row">
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				<div style="background-color: #999999;">执法监管团队</div>
				<table style="height: auto;" id="zfjdtd">
				<c:if test="${not empty expertiseCode4 }">
				<c:forEach items="${expertiseCode4}" var="row">
					<tr>
						<td id="exp" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTd">
				<input type="button" id="btn" value="确定" onclick="getExpertise()" />
			</td>
		</tr>
	</table>
</div>	
<div id="expertise_order" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">其他专长</div>
				<table style="height: auto;">
				<c:if test="${not empty expertiseCode5 }">
				<c:forEach items="${expertiseCode5}" var="row">
					<tr>
						<td id="exp_order" align="left" >
							<c:if test='${row.expertise_main!=null || row.expertise_detail!=null}'>
								<input type="checkbox" style="width: 20px;" id="expertise_code" name="expertise_code" value="<c:if test='${not empty row.expertise_code}'>${row.expertise_code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.expertise_main}'>${row.expertise_main}</c:if>
								<c:if test='${not empty row.expertise_detail}'>{ ${row.expertise_detail} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTd_order">
				<input type="button" id="btn_order" value="确定" onclick="getExpertise()" />
			</td>
		</tr>
	</table>
	
<div id="deptTop_1" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">一级部门</div>
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_1Code }">
				<c:forEach items="${psnLevelDept_1Code}" var="row">
					<tr>
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.name}'>{ ${row.name} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom">
				<input type="button" id="combtn" value="确定" onclick="getExperCom(this)" />
			</td>
		</tr>
	</table>
</div>	

<div id="deptTop_2" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">二级部门</div>
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_2Code }">
				<c:forEach items="${psnLevelDept_2Code}" var="row">
					<tr>
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.name}'>{ ${row.name} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom_2">
				<input type="button" id="combtn_2" value="确定" onclick="getExperCom(this)" />
			</td>
		</tr>
	</table>
</div>	

<div id="deptTop_3" class="lightbox" style="width: 420px;height:400px;display: none;">
	<table width="100%">
		<tr>
			<th class="lightbox_th" height="15px">
				<a class="lightbox_close" id="mClose_order" href="javascript:void(0);" onclick="javascript:closeUI();">[X]</a>
			</th>
		</tr>
		<tr>
			<td>
				<div style="position:relative; height:340px; overflow:auto">
				<div style="background-color: #999999;">三级部门</div>
				<table style="height: auto;">
				<c:if test="${not empty psnLevelDept_3Code }">
				<c:forEach items="${psnLevelDept_3Code}" var="row">
					<tr>
						<td  align="left" >
							<c:if test='${row.code!=null}'>
								<input type="checkbox" style="width: 20px;"  name="expertise_code" value="<c:if test='${not empty row.code}'>${row.code}</c:if>" />
							</c:if>
							<span>
								<c:if test='${not empty row.name}'>{ ${row.name} }</c:if>
							</span>
						</td>
					</tr>
				</c:forEach>
				</c:if>
				</table>
				</div>
			</td>
		</tr>
		<tr>
			<td id="btnTdcom_3">
				<input type="button" id="combtn_3" value="确定" onclick="getExperCom(this)" />
			</td>
		</tr>
	</table>
</div>	
</div>	
	<script type="text/javascript">
		$("#confirm").click(function() {
			var list=new Array();
			$("input[name='lader']:checked").each(function() {
				var obj = new Object();  
				obj.ldId =$(this).val();
				obj.apply_no=$(this).next().val();    
				var men="";
				$(this).parent().parent().children(":last").find("input").each(function() {
					men=men+this.value + ",";
				});
				obj.meId = men;
				var m=$(this).parent().parent().find("td").eq(4).text().replace("月","");
				if(m.length==1){
					m="0"+m;
				}
				obj.month=$("#month").val()+"-"+m;
				list.push(obj);
			});
			var json_str = JSON.stringify(list);
				$.post("${ctx}/extxz/insertRadomPerson",{
					strlist : json_str
				}, function(res) {
					if(res=="sucess"){
						alert("保存成功");
						window.location.href="/ciqs/expFoodProd/list";
					}
				});
			
		});
		
		//弹窗
		function expertise(e,param){
		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
			$("#hxtd").prev().show();
			$("#zytd").prev().show();
			$("#zzytd").prev().show();
			$("#zfjdtd").prev().show();
			$("#hxtd").show();
			$("#zytd").show();
			$("#zzytd").show();
			$("#zfjdtd").show();
		
			var parent=$(e).parent().prev().children().val();
			if(parent=="hxtd"){//核心团队
			$("#zytd").prev().hide();
			$("#zzytd").prev().hide();
			$("#zfjdtd").prev().hide();
			$("#zytd").hide();
			$("#zzytd").hide();
			$("#zfjdtd").hide();
			}
			if(parent=="zytd"){//专业团队
			$("#hxtd").prev().hide();
			$("#zzytd").prev().hide();
			$("#zfjdtd").prev().hide();
			$("#hxtd").hide();
			$("#zzytd").hide();
			$("#zfjdtd").hide();
			}
			if(parent=="zzytd"){//准专业团队
			$("#hxtd").prev().hide();
			$("#zytd").prev().hide();
			$("#zfjdtd").prev().hide();
			$("#hxtd").hide();
			$("#zytd").hide();
			$("#zfjdtd").hide();
			}
			if(parent=="zfjgtd"){//执法监管团队
			$("#hxtd").prev().hide();
			$("#zytd").prev().hide();
			$("#zzytd").prev().hide();
			$("#hxtd").hide();
			$("#zytd").hide();
			$("#zzytd").hide();
			}
		
		
		
			//1为组长，2为组员
			if(param==1){
				$("#btn").remove();
				$("#btn_order").remove();
				//$("#psnExpertise").val();
				var input = "<input type='button' id='btn' value='确定' onclick='getExpertise1()' />";
				$("#btnTd").append(input);
			}
			if(param==2){
				$("#btn").remove();
				$("#btn_order").remove();
				//$("#z_psnExpertise").val("");
				var input = "<input type='button' id='btn' value='确定' onclick='getExpertise2(\""+bj+"\")' />";
				$("#btnTd").append(input);
			}
			$.blockUI({ message: $('#expertise'),
			                css:{top:100,left:500}
			});
		}
		
		function expertise2(e,param){
		$('input[name="expertise_code"]:checked').attr("checked",false);
		var bj=e.getAttribute("id");
			//1为组长，2为组员
			if(param==1){
				$("#btn").remove();
				$("#btn_order").remove();
				//$("#psnExpertise").val();
				var input = "<input type='button' id='btn_order' value='确定' onclick='getExpertise1_order()' />";
				$("#btnTd_order").append(input);
			}
			if(param==2){
				$("#btn").remove();
				$("#btn_order").remove();
				//$("#z_psnExpertise").val("");
				var input = "<input type='button' id='btn' value='确定' onclick='getExpertise2_order(\""+bj+"\")' />";
				$("#btnTd_order").append(input);
			}
			$.blockUI({ message: $('#expertise_order'),
			                css:{top:100,left:500}
			});
		}
		
		function closeUI(){
			$.unblockUI();
		}
		
		function deptTop(e,param){
	  		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
				$("#combtn").remove();
				var input = "<input type='button' id='combtn' value='确定' onclick='getExperCom(\""+bj+"\")' />";
				$("#btnTdcom").append(input);
				$.blockUI({ message: $('#deptTop_1'),
			          css:{top:100,left:500}
				});
	  	}
	  	
	  	 function deptTop_2(e,param){
	  		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
				$("#combtn_2").remove();
				var input = "<input type='button' id='combtn_2' value='确定' onclick='getExperCom(\""+bj+"\")' />";
				$("#btnTdcom_2").append(input);
				$.blockUI({ message: $('#deptTop_2'),
			          css:{top:100,left:500}
				});
	  	}
	  	
	  	 function deptTop_3(e,param){
	  		$('input[name="expertise_code"]:checked').attr("checked",false);
			var bj=e.getAttribute("id");
				$("#combtn_3").remove();
				var input = "<input type='button' id='combtn_3' value='确定' onclick='getExperCom(\""+bj+"\")' />";
				$("#btnTdcom_3").append(input);
				$.blockUI({ message: $('#deptTop_3'),
			          css:{top:100,left:500}
				});
	  	}
		
		function getExperCom(e){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
	  		$("#"+e).val(chk_value1);
	  		$.unblockUI();
	  	}
		
	  	//组长专长
	  	function getExpertise1(){
	  		var chk_value =[]; 
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value.push($(this).val()); 
	  		}); 
	  		$("#psnExpertise").val(chk_value);
	  		$.unblockUI();
	  	}
	  	//组员专长
	  	function getExpertise2(){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
	  		$("#z_psnExpertise").val(chk_value1);
	  		$.unblockUI();
	  	}
	  	
	  	//组长专长
	  	function getExpertise1_order(){
	  		var chk_value =[]; 
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value.push($(this).val()); 
	  		}); 
	  		$("#psnExpertise_order").val(chk_value);
	  		$.unblockUI();
	  	}
	  	//组员专长
	  	function getExpertise2_order(){
	  		var chk_value1 =[];
	  		$('input[name="expertise_code"]:checked').each(function(){ 
	  			chk_value1.push($(this).val()); 
	  		}); 
	  		$("#z_psnExpertise_order").val(chk_value1);
	  		$.unblockUI();
	  	}
	</script>
</body>
</html>