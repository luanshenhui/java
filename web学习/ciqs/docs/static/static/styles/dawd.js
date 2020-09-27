/**
 * JS file.
 * 
 * @author zhanglin@dpn.com.cn
 * @since 1.0.0 zhanglin@dpn.com.cn
 * @version 1.0.0 zhanglin@dpn.com.cn
 */
/* *****************************************************************************
 * 备忘记录
 * -> 
********************************************************************************
 * 变更履历
 * -> 1.0.0 2015-11-26 zhanglin@dpn.com.cn : 初建。
***************************************************************************** */

function showErrorDialog(msg, onCloseFunction) {
    jQuery.Zebra_Dialog(
        msg, 
        {
            "type"          : "error",
            "title"         : "\u9519\u8bef",
            "overlay_close" : false,
            "buttons"       : ["\u5173\u95ed"],
            "onClose"       : onCloseFunction
        }
    );
}

function showQuestionDialog(msg, onCloseFunction) {
    jQuery.Zebra_Dialog(
        msg, 
        {
            "type"          : "question",
            "title"         : "\u786e\u8ba4",
            "overlay_close" : false,
            "buttons"       : ["\u7ee7\u7eed", "\u53d6\u6d88"],
            "onClose"       : onCloseFunction
        }
    );
}

function showInformationDialog(msg, onCloseFunction) {
    jQuery.Zebra_Dialog(
        msg, 
        {
            "type"          : "information",
            "title"         : "\u63d0\u793a",
            "overlay_close" : false,
            "buttons"       : ["\u786e\u8ba4"],
            "onClose"       : onCloseFunction
        }
    );
}

function handleAjaxPostRequest(reqUrl, reqParam, blockDivId, succBackFunction) {
    if (blockDivId != null) {
        jQuery.blockUI(
            {
                message : jQuery("#" + blockDivId)
            }
        );
    }
    jQuery.post(
        reqUrl,
        reqParam,
        function (data, status) {
            if (blockDivId) {
                jQuery.unblockUI();
            }
            // 请求超时。
            if (status == "timeout") {
                showErrorDialog("\u8bf7\u6c42\u9519\u8bef\u3002<br />\u8fde\u63a5\u670d\u52a1\u5668\u8d85\u65f6\uff0c\u8bf7\u68c0\u67e5\u7f51\u7edc\u8fde\u63a5\u662f\u5426\u6b63\u5e38\u6216\u5237\u65b0\u9875\u9762\u91cd\u8bd5\u3002");
                return;
            }
            // 请求错误。
            if (status == "error") {
                showErrorDialog("\u8bf7\u6c42\u9519\u8bef\u3002<br />\u53ef\u80fd\u670d\u52a1\u5668\u7e41\u5fd9\uff0c\u8bf7\u7b49\u5f85\u4e00\u6bb5\u65f6\u95f4\u540e\u91cd\u8bd5\u3002");
                return;
            }
            // 未知结果。
            if (status != "success") {
                showErrorDialog("\u8bf7\u6c42\u9519\u8bef\u3002<br />\u4e0d\u80fd\u5904\u7406\u7684\u8bf7\u6c42\u7ed3\u679c\uff08" + status + "\uff09\u3002");
                return;
            }
            // 请求成功。
            var backStatus = "";
            if (data != null) {
                backStatus = data.status;
            }
            // 未知处理结果。
            if (backStatus != "SUCC" && backStatus != "FAIL") {
                showErrorDialog("\u5904\u7406\u5931\u8d25\u3002<br />\u4e0d\u80fd\u5904\u7406\u7684\u8fd4\u56de\u7ed3\u679c\uff08" + backStatus + "\uff09\u3002");
                return;
            }
            var backResult = data.result;
            // 处理失败。
            if (backStatus == "FAIL") {
                showErrorDialog("\u5904\u7406\u5931\u8d25\u3002<br />" + backResult.errorMsg + "\u3002");
                return;
            }
            if (succBackFunction != null) {
                succBackFunction(backResult);
            }
        }
    );
}

function handleFormSubmitBlock(formId, blockDivId) {
    if (!formId || !blockDivId) {
        return;
    }
    jQuery("#" + formId).submit(function () {
        jQuery.blockUI(
            {
                message : jQuery("#" + blockDivId)
            }
        );
    });
}
