/**
 * Created by 11150221050069 on 2016/12/28.
 */
$(function(){
    $('.financial-tree>ul li').click(function(){
        $(this).addClass('on').siblings().removeClass('on');
    });
});