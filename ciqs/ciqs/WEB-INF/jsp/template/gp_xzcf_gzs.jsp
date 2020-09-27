<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>行政处罚告知书</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 
$(function(){
		if($("#operation").val() == "close"){
			alert("保存成功！请点击确定关闭页面");
			/* window.location.href =  */
			window.close();
		}else{
			$("#option_11_ta").val($("#option_11").val());
		}
		
		if($("#subStep").val() == '0'){
			$("input, textarea").each(function(e){
				$(this).attr("readonly", "readonly");
			});
		}
	});
	
	function submitForm(){
		$("#option_11").val($("#option_11_ta").val());
		$("#form").submit();
	}
</script>
<style type="text/css">
table{
    font-size: 15px;
    width:700px;
}
tr{
    height: 35px;
}
td{
    border: 0px solid #000;
}
input{
	border: 0px;
	height:30px;
	text-align: center;
}
textarea{
	border:0px;
}

</style>
</head>
<body>
   <div id="content">
   	<input type="hidden" id="subStep" value="${subStep }"/>
   	 <input type="hidden" id="operation" value="${operation }"/>
   	 <form id="form" action="/ciqs/generalPunishment/updateDoc" method="post">
   	  <input type="hidden" name="id" value="${id }"/>
      <input type="hidden" name="step" value="${step }"/>
      <input type="hidden" name="page" value="gp_anjian_ysh_input"/>
      <input type="hidden" name="pre_report_no" value="${pre_report_no }"/>
   	  <input type="hidden" name="doc_id" value="${doc.doc_id }"/>
   	  <input type="hidden" name="doc_type" value="${doc.doc_type }"/>
   	  <input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
      <table>
      	<tr >
            <td style="font-size:25px;font-weight: bold;width:700px;text-align:certer;"><h1>中华人民共和国     出入境检验检疫局</h1></td>
        </tr>
        <tr >
            <td style="font-size:25px;font-weight: bold;width:700px;text-align:certer;"><h1>行政处罚告知书</h1></td>
        </tr>
        <tr></tr>
        <tr>
            <td style="text-align:right;">（<input name="option_1" value="${doc.option_1 }" style="width:100px;"/>）检罚告【<input name="option_2" value="${doc.option_2 }" style="width:100px;"/><span>】号</span></td>
        </tr>
        <tr>
            <td style="text-align:left;"><div style="border-bottom:1px solid #000;display:inline;zoom:1;float:left;min-width:200px; text-align: center;"><input name="option_3" value="${doc.option_3 }" style="width:180px;"/><span style="float:right;">:</span></div></td>
        </tr>
        <tr>
            <script type="text/javascript">
             function selectChange(_this){
              var index = _this.selectedIndex;
             	var cont1 = $(_this).find("option").eq(index).attr("cont");
             	var cont2 = $(_this).find("option").eq(index).attr("cont2");
             	$("#fondId").html(cont1+"<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;依据&nbsp;&nbsp;"+cont2)
             	$("#fondHid5").val(cont1);
             	$("#fondHid6").val(cont2);
             }

            </script>
            <td style="width:700px;text-align:left;">
                <span  style="line-height: 33px;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;经我局调查：
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;你（单位）的行为已违反了
                    <%-- 《<input name="option_4" value="${doc.option_4 }" style="width:200px;"/>》 --%>
                    
              <c:if test="${subStep != '0' }">      《</c:if>
                    <%-- <input name="option_4" value="${doc.option_4 }" style="width:200px;"/> --%>
                    <c:if test="${subStep == '0' }">
                    	<input type="hidden" name="option_4" value=${doc.option_4 }/>
                    	<%-- ${doc.option_4 } --%>
                    </c:if>
                    <c:if test="${subStep != '0' }">
	                     <select style="width:200px;height: 30px;" name="option_4" onchange="selectChange(this)">
	               	         <option cont="" cont2="" value="" <c:if test="${ empty doc.option_4}">selected="selected"</c:if>>请选择</option>
	                    	<c:forEach items="${tiaoList }" var='l'>
		                    	<option style="width: 100px;" value="${l.ILLEGAL_ACT }" <c:if test="${not empty doc.option_4 && l.ILLEGAL_ACT.contains(doc.option_4)}">selected="selected"</c:if> cont="${l.ILLEGAL_BASIS }" cont2="${l.PUNISH_BASIS }">${l.ILLEGAL_ACT }</option>
	                    	</c:forEach>
	                    </select>
                    </c:if>
                    <c:if test="${subStep != '0' }">	》</c:if>
                    	<font id="fondId">
                    		${doc.option_5 }<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<c:if test="${not empty doc.option_6 }">依据</c:if>&nbsp;&nbsp;${doc.option_6 }
                    	</font>
                    	<input id="fondHid5" type="hidden" name="option_5" value=${doc.option_5 }/>
                    	<input id="fondHid6" type="hidden" name="option_6" value=${doc.option_6 }/>
                <%--     第 <input name="option_5" value="${doc.option_5 }" style="width:60px;"/> 条第  <input name="option_6" value="${doc.option_6 }" style="width:60px;"/>款 --%>
<%--                     第  <input name="option_7" value="${doc.option_7 }" style="width:60px;"/>项的规定，根据《<input name="option_8" value="${doc.option_8 }" style="width:200px;"/>》
                    第 <input name="option_9" value="${doc.option_9 }" style="width:60px;"/> 条第<input name="option_10" value="${doc.option_10 }" style="width:60px;"/>  款
                    第 <input name="option_11" value="${doc.option_11 }" style="width:60px;"/> --%>
                     <br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;我局拟对你（单位）实施下列行政处罚：<br/>
                   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 依据《中华人民共和国行政处罚法》第三十一条、第三十二条的规定，你（单位）有陈述和申辩的权利；依据《中华人民共和国行政处罚法》第四十二条的规定，你（单位）有要求举行听证的权利。你（单位）可在本告知书送达后3日内进行陈述、申辩，符合听证条件的，可以提出举行听证要求。逾期未行使以上权利的，视为放弃。<br/>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：举行听证，仅适用于下列案件：<br/>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（一）对公民处以10000元以上罚款的；<br/>
    			   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（二）对法人或者其他组织处以100000元以上罚款的；<br/>
    			   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（三）撤销行政许可、吊销行政许可证件的；<br/>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（四）吊销已取得的检疫证单的；<br/>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（五）责令停产、停业的；   <br/>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（六）其他符合法律、法规规定的听证条件的。<br/>
				   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;特此告知。<br/>
                </span>
            </td>
        </tr>
        <tr>
            <td style="width:700px;text-align:left;"><span>本局地址：</span><input name="option_12" value="${doc.option_12 }" style="width:200px;text-align:left;"/></td>
        </tr>
        <tr>
            <td style="width:700px;text-align:left;"><span>联    系    人：</span><input name="option_13" value="${doc.option_13 }" style="width:100px;text-align:left;"/></td>
        </tr>
        <tr>
            <td style="width:700px;text-align:left;"><span>联系电话：</span><input name="option_14" value="${doc.option_14 }" style="width:100px;text-align:left;"/></td>
        </tr>
        <tr>
            <td style="width:700px;text-align:right;"><span><input name="option_15" value="${doc.option_15 }" style="width:100px;"/>&nbsp;年&nbsp;<input name="option_16" value="${doc.option_16 }" style="width:60px;"/>&nbsp;月&nbsp;<input name="option_17" value="${doc.option_17 }" style="width:60px;"/>&nbsp;日</span></td>
        </tr>
      </table>
      <div style="text-align: center;">
	      <c:if test="${subStep != '0' }">
		      <input type="button" style="width: 80px;height: 30px;" value="提交" onclick="submitForm();"/>
	      </c:if>
	  	  <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="关闭" onclick=" window.close()"/>
	  	  <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="打印" onclick="window.print();"/>
      </div>
      </form>
   </div>
</body>
</html>