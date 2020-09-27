/**
 * 页面初始化
 */
$(function () {
    //BEGIN CHECKBOX & RADIO
    $('input[type="checkbox"]').iCheck({
        checkboxClass: 'icheckbox_minimal-grey',
        increaseArea: '20%' // optional
    });
    $('input[type="radio"]').iCheck({
        radioClass: 'iradio_minimal-grey',
        increaseArea: '20%' // optional
    });
    //END CHECKBOX & RADIO
    
	// 输入有效性验证
	$("#loginForm").validate({
		debug:true,
        errorPlacement: function(error, element)
        {
            error.insertAfter(element);
        }
    });
	
	
});

function dologin() {
	// 输入有效性验证
	if(!$("#loginForm").valid()) {
		 return false;
	}
    var userName = $("#account").val();
    var userPwd = $("#password").val();
	$.ajax({
	    cache: true,
	    type: "POST",
	    url: '/login/login.action',
	    data: $("#loginForm").serialize(),
	    dateType: 'json',
	    async: false,
	    error: function (request) {
	        alert("Connection error");
	    },
	    success: function (json) {
	    	debugger
            if (json.result != "success") {
                alert('登录失败,'+json.msg);
            } else {
            	window.location.href="/index.html";
            }
	    }
	});
}

function refreshCaptcha() {
    document.getElementById('img_captcha').src = '/servlets/CaptchaServlet?' + Math.random() + Math.random();
}

$(document).keypress(function (e) {
    // 回车键事件 
    if (e.which == 13) {
        dologin();
    }
});