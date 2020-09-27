<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生处理效果评价工作记录表</title>
<%@ include file="/common/resource.jsp"%>
<style type="text/css">
body div{
width:700px;
text-align: center;    
margin: 0 auto;
font-size:22px;
}
table{
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
.first_td{
    border-right-color: transparent;
    width:200px;
}
.second_td{
   text-align:left;
}
.second_td input{
    width: 18px;
    height: 18px;
    display: block;
    float: left;
    margin-top: 7px;
    readOnly:expression(this.readOnly=true);
}
</style>
</head>
<body>
<div>
    <div class="title_style"><span>卫生处理效果评价工作记录表</span></div>
    <table>
         <tbody>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_1 =='0'}"> checked="checked"</c:if>/><span>健康申报单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_2 =='0'}"> checked="checked"</c:if>/><span>总申报单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_3 =='0'}"> checked="checked"</c:if>/><span>货物申报单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_4 =='0'}"> checked="checked"</c:if>/><span>船员名单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_5 =='0'}"> checked="checked"</c:if>/><span>船用食品清单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_6 =='0'}"> checked="checked"</c:if>/><span>港口顺序清单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_7 =='0'}"> checked="checked"</c:if>/><span>电讯检疫申请单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_8 =='0'}"> checked="checked"</c:if>/><span>签发免予卫生控制证书</span></td></tr> 
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_9 =='0'}"> checked="checked"</c:if>/><span>签发卫生证书</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_10 =='0'}"> checked="checked"</c:if>/><span>旅客名单</span></td></tr>
             <tr><td class="first_td"></td><td class="second_td"><input type="checkbox" disabled="disabled"<c:if test="${results.option_11 =='0'}"> checked="checked"</c:if>/><span>签发卫生处理通知单</span></td></tr> 
         </tbody>
    </table>
    <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick="javascript:window.opener=null;window.open('','_self');window.close();">
</div>
</body>
</html>