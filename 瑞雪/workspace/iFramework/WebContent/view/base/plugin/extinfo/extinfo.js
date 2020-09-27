function getExtInfo(obj){
    var strHtml="";
	//动态构建扩展信息
	for(var i = 0 ; i<obj.length; i++){				
		if(obj[i].name !="id"){
			if(obj[i].type=="TextField"){
				strHtml += '<tr><td>'+obj[i].label+'：</td><td><input type="text"';
				if(obj[i].maxLength != ""){
					strHtml +=' maxLength="'+obj[i].maxLength+'"';
				}
				strHtml +=' id="'+obj[i].name+'" name="'+obj[i].name+'" style="width:'+obj[i].width +';"/>';
				if(obj[i].allowBlank == "false"){
					strHtml +='&nbsp;<font color="#ff0000">*</font></td></tr>';
				}else{
					strHtml +='</td></tr>';
				}
			}else if(obj[i].type=="DateField"){
				strHtml += '<tr><td>'+obj[i].label+'：</td><td><input type="text"';

				strHtml +=" id=\""+obj[i].name+"\" name=\""+obj[i].name+"\" style=\"width:"+obj[i].width +";\" readOnly onFocus=\"WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',readOnly:true})\" class=\"Wdate\">";
				if(obj[i].allowBlank == "false"){
					strHtml +='&nbsp;<font color="#ff0000">*</font></td></tr>';
				}else{
					strHtml +='</td></tr>';
				}
			}else if(obj[i].type=="NumberField"){
				strHtml += '<tr><td>'+obj[i].label+'：</td><td><input type="text"';
				if(obj[i].maxLength != ""){
					strHtml +=' maxLength="'+obj[i].maxLength+'"';
				}
				strHtml +=' id="'+obj[i].name+'" name="'+obj[i].name+'" style="width:'+obj[i].width +';"/>';
				if(obj[i].allowBlank == "false"){
					strHtml +='&nbsp;<font color="#ff0000">*</font></td></tr>';
				}else{
					strHtml +='</td></tr>';
				}
			}else if(obj[i].type=="ComboBox"){
				strHtml += '<tr><td>'+obj[i].label+'：</td>';
				if(obj[i].allowBlank == "false"){
					strHtml +='<td><select id="'+obj[i].name+'" name="'+obj[i].name+'" readOnly style="width:'+obj[i].width +';\"></select>&nbsp;<font color="#ff0000">*</font></td></tr></td></tr>';
				}else{
					strHtml +='<td><select id="'+obj[i].name+'" name="'+obj[i].name+'" readOnly style="width:'+obj[i].width +';\"></select></td></tr>';
				}
			}
		}
	}
	return strHtml;
}