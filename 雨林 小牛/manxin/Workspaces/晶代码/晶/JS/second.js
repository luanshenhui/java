/*ʵ�鷽�������أ�һ����������ƽ�����������������*/
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
function testMethod() {// ʹ���ڲ������ķ�ʽʵ���������ֵ����
	// Function����
	var arr = [ 12, 4, 56, 768, 9 ];
	var f = new Function("x", "y", "return x - y ;");
	arr.sort(f);
	alert(arr.toString());

	// ��������
	arr = [ 34, 7, 12, 4 ];
	var f1 = function(a, b) {
		return a - b;
	};
	arr.sort(f1);
	alert(arr.toString());
}

// ģ��򵥼�����
function cal(s) {
	// �жϣ��������=�����㣻����ƴ��
	if (s == "=") {
		var str = document.getElementById("txtNumber").value;
		var r = eval(str);
		document.getElementById("txtNumber").value = r;
	} else {
		document.getElementById("txtNumber").value += s;
	}
}

// ģ��ɾ���Ĳ�����ȷ��--ˢ������--����Ҫˢ
function delFunc() {
	var r = window.confirm("���Ҫɾ����");// true/false
	return r;
}
// ��ʾ��ǰʱ��
function showTime() {
	var d = new Date();// get set to
	document.getElementById("txtTime").value = d.toLocaleTimeString();
}
// ����ʱ�ӣ�ÿ�� 1s���� showTime ����
var t1;
function startClock() {
	t1 = window.setInterval(showTime, 1000);
}
// ֹͣʱ��
function stopClock() {
	window.clearInterval(t1);
}

// 5s�󵯳�
var t2;
function timoutFunc() {
	t2 = window.setTimeout("alert('hello');", 5000);
}
function cancelFunc() {
	window.clearTimeout(t2);
}

// �޸�ҳ�涯̬Ч��
function testDOM() {
	// ���ĸ���
	alert(document.getElementsByTagName("table").length);

	var obj = document.getElementById("s1");
	var count = 0;
	// ֻͳ�� option �ĸ���
	for ( var i = 0; i < obj.childNodes.length; i++) {
		if (obj.childNodes[i].nodeName == "OPTION") {
			count++;
		}
	}
	alert(count);

	// �޸Ķ���
	var pObj = document.getElementById("p1");
	pObj.style.color = "red";
	pObj.style.backgroundColor = "gray";
	pObj.innerHTML = "aaaabbbb";

	// �޸�ͼ��
	var imgObj = document.getElementById("m1");
	imgObj.src = "account_out.png";

	// ����h1 ����ʽ��
	document.getElementById("h1").className = "s1";
}

// ��֤�û���
function validName() {
	var str = document.getElementById("txtName").value;
	var reg = /^[a-zA-Z]{3,5}$/;
	if (reg.test(str)) {
		document.getElementById("nameInfo").style.color = "green";
	} else {
		document.getElementById("nameInfo").style.color = "red";
	}
	// ����������֤���
	return reg.test(str);
}
// ��֤����
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
// �ύǰ��Ӧ����֤���е������
function validData() {
	var r1 = validName();
	var r2 = validAge();
	return r1 && r2;
}

// �������
function add(btnObj) {
	// �õ���ǰ��ť���ڵ�Ԫ��������ӽڵ�
	var nodes = btnObj.parentNode.childNodes;
	for ( var i = 0; i < nodes.length; i++) {
		// typeΪtext��input �ڵ�
		var child = nodes[i];
		if (child.nodeName == "INPUT" && child.type == "text") {
			// child ���ı���
			var count = parseInt(child.value);
			count++;
			child.value = count;
		}
	}
	calPrice();
}

// ��������
function decrease(btnObj) {
	// �õ���ǰ��ť���ڵ�Ԫ��������ӽڵ�
	var nodes = btnObj.parentNode.childNodes;
	for ( var i = 0; i < nodes.length; i++) {
		// typeΪtext��input �ڵ�
		var child = nodes[i];
		if (child.nodeName == "INPUT" && child.type == "text") {
			// child ���ı���
			var count = parseInt(child.value);
			if (count > 0) {
				count--;
			}
			child.value = count;
		}
	}
	calPrice();
}
// ���������ı�ʱ������С���Լ��ܼ�
function calPrice() {

	// �õ�������
	var table = document.getElementById("t1");
	// �õ�����������
	var rows = table.getElementsByTagName("tr");
	// �ӵڶ��п�ʼ
	var total = 0;
	for ( var i = 1; i < rows.length; i++) {
		// ���ĵ����ݣ��ڵ�ǰ�еĸ�����Ԫ����
		var curRow = rows[i];// tr
		var cells = curRow.getElementsByTagName("td");
		// �ҵ��۸񣨵ڶ�����Ԫ���е��ı�<td>1.2</td>��
		var price = parseFloat(cells[1].innerHTML);
		// �ҵ���������������Ԫ���еĵڶ���input�е�value��
		var q = parseFloat(cells[2].getElementsByTagName("input")[1].value);
		// ����С�ƣ����ĸ���Ԫ���е��ı�
		var sum = price * q;
		cells[3].innerHTML = sum.toFixed(2);
		// �����ܼ�
		total += sum;
	}
	document.getElementById("totalPrice").innerHTML = total.toFixed(2);
}
