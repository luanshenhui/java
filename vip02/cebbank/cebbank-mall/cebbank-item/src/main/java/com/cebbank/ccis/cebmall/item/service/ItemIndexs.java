package com.cebbank.ccis.cebmall.item.service;

import com.cebbank.ccis.cebmall.item.dto.ItemMakeDto;
import com.cebbank.ccis.cebmall.item.dto.ItemRichDto;
import com.cebbank.ccis.cebmall.item.model.ItemModel;
import com.google.common.base.Splitter;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.BackCategoryService;
import com.spirit.category.service.SpuService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import static com.google.common.base.Strings.isNullOrEmpty;

/**
 * Created by 11140721050130 on 2016/9/5.
 */
@Component
@Slf4j
public class ItemIndexs {

    private final BackCategoryService backCategoryService;
    private final AttributeService attributeService;
    private final SpuService spuService;

    private final static Splitter splitter = Splitter.on(',').trimResults().omitEmptyStrings();

    @Autowired
    public ItemIndexs(BackCategoryService backCategoryService, AttributeService attributeService,
                      SpuService spuService) {
        this.attributeService = attributeService;
        this.backCategoryService = backCategoryService;
        this.spuService = spuService;
    }

    public ItemRichDto make(final ItemModel itemModel, final ItemMakeDto parItemMakeDto) {
        return  null;
    }

    public String buildItemName(String itemName,ItemModel itemModel) {
        if (!isNullOrEmpty(itemModel.getAttributeName1()) && !"无".equals(itemModel.getAttributeName1())) {
            itemName += "/" + itemModel.getAttributeName1();
        }
        if (!isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())) {
            itemName += "/" + itemModel.getAttributeName2();
        }
        return itemName;
    }

    // 各渠道活动类型
    private void setChannelPromoType(ItemRichDto richItem, String channel, Integer promType) {

    }
}
