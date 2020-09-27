package com.sanzeng.hello_watch.interfc;

/**
 * 响应的接口。
 * <p/>
 * Created by YY on 16/9/28.
 */

public interface ResponseItf<R> {
    /**
     * 异常方法
     */
    void onError(int type);

    /**
     * 响应后的方法
     *
     * @param r 响应对象
     */
    void onSuccess(R r);

    /**
     * 接口返回失败
     * @param str 错误提示
     */
    void onFail(String str);

}
