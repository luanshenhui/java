<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>线索申报</title>
<%@ include file="/common/resource_new.jsp"%>

<!-- **** javascript *************************************************** -->
<script type="text/javascript">
	function submitForm() {
		if($("#accept_org").val() == ""){
			alert("请选择受理局");
			return;
		}
		if(confirm("确认提交？")){
			if($("#id").val()){
				$("#form").attr("action", "/ciqs/generalPunishment/update?random="+Math.random());
			}else{
				$("#form").attr("action", "/ciqs/generalPunishment/add?random="+Math.random());
			}
			$("#form").submit();
		}
	}
	
	function openNewPage1(targetUrl){
		window.open(targetUrl, "附件查看", "height=400, width=500, top=200, left=250, toolbar=no, menubar=no, scrollbars=yes, resizable=no, location=no, status=no");
	}
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>行政处罚 /一般处罚</span><div>");
		$(".user-info").css("color","white");
	});
	
	function openNewPageTemp(targetUrl){
		if($("#comp_name").val()){
			targetUrl += "&comp_name=";
			targetUrl += encodeURI($("#comp_name").val());
		}
		if($("#psn_name").val()){
			targetUrl += "&psn_name=";
			targetUrl += encodeURI($("#psn_name").val());
		}
		if($("#gender").val()){
			targetUrl += "&gender=";
			targetUrl += encodeURI($("#gender").find("option:selected").text());
		}
		if($("#birth").val()){
			targetUrl += "&birth=";
			targetUrl += $("#birth").val();
		}
		if($("#nation").val()){
			targetUrl += "&nation=";
			targetUrl += encodeURI($("#nation").val());
		}
		if($("#corporate_psn").val()){
			targetUrl += "&corporate_psn=";
			targetUrl += encodeURI($("#corporate_psn").val());
		}
		if($("#addr").val()){
			targetUrl += "&addr=";
			targetUrl += encodeURI($("#addr").val());
		}
		if($("#tel").val()){
			targetUrl += "&tel=";
			targetUrl += $("#tel").val();
		}
		openNewPage(encodeURI(targetUrl));
	}
//模拟form提交
function postcall( url, params, target,step,page,update,id){
//step=1&page=gp_shexiananjian_sbd&update=update
    var tempform = document.createElement("form");
    tempform.action = url;
    tempform.method = "post";
    tempform.style.display="none"
    if(target) {
        tempform.target = target;
    }
    
	if($("#comp_name").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "comp_name";
	      opt1.value = $("#comp_name").val();
	      tempform.appendChild(opt1);
	}
	if($("#psn_name").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "psn_name";
	      opt1.value = $("#psn_name").val();
	      tempform.appendChild(opt1);
	}
	if($("#gender").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "gender";
	      opt1.value = $("#gender").find("option:selected").text();
	      tempform.appendChild(opt1);
	}
	if($("#birth").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "birth";
	      opt1.value = $("#birth").val();
	      tempform.appendChild(opt1);
	}
	if($("#nation").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "nation";
	      opt1.value = $("#nation").val();
	      tempform.appendChild(opt1);
	}
	if($("#corporate_psn").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "corporate_psn";
	      opt1.value = $("#corporate_psn").val();
	      tempform.appendChild(opt1);
	}
	if($("#addr").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "addr";
	      opt1.value = $("#addr").val();
	      tempform.appendChild(opt1);
	}
	if($("#tel").val()){
	      var opt1 = document.createElement("input");
	      opt1.name = "tel";
	      opt1.value = $("#tel").val();
	      tempform.appendChild(opt1);
	}
		
      var opt1 = document.createElement("input");
      opt1.name = "step";
      opt1.value = step;
      tempform.appendChild(opt1);
     
      var opt2 = document.createElement("input");
      opt2.name = "page";
      opt2.value = page;
      tempform.appendChild(opt2);
      
      var opt3 = document.createElement("input");
      opt3.name = "update";
      opt3.value = update;
      tempform.appendChild(opt3);
 
 	  var opt4 = document.createElement("input");
      opt4.name = "id";
      opt4.value = id;
      tempform.appendChild(opt4); 
          
      if(params != null && params != ""){
	    for (var x in params) {
	        var opt = document.createElement("input");
	        opt.name = x;
	        opt.value = params[x];
	        tempform.appendChild(opt);
	    }
      }

    var opt = document.createElement("input");
    opt.type = "submit";
    tempform.appendChild(opt);
    document.body.appendChild(tempform);
    tempform.submit();
    document.body.removeChild(tempform);
}
</script>

</head>
<body>
<%@ include file="/common/headMenu_Pn.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：<a href="#">一般处罚</a> &gt; <a
				href="${cxt}/ciqs/generalPunishment/list?step=1">线索申报</a>
		</div>
		<jsp:include page="/common/message.jsp" flush="true"/>
		<div class="form">
			<div class="main">
				<form method="post" id="form" enctype="multipart/form-data">
					<input type="hidden" id="id" name="id" value="${model.id}"/>
			    	<input type="hidden" id="pre_report_no" name="pre_report_no" value="${model.pre_report_no}"/>
			    	<input type="hidden" id="step" name="step" value="1"/>
					<table id="form_table">
						<tbody>
							<tr>
				      			<th width="25%">
									单位名称：
								</th>
								<td width="25%">
									<input type="text" id="comp_name" name="comp_name" size="14" value="${model.comp_name}" class="text"/>
									<p></p>
								</td>
								<th width="25%">
									姓名：
							  	</th>
								<td width="25%">
									<input type="text" id="psn_name" name="psn_name" value="${model.psn_name}" size="14" class="text"/>
									<p></p>
								</td>
							</tr>
							<tr>
								<th width="25%">
									性别：
							  	</th>
								<td class="right" width="25%">
									<select id="gender" name="gender" class="select">
										<c:if test="${empty model.gender}">
											<option selected="selected" value="0">不详</option>
										</c:if>
										<c:if test="${not empty model.gender}">
											<option value="0">不详</option>
										</c:if>
										<c:if test="${'1' == model.gender}">
											<option selected="selected" value="1">男</option>
										</c:if>
										<c:if test="${'1' != model.gender}">
											<option value="1">男</option>
										</c:if>
										<c:if test="${'2' == model.gender}">
											<option selected="selected" value="2">女</option>
										</c:if>
										<c:if test="${'2' != model.gender}">
											<option value="2">女</option>
										</c:if>
									</select>
				       			</td>
<%-- 								<th width="25%">
									出生年月：
							  	</th>
								<td class="right" width="25%">
									<input name="birth" type="text" class="text datepick" id="birth" value="${model.birth}"/>
								</td> --%>
								<th width="25%">
									年龄：
							  	</th>
								<td class="right" width="25%">
									<input name="age" type="text" class="text" id="age" value="${model.age}"/>
								</td>
							</tr>
							<tr>
								<th width="25%">
									国籍：
							  	</th>
								<td class="right" width="25%">
									<input type="text" name="nation" id="nation" size="14" value="${model.nation}" class="text" />
								</td>
								<th width="25%">
									法定代表人：
							  	</th>
								<td class="right" width="25%">
									<input type="text" name="corporate_psn" id="corporate_psn" size="14" value="${model.corporate_psn}" class="text" />
								</td>
							</tr>
							<tr>
								<th width="25%">
									住址：
							  	</th>
								<td width="25%">
									<input type="text" name="per_addr" id="per_addr" size="14" value="${model.per_addr}" class="text" />
								</td>
								<th width="25%">
									单位地址：
							  	</th>
								<td width="25%">
									<input type="text" name="addr" id="addr" size="14" value="${model.addr}" class="text" />
								</td>
							</tr>
							<tr>
								<th width="25%">
									联系人：
							  	</th>
								<td width="25%">
									<input type="text" name="contacts_name" id="contacts_name" size="14" value="${model.contacts_name}" class="text" />
								</td>
								<th width="25%">
									联系电话：
							  	</th>
								<td width="25%">
									<input type="text" name="tel" id="tel" size="14" value="${model.tel}" class="text" />
								</td>
							
							</tr>
							<tr>
								<th width="25%">
									直属局：
							  	</th>
								<td width="25%">
									<select id="belong_org" class="select" name="belong_org">
										<option selected="selected" value="0">辽宁局</option>
									</select>
								</td>
								<th width="25%">
									出生年月：
							  	</th>
								<td class="right" width="25%">
									<input name="birth" type="text" class="text datepick" id="birth" value="${model.birth}"/>
								</td>
<%-- 								<th width="25%">
									《检验检疫涉嫌案件申报单》
								</th>
								<td width="25%">
									<c:if test="${model == null}">
										<a href='javascript:postcall("/ciqs/generalPunishment/toPage","${doc}","_blank","1","gp_shexiananjian_sbd","update","");'>在线填写</a>
									</c:if>
									<c:if test="${model != null}">
										<a href='javascript:postcall("/ciqs/generalPunishment/toPage","","_blank","1","gp_shexiananjian_sbd","update","${model.id}");'>在线填写</a>
									</c:if>
								</td> --%>
							</tr>
							<tr>
								<th width="25%">
									附件：
							  	</th>
								<td width="25%">
									<c:if test="${not empty gp_file_fj }">
										<a style="cursor:pointer;" href="/ciqs/generalPunishment/downloadFile?fileName=${gp_file_fj.file_location }">${gp_file_fj.file_location }</a><br/>
									</c:if>
									<input type="file" name="gp_file_fj"/>
								</td>
								<th width="25%">受理局</th>
								<td width="25%">
									<select name="accept_org" id="accept_org" <c:if test="${not empty model.step_2_status }"> disabled="disabled"</c:if>>
										<option value="" <c:if test="${empty model.accept_org }">selected="selected"</c:if>>请选择受理局</option>
										<c:forEach items="${orgList }" var="org">
											<option value="${org.code }" <c:if test="${org.code == model.accept_org }">selected="selected"</c:if> >${org.name }</option>
										</c:forEach>
									</select>
								</td>
							</tr>
						</tbody>

						<tfoot>
							<tr>
								<td colspan="100">
									<input class="button" value="提交" id="subb"
									type="button" onclick="javascript:submitForm();"/> 
									<input onclick="javascript:history.go(-1);"
									class="button" value="返回" type="button" />
								</td>
							</tr>
						</tfoot>
					</table>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
