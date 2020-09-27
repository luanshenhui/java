jQuery(document).ready(function(){
	console.log(testuser);
splitRuleItemTable = $('#splituserItemTable').DataTable({
	    	"processing": true,
	        "serverSide": true,
	        "destroy":true,
//	        "scrollY": '375px', //支持垂直滚动
	        "autoWidth": false,
	        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "dom": '<"bottom"rtflp>',
	        "searching": false,
	        "pagingType": "full_numbers",
	        "deferRender": true,
	        
	        "fnRowCallback":function(nRow,aData,iDisplayIndex, iDisplayIndexFull)
	        {
	        
	        	console.log(nRow);
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
//	        "columnDefs": [{
//	        	"orderable":false,
//	        	"targets":[0]
//        	},{
//	        	"orderable":false,
//	        	"targets":[1]
//        	},{
//	        	"orderable":false,
//	        	"targets":[2]
//        	},{
//	        	"orderable":false,
//	        	"targets":[3]
//        	}
//	        	],
	        "order": [[ 0, "asc" ]]
	  
	        
	    });
	
	
	});



function userSaveSelect(){
	var obj = new Object();
	var idString = "";
	var userString ="";
	$("#splituserItemTable tr input[type='checkbox']:checked").each(function(k,v){
		userString = userString + $(this).parent().parent().find("td").eq(2).text() + ",";
//		idString =idString+ $(this).parent().parent().find("td").eq(0).text();
		
		if(idString==""){
			if(this.getAttribute('userid')!=null)
			idString=this.getAttribute('userid');
			
//			roleString =  $(this).parent().next().next().text();
		}else if(idString!=""){
			if(this.getAttribute('userid')!=null)
			idString+=","+this.getAttribute('userid');
//			roleString +=","+ $(this).parent().next().next().text();
		}
//		
//		if(userString==""){
//			userString=$(this).parent().next().next().text();
//		}else if(userString!=""){
//			userString+=","+$(this).parent().next().next().text();
//		}
	});

//	if (idString == null || idString==undefined || idString=="" || idString == ","){
////		alert(SELECT_ROLE_TO_DELETE);
//		return;
//	}
	obj.txtRoleUsers = userString.substr(0,userString.length-1);
	obj.txtRoleUsersValue = idString;
   return obj;
	

}