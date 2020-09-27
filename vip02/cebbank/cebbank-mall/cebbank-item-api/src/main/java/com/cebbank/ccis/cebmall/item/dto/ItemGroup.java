package com.cebbank.ccis.cebmall.item.dto;

import com.cebbank.ccis.cebmall.item.model.ItemModel;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import lombok.Getter;
import lombok.ToString;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/8.
 */
@ToString
public class ItemGroup {

    @Getter
    private final LinkedHashMap<String,List<Map<String,String>>> attributes;

    public ItemGroup(List<ItemModel> itemList) {
        attributes = Maps.newLinkedHashMap();
        for (ItemModel itemModel : itemList) {
            String attributeKey1 = itemModel.getAttributeKey1();
            if (!Strings.isNullOrEmpty(attributeKey1)) {
                List<Map<String,String>> skuTuples;
                if(attributes.containsKey(attributeKey1)){
                    skuTuples = attributes.get(attributeKey1);

                }else{
                    skuTuples = Lists.newArrayList();
                    attributes.put(attributeKey1,skuTuples);
                }
                Map<String,String> skuTuple = Maps.newHashMapWithExpectedSize(1);
                skuTuple.put(itemModel.getAttributeName1(), itemModel.getAttributeValue1());
                if(!skuTuples.contains(skuTuple)){
                    skuTuples.add(skuTuple);
                }
            }

            String attributeKey2 = itemModel.getAttributeKey2();
            if (!Strings.isNullOrEmpty(attributeKey2)) {
                List<Map<String,String>> skuTuples;
                if(attributes.containsKey(attributeKey2)){
                    skuTuples = attributes.get(attributeKey2);

                }else{
                    skuTuples = Lists.newArrayList();
                    attributes.put(attributeKey2,skuTuples);
                }
                Map<String,String> skuTuple = Maps.newHashMapWithExpectedSize(1);
                skuTuple.put(itemModel.getAttributeName2(), itemModel.getAttributeValue2());
                if(!skuTuples.contains(skuTuple)){
                    skuTuples.add(skuTuple);
                }
            }
        }

    }
}
