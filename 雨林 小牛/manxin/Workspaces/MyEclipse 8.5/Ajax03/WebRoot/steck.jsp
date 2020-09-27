<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<html>
  <head>
    <style>
    	#d1{
    		width:450px;
    		height:250px;
    		border:1px solid red;
    		background-color:black;
    		margin-left:400px;
    		margin-top:20px;
    	}
    	#d2{
    		height:35px;
    		color:white;
    		background-color:red;
    	}
    	table{
    		color:white;
    		font-size:24px;
    	}
    </style>
	<script type="text/javascript" src="js/my.js"></script>
	<script type="text/javascript" src="js/prototype-1.6.0.3.js"></script>
	<script type="text/javascript">
		function quoto(){
			setInterval(f1,2500);
		}
		function f1(){
			var xhr = getXhr();
			xhr.open('get','quoto.do',true);
			xhr.onreadystatechange = function(){
				if(xhr.readyState == 4){
					//获得服务器返回的json字符串
					var txt = xhr.responseText;
					//将json字符串转换成js对象
					var arr = txt.evalJSON();
					var html = "";
					for(i=0;i<arr.length;i++){
						var stock = arr[i];
						html +='<tr><td>' + stock.code + '</td><td>' + stock.name
						+ '</td><td>' + stock.price + '</td></tr>';
					}
					$('a').innerHTML = html;
				}
			};
			xhr.send(null);
		}
	</script>
  </head>
  
  <body style="font-size: 30px;font-style: italic;" onload="quoto();">
  	<div id="d1">
  		<div id="d2">股票实时行情信息</div>
  		<div>
  			<table cellpadding="0" cellspacing="0" width="100%">
  				<thead>
  					<tr><td>代码</td><td>名称</td><td>价格</td></tr>
  				</thead>
  				<tbody id="a"></tbody>
  			</table>
  		</div>
  	</div>

  </body>
</html>













