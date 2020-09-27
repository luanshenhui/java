var isMultiSelect = "false";
var needStation = "false";
var url = location.href
var param = url.split("check=")[1];
if (param == 'false') {
    isMultiSelect = "false";
    needStation = "false";
} else {
    isMultiSelect = "true";
    needStation = "true";
}
jQuery(document).ready(function(){
    initTree();
});
function initTree(){
    $("#orgTreeFrame").children().remove();
    $('body').bind('keydown',shieldCommon);
    //处理传入的参数
    //obj = window.dialogArguments;// 定义一个对象用于接收对话框参数
    isMultiSelect = (isMultiSelect && isMultiSelect != "" ? isMultiSelect : false); 
    needStation = (needStation && needStation != "" ? needStation : false);
    //处理树
    tree =new dhtmlXTreeObject("orgTreeFrame","100%","100%",0);
    tree.setImagePath("/csh_books/");
    if (isMultiSelect == "true"){
        tree.enableCheckBoxes(1);
        tree.enableThreeStateCheckboxes(false);
    }
    if(needStation){
        tree.setOnOpenEndHandler(checkSubNodes);  //解决节点请求回来无法展开
        tree.setOnMouseInHandler(beforeOpenNode);
        tree.setXMLAutoLoading("/unit/getSubUnitTree.action?needStation=true"); 
        tree.loadXML("/unit/getUnitTree.action?needStation=true");
    }else{
        tree.setOnOpenEndHandler(checkSubNodes);  //解决节点请求回来无法展开
        tree.setOnMouseInHandler(beforeOpenNode);
        tree.setXMLAutoLoading("/unit/getSubUnitTree.action"); 
        tree.loadXML("/unit/getUnitTree.action");
    }
    tree.openItem("RootUnit@UNIT");
    window.setTimeout(function() {
        //tree.closeAllItems(0);
    }, 0);
    getUnitTreeManageableInitTree();
}

function getUnitTreeManageableInitTree(){   
    jQuery.ajax({
        url:"/unit/getUnitTreeManageable.action",
        type:"post",
        async:false,
        dataType:"json",
        success:function(data){
            if(data.errorMessage==null || data.errorMessage==undefined){
                for(var i=0;i<data.length;i++){
                    if(data[i].MANAGEABLE != 1){
                        tree.showItemCheckbox(data[i].UNIT_ID,false); //隐藏复选框
                        tree.setItemColor(data[i].UNIT_ID,"#aaaaaa","#aaaaaa");//节点字体颜色置灰
                    }
                }
            } else {
                if (data.errorMessage == "session timeout")
                    window.location.href = "/login.jsp";
                else
                    alert(data.errorMessage);
            }
        }
    });
    
}


function unitSaveSelect(){
    if (isMultiSelect == "true") {
        needStation=true;
        var obj=getTreeUnitIds();
//      var div=window.top.window.borrowCustomModalDialog($("#queryUnitSelect"));
//      var div=window.top.window.borrowCustomModalDialog($("#FrameUnitSelect"));
//      div.modal('hide');
//      $('#userTable').DataTable().ajax.reload(null, false);
        $("#txtUserUnitsStations").val(obj.itemTexts);
        $("#txtUserUnitsStationsValue").val(obj.itemIds);
        return obj;
    }else{
        needStation=true;
        var o=getTreeUnitIds();
//      window.top.window.returnCustomModalDialog();
        $('#quickSearch').val(o.itemText);
        $('#quickSearchValue').val(o.itemId);
//      window.top.window.returnCustomModalDialog();
//      var div=window.top.window.borrowCustomModalDialog($("#FrameUnitSelect"));
//      div.modal('hide');
        return o;
    }
}

function getTreeUnitIds(){
    var returnObj = new Object();
    if (isMultiSelect == "true") {
        //获取所有选中的unit结点的id
        var itemIds = tree.getAllCheckedBranches();
        if (itemIds.length <= 0){
            returnObj.itemIds = "";
            returnObj.itemTexts = "";
            window.returnValue = returnObj;
            //window.close();
        }
        console.log(itemIds);
        //如果最后一个字符是“,”则把它去掉
        if(itemIds.substring(itemIds.length -1,itemIds.length) == ",")
            itemIds = itemIds.substring(0,itemIds.length-1);

        //把id字符串转成数组
        var itemIdArray = itemIds.split(",");
        var itemTexts = "";
        for (i=0;i<itemIdArray.length;i++)
        {
            if (itemIdArray[i] == "")
                break;
            itemTexts += tree.getItemText(itemIdArray[i]);
            if(i < itemIdArray.length-1)
                itemTexts += ",";
        }
        returnObj.itemIds = itemIds;
        returnObj.itemTexts = itemTexts;
    } else {
        var itemId = tree.getSelectedItemId();
        var itemText = tree.getItemText(itemId);
        var itemColor = tree.getItemColor(itemId);
        if(itemColor.acolor == "#aaaaaa"){
            returnObj.itemId = "";
            returnObj.itemText = "";
        }else{
            returnObj.itemId = itemId;
            returnObj.itemText = itemText;
        }
    }
    //如果非岗位模式，则认为所有的id都是unitId
    if (!needStation){
        //如果非多选模式
        if (!isMultiSelect){
            returnObj.itemId = returnObj.itemId.replaceAll("@UNIT","");
        } else {
            returnObj.itemIds = returnObj.itemIds.replaceAll("@UNIT","");
        }
    }
    
    //window.returnValue = returnObj;
    var returnValue = returnObj;
    return returnValue;
   // window.close();
}