//js�ļ���ֻ�ܰ���js����
function methodInFile()
{
	alert("method in file");
}
//����¼����ֵ��ƽ��
function getSquare() {
	//�õ�����
	var s = document.getElementById("txtNumber").value;
	//���жϣ�   isNaN(xxx)--true/false	is not a number
	if(isNaN(s)) {
		alert("��¼����ֵ");
	}
	else {
		//ת��
		var n = parseInt(s);
		//����
		alert(n * n);
	}
}
//�����ۼӵ�100 �ĺ�
function getSum()
{
	var sum = 0;//������������
	for(var i=0;i<=100;i++)
	{
		sum += i;
	}
	alert(sum);
}
//���������ַ�
function filterString() {
	var str = document.getElementById("txtStr").value;
	//�������е�js���Һ��Դ�Сд
	//var r = str.replace(/js/gi,"*");
	//�������е����֣�������¼����ֵ���滻Ϊ * 
	var r = str.replace( /\d/g ,"*");
	//������¼������
	//var r = str.replace( /[\u4e00-\u9fa5]/g ,"*");

	document.getElementById("txtStr").value = r;
}
//ʵ�ֶ�����ĸ��ֲ���
function operArray(t) {
	var str = document.getElementById("txtArray").value;
	var arr = str.split(",");
	switch(t) {
		case 1:  arr.reverse();  break;
		case 2:  arr.sort();   break;
		case 3://�����ĸ���������
			arr.sort(sortFunc);   	break;
	}
	alert(arr.join("*"));
}
//����������ȽϵĹ���   5,2---2,5
function sortFunc(a,b)  {
	return a-b;
}
//ʵ��������Ĳ���
function randomNumber(min,max)  {
	var seed = Math.random();
	var r = Math.floor(seed * (max-min) + min);
	alert(r);
}
//��֤�û�����3-5����Сд��ĸ
function valiName(){
	var name = document.getElementById("txtName").value;
	var r = /^[a-zA-Z]{3,5}$/;
	if( !r.test(name) ) {
		alert("¼�����");
	}}
function valiPw(){
	var pw = document.getElementById("txtPw").value;
	//alert(pw.length);
	if(pw.length!=6){
		alert("��������λ����");
	}else{
		alert("�����");
	}
}