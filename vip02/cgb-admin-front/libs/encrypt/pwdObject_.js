var pwdFormatMsg = new Array(18);

pwdFormatMsg[0] = new Array("100","只允许字母");        
pwdFormatMsg[1] = new Array("010","只允许数字");        
pwdFormatMsg[2] = new Array("001","只允许特殊符");      
pwdFormatMsg[3] = new Array("110","允许字母或数字");    
pwdFormatMsg[4] = new Array("101","允许字母或特殊符");  
pwdFormatMsg[5] = new Array("011","允许数字或特殊符");  
pwdFormatMsg[6] = new Array("000","不允许输入任何字符");
pwdFormatMsg[7] = new Array("111","允许输入任何字符");  
pwdFormatMsg[8] = new Array("220","必须字母和数字");                                                   
pwdFormatMsg[9] = new Array("202","必须字母和特殊符");                                                 
pwdFormatMsg[10] =new Array("022","必须数字和特殊符");                                                 
pwdFormatMsg[11] =new Array("222","必须包含三种类型的字符");                                           
pwdFormatMsg[12] =new Array("221","须包含字母和数字，允许特殊符");                                     
pwdFormatMsg[13] =new Array("212","须包含字母和特殊符，允许数字");                                     
pwdFormatMsg[14] =new Array("122","须包含数字和特殊符，允许字母");                                     
pwdFormatMsg[15] =new Array("221|212|122","必须同时包含两种或以上类型的字符");                         
pwdFormatMsg[16] =new Array("221|212","必须包含字母，且同时包含数字、字母、符号中任意两种以上字符");   
pwdFormatMsg[17] =new Array("020","必须是数字");                                                       

var version_now = "2.1.0.0";//现有版本

//根据规则代码获取规则描述信息                             
function getpwdFormatMsg(ruleStr){
	for(var i=0;i<pwdFormatMsg.length;i++){                   
		if(ruleStr==pwdFormatMsg[i][0]){
			return pwdFormatMsg[i][1];
		}
	}                                                         
	return "";                                                
}                                                          

//生成密码控件
//tdObj:密码输入框所在表格的td对象,pwdObjId:密码控件对象id
function createPwdObjectNew(pwdObjId,pwdObjWidth,pwdObjHeight,minLen,maxLen,typeStr,ruleStr,nextElemId,pwdHiddenName,style,classname){
	  var str = getPwdObjNewHtml(pwdObjId,pwdObjWidth,pwdObjHeight,minLen,maxLen,typeStr,ruleStr,nextElemId,pwdHiddenName,style);
      if(classname){
          document.getElementById(classname).innerHTML=str;
      }else{
          document.write(str);
      }
}

/**
 * 创建密码控件对象html片段
 */
function getPwdObjNewHtml(pwdObjId,pwdObjWidth,pwdObjHeight,minLen,maxLen,typeStr,ruleStr,nextElemId,pwdHiddenName,style){
   var x = navigator;
     var res = new Array(2);
     var appVersion_ = x.appVersion;
     var browser = x.appName;
     if(x.cpuClass!='x86'){
        res = choiceCab(1);//64位浏览器
     }else{
      if(appVersion_.indexOf("WOW64;") == '-1'){
         res = choiceCab(2);//32位浏览器，32系统
      }else{
         res = choiceCab(3);//32位浏览器，64系统
      }
     }
     classid = res[0];
     codebase = res[1];//alert("classid="+classid+",codebase="+codebase);
     var activeName;
     if(navigator.userAgent.indexOf("Firefox")>=0){
        activeName = "application/x-CgbEditFirefox-plugin";
     }else if(navigator.userAgent.indexOf("Safari")>=0 && navigator.userAgent.indexOf("Macintosh")>=0 && navigator.userAgent.indexOf("Chrome")<0){
        activeName = "application/x-CgbEditMac-plugin";
     }else if(navigator.userAgent.indexOf("Chrome")>=0){
        activeName = "application/x-CgbEditChrome-plugin";
     }
     var str = "";
     if(browser == 'Microsoft Internet Explorer' || navigator.userAgent.indexOf("rv:11.0") > 0){
        if(navigator.userAgent.indexOf("Windows NT 6.2") > 0 || navigator.userAgent.indexOf("Windows NT 6.3")> 0 || navigator.userAgent.indexOf("rv:11.0") > 0){
           str += "<object  id=\""+pwdObjId+"\" classid=\""+classid+
                "\" codebase=\"/assets/encrypt/cab_win81/"+codebase+
                "\#version=2,3,0,0\" width=\""+pwdObjWidth+"\" height=\""+pwdObjHeight+
                "\"> <param name=\"MinLength\" value=\""+minLen+
                "\" >  <param name=\"MaxLength\" value=\""+maxLen+
                "\" > <param name=\"Type\" value=\""+typeStr+
                "\" > <param name=\"Rule\" value=\""+ruleStr+
                "\" >  </object>";
        }else{
           str += "<object  id=\""+pwdObjId+"\" classid=\""+classid+
                "\" codebase=\"/assets/encrypt/"+codebase+
                "\#version=2,1,0,0\" width=\""+pwdObjWidth+"\" height=\""+pwdObjHeight+
                "\"> <param name=\"MinLength\" value=\""+minLen+
                "\" >  <param name=\"MaxLength\" value=\""+maxLen+
                "\" > <param name=\"Type\" value=\""+typeStr+
                "\" > <param name=\"Rule\" value=\""+ruleStr+
                "\" >  </object>";
        }
     }else{
        str += "<object  id=\""+pwdObjId+"\"  type='"+activeName+
             "'style='" + style + "' width=\""+pwdObjWidth+"\" height=\""+pwdObjHeight+
             "\"> <param name=\"NextElemId\" value=\""+nextElemId+
             "\"> <param name=\"MinLength\" value=\""+minLen+
             "\"> <param name=\"MaxLength\" value=\""+maxLen+
             "\"> <param name=\"Type\" value=\""+typeStr+
             "\"> <param name=\"Rule\" value=\""+ruleStr+
             "\"> </object>";
     }
     if(pwdHiddenName!="" && pwdHiddenName!=null) str += "<input type=\"hidden\" id=\""+pwdHiddenName+"\"/>";
     return str;
}

//清空密码控件                   
function clearPwdObject(pwdObj){ 
	pwdObj.Clear();                 
}                                

//校验密码控件
function checkPwdObject_login(pwdObj1,pwdObjTitle1,pwdHiddenObj,pwdIsPassObj){                    
	// 得到密码加密后的密文
	var szres = pwdObj1.GetRT();
	var len = szres.length-4;
	pwdHiddenObj.value=szres.substring(0,len);
	// 密码长度校验代码
	var checkLen = szres.substring(len,len+2);
	// 密码规则校验代码
	var checkRule = szres.substring(len+2,len+4);
	
	if(pwdIsPassObj){
		pwdIsPassObj.value = "1";
		if(checkLen!="01"){
			pwdIsPassObj.value = "0";//长度不对要修改
		}
		if(checkRule!="01"){
			pwdIsPassObj.value = "0";//纯数字则要修改
		}
		if(doGetCSRule(pwdObj1,$("loginId").value) != "0"){
			pwdIsPassObj.value = "0";//符合简单密码规则要修改
		}
	}
	return true;
}                                                                                                   

function checkPwdObject1(pwdObj1,pwdObjTitle1,ruleStr,lenMsg,userName){
	var ruleMsg = "";
	
	if(ruleStr!=""){
		ruleMsg = getpwdFormatMsg(ruleStr);
	}
	
	// 得到密码加密后的密文
	var szres = pwdObj1.GetRT();                                                                        
	var len = szres.length-4;                 
	
	// 密码长度校验代码
	var checkLen = szres.substring(len,len+2);
	
	// 密码规则校验代码
	var checkRule = szres.substring(len+2,len+4);                                                           
	if(checkLen!="01" && lenMsg!=""){
		clearPwdObject(pwdObj1);
		return pwdObjTitle1+"长度为"+lenMsg+",请重新输入";
	} 
	if(checkRule!="01" && ruleStr!=""){
		clearPwdObject(pwdObj1);
		return pwdObjTitle1+ruleMsg+",请重新输入";
	}
	if(userName){
		var simple = doGetCSRule(pwdObj1,userName);
		if(simple != "0"){
			clearPwdObject(pwdObj1);
			return getSimpleMsg(simple);
		}
	}
    
	return "";
}

function checkPwdObjectHidden(pwdObj1,pwdObjTitle1,pwdObj2,pwdObjTitle2,pwdHiddenObj1,pwdHiddenObj2,ruleStr,lenMsg,userName){
	var ruleMsg = ""; 
	
	if(ruleStr!=""){ 
		ruleMsg = getpwdFormatMsg(ruleStr);
	}
	
	// 得到密码加密后的密文
	var szres1 = pwdObj1.GetRT();                                                                                                
	var len1 = szres1.length-4;                                                                                                                        
	var checkLen1 = szres1.substring(len1,len1+2);
	var checkRule1 = szres1.substring(len1+2,len1+4);
	
	if(checkLen1!="01" && lenMsg!=""){
		pwdAlert(pwdObjTitle1+"长度为"+lenMsg+",请重新输入"); clearPwdObject(pwdObj1);clearPwdObject(pwdObj2);return false;
	}
	
	if(checkRule1!="01" && ruleStr!=""){
		pwdAlert(pwdObjTitle1+ruleMsg+",请重新输入"); clearPwdObject(pwdObj1);clearPwdObject(pwdObj2);return false;
	}      
    
	// 得到密码加密后的密文 
	var szres2 = pwdObj2.GetRT();                                                                                               
                                                                                                                                                    
	if(!pwdObj1.IsEqual(pwdObj2)){
		pwdAlert(pwdObjTitle1+"与"+pwdObjTitle2+"不一致!");
		clearPwdObject(pwdObj1);
		clearPwdObject(pwdObj2);
		return false;
	}
	
	if(userName){
		var simple = doGetCSRule(pwdObj1,userName);
		if(simple != "0"){
			clearPwdObject(pwdObj1);
			clearPwdObject(pwdObj2);
			pwdAlert(getSimpleMsg(simple));
			return false;
		}
	}
	
	// 密码校验通过，则将加密后的密文赋值给pwdHiddenObj隐藏域
	pwdHiddenObj1.value=szres2.substring(0,len1);
	// 密码校验通过，则将加密后的密文赋值给pwdHiddenObj隐藏域
	pwdHiddenObj2.value=szres2.substring(0,len1);
	return true;                                                                                        
	}                                                                                                                          

function checkPwdObject2(pwdObj1,pwdObjTitle1,pwdObj2,pwdObjTitle2,ruleStr,lenMsg,userName){                                     
	var ruleMsg = ""; 
	
	if(ruleStr!=""){ 
		ruleMsg = getpwdFormatMsg(ruleStr);
	}
	
	// 得到密码加密后的密文
	var szres1 = pwdObj1.GetRT();                                                                                                
	var len1 = szres1.length-4;                                                                                                                        
	var checkLen1 = szres1.substring(len1,len1+2);
	var checkRule1 = szres1.substring(len1+2,len1+4);
	
	if(checkLen1!="01" && lenMsg!=""){
		return (pwdObjTitle1+"长度为"+lenMsg+",请重新输入"); clearPwdObject(pwdObj1);clearPwdObject(pwdObj2)
	}
	
	if(checkRule1!="01" && ruleStr!=""){
        return (pwdObjTitle1+ruleMsg+",请重新输入"); clearPwdObject(pwdObj1);clearPwdObject(pwdObj2);
	}      
    
	// 得到密码加密后的密文 
	var szres2 = pwdObj2.GetRT();                                                                                               
                                                                                                                                                    
	if(!pwdObj1.IsEqual(pwdObj2)){
		clearPwdObject(pwdObj1);
		clearPwdObject(pwdObj2);
        return (pwdObjTitle1+"与"+pwdObjTitle2+"不一致!");
	}
	
	if(userName){
		var simple = doGetCSRule(pwdObj1,userName);
		if(simple != "0"){
			clearPwdObject(pwdObj1);
			clearPwdObject(pwdObj2);
            return (getSimpleMsg(simple));
		}
	}
	return "";
	}
 
function checkPwdObject3(pwdObj1,pwdObjTitle1,pwdObj2,pwdObjTitle2,pwdObj3,pwdObjTitle3,pwdHiddenObj1,pwdHiddenObj2,pwdHiddenObj3,ruleStr,lenMsg,userName){
	var ruleMsg = ""; 
	
	if(ruleStr!=""){ 
		ruleMsg = getpwdFormatMsg(ruleStr);
	}
	
	// 得到密码加密后的密文 
	var szres1 = pwdObj1.GetRT();
	var len1 = szres1.length-4;
	var checkLen1 = szres1.substring(len1,len1+2);
	var checkRule1 = szres1.substring(len1+2,len1+4);

	//if(checkRule1!="01" && ruleStr!=""){
	//	pwdAlert(pwdObjTitle1+ruleMsg+",请重新输入");
	//	clearPwdObject(pwdObj1);
	//	return false;
	//}

	// 得到密码加密后的密文
	var szres2 = pwdObj2.GetRT();                                                                                               
	var len2 = szres2.length-4;                                                                                                                       
	var checkLen2 = szres2.substring(len2,len2+2);                                                                                                    
	var checkRule2 = szres2.substring(len2+2,len2+4);     
	
	if(checkLen2!="01" && lenMsg!=""){
		pwdAlert(pwdObjTitle2+"长度为"+lenMsg+",请重新输入");
		clearPwdObject(pwdObj2);
		clearPwdObject(pwdObj3);
		return false;
	}
	
	if(checkRule2!="01" && ruleStr!=""){
		pwdAlert(pwdObjTitle2+ruleMsg+",请重新输入");
		clearPwdObject(pwdObj2);
		clearPwdObject(pwdObj3);
		return false;
	}
                                 
	// 得到密码加密后的密文
	var szres3 = pwdObj3.GetRT();                                                                                               
                                                                                                                                                   
	if(!pwdObj2.IsEqual(pwdObj3)){
		pwdAlert(pwdObjTitle2+"与"+pwdObjTitle3+"不一致!");
		clearPwdObject(pwdObj2);
		clearPwdObject(pwdObj3);
		return false;
	}
    
	if(userName){
		var simple = doGetCSRule(pwdObj2,userName);
		if(simple != "0"){
			clearPwdObject(pwdObj2);
			clearPwdObject(pwdObj3);
			pwdAlert(getSimpleMsg(simple));
			return false;
		}
	}
	
	// 密码校验通过，则将加密后的密文赋值给pwdHiddenObj1隐藏域
	pwdHiddenObj1.value=szres1.substring(0,len1);
	// 密码校验通过，则将加密后的密文赋值给pwdHiddenObj2隐藏域
	pwdHiddenObj2.value=szres2.substring(0,len2);
	// 密码校验通过，则将加密后的密文赋值给pwdHiddenObj3隐藏域
	pwdHiddenObj3.value=szres2.substring(0,len2);         
	
	return true;                                                                                                                                      
}

function getVersion(pwdObj1){//获得版本
	try{
		var version_new = pwdObj1.GetV();
		if(version_now!=version_new) {return false;}else{return true;}
	}catch(e){
		return false;
	}
}

function doGetCSRule(pwdObj1,userName) {//简单密码
    var res = pwdObj1.CSRule(userName);
    var simpleRes = '0';
    if(res!='0000000000'){
   	  if(res.substring(5,6)!='0'){//判断登录名密码是否一致
   	  	  simpleRes ='1' ;
   	  }else if(res.substring(6,9)!='000'){
   		  simpleRes ='2' ;
      }else if(res.substring(9,10)!='0'){
    	  simpleRes ='3' ;
      }
    }
    return simpleRes;
}

function getSimpleMsg(simpleValue){//密码提示
	if(simpleValue == '1'){
		return "您设置的网银密码与登录名相同，为了您的账户安全，请重新输入";
	}else if(simpleValue == '2'){
		return "您设置的网银密码与登录名有连续的相同部分，为了您的账户安全，请重新输入";
	}else if(simpleValue == '3'){
		return "您设置的网银密码存在连续或相同的数字或字母，为了您的账户安全，请重新输入";
	}
}

function choiceCab(flag){//根据浏览器和操作系统选择不同的cab
	var res = new Array();
    var isTest='1';//0:测试环境 1:生产环境  部署到生产环境时一定要改成1
    if(isTest=='0'){
		if(flag=='1'){
			res[0]='CLSID:307A2091-A687-4877-8ED4-4B9C8C907E9D';
			res[1]='CgbEditx64_Test.cab';
		}else if(flag=='2'){
		   	res[0]='CLSID:AAFAB3F0-A07B-4482-A044-CD42AB41D294';
		   	res[1]='CgbEditx86_Test.cab';
		}else if(flag=='3'){
			res[0]='CLSID:AAFAB3F0-A07B-4482-A044-CD42AB41D294';
			res[1]='CgbEditx64x86_Test.cab';
		}
	}else{
		if(flag=='1'){
			res[0]='CLSID:9FF156EE-F5C1-4FBD-A567-9F0BD113A072';
			res[1]='CgbEditx64.cab';
		}else if(flag=='2'){
		   	res[0]='CLSID:5157896D-FCA4-40C8-BFCF-34CD3BAEE25A';
		   	res[1]='CgbEditx86.cab';
		}else if(flag=='3'){
			res[0]='CLSID:5157896D-FCA4-40C8-BFCF-34CD3BAEE25A';
			res[1]='CgbEditx64x86.cab';
		}
	}
	return res;
}

function pwdAlert(msg){
	try{
        alert(msg);
	}catch(e){
		alert(msg);
	}
}

//根据版本号获得秘密密文
function getPasswordByVersion(pwdObj, versionNum) {
    if(versionNum == pwdObj.GetV()) {
        return pwdObj.GetRT2048("");//若是最新版，则使用这个接口
    } else {
        return pwdObj.GetRT();
    }
}

function getRandomCode(){
    var data = '';
    $.ajax({
        url: "/mmc/api/admin/user/getRandomCode?_="+new Date(),
        async: false,
        type:'GET', //数据发送方式
        error: function(){ //失败
            alert('密码控件失败');
        },
        success: function(msg){ //成功
            if(msg == null){
                alert('密码控件失败');
            }
            data = msg.data;
        }
    });
    return data;
}


