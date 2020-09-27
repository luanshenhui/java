function isTouchDevice(){
try{
document.createEvent("TouchEvent");
return true;
}catch(e){
return false;
}
}
function touchScroll(id){
if(isTouchDevice()){ //if touch events exist...
var el=document.getElementById(id);
var scrollStartPos=0;
 
document.getElementById(id).addEventListener("touchstart", function(event) {
	var target = event.target;
	while (target.nodeType != 1) target = target.parentNode;
	if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA'){
		scrollStartPos=this.scrollTop+event.touches[0].pageY;
		event.preventDefault();
	}
},false);
 
document.getElementById(id).addEventListener("touchmove", function(event) {
	var target = event.target;
	while (target.nodeType != 1) target = target.parentNode;
	if (target.tagName != 'SELECT' && target.tagName != 'INPUT' && target.tagName != 'TEXTAREA'){
		this.scrollTop=scrollStartPos-event.touches[0].pageY;
		event.preventDefault();
	}
},false);
}
}