<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="decorator" content="default" />
<title>新建分析</title>
<script type="text/javascript">
		 function func(){
		     var newName=$("#chartName").val();
		     if(!newName){
		     	alert("新建分析名不能为空");
		     }else{
		    	 var url="http://172.16.63.204:37799/WebReport/ReportServer?op=api&cmd=add_report&reportName="+newName;		    	 
		    	 $.ajax({
					    url:url,
					    type:'get', //GET
					    dataType:'jsonp',    //返回的数据格式：json/xml/html/script/jsonp/text
					    success:function(data){					    	
					    	if(data.result==undefined){
					    		alert("名字重复！");
					    	}else{
					    	var urlNew ="http://172.16.63.204:37799/WebReport/ReportServer"+data.result.buildUrl;
					    	window.location.href=urlNew;
					    }
					    }
			 	}) 
			 	
		     }
			}
	</script>
</head>
<body>
<div style="margin-top: 100px;" >

	    <label class="font-normal">新建分析名称: </label>
	    <input type="text" name="chartName" id="chartName" htmlEscape="true" maxlength="30"/>

    	<input type="button" name="addName" value="提交" onclick="func()"/>

</div>
</body>
</html>