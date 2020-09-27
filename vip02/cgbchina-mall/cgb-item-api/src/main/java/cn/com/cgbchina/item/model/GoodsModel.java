package cn.com.cgbchina.item.model;

import cn.com.cgbchina.common.enums.ChannelType;
import com.google.common.base.Objects;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@ToString
@EqualsAndHashCode
public class GoodsModel implements Serializable {

    private static final long serialVersionUID = 2020829117032759875L;
    @Getter
    @Setter
    private String code;// 商品编码
    @Getter
    @Setter
    private String ordertypeId;// 业务类型代码YG：广发JF：积分
    @Getter
    @Setter
    private String name;// 名称
    @Getter
    @Setter
    private Long productId;// 产品id
    @Getter
    @Setter
    private String createType;// 创建类型0平台创建1供应商创建
    @Getter
    @Setter
    private String vendorId;// 供应商id
    @Getter
    @Setter
    private String manufacturer;// 生产企业
    @Getter
    @Setter
    private Long goodsBrandId;// 品牌id
//    @Getter
//    @Setter
//    private Long backCategory1Id;// 一级后台类目
//    @Getter
//    @Setter
//    private Long backCategory2Id;// 二级后台类目
//    @Getter
//    @Setter
//    private Long backCategory3Id;// 三级后台类目
//    @Getter
//    @Setter
//    private Long backCategory4Id;// 四级后台类目
    @Getter
    @Setter
    private String channelMall;// 广发商城状态0已上架1未上架
    @Getter
    @Setter
    private String channelCc;// CC状态0已上架1未上架
    @Getter
    @Setter
    private String channelMallWx;// 广发商城-微信状态0已上架1未上架
    @Getter
    @Setter
    private String channelCreditWx;// 信用卡中心-微信状态0已上架1未上架
    @Getter
    @Setter
    private String channelPhone;// 手机商城状态0已上架1未上架
    @Getter
    @Setter
    private String channelApp;// APP状态0已上架1未上架
    @Getter
    @Setter
    private String channelSms;// 短信状态0已上架1未上架
    @Getter
    @Setter
    private String channelPoints;
    @Getter
    @Setter
    private String channelIvr;
    @Getter
    @Setter
    private String goodsType;// 商品类型
    @Getter
    @Setter
    private String isInner;// 是否内宣商品0是1否
    @Getter
    @Setter
    private String mailOrderCode;// 邮购分期类别码
    @Getter
    @Setter
    private String promotionTitle;// 营销语
    @Getter
    @Setter
    private String adWord;// 商品卖点
    @Getter
    @Setter
    private String keyword;// 商品搜索关键字
    @Getter
    @Setter
    private String giftDesc;// 赠品信息
    @Getter
    @Setter
    private String introduction;// 商品描述
    @Getter
    @Setter
    private String serviceType;// 服务承诺 多个值逗号分割
    @Getter
    @Setter
    private String recommendGoods1Code;// 关联推荐商品1
    @Getter
    @Setter
    private String recommendGoods2Code;// 关联推荐商品2
    @Getter
    @Setter
    private String recommendGoods3Code;// 关联推荐商品3
    @Getter
    @Setter
    private String regionType;// 分区(礼品用)
    @Getter
    @Setter
    private String approveStatus;// 商品审核状态值00编辑中01待初审02待复审03初审拒绝04复审拒绝05待上架
    @Getter
    @Setter
    private Integer limitCount;// 限购数量
    @Getter
    @Setter
    private String pointsType;// 积分类型
    @Getter
    @Setter
    private String cards;// 第三级卡产品编码，逗号分割
    @Getter
    @Setter
    private String cardLevelId;// 第三级卡产品编码，逗号分割
    @Getter
    @Setter
    private java.util.Date onShelfMallDate;// 广发商城上架时间
    @Getter
    @Setter
    private java.util.Date offShelfMallDate;// 广发商城下架时间
    @Getter
    @Setter
    private java.util.Date onShelfCcDate;// cc上架时间
    @Getter
    @Setter
    private java.util.Date offShelfCcDate;// cc下架时间
    @Getter
    @Setter
    private java.util.Date onShelfMallWxDate;// 广发商城-微信上架时间
    @Getter
    @Setter
    private java.util.Date offShelfMallWxDate;// 广发商城-微信下架时间
    @Getter
    @Setter
    private java.util.Date onShelfCreditWxDate;// 信用卡中心-微信上架时间
    @Getter
    @Setter
    private java.util.Date offShelfCreditWxDate;// 信用卡中心-微信下架时间
    @Getter
    @Setter
    private java.util.Date onShelfPhoneDate;// 手机商城上架时间
    @Getter
    @Setter
    private java.util.Date offShelfPhoneDate;// 手机商城下架时间
    @Getter
    @Setter
    private java.util.Date onShelfAppDate;// app上架时间
    @Getter
    @Setter
    private java.util.Date offShelfAppDate;// app下架时间
    @Getter
    @Setter
    private java.util.Date onShelfSmsDate;// 短信上架时间
    @Getter
    @Setter
    private java.util.Date offShelfSmsDate;// 短信下架时间
    @Getter
    @Setter
    private String freightSize;// 商品的尺寸数据
    @Getter
    @Setter
    private String freightWeight;// 商品的重量数据
    @Getter
    @Setter
    private String approveDifferent;// 审核数据diff
//    @Getter
//    @Setter
//    private String attribute;// 属性
    @Getter
    @Setter
    private String currType;// 币种
    @Getter
    @Setter
    private String delFlag;// 逻辑删除标示0未删除1已删除
    @Getter
    @Setter
    private String createOper;// 创建者
    @Getter
    @Setter
    private java.util.Date createTime;// 创建时间
    @Getter
    @Setter
    private String modifyOper;// 修改者
    @Getter
    @Setter
    private java.util.Date modifyTime;// 修改时间
    @Getter
    @Setter
    private java.util.Date onShelfTime;// 上架时间
    @Getter
    @Setter
    private Integer eachCount;// 每种商品的个数
//    @Getter
//    @Setter
//    private Integer installmentNumber;// 最高期数
    @Getter
    @Setter
    private String goodsMemo;// 礼品备注
    @Getter
    @Setter
    private String goodsBaseDesc;
    @Getter
    @Setter
    private java.util.Date autoOffShelfTime;//自动下架时间
    @Getter
    @Setter
    private String goodsBrandName;//品牌名称
//    @Getter
//    @Setter
//    private String backCategory1Nm;//一级后台类目名称
//    @Getter
//    @Setter
//    private String backCategory2Nm;//二级后台类目名称
    @Getter
    @Setter
    private java.util.Date onShelfPointsDate;//积分商城上架时间
    @Getter
    @Setter
    private java.util.Date offShelfPointsDate;//积分商城下架时间
    @Getter
    @Setter
    private java.util.Date onShelfIvrDate;//ivr上架时间
    @Getter
    @Setter
    private java.util.Date offShelfIvrDate;//ivr下架时间

    public static enum GoodsChannel {
        CHANNEL_MALL("channelMall", "广发商城渠道"),
        CHANNEL_CC("channelCc", "CC渠道"),
        CHANNEL_MALL_WX("channelMallWx", "广发商城微信渠道"),
        CHANNEL_PHONE("channelPhone", "手机商城渠道"),
        CHANNEL_CREDIT_WX("channelCreditWx", "信用卡中心微信渠道"),
        CHANNEL_APP("channelApp", "APP渠道"),
        CHANNEL_SMS("channelSms", "短信渠道"),
        CHANNEL_POINTS("channelPoints","积分商城"),
        CHANNEL_IVR("channelIVR","IVR渠道"),
        ALL("all", "所有渠道");
        private String value;
        private String desc;

        GoodsChannel(String value, String display) {
            this.value = value;
            this.desc = display;
        }

        public String value() {
            return value;
        }

        public static GoodsChannel from(String value) {
            for (GoodsChannel channel : GoodsChannel.values()) {
                if (Objects.equal(channel.value, value)) {
                    return channel;
                }
            }
            return null;
        }

        @Override
        public String toString() {
            return desc;
        }
    }


    public static enum ApproveStatus {
        EDITING_00("00", "编辑中"),
        TRIAL_FIRST_01("01", "待初审"),
        TRIAL_SECOND_02("02", "待复审"),
        TRILA_CHANGE_03("03", "商品变更审核"),
        TRIAL_PRICE_04("04", "价格变更审核"),
        TRIAL_OFFSHELF_05("05", "下架申请审核"),
        PASS("06", "审核通过"),
        TRIAL_PRICING("07", "待定价"),
        TRIAL_PRICE_08("08", "定价审核"),
        REFUSE_FIRST_O1("70", "初审拒绝"),
        REFUSE_SECOND_02("71", "复审拒绝"),
        REFUSE_CHANGE_03("72", "商品变更审核拒绝"),
        REFUSE_PRICE_04("73", "价格变更审核拒绝"),
        REFUSE_OFFSHELF_05("74", "下架申请审核拒绝"),
        REFUSE_PRICE_08("75", "定价审核拒绝");

        private String value;
        private String desc;

        ApproveStatus(String value, String desc) {
            this.value = value;
            this.desc = desc;
        }

        public String value() {
            return value;
        }

        public static ApproveStatus from(String value) {
            for (ApproveStatus channel : ApproveStatus.values()) {
                if (Objects.equal(channel.value, value)) {
                    return channel;
                }
            }
            return null;
        }

        @Override
        public String toString() {
            return desc;
        }
    }

    public static enum Status {
        INIT("00", "未上架"),
        ON_SHELF("02", "上架"),
        OFF_SHELF("01", "下架"),
        DELETED("-1", "删除");
        private String value;
        private String display;

        private Status(String value, String display) {
            this.value = value;
            this.display = display;
        }

        public String value() {
            return value;
        }

        public static Status fromNumber(String velue) {
            for (Status status : Status.values()) {
                if (Objects.equal(status.value, velue)) {
                    return status;
                }
            }
            return null;
        }

        @Override
        public String toString() {
            return display;
        }
    }

}