function $(id){
	return document.getElementById(id);
}

function submit(){
	var name = $("name").value;
	var sg = $("sg").value;
	var tz = $("tz").value;
	var sex;
	if($("sex_m").checked){
		sex = 1;
	}else if($("sex_w").checked){
		sex = 0;
	}
	
	var url = "http://localhost:8088/WEB01/web?name="
			+name+"&sg="+sg+"&tz="+tz+"&sex="+sex;
	location.href = url;
}