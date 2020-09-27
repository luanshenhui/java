<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>权限管理</title>
<%@ include file="/common/resource.jsp"%>
<script type="text/javascript"> 

</script>
<style type="text/css">
table{
    font-size: 25px;
    width:700px;
}
tr{
    height: 35px;
}
td{
    border: 1px solid #000;
}
.table_1_1{
    font-size:25px;
    font-family:'楷体_GB2312';
    font-weight: bold;
    width:700px;
    text-align:certer;
    border-color: white;
}
.table_2_1{
    font-size:20px;
    font-family:'楷体_GB2312';
    text-align:right;
    border-color: white  white  #000 white;
}
.table_3_1{
    height:90px;
    width:40px;
}
.table_4_1,.table_5_1,.table_8_1{
    height:180px; 
}
.table_11_1{
    height:90px;
}
.table_5_2,.table_8_2{
    height:110px;
}
.table_6_2,.table_6_3,.table_7_2,.table_7_3,.table_9_2,.table_10_2{
    border-top-style: hidden;
}
.table_6_3,.table_7_3{
    border-left-style: hidden;
}
.wordsRight{
    display: block;
    text-align: right;
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
  <form id="form" action="/ciqs/generalPunishment/updateDoc" method="post">
  <input type="hidden" name="id" value="${id }"/>
      <input type="hidden" name="step" value="${step }"/>
      <input type="hidden" name="page" value="gp_yanqi_spb"/>
      
   	  <input type="hidden" name="doc_id" value="${doc.doc_id }"/>
   	  <input type="hidden" name="doc_type" value="${doc.doc_type }"/>
   	  <input type="hidden" name="proc_main_id" value="${doc.proc_main_id }"/>
  <table>
    <tr>
     <td colspan="3" class="table_1_1"><span>行政处罚案件办理审批表</span></td>
    </tr>
    
    <tr>
      <td colspan="3" class="table_2_1">案号：（<span><input name="option_1" value="${doc.option_1 }" style="width:100px;"/></span>）检立[<span><input name="option_2" value="${doc.option_2 }" style="width:100px;"/></span>]号</td>
    </tr>
    
    <tr>
      <td class="table_3_1"><span>案由</span></td>
      <td colspan="2" class="table_3_2"><span class="tableWords"><input name="option_3" value="${doc.option_3 }" style="width:500px;"/></span></td>
    </tr>
    
    <tr>
      <td class="table_4_1"><span>申报事由</span></td>
      <td colspan="2" class="table_4_2"><span class="tableWords"><input name="option_6" value="${doc.option_6 }" style="width:500px;"/></span></td>
    </tr>
    
    <tr>
      <td rowspan="3" class="table_5_1"><span>请批建议</span></td>
      <td colspan="2" class="table_5_2"><span class="tableWords"><input name="option_9" value="${doc.option_9 }" style="width:200px;"/></span></td>
    </tr>
    <tr>
      <td class="table_6_2"><span>经办人：</span><span><input name="option_10" value="${doc.option_10 }" style="width:100px;"/></span></td>
      <td class="table_6_3"><span>审查人：</span><span></span><input name="option_11" value="${doc.option_11 }" style="width:100px;"/></td>
    </tr>
    <tr>
      <td class="table_7_2"><span class="wordsRight"><input name="option_12" value="${doc.option_12 }" style="width:80px;"/> 年   <input name="option_13" value="${doc.option_13 }" style="width:40px;"/> 月    <input name="option_14" value="${doc.option_14 }" style="width:40px;"/>   日</span></td>
      <td class="table_7_3"><span class="wordsRight"><input name="option_15" value="${doc.option_15 }" style="width:80px;"/> 年   <input name="option_16" value="${doc.option_16 }" style="width:40px;"/>  月    <input name="option_17" value="${doc.option_17 }" style="width:40px;"/>   日</span></td>
    </tr>
    
    <tr>
      <td rowspan="3" class="table_8_1"><span>审批意见</span></td>
      <td colspan="2" class="table_8_2"><span class="tableWords"><input name="option_18" value="${doc.option_18 }" style="width:200px;"/></span></td>
    </tr>
     <tr>
      <td colspan="2" class="table_9_2"><span>审批人：</span><span><input name="option_19" value="${doc.option_19 }" style="width:100px;"/></span></td>
    </tr>
    <tr>
      <td colspan="2" class="table_10_2"><span class="wordsRight"><input name="option_20" value="${doc.option_20 }" style="width:80px;"/> 年   <input name="option_21" value="${doc.option_21 }" style="width:40px;"/>  月  <input name="option_22" value="${doc.option_22 }" style="width:40px;"/>     日</span></td>
    </tr>
    
    <tr>
      <td class="table_11_1"><span>备注</span></td>
      <td colspan="2" class="table_11_2"><span class="tableWords">本表用于行政处罚审批、案件移送、指定管辖、登记保存（查封、扣押、封存）、案件调查延期、撤案、延（分）期缴纳罚款、撤销（变更）行政处罚等有关内部工作流程事项的审批。</span></td>
    </tr>
  </table>
  </form>
  <input type="button" value="提交" onclick="javascript:$('form').submit();"/>
  <input type="button" value="打印" onclick="window.print();"/>
</div>  
</body>
</html>