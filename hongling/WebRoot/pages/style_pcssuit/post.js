jQuery.csPcsSuitPost={
		bindEvent:function(){
			$("#btnSave").click(function(){$.csPcsSuitPost.save();});
			$("#category").change(function(){$.csPcsSuitPost.changeCategory();});
			$("#btnf").click(function(){$.csPcsSuitPost.addFabric(0);});
			$("#btnfs").click(function(){$.csPcsSuitPost.addFabric(1);});
			$.csPcsSuitPost.fillStyleID();//款式风格
		},
		addAssemble:function(type){
			$.csCore.loadModal('../style_pcssuit/assemble_list.jsp', 1000, 500,
					function() {
						$.csPcssuitAssemble.init(type);
					});
		}
		,
		addFabric:function(type){// 添加面料：0默认 1推荐
			$.csCore.loadModal('../style_pcssuit/fabric_list.jsp', 800, 500,
					function() {
						$.csPcssuitFabric.init(type);
					});
		}
		,
		getKitStyleByID : function(id){
			var param= $.csControl.appendKeyValue("","id",id);
			var url = $.csCore.buildServicePath('/service/kitstyle/getkitstylebyid');
			var data = $.csCore.invoke(url,param);
			$("#ID").val(data.ID);
			$("#kitStyleNo").val(data.code);
			$("#defaultFabric").val(data.defaultFabric);
			$("#fabrics").val(data.fabrics);
			$("#titleCn").val(data.title_Cn);
			$("#titleEn").val(data.title_En);
			$("#category").val(data.clothingID);
			$("#styleIDs").val(data.styleID);
			var category_style = new Array();
			category_style = data.categoryID.split(",");
			var styleH ="<td class='label star' style='width:90px;'>上衣组合代码</td><td><input type='text' id='style_3' readonly='readonly' style='width:150px;'  class='textbox' value='"+category_style[0]+"'/><input type='button' id='btn3' value='...' onclick='$.csPcsSuitPost.addAssemble(3);' style='width:29px;'></td><td class='label star' style='width:90px;'>西裤组合代码</td><td><input type='text' id='style_2000' readonly='readonly' style='width:150px;'  class='textbox' value='"+category_style[1]+"'/><input type='button' id='btn2000' value='...' onclick='$.csPcsSuitPost.addAssemble(2000);' style='width:29px;'></td>";
			$("#category_style").html(styleH);
			if(category_style.length == 3){
				var styleHtm ="<td class='label star' style='width:90px;'>马夹组合代码</td><td><input type='text' id='style_4000' readonly='readonly' style='width:150px;'  class='textbox' value='"+category_style[2]+"'/><input type='button' id='btn4000' value='...' onclick='$.csPcsSuitPost.addAssemble(4000);' style='width:29px;'></td><td></td><td></td>";
				$("#category_style3").html(styleHtm);
			}
		},
		changeCategory : function(){
			if($("#category").val()==0){
				$("#category_style").html("");
				$("#category_style3").html("");
			}
			if($("#category").val() >0){
				var styleH ="<td class='label star' style='width:90px;'>上衣组合代码</td><td><input type='text' id='style_3' readonly='readonly' style='width:150px;'  class='textbox'/><input type='button' id='btn3' value='...' onclick='$.csPcsSuitPost.addAssemble(3);' style='width:29px;'></td><td class='label star' style='width:90px;'>西裤组合代码</td><td><input type='text' id='style_2000' readonly='readonly' style='width:150px;'  class='textbox'/><input type='button' id='btn2000' value='...' onclick='$.csPcsSuitPost.addAssemble(2000);' style='width:29px;'></td>";
				$("#category_style").html(styleH);
				$("#category_style3").html("");
				if($("#category").val() == 2){
					var styleHtm ="<td class='label star' style='width:90px;'>马夹组合代码</td><td><input type='text' id='style_4000' readonly='readonly' style='width:150px;'  class='textbox'/><input type='button' id='btn4000' value='...' onclick='$.csPcsSuitPost.addAssemble(4000);' style='width:29px;'></td><td></td><td></td>";
					$("#category_style3").html(styleHtm);
				}
				
			}
		},
		save:function(){
			if ($.csPcsSuitPost.validate()) {
				var param = $.csControl.getFormData('form');
				var data=$.csCore.invoke($.csCore.buildServicePath('/service/kitstyle/savekitstyle'),param);
				if(data=='OK'){
					$.csPcsSuitList.list(0);
					$.csCore.close();
				}
			}
		},
		validate:function(){
			if($.csValidator.checkNull("kitStyleNo","组合代码不能为空")){
				return false;
			}
			if($.csValidator.checkNull("category","服装分类不能为空")){
				return false;
			}
			if($.csValidator.checkNull("defaultFabric","默认面料不能为空")){
				return false;
			}
			if($.csValidator.checkNull("styleIDs","款式风格不能为空")){
				return false;
			}
			if($("#category").val() >0){
				if($.csValidator.checkNull("style_3","上衣代码不能为空")){
					return false;
				}
				if($.csValidator.checkNull("style_2000","西裤代码不能为空")){
					return false;
				}
				if($("#category").val()==3){
					if($.csValidator.checkNull("style_4000","马甲代码不能为空")){
						return false;
					}
				}
			}
			return true;
			
		},
		fillStyleID : function() {
			var param = $.csControl.appendKeyValue('', 'clothingID', '3');
			var styleIDs = $.csCore.invoke($.csCore.buildServicePath('/service/assemble/getStyleByClothingId'),param);
			$.csControl.fillOptions('styleIDs', styleIDs, "ID", "NAME", "--请选择--");
		},
		init:function(id){
			$.csPcsSuitPost.bindEvent();
			if(id == ""){
				$("#kitStyleTitle").html("新增套装组合");
			}else{
				$("#kitStyleTitle").html("编辑套装组合");
				$.csPcsSuitPost.getKitStyleByID(id);
			}
		}
};