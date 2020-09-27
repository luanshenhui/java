<%@page pageEncoding="utf-8" 
contentType="text/html;charset=utf-8" %>
<html>
	<head>
		<style>
			table{
				margin-left:450px;
				margin-top:30px;
				font-size:24px;
			}
			.s2{
				font-style:italic;
				font-size:36px;
				color:red;
				cursor:pointer;
			}
		</style>
		<script type="text/javascript" 
		src="js/jquery-1.4.3.js">
		</script>
		<script type="text/javascript">
			$(function(){
				var event = 'input';   //非ie浏览器
				if(navigator.userAgent.indexOf('MSIE') != -1){
					//ie浏览器
					event = 'propertychange';
				}
				$('#key').bind(event,fn);
			});
			function fn(){
				$.ajax({
					'url':'keyInfo.do',
					'type':'post',
					'data':'key=' + $('#key').val(),
					'dataType':'text',
					'success':function(data){
						var arr = data.split(',');
						$('#tips').empty();
						for(i=0;i<arr.length;i++){
							$('#tips').append(
							"<div class='s1'>" + arr[i] + "</div>");
						}
						$('.s1').mouseenter(function(){
							$(this).addClass('s2').siblings().
							removeClass('s2');
						});
						$('.s1').click(function(){
							$('#key').val($(this).text());
							$('#tips').empty();
						});
					},
					'error':function(){
						alert('系统出错');
					}
				});
			}
		</script>
	</head>
	<body style="font-size:30px;font-style:italic;">
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td><input name="key" id="key"/></td>
				<td><input type="button" value="搜索"/></td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="tips">
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>