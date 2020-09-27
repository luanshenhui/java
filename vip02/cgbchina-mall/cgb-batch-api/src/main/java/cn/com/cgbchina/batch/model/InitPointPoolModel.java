package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by txy on 2016/7/20.
 */
@Getter
@Setter
@ToString
public class InitPointPoolModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = 4447104909394926157L;

    private Long maxPoint;//最大积分数

    private Long singlePoint;//单位积分

    private BigDecimal pointRate;//最高倍率

    private String curMonth;//当前月份
}
