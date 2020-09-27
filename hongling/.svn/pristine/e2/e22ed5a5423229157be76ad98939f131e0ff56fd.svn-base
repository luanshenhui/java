jQuery.csSizeSelect={
	getSelectCategory:function (){
		var sizeCategory = $.csCore.invoke($.csCore.buildServicePath('/service/size/getsizecategory'));
		var dom ="";
		for(var i=0;i<sizeCategory.length;i++){
			dom+="<li id='size_select_"+sizeCategory[i].ID+"'  onclick='$.csSizeSelect.select("+sizeCategory[i].ID+")' title='"+sizeCategory[i].name+"'>"+sizeCategory[i].name+"</li>";
		}
		$("#select_category").html(dom);
		if(sizeCategory.length == 1){
			$("#select_category").css("margin-left","350px");
		}else if(sizeCategory.length == 2){
			$("#select_category").css("margin-left","200px");
		}
	},
	select:function(id){
		$.cookie("size_category",id);
		$.csCore.close();
		$.csCore.loadModal('../size/post.htm',998,440,function(){$.csSizePost.init()});

	},
	init:function(){
		$.csCore.getValue("Size_Info",null,"#sizeSelect h1");
		$.csSizeSelect.getSelectCategory();
	}
};