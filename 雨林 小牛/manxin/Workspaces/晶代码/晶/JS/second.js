/*实验方法的重载：一个参数计算平方；两个参数计算和*/
function M() {
	if (arguments.length == 1) {
		var n = arguments[0];
		alert(n * n);
	} else if (arguments.length == 2) {
		alert(arguments[0] + arguments[1]);
	}
}

// var f = new Function("x","y","alert(x+y);");
// f(10,34);

/*
 * var f = function(x,y){ alert(x + y); }; f(11,22);
 */
function testMethod() {// 使用内部方法的方式实现数组的数值排序
	// Function对象
	var arr = [ 12, 4, 56, 768, 9 ];
	var f = new Function("x", "y", "return x - y ;");
	arr.sort(f);
	alert(arr.toString());

	// 匿名函数
	arr = [ 34, 7, 12, 4 ];
	var f1 = function(a, b) {
		return a - b;
	};
	arr.sort(f1);
	alert(arr.toString());
}

// 模拟简单计算器
function cal(s) {
	// 判断：传入的是=，计算；否则，拼接
	if (s == "=") {
		var str = document.getElementById("txtNumber").value;
		var r = eval(str);
		document.getElementById("txtNumber").value = r;
	} else {
		document.getElementById("txtNumber").value += s;
	}
}

// 模拟删除的操作：确定--刷；其他--不需要刷
function delFunc() {
	var r = window.confirm("真的要删除？");// true/false
	return r;
}
// 显示当前时间
function showTime() {
	var d = new Date();// get set to
	document.getElementById("txtTime").value = d.toLocaleTimeString();
}
// 启动时钟：每隔 1s调用 showTime 方法
var t1;
function startClock() {
	t1 = window.setInterval(showTime, 1000);
}
// 停止时钟
function stopClock() {
	window.clearInterval(t1);
}

// 5s后弹出
var t2;
function timoutFunc() {
	t2 = window.setTimeout("alert('hello');", 5000);
}
function cancelFunc() {
	window.clearTimeout(t2);
}

// 修改页面动态效果
function testDOM() {
	// 表格的个数
	alert(document.getElementsByTagName("table").length);

	var obj = document.getElementById("s1");
	var count = 0;
	// 只统计 option 的个数
	for ( var i = 0; i < obj.childNodes.length; i++) {
		if (obj.childNodes[i].nodeName == "OPTION") {
			count++;
		}
	}
	alert(count);

	// 修改段落
	var pObj = document.getElementById("p1");
	pObj.style.color = "red";
	pObj.style.backgroundColor = "gray";
	pObj.innerHTML = "aaaabbbb";

	// 修改图像
	var imgObj = document.getElementById("m1");
	imgObj.src = "account_out.png";

	// 设置h1 的样式类
	document.getElementById("h1").className = "s1";
}

// 验证用户名
function validName() {
	var str = document.getElementById("txtName").value;
	var reg = /^[a-zA-Z]{3,5}$/;
	if (reg.test(str)) {
		document.getElementById("nameInfo").style.color = "green";
	} else {
		document.getElementById("nameInfo").style.color = "red";
	}
	// 返回名的验证结果
	return reg.test(str);
}
// 验证年龄
function validAge() {
	var str = document.getElementById("txtAge").value;
	var reg = /^\d{2}$/;
	if (reg.test(str)) {
		document.getElementById("ageInfo").style.color = "green";
	} else {
		document.getElementById("ageInfo").style.color = "red";
	}
	return reg.test(str);
}
// 提交前，应该验证所有的相关项
function validData() {
	var r1 = validName();
	var r2 = validAge();
	return r1 && r2;
}

// 添加数量
function add(btnObj) {
	// 得到当前按钮所在单元格的所有子节点
	var nodes = btnObj.parentNode.childNodes;
	for ( var i = 0; i < nodes.length; i++) {
		// type为text的input 节点
		var child = nodes[i];
		if (child.nodeName == "INPUT" && child.type == "text") {
			// child 是文本框
			var count = parseInt(child.value);
			count++;
			child.value = count;
		}
	}
	calPrice();
}

// 减少数量
function decrease(btnObj) {
	// 得到当前按钮所在单元格的所有子节点
	var nodes = btnObj.parentNode.childNodes;
	for ( var i = 0; i < nodes.length; i++) {
		// type为text的input 节点
		var child = nodes[i];
		if (child.nodeName == "INPUT" && child.type == "text") {
			// child 是文本框
			var count = parseInt(child.value);
			if (count > 0) {
				count--;
			}
			child.value = count;
		}
	}
	calPrice();
}
// 数量发生改变时，计算小计以及总计
function calPrice() {

	// 得到表格对象
	var table = document.getElementById("t1");
	// 得到表格的所有行
	var rows = table.getElementsByTagName("tr");
	// 从第二行开始
	var total = 0;
	for ( var i = 1; i < rows.length; i++) {
		// 关心的数据：在当前行的各个单元格中
		var curRow = rows[i];// tr
		var cells = curRow.getElementsByTagName("td");
		// 找到价格（第二个单元格中的文本<td>1.2</td>）
		var price = parseFloat(cells[1].innerHTML);
		// 找到数量（第三个单元格中的第二个input中的value）
		var q = parseFloat(cells[2].getElementsByTagName("input")[1].value);
		// 计算小计：第四个单元格中的文本
		var sum = price * q;
		cells[3].innerHTML = sum.toFixed(2);
		// 计算总计
		total += sum;
	}
	document.getElementById("totalPrice").innerHTML = total.toFixed(2);
}
