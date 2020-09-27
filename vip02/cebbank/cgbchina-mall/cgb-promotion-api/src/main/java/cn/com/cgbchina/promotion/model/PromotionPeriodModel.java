package cn.com.cgbchina.promotion.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class PromotionPeriodModel implements Serializable {

	private static final long serialVersionUID = -445098483616971858L;
	@Getter
	@Setter
	private Integer id;// 自增主键
	@Getter
	@Setter
	private Integer promotionId;// 活动ID
	@Getter
	@Setter
	private java.util.Date beginDate;// 开始时间
	@Getter
	@Setter
	private java.util.Date endDate;// 结束时间
}