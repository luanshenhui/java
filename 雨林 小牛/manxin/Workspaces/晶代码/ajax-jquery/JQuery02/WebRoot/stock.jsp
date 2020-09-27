<%@page pageEncoding="utf-8" 
contentType="text/html;charset=utf-8" %>
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
		<script type="text/javascript" 
		src="js/jquery-1.4.3.js">
		</script>
		<script type="text/javascript">
			$(function(){
				setInterval(quoto,4000);
			});
			function quoto(){
				$.post('quoto.do',function(data){
					//data是服务器返回的数据，如果
					//是json字符串，会自动转换成相应的
					//javascript对象。
					$('#tb1').empty();
					for(i=0;i<data.length;i++){
						var s = data[i];
						$('#tb1').append(
						'<tr><td>' + s.code 
						+ '</td><td>' + s.name 
						+ '</td><td> ' + s.price
						 + '</td></tr>');
					}
				},'json');
			}
		</script>
	</head>
	<body style="font-size:30px;font-style:italic;" >
		<div id="d1">
			<div id="d2">股票实时行情信息</div>
			<div>
				<table cellpadding="0" cellspacing="0" 
				width="100%">
					<thead>
							<tr><td>代码</td><td>名称</td><td>价格</td></tr>
					</thead>
					<tbody id="tb1">
					</tbody>
				</table>
			</div>
		</div>
	</body>
</html>