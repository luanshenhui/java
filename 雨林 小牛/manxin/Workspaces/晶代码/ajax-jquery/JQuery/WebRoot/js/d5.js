$(function(){
		$('#d1').click(function(){
			//this:绑订了click事件处理函数的dom对象。
			//this.innerHTML = 'hello java';
			//或者
			$(this).html('hello java');
		});
	});