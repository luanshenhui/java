package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by txy on 2016/8/1.
 */
public class GiftRecommendationDto implements Serializable {
    private static final long serialVersionUID = -3374344168549577996L;

    private boolean giftOnShelveCheck;//礼品上架check

    public boolean isGiftOnShelveCheck() {
        return giftOnShelveCheck;
    }

    public void setGiftOnShelveCheck(boolean giftOnShelveCheck) {

        this.giftOnShelveCheck = giftOnShelveCheck;
    }

    private boolean giftCodeCheck;//积分区间是否推荐过该单品

    public boolean isGiftCodeCheck() {
        return giftCodeCheck;
    }

    public void setGiftCodeCheck(boolean giftCodeCheck) {

        this.giftCodeCheck = giftCodeCheck;
    }

    private boolean giftPointsPriceCheck;//该单品金普价是否在此积分区间

    public boolean isGiftPointsPriceCheck() {
        return giftPointsPriceCheck;
    }

    public void setGiftPointsPriceCheck(boolean giftPointsPriceCheck) {

        this.giftPointsPriceCheck = giftPointsPriceCheck;
    }

    private boolean insertSuccessFlag;//数据是否插入成功

    public boolean isInsertSuccessFlag() {
        return insertSuccessFlag;
    }

    public void setInsertSuccessFlag(boolean insertSuccessFlag) {

        this.insertSuccessFlag = insertSuccessFlag;
    }
    @Getter
    @Setter
    private String name;//礼品名称
    @Getter
    @Setter
    private Long goodsPoint;//单品金普价
    @Getter
    @Setter
    private String code; //单品编码20位
}
