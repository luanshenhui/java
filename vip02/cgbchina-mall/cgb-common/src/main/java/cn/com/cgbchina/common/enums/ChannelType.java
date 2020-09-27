package cn.com.cgbchina.common.enums;

import com.google.common.base.Objects;

/**
 * Created by 11140721050130 on 2016/9/17.
 */
public enum ChannelType {

    GYMALL("YG", "广发商城(一期)"),
    JFMALL("JF", "积分商城"),
    FQMALL("FQ","广发商城(分期)");

    private final String value;
    private final String desc;

    private ChannelType(String value, String desc) {
        this.value = value;
        this.desc = desc;
    }

    public String value() {
        return value;
    }

    public static ChannelType from(String value) {
        for (ChannelType type : ChannelType.values()) {
            if (Objects.equal(type.value, value)) {
                return type;
            }
        }
        return null;
    }
}
