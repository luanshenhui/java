package cn.rkylin.oms.common.enums;

import org.apache.commons.lang.StringUtils;

/**
 * 平台订单类型枚举
 *
 * @author liming
 */
public enum EcTradeTypeEnum {
    一口价,
    货到付款;

    /**
     * 根据字符串取枚举
     *
     * @param code
     * @return
     */
    public static EcTradeTypeEnum fromCode(String code) {
        if (StringUtils.isEmpty(code)) {
            return 一口价;
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
