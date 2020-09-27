<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">

  <title></title>
</head>
<body style="background:#171818;">
 <table>
        <tr>
            <td><iframe name="left"  src="${ctx}/gzw/homepage?pageIndex=01" frameborder="1" border="3" scrolling="auto" style="border:none;" width="1920" height="1080" allowtransparency="true"></iframe></td>
            <td><iframe name="left"  src="${ctx}/gzw/homepage?pageIndex=02" frameborder="1" border="3" scrolling="auto" style="border:none;" width="1920" height="1080" allowtransparency="true"></iframe></td>
        </tr>
        <tr>
            <td><iframe name="left"  src="${ctx}/gzw/homepage?pageIndex=03" frameborder="1" border="3" scrolling="auto" style="border:none;" width="1920" height="1080" allowtransparency="true"></iframe></td>
            <td><iframe name="left"  src="${ctx}/gzw/homepage?pageIndex=04" frameborder="1" border="3" scrolling="auto" style="border:none;" width="1920" height="1080" allowtransparency="true"></iframe></td>
        </tr>

    </table>

</body>
</html>
