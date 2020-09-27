/**
 * Created by 11150321050124 on 2017/1/12.
 */

var province="";
var city="";
var arr_prov="";
var arr_city=new Array();

$(function () {
     province=document.getElementById("prov");
     city=document.getElementById("city");
     arr_prov=new Array(new Option("--请选择--",''),new Option("入库阶段","1"),new Option("生产阶段","2"),new Option("销售阶段","3"));
     arr_city=new Array();
    arr_city[0]=new Array(new Option("--请选择--",''));
    arr_city[1]=new Array(new Option("原料采购物流资质告警",'1'));
    arr_city[2]=new Array(new Option("库存不足告警",'1'),new Option("生产消耗过高告警",'2'));
    arr_city[3]=new Array(new Option("回款率过低告警",'1'));
    //动态载入所有省份
        for(var i=0;i<arr_prov.length;i++){
            province.options[i]=arr_prov[i];
        }


    var content;
    content=location.search.split('=')[1];
    var type;
    var kind;
    if(content=='content1'){
        type=1;
        kind=1;
    }else if(content=='content2'){
        type=2;
        kind=1;
    }else if(content=='content3'){
        type=2;
        kind=2;
    }else if(content=='content4'){
        type=3;
        kind=1;
    }
    var endtime = new Date();
    var emonth = endtime.getMonth()+1;
    endtime = endtime.getFullYear()+'-'+ emonth + '-'+endtime.getDate();
    var starttime = new Date();
    starttime.setTime(starttime.getTime() - 1000*60*60*24*6);
    var smonth = starttime.getMonth()+1;
    starttime = starttime.getFullYear()+'-'+ smonth+ '-'+starttime.getDate();
    post(type,kind,starttime,endtime);
})

//选中省份之后，根据索引动态载入相应城市
function changeCity(){

    city.options.length=0;
    //获取省一级的下拉列表选中的索引
    var index=province.selectedIndex;
    for(var i=0;i<arr_city[index].length;i++){
        city.options[i]=arr_city[index][i];
    }
}
function search(){
    var type = $("#prov").val();
    var kind = $("#city").val();
    var endtime = new Date();
    var emonth = endtime.getMonth()+1;
    endtime = endtime.getFullYear()+'-'+ emonth + '-'+endtime.getDate();
    var starttime = new Date();
    starttime.setTime(starttime.getTime() - 1000*60*60*24*6);
    var smonth = starttime.getMonth()+1;
    starttime = starttime.getFullYear()+'-'+ smonth+ '-'+starttime.getDate();
    post(type,kind,starttime,endtime);
}
function post(type,kind,starttime,endtime){
    $("#labelbody").children().remove();
    $.post("/a/index/api",{
        // ds:'dcapp',
        _id:'index1_table',
        type:type,
        kind:kind,
        starttime:starttime,
        endtime:endtime
    },function(res){
        console.log(res);
        if (res.length != 0) {
            $("#labelbody").show();
            $('#nonebody').hide();
            for (var i = 0; i < res.length; i++) {
                var html;
                html ='<tr><td width="200px">'+ res[i].OPERATION_TIME +'<td width="200px">'+ res[i].TYPE_NAME +'</td><td width="280px">'+ res[i].KIND_NAME +'</td><td width="800px" style="text-align: center;">'+ res[i].WARNING_CONTENT +'</td><td width="200px">'+res[i].DLEVEL +'</td></tr>';
                $("#labelbody").append(html);
            }
        } else {
            $("#labelbody").hide();
            $('#nonebody').show();
        }
    })
}