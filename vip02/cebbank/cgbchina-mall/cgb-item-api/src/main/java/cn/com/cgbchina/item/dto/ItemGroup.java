/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.util.JsonMapper;
import lombok.Getter;
import lombok.ToString;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static javax.swing.text.html.HTML.Tag.LI;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/8.
 */
@ToString
public class ItemGroup {


    private final JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    @Getter
    private final LinkedHashMap<String, List<Map<Long, String>>> attributes;

    public ItemGroup(List<ItemModel> itemList) {
        attributes = Maps.newLinkedHashMap();
        for (ItemModel itemModel : itemList) {
            String itemAttributes = itemModel.getAttribute();
            if (!Strings.isNullOrEmpty(itemAttributes)) {
                ItemsAttributeDto itemsAttributeDto = jsonMapper.fromJson(itemAttributes, ItemsAttributeDto.class);
                List<ItemsAttributeSkuDto> attributeSkuDtos = itemsAttributeDto.getSkus();
                // 循环skus
                for (ItemsAttributeSkuDto itemsAttributeSkuDto : attributeSkuDtos) {
                    String attributeName = itemsAttributeSkuDto.getAttributeValueName();
                    List<Map<Long, String>> skuTuples;
                    if (attributes.containsKey(attributeName)) {
                        skuTuples = attributes.get(attributeName);
                    } else {
                        skuTuples = Lists.newArrayList();
                        attributes.put(attributeName, skuTuples);
                    }
                    Map<Long, String> skuTuple = Maps.newHashMapWithExpectedSize(1);
                    List<ItemAttributeDto> values = itemsAttributeSkuDto.getValues();
                    if(values != null) {
                        for (ItemAttributeDto itemAttributeDto : values) {
                            skuTuple.put(itemAttributeDto.getAttributeValueKey(), itemAttributeDto.getAttributeValueName());
                            if (!skuTuples.contains(skuTuple)) {
                                skuTuples.add(skuTuple);
                            }
                        }
                    }
                }

            }
        }

    }

    public static void main(String[] args) {

        String aa = "{\"attributes\":[],\"skus\":[{\"attributeValueKey\":23,\"attributeValueName\":\"厂商型号\",\"values\":[{\"attributeValueKey\":159,\"attributeValueName\":\"FS-1000-PK\"}]},{\"attributeValueKey\":22,\"attributeValueName\":\"颜色\",\"values\":[{\"attributeValueKey\":158,\"attributeValueName\":\"草莓红\"}]}]}";
        ItemsAttributeDto itemsAttributeDto = JsonMapper.nonEmptyMapper().fromJson(aa, ItemsAttributeDto.class);
        System.out.println(11);
    }
}
