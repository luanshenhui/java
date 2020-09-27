<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/taglib/uniflow.tld" prefix="uniflow"%>

<html>

  	<head>
		<title>流向</title>
		<%@ include file="/unieap/ria3.3/pages/config.jsp" %>
		<uniflow:render-dc/>
		<script type="text/javascript">
		   function close()
		   {
            unieap.getDialog().close();
		   }
		</script>
	</head>
	
  	<body class="unieap" scroll=no>
	  	 <div dojoType="unieap.layout.TitlePane" title="节点流向信息" width="100%" height="272px" style="background:rgb(248,248,248);">
	        <div dojoType="unieap.grid.Grid" 
		       id="actsTable"
		       binding="{store:'transitions'}"
		       width="100%" height="200"
		       views="{rowNumber:true,orderType:'none'}">
	         <header>
	            <cell width="25%" label="节点名称" name="actdefName"></cell>
	            <cell width="25%" label="传输线描述" name="transitionName"></cell>
	            <cell width="25%" label="办理人" name="participants"></cell>
	            <cell width="25%" label="预测走向" name="conditionValue"></cell>
	         </header>
	       </div>
	       <div dojoType="unieap.form.Button" style="float:right;margin:5px auto auto auto;" label="关闭" onclick="close()"></div>
		 </div>
  	</body>
  	
<html>