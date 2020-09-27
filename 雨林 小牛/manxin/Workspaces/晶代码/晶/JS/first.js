//js文件，只能包含js代码
function methodInFile()
{
	alert("method in file");
}
//计算录入数值的平方
function getSquare() {
	//得到数据
	var s = document.getElementById("txtNumber").value;
	//先判断：   isNaN(xxx)--true/false	is not a number
	if(isNaN(s)) {
		alert("请录入数值");
	}
	else {
		//转换
		var n = parseInt(s);
		//计算
		alert(n * n);
	}
}
//计算累加到100 的和
function getSum()
{
	var sum = 0;//定义数据类型
	for(var i=0;i<=100;i++)
	{
		sum += i;
	}
	alert(sum);
}
//过滤敏感字符
function filterString() {
	var str = document.getElementById("txtStr").value;
	//过滤所有的js，且忽略大小写
	//var r = str.replace(/js/gi,"*");
	//过滤所有的数字：不允许录入数值，替换为 * 
	var r = str.replace( /\d/g ,"*");
	//不允许录入中文
	//var r = str.replace( /[\u4e00-\u9fa5]/g ,"*");

	document.getElementById("txtStr").value = r;
}
//实现对数组的各种操作
function operArray(t) {
	var str = document.getElementById("txtArray").value;
	var arr = str.split(",");
	switch(t) {
		case 1:  arr.reverse();  break;
		case 2:  arr.sort();   break;
		case 3://调用哪个方法即可
			arr.sort(sortFunc);   	break;
	}
	alert(arr.join("*"));
}
//方法：定义比较的规则   5,2---2,5
function sortFunc(a,b)  {
	return a-b;
}
//实现随机数的产生
function randomNumber(min,max)  {
	var seed = Math.random();
	var r = Math.floor(seed * (max-min) + min);
	alert(r);
}
//验证用户名：3-5个大小写字母
function valiName(){
	var name = document.getElementById("txtName").value;
	var r = /^[a-zA-Z]{3,5}$/;
	if( !r.test(name) ) {
		alert("录入错误！");
	}}
function valiPw(){
	var pw = document.getElementById("txtPw").value;
	//alert(pw.length);
	if(pw.length!=6){
		alert("请输入六位数字");
	}else{
		alert("你对了");
	}
}