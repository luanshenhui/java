package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by zhanglin on 2016/7/4.
 */
public class ItemGoodsDetailDto extends ItemModel implements
        Serializable {

    private static final long serialVersionUID = 8890934807676287592L;
    //商品支付方式
    @Setter
    @Getter
    private List<TblGoodsPaywayModel> tblGoodsPaywayModelList;

    @Setter
    @Getter
    private String maxNumber;//最高期数
    @Getter
    @Setter
    private String goodsName;// 商品名称
}
