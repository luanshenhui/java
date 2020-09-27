<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>结构型数据</title>
	<meta name="decorator" content="default"/>
	<dca:resources />
	<link rel="stylesheet" type="text/css" href="/assets/dca/css/structuredDataList.css"> 
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
	<%-- <ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/dca/dcaWorkflowBasicIdx/">结构型数据</a></li>
	</ul> --%>
	<div class="font-normal span8 offset1">结构型数据加载请通过ETL进行实施，实施步骤如下：</div>
	<div class="clearfix"></div>
	<div class="structDataPic"></div>
</body>
</html>