package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.model.VirtualPrefuctureModel;
import com.google.common.base.Function;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.dto.AttributeDto;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import javax.annotation.Nullable;
import java.io.Serializable;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Objects.equal;

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
    @Getter
    @Setter
    private GoodsModel goodsModel;
    @Getter
    @Setter
    private List<TblGoodsPaywayModel> payways; // 支付方式
    @Getter
    @Setter
    private List<GoodsItemDto> goodsItemDtos;//分期数list
    @Getter
    @Setter
    private List<VirtualPrefuctureModel> virtualLists;
    @Getter
    @Setter
    private String buyLimited = "";//限制购买


    @Getter
    @Setter
    @AllArgsConstructor
    public static class Test{
        private int id;
        private String value;
    }

    public static void main(String[] args) {
        List<Test> list = Lists.newArrayList();
        for (int i = 0; i <= 11100; i++) {
            list.add(new Test(i,i + "test"));
        }

        List<Test> list2 = Lists.newArrayList();
        for (int i = 0; i <= 11100; i++) {
            list2.add(new Test(i,i + "test2"));
        }
        Long start = System.currentTimeMillis();
        System.out.println("start:" + start);
        for (Test s : list) {
            for (Test s2 : list2) {
                if (equal(s.getId(),s2.getId())) {
                    System.out.print(s.getValue() + "_" + s2.getValue());
                }
            }
        }
        System.out.println();
        Long end = System.currentTimeMillis();
        System.out.println("end:" + end);
        Long minux = end -start;
        System.out.println("minus:" + minux);
        Long start2 = System.currentTimeMillis();
        System.out.println("start2:" + start2);
        Map<Integer, Test> list2Map = Maps.uniqueIndex(list2, new Function<Test, Integer>() {
            @Nullable
            @Override
            public Integer apply(@Nullable Test input) {
                return input.getId();
            }
        });

        for (Test s1 : list) {
            Test s2 = list2Map.get(s1.getId());
            if (s2 != null) {
                System.out.print(s1.getValue() + "_" + s2.getValue());
            }
        }
        Long end2 = System.currentTimeMillis();
        System.out.println("end2:" + end2);
        Long minux2 = end2 -start2;
        System.out.println("minus2:" + minux2);
    }

}
