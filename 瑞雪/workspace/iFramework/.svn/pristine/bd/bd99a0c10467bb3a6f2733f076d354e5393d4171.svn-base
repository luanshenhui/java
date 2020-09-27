$().ready(function() {
	$("#inp_name").focus();
	
	$("#inp_name").blur(function(){			
		$("#errorDiv").hide();
	});
	$("#inp_pw").blur(function(){		
		$("#errorDiv").hide();
	});		
});
function requiredCheck(){	
	var userName = document.getElementById("inp_name");
	var password = document.getElementById("inp_pw");	
	var errorMessage = "";
	var flag =0;
	if(userName.value==""){
		errorMessage = errorMessage + Consts.LogIn.message_username_required;
		flag = 1;
		userName.focus();
	}
	if(password.value==""||password.value==null){
		errorMessage = errorMessage + Consts.LogIn.message_password_required;
		if(flag==0)password.focus();
	}
	if(errorMessage!=""){
		document.getElementById("errContainer").innerHTML = errorMessage;
		document.getElementById("errContainer").style.display = 'block';	
		return false;
	}else{return true;}
}
function checkParent(){		
    if(window.parent.length>0){ 
        window.parent.location="login.jsp"; 
    }
    var browser=navigator.appName; 
	var b_version=navigator.appVersion;
	var version=b_version.split(";"); 
	var trim_Version=version[1].replace(/[ ]/g,""); 
	if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0"){		
		DD_belatedPNG.fix('.png,img');
	}	
};
function belatedPNG(){
	var browser=navigator.appName; 
	var b_version=navigator.appVersion;
	var version=b_version.split(";"); 
	var trim_Version=version[1].replace(/[ ]/g,""); 
	if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0"){		
		DD_belatedPNG.fix('.png,img');
	}
}


