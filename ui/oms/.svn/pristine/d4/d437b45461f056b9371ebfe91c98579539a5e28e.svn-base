var setSkin = function(_skin){
	$.cookie("skin",_skin);
	$('#cssfile').attr('href',ApolloDomain+'/Apollo/themes/'+_skin+'/easyui.css');
};
var resetSkin = function(){
	$('#cssfile').attr('href',ApolloDomain+'/Apollo/themes/'+$.cookie("skin")+'/easyui.css');
};
$(function(){
	var _skin = $.cookie("skin");
	if(_skin == null){
		_skin = 'blue';
		$.cookie("skin",_skin);
	}
	
	$.fn.skinSet = function(param){
		$(this).click(function(){
			if($('.change_skin').length==0){
				$('<div class="change_skin"/>').append('<ul>'+
				//'<li skin="default" class="acctive_ls"><a href="javascript:void(0)"><img alt="蓝色经典" src="Apollo/themes/change_skin/images/ls.png">  <p>DEFAULT</p></a></li>'+
				'<li skin="blue" class="acctive_ls"><a href="javascript:void(0)"><img alt="蓝色经典" src="Apollo/themes/change_skin/images/ls.png">  <p>蓝色经典</p></a></li>'+
				'<li skin="red"	 class="acctive_hs"><a href="javascript:void(0)"><img alt="中国红" src="Apollo/themes/change_skin/images/hs.png"><p>中国红</p></a></li>'+
				'<li skin="orange" class="acctive_fs"><a href="javascript:void(0)"><img alt="沙漠情怀" src="Apollo/themes/change_skin/images/fs.png"><p>沙漠情怀</p></a></li>'+
				'<li skin="pf_1" class="acctive_green"><a href="javascript:void(0)"><img alt="夕阳无限" src="Apollo/themes/change_skin/images/green.png"><p>夕阳无限</p></a></li>'+
				'<li skin="pf_5" class="acctive_kj"><a href="javascript:void(0)"><img alt="梦幻科技" src="Apollo/themes/change_skin/images/kj.png"><p>梦幻科技</p></a></li>'+
				'<li skin="pf_4" class="acctive_nj"><a href="javascript:void(0)"><img alt="蓝天白云" src="Apollo/themes/change_skin/images/nj.png"><p>蓝天白云</p></a></li>'+
				'<li skin="pf_2" class="acctive_sm"><a href="javascript:void(0)"><img alt="水墨情" src="Apollo/themes/change_skin/images/sm.png"/><p>水墨情</p></a></li>'+
				'<li skin="pf_3" class="acctive_xc"><a href="javascript:void(0)"><img alt="火红乡村" src="Apollo/themes/change_skin/images/xc.png"><p>火红乡村</p></a></li>'+
				'<li skin="pf_6" class="acctive_zs"><a href="javascript:void(0)"><img alt="紫色之恋" src="Apollo/themes/change_skin/images/zs.png"><p>紫色之恋</p></a></li>'+
				'<li skin="pf_7" class="acctive_mw"><a href="javascript:void(0)"><img alt="木纹" src="Apollo/themes/change_skin/images/mw.png"><p>木纹</p></a></li>'+
				'</ul>').appendTo("body").dialog({
					title:'精彩皮肤选择',
					width:420,
					height:248,
					closed:true
				});
				$('.change_skin').find('li').hover(function(){
					if(!$(this).hasClass('selected'))
						$(this).addClass('acctive_'+$(this).attr('skin'));
				},function(){
					if(!$(this).hasClass('selected'))
						$(this).removeClass();
				}).click(function(){
					var skin = $(this).attr('skin');
					$(this).parent().children('.selected').removeClass();
					$(this).addClass('selected acctive_'+skin);
					setSkin(skin);
					if(param!=null&&typeof param.onChange == 'function'){
						param.onChange(this,skin);
					}	
				});
				$('.change_skin').find('li[skin="'+_skin+'"]').addClass('selected acctive_'+_skin);
				
			}
			$('.change_skin').dialog('open');
		});
	};
	window.setTimeout(function(){
		$('#cssfile').attr('href',ApolloDomain+'/Apollo/themes/'+_skin+'/easyui.css');
	},500);
	
});

