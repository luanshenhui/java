<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<script language= "javascript" src="<%=request.getContextPath() %>/pages/orden/printjsp.js"></script>
<style type="text/css" media=print>
      .noprint{display : none } 
</style>
<SCRIPT language=javascript>
    function printpreview() {
        // 打印页面预览 
        wb.execwb(7, 1);
    }
</SCRIPT>
<OBJECT classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" height=0 id=wb name=wb width=3></OBJECT>
<!--startprint-->
<div id="ordenPrint"></div>
<!---endprint-->
<div class="list_search noprint" style="text-align: right;padding-right: 15px;">
	<a id="btnCancelOrden"><s:text name="btnCancelOrden"></s:text></a>
	<a onclick="javascript:printpreview();"><s:text name="btnPrintOrden"></s:text></a>
</div>