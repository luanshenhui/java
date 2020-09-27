package cn.com.cgbchina.item.dto;

import java.io.Serializable;
import java.util.Date;

import lombok.Getter;
import lombok.Setter;

/**
 * 外部接口用DTO
 *
 * geshuo 20160723
 */
public class PromotionPeriodDetailDto implements Serializable {

	private static final long serialVersionUID = -5819657081695279864L;
	@Setter
	@Getter
	private Integer promotionId;

	@Setter
	@Getter
	private String promotionName;

	@Setter
	@Getter
	private String description;

	@Setter
	@Getter
	private Date beginDate;

	@Setter
	@Getter
	private Date endDate;

}
