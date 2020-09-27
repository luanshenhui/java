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
<script type="text/javascript">
		jQuery(document).ready(function(){
		$("#rlqr_3 tr:even").css("background-color","rgb(228, 242, 255)");
		$("#rlqr_3 tr").each(function(index,element){
				$(element).children().eq(1).attr("align","left");
			});
		});
</script>
</head>
<body  class="bg-gary">
<div class="title-bg" >
<div class=" title-position margin-auto white">
<div class="title"><a href="nav.html" class="white"><span  class="font-24px">证书审核确认事项单</span></a></div>
<%@ include file="/WEB-INF/jsp/userinfo.jsp"%>
</div>
</div>
<div class="blank_div_dtl">
</div>
<div class="margin-auto width-1200  data-box">
<div><h1 style="font-size: 208%" align="center">证书审核确认事项单</h1>
	  <table width="700" id="rlqr_3" border="0" align="center" style="font-size: 14px;line-height: 30px;" cellpadding="0" cellspacing="0"   class="tableLine">
      <tr><td class="tableLine" style="width: 50px;height: 50px;" colspan="3" align="left">一、纸质证书</td></tr>
      <tr><td class="tableLine" style="width: 50px;">1</td><td class="tableLine"  style="width: 599px;height: 50px;">预核销单已签字</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">2</td><td class="tableLine"  style="width: 599px;height: 50px;">卫生证书、附加证书及产地证书均为正本原件</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">3</td><td class="tableLine"  style="width: 599px;height: 50px;">《符合评估审查要求的国家或地区输华肉类产品名单》中列明准许进口</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">4</td><td class="tableLine"  style="width: 599px;height: 50px;">肉类品种与实际货物相符</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">5</td><td class="tableLine"  style="width: 599px;height: 50px;">卫生证书格式及出证机构与总局发布的证书样本一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">6</td><td class="tableLine"  style="width: 599px;height: 50px;">发货人名称及地址与产地证、报检单及预核销单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">7</td><td class="tableLine"  style="width: 599px;height: 50px;">收货人名称及地址与产地证、报检单及预核销单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">8</td><td class="tableLine"  style="width: 599px;height: 50px;">离港日期（如必要）</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">9</td><td class="tableLine"  style="width: 599px;height: 50px;">装货港与提单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">10</td><td class="tableLine"  style="width: 599px;height: 50px;">原产国与报检信息一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">11</td><td class="tableLine"  style="width: 599px;height: 50px;">目的地为中华人民共和国</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">12</td><td class="tableLine"  style="width: 599px;height: 50px;">集装箱号及铅封号与提单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">13</td><td class="tableLine"  style="width: 599px;height: 50px;">屠宰厂名称、地址及编号与认监委网站名单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">14</td><td class="tableLine"  style="width: 599px;height: 50px;">加工厂名称、地址及编号与认监委网站名单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">15</td><td class="tableLine"  style="width: 599px;height: 50px;">储存厂名称、地址及编号与认监委网站名单一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">16</td><td class="tableLine"  style="width: 599px;height: 50px;">目的港为大连</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">17</td><td class="tableLine"  style="width: 599px;height: 50px;">屠宰日期不晚于加工日期</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">18</td><td class="tableLine"  style="width: 599px;height: 50px;">储存温度明确（如必要）</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">19</td><td class="tableLine"  style="width: 599px;height: 50px;">货物品名、重量及数量与报检信息一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">20</td><td class="tableLine"  style="width: 599px;height: 50px;">防伪标识与总局发布信息一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">21</td><td class="tableLine"  style="width: 599px;height: 50px;">印章与总局发布信息一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">22</td><td class="tableLine"  style="width: 599px;height: 50px;">签字官及笔迹与总局发布信息一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">23</td><td class="tableLine"  style="width: 599px;height: 50px;">莱克多巴胺及H1N1附加证明（如必要）</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;height: 50px;" colspan="3" align="left">二、电子信息</td></tr>
      <tr><td class="tableLine" style="width: 50px;">1</td><td class="tableLine"  style="width: 599px;height: 50px;">入境口岸为辽宁局</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">2</td><td class="tableLine"  style="width: 599px;height: 50px;">收发货人信息与纸质证书一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">3</td><td class="tableLine"  style="width: 599px;height: 50px;">货物品名、数量或重量与纸质证书一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">4</td><td class="tableLine"  style="width: 599px;height: 50px;">生产企业编号与纸质证书一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">5</td><td class="tableLine"  style="width: 599px;height: 50px;">集装箱号或铅封号与纸质证书一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;">6</td><td class="tableLine"  style="width: 599px;height: 50px;">签发日期与纸质证书一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
      <tr><td class="tableLine" style="width: 50px;">7</td><td class="tableLine"  style="width: 599px;height: 50px;">签字兽医官与纸质证书一致</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>
	  <tr><td class="tableLine" style="width: 50px;">8</td><td class="tableLine"  style="width: 599px;height: 50px;">原被替代证书的电子信息已删除（如卫生证书为替代证）</td><td class="tableLine" style="width: 50px;"><input type="checkbox" checked="checked"/></td></tr>     
      <tr><td class="tableLine" style="width: 50px;height: 50px;" colspan="3" align="left">三、其他问题</td></tr>
      </table>
    </div> 
    <div align="center">
     <input type="button" style="margin: 40px 40px 0px 260px; width: 80px;height: 30px;" value="打印" onclick="window.print()"/>
     <input type="button" style="margin: 40px 40px 0px 80px; width: 80px;height: 30px;" value="返回" onclick=" window.history.back(-1)"/>
    </div>
</div>
</body>
</html>
