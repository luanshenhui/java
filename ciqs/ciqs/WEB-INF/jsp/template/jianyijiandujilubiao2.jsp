<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>检疫查验卫生监督记录2</title>
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
     <div class="title_style"><span>卫生监督记录</span></div>
     <table>
           <tbody>
                 <tr>
                     <td style="width:140px">名称</td>
                     <td style="width:140px">装自港</td>
                     <td style="width:140px">日期</td>
                     <td colspan="2">数量</td>
                 </tr>
                 <tr>
                     <td>消毒压舱水</td>
                     <td>${results.option_1}</td>
                     <td>${results.option_2}</td>
                     <td colspan="2">${results.option_3}吨</td>
                 </tr>        
                 <tr>
                     <td>饮用水</td>
                     <td>${results.option_4}</td>
                     <td>${results.option_5}</td>
                     <td colspan="2">${results.option_6}吨</td>
                 </tr>        
                 <tr>
                     <td>食品蔬菜类</td>
                     <td>${results.option_7}</td>
                     <td>${results.option_8}</td>
                     <td colspan="2">${results.option_9}吨</td>
                 </tr>
                 <tr>
                 	<td>卫生状况</td>
                     <td><c:if test="${results.option_10=='0'}"><span>良</span></c:if><c:if test="${results.option_10=='1'}"><span>中</span></c:if><c:if test="${results.option_10=='2'}"><span>差</span></c:if></td>
                     <td>是否检出风险因子</td>
                     <td><c:if test="${results.option_11=='0'}"><span>是</span></c:if><c:if test="${results.option_11=='1'}"><span>否</span></c:if></td>
                 </tr>
                 <tr>
                     <td colspan="5" style="text-align:left">卫生监督查验结果如下：</td>
                 </tr>
                 <tr>
                     <td>动植物查验</td>
                     <td colspan="4">
                         <ul style="text-align:left">
                            <c:forEach var="every" items="${fn:split(results.option_13,',')}">
                            <li>${every}</li>
                            </c:forEach>
                         </ul>
                     </td>
                 </tr>
                  <tr>
                     <td>货物检查</td>
                     <td colspan="4">
                         <ul style="text-align:left">
                            <c:forEach var="every" items="${fn:split(results.option_14,',')}">
                            <li>${every}</li>
                            </c:forEach>
                         </ul>
                     </td>
                 </tr>          
                  <tr>
                     <td>应受处理事项</td>
                     <td colspan="4">
                         <ul style="text-align:left">
                            <c:forEach var="every" items="${fn:split(results.option_15,',')}">
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