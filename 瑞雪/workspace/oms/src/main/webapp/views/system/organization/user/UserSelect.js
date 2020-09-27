var thisURL =  document.URL;
var getval = thisURL.split('?')[1];
var flg =0;
if(getval != undefined){
    var mark = getval.substr(getval.length-1,getval.length);
    if(mark != "="){
        var showvallist = getval.split('=')[1];
        var valLength = thisURL.split(',').length;
        flg = 1;
    }
}
jQuery(document).ready(function(){
    splitRuleItemTable = $('#splituserItemTable').DataTable({
        "processing": true,
        "serverSide": true,
        "destroy":true,
//  "scrollY": '375px', //支持垂直滚动
        "autoWidth": false,
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        "dom": '<"bottom"rtflp>',
        "searching": false,
        "pagingType": "full_numbers",
        "deferRender": true,
        "fnDrawCallback": function (oSettings) {
            if(flg == "1"){
                for(var i =0 ; i<valLength;i++){
                    var showval = showvallist.split(',')[i];
                    var userchk= "input[name='chkItem'][userid='"+showval+"']";
                    $(userchk).attr("checked",true);
                }
            }
        },

        "ajax": {
            "url": "/user/userList.action",
            "data": function ( d ) {
                var quickItemSearch = "";
                if (typeof($('#quickItemSearch').val())!='undefined'){
                    quickItemSearch = encodeURI($('#quickItemSearch').val());
                } 
                d.quickSearch = '';
            }
        },
        "tableTools": {
            "sRowSelect": "bootstrap"
        },
        "columns": [
            {"data": "chk"}, 
            {"data": "userAccount"}, 
            {"data": "userFullname"}, 
            {"data": "userUnits"}
            ],
            "columnDefs": [{
                "orderable":false,
                "targets":[0]
            }
            ],
            "order": [[ 1, "asc" ],[ 2, "asc" ]]
    });
    
    $("#checkBoxAll").click(function(){
        if($(this).attr("checked")){
            $("input[name='chkItem']").attr("checked",$(this).attr("checked"));
        }else{
            $("input[name='chkItem']").removeAttr("checked");
        }
        
    });
});

function userSaveSelect(){
	var obj = new Object();
	var idString = "";
	var userString ="";
	$("#splituserItemTable tr input[type='checkbox']:checked").each(function(k,v){
	    debugger
	    if($(this).parent().parent().find("td").eq(2).text() != ""){
	        userString = userString + $(this).parent().parent().find("td").eq(2).text() + ",";
	    }
		if(idString==""){
			if(this.getAttribute('userid')!=null)
			idString=this.getAttribute('userid');
			
		}else if(idString!=""){
			if(this.getAttribute('userid')!=null)
			idString+=","+this.getAttribute('userid');
		}
	});
	obj.txtRoleUsers = userString.substr(0,userString.length-1);
	obj.txtRoleUsersValue = idString;
    return obj;
}