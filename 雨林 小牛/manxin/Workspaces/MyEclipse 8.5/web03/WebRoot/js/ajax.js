var Ajax = {
		createXhr:function(){
			if(window.XMLHttpRequest){
				return new XMLHttpRequest();
			}else if(window.ActiveXObject){
				return new ActiveXObject("Microsoft.XMLHTTP");
			}
		},
		sendRequest:function(method,url,value,fun){
			var xhr = this.createXhr();
			xhr.open(method,url);
			if(method=="GET"){
				xhr.send(value);
			}else if(method=="POST"){
				xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				xhr,send(value);
			}
			xhr.onreadystatechange = function(){
				if((xhr.readyState==4)&&(xhr.status==200)){
					var p = {
							text:xhr.responseText,
							xml:xhr.responseXML
					};
					fun(p);
				}
			};
		}
};