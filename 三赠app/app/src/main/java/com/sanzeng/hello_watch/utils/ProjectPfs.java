package com.sanzeng.hello_watch.utils;

/**
 * 整体工程中用到的SharedPfs文件名称。
 * Created by YY on 2016/6/28.
 */
public class ProjectPfs {

    private ProjectPfs() {
        throw new AssertionError();
    }

    /**
     * 用户表
     */
    public static final String USER = "user";

    /**
     * Preference file name of System.
     */
    public static final String PFS_SYS = "system";

    /**
     * 初次打开应用
     */
    public static final String FIRST_VIEW = "first_view";

    /**
     * 登录后的token
     */
    public static final String TOKEN = "token";

    /**
     * user_id 又名 customerId
     */
    public static final String USER_ID = "user_id";


    /**
     * 屏幕的宽
     */
    public static final String SCREEN_WID = "screen_wid";

    /**
     * 屏幕的高
     */
    public static final String SCREEN_HEI = "screen_hei";

    /**
     * 账号
     */
    public static final String USER_ACCOUNT = "user_account";

    /**
     * 密码
     */
    public static final String USER_PSW = "user_psw";


}
