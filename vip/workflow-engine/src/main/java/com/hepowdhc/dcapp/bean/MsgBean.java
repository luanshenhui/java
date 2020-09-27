package com.hepowdhc.dcapp.bean;

import java.text.MessageFormat;
import java.util.Map;

/**
 * 引擎中的信息
 */
public final class MsgBean {

    private final Map<String, String> message;

    public MsgBean(Map<String, String> message) {
        this.message = message;
    }


    public String getMsg(String key, String... args) {

        return MessageFormat.format(message.get(key), args);
    }

    @Override
    public String toString() {
        return message.toString();
    }
}
