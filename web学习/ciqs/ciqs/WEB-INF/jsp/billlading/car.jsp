<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>动植物产品及废料</title>
<%@ include file="/common/resource_new.jsp"%>
<style  type="text/css">
select,input{
    width:140px;
}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
			$(".user-info").css("color","white");
		});
	jQuery(document).ready(function(){
		$(".logo").html("<div style='float:left'><span class='font-24px' style='color:white;'>动植物产品及废料</span><div>");
		$(".user-info").css("color","white");
	});
</script>

</head>
<body>
<%@ include file="/common/headMenudyw.jsp"%>
	<div class="dpn-content">
		<div class="crumb">
			当前位置：动植物产品及废料 &gt; 在途跟踪
		</div>
		
	</div>
	<div>
			<iframe  src="http://ciq.dpn.com.cn/ciq-web2.0/toPasSsoMcConta.do?conta_no=${conta}"  frameborder=0  width="100%;" height="700px">  </iframe>
		</div>
	
	<div style="text-align: center;margin: auto;margin-top: 10px;width:200px;padding-bottom: 10px;">
			<input type="button" class="search-btn" value="返回"  onclick="JavaScript:history.go(-1);"/>
		</div>	
</body>
</html>