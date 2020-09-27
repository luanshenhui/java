package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;
import java.math.BigDecimal;

public class ItemModel implements Serializable {

	private static final long serialVersionUID = 7564716368415068050L;
	@Getter
	@Setter
	private String code;//单品编码
	@Getter
	@Setter
	private String goodsCode;//商品code
	@Getter
	@Setter
	private java.math.BigDecimal marketPrice;//市场价格
	@Getter
	@Setter
	private java.math.BigDecimal price;//实际价格
	@Getter
	@Setter
	private Long stock;//实际库存
	@Getter
	@Setter
	private String o2oCode;//o2o商品编码
	@Getter
	@Setter
	private String o2oVoucherCode;//o2o兑换券编码
	@Getter
	@Setter
	private String installmentNumber;//最高期数
	@Getter
	@Setter
	private java.math.BigDecimal cash;//现金
	@Getter
	@Setter
	private Long stockWarning;//库存预警
	@Getter
	@Setter
	private java.util.Date nostockNotifyTime;//库存预警消息发送时间
	@Getter
	@Setter
	private String image1;//图片1
	@Getter
	@Setter
	private String image2;//图片2
	@Getter
	@Setter
	private String image3;//图片3
	@Getter
	@Setter
	private String image4;//图片4
	@Getter
	@Setter
	private String image5;//图片5
	@Getter
	@Setter
	private String freightSize;//商品体积
	@Getter
	@Setter
	private String freightWeight;//商品重量
	@Getter
	@Setter
	private String stagesCode;//一期邮购分期类别码
	@Getter
	@Setter
	private Long fixPoint;//固定积分
	@Getter
	@Setter
	private String machCode;//条形码
	@Getter
	@Setter
	private Long goodsTotal;//
	@Getter
	@Setter
	private Integer stickFlag;//置顶标志（默认0 非置顶，1置顶）
	@Getter
	@Setter
	private Integer stickOrder;//置顶商品显示顺序
	@Getter
	@Setter
	private Long wxOrder;//微信商品显示顺序
	@Getter
	@Setter
	private String delFlag;//逻辑删除标记 0：未删除 1：已删除
	@Getter
	@Setter
	private String createOper;//创建者
	@Getter
	@Setter
	private java.util.Date createTime;//创建时间
	@Getter
	@Setter
	private String modifyOper;//修改者
	@Getter
	@Setter
	private java.util.Date modifyTime;//修改时间
	@Getter
	@Setter
	private String attribute;//单品属性list
	@Getter
	@Setter
	private String mid;//商品ID(分期唯一值用于外系统)
	@Getter
	@Setter
	private String oid;//商品ID(一次性唯一值用于外系统)
	@Getter
	@Setter
	private String xid;//礼品编码
	@Getter
	@Setter
	private String bid;//虚拟礼品代号
	@Getter
	@Setter
	private String wxProp1;//商品属性一（微信商品用，商品详情）
	@Getter
	@Setter
	private String wxProp2;//商品属性二（微信商品用，商品参数）
	@Getter
	@Setter
	private String wxProp3;//商品属性三
	@Getter
	@Setter
	private Integer preinstallStock;//预设库存
	@Getter
	@Setter
	private java.math.BigDecimal productPointRate;//商品积分
	@Getter
	@Setter
	private java.math.BigDecimal bestRate;//最佳倍率
	@Getter
	@Setter
	private Long maxPoint;//最大积分
	@Getter
	@Setter
	private String cardLevelId;//卡等级编码


}