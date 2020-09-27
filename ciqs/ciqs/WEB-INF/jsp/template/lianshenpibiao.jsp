<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>立案审批表</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 

</script>
<style type="text/css">
table{
    font-size: 25px;
}
tr{
    height: 35px;
}
td{
    border: 1px solid #000;
}
.tableLine_1,.tableLine_2{
    font-size:25px;
    font-family:'楷体_GB2312';
    font-weight: bold;
    width:700px;
    text-align:certer;
    border-color: white;
}
.tableLine_3{
    font-size:20px;
    font-family:'楷体_GB2312';
    text-align:right;
    border-color: white  white  #000 white;
}
.tableLine_title{
    height:180px;
    width:40px;
}
.tableCol_2{
    height:30px;
    width:55px;
}
.tableCol_3{
    width:112px;
}
.tableCol_4{
    width:55px;
}
.tableCol_5{
    width:55px;
}
.tableCol_6{
    width:55px;
}
.tableCol_7{
    width:55px;
}
.tableCol_8{
    width:55px;
}
.tableCol_9{
    width:55px;
}
.tableLine_8,.tableLine_11{    
    height:110px;
}
.tableLine_9_2,.tableLine_12_2{
   border-style:hidden;
}
.tableLine_9_3,.tableLine_12_3{
   border-top-style:hidden;
   border-bottom-style:hidden;
}
.tableLine_10_2,.tableLine_13_2{
   border-right-style:hidden;
}
.tableLine_14{
   height:145px;
   border-bottom-style:hidden;
}
.tableLeft{
    display: block;
    margin-left: 0px;
    float: left;
}
.tableRight{
    display: block;
    float: right;
    margin-right: 20px;
}
.tableWords{
    display: block;
    white-space: normal;
    width: 651px;
}
    
</style>
</head>
<body>
<div id="content">
  <table>
    <tr>
      <td colspan="9" class="tableLine_1"><h1>中华人民共和国出入境检验检疫局</h1></td>
    </tr>
    <tr>
      <td colspan="9" class="tableLine_2"><h1>行政处罚案件立案审批表</h1></td>
    </tr>
    <tr>
      <td colspan="9" class="tableLine_3">案号：（<span></span>）检立[<span></span>]号</td>
    </tr>
    <tr>
      <td rowspan="3" class="tableLine_title"><span>当事人</span></td>
      <td class="tableCol_2"><span>姓名</span></td>
      <td class="tableCol_3"><span></span></td>
      <td class="tableCol_4"><span>性别</span></td>
      <td class="tableCol_5"><span></span></td>
      <td class="tableCol_6"><span>出生年月</span></td>
      <td class="tableCol_7"><span></span></td>
      <td class="tableCol_8"><span>国籍</span></td>
      <td class="tableCol_9"><span></span></td>
    </tr>
    <tr>
      <td><span>单位名称</span></td>
      <td colspan="4"><span  ></span></td>
      <td><span>法定代表人</span></td>
      <td colspan="2"><span></span></td>
    </tr>
    <tr>
      <td><span>住址或地址</span></td>
      <td colspan="4"><span></span></td>
      <td><span>电话</span></td>
      <td colspan="2"><span></span></td>
    </tr>
    
    <tr>
      <td class="tableLine_title"><span>立案事由</span></td>
      <td colspan="8"><span class="tableWords"></span></td>
    </tr>
    
    <tr>
      <td rowspan="3" class="tableLine_title"><span>立案意见</span></td>
      <td colspan="8" class="tableLine_8"><span class="tableWords"></span></td>
    </tr>
    <tr>
      <td colspan="4" class="tableLine_9_2"><span class="tableLeft">经办人：</span><span class="tableRight"></span></td>
      <td colspan="4" class="tableLine_9_3"><span class="tableLeft">审批人：</span><span class="tableRight"></span></td>
    </tr>
    <tr>
      <td colspan="4" class="tableLine_10_2"><span class="tableLeft">年        月      日</span></td>
      <td colspan="4"><span class="tableLeft">年        月      日</span></td>
    </tr>
    
    <tr>
      <td rowspan="3" class="tableLine_title"><span>审核意见</span></td>
      <td colspan="8" class="tableLine_11"><span class="tableWords"></span></td>
    </tr>
    <tr>
      <td colspan="4" class="tableLine_12_2"><span class="tableLeft">经办人：</span><span class="tableRight"></span></td>
      <td colspan="4" class="tableLine_12_3"><span class="tableLeft">审批人：</span><span class="tableRight"></span></td>
    </tr>
    <tr>
      <td colspan="4" class="tableLine_13_2"><span class="tableLeft">年        月      日</span></td>
      <td colspan="4"><span class="tableLeft">年        月      日</span></td>
    </tr>
    
    <tr>
      <td rowspan="2" class="tableLine_title"><span>立案审批</span></td>
      <td colspan="8" class="tableLine_14"><span class="tableWords"></span></td>
    </tr>
    <tr>
      <td colspan="8" class="tableLine_15"><span class="tableLeft">年        月      日</span></td>
    </tr>
  </table>
  <input type="button" value="打印" onclick="window.print();"/>
</div>        
</body>
</html>