//����½ڵ�
function addNewNode() {
	var f = document.getElementById("form1");
	//�ڰ�ť�������һ�����ӣ�click me�����ȥtts6
	var aObj = document.createElement("a");
	aObj.href = "http://yulin.com.cn";
	aObj.innerHTML = "click me";
	f.appendChild(aObj);
	//�ڰ�ťǰ�����һ���°�ť��new button�����굯�� hello
	var btnObj = document.createElement("input");
	btnObj.type = "button";
	btnObj.value = "new button";
	//Ϊ�°�ť����¼�����һ����������ֵ
	btnObj.onclick = function(){
									alert("hello");
								};
	f.insertBefore(btnObj,f.firstChild);
}
//��ƶ�ά���飬�洢��ص�����
var arr = new Array();
arr[0] = ["--��ѡ��--"];
arr[1] = ["core java","se","oracle"];
arr[2] = ["c","c++"];
arr[3] = ["html","css","php"];

function showOptions() {
	//��ɾ���ڶ�����������ԭ�е�ѡ��
	var selObj = document.getElementById("s2");
	while(selObj.childNodes.length > 0)
	{
		selObj.removeChild(selObj.firstChild);
	}

	//�õ���һ���������ѡ�е���(0-3)
	var index = document.getElementById("s1").selectedIndex;	
	//����ѡ�е���õ�ԭʼ���ݵ�����
	var data = arr[index];	
	//ѭ�����飺�����µ� option �Ӹ��ڶ���������
	for(var i=0;i<data.length;i++) {
			var obj = document.createElement("option");
			obj.innerHTML = data[i];
			document.getElementById("s2").appendChild(obj);
	}
}

//ģ���װ������id�Ҷ���---100������д��js�ļ���
function $(idValue) {
	return document.getElementById(idValue);    
}

//ʹ�� HTML DOM ��table����ķ�ʽʵ�ֶԱ��Ĳ���
function saveData() {
	//�ҵ�������
	var table = $("t1");
	//Ϊ������һ��	3��(0.1.2)��1�У�3��
	var row = table.insertRow(table.rows.length);
	//Ϊ������ӵ�Ԫ��
	var cell1 = row.insertCell(0);
	cell1.innerHTML = $("txtName").value;
	var cell2 = row.insertCell(1);
	cell2.innerHTML = $("txtPrice").value;
}

//ʵ��ҳ�����ת
function testPage() {
	//������ʷ���ʼ�¼
	//location.href = "http://yulin.com.cn";
	//�滻��ǰҳ��
	location.replace("http://yulin.com.cn");
}

//���� navigator �������Լ������Ե�ֵ
function testNavi() {
	var str = "";
	for(var pName in navigator)
	{
		//pName��ֵ��language��appVersion ��
		str += pName + ":" + navigator[pName] + "\n";
	}
	alert(str);
	
	
}

//ʹ��event �Ľ�������
function cal(eObj) {
	   
	//�õ��¼���Դ����
	var obj = eObj.target ||  eObj.srcElement;
	//�жϣ�ֻ�е�����ǰ�ť
	if( obj.nodeName == "INPUT" && obj.type == "button" )	{
		//�жϣ��ǲ��� = 
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

//ʹ�� Object ��װ����
function testObject() {
	var obj = new Object();
	//��װ����
	obj.name = "mary";
	obj.age = 18;
	//��װ��Ϊ
	obj.sing = new Function("alert('Hello');");

	//����
	alert(obj.name + ":" + obj.age);
	obj.sing();
}

//�ȶ���һ��Person��
function Person(n,a)  {
	this.name = n;
	this.age = a;
	this.introduceSelf = function(){
							alert("i am " + this.name + "," + this.age);
						};
}
//�����Զ������
function testOwnObj() {
	var p1 = new Person("mary",18);
	alert(p1.name);
	p1.introduceSelf();   //i am mary,18 

	var p2 = new Person("john",28);
	alert(p2.age);
	p2.introduceSelf();
}

//���ԣ�ʹ�� json ��װ����
function testJSon() {
	var obj = {
			"name":"mary",
			"age":18,
			"isGra":true
		};
	//����
	alert(obj.name + ":" + obj.age + ":" + obj.isGra);
}