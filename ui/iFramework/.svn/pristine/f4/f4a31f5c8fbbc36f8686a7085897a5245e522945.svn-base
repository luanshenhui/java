
function getELXY(e){
	return {x:e.offsetLeft,y:e.offsetTop};
}
function getELWH(e){
	return {w:e.offsetWidth,h:e.offsetHeight};
}
function getClientXY(e){
	e=e||event;
	return {cx:e.clientX,cy:e.clientY};
}
document.onclick = function(e){
	var obj = document.getElementById("qMenuDiv");
	var lt = getELXY(obj)['x'];
	var rt = getELXY(obj)['x'] + getELWH(obj)['w'];
	var topY = getELXY(obj)['y'];
	var bottomY = getELXY(obj)['y'] + getELWH(obj)['h'];
	var mouseXX = getClientXY(e)['cx'];
	var mouseYY = getClientXY(e)['cy'];
if(mouseXX<lt || mouseXX>rt || mouseYY<topY || mouseYY>bottomY){	
	obj.style.display="none";
	}else{
	}
};
