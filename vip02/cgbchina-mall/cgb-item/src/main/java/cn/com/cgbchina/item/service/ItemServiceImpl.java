package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.PromotionRedisDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.CommendRankDto;
import cn.com.cgbchina.item.dto.GoodFullDto;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.ItemMakeDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.indexer.ItemRealTimeIndexer;
import cn.com.cgbchina.item.manager.ItemManager;
import cn.com.cgbchina.item.manager.PointPoolManager;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static cn.com.cgbchina.item.model.GoodsModel.Status.ON_SHELF;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Strings.isNullOrEmpty;

/**
 * Created by 133625 on 16-5-19.
 */
@Service
@Slf4j
public class ItemServiceImpl implements ItemService {

    @Resource
    private ItemDao itemDao;

    @Resource
    private GoodsDao goodsDao;

    @Resource
    private BrandService brandService;
    @Resource
    private ItemManager itemManager;
    @Resource
    private TblGoodsPaywayDao tblGoodsPaywayDao;
    @Resource
    private ItemRealTimeIndexer itemRealTimeIndexer;
    @Resource
    private MallPromotionService mallPromotionService;
    @Resource
    private GoodsDetailService goodsDetailService;



    @Override
    public Response<Boolean> update(ItemModel itemModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            checkNotNull(itemModel, "itemModel is null");
            Integer count = itemManager.update(itemModel);
            if (count > 0) {
                response.setResult(true);
                return response;
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }


    @Override
    public Pager<ItemModel> findByPage(Map<String, Object> params, int offset, int limit) {
        return itemDao.findByPage(params, offset, limit);
    }

    @Override
    public ItemModel findById(String code) {
        return itemDao.findById(code);
    }

    @Override
    public Response<ItemModel> findInfoById(String code) {
        Response<ItemModel> response = Response.newResponse();
        try {
            ItemModel itemModel = itemDao.findById(code);
            response.setResult(itemModel);
            return response;
        } catch (Exception e) {
            log.error("findById query error");
            response.setSuccess(false);
            return response;
        }
    }

    @Override
    public Response<List<ItemDto>> findItemListByCodeOrName(String searchKey, String orderTypeId) {
        Response<List<ItemDto>> itemResponse = new Response<List<ItemDto>>();
        List<ItemDto> itemDtoList = new ArrayList<ItemDto>();
        try {
            Map<String, Object> param = Maps.newHashMap();
            // 根据商品或单品编码取得goodsCodeList
            List<String> goodsCodeListByGoodsOrItemCode = itemDao.findItemListByGoodsOrItemCode(searchKey);
            List<ItemModel> itemList = null;
            if (goodsCodeListByGoodsOrItemCode != null && goodsCodeListByGoodsOrItemCode.size() != 0) {
                param.put("orderTypeId", orderTypeId);
                param.put("goodsCodeList", goodsCodeListByGoodsOrItemCode);

                List<String> goodsCodeListByOrderType = goodsDao.findGoodsCodeByOrderTypeId(param);
                if (goodsCodeListByOrderType != null && goodsCodeListByOrderType.size() != 0) {
                    itemList = itemDao.findItemListByGoodsCodeList(goodsCodeListByOrderType);
                }
            }
            // 当以商品或单品编码为条件的检索结果为空时，再以名称进行模糊检索
            if (itemList == null || itemList.size() == 0) {
                param.clear();
                param.put("goodsName", searchKey);
                param.put("orderTypeId", orderTypeId);
                List<String> codeList = goodsDao.findGoodsByGoodsNameAndOrderType(param);
                // 按取得的商品CODE列表取得单品列表
                if (codeList != null && codeList.size() != 0) {
                    itemList = itemDao.findItemListByGoodsCodeList(codeList);
                }
            }
            // 根据属性值生成单品描述
            if (itemList != null && itemList.size() != 0) {
                List<String> goodsCodeList = new ArrayList<>();
                for (ItemModel itemRecord : itemList) {
                    goodsCodeList.add(itemRecord.getGoodsCode());
                }
                List<GoodsModel> goodsModelList = goodsDao.findByCodes(goodsCodeList);
                for (int cnt = 0; cnt < itemList.size(); cnt++) {
                    ItemModel itemModel = itemList.get(cnt);
                    StringBuffer itemDec = new StringBuffer();
                    // 商品名称
                    for (int i = 0; i < goodsModelList.size(); i++) {
                        if (itemList.get(cnt).getGoodsCode().equals(goodsModelList.get(i).getCode())) {
                            itemDec.append(goodsModelList.get(i).getName() + buildItemName(itemModel));
                            break;
                        }
                    }
                    ItemDto itemDto = new ItemDto();
                    itemDto.setItemModel(itemList.get(cnt));
                    itemDto.setItemDescription(itemDec.toString());
                    itemDtoList.add(itemDto);
                }

            }
            itemResponse.setResult(itemDtoList);
        } catch (Exception e) {
            log.error("find.item.list.by.code.or.name.error,cause:{}", Throwables.getStackTraceAsString(e));
            itemResponse.setError("find.item.list.by.code.or.name.error");
        }
        return itemResponse;
    }

    public String buildItemName(ItemModel itemModel) {
        String itemName = " ";
        if (!isNullOrEmpty(itemModel.getAttributeName1()) && !"无".equals(itemModel.getAttributeName1())) {
            itemName += "/" + itemModel.getAttributeName1();
        }
        if (!isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())) {
            itemName += "/" + itemModel.getAttributeName2();
        }
        return itemName;
    }


    /**
     * 活动用商品CODE 查单品
     *
     * @param itemCode
     * @return
     */
    @Override
    public Response<List<ItemDto>> findItemListByCodeOrNameForProm(String itemCode) {
        Response<List<ItemDto>> itemResponse = new Response<List<ItemDto>>();
        List<ItemDto> itemDtoList = new ArrayList<ItemDto>();
        try {
            // 根据商品或单品编码取得单品列表
            List<ItemModel> itemList = itemDao.findItemDetailByGoodCode(itemCode);
            // 根据属性值生成单品描述
            if (itemList != null && itemList.size() != 0) {
                List<String> goodsCodeList = new ArrayList<>();
                for (ItemModel itemRecord : itemList) {
                    goodsCodeList.add(itemRecord.getGoodsCode());
                }
                List<GoodsModel> goodsModelList = goodsDao.findByCodes(goodsCodeList);


                for (int cnt = 0; cnt < itemList.size(); cnt++) {
//                    String attr = itemList.get(cnt).getAttribute();
//                    ItemsAttributeDto itemsAttributeDto = jsonMapper.fromJson(attr, ItemsAttributeDto.class);
//                    List<ItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
                    StringBuffer itemDec = new StringBuffer();
                    // 商品名称
                    for (int i = 0; i < goodsModelList.size(); i++) {
                        if (itemList.get(cnt).getGoodsCode().equals(goodsModelList.get(i).getCode())) {
                            itemDec.append(goodsModelList.get(i).getName());
                            break;
                        }
                    }
                    // 单品描述
//                    for (ItemsAttributeSkuDto sku : skus) {
//                        itemDec.append(" " + sku.getValues().get(0).getAttributeValueName());
//                    }
                    ItemDto itemDto = new ItemDto();
                    itemDto.setItemModel(itemList.get(cnt));
                    itemDto.setItemDescription(itemDec.toString());
                    itemDtoList.add(itemDto);
                }
            }
            itemResponse.setResult(itemDtoList);
        } catch (Exception e) {
            log.error("find.item.list.by.code.or.name.error,cause:{}", Throwables.getStackTraceAsString(e));
            itemResponse.setError("find.item.list.by.code.or.name.error");
        }
        return itemResponse;
    }

    /**
     * 根据itemCode查询单品相关信息 niufw
     *
     * @param itemCode
     * @return
     */
    @Override
    public Response<ItemModel> findByItemcode(String itemCode) {
        Response<ItemModel> response = new Response<ItemModel>();
        try {
            ItemModel itemModel = itemDao.findById(itemCode);
            if (itemModel != null) {
                response.setResult(itemModel);
                return response;
            }
            response.setError("itemCode.is.not.find");
        } catch (Exception e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 根据itemCode查询数据
     *
     * @param itemCode
     * @return add by liuhan
     */
    @Override
    public ItemModel findItemDetailByCode(String itemCode) {
        ItemModel itemModel = new ItemModel();
        try {
            itemModel = itemDao.findItemDetailByCode(itemCode);
        } catch (Exception e) {
            log.error("brand.query.error,cause:{}", Throwables.getStackTraceAsString(e));
        }
        return itemModel;
    }

    /**
     * 根据单品编码List查询单品list
     *
     * @param itemCodes
     * @return
     */
    @Override
    public Response<List<ItemModel>> findByCodes(List<String> itemCodes) {
        Response<List<ItemModel>> response = new Response<List<ItemModel>>();
        try {
            List<ItemModel> itemModelList = itemDao.findByCodes(itemCodes);
            response.setResult(itemModelList);
        } catch (Exception e) {
            log.error("findByCodes.item.error,caust:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 通过商品ID List 查询商品详细信息
     *
     * @param ids
     * @return
     */
    @Override
    public Response<List<ItemGoodsDetailDto>> findByIds(List<String> ids) {
        Response<List<ItemGoodsDetailDto>> response = new Response<List<ItemGoodsDetailDto>>();
        if (ids == null || ids.size() == 0) {
            response.setResult(Collections.<ItemGoodsDetailDto>emptyList());
            return response;
        }
        try {
            List<ItemModel> itemModelList = itemDao.findNoCode(ids);

            List<String> goodsCodes = Lists.transform(itemModelList, new Function<ItemModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable ItemModel input) {
                    return input.getGoodsCode();
                }
            });
            List<GoodsModel> goodsList = goodsDao.findByCodes(goodsCodes);
            Map<String, GoodsModel> goodsModelHashMap = Maps.uniqueIndex(goodsList, new Function<GoodsModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable GoodsModel input) {
                    return input.getCode();
                }
            });

            List<ItemGoodsDetailDto> itemModelResult = new ArrayList<ItemGoodsDetailDto>();
            for (ItemModel itemModel : itemModelList) {
                ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
                BeanUtils.copyProperties(itemGoodsDetailDto, itemModel);
                GoodsModel goodsModel = goodsModelHashMap.get(itemModel.getGoodsCode());
                if (goodsModel != null) {
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName());
                    itemGoodsDetailDto.setVendorId(goodsModel.getVendorId());// 供应商id
                    itemGoodsDetailDto.setGoodsType(goodsModel.getGoodsType());// 商品类型（00实物01虚拟02O2O）
                    if (StringUtils.isNotEmpty(goodsModel.getPointsType())) {
                        itemGoodsDetailDto.setPointsType(goodsModel.getPointsType());// 积分类型id
                    }
                    itemGoodsDetailDto.setGoodsBrandName(goodsModel.getGoodsBrandName());// 品牌名称
                    itemGoodsDetailDto.setChannelCc(goodsModel.getChannelCc());// CC状态
                    itemGoodsDetailDto.setChannelIvr(goodsModel.getChannelIvr());// ivr状态
                    // 名称加上属性
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName() + buildItemName(itemModel));
                }
                //调用共通方法，查找单品最高期数
                Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
                itemGoodsDetailDto.setMaxNumber(maxInstallmentNumber.toString());
                BigDecimal newPrice = itemModel.getPrice();
                itemGoodsDetailDto.setPrice(newPrice.divide(new BigDecimal(maxInstallmentNumber), 2, BigDecimal.ROUND_HALF_UP));// 分期价格
                itemModelResult.add(itemGoodsDetailDto);
            }
            response.setResult(itemModelResult);
        } catch (RuntimeException e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        } catch (InvocationTargetException e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        } catch (IllegalAccessException e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 广发商城商品楼层装修使用   如果该单品参加了活动 会抓取活动信息
     */
    @Override
    public Response<List<ItemGoodsDetailDto>> findByIdsForDecoration(List<String> ids) {
        Response<List<ItemGoodsDetailDto>> response = new Response<List<ItemGoodsDetailDto>>();
        if (ids == null || ids.size() == 0) {
            response.setResult(Collections.<ItemGoodsDetailDto>emptyList());
            return response;
        }
        try {
            List<ItemModel> itemModelList = itemDao.findNoCode(ids);

            List<String> goodsCodes = Lists.transform(itemModelList, new Function<ItemModel, String>() {
                @Override
                public String apply(ItemModel input) {
                    return input.getGoodsCode();
                }
            });
            List<GoodsModel> goodsList = goodsDao.findByCodes(goodsCodes);
            Map<String, GoodsModel> goodsModelHashMap = Maps.uniqueIndex(goodsList, new Function<GoodsModel, String>() {
                @Override
                public String apply(GoodsModel input) {
                    return input.getCode();
                }
            });

            List<ItemGoodsDetailDto> itemModelResult = new ArrayList<ItemGoodsDetailDto>();
            for (ItemModel itemModel : itemModelList) {
                ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
                BeanUtils.copyProperties(itemGoodsDetailDto, itemModel);
               //价格  分期数 商品名
                String maxNumber = String.valueOf(GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber()));
                GoodsModel goodsModel = goodsModelHashMap.get(itemModel.getGoodsCode());
                if (goodsModel != null) {
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName());
                    // 名称加上属性
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName() + buildItemName(itemModel));
                }
                itemGoodsDetailDto.setMaxNumber(maxNumber);
                //普通商品的价格及分期数
                BigDecimal newPrice = itemModel.getPrice();
                //获取是否活动 如果是活动  秒杀和团购则覆盖普通商品的价格供前台显示  满减依然显示原价
                Response<MallPromotionResultDto> promByItemCodesR = mallPromotionService.findPromByItemCodes("1", itemModel.getCode(), "00");
                if(promByItemCodesR.isSuccess()){
                    MallPromotionResultDto mallPromotionResultDto = promByItemCodesR.getResult();
                    if(mallPromotionResultDto!=null){
                        List<PromotionItemResultDto> promItemResultList = mallPromotionResultDto.getPromItemResultList();
                        //该接口一定会返回值，防止数据问题导致高并发下首页不可用 加此判断
                        if(promItemResultList!=null&&promItemResultList.size()>0){
                            PromotionItemResultDto promotionItemResultDto = promItemResultList.get(0);
                            switch (mallPromotionResultDto.getPromType()){
                                case 10:
                                    newPrice=mallPromotionResultDto.getRuleDiscountRate().multiply(promotionItemResultDto.getPrice());
                                    break;
                                case 30:
                                    newPrice=promotionItemResultDto.getPrice();
                                    break;
                                case 40:
                                    newPrice=promotionItemResultDto.getLevelPrice();
                                    break;
                            }
                         }
                    }
                }else {
                    log.error("fail to read item's promotion info,errer message={}",promByItemCodesR.getError());
                }
                itemGoodsDetailDto.setPrice(newPrice.divide(new BigDecimal(maxNumber), 2, BigDecimal.ROUND_HALF_UP));// 分期价格
                itemModelResult.add(itemGoodsDetailDto);
            }
            response.setResult(itemModelResult);
        }catch (Exception e){
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        return response;
    }

    /**
     * 品牌楼层展示
     *
     * @param id1s id2s id3s
     * @return
     */
    @Override
    public Response<Map<String, Object>> findByIdList(List<String> id1s, List<String> id2s, List<String> id3s) {
        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
        Map<String, Object> mapParam = Maps.newHashMap();
        try {
            Response<List<ItemGoodsDetailDto>> id1sResult = findByIdsForDecoration(id1s);
            Response<List<ItemGoodsDetailDto>> id2sResult = findByIdsForDecoration(id2s);
            Response<List<ItemGoodsDetailDto>> id3sResult = findByIdsForDecoration(id3s);
            if (id1sResult.isSuccess()) {
                List<ItemGoodsDetailDto> list1 = id1sResult.getResult();
                mapParam.put("id1List", list1);
            }
            if (id2sResult.isSuccess()) {
                List<ItemGoodsDetailDto> list2 = id2sResult.getResult();
                mapParam.put("id2List", list2);
            }
            if (id3sResult.isSuccess()) {
                List<ItemGoodsDetailDto> list3 = id3sResult.getResult();
                mapParam.put("id3List", list3);
            }

        } catch (Exception e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        response.setResult(mapParam);
        return response;
    }

    /**
     * 品牌管接口
     *
     * @param id1s id2s
     * @return
     */
    @Override
    public Response<Map<String, Object>> findGoodsAndBrands(List<String> id1s, List<Long> id2s) {
        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
        Map<String, Object> mapParam = Maps.newHashMap();
        try {
            Response<List<ItemGoodsDetailDto>> resultIds1 = findByIds(id1s);
            if (!resultIds1.isSuccess()) {
                log.error("Response.error,error code: {}", resultIds1.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
            }
            List<ItemGoodsDetailDto> list1 = resultIds1.getResult();
            Response<List<GoodsBrandModel>> resultIds2 = brandService.findByIds(id2s);
            if (!resultIds2.isSuccess()) {
                log.error("Response.error,error code: {}", resultIds2.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
            }
            List<GoodsBrandModel> list2 = resultIds2.getResult();
            mapParam.put("id1List", list1);
            mapParam.put("id2List", list2);
        } catch (Exception e) {
            log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.item.error");
        }
        response.setResult(mapParam);
        return response;
    }



    /**
     * 查询 置顶商品 列表
     *
     * @param pageNo
     * @param size
     * @param code
     * @param name
     * @return Pager
     * edit by zhoupeng
     */
    @Override
    public Response<Pager<ItemDto>> findAllstickFlag(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                     @Param("code") String code, @Param("itemName") String name) {
        Response<Pager<ItemDto>> response = Response.newResponse();
        Map<String, Object> paramItem = Maps.newHashMapWithExpectedSize(2);
        Map<String, Object> paramGoods = Maps.newHashMapWithExpectedSize(4);
        PageInfo pageInfo = new PageInfo(pageNo, 10);
        List<ItemDto> itemDtos;
        List<GoodsModel> goodsList = null;
        try {
            // 查询条件
            //单品id 查询
            if (!isNullOrEmpty(code)) {
                paramItem.put("code", code);
            }
            //商品名称 模糊查询
            if (!isNullOrEmpty(name)) {
                paramGoods.put("goodsName", name);
                paramGoods.put("ordertypeId", "YG");
                goodsList = goodsDao.findGoodsByIds(paramGoods);
                if(null != goodsList && !goodsList.isEmpty()){
                    List<String> goodsCodes = Lists.transform(goodsList, new Function<GoodsModel, String>() {
                        @Nullable
                        @Override
                        public String apply(@Nullable GoodsModel input) {
                            return input.getCode();
                        }
                    });
                    paramItem.put("goodsCodes", goodsCodes);
                }else{
                    response.setResult(new Pager<ItemDto>(0L, Collections.<ItemDto>emptyList()));
                    return response;
                }
            }
            paramItem.put("stickFlag", 1);//置顶标识
            Pager<ItemModel> pager = itemDao.findAllStickFlagCount(paramItem, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager.getTotal() > 0) {
                List<ItemModel> itemList = pager.getData();
                itemDtos = Lists.newArrayListWithExpectedSize(itemList.size());

                // 单品列表查询 时， 检索 商品名进行展示
                // 之前 查询过 直接-处理数据,不必再次查询
                if (null != goodsList && !goodsList.isEmpty()) {
                    resultDataPrepared(goodsList, itemList, itemDtos);
                } else {
                    paramGoods.clear();
                    paramGoods.put("list", itemList);
                    paramGoods.put("ordertypeId", "YG");
                    goodsList = goodsDao.findGoodsByIds(paramGoods);
                    if (null != goodsList && !goodsList.isEmpty()) {
                        resultDataPrepared(goodsList, itemList, itemDtos);

                    } else {
                        response.setResult(new Pager<ItemDto>(0L, Collections.<ItemDto>emptyList()));
                    }
                }
                //数据返回
                response.setResult(new Pager<ItemDto>(pager.getTotal(), itemDtos));
            }else{
                response.setResult(new Pager<ItemDto>(0L, Collections.<ItemDto>emptyList()));
            }
        } catch (Exception e) {
            log.error("brand.query.error,cauese:{}", Throwables.getStackTraceAsString(e));
            response.setError("ItemServiceImpl.findAllstickFlag.filed");
        }
        return response;
    }

    /**
     * 数据准备
     *
     * @param goodsList goods 信息
     * @param itemList 查询的单品信息
     * @param itemDtos 展示数据
     */
    private void resultDataPrepared(List<GoodsModel> goodsList, List<ItemModel> itemList, List<ItemDto> itemDtos) {
        Map<String, GoodsModel> goodsMap = Maps.uniqueIndex(goodsList, new Function<GoodsModel, String>() {
            @NotNull
            @Override
            public String apply(@NotNull GoodsModel input) {
                return input.getCode();
            }
        });
        for (ItemModel itemModel : itemList) {
            ItemDto itemDto = new ItemDto();
            GoodsModel goodsModel = goodsMap.get(itemModel.getGoodsCode());
            if (null == goodsModel)
                continue;
            itemDto.setGoodsModel(goodsModel);
            itemDto.setItemModel(itemModel);
            itemDto.setItemDescription(goodsModel.getName() + buildItemName(itemModel));
            itemDtos.add(itemDto);
        }
    }

    /**
     * 置顶 信息更新
     *
     * @param itemCode 更新Code
     * @param user     用户信息
     * @param operate  操作方式
     * @return Boolean
     * edit by zhoupeng
     */
    @Override
    public Response<Boolean> updateStickOrder(String itemCode, Integer stickOrder, String operate, User user) {
        Response<Boolean> response = Response.newResponse();
        try {
            ItemModel itemModel;
            switch (operate) {
                case "create":
//                    stickOrder = itemDao.findMaxStickOrder();
                    stickOrder = getStickOrder();

                    if (10000 == stickOrder) {
                        response.setResult(Boolean.FALSE);
                        return response;
                    }

                    itemModel = new ItemModel();
                    itemModel.setCode(itemCode);
                    itemModel.setStickFlag(1);
                    itemModel.setStickOrder(stickOrder);
                    itemModel.setModifyOper(user.getName());
                    break;
                case "edit":

                    Map<String, Object> paramsMap = Maps.newHashMap();
                    paramsMap.put("stickOrder", stickOrder);
                    paramsMap.put("delFlag", Contants.DEL_FLAG_0);
                    List<ItemModel> items = itemDao.findItemByConditions(paramsMap);

//                    Boolean flag = checkStickOrder(itemCode, stickOrder);
                    if (null != items && !items.isEmpty()) {
                        response.setResult(Boolean.FALSE);
                        return response;
                    }

                    itemModel = new ItemModel();
                    itemModel.setCode(itemCode);
                    itemModel.setStickOrder(stickOrder);
                    itemModel.setModifyOper(user.getName());
                    break;
                case "delete":
                    itemModel = new ItemModel();
                    itemModel.setCode(itemCode);
                    itemModel.setStickFlag(0); // 置回未置顶
                    itemModel.setStickOrder(999999999);//999999999 --> DB默认值
                    itemModel.setModifyOper(user.getName());
                    break;
                default:
                    throw new ResponseException("unknown.status.error");
            }

            Integer count = itemManager.update(itemModel);

            ItemModel itemModelIndex = itemDao.findById(itemCode);
            if (itemModelIndex != null) {
                ItemMakeDto itemMakeDto = new ItemMakeDto();
                itemMakeDto.setGoodsCode(itemModelIndex.getGoodsCode());
                itemMakeDto.setStatus(ON_SHELF);
                itemRealTimeIndexer.index(itemMakeDto); // ON_SHELF("02", "上架"),OFF_SHELF("01", "下架"), DELETED("-1", "删除");
            }
            if (count > 0) {
                response.setResult(true);
                return response;
            }
        } catch (Exception e) {
            log.error("update.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    private Integer getStickOrder() {
        List<Integer> stickOrders = itemDao.findAllStickOrder();
        // 为空时 默认 1
        if (null == stickOrders || stickOrders.isEmpty()) {
            return 1;
        }

        for (int i = 1; i <= 9999; i++) {
            if (!stickOrders.contains(i)) {
                return i;
            }
        }

        return 10000;
    }



    /**
     * 根据商品code取得所对应的单品信息
     *
     * @param goodsCodeList
     * @return
     * @author TanLiang
     * @time 2016-6-14
     */
    @Override
    public Response<List<ItemModel>> findItemListByGoodsCodeList(List<String> goodsCodeList) {
        Response<List<ItemModel>> response = new Response<>();
        try {
            List<ItemModel> itemModelList = itemDao.findItemListByGoodsCodeList(goodsCodeList);
            response.setResult(itemModelList);
            return response;
        } catch (Exception e) {
            log.error("find.item.list.by.goods.code.list.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("find.item.error");
            return response;
        }
    }




    @Override
    public Response<List<ItemModel>> findByCodesNoOrder(List<String> itemCodes) {
        Response<List<ItemModel>> response = new Response<List<ItemModel>>();
        try {
            List<ItemModel> itemModelList = itemDao.findByCodesNoOrder(itemCodes);
            response.setResult(itemModelList);
        } catch (Exception e) {
            log.error("findByCodesNoOrder.item.error", Throwables.getStackTraceAsString(e));
            response.setError("findByCodesNoOrder.item.error");
        }
        return response;
    }

    /**
     * 根据编码、oId、mid 查找单品
     *
     * @param code
     * @param omid(可能是oId也可能是mid)
     * @return ItemModel
     * @author ZJQ @2016-7-8
     * @modifier xiewl  code oid mid 可以传空，传空则取随机抽取一个CC上架商品
     */
    @Override
    public Response<ItemModel> findByIdAndOidOrMid(String code, String omid) {
        Response<ItemModel> result = new Response<ItemModel>();
        try {
            ItemModel itemModel = itemDao.findByIdAndOidOrMid(code, omid);
            result.setResult(itemModel);
        } catch (Exception e) {
            log.error("findByIdAndOidOrMid.item.error", Throwables.getStackTraceAsString(e));
            result.setError("findByIdAndOidOrMid.item.error");
        }
        return result;
    }

    /**
     * 积分商城首页展示
     *
     * @param newItemIds hotItemIds
     * @return
     */
    public Response<Map<String, Object>> findIntegralItemsByIdList(@Param("newItemIds") List<String> newItemIds,
                                                                   @Param("hotItemIds") List<String> hotItemIds) {
        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
        Map<String, Object> mapParam = Maps.newHashMap();
        try {
            Response<List<ItemGoodsDetailDto>> resultNewItemIds = findByIds(newItemIds);
            if (!resultNewItemIds.isSuccess()) {
                log.error("Response.error,error code: {}", resultNewItemIds.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
            }
            List<ItemGoodsDetailDto> newItemList = resultNewItemIds.getResult();

            Map<String, Object> paramMap = Maps.newHashMap();
            for (ItemGoodsDetailDto itemGoodsDetailDto : newItemList) {
                paramMap.put("goodsId", itemGoodsDetailDto.getCode());
                paramMap.put("memberLevel", "0000");// 金普等级
                List<TblGoodsPaywayModel> tblGoodsPaywayModels = tblGoodsPaywayDao.findGoodsPayWayByParams(paramMap);
                if (tblGoodsPaywayModels.size() > 0) {
                    itemGoodsDetailDto.setPrice(new BigDecimal(tblGoodsPaywayModels.get(0).getGoodsPoint()));
                }
            }
            Response<List<ItemGoodsDetailDto>> resultHotItemIds = findByIds(hotItemIds);
            if (!resultHotItemIds.isSuccess()) {
                log.error("Response.error,error code: {}", resultHotItemIds.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
            }
            List<ItemGoodsDetailDto> hotItemList = resultHotItemIds.getResult();
            Map<String, Object> paramMap1 = Maps.newHashMap();
            for (ItemGoodsDetailDto hotItemGoodsDetailDto : hotItemList) {
                paramMap1.put("goodsId", hotItemGoodsDetailDto.getCode());
                paramMap1.put("memberLevel", "0000");// 金普等级
                List<TblGoodsPaywayModel> tblGoodsPaywayModels = tblGoodsPaywayDao.findGoodsPayWayByParams(paramMap1);
                if (tblGoodsPaywayModels.size() > 0) {
                    hotItemGoodsDetailDto.setPrice(new BigDecimal(tblGoodsPaywayModels.get(0).getGoodsPoint()));
                }
            }
            //查找热门收藏排行
            List<CommendRankDto> rankList = Lists.newArrayList();
            Response<List<CommendRankDto>> rankR =  goodsDetailService.findCommendRank(Contants.BUSINESS_TYPE_JF,4,"0002");
            if (rankR.isSuccess()){
                rankList = rankR.getResult();
            }
            mapParam.put("newItemList", newItemList);
            mapParam.put("hotItemList", hotItemList);
            mapParam.put("rankList",rankList);
        } catch (Exception e) {
            log.error("findIntegralItemsByIdList.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findIntegralItemsByIdList.item.error");
        }
        response.setResult(mapParam);
        return response;
    }


    /**
     * 根据单品编码List查询单品list(包含已删除)
     *
     * @param itemCodes
     * @return
     * @add by yanjie.cao
     */
    @Override
    public Response<List<ItemModel>> findByCodesAll(List<String> itemCodes) {
        Response<List<ItemModel>> response = new Response<List<ItemModel>>();
        try {
            List<ItemModel> itemModelList = Lists.newArrayList();
            itemModelList = itemDao.findByCodesAll(itemCodes);
            response.setResult(itemModelList);
        } catch (Exception e) {
            log.error("findByCodesAll.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodesAll.item.error");
        }
        return response;
    }

    @Override
    public Response<ItemModel> findByCodeAll(String itemCode) {
        Response<ItemModel> response = Response.newResponse();
        try {
            ItemModel itemModel = itemDao.findByCodeAll(itemCode);
            response.setResult(itemModel);
        } catch (Exception e) {
            log.error("findByCodeAll.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodeAll.item.error");
        }
        return response;
    }

    /**
     * 根据品牌ID查询前十条单品数据
     *
     * @param brandId
     * @return
     */
    @Override
    public Response<List<RecommendGoodsDto>> findByBrandId(String brandId) {
        Response<List<RecommendGoodsDto>> response = Response.newResponse();
        List<RecommendGoodsDto> list = Lists.newArrayList();
        try {
            List<String> goodsCodes = goodsDao.findGoodsCodeByBrandId(brandId);// 通过品牌ID取出最新上架的十条商品code
            if (goodsCodes != null && goodsCodes.size() != 0) {
                List<ItemModel> itemModels = itemDao.findTopItemListByGoodsCodeList(goodsCodes);// 根据前十条商品CodeList查找单品信息
                for (ItemModel itemModel : itemModels) {
                    Response<RecommendGoodsDto> recommendGoodsDtoResponse = finRecommendGoodsByItemModel(
                            itemModel.getCode());
                    if (recommendGoodsDtoResponse.isSuccess()) {
                        RecommendGoodsDto recommendGoodsDto = recommendGoodsDtoResponse.getResult();
                        list.add(recommendGoodsDto);
                    }
                }
                response.setResult(list);
            }
        } catch (Exception e) {
            log.error("find.item.by.brandId.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("find.item.by.brandId.error");
        }
        return response;
    }



    @Override
    public Response<Integer> updateItemTotal(ItemModel itemModel) {
        Response<Integer> response = Response.newResponse();
        try {
            Integer count = itemManager.updateItemTotal(itemModel);
            response.setResult(count);
        } catch (Exception e) {
            log.error("update.item.goods.total.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.goods.total.error");
        }
        return response;
    }

    /**
     * 根据itemCode查询RecommendGoodsDto-商城前台展示使用
     *
     * @param itemCode
     * @return
     */
    @Override
    public Response<RecommendGoodsDto> finRecommendGoodsByItemModel(String itemCode) {
        Response<RecommendGoodsDto> result = Response.newResponse();
        try {
            RecommendGoodsDto recommendGoodsDto = findItemInfoByItemCode(itemCode);
            // 判断最大分期数是否为空
            if (recommendGoodsDto != null) {
                BigDecimal newPrice = recommendGoodsDto.getPrice();
                String max = recommendGoodsDto.getMaxInstallmentNumber();
                if (StringUtils.isNotEmpty(max)) {
                    Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(max);
                    recommendGoodsDto.setMaxInstallmentNumber(maxInstallmentNumber.toString());
                    if (newPrice != null) {
                        BigDecimal perStage = newPrice.divide(BigDecimal.valueOf(maxInstallmentNumber), 2, BigDecimal.ROUND_HALF_UP);// 计算每期价格
                        recommendGoodsDto.setMinPrice(perStage); // 每期价格
                    }
                } else {
                    recommendGoodsDto.setMinPrice(newPrice);// 如果最大分期数为空，最小价格为最大价格
                }
            }
            result.setResult(recommendGoodsDto);
        } catch (Exception e) {
            log.error("find.recommend.goods.by.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("find.recommend.goods.by.item.error");
        }
        return result;
    }

    private RecommendGoodsDto findItemInfoByItemCode(String itemCode) {
        RecommendGoodsDto recommendItem = new RecommendGoodsDto();
        // 根据单品编码取得单品信息
        ItemModel itemModel = itemDao.findItemDetailByCode(itemCode);
        if (itemModel != null) {
            // 根据商品编码取得商品信息
            GoodsModel recommendGoods = goodsDao.findById(itemModel.getGoodsCode());
            // 单品信息设定
            recommendItem.setGoodsName(recommendGoods.getName() + buildItemName(itemModel));
            recommendItem.setGoodsCode(itemModel.getGoodsCode());
            recommendItem.setPrice(itemModel.getPrice());
            recommendItem.setImg(itemModel.getImage1());
            recommendItem.setItemCode(itemModel.getCode());
            recommendItem.setMaxInstallmentNumber(itemModel.getInstallmentNumber());
        }
        return recommendItem;
    }

    @Override
    public Response<Boolean> updateBatchStock(Map<String, Integer> map, User user) {
        Response<Boolean> response = Response.newResponse();
        try {
            int ret = itemManager.updateBatchStock(map, user);
            if (ret <= 0) {
                log.error("update.item.error,cause:库存回滚失败");
                response.setError("update.item.error:库存回滚失败");
                return response;
            }
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("update.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    /**
     * MAL502 回滚库存 niufw
     *
     * @param code
     * @param backNum
     * @return
     */
    @Override
    public Response<Boolean> rollbackBacklogByNum(String code, int backNum) {
        Response<Boolean> response = Response.newResponse();
        // 校验
        if (StringUtils.isEmpty(code)) {
            log.error("code.is.null，error:{}", response.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, "code.is.null");
        }
        try {
            // 根据单品编码查询单品信息
            ItemModel itemModel = itemDao.findItemDetailByCode(code);
            if (itemModel == null) {
                log.error("itemModel.can.not.find，error:{}", response.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "itemModel.can.not.find");
            }
            // 查看单品库存
            Long stock = itemModel.getStock();
            if (stock >= 9999) {
                log.error("stock.can.not.add，error:{}", response.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "stock.can.not.add");
            }
            ItemModel item = new ItemModel();
            item.setCode(code);
            item.setStock(stock + backNum);
            Boolean updateResult = itemManager.rollbackBacklogByNum(item);
            response.setResult(updateResult);
            return response;
        } catch (Exception e) {
            log.error("update.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
            return response;
        }
    }

    @Override
    public Response<ItemModel> findItemByXid(String code) {
        Response<ItemModel> response = Response.newResponse();
        try {

            ItemModel itemModel = new ItemModel();
            List<ItemModel> itemModelList = itemDao.findItemCodeByXid(code);
            if (itemModelList != null && itemModelList.size() > 0) {
                itemModel = itemModelList.get(0);
            }
            response.setResult(itemModel);
            return response;
        } catch (Exception e) {
            log.error("findItemByXid query error");
            response.setSuccess(false);
            return response;
        }
    }

    /**
     * MAL115 减库存
     *
     * @param code
     * @param goodsNum
     * @return
     */
    @Override
    public Response<Integer> subtractStock(String code, long goodsNum) {
        Response<Integer> response = Response.newResponse();
        try {
            ItemModel itemModel = new ItemModel();
            itemModel.setCode(code);
            itemModel.setStock(goodsNum);
            Integer count = itemManager.subtractStock(itemModel);
            response.setResult(count);
        } catch (Exception e) {
            log.error("update.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    public Response<ItemModel> findByMid(String mid) {
        Response<ItemModel> response = Response.newResponse();
        try {
            response.setResult(itemDao.findByMid(mid));
            return response;
        } catch (Exception e) {
            log.error("findByMid.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findByMid.item.error");
            return response;
        }
    }

    @Override
    public Response<Long> findStockByItemCode(String itemCode) {
        Response<Long> response = new Response<>();
        try {
            Long stockByItemCode = itemDao.findStockByItemCode(itemCode);
            response.setResult(stockByItemCode);
        } catch (Exception e) {
            log.error("fail to find stock by itemCode{},cause by{}", itemCode, Throwables.getStackTraceAsString(e));
            response.setError("find.item.stock.error");
        }
        return response;
    }

    @Override
    public Response<List<ItemModel>> findStocksByItemCodes(List<String> itemCodes) {
        Response<List<ItemModel>> response = new Response<>();
        if (itemCodes == null || itemCodes.size() == 0) {
            response.setResult(Collections.<ItemModel>emptyList());
            return response;
        }
        try {
            List<ItemModel> stockByItemCode = itemDao.findStocksByItemCodes(itemCodes);
            response.setResult(stockByItemCode);
        } catch (Exception e) {
            log.error("fail to find stock by itemCode{},cause by{}", itemCodes, Throwables.getStackTraceAsString(e));
            response.setError("find.item.stock.error");
        }
        return response;
    }


    @Override
    public Response<Boolean> updateStockForOrder(Map<String, Long> itemModelMap) {
        Response<Boolean> response = Response.newResponse();
        try {
            Integer count = itemManager.updateStock(itemModelMap);
            if (count > 0) {
                response.setResult(true);
                return response;
            } else {
                response.setError("库存已没有");
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("updateStock.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("updateStock.item.error");
        }
        return response;
    }


    @Override
    public Response<Boolean> updateRollBackStockForJF(Map<String, Integer> map, User user) {
        Response<Boolean> response = Response.newResponse();
        try {
            int ret = itemManager.updateRollBackStockForJF(map, user);
            if (ret < 0) {
                log.error("update.item.error,cause:库存回滚失败");
                response.setError("update.item.error:库存回滚失败");
                return response;
            }
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("update.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    @Override
    public Response<List<String>> findItemCodeListByMidOrXid(String midOrXid) {
        Response<List<String>> response = Response.newResponse();
        try {
            List<String> itemCodeList = itemDao.findLikeMidOrXid(midOrXid);
            response.setResult(itemCodeList);
            return response;
        } catch (Exception e) {
            log.error("ItemServiceImpl.findItemCodeListByMidOrXid.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("ItemServiceImpl.findItemCodeListByMidOrXid.error");
            return response;
        }

    }

    /**
     * Description : 根据xids 获取单品数据 MAL104
     *
     * @param
     * @return
     * @author xiewl
     */
    @Override
    public Response<List<ItemGoodsDetailDto>> findByXids(List<String> xids) {
        Response<List<ItemGoodsDetailDto>> response = new Response<>();
        List<ItemGoodsDetailDto> dtos = Lists.newArrayList();
        try {
            List<ItemModel> itemModels = itemDao.findItemByXids(xids);
            List<String> goodsCodes = Lists.transform(itemModels, new Function<ItemModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable ItemModel input) {
                    return input.getGoodsCode();
                }
            });
            List<GoodsModel> goodsList = goodsDao.findGoodsListByItemCodeList(goodsCodes);
            Map<String, GoodsModel> goodsModelHashMap = Maps.uniqueIndex(goodsList, new Function<GoodsModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable GoodsModel input) {
                    return input.getCode();
                }
            });
            for (ItemModel itemModel : itemModels) {
                ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
                BeanUtils.copyProperties(itemGoodsDetailDto, itemModel);
                //调用共通方法，查找单品最高期数
                Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
                GoodsModel goodsModel = goodsModelHashMap.get(itemModel.getGoodsCode());
                if (goodsModel != null) {
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName());
                    itemGoodsDetailDto.setVendorId(goodsModel.getVendorId());// 供应商id
                    itemGoodsDetailDto.setGoodsType(goodsModel.getGoodsType());// 商品类型（00实物01虚拟02O2O）
                    if (StringUtils.isNotEmpty(goodsModel.getPointsType())) {
                        itemGoodsDetailDto.setPointsType(goodsModel.getPointsType());// 积分类型id
                    }
                    itemGoodsDetailDto.setGoodsBrandName(goodsModel.getGoodsBrandName());// 品牌名称
                    itemGoodsDetailDto.setChannelCc(goodsModel.getChannelCc());// CC状态
                    itemGoodsDetailDto.setChannelIvr(goodsModel.getChannelIvr());// ivr状态
                    // 名称加上属性
                    itemGoodsDetailDto.setGoodsName(goodsModel.getName() + buildItemName(itemModel));
                }
                itemGoodsDetailDto.setMaxNumber(maxInstallmentNumber.toString());
                BigDecimal newPrice = itemModel.getPrice();
                itemGoodsDetailDto.setPrice(newPrice.divide(new BigDecimal(maxInstallmentNumber), 2, BigDecimal.ROUND_HALF_UP));// 分期价格
                dtos.add(itemGoodsDetailDto);
            }
            response.setSuccess(true);
            response.setResult(dtos);
        } catch (Exception e) {
            log.error("itemServiceImpl.findByXids.error");
            response.setSuccess(false);
            response.setError("数据库操作异常");
        }
        return response;
    }


    @Override
    public Response<List<GoodFullDto>> findIntegrateAreaGoods(List<String> itemIds) {
        Response<List<GoodFullDto>> response = Response.newResponse();
        List<GoodFullDto> goodFullDtos = Lists.newArrayList();
        if(itemIds==null || itemIds.isEmpty()){
            response.setResult(Collections.EMPTY_LIST);
            return response;
        }
        try {

            List<ItemModel> itemModelLists = itemDao.findGoodsCodeListByItemCodeList(itemIds);// 单品

            ImmutableMap<String, ItemModel> itemMap = Maps.uniqueIndex(itemModelLists, new Function<ItemModel, String>() {
                @Override
                public String apply(ItemModel input) {
                    return input.getCode();
                }
            });

            List<String> goodsCodeList = Lists.transform(itemModelLists, new Function<ItemModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable ItemModel input) {
                    return input.getGoodsCode();
                }
            });

            List<GoodsModel> goodsModelList = goodsDao.findGoodsListByItemCodeList(goodsCodeList);// 商品

            ImmutableMap<String, GoodsModel> goodsMap = Maps.uniqueIndex(goodsModelList, new Function<GoodsModel, String>() {
                @Override
                public String apply(GoodsModel input) {
                    return input.getCode();
                }
            });

            //根据itemcodelist查询出tbl_goods_payway 对应的金普积分
            Map<String, Object> params = Maps.newHashMap();
            params.put("itemList", itemIds);
            params.put("memberLevel", Contants.MEMBER_LEVEL_JP_CODE);
            List<TblGoodsPaywayModel> paywayModelList = tblGoodsPaywayDao.findByGoodsIdListNoOrder(params);

            ImmutableMap<String, TblGoodsPaywayModel> paywayMap = Maps.uniqueIndex(paywayModelList, new Function<TblGoodsPaywayModel, String>() {
                @Override
                public String apply(TblGoodsPaywayModel input) {
                    return input.getGoodsId();
                }
            });

            GoodFullDto goodFullDto;
            for (String code : itemIds) {
                goodFullDto = new GoodFullDto();
                ItemModel itemModel = itemMap.get(code);//单品model
                goodFullDto.setDefaultItem(itemModel);
                goodFullDto.setGoodsModel(goodsMap.get(itemModel.getGoodsCode()));
                goodFullDto.setGoodsPaywayModel(paywayMap.get(code)); //支付方式model
                goodFullDtos.add(goodFullDto); //结果list
            }
            response.setResult(goodFullDtos);
        } catch (Exception e) {
            log.error("findIntegrateAreaGoods.item.error,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("findIntegrateAreaGoods.item.error");
        }
        return response;
    }
	 @Override
	    public Response<List<String>> findItemCodesByItemCode(String itemCode) {
		Response<List<String>> response = Response.newResponse();
	        try {
	            List<String> itemCodeList = itemDao.findItemCodesByItemCode(itemCode);
	            response.setResult(itemCodeList);
	            return response;
	        } catch (Exception e) {
	            log.error("ItemServiceImpl.findItemCodesByItemCode.error,cause:{}", Throwables.getStackTraceAsString(e));
	            response.setError("ItemServiceImpl.findItemCodesByItemCode.error");
	            return response;
	        }
	    }

    @Override
    public Response<Boolean> updateStock(String actId,String actType, Integer periodId, String goodsId, Integer goodsNum, String createOper, Long bonusTotalvalue, ItemModel itemModel) {
        Response<Boolean> response = new Response<>();
        try {
            itemManager.updateStockForOrderTrade( actId, actType, periodId, goodsId, goodsNum, createOper, bonusTotalvalue, itemModel);
            response.setSuccess(true);
        }catch (Exception e){
            log.error("updateStock: {}", e);
            response.setSuccess(false);
        }
        return response;
    }


}