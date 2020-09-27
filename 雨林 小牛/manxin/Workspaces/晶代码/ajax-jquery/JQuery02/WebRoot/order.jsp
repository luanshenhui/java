<%@page pageEncoding="utf-8" 
contentType="text/html;charset=utf-8" %>
<html>
	<head>
		<script type="text/javascript" src="js/jquery-1.4.3.js">
		</script>
		<script type="text/javascript">
			$(function(){
				$('a.s1').toggle(function(){
					var flight = $(this).parent()
					.siblings().eq(0).text();
					alert(flight);
					//$(this).next().load('getPriceInfo.do',
					//'flight=' + flight);
					$(this).next().load('getPriceInfo.do',
					{'flight':flight});
					$(this).html('查看经济舱价格');
				},function(){
					$(this).next().empty();
					$(this).html('查看所有票价');
				});
			});
		</script>
	</head>
	<body style="font-size:30px;font-style:italic;">
		<table border="1" cellpadding="0" 
		cellspacing="0" border="1">
			<tr>
				<td>航班号</td>
				<td><a href="#">机型</a></td>
				<td>起飞时间</td>
				<td>到达时间</td>
				<td>&nbsp;</td>
				<td>经济舱价格</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>CA1234</td>
				<td><a href="#">波音747</a></td>
				<td>8:00 am</td>
				<td>11:00</td>
				<td><a href="javascript:;" class="s1">查看所有票价</a>
				<div></div>
				</td>
				<td>￥1200</td>
				<td><input type="button" value="订票"/></td>
			</tr>
			<tr>
				<td>MU1494</td>
				<td><a href="#">空客320</a></td>
				<td>8:00 am</td>
				<td>11:00</td>
				<td><a href="javascript:;" class="s1">查看所有票价</a>
				<div></div>
				</td>
				<td>￥800</td>
				<td><input type="button" value="订票"/></td>
			</tr>
		</table>
	</body>
</html>