package com.cebbank.ccis.cebmall.item.dto;

import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import com.spirit.search.Pair;
import com.spirit.search.SearchFacet;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;
import java.util.Set;

/**
 * 搜索结果
 * Created by 11140721050130 on 2016/8/30.
 */
public class ItemSearchFactDto implements Serializable {

    private static final long serialVersionUID = -5399798534063354856L;
    @Setter
    @Getter
    private Long total;// 总数
    @Setter
    @Getter
    private List<ItemRichDto> resultDtos;// 搜索结果列表
    @Getter
    @Setter
    private List<SearchFacet> categories = Collections.emptyList();   //for dubbo serialization sake
    @Getter
    @Setter
    private List<Pair> chosenCategories = Collections.emptyList();   //for dubbo serialization sake
    @Getter
    @Setter
    private List<AttributeNavigator> attributes = Collections.emptyList();  //for dubbo serialization sake
    @Getter
    @Setter
    private List<Pair> breadCrumbs = Collections.emptyList();     //for dubbo serialization sake
    @Getter
    @Setter
    private List<Pair> chosenAttributes = Collections.emptyList();  //for dubbo serialization sake
    @Getter
    @Setter
    private List<SearchFacet> prices = Collections.emptyList();
    @Getter
    @Setter
    private List<Pair> chosenPrices = Collections.emptyList();
    @Getter
    @Setter
    private List<SearchFacet> points = Collections.emptyList();
    @Getter
    @Setter
    private List<Pair> chosenPoints = Collections.emptyList();
    @Setter
    @Getter
    private String businessType;// 业务类型
    @Setter
    @Getter
    private String fcName; // //如果前台传入fcid，后台相应返回fcName
    @Setter
    @Getter
    private String orderType;// 业务类型

    public static class AttributeNavigator implements Serializable {
        private static final long serialVersionUID = -2122612282527597154L;
        @Getter
        @Setter
        private String key;
        @Getter
        @Setter
        private Set<SearchFacet> values = Collections.emptySet();  //for dubbo serialization sake

        @Override
        public boolean equals(Object obj) {
            if (obj == null || !(obj instanceof AttributeNavigator)) {
                return false;
            }
            AttributeNavigator that = (AttributeNavigator) obj;
            return Objects.equal(key, that.getKey());
        }

        @Override
        public int hashCode() {
            return Objects.hashCode(key);
        }

        @Override
        public String toString() {
            return MoreObjects.toStringHelper(this).add("key", key).add("values", values).toString();
        }
    }

}
