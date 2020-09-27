package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.ItemSearchFactDto;
import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import cn.com.cgbchina.item.model.GoodsPriceRegionModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * Created by 133625 on 16-3-16.
 */
public interface ItemSearchService {

    /**
     * 搜索引擎改造，zhangchj
     *
     * @param pageNo 分页数
     * @param size   每页显示条数
     * @param params 搜索条件
     * @return 搜索结果
     */
    Response<ItemSearchFactDto> itemSearch(@Param("pageNo") int pageNo,
                                           @Param("size") int size,
                                           @Param("params") Map<String, String> params);

    /**
     * 查询商品价格区间数据
     *
     * @return 结果
     */
    public Response<List<GoodsPriceRegionModel>> findGoodsPriceRegion();

    /**
     * 查询商品积分区间数据
     *
     * @return 结果
     */
    public Response<List<GoodsPointRegionModel>> findGoodsPointRegion();
}