/* JS程序简要描述信息
**************************************************************
* 程序名	: Tip.js
* 建立日期: 2010-07-21
* 版权声明:
*  代码来源于网络
* 作者		: 网络
* 模块		: 系统主页面
* 描述		: 提供主页面菜单tip特效
* 备注		: 
* ------------------------------------------------------------
* 修改历史
* 序号	日期		         修改人		修改原因
* 1   
* 2
**************************************************************
*/
var offsetxpoint=-60 
	var offsetypoint=20
	var ie=document.all
	var ns6=document.getElementById && !document.all
	var enabletip=false
	//if (ie||ns6)
	//var tipobj=document.all? document.all["dhtmltooltip"] : document.getElementById? document.getElementById("dhtmltooltip") : ""
	var tipobj= document.getElementById("dhtmltooltip");
	function ietruebody(){
	return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
	}
	function ddrivetip(thetext, thecolor, thewidth){
		var zipDivFlag = document.getElementById("zipDivFlag").value;
		if(zipDivFlag>0){
			if (ns6||ie){
			if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"
			if (typeof thecolor!="undefined" && thecolor!="") tipobj.style.backgroundColor=thecolor
			tipobj.innerHTML=thetext
			enabletip=true
			return false
			}			
			}

	}
	function positiontip(e){
	if (enabletip){
	var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
	var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;
	var rightedge=ie&&!window.opera? ietruebody().clientWidth-event.clientX-offsetxpoint : window.innerWidth-e.clientX-offsetxpoint-20
	var bottomedge=ie&&!window.opera? ietruebody().clientHeight-event.clientY-offsetypoint : window.innerHeight-e.clientY-offsetypoint-20
	var leftedge=(offsetxpoint<0)? offsetxpoint*(-1) : -1000
	if (rightedge<tipobj.offsetWidth)
	tipobj.style.left=ie? ietruebody().scrollLeft+event.clientX-tipobj.offsetWidth+"px" : window.pageXOffset+e.clientX-tipobj.offsetWidth+"px"
	else if (curX<leftedge)
	tipobj.style.left="5px"
	else
	tipobj.style.left=curX+offsetxpoint+"px"
	if (bottomedge<tipobj.offsetHeight)
	tipobj.style.top=ie? ietruebody().scrollTop+event.clientY-tipobj.offsetHeight-offsetypoint+"px" : window.pageYOffset+e.clientY-tipobj.offsetHeight-offsetypoint+"px"
	else
	tipobj.style.top=30+"px"
	tipobj.style.visibility="visible"
	}
	}
	function hideddrivetip(){
	if (ns6||ie){
	enabletip=false
	tipobj.style.visibility="hidden"
	tipobj.style.left="-1000px"
	tipobj.style.backgroundColor=''
	tipobj.style.width=''
	}
	}
	document.onmousemove=positiontip