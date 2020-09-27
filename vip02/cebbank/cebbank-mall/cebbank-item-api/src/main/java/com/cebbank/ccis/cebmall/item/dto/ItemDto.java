package com.cebbank.ccis.cebmall.item.dto;

import com.cebbank.ccis.cebmall.item.model.ItemModel;
import com.spirit.category.dto.AttributeDto;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 陈乐 on 2016/3/29.
 */
@EqualsAndHashCode
public class ItemDto implements Serializable {

    private static final long serialVersionUID = -6731036799948519479L;
    @Getter
    @Setter
    private ItemModel itemModel;
    @Getter
    @Setter
    private AttributeDto itemsAttributeDto;// 销售属性相关信息
    @Getter
    @Setter
    private List<AttributeDto> itemsAttributeList;
    @Getter
    @Setter
    private String itemDescription;// 单品描述

}
