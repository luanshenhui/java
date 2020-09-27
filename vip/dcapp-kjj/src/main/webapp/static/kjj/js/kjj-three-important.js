/**
 * Created by 11150221050069 on 2016/12/28.
 */
$(function(){
    //树状图气泡
    $('.form-left .flow-tree li>a>span').click(function(){
        $('.tree-pop').fadeIn();
    });
    $('.pop-close').click(function(){
        $('.tree-pop').hide();
    });

});
