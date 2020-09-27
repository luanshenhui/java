package cn.com.cgbchina.trade.model;

import lombok.Getter;
import lombok.Setter;
import org.omg.CORBA.LongLongSeqHelper;

import java.io.Serializable;

public class OrderGoodsDetailModel implements Serializable {

	private static final long serialVersionUID = 6495703911597287979L;
	@Getter
	@Setter
	private Long id;// 订单商品详情主键
	@Getter
	@Setter
	private String orderNo;// 订单编号
	@Getter
	@Setter
	private String goodsCode;// 商品编码
	@Getter
	@Setter
	private String goodsName;// 商品名称
	@Getter
	@Setter
	private String itemCode;// 单品编码
	@Getter
	@Setter
	private java.math.BigDecimal itemPrice;// 商城价格
	@Getter
	@Setter
	private java.math.BigDecimal itemMarketPrice;// 市场价格
	@Getter
	@Setter
	private Integer itemNum;// 单品数量
	@Getter
	@Setter
	private String itemSmallPic;// 单品小图标
	@Getter
	@Setter
	private String o2oCode;// o2o商品编码
	@Getter
	@Setter
	private String o2oVoucherCode;// o2o商品兑换码
	@Getter
	@Setter
	private java.math.BigDecimal installmentPrice;// 分期价格
	@Getter
	@Setter
	private Integer installmentNum;// 分期数
	@Getter
	@Setter
	private String freightSize;// 商品体积
	@Getter
	@Setter
	private String freightWeight;// 商品重量
	@Getter
	@Setter
	private String itemImage1;//
	@Getter
	@Setter
	private String itemImage2;//
	@Getter
	@Setter
	private String itemImage3;//
	@Getter
	@Setter
	private String itemImage4;//
	@Getter
	@Setter
	private String itemImage5;//
	@Getter
	@Setter
	private Long brandId;// 品牌id
	@Getter
	@Setter
	private Long backCategory1Id;// 一级后台类目
	@Getter
	@Setter
	private Long backCategory2Id;// 二级后台类目
	@Getter
	@Setter
	private Long backCategory3Id;// 三级后台类目
	@Getter
	@Setter
	private String promotionTitle;// 营销语
	@Getter
	@Setter
	private String mainImage;// 主图片
	@Getter
	@Setter
	private String saleChannel;// 销售渠道
	@Getter
	@Setter
	private String innerFlag;// 是否内宣商品
	@Getter
	@Setter
	private Integer stageNumber;// 最高期数
	@Getter
	@Setter
	private String mailOrderCode;// 邮购分期类别码
	@Getter
	@Setter
	private String adWord;// 商品卖点
	@Getter
	@Setter
	private String giftWord;// 赠品信息
	@Getter
	@Setter
	private String introduction;// 商品描述
	@Getter
	@Setter
	private String serviceType;// 服务承诺
	@Getter
	@Setter
	private Integer buyLimit;// 限购数量
	@Getter
	@Setter
	private java.util.Date createTime;// 创建时间
	@Getter
	@Setter
	private java.util.Date modifyTime;// 更新时间
	@Getter
	@Setter
	private String createOper;// 创建人
	@Getter
	@Setter
	private String modifyOper;// 更新人
	@Getter
	@Setter
	private String delFlag;// 逻辑删除标志0未删1已删
	@Getter
	@Setter
	private String itemAttrs;// 销售属性（json）
	@Getter
	@Setter
	private String productAttrs;// 产品属性（json）
	@Getter
	@Setter
	private String orderCount;// 热门交易TOP10交易数
}