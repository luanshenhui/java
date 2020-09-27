/**
 * Created by 11150221050069 on 2016/12/28.
 */
$(function(){
    $('.tree-blue a span').click(function(){
        $('.tree-pop').fadeIn();
    });
    $('.pop-close').click(function(){
        $('.tree-pop').hide();
    });
    $('.box-left>ul li a').click(function(){
        $(this).addClass('on').siblings().removeClass('on');
    });

    //流程图切换
    $('.personal-title>ul li').click(function(){
        var index = $(this).index();
        $(this).addClass('on').siblings().removeClass('on');
        $('.form-left').eq(index).removeClass('display-none').siblings('.form-left').addClass('display-none');
    });
});
