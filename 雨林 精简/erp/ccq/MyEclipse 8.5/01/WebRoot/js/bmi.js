function $(id){
	return document.getElementById(id)
}
function submit(){
	var name=$("name").value;
	var sg=$("sg").value;
	var tz=$("tz").value;
	var sex;
	if($("sex_m").checked){
	sex=$("sex_m").value;
	}else if($("sex_w").checked){
		sex=$("sex_w").value;
	}
	var url="http://localhost:8088/01/web?name="+name+"&sex="+sex+"&sg="+sg+"&tz="+tz;
		location.href=url;
}