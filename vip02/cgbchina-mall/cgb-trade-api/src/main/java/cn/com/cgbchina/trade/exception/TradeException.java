/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.exception;

/**
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/8/15.
 */
public class TradeException extends RuntimeException{
    private static final long serialVersionUID = -4796018117164941256L;

    public TradeException() {
    }

    public TradeException(String message) {
        super(message);
    }

    public TradeException(String message, Throwable cause) {
        super(message, cause);
    }

    public TradeException(Throwable cause) {
        super(cause);
    }
}

