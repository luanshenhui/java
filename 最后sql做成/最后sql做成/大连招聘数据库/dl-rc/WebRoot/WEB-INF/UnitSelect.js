var isMultiSelect = "false";
var needStation = "false";
$(function () {
//    var url = location.href
//    var param = url.split("check=")[1];
//    if (param == 'false') {
//        isMultiSelect = "false";
//        needStation = "false";
//    } else {
//        isMultiSelect = "true";
//        needStation = "true";
//    }
    
    initTree();
});
function initTree() {
    $("#orgTreeFrame").children().remove();
    $('body').bind('keydown', shieldCommon);
    //澶勭悊浼犲叆鐨勫弬鏁�
    //obj = window.dialogArguments;// 瀹氫箟涓�釜瀵硅薄鐢ㄤ簬鎺ユ敹瀵硅瘽妗嗗弬鏁�
    isMultiSelect = (isMultiSelect && isMultiSelect != "" ? isMultiSelect
            : false);
    needStation = (needStation && needStation != "" ? needStation : false);
    //澶勭悊鏍�
    tree = new dhtmlXTreeObject("orgTreeFrame", "100%", "100%", 0);
    tree.setImagePath("/csh_books/");
    if (isMultiSelect == "true") {
        tree.enableCheckBoxes(1);
        tree.enableThreeStateCheckboxes(false);
    }
    if (needStation) {
        tree.setOnOpenEndHandler(checkSubNodes); //瑙ｅ喅鑺傜偣璇锋眰鍥炴潵鏃犳硶灞曞紑
        tree.setOnMouseInHandler(beforeOpenNode);
        tree.setXMLAutoLoading("/unit/getSubUnitTree.action?needStation=true");
        tree.loadXML("/unit/getUnitTree.action?needStation=true");
    } else {
        tree.setOnOpenEndHandler(checkSubNodes); //瑙ｅ喅鑺傜偣璇锋眰鍥炴潵鏃犳硶灞曞紑
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
                        tree.showItemCheckbox(data[i].UNIT_ID, false); //闅愯棌澶嶉�妗�
                        tree
                                .setItemColor(data[i].UNIT_ID, "#aaaaaa",
                                        "#aaaaaa");//鑺傜偣瀛椾綋棰滆壊缃伆
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
        //鑾峰彇鎵�湁閫変腑鐨剈nit缁撶偣鐨刬d
        var itemIds = tree.getAllCheckedBranches();
        if (itemIds.length <= 0) {
            returnObj.itemIds = "";
            returnObj.itemTexts = "";
            window.returnValue = returnObj;
            //window.close();
        }
        console.log(itemIds);
        //濡傛灉鏈�悗涓�釜瀛楃鏄�,鈥濆垯鎶婂畠鍘绘帀
        if (itemIds.substring(itemIds.length - 1, itemIds.length) == ",")
            itemIds = itemIds.substring(0, itemIds.length - 1);

        //鎶奿d瀛楃涓茶浆鎴愭暟缁�
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
    //濡傛灉闈炲矖浣嶆ā寮忥紝鍒欒涓烘墍鏈夌殑id閮芥槸unitId
    if (!needStation) {
        //濡傛灉闈炲閫夋ā寮�
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

var nodeClickArray = new ArrayList(); //鑺傜偣鐐瑰嚮鏁扮粍
var beforeOpenSubNodes;
function checkSubNodes(id, state) {
    //璁板綍鐐瑰嚮杩囩殑鑺傜偣锛岀涓�鍗曞嚮鍒欒姹傛暟鎹紝鐒跺悗璁板綍锛涘綋鍐嶆鐐瑰嚮鍚庡垯涓嶅啀璇锋眰鏁版嵁銆�
    if (nodeClickArray.contains(id))
        return true;
    else {
        nodeClickArray.add(id);
        //2011骞�鏈�2鏃�wangxy
        //濡傛灉鐖剁粨鐐规槸鐏扮殑锛屽垯闇�瀵瑰瓙缁撶偣鐨勪娇鐢ㄧ姸鎬佽繘琛屽垽鏂�
        //濡傛灉鐖剁粨鐐逛笉鏄伆鐨勶紝鍒欐墍鏈夊瓙缁撶偣鏄彲鐢ㄧ姸鎬併�
        var itemColor = tree.getItemColor(id);
        //閫氳繃鑺傜偣棰滆壊鍒ゆ柇鏄惁鏈夋搷浣滄潈闄�
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
 * 鏍戠粨鐐圭偣鍑讳簨浠跺鐞�
 * @return
 */
function nodeCheckHandler(id, state) {
    //state锛�鏄�涓紝0鏄湭閫変腑
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
 * 鏍规嵁绫诲瀷鑾峰彇鏉冮檺锛屽苟涓旂粰鏉冮檺鏍戞墦鎸�
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
                //鏍规嵁璧勬簮鎺堟潈鎯呭喌锛屽湪鏍戜笂閫変腑缁撶偣
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
            alert("鎿嶄綔澶辫触锛屽彲鑳芥槸缃戠粶鍘熷洜");
            // 閫氬父 textStatus 鍜�errorThrown 涔嬩腑 
            // 鍙湁涓�釜浼氬寘鍚俊鎭�
            //this;  璋冪敤鏈AJAX璇锋眰鏃朵紶閫掔殑options鍙傛暟
        }
    });
}
