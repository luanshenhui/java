package cn.com.cgbchina.item.dto;


import cn.com.cgbchina.item.model.EspAreaInfModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by tongxueying on 2016/6/25.
 */
public class GiftPartionDto implements Serializable {

    private static final long serialVersionUID = -6430388387845449092L;
    @Getter
    @Setter
    private EspAreaInfModel espAreaInfModel;//首页专区类别表

    @Getter
    @Setter
    private String integraltypeNm;//积分类型名称
}
