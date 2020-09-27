<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<html>
  <head>
    <style>
    	table{
    		margin-left:450px;
    		margin-top:30px;
    		font-size: 24px;
    	}
    	.s2{
    		font-style: italic;;
    		font-size: 36px;
    		color: red;
    		cursor: pointer;
    	}
    	
    </style>
	<script type="text/javascript" src="js/jquery-1.4.3.js"></script>
	<script type="text/javascript">
		$(function(){
			$('#key').keyup(function(){
				/*
					将用户输入的关键字发送给服务器，服务器会返回类似于:"小学生，小学生作文，小月月"这样的字符串，
					客户端需要分解这个字符串,然后将其添加到id为tips的div里面
				*/
				$.ajax({
					'url':'keyInfo.do',
					'type':'post',
					'data':'key=' + $('#key').val(),
					'dataType':'text',
					'success':function(data){
						//data是服务器返回的数据
						//success 成功之后运行
						var arr = data.split(',');
						$('#tips').empty();
						for(i=0;i<arr.length;i++){
							$('#tips').append(
								"<div class='s1'>" + arr[i] + "</div>"
							);
						}
						/*
							对所有的提示项绑定mouseenter事件，当光标进入时，对应的提示项样式会发生变化
						*/
						$('.s1').mouseenter(function(){
							$(this).addClass('s2').siblings().removeClass('s2');
						});
						/*
							对所有的提示项绑定点击事件，当用户点击时，将选项值赋给文本输入框，同时，清楚tisp的内容
						*/
						$('.s1').click(function(){
							$('#key').val($(this).text());
							$('#tips').empty();
						});
					}
				});
			});
		});
		
	</script>
  </head>
  
  <body style="font-size: 30px;font-style: italic;">
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td><input name="key" id="key"/></td>
				<td><input type="button" value="搜索"/></td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="tips"></div>
				</td>
			</tr>
		</table>
  </body>
</html>













