package cn.com.cgbchina.trade.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import cn.com.cgbchina.item.model.PromotionPayWayModel;
import lombok.Getter;
import lombok.Setter;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;

/**
 * Created by lvzd on 2016/9/15.
 */
@Setter
@Getter
public class OrderMainSingleCheckDto extends BaseOrderDto implements
	Serializable {
    private static final long serialVersionUID = -54520433264642729L;
    private String itemCode;
    private Integer totalNum = 0;
    private Long jfTotalNum = 0L;
    private Long jfTotalNumNoFix = 0L;
    private BigDecimal totalPrice = new BigDecimal("0");
    private BigDecimal voucherPriceTotal = new BigDecimal("0");
    private BigDecimal deduction = new BigDecimal("0");
    private OrderCommitInfoDto orderCommitInfoDto;
    private TblGoodsPaywayModel tblGoodsPaywayModel;
    private PromotionPayWayModel promotionPayWayModel;
    private String payWayId;
    private ItemModel itemModel;
    private Integer promotionType;
    private String error;

    private int goodsCount;
    private String origin;
    // 用来做check的字段
    private Boolean WXFlag = false;// 仅用做check校验是否微信渠道
    private Boolean appSource = false;// 仅用做check校验是否APP渠道
    private String mobilePhone = "";// 仅用做check校验O2O商品手机号必填

    private GoodsModel goodsModel;
    private VendorInfoDto vendorInfoDto;
    private String vendorId;
    private String privilegeId;// 优惠券ID
    private BigDecimal privilegeMoney = new BigDecimal("0");// 优惠券金额
    private String privilegeName;// 优惠劵名称
    private Long jfCount;// 积分总数
    private Long singlePrice;// 单位积分 多少积分抵扣1元
    private Boolean fixFlag;// 是否固定积分
    private MallPromotionResultDto mallPromotionResultDto;// 活动
    private String custCartId;// 购物车ID
    private BigDecimal discountPrivMon = new BigDecimal(0);
    private String pointType;// 积分类型 普通积分默认送1
    private BigDecimal oriPrice;//商品原价
}
