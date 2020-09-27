package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by tongxueying on 2016/7/5.
 */
public class OrderForBatchDto implements Serializable {
    private static final long serialVersionUID = -864652771533068511L;
    @Getter
    @Setter
    private String goodsId;//单品编码
    @Getter
    @Setter
    private int goodsSum;//单品数量和
}
