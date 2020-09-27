package com.sanzeng.hello_watch.utils;

import java.net.SocketTimeoutException;

/**
 * 响应码的控制器
 * Created by YY on 16/10/7.
 */

public class CodeController implements ResponseCodeConfigs {

    /**
     * 状态码
     */
    private int mCode = BAD_REQ;

    public CodeController() {
    }

    public void setCode(int code) {
        this.mCode = code;
    }

    /**
     * 获取Code码的类型
     */
    public int getCodeType() {
        switch (mCode) {
            case BAD_REQ:
            case NOT_APT:
            case NOT_AUT:
            case MET_NOT_ALLOW:
            case ITN_SERVER_ERR:
            case ITF_SERVER_EX:
            case APP_SERVER_EX:
            case SERVER_EMPTY_EX:
            case EMPTY_VAL_EX:
            case DATA_TRANS_EX:
            case IO_EX:
            case UNKNOWN_MET_EX:
            case ARRAY_OUT_IDX_EX:
            case TONG_DUN_ERR:
            case BAI_RONG_ERR:
            case BAI_RONG_ERR_2:
                return TYPE_SYS_ERR;

            case TOKEN_INVALID_EX:
            case TOKEN_MATCH_EX:
                return TYPE_TOKEN_ERR;

            case OTHER_CODE:
            case SUCCESS_CODE:
            case NO_BAND_CARD:
                return TYPE_SCS;

            default:
                return TYPE_BIZ_ERR;
        }
    }
}
