package cn.com.cgbchina.item.dto;

import com.spirit.common.model.Indexable;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by 133625 on 16-4-30.
 */
public class ItemIndexDto implements Indexable,Serializable {

	private static final long serialVersionUID = -3092449217876939349L;
	@Setter
	@Getter
	/**
	 * 单品编码
	 */
	private String itemCode;

	@Getter
	@Setter
	private String ordertypeId;// 业务类型代码YG：广发JF：积分

	@Setter
	@Getter
	/**
	 * 商品名称
	 */
	private String name;

	@Getter
	@Setter
	private Long goodsBrandId;// 品牌id

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
	private long channelSms;// 短信状态0已上架1未上架

	@Getter
	@Setter
	private Date onShelfMallDate;// 广发商城上架时间

	@Getter
	@Setter
	private Date onShelfCcDate;// cc上架时间

	@Getter
	@Setter
	private Date onShelfMallWxDate;// 广发商城-微信上架时间

	@Getter
	@Setter
	private Date onShelfCreditWxDate;// 信用卡中心-微信上架时间

	@Getter
	@Setter
	private Date onShelfPhoneDate;// 手机商城上架时间

	@Getter
	@Setter
	private Date onShelfAppDate;// app上架时间

	@Getter
	@Setter
	private Date onShelfSmsDate;// 短信上架时间

	@Setter
	@Getter
	/**
	 * 广发商城状态0已上架1未上架
	 */
	private String mallShelfStatus;

	@Setter
	@Getter
	/**
	 * CC状态0已上架1未上架
	 */
	private String ccShelfStatus;

	@Setter
	@Getter
	/**
	 * 广发商城-微信状态0已上架1未上架
	 */
	private String mallWxShelfStatus;

	@Setter
	@Getter
	/**
	 * 信用卡中心-微信状态0已上架1未上架
	 */
	private String creditWxShelfStatus;

	@Setter
	@Getter
	/**
	 * 手机商城状态0已上架1未上架
	 */
	private String phoneShelfStatus;

	@Setter
	@Getter
	/**
	 * APP状态0已上架1未上架
	 */
	private String appShelfStatus;

	@Setter
	@Getter
	/**
	 * 短信状态0已上架1未上架
	 */
	private String smsShelfStatus;

	@Getter
	@Setter
	private String isInner;// 是否内宣商品0是1否

	@Setter
	@Getter
	/**
	 * 单品实际价格
	 */
	private BigDecimal price;

	@Setter
	@Getter
	/**
	 * 销量
	 */
	private Long salesNum;

	@Setter
	@Getter
	/**
	 * 销售属性 eg:[{"attrId":"12attr30"},{"attrId":"12attr60"}]
	 */
	private List<Map<String, Object>> saleAttrList;

	@Setter
	@Getter
	/**
	 * 销售属性 JSON格式
	 */
	private String itemAttribute;

	@Setter
	@Getter
	/**
	 * 单品图片
	 */
	private String image1;

	@Override
	public String getId() {
		return this.itemCode;
	}
}
