function shieldCommon(keyEvent){
	var theEvent;
	if (!keyEvent)
		theEvent = keyEvent;
	else
		theEvent = window.event || arguments.callee.caller.arguments[0];   
	if(theEvent.keyCode==8){      
		var actId = document.activeElement.id;
		if(actId != ""){
			var obj = $jQuery("#"+actId);
			if(obj != undefined && obj != null){
				var tagName = document.getElementById(actId).tagName;
				if(tagName != undefined){
					if(tagName == "INPUT" || tagName == "TEXTAREA"){
						return true;
					}
				}

			}
		}
		shieldBackspace();
	}
}
function shieldBackspace(){
	if(window.event)   { 	
		event.returnValue=false;// IE下的情况处理
	 	return false;   
	}   
	else  { 
		arguments.callee.caller.arguments[0].preventDefault();// FF下的情况处理 }
	}   
}