package cn.rkylin.oms.common.enums;

import org.apache.commons.lang.StringUtils;

/**
 * 平台订单状态枚举
 *
 * @author wangxiaoyi
 * 2017-2-16 liming 修改几种状态
 */
public enum EcTradeStatusEnum {
    等待买家付款,
    等待卖家发货,
    交易部分发货,
    交易全部发货,
    交易成功,
    交易取消;

    /**
     * 根据字符串取枚举
     *
     * @param code
     * @return
     */
    public static EcTradeStatusEnum fromCode(String code) {
        if (StringUtils.isEmpty(code)) {
            return 等待买家付款;
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
