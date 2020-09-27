package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import cn.com.cgbchina.item.model.PromotionRedisModel;
import lombok.Getter;
import lombok.Setter;

/**
 * 活动详情用DTO
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class MallPromotionResultDto extends PromotionRedisModel implements Serializable {

	private static final long serialVersionUID = 2781082178466313570L;
	@Setter
	@Getter
	private String promStatus;// 活动当前状态(0:进行中 1:待开始 2:已结束)
	@Setter
	@Getter
	private Date promNowDate;// 当前时间
	@Setter
	@Getter
	private String periodId;// 场次ID
	@Setter
	@Getter
	private List<PromotionItemResultDto> promItemResultList;// 活动范围（选品列表）
	@Setter
	@Getter
	private Object tblGoodsPaywayModelList;// 支付方式
	@Setter
	@Getter
	private String saleAmountAll;// 已售数量(商品详情页展示用，非直接查询获得)
	@Setter
	@Getter
	private Boolean havaStock;// 是否有库存(商品详情页展示用，非直接查询获得)
	@Setter
	@Getter
	private Long remainStock;// 剩余库存(当前场次)
	@Getter
	@Setter
	private Integer ruleLimitBuyCount;// 限购数量
	@Getter
	@Setter
	private Integer ruleLimitBuyType;// 限购种类，0 单日内限购，1 整个活动限购
}
