package cn.rkylin.oms.common.enums;

import org.apache.commons.lang.StringUtils;

/**
 * 店铺类型状态枚举
 *
 * @author liming
 */
public enum ShopTypeEnum {
    淘宝,
    京东;

    /**
     * 根据字符串取枚举
     *
     * @param code
     * @return
     */
    public static ShopTypeEnum fromCode(String code) {
        if (StringUtils.isEmpty(code)) {
            return 淘宝;
        }
        try {
            return values()[Integer.parseInt(code)];
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 获取检举字符串值
     *
     * @return
     */
    public String toCode() {
        return Integer.toString(this.ordinal());
    }
}
