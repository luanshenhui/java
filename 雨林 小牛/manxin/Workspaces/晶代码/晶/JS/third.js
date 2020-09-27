//添加新节点
function addNewNode() {
	var f = document.getElementById("form1");
	//在按钮后面添加一个链接，click me，点击去tts6
	var aObj = document.createElement("a");
	aObj.href = "http://yulin.com.cn";
	aObj.innerHTML = "click me";
	f.appendChild(aObj);
	//在按钮前面添加一个新按钮，new button，点完弹出 hello
	var btnObj = document.createElement("input");
	btnObj.type = "button";
	btnObj.value = "new button";
	//为新按钮添加事件：将一个方法对象赋值
	btnObj.onclick = function(){
									alert("hello");
								};
	f.insertBefore(btnObj,f.firstChild);
}
//设计二维数组，存储相关的数据
var arr = new Array();
arr[0] = ["--请选择--"];
arr[1] = ["core java","se","oracle"];
arr[2] = ["c","c++"];
arr[3] = ["html","css","php"];

function showOptions() {
	//先删除第二个下拉框中原有的选项
	var selObj = document.getElementById("s2");
	while(selObj.childNodes.length > 0)
	{
		selObj.removeChild(selObj.firstChild);
	}

	//得到第一个下拉框的选中的项(0-3)
	var index = document.getElementById("s1").selectedIndex;	
	//根据选中的项得到原始数据的数组
	var data = arr[index];	
	//循环数组：创建新的 option 加给第二个下拉框
	for(var i=0;i<data.length;i++) {
			var obj = document.createElement("option");
			obj.innerHTML = data[i];
			document.getElementById("s2").appendChild(obj);
	}
}

//模拟封装：根据id找对象---100个方法写在js文件中
function $(idValue) {
	return document.getElementById(idValue);    
}

//使用 HTML DOM 中table对象的方式实现对表格的操作
function saveData() {
	//找到表格对象
	var table = $("t1");
	//为表格添加一行	3行(0.1.2)加1行（3）
	var row = table.insertRow(table.rows.length);
	//为新行添加单元格
	var cell1 = row.insertCell(0);
	cell1.innerHTML = $("txtName").value;
	var cell2 = row.insertCell(1);
	cell2.innerHTML = $("txtPrice").value;
}

//实现页面的跳转
function testPage() {
	//保留历史访问记录
	//location.href = "http://yulin.com.cn";
	//替换当前页面
	location.replace("http://yulin.com.cn");
}

//遍历 navigator 对象属性及其属性的值
function testNavi() {
	var str = "";
	for(var pName in navigator)
	{
		//pName的值：language、appVersion 等
		str += pName + ":" + navigator[pName] + "\n";
	}
	alert(str);
	
	
}

//使用event 改进计算器
function cal(eObj) {
	   
	//得到事件的源对象
	var obj = eObj.target ||  eObj.srcElement;
	//判断：只有点击的是按钮
	if( obj.nodeName == "INPUT" && obj.type == "button" )	{
		//判断：是不是 = 
		if( obj.value == "=" ) {
			var str = $("txtNumber").value;
			var result = eval(str);
			$("txtNumber").value = result;
		}
		else {
			$("txtNumber").value += obj.value;
			alert(document.getElementById("txtNumber").value);
		}
	}
}

//使用 Object 封装数据
function testObject() {
	var obj = new Object();
	//封装数据
	obj.name = "mary";
	obj.age = 18;
	//封装行为
	obj.sing = new Function("alert('Hello');");

	//测试
	alert(obj.name + ":" + obj.age);
	obj.sing();
}

//先定义一个Person类
function Person(n,a)  {
	this.name = n;
	this.age = a;
	this.introduceSelf = function(){
							alert("i am " + this.name + "," + this.age);
						};
}
//测试自定义对象
function testOwnObj() {
	var p1 = new Person("mary",18);
	alert(p1.name);
	p1.introduceSelf();   //i am mary,18 

	var p2 = new Person("john",28);
	alert(p2.age);
	p2.introduceSelf();
}

//测试：使用 json 封装数据
function testJSon() {
	var obj = {
			"name":"mary",
			"age":18,
			"isGra":true
		};
	//测试
	alert(obj.name + ":" + obj.age + ":" + obj.isGra);
}