/**
 * 获取checkbox选中的行的JSON数据格式:"selectedRecords":[{}] 
 * 
 * 注意：本方法要求隐藏列必须位于最后，不能放到前面
 * 
 * @param tableId
 *            ecside表格的id，默认是一般情况下是"ec"。
 */
ECSideUtil.getSelectedRowJSON = function(tableId) {
	var selectedRecords = "\"selectedRecords\":[";
	var ecsideObj = ECSideUtil.getGridObj(tableId);
	var listBody = ecsideObj.ECListBody.rows;
	// 取所有列
	var headCells = ecsideObj.ECListHead.rows[0].cells;
	var allcheckarray = ECSideUtil.getPageCheckValue("checkBoxID");
	if (!allcheckarray) {
		return "no rows checked";
	}
	for ( var i = 0; i < allcheckarray.length; i++) {
		for ( var j = 0; j < listBody.length; j++) {
			var tempID = "";
			if (listBody[j].cells[0].children[0]) {
				tempID = listBody[j].cells[0].children[0].value;
			}
			if (tempID == allcheckarray[i]) {
				var pars = ECSideUtil.getRowCellsMap(listBody[j], tableId);
				selectedRecords += "{";
				for (sKey in pars) {
					if (pars[sKey] == "" || pars[sKey] == 'null'
							|| pars[sKey] == undefined)
						pars[sKey] = "";
					selectedRecords += "\"" + sKey + "\":\"" + pars[sKey]
							+ "\",";
				}
				selectedRecords = selectedRecords.substring(0,
						selectedRecords.length - 1);
				selectedRecords += "},";
				continue;
			}
		}
	}
	if (selectedRecords.indexOf(",") > 0)
		selectedRecords = selectedRecords.substring(0,
				selectedRecords.length - 1); // 去掉","
	selectedRecords += "]";
	return selectedRecords;
};
/**
 * FunctionName:ECSideUtil.addToGirdWithInitValue
 * @param
 *  buttonObj 操作id 可以为null
 *  templateId 模板id
 *  formid 表单id
 *  newRowcount 新增行数
 *  initValue 一行初始值
 * desc:增加行并赋初始值
 * update: 
 * */
ECSideUtil.addToGirdWithInitValue = function(buttonObj,templateId,formid,newRowcount,initValue){	
	if(newRowcount>0){}else{
		newRowcount = 1;
		}
	for(var k=0;k<newRowcount;k++){
		ECSideUtil.addToGird(buttonObj,templateId,formid);		
	}
	var newAddRows = ECSideUtil.getAddRows(formid);
	if(newAddRows.length>0){
		for(var i=0;i<newAddRows.length;i++){
			ECSideUtil.setInitValue(newAddRows[i],initValue);
			}		
		}	
}
/**
 * FunctionName:ECSideUtil.getAddRows
 * @param
 *  formid 表单id
 * desc:增加行并赋初始值
 * update: 
 * */
ECSideUtil.getAddRows = function(formid){
	var ecsideObj=ECSideUtil.getGridObj(formid);
	var isAddRow;
	var listBody = ecsideObj.ECListBody.rows;
	var addRows = new Array();
	var i = 0;
	for(j=0; j<listBody.length; j++){
		isAddRow = ECSideUtil.hasClass(listBody[j],"add");
		if(isAddRow){
			addRows[i] = listBody[j];
			i++;
			}
		}
	return addRows;
}
/**
 * FunctionName:ECSideUtil.setInitValue
 * @param 
 *  currRow 新增的行
 *  initValue 初始值数组
 * desc:为新增行赋值
 * update: 
 * */
ECSideUtil.setInitValue=function(currRow,initValue)
{
   var cells = currRow.cells;  
   var childNodesLengh; 
   var j=0;
   for(var i=0; i<cells.length; i++)
   {
	     childNodesLengh = cells[i].childNodes.length;	    
	     if(childNodesLengh>1)
     {	    	
	    	if(initValue[j]){
	    		sValue = initValue[j];
	    	}else{
	    		sValue ='';
	    	}	    	 
	    	cells[i].children[0].value	= sValue;
	    	j++;		            
     }
   }   
}
/**
 * FunctionName:ECSideUtil.setInsertProperty
 * @param 
 *  currRow 为编辑状态的行按列名赋值
 *  initValue 初始值数组
 *  sValue 初始值
 * desc:为新增行赋值
 * update: 
 * */
ECSideUtil.setInsertProperty=function(currRow,rowName,sValue)
{
 var cells = currRow.cells;
   var flag = false;
   var nodeName;
   var childNodesLengh;
   var _name;
   for(var i=0; i<cells.length; i++)
   {
	     childNodesLengh = cells[i].childNodes.length;
	     if(childNodesLengh>1)
     {	    
	    	 _name = cells[i].children[0].name;
	    	 if(_name==rowName){
	    		 cells[i].children[0].value	= sValue;
		    	 }	    	
        flag = true;        
     }
   }
   if(!flag)
   {
       alert("setInsertProperty（）函数设置属性出错，请检查列名是否正确！");
    return;
   }
}
/**
 * FunctionName:ECSideUtil.AddToGridWithId
 * @param 
 *  templateId 新建模板id
 *  formid 表单id
 * desc:按模板新增一行，并为新增行及行中的每个元素增加id,id标示的规则是addElement_行号_元素在模板中定义的id/name/编号
 * update: 
 * */
ECSideUtil.AddToGridWithId = function(templateId,formid){	
	var ecsideObj =ECSideUtil.getGridObj(formid);
	var template=document.getElementById(templateId);
	if (!template){
		template= document.getElementById(ECSideConstants.DEFALUT_ADD_TEMPLATE);
	}
	template=template.value;
	
//  框架原版代码	
//	if (ecsideObj.ECListBody.rows){
//		rowsNum=ecsideObj.ECListBody.rows.length;
//	}
//	var newTr=ecsideObj.ECListBody.insertRow(rowsNum);
	
//  yin.hl修改-start
	var rowsNum=0;
	var inserRowNum=0;
	if (ecsideObj.ECListBody.rows){
		rowsNum=ecsideObj.ECListBody.rows.length;
		inserRowNum=ecsideObj.ECListBody.rows.length;
		var row = ecsideObj.ECListBody.rows[rowsNum-1];
		if(!!row.id && row.id != ""){
			var lastRowId = row.id;	
			var lastRowNum = parseInt(lastRowId.substring(7));
			rowsNum = lastRowNum + 1;
		}
	}
	var newTr=ecsideObj.ECListBody.insertRow(inserRowNum);
//  yin.hl修改-end
	
	ECSideUtil_addEvent( newTr,"click", ECSideUtil.selectRow.bind(this,newTr,ecsideObj.id) );
	newTr.className="add";	
//	if(rowsNum>1)rowsNum = rowsNum+1;
	var rowid = "addRow_"+rowsNum;
	newTr.id = rowid;
	template=template.split("<tpsp />");
	var cells=[];
	for (var i=0;i<ecsideObj.columnNum;i++ ){		
		cells[i]=newTr.insertCell(i);
		cells[i].innerHTML=template[i];
	}
	var topTr=ECSideUtil.getPosTop(newTr);
	if (ecsideObj.ECListBodyZone){
		ecsideObj.ECListBodyZone.scrollTop=topTr;
	}
	var i=0;
	var temp;
	$jQuery("#"+rowid+" td").each(function(){
		i++;
		$jQuery(this).attr("id","addTd_"+rowsNum+'_'+i);
		temp = $jQuery(this).children().attr("id");
		if(temp==''){
			temp = $jQuery(this).children().attr("name");
			if(temp==''){
				temp = i;
			}
		}
		$jQuery(this).children().attr("id","addElement_"+rowsNum+'_'+temp);
	});	
	return newTr;	
};
//-----------------------------------------------------------------------------------------
/**
 * 功能：删除表格里的删除状态的行（不会进行后台保存，请谨慎使用）
 * @return ture 成功 false 失败
 * @param {} gridID
 */
ECSideUtil.removeDeleteRows=function(gridID){
    var ecsideObj = ECSideUtil.getGridObj(gridID);
	var rowsd=ECSideUtil.getDeletedRows(gridID);
	ecsideObj.forDeleteRows = rowsd;
	for (var i=0;i< rowsd.length;i++){
		ECSideUtil.getRemoveDeletedRows(ecsideObj.forDeleteRows, crow.getAttribute("recordKey"));
	}
	return true;
};

/**
 * 生成更新行的JSON数据格式,去掉空格:"updateRecords":[{}]
 * @param tableId
 */
ECSideUtil.getUPdateJSONWithOutNsp=function(tableId){
	var updateRows = "\"updateRecords\":[";
	var ecsideObj= ECSideUtil.getGridObj(tableId);
	var rowsi = ECSideUtil.getUpdatedRows(tableId);
	ecsideObj.forUpdateRows = rowsi;
	for (var i = 0; i < rowsi.length; i++){
		var pars = ECSideUtil.getRowCellsMap(ecsideObj.forUpdateRows[i], tableId);
		updateRows +="{"
		for(sKey in pars){
			if(pars[sKey]== "" || pars[sKey] == 'null' || pars[sKey] == undefined)
				pars[sKey] = "";
			updateRows += "\""+sKey+"\":\""+pars[sKey]+"\","
		}
		updateRows = updateRows.substring(0,updateRows.length -1);
		updateRows +="},"
	}
	if(updateRows.indexOf(",") > 0) updateRows = updateRows.substring(0,updateRows.length - 1);  //去掉","
	updateRows +="]";
	return updateRows;
};

/**
 * 生成所有行的JSON数据格式:"records":[{}]
 * @param tableId
 */
ECSideUtil.getAllRowsJSON=function(tableId){
	//得到增加行
	var allRows = "{\"records\":[";
	//获得表格对象
	var ecsideObj= ECSideUtil.getGridObj(tableId);
	
	if (ecsideObj && ecsideObj.ECListBody){
		//获得表格数据
		var rowsi = ecsideObj.ECListBody.rows;
	
		for (var i = 0; i < rowsi.length; i++){
			if (ECSideUtil.hasClass(rowsi[i],"hideListRow") ||
					ECSideUtil.hasClass(rowsi[i],"del"))
				continue;
			
			allRows +="{"
				
			var pars;
			//新建状态数据用prototype
			//if (ECSideUtil.hasClass(rowsi[i],"add"))
			//	pars = Form.serialize(rowsi[i], true);
			//else //表格控件取值使用prototype
				pars = ECSideUtil.getRowCellsMap(rowsi[i], tableId);
			
			ECSideUtil.getRowCellsMap(rowsi[i], tableId);
			for(sKey in pars){
				pars[sKey] = pars[sKey].replace(/\n|\r|\t/g,"");
				if(pars[sKey]== "" || pars[sKey] == 'null' || pars[sKey] == undefined)
					pars[sKey] = "";
				allRows += "\""+sKey+"\":\""+ECSideUtil.trimString(pars[sKey])+"\","
			}
			allRows = allRows.substring(0,allRows.length -1);
			allRows +="},"
		}
		if(allRows.indexOf(",") >0) allRows = allRows.substring(0,allRows.length -1);
		allRows +="]}";
		return allRows;
	}
};


/**
 * 注意：此方法只适合于PDM2Code生成的代码，取insert行
 * 生成插入行的JSON数据格式:"insertRecords":[{}]
 * @param tableId
 */
ECSideUtil.getInsertJSON_PDM2Code=function(tableId){
	//得到增加行
	var insertRows = "\"insertRecords\":[";
	//获得表格对象
	var ecsideObj= ECSideUtil.getGridObj(tableId);
	//获得表格数据
	var rowsi = ECSideUtil.getInsertRows(tableId);
	ecsideObj.forInsertRows = rowsi;
	for (var i = 0; i < rowsi.length; i++){
		insertRows +="{"
		var pars = ECSideUtil.getRowCellsMap(ecsideObj.forInsertRows[i], tableId);
		//var pars = Form.serialize(ecsideObj.forInsertRows[i], true);
		for(sKey in pars){
			if(pars[sKey]== "" || pars[sKey] == 'null' || pars[sKey] == undefined)
				pars[sKey] = "";
			insertRows += "\""+sKey+"\":\""+ECSideUtil.trimString(pars[sKey])+"\"," 
		}
		insertRows = insertRows.substring(0,insertRows.length -1);
		insertRows +="},"
	}
	if(insertRows.indexOf(",") >0) insertRows = insertRows.substring(0,insertRows.length -1);
	insertRows +="]";
	return insertRows;
};

/**
 * 生成更新行的JSON数据格式:"updateRecords":[{}]
 * 修改：2011-6-10 取值去空格
 * @param tableId
 */
ECSideUtil.getUPdateJSON_PDM2Code=function(tableId){
	var updateRows = "\"updateRecords\":[";
	var ecsideObj= ECSideUtil.getGridObj(tableId);
	var rowsi = ECSideUtil.getUpdatedRows(tableId);

	ecsideObj.forUpdateRows = rowsi;
	for (var i = 0; i < rowsi.length; i++){
		var pars = ECSideUtil.getRowCellsMap(ecsideObj.forUpdateRows[i], tableId);
		updateRows +="{"
		for(sKey in pars){
			if(pars[sKey]== "" || pars[sKey] == 'null' || pars[sKey] == undefined)
				pars[sKey] = "";
			updateRows += "\""+sKey+"\":\""+ECSideUtil.trimString(pars[sKey])+"\","
		}
		updateRows = updateRows.substring(0,updateRows.length -1);
		updateRows +="},"
	}
	if(updateRows.indexOf(",") > 0) updateRows = updateRows.substring(0,updateRows.length - 1);  //去掉","
	updateRows +="]";
	return updateRows;
};