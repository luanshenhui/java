function getXhr(){
		var xhr = null;
		if(window.XMLHttpRequest){
			//非ie浏览器
			xhr = new XMLHttpRequest();
		}else{
			//ie浏览器
			xhr = new ActiveXObject('Microsoft.XMLHttp');
		}
		return xhr;
	}