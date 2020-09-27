package com.sanzeng.hello_watch.utils;

/**
 * 这个类来记录响应码
 * 算做是一个清单文件
 * <p>
 * Created by YY on 16/9/30.
 */

public interface ResponseCodeConfigs {
    int TYPE_SYS_ERR = 1;
    int TYPE_NET_ERR = 4;
    int TYPE_TOKEN_ERR = 2;
    int TYPE_BIZ_ERR = 3;
    int TYPE_SCS = 0;

    // ***** 系统异常码 *****
    int BAD_REQ = 400;
    int NOT_AUT = 401;
    int MET_NOT_ALLOW = 405;
    int NOT_APT = 406;
    int ITN_SERVER_ERR = 500;
    int ITF_SERVER_EX = 1001;
    int APP_SERVER_EX = 1002;
    int SERVER_EMPTY_EX = 1003;
    int EMPTY_VAL_EX = 1004;
    int DATA_TRANS_EX = 1005;
    int IO_EX = 1006;
    int UNKNOWN_MET_EX = 1007;
    int ARRAY_OUT_IDX_EX = 1008;
    int TONG_DUN_ERR = 6000;
    int BAI_RONG_ERR = 6001;
    int BAI_RONG_ERR_2 = 6002;

    String SYSTEM_ERROR = "系统发生异常";
    String NET_ERROR = "请求超时";

    // ***** token失效的相关异常 *****
    int TOKEN_INVALID_EX = 1009;
    int TOKEN_MATCH_EX = 1010;

    String TOKEN_ERROR = "登录信息已失效请重新登录";

    // 访问成功
    int SUCCESS_CODE = 1000;
    int NO_BAND_CARD = 3005;
    int OTHER_CODE = 5021;
}
