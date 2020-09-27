$(function () {
	$("#breadcrumbL2").hide();
    //BEGIN MENU SIDEBAR
    //$('#sidebar').css('min-height', "100%");
    $('#side-menu').metisMenu();
    $(window).on("load resize", function () {
        if ($(this).width() < 768) {
            $('body').removeClass();
            $('div.sidebar-collapse').addClass('collapse');
        } else {
            $('body').addClass($.cookie('menu_style') + ' ' + $.cookie('header'));
            $('div.sidebar-collapse').removeClass('collapse');
            $('div.sidebar-collapse').css('height', 'auto');
        }

        // ============== MIS系统，一屏显示即可，不要再下翻页了。===============
        //面包屑高度
        breadcrumbHeight = $("#title-breadcrumb-option-demo").height();
        //页脚高度
        footerHeight = $("#footer").height();
        //页头高度
        headerHeight = $(".topbar-main").height();
        $("#contentFrame").css('height',$(document.body).height() - (headerHeight + footerHeight + breadcrumbHeight + 19));
        $("#contentFrame").css('max-height',$(document.body).height() - (headerHeight + footerHeight + breadcrumbHeight + 19));

        $("#sidebar").css('height',$(document.body).height() - (headerHeight + footerHeight + breadcrumbHeight + 19));
        $("#sidebar").css('max-height',$(document.body).height() - (headerHeight + footerHeight + breadcrumbHeight + 19));

//        if($('#sidebar').height() > $('#page-wrapper').height()){
//            $('#wrapper').css('height', $('#sidebar').height());
//        }
        // ====================================================================
    });

    $('#news-ticker-close').click(function(e){
        $('.news-ticker').remove();
        $('.quick-sidebar').css('top', '50px');
    });
    //END NEWS TICKER TOPBAR

    //BEGIN TOPBAR DROPDOWN
    $('.dropdown-slimscroll').slimScroll({
        "height": '250px',
        "wheelStep": 30
    });
    //END TOPBAR DROPDOWN

    //BEGIN CHECKBOX & RADIO
    if($('#demo-checkbox-radio').length <= 0){
        $('input[type="checkbox"]:not(".switch")').iCheck({
            checkboxClass: 'icheckbox_minimal-grey',
            increaseArea: '20%' // optional
        });
        $('input[type="radio"]:not(".switch")').iCheck({
            radioClass: 'iradio_minimal-grey',
            increaseArea: '20%' // optional
        });
    }
    //END CHECKBOX & RADIO

    //BEGIN TOOTLIP
    $("[data-toggle='tooltip'], [data-hover='tooltip']").tooltip();
    //END TOOLTIP

    //BEGIN POPOVER
    $("[data-toggle='popover'], [data-hover='popover']").popover();
    //END POPOVER

    //BEGIN THEME SETTING
    $('#theme-setting > a.btn-theme-setting').click(function(){
        if($('#theme-setting').css('right') < '0'){
            $('#theme-setting').css('right', '0');
        } else {
            $('#theme-setting').css('right', '-250px');
        }
    });

    // Begin Change Theme Color
    var list_menu = $('.dropdown-theme-setting > li > select#list-menu');
    var list_style = $('.dropdown-theme-setting > li > select#list-style');
    var list_header = $('.dropdown-theme-setting > li > select#list-header');
    var list_color = $('.dropdown-theme-setting > li > ul#list-color > li');

    // FUNCTION CHANGE URL STYLE ON HEAD TAG
    var setTheme = function (menu_style, style, header, color) {
        $.cookie('menu_style', menu_style);
        $.cookie('style',style);
        $.cookie('header', header);
        $.cookie('color',color);

        $('body').removeClass();
        $('body').addClass(menu_style + ' ' + header);
        // Set slimscroll when sidebar fixed
        if ($.cookie('header') == 'header-fixed') {
            if ($('body').hasClass('sidebar-collapsed')) {
                $('#side-menu').attr('style','').parent('.slimScrollDiv').replaceWith($('#side-menu'));
            } else {
                setTimeout(function(){
                    $('#side-menu').slimScroll({
                        "height": $(window).height() - 100,
                        'width': '250px',
                        'wheelStep': 30
                    });
                    $('#side-menu').focus();
                }, 500)
            }
        } else {
            $('#side-menu').attr('style','').parent('.slimScrollDiv').replaceWith($('#side-menu'));
        }
        
        $('#theme-change').attr('href', 'css/themes/'+ style + '/' + color + '.css');
    }
    // INITIALIZE THEME FROM COOKIE
    // --NOTES: HAVE TO SET VALUE FOR STYLE & COLOR BEFORE AND AFTER ACTIVE THEME
    // Check cookie when window reload and set value for each option(menu,style,color)
    if ($.cookie('style')) {
        // FIX SIDEBAR IN HORIZONTAL AND RIGHT
        if ($('body').hasClass('clear-cookie')) {
            $.removeCookie('menu_style');
        } else {
            list_menu.find('option').each(function(){
                if($(this).attr('value') == $.cookie('menu_style')) {
                    $(this).attr('selected', 'selected');
                }
            });
            
            list_style.find('option').each(function(){
                if($(this).attr('value') == $.cookie('style')) {
                    $(this).attr('selected', 'selected');
                }
            });

            list_header.find('option').each(function(){
                if($(this).attr('value') == $.cookie('header')) {
                    $(this).attr('selected', 'selected');
                }
            });

            list_color.removeClass("active");
            list_color.each(function(){
                if($(this).attr('data-color') == $.cookie('color')){
                    $(this).addClass('active');
                }
            });
            setTheme($.cookie('menu_style'), $.cookie('style'),$.cookie('header'), $.cookie('color'));
        }
    };

    // SELECT MENU STYLE EVENT
    list_menu.on('change', function(){
        list_color.each(function() {
            if($(this).hasClass('active')){
                color_active  = $(this).attr('data-color');
            }
        });
        // No Menu style 3 fixed
        if (($.cookie('header') == 'header-fixed') && ($(this).val() == 'sidebar-icons')) {
            setTheme($(this).val(), list_style.val(), 'header-static', color_active);
            return;
        }
        setTheme($(this).val(), list_style.val(), list_header.val(), color_active);
    });
    // SELECT STYLE EVENT
    list_style.on('change', function() {
        list_color.each(function() {
            if($(this).hasClass('active')){
                color_active  = $(this).attr('data-color');
            }
        });
        setTheme(list_menu.val(), $(this).val(), list_header.val(), color_active);
    });

    // SELECT HEADER EVENT
    list_header.on('change', function() {
        list_color.each(function() {
            if($(this).hasClass('active')){
                color_active  = $(this).attr('data-color');
            }
        });
        // No Menu style 3 fixed
        if (($.cookie('menu_style') == 'sidebar-icons') && ($(this).val() == 'header-fixed')) {
            return;
        }
        setTheme(list_menu.val(), list_style.val(), $(this).val(), color_active);
    });
    // LI CLICK EVENT
    list_color.on('click', function() {
        list_color.removeClass('active');
        $(this).addClass('active');
        setTheme(list_menu.val(), list_style.val(), list_header.val(), $(this).attr('data-color'));
    });
    // End Change Theme Color
    //END THEME SETTING

    //BEGIN FULL SCREEN
    $('.btn-fullscreen').click(function() {

        if (!document.fullscreenElement &&    // alternative standard method
            !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement ) {  // current working methods
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen();
            } else if (document.documentElement.msRequestFullscreen) {
                document.documentElement.msRequestFullscreen();
            } else if (document.documentElement.mozRequestFullScreen) {
                document.documentElement.mozRequestFullScreen();
            } else if (document.documentElement.webkitRequestFullscreen) {
                document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
            }
        } else {
            if (document.exitFullscreen) {
                document.exitFullscreen();
            } else if (document.msExitFullscreen) {
                document.msExitFullscreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.webkitExitFullscreen) {
                document.webkitExitFullscreen();
            }
        }
    });
    //END FULL SCREEN

    // BEGIN FORM CHAT
    $('.btn-chat').click(function () {
        if($('#chat-box').is(':visible')){
            $('#chat-form').toggle('slide', {
                direction: 'right'
            }, 500);
            $('#chat-form').slimScroll();
            $('#chat-box').hide();
        } else{
            $('#chat-form').toggle('slide', {
                direction: 'right'
            }, 500);
            $('#chat-form > .chat-inner').slimScroll({
                "height": $(window).height(),
                'width': '280px',
                "wheelStep": 30
            });
        }
    });
    $('.chat-box-close').click(function(){
        $('#chat-box').hide();
        $('#chat-form .chat-group a').removeClass('active');
    });
    $('.chat-form-close').click(function(){
        $('#chat-form').toggle('slide', {
            direction: 'right'
        }, 500);
        $('#chat-box').hide();
    });

    $('#chat-form .chat-group a').unbind('*').click(function(){
        $('#chat-box').hide();
        $('#chat-form .chat-group a').removeClass('active');
        $(this).addClass('active');
        var strUserName = $('> small', this).text();
        $('.display-name', '#chat-box').html(strUserName);
        var userStatus = $(this).find('span.user-status').attr('class');
        $('#chat-box > .chat-box-header > span.user-status').removeClass().addClass(userStatus);
        var chatBoxStatus = $('span.user-status', '#chat-box');
        var chatBoxStatusShow = $('#chat-box > .chat-box-header > small');
        if(chatBoxStatus.hasClass('is-online')){
            chatBoxStatusShow.html('Online');
        } else if(chatBoxStatus.hasClass('is-offline')){
            chatBoxStatusShow.html('Offline');
        } else if(chatBoxStatus.hasClass('is-busy')){
            chatBoxStatusShow.html('Busy');
        } else if(chatBoxStatus.hasClass('is-idle')){
            chatBoxStatusShow.html('Idle');
        }

        var offset = $(this).offset();
        var h_main = $('#chat-form').height();
        var h_title = $("#chat-box > .chat-box-header").height();
        var top = ($('#chat-box').is(':visible') ? (offset.top - h_title - 40) : (offset.top + h_title - 20));

        if((top + $('#chat-box').height()) > h_main){
            top = h_main - 	$('#chat-box').height();
        }

        $('#chat-box').css({'top': top});

        if(!$('#chat-box').is(':visible')){
            $('#chat-box').toggle('slide',{
                direction: 'right'
            }, 500);
        }
        // FOCUS INPUT TEXT WHEN CLICK
        $("#chat-box .chat-textarea input").focus();
        $('.chat-content > .chat-box-body').slimScroll({
            "height": "250px",
            'width': '340px',
            "wheelStep": 30,
            "scrollTo": $(this).height() 
        });
    });
    // Add content to form
    $('.chat-textarea input').on("keypress", function(e){
        var $obj = $(this);
        var $me = $obj.parent().parent().find('ul.chat-box-body');
        var $my_avt = 'https://s3.amazonaws.com/uifaces/faces/twitter/kolage/128.jpg';
        var $your_avt = 'https://s3.amazonaws.com/uifaces/faces/twitter/alagoon/48.jpg';
        if (e.which == 13) {
            var $content = $obj.val();

            if ($content !== "") {
                var d = new Date();
                var h = d.getHours();
                var m = d.getMinutes();
                if (m < 10) m = "0" + m;
                $obj.val(""); // CLEAR TEXT ON TEXTAREA

                var $element = ""; 
                $element += "<li>";
                $element += "<p>";
                $element += "<img class='avt' src='"+$my_avt+"'>";
                $element += "<span class='user'>John Doe</span>";
                $element += "<span class='time'>" + h + ":" + m + "</span>";
                $element += "</p>";
                $element = $element + "<p>" + $content +  "</p>";
                $element += "</li>";
                
                $me.append($element);
                var height = 0;
                $me.find('li').each(function(i, value){
                    height += parseInt($(this).height());
                });

                height += '';
                $me.scrollTop(height);  

                // RANDOM RESPOND CHAT
                var $res = "";
                $res += "<li class='odd'>";
                $res += "<p>";
                $res += "<img class='avt' src='"+$your_avt+"'>";
                $res += "<span class='user'>Swlabs</span>";
                $res += "<span class='time'>" + h + ":" + m + "</span>";
                $res += "</p>";
                $res = $res + "<p>" + "Yep! It's so funny :)" + "</p>";
                $res += "</li>";
                setTimeout(function(){
                    $me.append($res);
                    $me.scrollTop(height+100);        
                }, 1000);
            }
        }
    });
    //END FORM CHAT

    //BEGIN PORTLET
    $(".portlet").each(function(index, element) {
        var me = $(this);
        $(">.portlet-header>.tools>i", me).click(function(e){
            if($(this).hasClass('fa-chevron-up')){
                $(">.portlet-body", me).slideUp('fast');
                $(this).removeClass('fa-chevron-up').addClass('fa-chevron-down');
            }
            else if($(this).hasClass('fa-chevron-down')){
                $(">.portlet-body", me).slideDown('fast');
                $(this).removeClass('fa-chevron-down').addClass('fa-chevron-up');
            }
            else if($(this).hasClass('fa-cog')){
                //Show modal
            }
            else if($(this).hasClass('fa-refresh')){
                //$(">.portlet-body", me).hide();
                $(">.portlet-body", me).addClass('wait');

                setTimeout(function(){
                    //$(">.portlet-body>div", me).show();
                    $(">.portlet-body", me).removeClass('wait');
                }, 1000);
            }
            else if($(this).hasClass('fa-times')){
                me.remove();
            }
        });
    });
    //END PORTLET

    //BEGIN BACK TO TOP
    $(window).scroll(function(){
        if ($(this).scrollTop() < 200) {
            $('#totop') .fadeOut();
        } else {
            $('#totop') .fadeIn();
        }
    });
    $('#totop').on('click', function(){
        $('html, body').animate({scrollTop:0}, 'fast');
        return false;
    });
    //END BACK TO TOP

    //BEGIN CHECKBOX TABLE
    $('.checkall').on('ifChecked ifUnchecked', function(event) {
        if (event.type == 'ifChecked') {
            $(this).closest('table').find('input[type=checkbox]').iCheck('check');
        } else {
            $(this).closest('table').find('input[type=checkbox]').iCheck('uncheck');
        }
    });
        //ONLY FOR USER_PROFILE PAGE
    $('.checkall-email').on('ifChecked ifUnchecked', function(event) {
        if (event.type == 'ifChecked') {
            $(this).closest('.tab-pane').find('input[type=checkbox]').iCheck('check');
        } else {
            $(this).closest('.tab-pane').find('input[type=checkbox]').iCheck('uncheck');
        }
    });
    //END CHECKBOX TABLE

    $('.option-demo').hover(function() {
        $(this).append("<div class='demo-layout animated fadeInUp'><i class='fa fa-magic mrs'></i>Demo</div>");
    }, function() {
        $('.demo-layout').remove();
    });
      $('#header-topbar-page .demo-layout').live('click', function() {
        var HtmlOption = $(this).parent().detach();
        $('#header-topbar-option-demo').html(HtmlOption).addClass('animated flash').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
            $(this).removeClass('animated flash');
        });
        $('#header-topbar-option-demo').find('.demo-layout').remove();
        return false;
    });
    $('#title-breadcrumb-page .demo-layout').live('click', function() {
        var HtmlOption = $(this).parent().html();
        $('#title-breadcrumb-option-demo').html(HtmlOption).addClass('animated flash').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
            $(this).removeClass('animated flash');
        });
        $('#title-breadcrumb-option-demo').find('.demo-layout').remove();
        return false;
    });
    // CALL FUNCTION RESPONSIVE TABS
    fakewaffle.responsiveTabs(['xs', 'sm']);

    // BEGIN SEARCH FORM ON TOPBAR
    $('#topbar-search').on('click', function (e) {
        $(this).addClass('open');
        $(this).find('.form-control').focus();

        $('#topbar-search .form-control').on('blur', function (e) {
            $(this).closest('#topbar-search').removeClass('open');
            $(this).unbind('blur');
        });
    });
    // END SEARCH FORM ON TOPBAR

//    // BEGIN DATERANGE PICKER ON BREADCRUMB
//    $('.reportrange').daterangepicker(
//        {
//            ranges: {
//                'Today': [moment(), moment()],
//                'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
//                'Last 7 Days': [moment().subtract('days', 6), moment()],
//                'Last 30 Days': [moment().subtract('days', 29), moment()],
//                'This Month': [moment().startOf('month'), moment().endOf('month')],
//                'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
//            },
//            startDate: moment().subtract('days', 29),
//            endDate: moment(),
//            opens: 'left',
//        },
//        function(start, end) {
//            $('.reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
//            $('input[name="datestart"]').val(start.format("YYYY-MM-DD"));
//            $('input[name="endstart"]').val(end.format("YYYY-MM-DD"));
//        }
//    );
//    $('.reportrange span').html(moment().subtract('days', 29).format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
//    //END PLUGINS DATE RANGE PICKER
    
    // ===================== 自定义函数 =====================
    //退出系统
    $("#logOut").click(function(){
// 	  window.location.href="/sysUser/loginOut.action";
 	  window.location.href="/login/loginOut.action";
    })
});

//左侧菜单点击
function menuItemSelected(menuItem) {
	$("#side-menu").find("li").removeClass("active");
	$(menuItem).parent().parent().parent().addClass("active");
	$(menuItem).parent().addClass("active");
	// TODO 面包屑待完善
	$("#breadcrumbL2").show();
	var menuItemName = $(menuItem).find("span").text();
	menuItemName = menuItemName.replace(/(^\s*)|(\s*$)/g, "");
	if (menuItemName != undefined && menuItemName != null && menuItemName != "") {
		$(".page-title").text(menuItemName);
		$(".breadcrumb > .active").html(menuItemName);
		// TODO 页面跳转待完善，根据菜单设置跳转，这里先写死了
		var url = "";
		switch (menuItemName) {
        case "用户管理":
        	url = 'login/userList.action';
        	break;
        case "柱状图":
        	url = 'login/oracleDraw.action';
        	break;
        case "波动图":
        	url = 'login/streetDraw.action';
        	break;
        case "角色列表":
        	url = 'login/roleList.action';
        	break;
        case "省区域":
        	url = 'login/province.action';
        	break;	
        case "上传图片":
        	url = 'login/imgInfo.action';
        	break;
		default:

		}
		$('#contentFrame').attr('src', url);
	}
}


// 自定义函数
function changePageContent() {
	$('#contentFrame').attr('src', "/login/updateManager.action");
	
}

// 共用，提示对话框
function showModalAlert(content){
	$('#modalAlertTitle').text(content);
	$('#modal-alert').modal('show');
}
// 共用，确认对话框
function showModalConfirm(content, callback) {
	$("#modalConfirmContent").text(content);
	$('#btnModalOK').unbind();
	$("#btnModalOK").on('click', callback);
	$('#modal-confirm').modal({show:true, backdrop:'static'});
}
// 共用，显示sco.message提示
function showScoMessage(strType, content){
	if (strType == 'ok' || strType == 'OK') {
		$.scojs_message(content, $.scojs_message.TYPE_OK);
	} else if (strType == 'error' || strType == 'ERROR') {
		$.scojs_message(content, $.scojs_message.TYPE_ERROR);
	}
}

// ===================>> 自定义对话框处理块.start <<===================
var parentEle;   // 父元素
var editDialog;  // 自定义对话框

// 借用iframe中的自定义模态对话框
function borrowCustomModalDialog(customModal) {
	parentEle = customModal.parent();
	editDialog = customModal;
	$("#customModalDialog").empty();
	editDialog.appendTo($("#customModalDialog"));
	// 给index页面添加一个遮罩层，因为iframe页面中的遮罩层不会自动加到index页面
	$(document.body).append("<div id=\"myModalBackdrop\" class=\"modal-backdrop in\"></div>");
	
	//处理时间控件
	$('.datetimepicker-default').datetimepicker();
	
    // 初始化MultiSelect控件
    $('#public-methods').multiSelect();
    $('#select-all').click(function(){
        $('#public-methods').multiSelect('select_all');
    });
    $('#deselect-all').click(function(){
        $('#public-methods').multiSelect('deselect_all');
    });
	return editDialog;
}

// 归还自定义模态对话框
function returnCustomModalDialog(){
	// 去掉自动加的遮罩层
	$("#myModalBackdrop").remove();
	editDialog.appendTo(parentEle);
}
//===================>> 自定义对话框处理块.over <<===================
function dateTimeTest(){
	$('.datetimepicker-default').datetimepicker();
}