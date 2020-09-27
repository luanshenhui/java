
<%--  --%><%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript">
		function submitForm10(){
			var forms = [];
			var message = "";
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '10';
					if($("#"+f.id+"_status")){
						/* f.status = $("#"+f.id+"_status").val(); */
					}
					if($("#"+f.id+"_forward").val()){
						if($("#"+f.id+"_forward").val()){
							f.forward_step = $("#"+f.id+"_forward").val();
							f.status = $("#"+f.id+"_forward").val();
						}else{
							message = "请选择审理建议一";
							return;
						}
					}
					if($("#"+f.id+"_forward_20").val()){
						if($("#"+f.id+"_forward_20").val()){
							f.forward_step = $("#"+f.id+"_forward_20").val();
							f.status = $("#"+f.id+"_forward_20").val();
							f.step = '20';
						}else{
							message = "请选择审理建议二";
							return;
						}
					}				
					forms.push(f);
				}
			});
			
			if("" != message){
				alert(message);
				return;
			}
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/audit",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
							alert("提交成功");
							window.location.href = "/ciqs/generalPunishment/listNew?step="+result;
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
	function submitForm1() {
		var forms = [];
		var flag = false;
		$("[name='check']:checkbox").each(function(i, e) {
			var f = {};
			if ($(this).is(":checked")) {
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '1';
				var tr = $(e).parent().parent().get(0);
				/* var value = tr.getElementsByTagName("select")[0].value; */
				var value = 1;
				if (value == '1' || value == '2') {
					f.status = value;
					forms.push(f);
				} else {
					flag = true;
				}
			}
		});
		if (flag == true) {
			alert("请选择要提交数据项审核状态！");
			return;
		}
		if (forms.length > 0) {
			if (confirm("是否确认提交？")) {
			console.log(forms);
			$.ajax({
						type : "post",
						url : "next",
						//async:false,
						data : JSON.stringify({
							"forms" : forms
						}),
						dataType : "json",
						contentType : "application/json",
						success : function(result) {
							alert("提交成功");
							window.location.href = "/ciqs/generalPunishment/listNew?step=1";
						}
					});
			}
		} else {
			alert("请选择提交审核的记录");
		}
	}
	
	function submitForm2() {
		var forms = [];
		var flag = false;
		$("[name='check']:checkbox").each(function(i, e) {
			var f = {};
			if ($(this).is(":checked")) {
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '2';
				var tr = $(e).parent().parent().get(0);
				var value = tr.getElementsByTagName("select")[0].value;
				if (value == '1' || value == '2') {
					f.status = value;
					forms.push(f);
				} else {
					flag = true;
				}
			}
		});
		if (flag == true) {
			alert("请选择要提交数据项审核状态！");
			return;
		}
		if (forms.length > 0) {
			if (confirm("是否确认提交？")) {
			$.ajax({
						type : "post",
						url : "auditRef",
						//async:false,
						data : JSON.stringify({
							"forms" : forms
						}),
						dataType : "json",
						contentType : "application/json",
						success : function(result) {
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step=2";
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
			}
		} else {
			alert("请选择提交审核的记录");
		}
	}
	
	function submitForm3(){
			var forms = [];
			/*
			$("input[name='check']['checked']").each(function(i, e){
				if(e.id.split('|')[2] == null || e.id.split('|')[2] == ''){
					var f = {};
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '3';
					f.status = '1';
					forms.push(f);
				}
			});
			*/
			var flag = false;
			$("select[name='status3']").each(function(i, e){
				if($(e).parent().parent().get(0).getElementsByTagName("input")[0].checked){
					if(e.value == '1' || e.value == '2'){
							var f = {};
							f.id = e.id.split('|')[0];
							f.pre_report_no = e.id.split('|')[1];
							f.step = '3';
							f.status = e.value;
							forms.push(f);
					}else{
						flag = true;
					}
				}
			});
			$("select[name='status16']").each(function(i, e){
				if($(e).parent().parent().get(0).getElementsByTagName("input")[0].checked){
					if(e.value == '1' || e.value == '2'){
							var f = {};
							f.id = e.id.split('|')[0];
							f.pre_report_no = e.id.split('|')[1];
							f.step = '16';
							f.status = e.value;
							forms.push(f);
					}else{
						flag = true;
					}
				}
			});
			$("select[name='status4']").each(function(i, e){
				if($(e).parent().parent().get(0).getElementsByTagName("input")[0].checked){
					if(e.value == '1' || e.value == '2'){
						var f = {};
						f.id = e.id.split('|')[0];
						f.pre_report_no = e.id.split('|')[1];
						f.step = '4';
						f.status = e.value;
						forms.push(f);
					}else{
						flag = true;
					}
				}
			});
			if(flag == true){
				alert('请选择要提交数据项审核状态！')
				return;
			}
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step=3";
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		
		function submitForm5(){
			var forms = [];
			/*
			$("input[name='check']['checked']").each(function(i, e){
				var f = {};
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '5';
				f.status = '1';
				forms.push(f);
			});
			$.ajax({
				type:"POST",
				url:"/ciqs/generalPunishment/audit",
				async:false,
				data:JSON.stringify({"forms": forms}),
				dataType:"json",
				contentType:"application/json"
			});
			*/
			var flag = false;
			$("select[name='status5']").each(function(i, e){
				if($(e).parent().parent().get(0).getElementsByTagName("input")[0].checked){
					if(e.value == '1' || e.value == '2' || e.value == '15'){
						var f = {};
						f.id = e.id.split('|')[0];
						f.pre_report_no = e.id.split('|')[1];
						f.step = '5';
						f.status = e.value;
						forms.push(f);
					}else{
						flag = true
					}					
				}
			});
			$("select[name='status17']").each(function(i, e){
				if($(e).parent().parent().get(0).getElementsByTagName("input")[0].checked){
					if(e.value == '1' || e.value == '2'  || e.value == '15'){
						var f = {};
						f.id = e.id.split('|')[0];
						f.pre_report_no = e.id.split('|')[1];
						f.step = '17';
						f.status = e.value;
						forms.push(f);
					}else{
						flag = true
					}					
				}
			});
			$("select[name='status6']").each(function(i, e){
				if($(e).parent().parent().get(0).getElementsByTagName("input")[0].checked){
					if(e.value == '1' || e.value == '2'  || e.value == '15'){
						var f = {};
						f.id = e.id.split('|')[0];
						f.pre_report_no = e.id.split('|')[1];
						f.step = '6';
						f.status = e.value;
						forms.push(f);
					}else{
						flag = true;
					}
				}
			});
			if(flag == true){
				alert('请选择要提交数据项审核状态！')
				return;
			}
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		function submitForm7(){
			var forms = [];
			/*
			$("select[name='status']").each(function(i, e){
				if(e.value == '1' || e.value == '2'){
					var f = {};
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '7';
					f.status = e.value;
					forms.push(f);
				}
			});
			$.ajax({
				type:"POST",
				url:"/ciqs/generalPunishment/audit",
				async:false,
				data:JSON.stringify({"forms": forms}),
				dataType:"json",
				contentType:"application/json"
			});
			*/
			var message = "";
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '7';
					f.status = $("#"+f.id+"_status").val();
					if(f.status == ""){
						message = "请填写审批建议";
					}
					forms.push(f);
				}
			});
			if(message != ""){
				alert(message);
				return;
			}
/* 			$("select[name='status']").each(function(i, e){
				if(e.value == '1' || e.value == '2'){
					var f = {};
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '7';
					f.status = e.value;
					forms.push(f);
				}
			}); */
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		
	function submitForm9() {
		var forms = [];
		/*
		$("select[name='status']").each(function(i, e){
			if(e.value == '1' || e.value == '2'){
				var f = {};
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '9';
				f.status = e.value;
				forms.push(f);
			}
		});
		 */
		$("[name='check']:checkbox").each(function(i, e) {
			var f = {};
			if ($(this).is(":checked")) {
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '9';
				f.status = '1';
				forms.push(f);
			}
		});
		if (forms.length > 0) {
			if (confirm("是否确认提交？")) {
				$
						.ajax({
							type : "POST",
							url : "/ciqs/generalPunishment/auditRef",
							//async:false,
							data : JSON.stringify({
								"forms" : forms
							}),
							dataType : "json",
							contentType : "application/json",
							success : function(result) {
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
							}
						});
			}
		} else {
			alert("请选择提交审核的记录");
		}
	}
	
	function submitForm18() {
		var forms = [];
		/*
		$("select[name='status']").each(function(i, e){
			if(e.value == '1' || e.value == '2'){
				var f = {};
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '9';
				f.status = e.value;
				forms.push(f);
			}
		});
		 */
		$("[name='check']:checkbox").each(function(i, e) {
			var f = {};
			if ($(this).is(":checked")) {
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '18';
				f.status = '1';
				forms.push(f);
			}
		});
		if (forms.length > 0) {
			if (confirm("是否确认提交？")) {
				$
						.ajax({
							type : "POST",
							url : "/ciqs/generalPunishment/auditRef",
							//async:false,
							data : JSON.stringify({
								"forms" : forms
							}),
							dataType : "json",
							contentType : "application/json",
							success : function(result) {
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
							}
						});
			}
		} else {
			alert("请选择提交审核的记录");
		}
	}
	
	function submitForm19() {
		var forms = [];
		/*
		$("select[name='status']").each(function(i, e){
			if(e.value == '1' || e.value == '2'){
				var f = {};
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '9';
				f.status = e.value;
				forms.push(f);
			}
		});
		 */
		$("[name='check']:checkbox").each(function(i, e) {
			var f = {};
			if ($(this).is(":checked")) {
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '19';
				f.status = '1';
				forms.push(f);
			}
		});
		if (forms.length > 0) {
			if (confirm("是否确认提交？")) {
				$
						.ajax({
							type : "POST",
							url : "/ciqs/generalPunishment/auditRef",
							//async:false,
							data : JSON.stringify({
								"forms" : forms
							}),
							dataType : "json",
							contentType : "application/json",
							success : function(result) {
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
							}
						});
			}
		} else {
			alert("请选择提交审核的记录");
		}
	}

	function submitForm() {
		var forms = [];
		/*
		$("select[name='status']").each(function(i, e){
			if(e.value == '1' || e.value == '2'){
				var f = {};
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '9';
				f.status = e.value;
				forms.push(f);
			}
		});
		 */
		$("[name='check']:checkbox").each(function(i, e) {
			var f = {};
			if ($(this).is(":checked")) {
				f.id = e.id.split('|')[0];
				f.pre_report_no = e.id.split('|')[1];
				f.step = '19';
				f.status = '1';
				forms.push(f);
			}
		});
		if (forms.length > 0) {
			if (confirm("是否确认提交？")) {
				$
						.ajax({
							type : "POST",
							url : "/ciqs/generalPunishment/auditRef",
							//async:false,
							data : JSON.stringify({
								"forms" : forms
							}),
							dataType : "json",
							contentType : "application/json",
							success : function(result) {
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = window.location.href;
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
							}
						});
			}
		} else {
			alert("请选择提交审核的记录");
		}
	}
	
	
	function submitForm11(){
			var message = "";
			var forms = [];
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '11';
/* 					if($("#"+f.id+"_status")){
						f.status = $("#"+f.id+"_status").val();
					} */
					if($("#"+f.id+"_forward").val()){
						if($("#"+f.id+"_forward").val()){
							f.status = $("#"+f.id+"_forward").val();
						}else{
							message = "请选择审理建议一";
							return;
						}
					}
					forms.push(f);
				}
			});
			if(message != ""){
				alert(message);
				return;
			}
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		
		function submitForm12(){
			var forms = [];
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '12';
					/* if($("#"+f.id+"_status")){
						f.status = $("#"+f.id+"_status").val();
					} */
					
					if($("#"+f.id+"_forward").val()){
						if($("#"+f.id+"_forward").val()){
							f.status = $("#"+f.id+"_forward").val();
						}else{
							message = "请选择审理建议一";
							return;
						}
					}
					forms.push(f);
				}
			});
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step=12";
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		function submitForm13(){
			var forms = [];
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '13';
					f.status = '1';
					forms.push(f);
				}
			});
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		function submitForm14(){
			var forms = [];
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '14';
					f.status = $("#"+f.id+"_forward").val();
					forms.push(f);
				}
			});
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/auditRef",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
								if(result){
									if(result.success){
										alert("提交成功");
										window.location.href = "/ciqs/generalPunishment/listNew?step="+'${step}';
									}else{
										alert(result.message);
									}
								}else{
									alert("系统错误");
								}
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
		
		function submitFormBack(){
			var forms = [];
			$("[name='check']:checkbox").each(function(i, e){
				var f = {};
				if($(this).is(":checked")){
					f.id = e.id.split('|')[0];
					f.pre_report_no = e.id.split('|')[1];
					f.step = '10';
					f.status = '2';
					forms.push(f);
				}
			});
			if(forms.length > 0){
				if(confirm("是否确认提交？")){
					$.ajax({
						type:"POST",
						url:"/ciqs/generalPunishment/audit",
						//async:false,
						data:JSON.stringify({"forms": forms}),
						dataType:"json",
						contentType:"application/json",
						success:function(result){
							alert("提交成功");
							window.location.href = "/ciqs/generalPunishment/listNew?step=10";
						}
					});
				}
			}else{
				alert("请选择提交审核的记录");
			}
		}
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
	
	<c:if test="${step == '1'}">
		<%@ include  file="./step1.jsp" %>
	</c:if>
	
	<c:if test="${step == '2'}">
		<%@ include  file="./step2.jsp" %>
	</c:if>
	
	<c:if test="${step == '3'}">
		<%@ include  file="./step3.jsp" %>
	</c:if>
	
	<c:if test="${step == '5'}">
		<%@ include  file="./step5.jsp" %>
	</c:if>
	
	<c:if test="${step == '7'}">
		<%@ include  file="./step7.jsp" %>
	</c:if>
	<c:if test="${step == '9'}">
		<%@ include  file="./step9.jsp" %>
	</c:if>
	<c:if test="${step == '18'}">
		<%@ include  file="./step18.jsp" %>
	</c:if>
	<c:if test="${step == '19'}">
		<%@ include  file="./step19.jsp" %>
	</c:if>
	<c:if test="${step == '10'}">
		<%@ include  file="./step10.jsp" %>
	</c:if>
	<c:if test="${step == '11'}">
		<%@ include  file="./step11.jsp" %>
	</c:if>
	<c:if test="${step == '12'}">
		<%@ include  file="./step12.jsp" %>
	</c:if>
	<c:if test="${step == '13'}">
		<%@ include  file="./step13.jsp" %>
	</c:if>
	<c:if test="${step == '14'}">
		<%@ include  file="./step14.jsp" %>
	</c:if>
</html>
				
				