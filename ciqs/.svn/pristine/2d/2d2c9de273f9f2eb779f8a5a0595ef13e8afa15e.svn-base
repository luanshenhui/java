<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
</head>
<script language="javascript" type="text/javascript">
	function dayin() {
		window.print();
	}
	
	$(function(){
		var jdyj = $("#jdyj").val();
		var jdyj_hide = $("#jdyj_hide").val();
		if(jdyj == ""){
			if(jdyj_hide == 0){
				$("#jdyj").val("不予许可");
			}else if(jdyj_hide == 1){
				$("#jdyj").val("准予许可");
			}
		}
	})
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
	<input type ="hidden" name="ProcMainId" value="${license_dno}" />
	<input type ="hidden" name="DocType" value="F_CARD" />
	<input type ="hidden" name="DocId" value="${doc.docId}" />
	<input type ="hidden" id="jdyj_hide" value="${flowCardList.jd_sp}" />
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">国境口岸卫生许可工作流程卡 </p></td>
        </tr>
    </table>
    <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
            <td width="117" align="center" ><input type="hidden" name="option1" value="${flowCardList.comp_name}" />${flowCardList.comp_name}</td>
      </tr>
      <tr>
        <td height="42" align="center" class="tableLine">许可项目</td>
        <td colspan="3" class="tableLine">
        	<input type="checkbox" name="option2" value="1"  <c:if test="${flowCardList.management_type == 1}"> checked="checked" </c:if>  />食品生产&nbsp;<input type="checkbox" name="option2" value="2" <c:if test="${flowCardList.management_type == 2}"> checked="checked" </c:if>  />食品流通&nbsp;
        	<input type="checkbox" name="option2" value="3" <c:if test="${flowCardList.management_type == 3}"> checked="checked" </c:if> />餐饮服务&nbsp;<input type="checkbox" name="option2" value="4" <c:if test="${flowCardList.management_type == 4}"> checked="checked" </c:if>  />饮用水供应&nbsp;
            <input type="checkbox" name="option2" value="5" <c:if test="${flowCardList.management_type == 5}"> checked="checked" </c:if> />公共场所&nbsp;
        </td>
      </tr>
      <tr>
        <td rowspan="10" align="center" class="tableLine">受理</td>
        <td width="288" rowspan="2" class="tableLine">申请材料提交</td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option3" value="${st_0.opr_psn}"/>申请人：${st_0.opr_psn}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option4" value="${st_0.opr_date_str}" />日期：${st_0.opr_date_str}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option5" value="${st_1.opr_psn}" />材料接受人：${st_1.opr_psn}</td>
        <td class="tableLine"><input type="hidden" name="option6" value="${st_1.opr_date_str}" />日期：
        ${st_1.opr_date_str}
        </td>
      </tr>
      <tr>
        <td width="288" rowspan="2" class="tableLine"><p >材料补正告知书</p></td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option7" value="${st_18.opr_psn}" />签发人：${st_18.opr_psn}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option8" value="${st_18.opr_date_str}" />日期：
        ${st_18.opr_date_str}
        </td>
      </tr>
      <tr>
        <td class="tableLine">
        	<input type="hidden" name="option9" value="${sdhz.option9}" />领取人：
	        <c:if test="${not empty st_18.opr_psn}">
	        	${sdhz.option9}
	        </c:if>
        </td>
        <td class="tableLine"><input type="hidden" name="option10" value="${st_18.opr_date_str}" />日期：${st_18.opr_date_str}</td>
      </tr>
      <tr>
        <td width="288" rowspan="2" class="tableLine">受理意见</td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option11" value="${st_1.opr_psn}" />受理人：${st_1.opr_psn}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option12" value="${st_1.opr_date_str}" />受理日期：${st_1.opr_date_str}</td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option13" value="${st_19.opr_psn}" />申请人：${st_19.opr_psn}</td>
        <td class="tableLine"><input type="hidden" name="option14" value="${st_19.opr_date_str}" />材料补正日期：
       ${st_19.opr_date_str}</td>
      </tr>
      <tr>
        <td width="288" rowspan="2" class="tableLine">出具《受理决定书》、《不予/受理决定书》、《检验限期告知书》</td>
        <td width="150" height="38" class="tableLine">
        <input type="hidden" name="option15" value="${st_1.opr_psn}"/>签发人：
        <c:if test="${empty st_18.opr_psn}" >
        ${st_1.opr_psn}
        </c:if>
        </td>
        <td width="143" class="tableLine">
        <input type="hidden" name="option16" value="${st_1.opr_date_str}" />签发日期：
        <c:if test="${empty st_18.opr_psn}" >
        ${st_1.opr_date_str}
        </c:if>
        </td>
      </tr>
      <tr>
        <td class="tableLine">
        	<input type="hidden" name="option17" value="${sdhz.option9}" />领取人：
	        <c:if test="${empty st_18.opr_psn}" >
	        	${sdhz.option9}
	        </c:if>
        </td>
        <td class="tableLine">
        	<input type="hidden" name="option18" value="${st_1.opr_date_str}" />日期：
        	<c:if test="${empty st_18.opr_psn}" >
        		${st_1.opr_date_str}
        	</c:if>
        </td>
      </tr>
     <tr>
        <td width="288" rowspan="2" class="tableLine"><p >初审意见</p></td>
        <td width="150" height="38" class="tableLine"><input type="hidden" name="option19" value="${st_20.opr_psn}" />初审人：${st_20.opr_psn}</td>
        <td width="143" class="tableLine"><input type="hidden" name="option20" value="${st_20.opr_date_str}" />日期：
        ${st_20.opr_date_str}
        </td>
      </tr>
      <tr>
        <td class="tableLine"><input type="hidden" name="option21" value="${st_2.opr_psn}" />部门负责人：${st_2.opr_psn}</td>
        <td class="tableLine"><input type="hidden" name="option22" value="${st_2.opr_date_str}" />日期：
         ${st_2.opr_date_str}
        </td>
      </tr>
      <tr>
        <td height="39" rowspan="4" align="center" class="tableLine">审查</td>
        <td colspan="3" class="tableLine">
        	实地审查意见（现场审查组组长）：
        	<input type="text" style="border: none;outline: none" name="option23" value="${ishg}" placeholder="现场审查组组长" />
        </td>
      </tr>
      <tr>
        <td colspan="2" class="tableLine">审查组成员：<input type="hidden" name="option24" value="${spproval_users_name}"/>${spproval_users_name}</td>
        <td class="tableLine"><input type="hidden" name="option25" value="${st_3.opr_date_str}"/>日期：
         ${st_3.opr_date_str}
       </td>
      </tr>
      
      <tr>
        <td colspan="3" class="tableLine">
        	复审意见（发证部门填写）： 
        	<input type="text" style="border: none;outline: none;" name="option26" size="50" placeholder="复查意见" />
        </td>
      </tr>
      <tr>
        <td colspan="2" class="tableLine">复审人：<input type="text" name="option27" value="${doc.option27}" placeholder="复审人" style="border: none;outline: none;text-align: left;"/></td>
        <td class="tableLine"><input type="hidden" name="option28" value="${st_4.opr_date_str}" />日期：
        ${st_4.opr_date_str}
        </td>
      </tr>
      <tr>
        <td height="38" rowspan="2" align="center" class="tableLine">决定</td>
        <td colspan="3" class="tableLine">
        	决定意见（发证部门主管领导填写）：
        	<input id="jdyj" type="text" style="border: none;outline: none" name="option29" placeholder="决定意见" />
        </td>
      </tr>
      <tr>
        <td colspan="2" class="tableLine">决定人：<input type="hidden" name="option30" value="${st_6.opr_psn}"/>${st_6.opr_psn} </td>
        <td class="tableLine"><input type="hidden" name="option31" value="${st_5.opr_date_str}" />日期：
         ${st_5.opr_date_str}
        </td>
      </tr>
      <tr>
        <td height="21" colspan="4" align="left" class="tableLine"><p >发证日期：
        <input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option32" placeholder="yyyy" />年
        <input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option33" placeholder="mm" />月
        <input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option34" placeholder="dd" />日 </p></td>
      </tr>
      <tr>
        <td height="21" colspan="4" align="left" class="tableLine">
        	证书编号：
        	<input type="text" style="border: none;outline: none" name="option35" placeholder="证书编号" />
        </td>
      </tr>
      <tr>
        <td height="42" colspan="4" class="tableLine">
        	有效期：<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option36" value="${doc.option35}" placeholder="yyyy" />
        	年<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option37" value="${doc.option36}" placeholder="mm" />
			月<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option38" value="${doc.option37}" placeholder="dd" />
			日至<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option39" value="${doc.option38}" placeholder="yyyy" />
			年<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option40" value="${doc.option39}" placeholder="mm" />
			月<input type="text" style="border: none;outline: none;text-align: right;" size="2" name="option41" value="${doc.option40}" placeholder="dd" />
			日
		</td>
      </tr>
      <tr>
        <td height="42" style="text-align:left;" class="tableLine">
        	备  注：
        </td>
        <td height="42" colspan="3" align="left" class="tableLine">
        	<input type="text" style="border: none;outline: none;" size="80" name="option42" />
        </td>
      </tr>
    </table>
    <div style="text-align: center;margin-top:20px;" class="noprint">
        <span> 
   			<input type="submit" value="提交" id="print" class="btn" />
            <input type="button" value="打印" id="print" class="btn" onClick="dayin()" />
      	</span>
    </div>
    </form>
</div>
</body>
