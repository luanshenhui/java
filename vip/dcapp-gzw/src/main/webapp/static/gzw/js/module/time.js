/**
 * Created by 11150321050124 on 2017/1/15.
 */
$(function(){
    //获取当前日期
    var sysDate = new Date(); //实例一个时间对象；
    var time = "截至"+sysDate.getFullYear()+"年"+(sysDate.getMonth()+1)+"月"+sysDate.getDate()+"日"+sysDate.getHours()+"时";
   $('.footer').html(time);
});
