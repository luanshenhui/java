function testName(){
	var name = document.getElementById("name").value;
	var reg = /^[a-zA-Z]{3,5}$/;
	if(reg.test(name)){
		document.getElementById("nameMsg").style.color="green";
	}else{
		document.getElementById("nameMsg").style.color="red";
	}
	return reg.test(name);
}
function testAge(){
	var age = document.getElementById("age").value;
	var reg = /^\d{2}$/;
	if(reg.test(age)){
		document.getElementById("ageMsg").style.color="green";
	}else{
		document.getElementById("ageMsg").style.color="red";
	}
	return reg.test(age);
}
function validate(){
	var a = testName();
	var b = testAge();
	return a && b;
}