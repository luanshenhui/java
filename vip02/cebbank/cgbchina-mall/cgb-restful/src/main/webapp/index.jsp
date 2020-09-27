<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <style type="text/css">
        div {
            height: 150px;
            width: 98%;
            float: left;
            border-width: 1px;
            border-style: solid;
        }
    </style>
    <script type="text/javascript">
        var $id = function (str) {
            return document.getElementById(str);
        }
        function send() {
            var typeName = $id("typeName").value;
            var method = $id("method").value;
            var paramter = $id("paramter").value;
            var oAjax = null;
            if (window.XMLHttpRequest) {
                oAjax = new XMLHttpRequest();
            } else {
                oAjax = new ActiveXObject('Microsoft.XMLHTTP');
            }
            var url = "<%=request.getSession().getServletContext().getContextPath()%>/call/callMethod?beanName=" + typeName + "&methodName=" + method + "&value=" + paramter;
            oAjax.open('GET', url, true);
            oAjax.send();
            oAjax.onreadystatechange = function () {  //OnReadyStateChange事件
                if (oAjax.readyState == 4) {  //4为完成
                    if (oAjax.status == 200) {    //200为成功
                        var response = JSON.parse(oAjax.responseText);
                        var data = response.data;
                        $id("result").value = JSON.stringify(data);
                    }
                }
            };
        }
    </script>
    <title>callService</title>
</head>
<body>
<div><span>类名</span><input type="text" id="typeName"/></div>
<div><span>方法</span><input type="text" id="method"/></div>
<div>
    <input type="button" value="send" onclick="send();"/>
    <span>传入参数</span><textarea id="paramter" cols="3" cols="20" style="width: 60%;height: 100px"></textarea>
</div>
<div>
    <span>传出参数</span><textarea id="result" cols="3" cols="20" style="width: 60%;height: 100px"></textarea>
</div>
</body>
</html>