package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsBrandAdvertiseModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by liuchang on 2016/7/29.
 */
public class GoodsBrandAdvertiseDto extends GoodsBrandAdvertiseModel implements Serializable {

    private static final long serialVersionUID = 6702392169648949481L;

    @Getter
    @Setter
    private List<ItemGoodsDetailDto> specialsItemList; // 限时特价单品

    @Getter
    @Setter
    private List<ItemGoodsDetailDto> newItemList; // 新品上市单品

    @Getter
    @Setter
    private String brandCategoryId; // 品牌分类类别ID

    @Getter
    @Setter
    private String brandCategoryName; // 品牌分类类别名称
}
