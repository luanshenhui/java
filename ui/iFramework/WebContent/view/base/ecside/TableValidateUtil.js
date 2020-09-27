/**
 * 表格编辑时做有效性校验，IE8、FF23已经测试通过
 * 详细说明请见TableCheckUtilDemo.html
 * 体积小，简单，易于扩展，适合定制，目前还不支持国际化。
 * @date 2013/08/27  Tue
 * @author wangxy
 */

/**
 * 对控件进行有效性校验
 * @param aElement 要校验的控件
 * @param oForm 对于radio和checkbox必须要传，其它可以不传
 */
function checkElement(aElement,oForm)
{
	//获取控件验证类型
	var sType=aElement.attributes.valueType.nodeValue;
	if(aElement.attributes.mustInput!=null && aElement.attributes.mustInput)
	{
		if(trim(aElement.value)=="")
		{
			if(aElement.attributes.objname != null)
			{
				alert(aElement.attributes.objname.nodeValue+"不可以为空");
			}
			else
			{
				alert("该文本框为必输字段");
			}
			aElement.focus(); 
			return false; 
		}
	} 
	switch(sType)
	{
		//整数
		case "int":
		if(!checkInt(aElement))
		{
			return false;
		}
		break;
		//小数
		case "float":
		if(!checkFloat(aElement))
		{ 
			return false;
		}
		break;
		//字符串
		case "string":
		if(!checkString(aElement))
		{
			return false;
		}
		break;
		//日期
		case "date":
		if(!checkDate(aElement))
		{
			return false;
		}
		break;
		//邮件
		case "email":
		if(!checkEmail(aElement))
		{
			return false;
		}
		break;
		//单选按钮
		case "radio":
		if(!checkRadio(aElement,oForm))
		{
			return false;
		}
		break;
		//复选按钮
		case "checkbox":
		if(!checkBox(aElement,oForm))
		{
			return false;
		}
		break;
		//下拉列表框
		case "select":
		if(!checkSelect(aElement))
		{
			return false;
		}
		break;
		//列表框
		case "list":
		if(!checkList(aElement))
		{
			return false;
		}
		break;
	}
	return true;
}

//对form进行验证
function checkForm(formID)
{
	var oForm= document.getElementById(formID);
	var eles = oForm.elements;
	//遍历所有表元素
	for(var i=0;i<eles.length;i++)
	{
		//是否需要验证
		var sType=eles[i].attributes.valueType;
		if(sType)
		{
			if(!checkElement(eles[i],oForm))
				return false;
		}
	}
	return true;
}

/***检查是否为整数***/
function checkInt(ele)
{
	if(!isInt(ele.value))
	{
		alert("请输入有效整数");
		ele.focus();
		return false;
	}
	else
	{
		if(ele.maxInput!=null && !isNaN(ele.maxInput))
		if(parseInt(ele.maxInput)<parseInt(ele.value))
		{
			alert("您输入的"+ convertNullToSpace(ele.objname)+"值应该小于"+ele.maxInput); 
			ele.focus();
			return false;
		} 
		if(ele.minInput!=null && !isNaN(ele.minInput))
			if(parseInt(ele.minInput)>parseInt(ele.value))
			{
				alert("您输入的"+ convertNullToSpace(ele.objname)+"值应该大于"+ele.minInput);
				ele.focus();
				return false;
			} 
	}
	return true;
}

/***检查是否为小数***/
function checkFloat(ele)
{
	if(isNaN(ele.value))
	{
		alert("请输入有效数字");
		ele.focus();
		return false;
	}
	else
	{
		if(ele.decimalLen!=null && !checkDecimal(ele.value,ele.decimalLen))
		{
			alert("您输入的"+convertNullToSpace(ele.objname)+"值小数位最多为"+ele.decimalLen);
			ele.focus(); 
			return false;
		} 
		if(ele.maxInput!=null && !isNaN(ele.maxInput))
			if(parseInt(ele.maxInput)<parseInt(ele.value))
			{
				alert("您输入的"+ convertNullToSpace(ele.objname)+"值应该小于"+ele.maxInput); 
				ele.focus();
				return false;
			} 
		if(ele.minInput!=null && !isNaN(ele.minInput))
			if(parseInt(ele.minInput)>parseInt(ele.value))
			{
				alert("您输入的"+ convertNullToSpace(ele.objname)+"值应该大于"+ele.minInput);
				ele.focus();
				return false;
			} 
	}
	return true;
}

/***检查是否为字符串***/
function checkString(ele)
{
	if(ele.stringLen!=null && !isNaN(ele.stringLen))
	{
		var value=new String(ele.value);
		if(value.length>parseInt(ele.stringLen))
		{
			alert("您输入的"+convertNullToSpace(ele.objname)+"最大长度为"+ele.stringLen);
			ele.focus(); 
			return false;
		}
	}
	return true;
}
/***检查是否为日期格式***/
function checkDate(ele)
{
	if(!isDate(ele.value))
	{
		alert("请输入有效日期(yyyy-mm-dd)");
		ele.focus();
		return false;
	}
	return true;
}

/***检查是否为电子邮箱***/
function checkEmail(ele)
{
	if(!isEmail(ele.value))
	{
		alert("请输入有效邮箱");
		ele.focus();
		return false;
	}
	return true;
}
/***检查单选按钮是否需要选择***/
function checkRadio(ele,aForm)
{
	if(aForm == null || aForm == "undefined" || aForm == undefined)
		return true;
	var rads = new Array();
	var eles = aForm.elements;
	//遍历所有表元素
	for(var i=0;i<eles.length;i++)
	{
		if(ele.name == eles[i].name)
			rads.push(eles[i]);
	}
	//eval("var rads="+name+"."+ele.name);
	var selectCount=0;
	for(var i=0;i<rads.length;i++)
	{
		if(rads[i].checked)
		{
			selectCount++;
		}
	}

	if(ele.attributes.mustSelect!=null && ele.attributes.mustSelect)
	{
		if(selectCount==0)
		{
			alert("请选择"+convertNullToSpace(ele.objname));
			ele.focus(); 
			return false;
		}
	}
	return true;
}
/***检查复选按钮是否需要选择***/
function checkBox(ele,aForm)
{
	if(aForm == null || aForm == "undefined" || aForm == undefined)
		return true;
	var chks = new Array();
	var eles = aForm.elements;
	//遍历所有表元素
	for(var i=0;i<eles.length;i++)
	{
		if(ele.name == eles[i].name)
			chks.push(eles[i]);
	}
	var selectCount=0;
	for(var i=0;i<chks.length;i++)
	{
		if(chks[i].checked)
		{
		selectCount++;
		}
	}
	if(ele.attributes.minselect!=null && !isNaN(ele.attributes.minselect.nodeValue))
	{
		if(selectCount<parseInt(ele.attributes.minselect.nodeValue))
		{
			alert(convertNullToSpace(ele.objname)+"至少选择"+ele.attributes.minselect.nodeValue+"项");
			ele.focus(); 
			return false;
		}
	}
	if(ele.attributes.maxselect!=null && !isNaN(ele.attributes.maxselect.nodeValue))
	{
		if(selectCount>parseInt(ele.attributes.maxselect.nodeValue))
		{
			alert(convertNullToSpace(ele.objname)+"至多选择"+ele.attributes.maxselect.nodeValue+"项");
			ele.focus(); 
			return false;
		}
	}
	return true;
}
/***检查下拉列表框是否需要选择***/
function checkSelect(ele)
{
	//var rads = document.getElementsByName(ele.name);
	if(ele.attributes.mustselect!=null && ele.attributes.mustselect)
	{
		if(ele.selectedIndex==0)
		{
			alert("请选择"+convertNullToSpace(ele.objname));
			ele.focus(); 
			return false;
		}
	}
	return true;
}
/***检查列表框的选择项数***/
function checkList(ele)
{
	//var rads = document.getElementsByName(ele.name);
	var selectCount=0;
	for(var i=0;i<ele.options.length;i++)
	{
		if(ele.options[i].selected)
		{
			selectCount++;
		}
	}
	if(ele.attributes.minselect!=null && !isNaN(ele.attributes.minselect.nodeValue))
	{
		if(selectCount<parseInt(ele.attributes.minselect.nodeValue))
		{
			alert(convertNullToSpace(ele.objname)+"至少选择"+ele.attributes.minselect.nodeValue+"项");
			ele.focus(); 
			return false;
		}
	}
	if(ele.attributes.maxselect!=null && !isNaN(ele.attributes.maxselect.nodeValue.nodeValue))
	{
		if(selectCount>parseInt(ele.attributes.maxselect.nodeValue))
		{
			alert(convertNullToSpace(ele.objname)+"至多选择"+ele.attributes.maxselect.nodeValue+"项");
			ele.focus(); 
			return false;
		}
	}
	return true;
}
/***判断是否为整数***/
function isInt(s)
{
	var patrn=/^[-,+]{0,1}[0-9]{0,}$/;
	if (!patrn.exec(s))
	return false;
	return true;
}
/***判断是否为数字***/
function isNumber(s)
{
	var patrn=/^[-,+]{0,1}[0-9]{0,}[.]{0,1}[0-9]{0,}$/;
	if (!patrn.exec(s))
	return false;
	return true;
}
/***判断是否为日期***/
function isDate(str)
{
	var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/); 
	if(r==null)
	{
		return false;
	} 
	var d= new Date(r[1], r[3]-1, r[4]); 
	if(!(d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]))
	{ 
		return false;
	}
	return true;
}
/***判断是否为邮箱***/
function isEmail(str)
{
	if(str.match(/[\w-]+@{1}[\w-]+\.{1}\w{2,4}(\.{0,1}\w{2}){0,1}/ig)!=str)
		return false;
	else
		return true;
}
/***将NULL转化为空格，用于显示对象名称***/
function convertNullToSpace(paramValue)
{
	if(paramValue==null)
		return "";
	else 
		return paramValue;
}
/***检查小数位数***/
function checkDecimal(num,decimalLen)
{
	var len = decimalLen*1+1;
	if(num.indexOf('.')>0)
	{
		num=num.substr(num.indexOf('.')+1,num.length-1); 
		if ((num.length)<len)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	return true;
}
/***去除空格***/
function trim(str)
{
	if (str.length > 0) 
	{
		while ((str.substring(0,1) == " ") && (str.length > 0)) 
		{
			str = str.substring(1,str.length);
		}
		while (str.substring(str.length-1,str.length) == " ") 
		{
			str = str.substring(0,str.length-1);
		}
	}
	return str;
}