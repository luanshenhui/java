package cn.com.cgbchina.trade.dto;

import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * 积分商城下单参数（外部接口 MAL104用）
 * geshuo 20160825
 */
public class OrderCCAndIVRAddDto  implements Serializable {

	private static final long serialVersionUID = -8170141028087348437L;

	@Getter
	@Setter
	private OrderMainModel orderMainModel;//主订单

	@Getter
	@Setter
	private String[] cardNoArray;//卡号

	@Getter
	@Setter
	private String[] goodsPriceArray;//价格

	@Getter
	@Setter
	private String[] intergralTypeArray;//积分类型

	@Getter
	@Setter
	private String[] intergralNoArray;//积分

	@Getter
	@Setter
	private String orderType;//订单类型

	@Getter
	@Setter
	private String[] goodsIdArray;//商品id列表

	@Getter
	@Setter
	private Map<String,ItemGoodsDetailDto> itemMap;//单品map

	@Getter
	@Setter
	private Map<String,TblGoodsPaywayModel> paywayMap;//支付方式map

	@Getter
	@Setter
	private Map<String,VendorInfoModel> vendorMap;//供应商map

	@Getter
	@Setter
	private String[] paywayIdArray;//支付方式id

	@Getter
	@Setter
	private String[] goodsNoArray;//商品数量

	@Getter
	@Setter
	private String contIdCard;//证件号

	@Getter
	@Setter
	private String createOper;//客户号

	@Getter
	@Setter
	private String merId;//供应商id

	@Getter
	@Setter
	private int moneyCardIndex;//卡号索引

	@Getter
	@Setter
	private String ivrFlag;//ivr标志

	@Getter
	@Setter
	private String custType;//客户类型

	@Getter
	@Setter
	private Map<String,TblCfgIntegraltypeModel> integraltypeMap;//积分类型map

	@Getter
	@Setter
	private OrderSubModel orderSubModel;//子订单(虚拟商品下单用)

	@Getter
	@Setter
	private OrderDoDetailModel orderDoDetailModel;//订单操作历史(虚拟商品下单用)

	@Getter
	@Setter
	private OrderVirtualModel orderVirtualModel;//虚拟订单扩展(虚拟商品下单用)

	@Getter
	@Setter
	private List<String> birthList;//客户号列表(虚拟商品下单用)

	@Getter
	@Setter
	private int goodsNum;//商品数量(虚拟商品下单用)

	@Getter
	@Setter
	private TblGoodsPaywayModel payway;//支付方式(虚拟商品下单用)
}
