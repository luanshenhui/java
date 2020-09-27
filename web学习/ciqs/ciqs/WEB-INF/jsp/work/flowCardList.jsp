<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
</head>
<script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
<script language="javascript" type="text/javascript">
	function dayin() {
		window.print();
	}
	
	$(function(){
	   if($("#msg").val() && $("#msg").val()=="success"){
 			        	alert("保存成功");
 			        }  
 			        if($("#alert").val() && $("#alert").val()=="error"){
 			        	alert("保存失败");
 			        }  
 			        $("#msg").val(""); 
	});
	
</script>

<style type="text/css">
<!--
.tableLine {
	border: 1px solid #000;
}
.fangxingLine {
	font-size:10;
	margin-left:5px;
	margin-right:5px;
	border: 2px solid #000;
	font-weight:900;
	padding-left: 3px;
	padding-right: 3px;
}
.tableLine2 {
	border: 1px solid #000;
	padding-left: 10px; 
}
.tableLine_noright {
	padding-left: 10px;
	border-top-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-bottom-style: solid;
	border-left-style: solid;
	border-top-color: #000;
	border-bottom-color: #000;
	border-left-color: #000;
}
.tableLine_noleft {
	padding-left: 10px;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-top-style: solid;
	border-right-style: solid;
	border-bottom-style: solid;
	border-top-color: #000;
	border-right-color: #000;
	border-bottom-color: #000;
}
@media print {
.noprint{display:none}
}
-->
</style>
<body>
	<div id="content">
	
	<form action="${ctx}/work/submitDoc" method="post">
	<input type ="hidden" name="ProcMainId" value="" />
	<input type ="hidden" name="DocType" value="F_CARD" />
	<input type ="hidden" id="msg" value="${msg}" />
	
	
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">国境口岸卫生许可工作流程卡 </p></td>
        </tr>
    </table>
    <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
            <td width="117" align="center" ><input type="hidden" name="option1" value="${doc.option1}" />${doc.option1}：</td>
      </tr>
      <tr>
        <td height="42" align="center" class="tableLine">许可项目</td>
         <td colspan="3" class="tableLine">
        	<input type="checkbox" name="option2" value="1"  <c:if test="${doc.option2 == 1}"> checked="checked" </c:if>  />食品生产&nbsp;<input type="checkbox" name="option2" value="2" <c:if test="${doc.option2 == 2}"> checked="checked" </c:if>  />食品流通&nbsp;
        	<input type="checkbox" name="option2" value="3" <c:if test="${doc.option2 == 3}"> checked="checked" </c:if> />餐饮服务&nbsp;<input type="checkbox" name="option2" value="4" <c:if test="${doc.option2 == 4}"> checked="checked" </c:if>  />饮用水供应&nbsp;
            <input type="checkbox" name="option2" value="5" <c:if test="${doc.option2 == 5}"> checked="checked" </c:if> />公共场所&nbsp;
        </td>
      </tr>
      <tr>
        <td rowspan="10" align="center" class="tableLine">受理</td>
        <td width="288" rowspan="2" class="tableLine">申请材料提交</td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option3" value="${doc.option3}"/>申请人：${doc.option3}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option4" value="${doc.option4}" />日期：${doc.option4}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option5" value="${doc.option5}" />材料接受人：${doc.option5}</td>
        <td class="tableLine"><input type="hidden" name="option6" value="${doc.option6}" />日期：${doc.option6}</td>
      </tr>
      <tr>
        <td width="288" rowspan="2" class="tableLine"><p >材料补正告知书</p></td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option7" value="${doc.option7}" />签发人：${doc.option7}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option8" value="${doc.option8}" />日期：${doc.option8}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option9" value="${doc.option9}" />领取人：${doc.option9}</td>
        <td class="tableLine"><input type="hidden" name="option10" value="${doc.option10}" />日期：${doc.option10}</td>
      </tr>
      <tr>
        <td width="288" rowspan="2" class="tableLine">受理意见</td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option11" value="${doc.option11}" />受理人：${doc.option11}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option12" value="${doc.option12}" />受理日期：${doc.option12}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option13" value="${doc.option13}" />申请人：${doc.option13}</td>
        <td class="tableLine"><input type="hidden" name="option14" value="${doc.option14}" />材料补正日期：${doc.option14}</td>
      </tr>
      <tr>
        <td width="288" rowspan="2" class="tableLine">出具《受理决定书》、《不予/受理决定书》、《检验限期告知书》</td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option15" value="${doc.option15}"/>签发人：${doc.option15}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option16" value="${doc.option16}" />签发日期：${doc.option16}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option17" value="${doc.option17}" />领取人：${doc.option17}</td>
        <td class="tableLine"><input type="hidden" name="option18" value="${doc.option18}" />日期：${doc.option18}</td>
      </tr>
     <tr>
        <td width="288" rowspan="2" class="tableLine"><p >初审意见</p></td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option19" value="${doc.option19}" />初审人：${doc.option19}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option20" value="${doc.option20}" />日期：${doc.option20}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option21" value="${doc.option21}" />部门负责人：${doc.option21}</td>
        <td class="tableLine"><input type="hidden" name="option22" value="${doc.option22}" />日期：${doc.option22}</td>
      </tr>
      <tr>
        <td height="39" rowspan="4" align="center" class="tableLine">审查</td>
        <td colspan="3" class="tableLine">
        	实地审查意见（现场审查组组长）：
        	<input type="text" style="border: none;outline: none" name="option23"  value="${doc.option23}" placeholder="现场审查组组长" />
        </td>
      </tr>
      <tr>
        <td colspan="2" class="tableLine">审查组成员：<input type="hidden" name="option24" value="${doc.option24}"/>${doc.option24}</td>
        <td class="tableLine"><input type="hidden" name="option25" value="${doc.option25}"/>日期：${doc.option25}</td>
      </tr>
      
      <tr>
        <td colspan="3" class="tableLine">
        	复审意见（发证部门填写）： 
        	<input type="text" style="border: none;outline: none;" name="option26" value="${doc.option26}" size="50" placeholder="复查意见" />
        </td>
      </tr>
      <tr>
        <td colspan="2" class="tableLine"><input type="hidden" name="option27" value="${doc.option27}" />复审人：${doc.option27}</td>
        <td class="tableLine"><input type="hidden" name="option28" value="${doc.option28}" />日期：${doc.option28}</td>
      </tr>
      <tr>
        <td height="38" rowspan="2" align="center" class="tableLine">决定</td>
        <td colspan="3" class="tableLine">
        	决定意见（发证部门主管领导填写）：
        	<input type="text" style="border: none;outline: none" name="option29" value="${doc.option29}" placeholder="决定意见" />
        </td>
      </tr>
      <tr>
        <td colspan="2" class="tableLine">决定人：<input type="hidden" name="option30" value="${doc.option30}"/>${doc.option30} </td>
        <td class="tableLine"><input type="hidden" name="option31" value="${doc.option31}" />日期：${doc.option31}</td>
      </tr>
      <tr>
        <td height="21" colspan="4" align="left" class="tableLine"><p >发证日期：
        <input type="text" style="border: none;outline: none;text-align: right;" size="2" value="${doc.option32}" name="option32" placeholder="yyyy" />年
        <input type="text" style="border: none;outline: none;text-align: right;" size="2" value="${doc.option33}" name="option33" placeholder="mm" />月
        <input type="text" style="border: none;outline: none;text-align: right;" size="2" value="${doc.option34}" name="option34" placeholder="dd" />日 </p></td>
      </tr>
      <tr>
        <td height="21" colspan="4" align="left" class="tableLine">
        	证书编号：
        	<input type="text" style="border: none;outline: none" value="${doc.option35}" name="option35" placeholder="证书编号" />
        </td>
      </tr>
      <tr>
        <td height="42" colspan="4" class="tableLine">
        	有效期：<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option36" value="${doc.option36}" placeholder="yyyy" />
        	年<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option37" value="${doc.option37}" placeholder="mm" />
			月<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option38" value="${doc.option38}" placeholder="dd" />
			日至<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option39" value="${doc.option39}" placeholder="yyyy" />
			年<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option40" value="${doc.option40}" placeholder="mm" />
			月<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option41" value="${doc.option41}" placeholder="dd" />
			日
		</td>
      </tr>
      <tr>
        <td height="42" style="text-align:left;" class="tableLine">
        	备  注：
        </td>
        <td height="42" colspan="3" align="left" class="tableLine">
        	<input type="text" style="border: none;outline: none;" size="80" value="${doc.option42}"  name="option42" />
        </td>
      </tr>
    </table>
    

    <div style="text-align: center;margin-top:20px;" class="noprint">
        <span> 
   			<input onClick="javascript:window.close();" type="button" class="btn" value="返回" />
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      	</span>
    </div>
    </form>
</div>
</body>
