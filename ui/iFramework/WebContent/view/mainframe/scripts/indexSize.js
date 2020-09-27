function getSize() {
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {
        xScroll = document.body.scrollWidth;
        yScroll = window.innerHeight + window.scrollMaxY;
    } else if (document.body.scrollHeight > document.body.offsetHeight){      // all but Explorer Mac
        xScroll = document.body.scrollWidth;
        yScroll = document.body.scrollHeight;
    } else {      // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
        xScroll = document.body.offsetWidth;
        yScroll = document.body.offsetHeight;
    }

    var windowWidth, windowHeight;
    if (self.innerHeight) {      // all except Explorer
        windowWidth = self.innerWidth;
        windowHeight = self.innerHeight;
    } else if (document.documentElement && document.documentElement.clientHeight) {      // Explorer 6 Strict Mode
        windowWidth = document.documentElement.clientWidth;
        windowHeight = document.documentElement.clientHeight;
    } else if (document.body) {      // other Explorers
        windowWidth = document.body.clientWidth;
        windowHeight = document.body.clientHeight;
    }

    // for small pages with total height less then height of the viewport
    if(yScroll < windowHeight){
        pageHeight = windowHeight;
        y = pageHeight;
    } else {
        pageHeight = yScroll;
        y = pageHeight;
    }

    if(xScroll < windowWidth){
        pageWidth = windowWidth;
    } else {
        pageWidth = xScroll;
    }
    arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight)
    return arrayPageSize;
};
//这段代码用来获取目标页的参数，包括页面宽、高，屏幕宽、高，分别装入数组arrayPageSize[0]、[1]、[2]、[3]


window.onload = function(){
    document.getElementById('container').style.height = getSize()[3] + 'px';    
    document.getElementById('mainContent').style.height = getSize()[3] - 75-26 + 'px';
}  ;  
//F11 时调用
window.onresize = function(){			
	var _size = getSize();	
	var windowHeight =_size[3];
	
	var topHeigth = 0;
	if($("#topHiddenFlag").val()==1){
		topHeigth =75;
	}
	var resizeHeight = windowHeight - 75-26+topHeigth;	
    document.getElementById('container').style.height = windowHeight + 'px';      
    if(document.getElementById('mainContent')!=undefined&&resizeHeight>0){    	
    	document.getElementById('mainContent').style.height = windowHeight - 75-26+topHeigth+ 'px';
    }
    if(document.getElementById('centreFrameId')!=undefined&&resizeHeight>0){
    	document.getElementById('centreFrameId').style.height = windowHeight -75-26+topHeigth+ 'px';
    }    
	var activeNum = $("#activeMenuNum").attr("value");	
	setLeftMenuDivHeight(activeNum);	
};

window.ontopresize = function(){		
    document.getElementById('container').style.height = getSize()[3] + 'px';    
    document.getElementById('mainContent').style.height = getSize()[3] - 75-26 + 'px';
    document.getElementById('centreFrameId').style.height = getSize()[3] -75-26+ 'px';
	var activeNum = $("#activeMenuNum").attr("value");				
	setLeftMenuDivHeight(activeNum);
};
window.onTopHideresize = function(){
    document.getElementById('container').style.height = getSize()[3] + 'px';    
    document.getElementById('mainContent').style.height = getSize()[3] -75+ 'px';
    document.getElementById('centreFrameId').style.height = getSize()[3] -26+ 'px';   
};
window.onLeftHideresize = function(){	
    document.getElementById('container').style.height = getSize()[3] + 'px' ;
    document.getElementById('mainContent').style.height = getSize()[3] - 75-26 + 'px';
};
window.onLeftShowresize = function(){	
    document.getElementById('container').style.height = getSize()[3] + 'px';
    document.getElementById('mainContent').style.height = getSize()[3] -26 -75+ 'px';
};
function getInitCountTop(){
	var screen = 0;
	screen = document.body.clientWidth;//window.screen.width;	
	var initCount =8;
	var menuWidth=89;
	var temp=0;	
	try{
		temp=screen/menuWidth;
		initCount = parseInt(screen/menuWidth)+1;
	}catch(Exception ){
		
	}	
	return initCount;
}
function getInitCountLeft(){
	var screen = window.screen.height;
	var initCount =8;
	if(screen>1024){initCount = 14;}
	if(screen<=600){initCount = 6;}else
		if(screen<=768){initCount = 8;}else
			if(screen<=900){initCount = 12;}else
				if(screen<=1024){initCount = 14;}
	
	//alert(screen+""+initCount);
	return initCount;
};
