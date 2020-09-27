<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>卫生许可证</title>
<%@ include file="/common/resource_new.jsp"%>
</head>
<body>

<form action="/ciqs/xk/submitDoc"  method="post">
<input type ="hidden" id="declare_date" value="${declare_date}" />
<input type ="hidden" name="ProcMainId" value="${license_dno}" />
<input type ="hidden" name="DocType" value="D_SQ_BZ" />
<input type ="hidden" name="DocId" value="${doc.doc_id}" />
	<div id="content">
    <table width="700px" align="center">
        <tr>
            <td align="center" style="font-size:25px;font-family:'楷体_GB2312';font-weight: bold;"><p align="center">行政许可申请材料补正告知书 </p></td>
        </tr>
        <tr>
          <td align="right" style="font-size:18px; font-family:'楷体_GB2312';"><p align="center">（${doc.option_1}）<span style="text-decoration:line-through;">质</span>检
          （${doc.option_2}）
          许补字〔${doc.option_3}〕 ${doc.option_60}   号 </p></td>
      </tr>
        <tr>
          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';">${doc.option_4}</td>
      </tr>
        <tr>
          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';">
          <span style="margin-left:30px">你（单位）于${doc.option_5}年${doc.option_20}月${doc.option_21}日提交的${doc.option_6}行政许<br />可申请材料收悉。</span>
          依照《中华人民共和国行政许可法》第三十二条第一款第四项和${doc.option_7}规定，经审查，需补正以下材料： </td>
      </tr>
        <tr>
          <td align="left" style="font-size:18px; font-family:'楷体_GB2312';">
            <p style="width:666px;text-align:left">1、${doc.option_8}</p>
            <p style="width:666px;text-align:left">2、 ${doc.option_9}</p>
            <p style="width:666px;text-align:left">3、 ${doc.option_10}</p>
            <p style="width:666px;text-align:left">4、 ${doc.option_11}</p>
            <p style="width:666px;text-align:left">5、 ${doc.option_12}</p>
            <p style="width:666px;text-align:left">6、 ${doc.option_13}</p>
            <p style="width:666px;text-align:left">7、 ${doc.option_14}</p>
            <p style="width:666px;text-align:left">8、 ${doc.option_15}</p>
          	<p style="width:666px;text-align:left">9、 ${doc.option_16}</p>
          	</td>
        </tr>
        <tr>
          <td align="center" style="font-size:18px; font-family:'楷体_GB2312';">
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <p>&nbsp;</p>
          <blockquote>
            <p style="padding-left:310px">（行政许可专用印章） </p>
          </blockquote>
          <p style="padding-left:310px">${doc.option_17}年${doc.option_18}月${doc.option_19}日</p>
          <p style="padding-left:310px">&nbsp;</p>
          <p></p>
          <p>本文书一式两份。一份送达申请人，一份质检部门存档。 </p></td>
      </tr>
    </table>
    
    

    <div style="text-align: center;" class="noprint">
        <span> 
        	<input type="submit" class="btn" value="打印" onclick="javascript:window.print()" />
        </span>
    </div>
</div>
</form>
</body>
</html>