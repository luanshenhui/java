package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.ACardLevelToelectronbankModel;
import com.spirit.category.dto.AttributeDto;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

public class PointPresentDto implements Serializable {

	private static final long serialVersionUID = -8358425015999483767L;
	@Getter
	@Setter
	private String goodsCode;// 商品编码
	@Getter
	@Setter
	private String vendorId;// 供应商Id
	@Getter
	@Setter
	private String backCategory1Id;// 第一级后台类目
	@Getter
	@Setter
	private String backCategory2Id;// 第二级后台类目
	@Getter
	@Setter
	private String backCategory3Id;// 第三级后台类目
	@Getter
	@Setter
	private String backCategory1Nm;// 第一级后台类目
	@Getter
	@Setter
	private String backCategory2Nm;// 第二级后台类目
	@Getter
	@Setter
	private String goodsBrandName;// 品牌名称
	@Getter
	@Setter
	private Integer goodsBrandId;// 品牌Id
	@Getter
	@Setter
	private String presentName;// 礼品名称
	@Getter
	@Setter
	private String manufacturer;// 生产厂家
	@Getter
	@Setter
	private String areaName;// 分区名称
	@Getter
	@Setter
	private String areaId;// 分区Id
	@Getter
	@Setter
	private String cards;// 三级卡编码
	@Getter
	@Setter
	private String cardsLevel;// 卡等级编码
	@Getter
	@Setter
	private String localOrder;// 商品类型
	@Getter
	@Setter
	private Integer isInner;// 是否内宣商品
	@Getter
	@Setter
	private Integer monthLimited;// 限购数量 limit_count
	@Getter
	@Setter
	private List<ItemModel> itemList;// 单品list
	@Getter
	@Setter
	private String adWord;// 商品卖点
	@Getter
	@Setter
	private String giftDesc;// 赠品信息
	@Getter
	@Setter
	private String editorValue;// 商品描述introduction
	@Getter
	@Setter
	private AttributeDto goodsAttr;// 商品销售属性及其他属性
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
	private String orderTypeId;// 业务类型代码
	@Getter
	@Setter
	private String createType;// 创建类型
	@Getter
	@Setter
	private String approveStatus;// 状态
	@Getter
	@Setter
	private String channelPoints;// 积分商城
	@Getter
	@Setter
	private String channelCc;// CC状态
	@Getter
	@Setter
	private String channelPhone;// 手机商城
	@Getter
	@Setter
	private String channelSms;// 短信状态
	@Getter
	@Setter
	private String channelIvr;// ivr状态
	@Getter
	@Setter
	private String createOper;// 创建者
	@Getter
	@Setter
	private String modifyOper;// 修改者
	@Getter
	@Setter
	private String approveDifferent;// 审核数据diff
	@Getter
	@Setter
	private String integraltypeId;//无用属性
	@Getter
	@Setter
	private String integraltypeNm;//无用属性
	@Getter
	@Setter
	private String pointsType;
	@Getter
	@Setter
	private Integer productId;
	@Getter
	@Setter
	private String mailOrderCode;//无用属性
	@Getter
	@Setter
	private String promotionTitle;//无用属性
	@Getter
	@Setter
	private String keyword;
	@Getter
	@Setter
	private String attribute;
	@Getter
	@Setter
	private List<ACardLevelToelectronbankModel> cardLevelList;// 卡等级list
	@Getter
	@Setter
	private BigDecimal points;//金普价格
	@Getter
	@Setter
	private String autoOffShelfTime;
	@Getter
	@Setter
	private Integer isDisplay;

}
