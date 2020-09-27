package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

@Getter
@Setter
@ToString
public class PromotionPeriodBatchModel implements Serializable {

    private static final long serialVersionUID = -445098483616971858L;
    private Integer id;// 自增主键
    private Integer promotionId;// 活动ID
    private java.util.Date beginDate;// 开始时间
    private java.util.Date endDate;// 结束时间
}