var context = "/mmc";
// 图片上传
function _ajaxFileslide() {
    $.ajaxFileUpload({
        type: "post",
        url: context + '/api/images/upload/',//用于文件上传的服务器端请求地址
        secureuri: false,//一般设置为false
        fileElementId: 'file',//文件上传空间的id属性  <input type="file" id="file" name="file" />
        dataType: 'text',//返回值类型 一般设置为json
        success: function (data) {//成功返回之后调用的函数
            var mark_result2 = new Array();
            var mark_reg = /(<(\w+)\s?.*?>)([^<].*?[^>])(<\/\2>)/ig
            var mark_match = data.match(mark_reg)
            var mark_reg2 = />(.*?)</
            for (i = 0; i < mark_match.length; i++) {
                mark_reg2.test(mark_match[i])
                mark_result2.push(RegExp.$1)
            }
            var dataset = $.parseJSON("" + mark_result2 + "");
            var dataObj = dataset[0];
            //document.getElementById("mainImage").value = dataObj.url;
            $("#mainImage").val(dataObj.url);
            $("#msg_info").html("文件上传成功");
        },
        complete: function (XMLHttpRequest, textStatus) {//调用执行后调用的函数
        },
        error: function (data) {//调用出错执行的函数
            //$("#msg_info").html("文件上传失败");
            //请求出错处理
        }
    });
    return false;
};

// 上传轮播图
function _ajaxFilebanner() {
    $.ajaxFileUpload({
        type: "post",
        url: context + '/api/images/upload/',//用于文件上传的服务器端请求地址
        secureuri: false,//一般设置为false
        fileElementId: 'filebanner',//文件上传空间的id属性  <input type="file" id="file" name="file" />
        dataType: 'text',//返回值类型 一般设置为json
        success: function (data) {//成功返回之后调用的函数
            var mark_result2 = new Array();
            var mark_reg = /(<(\w+)\s?.*?>)([^<].*?[^>])(<\/\2>)/ig
            var mark_match = data.match(mark_reg)
            var mark_reg2 = />(.*?)</
            for (i = 0; i < mark_match.length; i++) {
                mark_reg2.test(mark_match[i])
                mark_result2.push(RegExp.$1)
            }
            var dataset = $.parseJSON("" + mark_result2 + "");
            var dataObj = dataset[0];
            //document.getElementById("mainImage").value = dataObj.url;
            $("#mainBannerImage").val(dataObj.url);
            $("#msg_infobanner").html("文件上传成功");
        },
        complete: function (XMLHttpRequest, textStatus) {//调用执行后调用的函数
        },
        error: function (data) {//调用出错执行的函数
            //$("#msg_info").html("文件上传失败");
            //请求出错处理
        }
    });
    return false;
};

//图片上传（商品管理）
function _ajaxItemImgUpload(){
    $.ajaxFileUpload({
        type: "post",
        url: context + '/api/images/upload/',//用于文件上传的服务器端请求地址
        secureuri: false,//一般设置为false
        fileElementId: 'fileimg',//文件上传空间的id属性  <input type="file" id="file" name="file" />
        dataType: 'text',//返回值类型 一般设置为json
        success: function (data) {//成功返回之后调用的函数
            var mark_result2 = new Array();
            var mark_reg = /(<(\w+)\s?.*?>)([^<].*?[^>])(<\/\2>)/ig;
            var mark_match = data.match(mark_reg)
            var mark_reg2 = />(.*?)</
            for (i = 0; i < mark_match.length; i++) {
                mark_reg2.test(mark_match[i]);
                mark_result2.push(RegExp.$1);
            }
            var dataset = $.parseJSON("" + mark_result2 + "");
            $(".upload-li").before("<li class='js-img-li'><a href='javascript:void(0)'><img class='img-width' src="+dataset[0].url+"></a><i class='icon-icons-product-del'style='display: none'></i></li>");
            $("#msg_info_id").html("文件上传成功");
            count = $(".js-img-li").length;
            if(count >=5){
                $(".js-upload-area").hide()
            }
        },
        complete: function (XMLHttpRequest, textStatus) {//调用执行后调用的函数
        },
        error: function (data) {//调用出错执行的函数
            errorMsg = '<pre style="word-wrap: break-word; white-space: pre-wrap;">请上传jpg.png.jpeg.格式的图片！</pre>';
            if(data.responseText == errorMsg || typeof(data.responseText) == undefined ||data.responseText==undefined){
                $("#msg_info_id").html("请上传jpg.png.jpeg.bmp格式的图片！");
            }else{
                $("#msg_info_id").html("上传的文件超过规定大小");
            }
        }
    });
    return false;
};


// 图片上传(品牌管理，品牌授权管理)
function _ajaxFileUpload() {
    $.ajaxFileUpload({
        type: "post",
        url: context + '/api/images/upload/',//用于文件上传的服务器端请求地址
        secureuri: false,//一般设置为false
        fileElementId: 'fileimg',//文件上传空间的id属性  <input type="file" id="file" name="file" />
        dataType: 'text',//返回值类型 一般设置为json
        success: function (data) {//成功返回之后调用的函数
            var mark_result2 = new Array();
            var mark_reg = /(<(\w+)\s?.*?>)([^<].*?[^>])(<\/\2>)/ig;
            var mark_match = data.match(mark_reg)
            var mark_reg2 = />(.*?)</
            for (i = 0; i < mark_match.length; i++) {
                mark_reg2.test(mark_match[i]);
                mark_result2.push(RegExp.$1);
            }
            var dataset = $.parseJSON("" + mark_result2 + "");
            $("#brandImage").val(dataset[0].url);
            $(".js-brand-img").attr("style","display: inline;");
            $(".brand-img-none").attr("style","display: none;");
            $(".js-brand-img").attr("src",dataset[0].url);
            $("#msg_info_id").html("文件上传成功");
        },
        complete: function (XMLHttpRequest, textStatus) {//调用执行后调用的函数
        },
        error: function (data) {//调用出错执行的函数
            errorMsg = '<pre style="word-wrap: break-word; white-space: pre-wrap;">请上传jpg.png.jpeg.bmp格式的图片！</pre>';
            if(data.responseText == errorMsg || typeof(data.responseText) == undefined ||data.responseText==undefined){
                $("#msg_info_id").html("请上传jpg.png.jpeg.bmp格式的图片！");
            }else{
                $("#msg_info_id").html("上传的文件超过规定大小");
            }
        }
    });
    return false;
};

function _ajaxFileUploadXp(aaa) {
    $("#" + aaa + "s").html("");
    $.ajaxFileUpload({
        type: "post",
        url: context + '/api/images/upload/',//用于文件上传的服务器端请求地址
        secureuri: false,//一般设置为false
        fileElementId: 'file',//文件上传空间的id属性  <input type="file" id="file" name="file" />
        dataType: 'JSON',//返回值类型 一般设置为json
        success: function (data) //服务器成功响应处理函数
        {
            var tempA = data.responseText
            //去除<pre>
            var start = tempA.indexOf(">");
            if (start != -1) {
                var end = tempA.indexOf("<", start + 1);
                if (end != -1) {
                    tempA = tempA.substring(start + 1, end);
                }
            }
            var dataset = $.parseJSON("" + tempA + "");
            $("#" + aaa + "s").html("成功上传");
            $("." + aaa + "").val(dataset[0].url);
            $("." + aaa + "").html(dataset[0].url)
            //var dataset = $.parseJSON("" + data + "");
            //alert(data.message);//从服务器返回的json中取出message中的数据,其中message为在struts2中action中定义的成员变量

            //if (typeof (data.error) != 'undefined') {
            //	if (data.error != '') {
            //		alert(data.error);
            //	} else {
            //		alert(data.message);
            //	}
            //}
        },
        error: function (data)//服务器响应失败处理函数
        {

            var tempA = data.responseText
            //去除<pre>
            var start = tempA.indexOf(">");
            if (start != -1) {
                var end = tempA.indexOf("<", start + 1);
                if (end != -1) {
                    tempA = tempA.substring(start + 1, end);
                }
            }
            var dataset = $.parseJSON("" + tempA + "");
            $("#" + aaa + "s").html("成功上传");
            $("." + aaa + "").val(dataset[0].url);
            $("." + aaa + "").html(dataset[0].url)

            //$("#msg_info").html("文件上传失败");
        }
    });
    return false;
};