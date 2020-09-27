package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.ItemsAttributeDto;
import cn.com.cgbchina.item.dto.ItemsAttributeSkuDto;
import cn.com.cgbchina.item.manager.ItemManager;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

import static com.google.common.base.Preconditions.checkNotNull;

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
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    @Override
    public Response<Long> create(ItemModel item) {
        return null;
    }

    @Override
    public Response<Boolean> delete(ItemModel item) {
        return null;
    }

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
    public Response<Pager<ItemModel>> find(@Param("pageNo") Integer pageNo) {
        return null;
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
    public Response<List<ItemDto>> findItemListByCodeOrName(String searchKey) {
        Response<List<ItemDto>> itemResponse = new Response<List<ItemDto>>();
        List<ItemModel> itemList = new ArrayList<ItemModel>();
        List<ItemDto> itemDtoList = new ArrayList<ItemDto>();
        // 根据商品或单品编码取得单品列表
        itemList = itemDao.findItemListByGoodsOrItemCode(searchKey);
        // 当以商品或单品编码为条件的检索结果为空时，再以名称进行模糊检索
        if (itemList == null || itemList.size() == 0) {
            // 按商品名称取得商品CODE列表
            List<String> codeList = goodsDao.findGoodsByGoodsName(searchKey);
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
                String attr = itemList.get(cnt).getAttribute();
                ItemsAttributeDto itemsAttributeDto = jsonMapper.fromJson(attr, ItemsAttributeDto.class);
                List<ItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
                StringBuffer itemDec = new StringBuffer();
                // 商品名称
                for (int i = 0; i < goodsModelList.size(); i++) {
                    if (itemList.get(cnt).getGoodsCode().equals(goodsModelList.get(i).getCode())) {
                        itemDec.append(goodsModelList.get(i).getName());
                        break;
                    }
                }
                // 单品描述
                for (ItemsAttributeSkuDto sku : skus) {
                    itemDec.append(sku.getValues().get(0).getAttributeValueName());
                }
                ItemDto itemDto = new ItemDto();
                itemDto.setItemModel(itemList.get(cnt));
                itemDto.setItemDescription(itemDec.toString());
                itemDtoList.add(itemDto);
            }
        }

        itemResponse.setResult(itemDtoList);
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
            response.setError("findByCodes.item.error");
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
    public Response<List<ItemGoodsDetailDto>> findByIds(List<String> ids) {
        Response<List<ItemGoodsDetailDto>> response = new Response<List<ItemGoodsDetailDto>>();
        if (ids == null || ids.size() == 0) {
            response.setResult(Collections.<ItemGoodsDetailDto>emptyList());
            return response;
        }
        try {
            List<ItemModel> itemModelList = itemDao.findNoCode(ids);
            List<ItemGoodsDetailDto> itemGoodsList = new ArrayList<ItemGoodsDetailDto>();
            List<GoodsModel> goodsList = new ArrayList<GoodsModel>();
            goodsList = goodsDao.getGoodsNameByItemId(itemModelList);

            List<ItemGoodsDetailDto> itemModelResult = new ArrayList<ItemGoodsDetailDto>();
            for (ItemModel itemModel : itemModelList) {
                ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
                BeanUtils.copyProperties(itemGoodsDetailDto, itemModel);
                String maxNumber = "";
                String[] numberList = new String[10];
                if (itemModel.getInstallmentNumber() != null) {
                    numberList = itemModel.getInstallmentNumber().split(",");
                    maxNumber = numberList[numberList.length - 1];
                }
                for (GoodsModel model : goodsList) {
                    if (itemModel.getGoodsCode().equals(model.getCode())) {
                        itemGoodsDetailDto.setGoodsName(model.getName());
                        break;
                    }
                }
                //名称加上属性
                ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
                itemsAttributeDto = jsonMapper.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
                if (itemsAttributeDto != null) {
                    List<ItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
                    // 根据商品编码取得商品信息
                    // 单品描述
                    StringBuffer sb = new StringBuffer();
                    sb.append(itemGoodsDetailDto.getGoodsName());
                    for (ItemsAttributeSkuDto sku : skus) {
                        sb.append(" " + sku.getValues().get(0).getAttributeValueName());
                    }
                    // 单品信息设定
                    itemGoodsDetailDto.setGoodsName(sb.toString());

                    String newName = itemGoodsDetailDto.getGoodsName();
                    if (newName.length() > 25) {
                        newName = newName.substring(0, 24) + "...";
                    }
                    itemGoodsDetailDto.setGoodsName(newName);
                }

                itemGoodsDetailDto.setMaxNumber(maxNumber);
                itemModelResult.add(itemGoodsDetailDto);
            }
            response.setResult(itemModelResult);
        } catch (Exception e) {
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
    public Response<Map<String, Object>> findByIdList(@Param("id1s") List<String> id1s, @Param("id2s") List<String> id2s, @Param("id3s") List<String> id3s) {
        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
        Map<String, Object> mapParam = Maps.newHashMap();
        List<ItemGoodsDetailDto> list1 = new ArrayList<ItemGoodsDetailDto>();
        List<ItemGoodsDetailDto> list2 = new ArrayList<ItemGoodsDetailDto>();
        List<ItemGoodsDetailDto> list3 = new ArrayList<ItemGoodsDetailDto>();
        try {
            list1 = findByIds(id1s).getResult();
            list2 = findByIds(id2s).getResult();
            list3 = findByIds(id3s).getResult();
            mapParam.put("id1List", list1);
            mapParam.put("id2List", list2);
            mapParam.put("id3List", list3);
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
    public Response<Map<String, Object>> findGoodsAndBrands(@Param("id1s") List<String> id1s, @Param("id2s") List<Long> id2s) {
        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
        Map<String, Object> mapParam = Maps.newHashMap();
        List<ItemGoodsDetailDto> list1 = new ArrayList<ItemGoodsDetailDto>();
        List<GoodsBrandModel> list2 = new ArrayList<GoodsBrandModel>();
        try {
            list1 = findByIds(id1s).getResult();
            list2 = brandService.findByIds(id2s).getResult();
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
     * 查询置顶商品
     *
     * @return add by liuhan
     */
    @Override
    public Response<Pager<ItemDto>> findAllstickFlag(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
                                                     @Param("code") String code, @Param("itemName") String itemName) {
        Response<Pager<ItemDto>> response = new Response<Pager<ItemDto>>();
        List<String> goodsCode = new ArrayList<String>();
        Map<String, Object> paramMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, 10);
        List<ItemDto> model = Lists.newArrayList();
        ItemDto itemDto = null;
        try {
            // 查询条件
            paramMap.put("offset", pageInfo.getOffset());
            paramMap.put("limit", pageInfo.getLimit());
            if (!Strings.isNullOrEmpty(code)) {
                paramMap.put("code", code);
            }
            Pager<ItemModel> pager = itemDao.findAllstickFlagPager(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
            if (pager.getTotal() > 0) {
                List<ItemModel> itemList = pager.getData();
                // 对查出的itemModelList进行循环
                ItemsAttributeDto itemsAttributeDto = null;// 用于存放与单品属性相关的DTO
                Boolean isContain = false;
                for (ItemModel itemModel : itemList) {
                    String itemDescription = null;
                    String a = null;
                    // 处理单品相关的销售属性信息
                    if (StringUtils.isNotEmpty(itemModel.getAttribute())) {
                        itemsAttributeDto = new ItemsAttributeDto();
                        itemDto = new ItemDto();
                        itemsAttributeDto = jsonMapper.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
                        GoodsModel goodsName = goodsDao.findById(itemModel.getGoodsCode());
                        if (goodsName != null) {
                            itemDescription = goodsName.getName() + " ";
                        }
                        for (int i = 0; i < itemsAttributeDto.getSkus().size(); i++) {
                            a = itemsAttributeDto.getSkus().get(i).getValues().get(0).getAttributeValueName();
                            itemDescription += a + " ";
                        }
                        itemDto.setGoodsModel(goodsName);
                        itemDto.setItemsAttributeDto(itemsAttributeDto);
                        itemDto.setItemModel(itemModel);
                        if (!Strings.isNullOrEmpty(itemName)) {
                            isContain = itemDescription.contains(itemName);
                            if (isContain) {
                                itemDto.setItemDescription(itemDescription);
                                model.add(itemDto);
                            }
                        } else {
                            itemDto.setItemDescription(itemDescription);
                            model.add(itemDto);
                        }
                    }
                }
            }
            response.setResult(new Pager<ItemDto>(pager.getTotal(), model));
            return response;
        } catch (Exception e) {
            log.error("brand.query.error,cauese:{}", Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 查询置顶商品显示顺序
     *
     * @return add by liuhan
     */
    @Override
    public Response<Integer> findAllstickOrder() {
        Response<Integer> response = new Response<Integer>();
        List<ItemModel> itemList = new ArrayList<ItemModel>();
        List<Integer> stickRrder = new ArrayList<Integer>();
        int i = 0;
        try {
            itemList = itemDao.findAllstickFlag();
            for (int k = 0; k < itemList.size(); k++) {
                stickRrder.add(itemList.get(k).getStickOrder());
            }
            for (i = 1; i <= 9999; i++) {
                if (!stickRrder.contains(i)) {
                    response.setResult(i);
                    break;
                }
            }
        } catch (Exception e) {
            log.error("brand.query.error,cauese:{}", Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    /**
     * 新增置顶
     *
     * @param itemModel
     * @return add by liuhan
     */
    @Override
    public Response<Boolean> updateadd(ItemModel itemModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {

            ItemModel itme = itemDao.findById(itemModel.getCode());
            if (itme.getStickFlag() == 0) {
                Integer count = itemManager.update(itemModel);
                if (count > 0) {
                    response.setResult(true);
                    return response;
                }
            } else {
                response.setResult(false);
                return response;
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update.item.error,cauese:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;

    }

    /**
     * 修改置顶
     *
     * @param itemModel
     * @return add by liuhan
     */
    @Override
    public Response<Boolean> updateEdit(ItemModel itemModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            List<ItemModel> itemModelList = itemDao.findAllstickFlag();
            List<Integer> list = new ArrayList<Integer>();
            for (int i = 0; i < itemModelList.size(); i++) {
                list.add(itemModelList.get(i).getStickOrder());
            }
            if (list.contains(itemModel.getStickOrder())) {
                response.setResult(false);
                return response;
            }
            Integer count = itemManager.update(itemModel);
            if (count > 0) {
                response.setResult(true);
                return response;
            } else {
                response.setResult(false);
                return response;
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update.item.error,cauese:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    /**
     * 删除置顶
     *
     * @param itemModel
     * @return add by liuhan
     */
    @Override
    public Response<Boolean> updateDel(ItemModel itemModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            Integer count = itemManager.update(itemModel);
            if (count > 0) {
                response.setResult(true);
                return response;
            } else {
                response.setResult(false);
                return response;
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update.item.error,cauese:{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
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

    /**
     * 微信商品顺序check
     *
     * @param order
     * @return
     * @author TanLiang
     * @time 2016-6-15
     */
    @Override
    public Long wxOrderCheck(Long order) {
        Long total = itemDao.wxOrderCheck(order);
        return total;
    }

    /**
     * 测试取得商品列表
     *
     * @return
     */
    public Response<List<ItemModel>> getItemListTest() {
        Response<List<ItemModel>> result = new Response<>();
        try {
            List<ItemModel> list = itemDao.getItemListTest();
            result.setResult(list);
            return result;
        } catch (Exception e) {
            result.setError("ItemService.getItemListTest.fail");
            return result;
        }
    }
}