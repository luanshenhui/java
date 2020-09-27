String.prototype.endWith = function (s) {
    if (s == null || s == "" || this.length == 0 || s.length > this.length) {
        return false;
    }
    if (this.substring(this.length - s.length) == s) {
        return true;
    }
    else {
        return false;
    }
    return true;
};

String.prototype.startWith = function (s) {
    if (s == null || s == "" || this.length == 0 || s.length > this.length) {
        return false;
    }
    if (this.substr(0, s.length) == s) {
        return true;
    }
    else {
        return false;
    }
    return true;
};

String.prototype.toValidJson = function () {
    var v = this;
    if (v != undefined && v != null && v != "") {
        //v = v.toString().replace(new RegExp('(["\"])', 'g'), "\\\"");
        //v = v.replace(/[\r\n]/g, "");
        //v = v.replace("\n", "");
        //v = v.replaceAll("'", "&#39;");
        //v = v.replaceAll('\\\\', '\\\\');
        v = escape(v);
    }
    return v;
};

String.prototype.replaceAll = function (reallyDo, replaceWith, ignoreCase) {
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi" : "g")), replaceWith);
    } else {
        return this.replace(reallyDo, replaceWith);
    }
};

/*
* 检测数组中是否包含与指定值相同的单元
* 成功则返回值相同的第一个位置，没有相同的则返回false
*/
Array.prototype.contain = function (_val) {
    if (this.length <= 0) return false;
    for (var i = 0; i < this.length; i++) {
        if (this[i] == _val) return i;
    }
    return false;
};

// 清空数组
Array.prototype.clear = function () {
    this.splice(0, this.length);
};
jQuery.csCore = {
    PAGE_INDEX_KEY: "pageindex",
    PAGE_SIZE_KEY: "pagesize",
    loadPath: function (id) {
        var dict = $.csCore.getDictByID(id);
        if ($.csValidator.isNull($("#path").html())) {
            $("#path").html(dict.name);
        } else {
            $("#path").html(dict.name + ">>" + $("#path").html());
        }

        if (dict.parentID != "0") {
            $.csCore.loadPath(dict.parentID);
        }
    },
    getMemberByID: function (id) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/member/getmemberbyid'), $.csControl.appendKeyValue("", "id", id));
    },
    getCashByMemberByID: function (pubmemberid) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/member/getcashbymemberid'), $.csControl.appendKeyValue("", "pubmemberid", pubmemberid));
    },
    getDiscountByID: function (id) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/bldiscount/GetDiscountByID'), $.csControl.appendKeyValue("", "ID", id));
    },
    isInRole: function (id) {
        return $.csCore.invoke($.csCore.buildServicePath('/service/groupmenu/isinrole'), $.csControl.appendKeyValue("", "id", id));
    },
    isJSON: function (obj) {
        var isjson = typeof (obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]";
        return isjson;
    },
    addValueLine: function (viewID) {
        this.getViewElements(viewID).addClass('value');
    },
    buildServicePath: function (servicePath) {
        return SERVICE_ROOT + servicePath;
    },
    isAdmin: function () {
        return this.invoke(this.buildServicePath('/service/core/isadmin'));
    },
    signOut: function () {
        $.csCore.confirm($.csCore.getValue('Common_ExitConfirm'), "$.csCore.signOutRemote()");
    },
    signOutRemote: function () {
    	$.cookie("fashiontype", "");
        var data = this.invoke(this.buildServicePath('/service/member/signout'));
        if (!$.csValidator.isNull(data)) {
            if (data.toUpperCase() == "OK") {
                document.location.href = "../common/login.htm";
            }
        }
    },
    getVersions: function () {
        return this.invoke(this.buildServicePath('/service/dict/getversions'));
    },
    getCurrentVersion:function(){
    	return this.invoke(this.buildServicePath('/service/core/getcurrentversion'));
    },
    contain: function (a, b) {
        a = "," + a + ",";
        b = "," + b + ",";
        if (a.indexOf(b) > -1) {
            return true;
        }
        return false;
    },
    getImageHeight: function (url) {
        var theimage = new image();
        theimage.src = url;
        return theimage.height;
    },
    setPageTitle: function (page, title) {
        page.title = title;
    },
    getDictResourceName: function (dictID) {
        return "Dict_" + dictID;
    },
    pickUser: function (controlID, controlText, isMultiple, groupID) {
        $.csCore.loadModal('../member/pick.htm', 600, 370, function () { $.csMemberPick.init(controlID, controlText, isMultiple, groupID); });
    },
    autoCompleteUsername: function (input, isMultiple) {
        if (isMultiple == "undefined" || isMultiple == null || isMultiple == "") {
            isMultiple = false;
        }
        var url = $.csCore.buildServicePath('/service/member/getmemberbykeyword');
        $("#" + input).autocomplete(url, {
            multiple: isMultiple,
            dataType: "json",
            parse: function (data) {
                return $.map(data, function (row) {
                    return {
                        data: row,
                        value: row.ID,
                        result: row.username
                    };
                });
            },
            formatItem: function (item) {
                return item.username + "(" + item.name + ")";
            }
        }).result(function (e, data) {

        });
    },
    postData: function (url, form) {
        flag = false;
        var formData = $.csControl.getFormData(form);
        //alert(JSON.stringify(formData));
        var data = this.invoke(url, formData);
        if (!$.csValidator.isNull(data)) {
            if (data.toUpperCase() == "OK") {
                flag = true;
                $('#' + form).resetForm();
            }
            else {
                $.csCore.alert(data);
            }
        }else{
        	$.csCore.alert(data);
        }
        return flag;
    },
    getData: function (url) {
        url = encodeURI(url);
        var d = "";
        $.ajax({
            url: url,
            async: false,
            cache: false,
            success: function (data, textStatus, jqXHR) {
                d = data;
            },
            error: function (jqXHR, textStatus, errorThrown) {
                d = "error:" + jqXHR.responseText;
            }
        });
        if (IS_NET == true) {
            d = JSON.stringify(d);
            d = escape(d);
            d = JSON.parse(d);
        } else {
            try {
                d = JSON.parse(d);
            }
            catch (e) { }
        }
        return d;
    },
    invoke: function (url, formData,nameid) {
        var d = "";
        if ($.csValidator.isNull(formData)) {
            formData = "{}";
        }
        if ($.csValidator.isNull(nameid)) {
        	 if (IS_NET == true) {
                 var param = '{"formData":"' + formData + '"}';
                 $.ajax({
                     url: url,
                     data: param,
                     type: 'post',
                     dataType: 'json',
                     async: false,
                     contentType: "application/json;charset=utf-8;",
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                     },
                     error: function (xhr) {
                         d = xhr;
                     }
                 });

             } else {
                 $.ajax({
                     url: url,
                     data: { formData: formData },
                     type: "post",
                     dataType: "json",
                     async: false,
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                     },
                     error: function (xhr) {
                         d = xhr.responseText;
                     }
                 });
             }
        	 if (IS_NET == true) {
                 d = JSON.stringify(d);
                 d = $.csCore.utf8ToGb2312(d);
                 var from = d.indexOf(":") + 1;
                 d = d.substring(from, d.length - 1);
                 if (d.substring(0, 1) == "\"") {
                     d = d.substring(1, d.length - 1);
                 } else {
                     try {
                         d = JSON.parse(d);
                     }
                     catch (e) { }
                     return d;
                 }
             } else {
                 try {

                     d = JSON.parse(d);
                 }
                 catch (e) { }
             }
             return d;
        }else{
        	 if (IS_NET == true) {
                 var param = '{"formData":"' + formData + '"}';
                 $.ajax({
                     url: url,
                     data: param,
                     type: 'post',
                     dataType: 'json',
                     contentType: "application/json;charset=utf-8;",
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                       $(nameid).html(d);
                     },
                     error: function (xhr) {
                         d = xhr;
                     }
                 });

             } else {
                 $.ajax({
                     url: url,
                     data: { formData: formData },
                     type: "post",
                     dataType: "json",
                     success: function (data, textStatus, jqXHR) {
                         d = data;
                         $(nameid).html(d);
                     },
                     error: function (xhr) {
                         d = xhr.responseText;
                     }
                 });
             }
        }
    },
    getDicts: function (categoryID) {
        var datas = this.invoke(this.buildServicePath('/service/dict/getdicts'), $.csControl.appendKeyValue("", "categoryid", categoryID));
        return datas;
    },
    getDictsByParent: function (categoryID, parentID) {
        var param = $.csControl.appendKeyValue("", "categoryid", categoryID);
        param = $.csControl.appendKeyValue(param, "parentid", parentID);
        var datas = this.invoke(this.buildServicePath('/service/dict/getdictsbyparent'), param);
        return datas;
    },
    getAllDicts: function (parentID) {
        var datas = this.invoke(this.buildServicePath('/service/dict/getalldicts'), $.csControl.appendKeyValue("", "parentid", parentID));
        return datas;
    },
    getNextDicts: function (parentID) {
        var datas = this.invoke(this.buildServicePath('/service/dict/getnextdicts'), $.csControl.appendKeyValue("", "parentid", parentID));
        return datas;
    },
    getDictByID: function (dictID) {
        var dict = this.invoke(this.buildServicePath('/service/dict/getdictbyid'), $.csControl.appendKeyValue("", "id", dictID));
        return dict;
    },
    getValue: function (name1, name2,nameid) {
        if ($.csValidator.isNull(name1)) {
            alert("param is required");
            return false;
        }
        var param = "";
        param = $.csControl.appendKeyValue(param, "name1", name1);
        if (!$.csValidator.isNull(name2)) {
            param = $.csControl.appendKeyValue(param, "name2", name2);
        }
        return this.invoke(this.buildServicePath('/service/core/getvalue'), param,nameid);
    },
    getCurrentMember: function () {
        return this.invoke(this.buildServicePath('/service/member/getcurrentmember'));
    },
    getBlDealItems: function () {
    	param = $.csControl.appendKeyValue("", "from", "BlAddDeal.js");
        var datas = this.invoke(this.buildServicePath('/service/blcash/GetDealItems'), param);
        return datas;
    },
    getBlDealItemByID: function (ID) {
        var dealItem = this.invoke(this.buildServicePath('/service/blcash/GetDealItemByID'), $.csControl.appendKeyValue("", "ID", ID));
        return dealItem;
    },
    removeData: function (url, removedIDs) {
        if (removedIDs == null || removedIDs == "") {
            this.alert($.csCore.getValue('Common_PleaseSelect', 'Common_ForRemoved'));
            return false;
        }
        this.confirm($.csCore.getValue('Common_RemoveConfirm'), "$.csCore.removeRemote('" + url + "','" + removedIDs + "')");
    },
    removeRemote: function (url, removedIDs) {
        var param = $.csControl.appendKeyValue("", "removedIDs", removedIDs);
        var data = $.csCore.invoke(url, param);
        if (data != null) {
            if (data == "OK") {
                removedIDs = removedIDs.split(',');
                for (var i = 0; i <= removedIDs.length - 1; i++) {
                    $('#row' + removedIDs[i]).remove();
                }
            }
            else {
                $.csCore.alert(data);
            }
        }
    },
    initPagination: function (divPagination, nCount, nPageSize, getPagingData) {
        var prev_text = $.csCore.getValue('Common_Prev');
        var next_text = $.csCore.getValue('Common_Next');
        var total = $.csCore.getValue("Common_Total");
        var item_unit = $.csCore.getValue("Common_ItemUnit");
        var item_per_page = $.csCore.getValue("Common_ItemPerPage");

        $("#" + divPagination).pagination(nCount, {
            callback: getPagingData,
            items_per_page: nPageSize,
            prev_text: prev_text,
            next_text: next_text
        });
        $('#' + divPagination.replaceAll("Pagination", "") + 'Statistic').html(total + nCount + item_unit + "," + nPageSize + item_per_page);

    },
    processList: function (moduler, data) {
        $('#' + moduler + 'Result').setTemplateElement(moduler + 'Template', null, { filter_data: false });
        if (data.data != null) {
            $('#' + moduler + 'Result').processTemplate(data);
        }
        else {
            $('#' + moduler + 'Result').processTemplate({ data: data });
        }
        var result = $('#' + moduler + 'Result').html().replaceAll("null", "", true).replaceAll("00:00:00.0", "", true);
        $('#' + moduler + 'Result').html(result);
    },
    changeVersion: function (versionID) {
        var datas = this.invoke(this.buildServicePath('/service/core/changeversion'), $.csControl.appendKeyValue("", "versionid", versionID));
        //data = JSON.parse(datas);
        if (datas == "OK") {
            window.location.reload();//页面刷新
        }
    },
    pressEnterToNext: function () {
        $('input:text:first').focus();
        var $inp = $('input');
        $inp.bind('keydown', function (e) {
            var key = e.which;
            if (key == 13) {
                e.preventDefault();
                var nxtIdx = $inp.index(this) + 1;
                $(":input:eq(" + nxtIdx + ")").focus();
            }
        });
    },
    pressEnterToSubmit: function (pressedId, buttonId) {
        $("#" + pressedId).keydown(
			function (e) {
			    if (e.keyCode == 13) {
			        $('#' + buttonId).trigger('click');
			    }
			}
		);
    },
    getViewElements: function (viewID) {
        return $("#" + viewID).find("[id^='_view_']");
    },
    resetView: function (viewID) {
        var elements = this.getViewElements(viewID);
        for (var i = 0; i < elements.length; i++) {
            elements.eq(i).html("");
        }
    },
    viewWithJSON: function (viewID, jsonObject) {
        var elements = this.getViewElements(viewID);
        $.each(jsonObject, function (fieldName, fieldValue) {
            if ($.inArray($("#_view_" + fieldName)[0], elements) >= 0) {

                if (!$.csValidator.isNull(fieldValue)) {
                    try {
                        if (fieldValue.toLowerCase().substring(0, 6) == "/date(") {
                            fieldValue = $.csDate.formatMillisecondDate(fieldValue);
                        }
                    } catch (err) { }

                    $("#_view_" + fieldName).html(unescape(fieldValue));
                }
            }
        });
    },
    loadModal: function (src, width, height, initEvent) {
        if (width <= 0 || height <= 0 || width == undefined || height == undefined) {
            width = 750;
            height = 415;
        }
        if (src.endWith(".htm") || src.endWith(".html")) {
            if ($.csValidator.isNull(initEvent)) {
                $.weeboxs.open(src, { contentType: 'ajax', width: width, height: height, showButton: false });
            } else {
                $.weeboxs.open(src, { contentType: 'ajax', onopen: initEvent, width: width, height: height, showButton: false });
            }

        } else {
            $.weeboxs.open("#" + src, { width: width, height: height, showButton: false });
        }
    },
    loadPage: function (container, url, initEvent) {
        if ($.csValidator.isNull(url)) {
            return false;
        }
        $('#' + container).html('');
        if ($.csValidator.isNull(initEvent)) {
            $('#' + container).load(url);
        } else {
            $('#' + container).load(url, initEvent);
        }
    },
    changeCaptcha: function (imgId) {
        $("#" + imgId).attr("src", this.buildServicePath('/service/core/getcaptcha?' + (new Date()).getTime()));
    },
    login: function (divId) {
        if ($.csValidator.checkNull('username', $.csCore.getValue('Common_Required', 'Member_Username'))) {
            return false;
        }
        if ($.csValidator.checkNull('password', $.csCore.getValue('Common_Required', 'Member_Password'))) {
            return false;
        }
        if (!IS_NET) {
            if ($.csValidator.checkNull('captcha', $.csCore.getValue('Common_Required', 'Common_Captcha'))) {
                return false;
            }
        }
        if (this.postData(this.buildServicePath('/service/member/login'), divId)) {
            document.location.href = this.getMyPlatform();
        }
    },
    utf8ToGb2312: function (str1) {
        str1 = unescape(str1.replace(/\\u/g, '%u').replace(/;/g, ''));
        return str1;

    },
    getMyPlatform: function () {
        var datas = this.invoke(this.buildServicePath('/service/member/getmyplatform'), '');
        return datas;
    },
    alert: function (msg) {
        hint = $.csCore.getValue("Common_Prompt");
        $.weeboxs.open(msg, { boxid:'msgAlert',title: hint, type: 'alert', okBtnName: $.csCore.getValue("Button_OK") });
    },
    confirm: function (msg, okEvent) {
        $.weeboxs.open(msg, {
            title: $.csCore.getValue("Common_Prompt"),
            okBtnName: $.csCore.getValue("Button_OK"),
            cancelBtnName: $.csCore.getValue("Button_Cancel"),
            type: 'dialog',
            onok: function () {
                eval(okEvent);
                $.csCore.close();
            },
            oncancel: function () {
                $.csCore.close();
            }
        });
    },
    close: function () {
        $.weeboxs.close();
    },
    loadEditor: function (textareaId) {
        //自定义插件
        var uploadUrl = $.csCore.buildServicePath('/service/file/uploadimages');
        if (IS_NET) {
            uploadUrl = "../../scripts/jquery/xheditor/upload.ashx";
        }
        var uploadPlugin = {
            uploadFile: { c: 'upload_image', t: 'Upload Image (Ctrl+2)', h: 1, e: function () {
                var _this = this;
                var jDom = $('<div><input type="text" id="xheImgUrl" class="xheText" /><input type="button" id="xheSave" /></div>');
                var jUrl = $('#xheImgUrl', jDom);
                var jSave = $('#xheSave', jDom);
                _this.uploadInit(jUrl, uploadUrl, 'jpg,gif,png,bmp');
                jSave.click(function () {
                    _this.loadBookmark();
                    _this.pasteHTML("<img src='" + jUrl.val() + "'/>");
                    _this.hidePanel();
                    return false;
                });
                _this.saveBookmark();
                _this.showDialog(jDom);

                //alert($("#xheCancel").parent().parent().parent().html());
                $("#xheCancel").hide();
                $("#xheSave").hide();
                $(".xheUpload").css("width", "200px");
                $("#xheImgUrl").hide();
            }
            }
        };
        //初始化xhEditor编辑器插
        $('#' + textareaId).xheditor({
            plugins: uploadPlugin,
            tools: 'uploadFile,|,Link,Unlink,|,SelectAll,Removeformat,Align,|,Fontface,FontSize,Bold,Italic,Underline,FontColor,BackColor,|,Source,Fullscreen',
            skin: 'default',
            upMultiple: false,
            html5Upload: false
        });
    },
    loadUpload: function (dataID,types) {
    	if($.csValidator.isNull(types)){
    		types = "*.*";
    	}
        var buttonID = "button" + dataID;
        var progressID = "progress" + dataID;

        var dom = "<span id='" + buttonID + "'></span><div class='fieldset flash' id='" + progressID + "'></div>";
        $("#" + dataID).parent().append(dom);

        var attachmentIDs = $("#" + dataID).val();
        if (!$.csValidator.isNull(attachmentIDs)) {
            var attachments = this.getAttachmentByIDs(attachmentIDs);
            $.each(attachments, function (i, attachment) {
                var file = new Object();
                file.index = i;
                file.name = attachment.fileName;
                file.size = attachment.fileLength;
                file.id = "upload_" + dataID + i;
                file.filestatus = -4;
                loadSuccessFile(file, progressID, attachment.ID, attachment.fileNameInDisk, dataID);
            });
        };
        url = "/service/file/uploadfile?dataid=" + dataID;
        if (IS_NET) {
            url = "../../scripts/jquery/swfupload/upload.ashx?dataid=" + dataID;
        }

        var upload = new SWFUpload({
            upload_url: this.buildServicePath(url),
            file_size_limit: "500 MB",
            file_types: types,
            file_types_description: "All Files",
            file_upload_limit: 10,
            file_queue_limit: 0,
            swfupload_preload_handler: preLoad,
            swfupload_load_failed_handler: loadFailed,
            file_dialog_start_handler: fileDialogStart,
            file_queued_handler: fileQueued,
            file_queue_error_handler: fileQueueError,
            file_dialog_complete_handler: fileDialogComplete,
            upload_start_handler: uploadStart,
            upload_progress_handler: uploadProgress,
            upload_error_handler: uploadError,
            upload_success_handler: uploadSuccess,
            upload_complete_handler: uploadComplete,
            button_image_url: "../../scripts/jquery/swfupload/images/button_upload_cn.png",
            button_placeholder_id: buttonID,
            button_width: 61,
            button_height: 22,
            flash_url: "../../scripts/jquery/swfupload/swfupload.swf",
            flash9_url: "../../scripts/jquery/swfupload/swfupload_fp9.swf",
            custom_settings: { progressTarget: progressID },
            debug: false
        });
    },
    getAttachmentByIDs: function (IDs) {
        var datas = this.invoke(this.buildServicePath('/service/file/getattachmentbyids'), $.csControl.appendKeyValue("", "IDs", IDs));
        return datas;
    },
    getRandom: function () {
        Math.round(Math.random() * 10000);
    },
    playVideo: function (width, height, file) {
        var aid = this.getRandom();
        var video = "";
        video += "<object width='" + width + "' height='" + height + "' id='p" + aid + "' classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'>";
        video += " <param name='movie' value='player.swf' />";
        video += " <param name='quality' value='high' />";
        video += " <param name='menu' value='false' />";
        video += " <param name='allowFullScreen' value='true' />";
        video += " <param name='scale' value='noscale' />";
        video += " <param name='allowScriptAccess' value='always' />";
        video += " <param name='swLiveConnect' value='true' />";
        video += " <param name='flashVars' value=' &video=" + file + "&autoplay=1'/>";
        video += " <!-- [if !IE] -->";
        video += " <object width='" + width + "' height='" + height + "' data='player.swf' type='application/x-shockwave-flash' id='p" + aid + "'>";
        video += " <param name='quality' value='high' />";
        video += " <param name='menu' value='false' />";
        video += " <param name='allowFullScreen' value='true' />";
        video += " <param name='scale' value='noscale' />";
        video += " <param name='allowScriptAccess' value='always' />";
        video += " <param name='swLiveConnect' value='true' />";
        video += " <param name='flashVars' value=' &video=" + file + "&autoplay=1'/>";
        video += " </object>";
        video += " <!-- [endif] -->";
        video += "</object>";
        return video;
    },
    playImg: function (width, height, file) {
        return "<img style='margin-top:4px;width:" + width + "px;height:" + height + "px;' src='" + file + "'/>";
    },
    zoomImg: function (maxWidth, maxHeight) {
        $('img').each(function () {
            var ratio = 0;  // 缩放比例  
            var width = $(this).width();    // 图片实际宽度   
            var height = $(this).height();  // 图片实际高度     // 检查图片是否超宽   
            if (width > maxWidth) {
                ratio = maxWidth / width;   // 计算缩放比例       
                $(this).css("width", maxWidth); // 设定实际显示宽度       
                height = height * ratio;    // 计算等比例缩放后的高度       
                $(this).css("height", height);  // 设定等比例缩放后的高度   
            }     // 检查图片是否超高  
            if (height > maxHeight) {
                ratio = maxHeight / height; // 计算缩放比例      
                $(this).css("height", maxHeight);   // 设定实际显示高度       
                width = width * ratio;    // 计算等比例缩放后的高度       
                $(this).css("width", width);    // 设定等比例缩放后的高度   
            }
        });
    }
};

jQuery.csDate = {
    formatUTCDateTime: function (date) {
        if (date == null || date == "" || date == "null") return "";

        var beginIndex = date.indexOf("(") + 1;
        var endIndex = date.indexOf(")");
        var dateNum = date.substring(beginIndex, endIndex);
        var newDate = new Date(parseInt(dateNum, 10));
        return $.format.date(newDate, "yyyy-MM-dd ");
    },
    formatMillisecondDate: function (date) {
        if (IS_NET) {
            return $.csDate.formatUTCDateTime(date);
        } else {
            if (!$.csValidator.isNull(date)) {
                var newDate = new Date(date);
                return $.format.date(newDate, "yyyy-MM-dd ");
            }
        }
        return date;
    },
    formatDateTime: function (date) {
        if (date == null || date == "" || date == "null") return "";
        var beginIndex = date.indexOf("(") + 1;
        var endIndex = date.indexOf(")");
        var dateNum = date.substring(beginIndex, endIndex);
        var newDate = new Date(parseInt(dateNum, 10));
        return $.format.date(newDate, "yyyy-MM-dd hh:mm:ss");
    },
    getLastYear: function () {
        //获取系统时间 
        var date = new Date();
        year = date.getFullYear() ;
        month = date.getMonth();
        if (month == '0') {
        	month = '12';
        }
        day = date.getDate();
        return $.format.date(year + "-" + month + "-" + day, "yyyy-MM-dd");
    },
    getNow: function () {
        return $.format.date(new Date(), "yyyy-MM-dd");
    },
    datePicker: function (id, defaultDate) {
        defaultDate = $.csValidator.isNull(defaultDate) ? $.csDate.getNow() : defaultDate;
        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd' }); }).val(defaultDate).css("width", "80").css("text-align", "center").css("cursor", "pointer");
    },
    datePickerNull: function (id) {
        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd' }); }).css("width", "80").css("text-align", "center").css("cursor", "pointer");
    },
    datePickerTo10: function (id, defaultDate) {
        defaultDate = $.csValidator.isNull(defaultDate) ? $.csDate.getNow() : defaultDate;
        nowDate = $.csDate.getNow();
        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd', minDate:nowDate,maxDate:defaultDate}); }).val(defaultDate).css("width", "80").css("text-align", "center").css("cursor", "pointer");
//        $('#' + id).click(function () { WdatePicker({ dateFmt: 'yyyy-MM-dd', minDate:'%y-%M-{%d+-5}', maxDate:'#F{$dp.$DV(\'"+defaultDate+"\',{d:-2})}'}); }).val(defaultDate).css("width", "80").css("text-align", "center").css("cursor", "pointer");
    }
};

jQuery.csValidator = {
    checkNull: function (controlId, message) {
        var bFlag = false;
        if ($('#' + controlId) != null && $('#' + controlId).get(0) != null && $('#' + controlId).get(0).tagName.toLowerCase() == "select") {
            if ($('#' + controlId).val() < 0) {
                bFlag = true;
            }
        }
        else {
            var value = $("#" + controlId).val();
            if (this.isNull(value)) {
                bFlag = true;
            }
        }
        if (bFlag == true) {
            $.csCore.alert(message);
            $("#" + controlId).focus();
        }
        return bFlag;
    },
    checkNotValidEmail: function (controlId, message) {
        if ($("[id$='" + controlId + "']").val() != "") {
            var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
            if (!emailReg.test($("[id$='" + controlId + "']").val())) {
                $.csCore.alert(message);
                $("[id$='" + controlId + "']").focus();
                return true;
            }
        }
        return false;
    },
    isNull: function (val) {
        if (val == undefined || val == null || val == "" || val == '' || val == "undefined" || val == "null" || val == "NULL") {
            return true;
        }
        return false;
    },
    isExistImg: function (url) {      
        if ($.browser.msie) {
        	var x = new XMLHttpRequest();
            x.open("HEAD", url, false);
            x.send();
            return x.status == 200;
        }

        return true;
    },
    //判断是否为正整数
    checkNotPositiveInteger: function (val, message) { 
        if (val != undefined && val != null && val != "" && val != '' && val != "undefined" && val != "null" && val != "NULL") {
            var value = /^[1-9][0-9]*$/;
            if (!value.test(val)) {
                $.csCore.alert(message);
                return true;
            }
        }
        return false;
    },
    //判断是否为两位小数
    checkNotPositiveMoney: function (val, message) { 
        if (val != undefined && val != null && val != "" && val != '' && val != "undefined" && val != "null" && val != "NULL") {
            var value = /^-?\d+\.?\d{0,2}$/;
            if (!value.test(val)) {
                $.csCore.alert(message);
                return true;
            }
        }
        return false;
    }
};

jQuery.csControl = {
    fillBool: function (controlID) {
        $.csControl.fillOptions(controlID, $.csCore.getAllDicts(DICT_BOOL), "ID", "name");
    },
    initTable: function () {
        $(".list_result tr").mouseover(function () { $(this).addClass("over"); }).mouseout(function () { $(this).removeClass("over"); });
    },
    canListView: function () {
        if ($.cookie("area") == "ParamH" || $.cookie("area") == "ParamV") {
            return true;
        }
        return false;
    },
    view: function (url, event, width, height) {
        $('#paneView').empty();
        if ($.csValidator.isNull(url)) {
            return false;
        }
        if ($.cookie("area") == "ParamV" || $.cookie("area") == "ParamH") {
            $.csCore.loadPage('paneView', url, event);
        } else {
            if ($.csValidator.isNull(width)) {
                width = 750;
            }
            if ($.csValidator.isNull(height)) {
                height = 400;
            }

            $.csCore.loadModal(url, width, height, event);
        }
    },
    fillOptions: function (select, datas, fieldValue, fieldText, firstHint) {
        select = $('#' + select).empty();
        if (firstHint != null && firstHint != "") {
            var optionFirst = "<option value='-1'>" + firstHint + "</option>";
            select.append(optionFirst);
        };
        $.each(datas, function (i, data) {
        	if(fieldValue == "CXID"){//编辑页面，刺绣信息 ecode为空，不显示
        		if(data.ecode != null){
	        		 var actionValue = "data.ID";
	                 var actionText = "data." + fieldText;
	                 var option = "<option value='" + eval(actionValue) + "'>" + eval(actionText) + "</option>";
	                 select.append(option);
        		}
        	}else{
        		var actionValue = "data." + fieldValue;
                var actionText = "data." + fieldText;
                var option = "<option value='" + eval(actionValue) + "'>" + eval(actionText) + "</option>";
                select.append(option);
        	}
        });
    },
    fillRadios: function (divContainer, datas, fieldName, fieldValue, fieldText) {
        var div = $('#' + divContainer);
        $.each(datas, function (i, data) {
            if (i == 0) {
                checked = " checked='true' ";
            } else {
                checked = "";
            };
            var inputRadio = "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='" + fieldName + "' value='" + eval("data." + fieldValue) + "'>" + eval("data." + fieldText) + "</label> ";
            div.append(inputRadio);
        });
    },
    fillRadio: function (divContainer, datas, fieldName, fieldValue, fieldText,value) {
        var div = $('#' + divContainer);
        $.each(datas, function (i, data) {
        	if(eval("data." + fieldValue)==value){
        		checked = " checked='true' "; 
        	}else{
        		checked = ""; 
        	}
            var inputRadio = "<label style='display:inline;clear:none;'><input " + checked + " type='radio' name='" + fieldName + "' value='" + eval("data." + fieldValue) + "'>" + eval("data." + fieldText) + "</label> ";
            div.append(inputRadio);
        });
    },
    getRadioValue: function (name) {
        return $("input[name=" + name + "]:checked").val();
    },
    fillChecks: function (divContainer, datas, fieldName, fieldValue, fieldText, initValue) {
        try {
            initValue = initValue == null ? "" : initValue.toLowerCase();
        }
        catch (err) { }
        initValue = "," + initValue + ",";
        var div = $('#' + divContainer);
        div.empty();
        $.each(datas, function (i, data) {
            var value = eval("data." + fieldValue);
            var tempValue = "," + value + ",";
            tempValue = tempValue.toLowerCase();
            var checked = "";
            if (initValue != null && initValue != "" && initValue.indexOf(tempValue) >= 0) {
                checked = "checked='true'";
            }
            var inputCheck = "<label class='checkbox'><input " + checked + " type='checkbox' name='" + fieldName + "' value='" + value + "'>";
            inputCheck = inputCheck + eval("data." + fieldText) + "</label>";
            div.append(inputCheck);
        });
    },
    checkAll: function (chkRow, chked) {
        $('[name=' + chkRow + ']').each(function () { $(this).attr("checked", chked); });
    },
    getCheckedValue: function (chkRow) {
        var index = 0;
        var values = new Array();
        $('[name=' + chkRow + ']').each(function () {
            if (this.checked == true) {
                values[index] = this.value;
                index++;
            }
        });
        return values;
    },
    initSingleCheck: function (value) {
        var radio = $("input[value='" + value + "']");
        if (radio.length > 0) {
            radio.attr("checked", "checked");
        }
        else {
            var option = $("option[value='" + value + "']");
            if (option.length > 0) {
                option.attr("selected", true);
            }
        }
    },
    initSingleCheckById: function (id) {
    	$('#'+id).attr("checked", "checked");
    },
    checkOnce: function (current) {
        var checked = current.checked;
        $("input[name='" + current.name + "']").attr("checked", false);
        current.checked = checked;
    },
    getFormData: function (containerID) {
        var result = "{";
        var elements = "";
        elements += '#' + containerID + ' input[type=text],';
        elements += '#' + containerID + ' input[type=password],';
        elements += '#' + containerID + ' input[type=hidden],';
        elements += '#' + containerID + ' textarea,';
        elements += '#' + containerID + ' select,';
        elements += '#' + containerID + ' input[type=checkbox],';
        elements += '#' + containerID + ' input[type=radio]';
        $(elements).each(
			function () {
			    if ($(this).attr('type') == 'radio' || $(this).attr('type') == "checkbox") {

			        if ($(this).attr('checked') == 'checked' || $(this).attr('checked') == 'true' || $(this).attr('checked') == true) {
			            result += $.csControl.appendElement(this);
			        }
			    }
			    else {
			        result += $.csControl.appendElement(this);
			    }
			}
		);
        if (result.endWith(",")) {
            result = result.substring(0, result.length - 1);
        }
        result += "}";
        return result;
    },
    appendElement: function (element) {
        var name = $(element).attr('name');
        if ($.csValidator.isNull(name)) {
            name = $(element).attr('id');
        }
        if (!$.csValidator.isNull(name)) {
            var val = $(element).val();
            if (!$.csValidator.isNull(val)) {
                val = val.toValidJson();
            }
            return "'" + name + "':'" + val + "',";
        }
        return "";
    },
    appendKeyValue: function (json, key, value) {
        if ($.csValidator.isNull(key)) {
            alert("key is reqiured");
            return false;
        }
        var base = json;
        if ($.csValidator.isNull(base)) {
            base = "{'" + key + "':'" + value + "'}";
        } else {
            if (base.startWith("{") && base.endWith("}")) {
                base = base.replaceAll("}", "", true);
                base = base + ",'" + key + "':'" + value + "'}";
            } else {
                alert("json param is error;");
            }
        }
        return base;
    }
};

jQuery.csMemberPick = {
    moduler: "MemberPick",
    controlID: "",
    controlText: "",
    isMultiple: true,
    bindEvent: function () {
        $("#btnMemberPickSearch").click($.csMemberPick.list);
        $("#btnPickMember").click($.csMemberPick.pick);
        $("#btnCancelPickMember").click($.csCore.close);
    },
    list: function () {
        var param = $.csControl.getFormData($.csMemberPick.moduler + 'Search');
        var url = $.csCore.buildServicePath("/service/member/getpickmembers");
        //alert(param);
        var data = $.csCore.invoke(url, param);
        $.csControl.fillOptions('select_left', data, "ID", "name");
        var selectValues = $("#" + $.csMemberPick.controlID).val();
        if (!$.csValidator.isNull(selectValues)) {
            var Values = selectValues.split(',');
            $.each(Values, function (i, value) {
                $("#select_left option[value='" + value + "']").remove();
            });
        }

        $.csMemberCommon.bindLabel();
    },
    pick: function () {
        var values = "";
        var texts = "";
        var options = $("#select_right").find("option");
        $.each(options, function (i, option) {
            values += option.value + ",";
            texts += option.text + ",";
        });
        if (values.endWith(",")) {
            values = values.substring(0, values.length - 1);
        }
        if (texts.endWith(",")) {
            texts = texts.substring(0, texts.length - 1);
        }
        $("#" + $.csMemberPick.controlID).val(values);
        $("#" + $.csMemberPick.controlText).val(texts);
        $.csCore.close();
    },
    beforeMove: function () {
        if ($.csMemberPick.isMultiple) {
            var selectLeft = $("#select_left").find("option:selected");
            $.each(selectLeft, function (i, item) {
                $("#select_right option[value='" + item.value + "']").remove();
            });
        } else {
            var selectLeft = $("#select_left").find("option:selected");
            var selectRight = $("#select_right").find("option");
            $.each(selectRight, function (i, item) {
                $("#select_left").append("<option value='" + item.value + "'>" + item.text + "</option>");
                $("#select_right option[value='" + item.value + "']").remove();
            });
        }
        return true;
    },
    init: function (controlID, controlText, isMultiple, groupID) {
        $.csMemberCommon.fillStatus("searchStatusID");
        $.csMemberCommon.fillGroup("searchGroupIDs");
        if (!$.csValidator.isNull(groupID)) {
            $("#searchGroupIDs").hide();
            $.csControl.initSingleCheck(groupID);
        }

        $.csMemberPick.controlID = controlID;
        $.csMemberPick.controlText = controlText;
        $.csMemberPick.isMultiple = isMultiple;

        var selectValues = $("#" + controlID).val();
        var selectTexts = $("#" + controlText).val();
        if (!$.csValidator.isNull(selectValues)) {
            Values = selectValues.split(',');
            Texts = selectTexts.split(',');
            var domOption = "";
            for (var i = 0; i < Values.length; i++) {
                domOption += "<option value='" + Values[i] + "'>" + Texts[i] + "</option>"
            }
            $("#select_right").append(domOption);
        }
        if (isMultiple) {
            $("#select_left").attr("multiple", "multiple");
            $("#select_right").attr("multiple", "multiple");
        } else {
            $("#options_right_all,#options_left_all").hide();
        }
        $.csMemberPick.list();
        $.csMemberPick.bindEvent();
        var options = {
            sortType: "key",
            button_select: "#options_right",
            button_deselect: "#options_left",
            button_select_all: "#options_right_all",
            button_deselect_all: "#options_left_all",
            beforeMove: $.csMemberPick.beforeMove
        };
        $("#select_left").multiSelect("#select_right", options);
        $.csCore.pressEnterToSubmit('searchKeyword','btnMemberPickSearch');
    }
};