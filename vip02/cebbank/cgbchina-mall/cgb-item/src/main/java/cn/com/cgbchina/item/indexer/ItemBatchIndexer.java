/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.indexer;

import cn.com.cgbchina.item.dto.ItemIndexDto;
import cn.com.cgbchina.item.dto.ItemsAttributeDto;
import cn.com.cgbchina.item.dto.ItemsAttributeSkuDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import com.google.common.base.Stopwatch;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.BeanUtils;
import org.elasticsearch.index.query.QueryBuilders;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * @author 11140721050130
 * @version 1.0
 * @created at 2016/7/4.
 */
@Component
@Slf4j
public class ItemBatchIndexer extends ItemBaseIndexer {

    private static final String INDEX_NAME = "items";
    private static final String INDEX_TYPE = "item";
    private static final int PAGE_SIZE = 500;

    private static final DateTimeFormatter DATE_TIME_FORMAT = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private ItemService itemService;
    @Autowired
    private GoodsService goodsService;

    public void fullItemIndex() {
        log.info("[FULL_DUMP_ITEM] full item refresh start");
        Stopwatch stopwatch = Stopwatch.createStarted();
        // First delete all index
        esClient.getClient().prepareDeleteByQuery(INDEX_NAME).setTypes(INDEX_TYPE)
                .setQuery(QueryBuilders.matchAllQuery()).execute().actionGet();
        // Full index start
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("delFlag", 0);
        excuteItemIndex(paramMap, "full");
        stopwatch.stop();
        log.info("[FULL_DUMP_ITEM] full item refresh end, took {} ms", stopwatch.elapsed(TimeUnit.MILLISECONDS));
    }

    /**
     * 封装索引对象
     *
     * @param itemModels
     * @return
     * @throws java.lang.reflect.InvocationTargetException
     * @throws IllegalAccessException
     */
    private List<ItemIndexDto> getItemIndexDto(List<ItemModel> itemModels)
            throws InvocationTargetException, IllegalAccessException {
        // 单品按商品编码分组
        Multimap<String, ItemModel> itemModelGroups = ArrayListMultimap.create();
        //生成key:商品-value:单品map
        for (ItemModel itemModel : itemModels) {
            itemModelGroups.put(itemModel.getGoodsCode(), itemModel);
        }
        //根据单品查询商品信息
        Response<List<GoodsModel>> goodsModelListResult = goodsService
                .findByCodes(Arrays.asList(itemModelGroups.keySet().toArray(new String[0])));
        //获取商品信息
        List<GoodsModel> goodsModelList = goodsModelListResult.getResult();
        //声明单品list
        List<ItemIndexDto> itemIndexDtoList = Lists.newArrayList();
        //整合商品、单品信息 准备生成索引数据
        for (GoodsModel goodsModel : goodsModelList) {
            for (ItemModel itemModel : itemModelGroups.get(goodsModel.getCode())) {
                // 封装索引对象
                ItemIndexDto itemIndexDto = new ItemIndexDto();
                BeanUtils.copyProperties(itemIndexDto, goodsModel);
                // 创建图片索引数据
                itemIndexDto.setImage1(itemModel.getImage1());
                // 创建单品属性索引数据
                itemIndexDto.setItemAttribute(itemModel.getAttribute());
                // 创建单品价格索引数据
                itemIndexDto.setPrice(itemModel.getPrice());
                // 创建单品销量索引数据
                itemIndexDto.setSalesNum(itemModel.getGoodsTotal() == null ? -1 : itemModel.getGoodsTotal());
                // 创建单品ID索引数据
                itemIndexDto.setItemCode(itemModel.getCode());
                // 解析销售属性
                ItemsAttributeDto itemsAttributeDto = JsonMapper.JSON_NON_DEFAULT_MAPPER
                        .fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
                //单品销售属性非空判断
                if (itemsAttributeDto != null) {
                    List<Map<String, Object>> saleAttrList = Lists.newArrayList();
                    for (ItemsAttributeSkuDto itemsAttributeSkuDto : itemsAttributeDto.getSkus()) {
                        Map<String, Object> attrMap = Maps.newHashMap();
                        attrMap.put("attrId", itemsAttributeSkuDto.getAttributeValueKey().toString().concat("attr")
                                .concat(itemsAttributeSkuDto.getValues().get(0).getAttributeValueKey().toString()));
                        saleAttrList.add(attrMap);
                    }
                    itemIndexDto.setSaleAttrList(saleAttrList);
                }
                itemIndexDtoList.add(itemIndexDto);
            }
        }
        return itemIndexDtoList;
    }

    /**
     * 批量创建/更新索引操作
     *
     * @param queryParam
     * @param indexType
     */
    private void excuteItemIndex(Map<String, Object> queryParam, String indexType) {
        // get item list
        List<ItemIndexDto> itemIndexDtoList = null;
        int offset = 0;
        Pager<ItemModel> pager = itemService.findByPage(queryParam, offset, PAGE_SIZE);
        Long itemCount = pager.getTotal();// 获取有效单品总数；
        int returnSize = PAGE_SIZE;
        while (itemCount > 0 && returnSize == PAGE_SIZE) {
            if (pager == null) {
                pager = itemService.findByPage(queryParam, offset, PAGE_SIZE);
            }
            returnSize = pager.getData().size();
            offset = returnSize + 1;
            try {
                if ("full".equals(indexType)) {
                    itemIndexDtoList = getItemIndexDto(pager.getData());
                } else {
                    List<String> invalidIds = Lists.newArrayList();
                    List<ItemModel> validItemModels = filterValidItems(pager.getData(), invalidIds);
                    itemIndexDtoList = this.getItemIndexDto(validItemModels);
                    esClient.delete(INDEX_NAME, INDEX_TYPE, invalidIds);
                }
                if (!itemIndexDtoList.isEmpty()) {
                    esClient.index(INDEX_NAME, INDEX_TYPE, itemIndexDtoList);
                } else {
                    break;
                }
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

    }

    /**
     * 过滤出有效单品与废弃单品
     *
     * @param itemModels 一定时间段更新的单品
     * @param invalidIds 记录废弃单品
     * @return 返回有效单品
     */
    private List<ItemModel> filterValidItems(List<ItemModel> itemModels, List<String> invalidIds) {
        List<ItemModel> validItemModels = Lists.newArrayList();
        for (ItemModel itemModel : itemModels) {
            if ("0".equals(itemModel.getDelFlag())) {
                validItemModels.add(itemModel);
            } else {
                invalidIds.add(itemModel.getCode());
            }
        }
        return validItemModels;
    }

    public void deleteAllIndex() {
        log.info("[DELETE_ITEM] delete item index start");
        Stopwatch stopwatch = Stopwatch.createStarted();
        esClient.getClient().prepareDeleteByQuery(INDEX_NAME).setTypes(INDEX_TYPE)
                .setQuery(QueryBuilders.matchAllQuery()).execute().actionGet();

        log.info("[DELETE_ITEM] delete item index end, took {} ms", stopwatch.elapsed(TimeUnit.MILLISECONDS));
    }

    public void deltaItemIndex(Integer interval) {
        log.info("[DELTA_DUMP_ITEM] item delta dump start");

        String lastUpdateTime = DATE_TIME_FORMAT.print(new DateTime().minusMinutes(interval));
        Stopwatch stopwatch = Stopwatch.createStarted();
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("modifyTime", lastUpdateTime);
        excuteItemIndex(paramMap, "delta");
        stopwatch.stop();
        log.info("[DELTA_DUMP_ITEM] item delta finished,took {} ms", stopwatch.elapsed(TimeUnit.MILLISECONDS));
    }

    /**
     * 商品上架 创建单品索引
     * @param itemId
     */
    public void deltaItemIndex(String itemId) {
        ItemModel itemModel = itemService.findById(itemId);
        ItemIndexDto itemIndexDto = null;
        try {
            itemIndexDto = this.getItemIndexDto(Lists.newArrayList(itemModel)).get(0);
        } catch (Exception e) {
            log.error("[ERROR_DELTA_ITEM_INDEX] delta item index {}",e);
        }
        esClient.index(INDEX_NAME, INDEX_TYPE, itemIndexDto);
        //esClient.getClient().close();
        log.info("[DELTA_ITEM_INDEX] delta item index {} success ", itemId);
    }

    public void deleteItemIndex(String itemId) {
        esClient.delete(INDEX_NAME, INDEX_TYPE, itemId);
        log.info("[DELETE_ITEM_INDEX] delete item index {} success ", itemId);
    }
}
