package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsRegionModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by tongxueying on 2016/6/25.
 */
public class GiftPartionDto implements Serializable {

    private static final long serialVersionUID = 8466053887752855752L;
    @Getter
    @Setter
    private GoodsRegionModel goodsRegionModel;

    @Getter
    @Setter
    private String integraltypeNm;//积分类型名称
}
