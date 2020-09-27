package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 133625 on 16-5-5.
 */
@Setter
@Getter
public class ItemMakeDto implements Serializable {

    private static final long serialVersionUID = 4605482396031227095L;
    private String goodsCode;
    private boolean delete = false;
    //  CHANNEL_MALL_CODE = "00";// 网上商城（包括广发，积分商城）
    //  CHANNEL_PHONE_CODE = "03";// 手机商城
    //  CHANNEL_CC_CODE = "01";// CallCenter
    //  CHANNEL_IVR_CODE = "02";// IVR渠道
    //  CHANNEL_SMS_CODE = "04";// 短信渠道
    //  CHANNEL_APP_CODE = "09";// APP渠道
    //  CHANNEL_MALL_WX_CODE = "05";// 广发银行(微信)
    //  CHANNEL_CREDIT_WX_CODE = "06";// 广发信用卡(微信)
    private String channel;     // 渠道

    //  ORDERTYPEID_YG = "YG";
    //  ORDERTYPEID_JF = "JF";
    private String ordertypeId; // 业务类型代码YG：广发JF：积分
	private boolean synchroPromoData = true; // 是否需要同步活动信息，默认 false 不需要
    private GoodsModel.Status status;
}
