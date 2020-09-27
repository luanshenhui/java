<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>出口食品备案企业年度报告表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
h1{
    text-align: center;
    font-size: 30px;
}
table{
    margin-top: 30px;
/*     font-size: 25px; */
    line-height:32px;    
}
table tr td{
/*     text-align:left; */
    border: 1px solid #000;
    width:50px;
}
</style>
</head>
<body>
    <h1>出口食品备案企业年度报告表</h1>
     <table style="width: 665px">
     <tr>
       <td >备案编号:</td>
       <td  >${obj[0].recordnumber}</td>
     </tr>
      <tr>
       <td>企业名称:</td>
       <td >${obj[0].orgname}</td>
      </tr> 
      <tr>
       <td >企业地址:</td>
       <td  >${obj[0].productaddr}</td>
       </tr>
      <tr> 
       <td >备案类别:</td>
       <td  ><%-- ${obj.enter_type} --%></td>
       </tr>
      <tr> 
       <td>法人代表:</td>
       <td  >${obj[0].headname}</td>
        </tr>
      <tr>
       <td>联系电话:</td>
       <td  >${obj[0].phone}</td>
       </tr>
      <tr> 
       <td>企业性质:</td>
       <td >${obj[0].corpnature}</td>
       </tr>
      <tr> 
       <td>企业内审员:</td>
       <td >${obj[0].internalauditor}</td>
     </tr>
      <tr>
       <td  >声明和承诺 :</td>
         <td ><%-- ${obj.statement} --%></td>
     </tr>
      <tr>
       <td >附件 :</td>
       <td>
     	 <c:forEach items="${obj}" var="row">
     	 <a href="${ctx}/expFoodPOF/fileList?fileid=${row.attid}&filetype=${row.filetype}&filename=${row.attname}&path=${row.path}">${row.attname}</a>
		</br>
		</c:forEach>
     </td>
     </tr>
      <tr>
       <td  >说明 :</td>
        <td ></td>
     </tr>
    </table>
</body>
</html>