<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
</head>
<body>
	<div id="content">
	<form action="${ctx}/work/submitDoc" method="post">
	<input type ="hidden" name="ProcMainId" value="${license_dno}" />
	<input type ="hidden" name="DocType" value="D_D_PDF" />
	
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;">
            <p align="center">中华人民共和国<br>
            口岸卫生许可证 </p></td>
        </tr>
    </table>
    <table  align="center" style="font-size: 14px;line-height: 30px;"  class="tableLine">
<tr><td style="width:249px">
  单位名称
</td><td> <input type="text" style="width:124px;border: none;outline: none" name="option1" value="${doc.option1}"  placeholder="单位名称"/></td>
</tr> 
  <tr><td>
  法定代表人（负责人或经营人）
  </td><td> <input type="text" style="width:124px;border: none;outline: none" name="option2" value="${doc.option2}"  placeholder="法定代表人"/></td>
    <tr><td>
  经营地址
  </td><td> <input type="text" style="width:124px;border: none;outline: none" name="option3" value="${doc.option3}"  placeholder="经营地址"/></td>
    <tr><td>
  经营范围
  </td><td> <input type="text" style="width:124px;border: none;outline: none" name="option4" value="${doc.option4}"  placeholder="经营范围"/></td>
    <tr><td>
  备注
  </td><td> <input type="text" style="width:124px;border: none;outline: none" name="option5" value="${doc.option5}"  placeholder="备注"/></td>
    <tr><td>
  有效期限          
  </td><td>  <input type="text" style="width:124px;border: none;outline: none" name="option6" value="${doc.option6}"  placeholder="有效期限 "/>
  至 <input type="text" style="width:124px;border: none;outline: none" name="option7" value="${doc.option7}"  placeholder="有效期限 "/></td>
      </table>
    
    <div style="text-align: center;margin-top:20px;" class="noprint">
        <span> 
			<input onClick="javascript:window.close();" type="button" class="btn" value="返回" />
            <input type="submit" value="提交" class="btn"  />
      </span>
    </div>
    </form>
</div>
</body>
