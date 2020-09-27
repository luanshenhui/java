var url = location.href
var param =url.split("type=")[1];
jQuery(document).ready(function(){
    manageRole(param);
});

function manageRole(param){
    if(param=="check"){
        splitRuleItemTable = $('#splitRuleItemTable').DataTable({
            "processing": true,
            "serverSide": true,
            "destroy":true,
            "autoWidth": false,
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
            "dom": '<"bottom"rtflp>',
            "searching": false,
            "pagingType": "full_numbers",
            "deferRender": true,
            "ajax": {
                "url": "/role/getRole.action?isAdminRole=false",
                "data": function ( d ) {
                    var quickItemSearch = "";
                    if (typeof($('#quickItemSearch').val())!='undefined'){
                        quickItemSearch = encodeURI($('#quickItemSearch').val());
                    } else {
                        quickItemSearch = encodeURI(window.top.window.$('#quickItemSearch').val());
                    }
                    d.quickSearch = quickItemSearch;
                }
            },
            "tableTools": {
                "sRowSelect": "bootstrap"
            },
            "columns": [
                {"data": "chk"}, 
                {"data": "roleName"}, 
                {"data": "roleDescription"}, 
                {"data": "isAdminrole"}
            ],
            "order": [[ 1, "asc" ]]
        });
    }else if(param=="radio"){
        splitRuleItemTable = $('#splitRuleItemTable').DataTable({
            "processing": true,
            "serverSide": true,
            "destroy":true,
            "autoWidth": false,
            "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
            "dom": '<"bottom"rtflp>',
            "searching": false,
            "pagingType": "full_numbers",
            "deferRender": true,
            "ajax": {
                "url": "/role/getRole.action?isAdminRole=true",
                "data": function ( d ) {
                    var quickItemSearch = "";
                    if (typeof($('#quickItemSearch').val())!='undefined'){
                        quickItemSearch = encodeURI($('#quickItemSearch').val());
                    } else {
                        quickItemSearch = encodeURI(window.top.window.$('#quickItemSearch').val());
                    }
                    d.quickSearch = quickItemSearch;
                }
            },
            "tableTools": {
                "sRowSelect": "bootstrap"
            },
            "columns": [
                {"data": "radio"}, 
                {"data": "roleName"}, 
                {"data": "roleDescription"}, 
                {"data": "isAdminrole"}
            ],
            "order": [[ 2, "asc" ]]
        });
    }
}

function saveRadio(){
    var returnObj = new Object();
    if($('#splitRuleItemTable input:radio[name="statusRadio"]:checked').length==0){
        returnObj.id = "";
        returnObj.roleName = "";
        return returnObj;
    }
    var id=$('#splitRuleItemTable input:radio[name="statusRadio"]:checked')[0].getAttribute('radioid');
    var roleName=$($('#splitRuleItemTable input:radio[name="statusRadio"]:checked').parent().next()).text();
    returnObj.id = id;
    returnObj.roleName = roleName;
    return returnObj;
}

function saveCheck(){
        var idString = "";
        var nameString = "";
        $("#splitRuleItemTable input[type='checkbox']:checked").each(function(k,v){
            var name=$(this).parent().next().text();
            if(idString==""){
                idString=this.getAttribute('roleid')
            }else if(idString!=""){
                idString+=","+this.getAttribute('roleid')
            }
            if(nameString==""){
                nameString=name;
            }else if(nameString!=""){
                nameString+=","+name;
            }
        });
//      if (idString == null || idString==undefined || idString=="" || idString == ","){
//          return;
//      }
        var returnObj = new Object();
        returnObj.id = idString;
        returnObj.roleName = nameString;
        return returnObj;
}