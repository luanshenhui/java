function no1(){
	var n = document.getElementById("btn1");	
	var btn = document.createElement("input");
	btn.type = "button";
	btn.value = "newButton";
	btn.onclick = function hello(){
		alert("Hello!");	
	};
	
}