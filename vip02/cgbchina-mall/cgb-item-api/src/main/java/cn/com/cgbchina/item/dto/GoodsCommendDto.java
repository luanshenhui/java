package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsCommendModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by liuchang on 2016/8/1.
 */
public class GoodsCommendDto implements Serializable {

    private static final long serialVersionUID = 8701558640271407190L;

    @Getter
    @Setter
    private String itemName;

    @Getter
    @Setter
    private GoodsCommendModel goodsCommendModel;

}
