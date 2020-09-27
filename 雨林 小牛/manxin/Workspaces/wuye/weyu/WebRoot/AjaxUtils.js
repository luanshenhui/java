var Ajax={
	createXHR:function(){
		if(window.XMLHttpRequest){
			var xhr = new XMLHttpRequest();
			return xhr;
		}else if(window.ActiveXObject){
			var xhr = new ActiveXObject("Microsoft.XMLHTTP");
			return xhr;
		}
	},
	sendRequest:function(method,url,data,callback){
		var xhr = this.createXHR();
		xhr.open(method,url);
		if(method=="GET"){
			xhr.send(null);
		}else if(method=="POST"){
			xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			xhr.send(data);
		}
		xhr.onreadystatechange=function(){
			if(xhr.readyState==4&&xhr.status==200){
				callback({text:xhr.responseText,xml:xhr.responseXML});
			}
		}
	}
}