<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>原产地证书签发行政确认全过程执法记录</title>
<%@ include file="/common/resource_show.jsp"%>
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
/* @media print { */
/* .noprint{display:none} */
/* } */
-->
.title a:link, a:visited {
	    color:white;
	    text-decoration: none;
	    }
</style>
</head>
<body  class="bg-gary">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">原产地证书签发确认</span></a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="blank_div_dtl">
</div>
<div class="margin-auto width-1200  data-box">
<div><h1 style="margin-left:366px;font-size: 208%">原产地业务实地调查记录单</h1>
	  <table width="700"  border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr>
              <td width="167" height="44" align="center" class="tableLine">企业名称</td>
              <td colspan="4" align="center" class="tableLine" >
             	${docs.option1}
              </td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">企业备案号</td>
            <td colspan="4" align="center" class="tableLine">${docs.option2}</td>
      </tr>
      <tr>
            <td height="44" align="center" class="tableLine">调查类别</td>
              <td colspan="4" align="left" class="tableLine">
              <div><input type="checkbox"  disabled="disabled" <c:if test="${docs.option3==0}"> checked="checked" </c:if>/>备案</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${docs.option3==1}"> checked="checked" </c:if>/> 签证调查</div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${docs.option3==2}"> checked="checked" </c:if>/> 产品变更 </div>
              <div><input type="checkbox"  disabled="disabled" <c:if test="${docs.option3==3}"> checked="checked" </c:if>/>异地调查结果单办理</div>
            </td>
      </tr>
      <tr>
            <td height="30" rowspan="8" align="center" class="tableLine">调查内容</td>
            <td width="131" align="center" class="tableLine"><p>产品名称<br/></p></td>
            <td width="131" align="center" class="tableLine">${docs.option4}</td>
            <td width="131" align="center" class="tableLine"><p>HS编码<br/></p></td>
            <td width="131" align="center" class="tableLine">${docs.option5}</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">拟出口国别</td>
        <td width="221" align="center"  colspan="3" class="tableLine">${docs.option6}</td>
      </tr>
      <tr>
        <td align="center" class="tableLine">原材料来源情况</td>
        <td width="221" align="center" colspan="3" class="tableLine">
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option7=='0'}"> checked="checked" </c:if>/> 有进口成分 
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option7=='1'}"> checked="checked" </c:if>/> 无进口成分
        </td>
      </tr>
       <tr>
        <td align="center" class="tableLine">随附单据情况</td>
        <td width="221" align="center" colspan="3" class="tableLine">
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option8==0}"> checked="checked" </c:if>/> 相符   
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option8==1}"> checked="checked" </c:if>/> 不相符  
        </td>
      </tr>
     <tr>
        <td align="center" class="tableLine">加工工序情况</td>
        <td width="221" align="center" colspan="3" class="tableLine">
       	<input type="checkbox"  disabled="disabled" <c:if test="${docs.option9==0}"> checked="checked" </c:if>/>相符   
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option9==1}"> checked="checked" </c:if>/> 不相符  
        </td>
      </tr>
       <tr>
        <td align="center" class="tableLine">设备情况</td>
        <td width="221" align="center" colspan="3" class="tableLine">
       	<input type="checkbox"  disabled="disabled" <c:if test="${docs.option10==0}"> checked="checked" </c:if>/>相符   
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option10==1}"> checked="checked" </c:if>/> 不相符  
        </td>
      </tr>
      <tr> 
        <td align="center" class="tableLine" rowspan="2">外包装情况</td>
        <td width="131" align="center" rowspan="2" class="tableLine">
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option11==0}"> checked="checked" </c:if>/>无唛头</td>
        <td width="131" align="center" rowspan="2" class="tableLine">
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option11==1}"> checked="checked" </c:if>/>有唛头</td>
        <td width="131" align="center" class="tableLine">
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option12==1}"> checked="checked" </c:if>/>&nbsp;不相符</td>
      </tr>
       <tr>
        <td width="131" align="center" class="tableLine">
        <input type="checkbox"  disabled="disabled" <c:if test="${docs.option12==0}"> checked="checked" </c:if>/>&nbsp;相符</td>
      </tr>
      <tr>
            <td height="30" rowspan="2" align="center" class="tableLine">调查结果</td>
            <td width="131" align="center" colspan="4" class="tableLine">
            <input type="checkbox"  disabled="disabled" <c:if test="${docs.option13==0}"> checked="checked" </c:if>/>调查通过，可进行 业务申报。</td>
      </tr>
      <tr>
            <td width="131" align="center" colspan="4" class="tableLine">
            <input type="checkbox"  disabled="disabled" <c:if test="${docs.option13==1}"> checked="checked" </c:if>/>调查未通过，退回申请。</td>
      </tr>
       <tr>
            <td height="44" align="center" class="tableLine">调查人</td>
            <td width="131" align="center" class="tableLine"><c:out value="${docs.option14}"></c:out></td>
            <td height="44" align="center" class="tableLine">调查时间</td>
            <td width="131" align="center" colspan="2" class="tableLine">
             ${docs.option15}
            </td>
      </tr>
 	  <tr>
            <td height="44" align="center" class="tableLine">被调查人</td>
            <c:if test="${not empty docs.option16}">
            <td height="44" align="center" colspan="4" class="tableLine">
	       		<img style="height: 30px;width: 60px;" src="/ciqs/showVideo?imgPath=${docs.option16}" alt="xx" /> 
            </td>
       		</c:if>
      </tr>
       <tr>
            <td height="44" align="center" class="tableLine">备注</td>
            <td height="44" align="center" colspan="4" class="tableLine">${docs.option17}</td>
      </tr>
      </table>
    </div> 
     <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
</div>
</body>
</html>
