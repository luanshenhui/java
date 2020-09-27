package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import com.google.common.base.MoreObjects;
import lombok.Getter;
import lombok.Setter;

/**
 * 活动销售信息DTO
 *
 * @author wangqi
 * @version 1.0
 * @Since 2016/6/13.
 */
public class MallPromotionSaleInfoDto implements Serializable {

	private static final long serialVersionUID = -1067185461409082363L;
	@Setter
	@Getter
	private Integer saleAmountAll;// 活动的整体销售数量
	@Setter
	@Getter
	private Integer saleAmountToday;// 活动的今天的销售数量
	@Setter
	@Getter
	private Long stockAmountTody;// 今天该商品的总体库存
    //活动剩余库存
	public Long getRemainStock(){
		return MoreObjects.<Long>firstNonNull(stockAmountTody,0L)-MoreObjects.<Integer>firstNonNull(saleAmountToday,0);
	}

}
