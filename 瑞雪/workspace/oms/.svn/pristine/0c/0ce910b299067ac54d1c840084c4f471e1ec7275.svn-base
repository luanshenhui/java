var isMultiSelect = "false";
var needStation = "false";
$(function () {
    var url = location.href
    var param = url.split("check=")[1];
    if (param == 'false') {
        isMultiSelect = "false";
        needStation = "false";
    } else {
        isMultiSelect = "true";
        needStation = "true";
    }
    
    initTree();
});
function initTree() {
    $("#orgTreeFrame").children().remove();
    $('body').bind('keydown', shieldCommon);
    //处理传入的参数
    //obj = window.dialogArguments;// 定义一个对象用于接收对话框参数
    isMultiSelect = (isMultiSelect && isMultiSelect != "" ? isMultiSelect
            : false);
    needStation = (needStation && needStation != "" ? needStation : false);
    //处理树
    tree = new dhtmlXTreeObject("orgTreeFrame", "100%", "100%", 0);
    tree.setImagePath("/csh_books/");
    if (isMultiSelect == "true") {
        tree.enableCheckBoxes(1);
        tree.enableThreeStateCheckboxes(false);
    }
    if (needStation) {
        tree.setOnOpenEndHandler(checkSubNodes); //解决节点请求回来无法展开
        tree.setOnMouseInHandler(beforeOpenNode);
        tree.setXMLAutoLoading("/unit/getSubUnitTree.action?needStation=true");
        tree.loadXML("/unit/getUnitTree.action?needStation=true");
    } else {
        tree.setOnOpenEndHandler(checkSubNodes); //解决节点请求回来无法展开
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

function getUnitTreeManageableInitTree() {
    jQuery.ajax({
        url : "/unit/getUnitTreeManageable.action",
        type : "post",
        async : false,
        dataType : "json",
        success : function(data) {
            if (data.errorMessage == null || data.errorMessage == undefined) {
                for (var i = 0; i < data.length; i++) {
                    if (data[i].MANAGEABLE != 1) {
                        tree.showItemCheckbox(data[i].UNIT_ID, false); //隐藏复选框
                        tree
                                .setItemColor(data[i].UNIT_ID, "#aaaaaa",
                                        "#aaaaaa");//节点字体颜色置灰
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

function unitSaveSelect() {
    if (isMultiSelect == "true") {
        needStation = true;
        var obj = getTreeUnitIds();
        $("#txtUserUnitsStations").val(obj.itemTexts);
        $("#txtUserUnitsStationsValue").val(obj.itemIds);
        return obj;
    } else {
        needStation = true;
        var o = getTreeUnitIds();
        $('#quickSearch').val(o.itemText);
        $('#quickSearchValue').val(o.itemId);
        return o;
    }
}
function aaa(isMultiSelect, needStation) {
    isMultiSelect = isMultiSelect;
    needStation = needStation;
    return "33"
}

function getTreeUnitIds() {
    var returnObj = new Object();
    if (isMultiSelect == "true") {
        //获取所有选中的unit结点的id
        var itemIds = tree.getAllCheckedBranches();
        if (itemIds.length <= 0) {
            returnObj.itemIds = "";
            returnObj.itemTexts = "";
            window.returnValue = returnObj;
            //window.close();
        }
        console.log(itemIds);
        //如果最后一个字符是“,”则把它去掉
        if (itemIds.substring(itemIds.length - 1, itemIds.length) == ",")
            itemIds = itemIds.substring(0, itemIds.length - 1);

        //把id字符串转成数组
        var itemIdArray = itemIds.split(",");
        var itemTexts = "";
        for (i = 0; i < itemIdArray.length; i++) {
            if (itemIdArray[i] == "")
                break;
            itemTexts += tree.getItemText(itemIdArray[i]);
            if (i < itemIdArray.length - 1)
                itemTexts += ",";
        }
        returnObj.itemIds = itemIds;
        returnObj.itemTexts = itemTexts;
    } else {
        var itemId = tree.getSelectedItemId();
        var itemText = tree.getItemText(itemId);
        var itemColor = tree.getItemColor(itemId);
        if (itemColor.acolor == "#aaaaaa") {
            returnObj.itemId = "";
            returnObj.itemText = "";
        } else {
            returnObj.itemId = itemId;
            returnObj.itemText = itemText;
        }
    }
    //如果非岗位模式，则认为所有的id都是unitId
    if (!needStation) {
        //如果非多选模式
        if (!isMultiSelect) {
            returnObj.itemId = returnObj.itemId.replaceAll("@UNIT", "");
        } else {
            returnObj.itemIds = returnObj.itemIds.replaceAll("@UNIT", "");
        }
    }

    //window.returnValue = returnObj;
    var returnValue = returnObj;
    return returnValue;
    // window.close();
}

var nodeClickArray = new ArrayList(); //节点点击数组
var beforeOpenSubNodes;
function checkSubNodes(id, state) {
    //记录点击过的节点，第一次单击则请求数据，然后记录；当再次点击后则不再请求数据。
    if (nodeClickArray.contains(id))
        return true;
    else {
        nodeClickArray.add(id);
        //2011年4月12日 wangxy
        //如果父结点是灰的，则需要对子结点的使用状态进行判断
        //如果父结点不是灰的，则所有子结点是可用状态。
        var itemColor = tree.getItemColor(id);
        //通过节点颜色判断是否有操作权限
        if (itemColor.acolor == "#aaaaaa") {
            getSubUnitTreeManageable(id);
        }
        //over
    }
    if (beforeOpenSubNodes > 0)
        return true;
    if (beforeOpenSubNodes == 0 && state == -1) {
        tree.openItem(id);
    }
    beforeOpenSubNodes = 1;
    return true;
}

function beforeOpenNode(id) {
    beforeOpenSubNodes = tree.hasChildren(id);
    return true;
}

/**
 * 树结点点击事件处理
 * @return
 */
function nodeCheckHandler(id, state) {
    //state：1是选中，0是未选中
    if (state == "1" || state == 1) {
        if (delList.contains(id))
            delList.remove(id);
        else if (!addList.contains(id))
            addList.add(id);
    } else {
        if (addList.contains(id))
            addList.remove(id);
        else if (!delList.contains(id))
            delList.add(id);
    }
}

/**
 * 根据类型获取权限，并且给权限树打挑
 * @return
 */
function requestPrivilegeAndDrawTree(id, type) {
    var sURL1 = "/privilege/getPageElementPrivilege.action";
    $.ajax({
        url : sURL1,
        type : "post",
        dataType : "json",
        data : {
            type : type,
            id : id,
            isAdminRole : "false"
        },
        success : function(data) {
            if (data.errorMessage == undefined) {
                //根据资源授权情况，在树上选中结点
                for ( var k in data.authMap) {
                    tree.setCheck(k, 1);
                }
                //tree.enableThreeStateCheckboxes(true);
            } else {
                if (data.errorMessage == "session timeout")
                    window.location.href = "/login.jsp";
                else
                    alert(data.errorMessage);
            }
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
            alert("操作失败，可能是网络原因");
            // 通常 textStatus 和 errorThrown 之中 
            // 只有一个会包含信息 
            //this;  调用本次AJAX请求时传递的options参数
        }
    });
}
