TipAndAlert = require "tip_and_alert/tip_and_alert"
Store = require "extras/store"
class rest_manage
  _.extend @::, TipAndAlert
  me=null
  constructor: ->
    @initPage()
    @bindEvent()
    me=@

  ###
    绑定事件
  ###
  bindEvent:->
    #绑定修改上限数的方法
    pageDom.on("blur",".totalLimit", (e)->
      num=$(@).val()
      if !$.isNumeric num
        me.alert "body", "error", "请输入数字"
      else
        key=$(@).parents("tr").attr("sysId")
        $.ajax
          url:Store.context+"/restManage/setTotalNum"
          type:"post"
          data: key:key,value:num
          success:(data)->
            if !data.data
              me.alert "body", "error", "操作失败"
      
    )
    console.log pageDom

    #绑定重置当前可连接数的方法
    pageDom.on("click",".reset",(e)->
      $.ajax
        url:Store.context+"/restManage/restCurrentNum"
        type:"post"
        success:(data)->
          if !data.data
            me.alert "body", "error", "操作失败"  
    )
    

    #设置轮询定时器，用来刷新当前总链接数
    setInterval ->
      $.ajax
        url:Store.context+"/restManage/getLimitNum"
        type:"post"
        success:(data)->
          data=data.data
          me.intervalFun(data)
    ,5000
    
  intervalFun:(data)->
    ((item)->
            $("[sysId="+item.key+"]").children(":eq(1)").html(item.num)) (item) for item in data


  ###
    初始化页面
  ###
  initPage:->
    $.when($.post(Store.context+"/restManage/getTotalNum"),
          $.post(Store.context+"/restManage/getLimitNum"))
      .done(
        (total,limit)->
          console.log total,limit
          pageDom.append(restTemplates(total:total[0].data))
          me.intervalFun(limit[0].data)
      )
    



  pageDom=$(".restManageContent")

  restTemplates=App.templates["rest_manage_page"]

module.exports=rest_manage