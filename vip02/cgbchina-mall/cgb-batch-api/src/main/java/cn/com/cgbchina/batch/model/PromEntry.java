


package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.Date;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/18.
 */
@Setter
@Getter
@ToString
public class PromEntry implements Serializable {

    private static final long serialVersionUID = 9065649522131379682L;
    private Integer id;//活动id
    private Integer periodId;//活动场次id
    private Date beginDate;//活动开始时间
    private Date endDate;//活动结束时间
    private String promType;//活动类型 只有在每天活动的返回类型时候使用  通
    // 过单品获取的活动基本信息不包括此项，批处理插入到redis中的每天中的每一条活动才包含此信息
}

