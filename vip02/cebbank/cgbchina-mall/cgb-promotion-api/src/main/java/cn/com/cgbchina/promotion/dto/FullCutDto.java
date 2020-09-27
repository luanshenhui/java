package cn.com.cgbchina.promotion.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * 满减
 *
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/6/13.
 */
public class FullCutDto implements Serializable {

    private static final long serialVersionUID = -1359254972660077937L;
    @Setter
    @Getter
    private Integer full;// 满多少钱
    @Setter
    @Getter
    private Integer cut;// 减多少钱

}
