<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>检疫查验记录</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css"> 
body div{
    text-align: center;    
    margin: 0 auto;
    font-size:22px;
}
table{
    margin-top:10px;
    width:100%;
}
tr{
    height:30px; 
}
td{
    border: 1px solid #000;
    padding:3px;  
}
.title_style{
    font-size:30px;
    font-weight: 600;
}
</style>
</head>
<body>
<div style="width:700px">
     <div class="title_style"><span>检疫查验记录</span></div>
     <table>
           <tbody>
                 <tr>
                     <td style="width:100px">健康证书</td>
                     <td colspan="2" style="width:240px"><c:if test="${results.option_1=='0'}"><span>是</span></c:if><c:if test="${results.option_1=='1'}"><span>否</span></c:if></td>
                     <td style="width:120px">是否查验</td>
                     <td style="width:240px"><c:if test="${results.option_2=='0'}"><span>是</span></c:if><c:if test="${results.option_2=='1'}"><span>否</span></c:if></td>
                 </tr> 
                 <tr>
                     <td>船员人数</td>
                     <td style="width:90px">名</td>
                     <td colspan="2" style="width:240px">中方：${results.option_3}</td>
                     <td style="width:240px">外方：${results.option_4}</td>
                 </tr>
                 <tr>
                     <td>旅客人数</td>
                     <td>名</td>
                     <td colspan="2">中方：${results.option_5}</td>
                     <td>外方：${results.option_6}</td>
                 </tr> 
                 <tr>
                     <td colspan="5" style="text-align:left">卫生监督查验结果如下：</td>
                 </tr>
                 <tr>
                     <td>医学检查</td>
                     <td colspan="4">
                         <ul style="text-align:left">
                            <c:forEach var="every" items="${fn:split(results.option_7,',')}">
                            <li>${every}</li>
                            </c:forEach>
                         </ul>
                     </td>
                 </tr>                         
           </tbody>
     </table>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
</div>     
</body>
</html>