/**
 * Created by 11150221050069 on 2016/12/28.
 */
$(function(){
    $('.box-left>ul li a').click(function(){
        $(this).addClass('on').siblings().removeClass('on');
    });
});