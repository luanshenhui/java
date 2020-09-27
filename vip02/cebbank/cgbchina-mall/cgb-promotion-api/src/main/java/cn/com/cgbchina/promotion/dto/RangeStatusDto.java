package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/1.
 */
public class RangeStatusDto implements Serializable{

    private static final long serialVersionUID = 6108434044340308807L;
    @Setter
    @Getter
    private Integer ready;//待审核的数量
    @Setter
    @Getter
    private Integer already;//已经审批通过的数量
    @Setter
    @Getter
    private Integer refuse;//已拒绝的商品数量
    @Setter
    @Getter
    private Integer all;//该活动下 所有单品
}
