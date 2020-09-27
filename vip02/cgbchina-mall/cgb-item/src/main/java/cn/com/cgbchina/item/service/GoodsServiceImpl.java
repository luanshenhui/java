package cn.com.cgbchina.item.service;

import static cn.com.cgbchina.item.model.GoodsModel.Status.ON_SHELF;
import static com.google.common.base.Objects.equal;
import static com.google.common.base.Preconditions.checkNotNull;
import static com.google.common.base.Strings.isNullOrEmpty;
import static com.spirit.util.Arguments.isEmpty;
import static com.spirit.util.Arguments.isNull;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

import cn.com.cgbchina.generator.IdEnum;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.*;
import lombok.extern.slf4j.Slf4j;

import org.elasticsearch.common.recycler.Recycler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dao.AuditLoggingDao;
import cn.com.cgbchina.item.dao.BrandAuthorizeDao;
import cn.com.cgbchina.item.dao.EspAreaInfDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.ServicePromiseDao;
import cn.com.cgbchina.item.dao.TblCfgIntegraltypeDao;
import cn.com.cgbchina.item.indexer.ItemRealTimeIndexer;
import cn.com.cgbchina.item.manager.GoodsManager;
import cn.com.cgbchina.item.manager.PointPoolManager;
import cn.com.cgbchina.item.model.AuditLoggingModel;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.MailStatesService;
import cn.com.cgbchina.user.service.VendorService;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Collections2;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.html.HtmlEscapers;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.Forest;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.search.Pair;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;

@Service
@Slf4j
public class GoodsServiceImpl implements GoodsService {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    @Resource
    private GoodsDao goodsDao;
    @Resource
    private BrandService brandService;
    @Resource
    private ItemDao itemDao;
    @Resource
    private ServicePromiseDao servicePromiseDao;
    @Resource
    private GoodsManager goodsManager;
    @Resource
    private VendorService vendorService;
    @Resource
    private AuditLoggingDao auditLoggingDao;
    @Autowired
    private MailStatesService mailStatesService;
    @Autowired
    private ItemService itemService;
    @Resource
    private TblCfgIntegraltypeDao tblCfgIntegraltypeDao;
    @Resource
    private PointPoolManager pointPoolManager;
    @Autowired
    private SpuService spuService;
    @Autowired
    private BackCategoryHierarchy bch;
    @Autowired
    private ItemRealTimeIndexer itemRealTimeIndexer;
    @Resource
    private EspAreaInfDao espAreaInfDao;// 礼品分区 Dao
    @Autowired
    private BrandAuthorizeDao brandAuthorizeDao;
    @Resource
    private IdGenarator idGenarator;


    private static final String APPROVE_RESULT_PASS = "pass";// 审核结果标识：通过
    private static final String STICK_ITEM_00 = "00";
    private static final String STICK_ITEM_01 = "01";
    private static final String STICK_ITEM_02 = "02";
    private static final String APPROVE_TYPE_2 = "2";// 审核类型标识:初审
    private static final String APPROVE_TYPE_3 = "3";// 审核类型标识:复审
    private static final String APPROVE_TYPE_4 = "4";// 审核类型标识:商品信息变更审核
    private static final String APPROVE_TYPE_5 = "5";// 审核类型标识:价格变更审核
    private static final String APPROVE_TYPE_6 = "6";// 审核类型标识:下架申请审核审核
    private final Splitter splitter = Splitter.on(',').trimResults();

    private final LoadingCache<String, GoodsModel> cacheGoods
            = CacheBuilder.newBuilder().expireAfterWrite(5L, TimeUnit.MINUTES).build(
            new CacheLoader<String, GoodsModel>() {
                @Override
                public GoodsModel load(String goodsId) throws Exception {
                    return goodsDao.findById(goodsId);
                }
            });

    @Override
    public Response<Map<String, Object>> findGoodList(Integer pageNo, Integer size, String channel, User user, Map<String, String> params) {
        Response<Map<String, Object>> result = Response.newResponse();
        Map<String, Object> returnMap = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);

        //检索条件
        Map<String, Object> selectParam = Maps.newHashMap();
        params.put("type", params.get("type"));

        // 渠道不存在
        ChannelType channelType = ChannelType.from(channel);
        if (isNull(channelType)) {
            log.error("channel is not existed,channel code:{}", channel);
            result.setError("channel.not.existed");
            return result;
        }
        selectParam.put("ordertypeId", channelType.value());

        // 筛选查询条件
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (!Strings.isNullOrEmpty(entry.getValue())) {
                selectParam.put(entry.getKey(), HtmlEscapers.htmlEscaper().escape(entry.getValue()));
            }
        }

        // TODO 修改 商品编码查询 根据（mid或xid）查询，商品、礼品列表信息 add by zhoupeng
        //传过来的code为5位的编码
        if (selectParam.containsKey("code")) {
            List<String> goodsCodes = midToGoodsCodes(selectParam.get("code"), channel);
            if (null != goodsCodes && !goodsCodes.isEmpty()) {
                selectParam.put("codes", goodsCodes);
                selectParam.remove("code");
            }
        }
        // 供应商平台查询 判断 add by zhoupeng
        String id = user.getVendorId();
        if (!Strings.isNullOrEmpty(id)) {
            selectParam.put("vendorId", id);
        }
        // 类目查询 add by zhoupeng
        if (selectParam.containsKey("backCategory3Id")) {
            List<Long> spuIds = findSpusByCategoryId(String.valueOf(selectParam.get("backCategory3Id")));
            if(null != spuIds && !spuIds.isEmpty()) {
                selectParam.put("productIds", spuIds); // spuIds
            }else{
                returnMap.put("pager", new Pager<>(0L, Collections.<GoodsInfoDto>emptyList()));
                result.setResult(returnMap);
                return result;
            }
        }

        // 供应商信息
        VendorInfoModel vendorInfoModel=new VendorInfoModel();
        vendorInfoModel.setBusinessTypeId(channel);
        Response<List<VendorInfoModel>> vendorInfoModelResponse = vendorService.findAll(vendorInfoModel);
        List<VendorInfoModel> vendorInfoList = Lists.newArrayList();
        if (vendorInfoModelResponse.isSuccess()) {
            vendorInfoList = vendorInfoModelResponse.getResult();
        }
        returnMap.put("vendors", vendorInfoList);
        Map<String, VendorInfoModel> vendorInfoModelMap = Maps.uniqueIndex(vendorInfoList, new Function<VendorInfoModel, String>() {
            @NotNull
            @Override
            public String apply(@NotNull VendorInfoModel input) {
                return input.getVendorId();
            }
        });

        // 品牌信息
        Response<List<GoodsBrandModel>> brandModelResponse = brandService.allBrandsByChannel(channel);
        List<GoodsBrandModel> brandList = Lists.newArrayList();
        if (brandModelResponse.isSuccess()) {
            brandList = brandModelResponse.getResult();
            returnMap.put("brands", brandList);
        }

        Map<Long, GoodsBrandModel> brandListMap = Maps.uniqueIndex(brandList, new Function<GoodsBrandModel, Long>() {
            @Override
            public Long apply(GoodsBrandModel input) {
                return input.getId();
            }
        });
        try {
            Pager<GoodsModel> pager = goodsDao.findByPage(selectParam, pageInfo.getOffset(), pageInfo.getLimit());
            GoodsInfoDto goodsInfoDto = null;
            List<GoodsInfoDto> goodsInfoList = Lists.newArrayList();
            if (pager.getTotal() > 0) {
                List<GoodsModel> goodsList = pager.getData();
                // 将数据循环并加入品牌名称及后台类目信息，整合为goodsInfoList
                for (GoodsModel goodsModel : goodsList) {
                    goodsInfoDto = new GoodsInfoDto();
                    goodsInfoDto.setGoods(goodsModel);
                    GoodsBrandModel brandModel = brandListMap.get(goodsModel.getGoodsBrandId());
                    if (brandModel != null) {
                        goodsInfoDto.setBrandName(brandModel.getBrandName());
                    }
                    goodsInfoDto.setModifyTimeLong(String.valueOf(goodsModel.getModifyTime().getTime()));// 修改时间
                    final String vendorId = goodsModel.getVendorId();
                    VendorInfoModel vendorInfoModel1 = vendorInfoModelMap.get(vendorId);
                    if (vendorInfoModel1 != null) {
                        goodsInfoDto.setVendorName(vendorInfoModel1.getSimpleName());
                    }

                    goodsInfoList.add(goodsInfoDto);
                }
                returnMap.put("pager", new Pager<>(pager.getTotal(), goodsInfoList));
            } else {
                returnMap.put("pager", new Pager<>(0L, Collections.<GoodsInfoDto>emptyList()));
            }
            result.setResult(returnMap);
            return result;
        } catch (Exception e) {
            log.error("find goods list error{}", Throwables.getStackTraceAsString(e));
            result.setError("find.goods.list.error");
        }
        return result;
    }

    /**
     * 查询 goodsCodes
     *
     * @param midOrXid 查询条件
     * @param channel  渠道信息
     * @return list
     * Add by zhoupeng
     */
    private List<String> midToGoodsCodes(Object midOrXid, String channel) {
        Map<String, Object> params = Maps.newHashMap();
        params.put("midOrXid", midOrXid);
        params.put("channel", channel);
        return itemDao.findGoodsCodesbyMidOrXid(params);
    }




    /**
     * 查看 初审复审 1 2 3
     *
     * @param type
     * @param goodsCode
     * @return
     */
    public Response<GoodFullDto> findDetail_new(String type, String goodsCode) {
        Response<GoodFullDto> result = new Response<>();
        GoodsModel goodsModel = goodsDao.findById(goodsCode);
        // type 用于区分是审核还是查看
        // 其中 type为 时是点击审核相关按钮进入，type为1是点击查看进入
        GoodFullDto goodFullDto;
        try {
            if (ImmutableList.of("1", "2", "3", "6").contains(type)) {
                List<ItemModel> itemModelList = MoreObjects.firstNonNull(itemDao.findItemDetailByGoodCode(goodsCode), Collections.<ItemModel>emptyList());
                goodFullDto = goodInfoView(goodsModel, itemModelList);
            } else if ("5".equals(type)) {//价格变更审核
                String approveDifferent = goodsModel.getApproveDifferent();
                List<ItemModel> itemModelList = MoreObjects.firstNonNull(itemDao.findItemDetailByGoodCode(goodsCode), Collections.<ItemModel>emptyList());
                GoodFullDto temp = jsonMapper.fromJson(approveDifferent, GoodFullDto.class);
                List<ItemModel> priceChangeList = temp.getItemList();
                if (priceChangeList != null && priceChangeList.size() != 0) {
                    ImmutableMap<String, ItemModel> changeMap = Maps.uniqueIndex(priceChangeList, new Function<ItemModel, String>() {
                        @Override
                        public String apply(ItemModel itemModel) {
                            return itemModel.getCode();
                        }
                    });
                    for (ItemModel item : itemModelList) {
                        ItemModel itemModel = changeMap.get(item.getCode());
                        item.setPrice(itemModel.getPrice());
                        item.setMarketPrice(itemModel.getMarketPrice());
                        item.setFixPoint(itemModel.getFixPoint());//可能更改的值
                    }
                }
                //处理单品单价
                goodFullDto = goodInfoView(goodsModel, itemModelList);
            } else {
                //商品变更审核
                List<ItemModel> itemModelList = MoreObjects.firstNonNull(itemDao.findItemDetailByGoodCode(goodsCode), Collections.<ItemModel>emptyList());
                ImmutableMap<String, ItemModel> modelMap = Maps.uniqueIndex(itemModelList, new Function<ItemModel, String>() {
                    @Override
                    public String apply(ItemModel itemModel) {
                        return itemModel.getCode();
                    }
                });
                String approveDifferent = goodsModel.getApproveDifferent();
                GoodFullDto temp = jsonMapper.fromJson(approveDifferent, GoodFullDto.class);
                List<ItemModel> tempItemList = temp.getItemList();
                for (ItemModel tempItem : tempItemList) {
                    tempItem.setMid(modelMap.get(tempItem.getCode()).getMid());
                }
                goodFullDto = goodInfoView(temp.getGoodsModel(), temp.getItemList());
            }
            result.setResult(goodFullDto);

        } catch (Exception e) {
            log.error("find goods detail view error{}", Throwables.getStackTraceAsString(e));
            result.setError("find.goods.detail.view.error");
        }
        return result;
    }

    private GoodFullDto goodInfoView(GoodsModel goodsModel, List<ItemModel> itemModelList) {
        GoodFullDto goodFullDto = new GoodFullDto();
        // 供应商信息
        Response<VendorInfoDto> vendorResponse = vendorService.findById(goodsModel.getVendorId());
        if (vendorResponse.isSuccess()) {
            goodFullDto.setVendorInfoModel(vendorResponse.getResult());
        }

        Response<List<Pair>> categoryRe = findCategoryByGoodsCode(goodsModel.getCode());
        if (categoryRe.isSuccess() && categoryRe.getResult().size() >= 4) {
            List<Pair> categoryList = categoryRe.getResult();
            for (int i = 1; i < categoryList.size(); i++) {
                try {
                    Method method = goodFullDto.getClass().getMethod("setBackCategory" + i + "Name", String.class);
                    method.invoke(goodFullDto, categoryList.get(i).getName());
                } catch (Exception e) {
                    e.printStackTrace();
                    log.error("no such method error", e);//won't happen
                }
            }
        }

        //礼品分区
        if (!Strings.isNullOrEmpty(goodsModel.getRegionType())) {
            EspAreaInfModel model = espAreaInfDao.findEspAreaInfByAreaId(goodsModel.getRegionType());
            goodFullDto.setEspAreaInfModel(model);
        }

        // 查询积分类型信息
        if (!Strings.isNullOrEmpty(goodsModel.getPointsType())) {
            TblCfgIntegraltypeModel tblCfgIntegraltypeModel = tblCfgIntegraltypeDao.findById(goodsModel.getPointsType());
            goodFullDto.setIntegralTypeModel(tblCfgIntegraltypeModel);
        }

        goodFullDto.setGoodsModel(goodsModel);//商品Model

        //服务承诺处理
        if (!Strings.isNullOrEmpty(goodsModel.getServiceType())) {
            List<String> servicePromiseIsSelectIds = Splitter.on(",").omitEmptyStrings().trimResults().splitToList(goodsModel.getServiceType());
            List<ServicePromiseModel> servicePromiseIsSelectList = servicePromiseDao.findListByIds(servicePromiseIsSelectIds);
            String servicepromiseStr = Joiner.on(";").skipNulls().join(Collections2.transform(servicePromiseIsSelectList, new Function<ServicePromiseModel, String>() {
                @Override
                public String apply(ServicePromiseModel servicePromiseModel) {
                    return servicePromiseModel.getName();
                }
            }));
            goodFullDto.setServicePromiseStr(servicepromiseStr);
        }

        goodFullDto.setItemList(itemModelList);
        // 推荐关联单品
        List<RecommendGoodsDto> recommendGoodsList = Lists.newArrayList();
        if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods1Code())) {
            recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods1Code()).getResult());
        }
        if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods2Code())) {
            recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods2Code()).getResult());
        }
        if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods3Code())) {
            recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods3Code()).getResult());
        }
        goodFullDto.setRecommendGoodsList(recommendGoodsList);
        // 操作履历,审核
        List<AuditLoggingModel> auditLoggingModelList = auditLoggingDao.findByOuterId(goodsModel.getCode());
        goodFullDto.setAuditLoggingModelList(auditLoggingModelList);
        return goodFullDto;
    }



    @Override
    public Response<Boolean> createGoods(GoodsModel goodsModel, List<ItemModel> itemList, String vendorNo, String channel) {
        Response<Boolean> result = Response.newResponse();
        if (Strings.isNullOrEmpty(goodsModel.getVendorId())) {
            log.error("userId can not be null");
            result.setError("vendor.id.not.null.fail");
            return result;
        }

        if (Strings.isNullOrEmpty(goodsModel.getName())) {
            log.error("goods name can not be empty");
            result.setError("goods.name.empty");
            return result;
        }

        if (itemList == null || itemList.isEmpty()) {
            log.error("itemList can not be null or empty");
            result.setError("illegal.param");
            return result;
        }
        try {
            goodsManager.createGoods(goodsModel, itemList, channel);
            result.setResult(Boolean.TRUE);
        } catch (Exception e) {
            log.error("insert.goods.error{}", Throwables.getStackTraceAsString(e));
            result.setError("insert.goods.error");
        }
        return result;
    }

    /**
     * 更新单品信息
     *
     * @param itemModel
     * @return
     */
    @Override
    public Response<Integer> updateItemDetail(ItemModel itemModel) {
        Response<Integer> response = new Response<Integer>();
        try {
            checkNotNull(itemModel, "itemModel is null");
            Integer count = goodsManager.updateItemDetail(itemModel);
            response.setResult(count);
            return response;
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update item detail error{}", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    /**
     * 更新商品上下架信息
     *
     * @param goodsModel
     * @return
     */
    @Override
    public Response<Integer> updateGoodsShelf(GoodsModel goodsModel, String channels, String state) {
        Response<Integer> response = new Response<Integer>();
        if (goodsModel == null) {
            log.error("goods model is null");
            response.setError("goods.not.null");
            return response;
        }

        if (Strings.isNullOrEmpty(state)) {
            log.error("state is null,cause:{}", state);
            response.setError("channel.not.exist");
            return response;
        }

        // 上架操作时，对下架 更新为 自动下架时间 add by zhoupeng
        GoodsModel queryModel = goodsDao.findById(goodsModel.getCode());
        Date autoOffShelfTime = queryModel.getAutoOffShelfTime();

        List<String> strings = Splitter.on(",").omitEmptyStrings().splitToList(channels);
        GoodsModel.Status goodsStatus = GoodsModel.Status.fromNumber(state);
        for (String channel : strings) {
            if (isNull(GoodsModel.GoodsChannel.from(channel))) {
                log.error("channel.not.exist,channel:{}", channel);
                response.setError("channel.not.exist");
                return response;
            }
            switch (GoodsModel.GoodsChannel.from(channel)) {
                case CHANNEL_MALL:   // 广发商城渠道
                    goodsModel.setChannelMall(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfMallDate(new Date());// 上架状态更新上架时间
                        goodsModel.setOffShelfMallDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfMallDate(new Date());// 下架状态更新下架时间
                    }
                    break;
                case CHANNEL_CC:   // CC渠道
                    // CC渠道
                    goodsModel.setChannelCc(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfCcDate(new Date());
                        goodsModel.setOffShelfCcDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfCcDate(new Date());
                    }
                    break;
                case CHANNEL_MALL_WX:   // 广发商城微信渠道
                    goodsModel.setChannelMallWx(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfMallWxDate(new Date());
                        goodsModel.setOffShelfMallWxDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfMallWxDate(new Date());
                    }
                    break;
                case CHANNEL_PHONE:   // 手机商城渠道
                    goodsModel.setChannelPhone(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfPhoneDate(new Date());
                        goodsModel.setOffShelfPhoneDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfPhoneDate(new Date());
                    }
                    break;
                case CHANNEL_CREDIT_WX:   // 卡中心微信渠道
                    goodsModel.setChannelCreditWx(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfCreditWxDate(new Date());
                        goodsModel.setOffShelfCreditWxDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfCreditWxDate(new Date());
                    }
                    break;
                case CHANNEL_APP:   // app渠道
                    goodsModel.setChannelApp(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfAppDate(new Date());
                        goodsModel.setOffShelfAppDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfAppDate(new Date());
                    }
                    break;
                case CHANNEL_SMS:   // 短信渠道
                    goodsModel.setChannelSms(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfSmsDate(new Date());
                        goodsModel.setOffShelfSmsDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfSmsDate(new Date());
                    }
                    break;
                case CHANNEL_POINTS:  //积分商城渠道
                    goodsModel.setChannelPoints(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfPointsDate(new Date());
                        goodsModel.setOffShelfPointsDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfPointsDate(new Date());
                    }
                    break;
                case CHANNEL_IVR:  //IVR渠道
                    goodsModel.setChannelIvr(state);
                    if (equal(goodsStatus, ON_SHELF)) {
                        goodsModel.setOnShelfIvrDate(new Date());
                        goodsModel.setOffShelfIvrDate(autoOffShelfTime);
                    } else {
                        goodsModel.setOffShelfIvrDate(new Date());
                    }
                    break;
//                case ALL:
//                    goodsModel.setOnShelfMallDate(new Date());// 上架状态更新上架时间
//                    goodsModel.setChannelMall(state);
//                    goodsModel.setChannelCc(state);
//                    goodsModel.setOnShelfCcDate(new Date());
//                    goodsModel.setChannelMallWx(state);
//                    goodsModel.setOnShelfMallWxDate(new Date());
//                    goodsModel.setChannelPhone(state);
//                    goodsModel.setOnShelfPhoneDate(new Date());
//                    goodsModel.setChannelCreditWx(state);
//                    goodsModel.setOnShelfCreditWxDate(new Date());
//                    goodsModel.setChannelApp(state);
//                    goodsModel.setOnShelfAppDate(new Date());
//                    goodsModel.setChannelSms(state);
//                    goodsModel.setOnShelfSmsDate(new Date());
//                    goodsModel.setChannelPoints(state);
//                    goodsModel.setOnShelfPointsDate(new Date());
//                    goodsModel.setChannelIvr(state);
//                    goodsModel.setOnShelfIvrDate(new Date());
//                    break;
            }
        }

        try {
            checkNotNull(goodsModel, "goodsModel is null");
            Integer count = goodsManager.updateGoodsShelf(goodsModel);
            // 实时索引
            ItemMakeDto itemMakeDto = new ItemMakeDto();
            itemMakeDto.setGoodsCode(goodsModel.getCode());
            itemMakeDto.setStatus(ON_SHELF);
            itemRealTimeIndexer.index(itemMakeDto); // ON_SHELF("02", "上架"),OFF_SHELF("01", "下架"), DELETED("-1", "删除");
            response.setResult(count);
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update goods shelf error{}", Throwables.getStackTraceAsString(e));
            response.setError("update.goods.shelf.error");
        }
        return response;
    }

    /**
     * 更新商品状态
     *
     * @param goodsModel
     * @return
     */
    @Override
    public Response<Boolean> updataGdInfo(GoodsModel goodsModel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            checkNotNull(goodsModel, "goodsModel is Null");
            Boolean count = goodsManager.updateGoodsInfo(goodsModel);
            response.setResult(count);
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update goods info error{}", Throwables.getStackTraceAsString(e));
            response.setError("update.goods.error");
        }
        return response;
    }

    /**
     * 根据供应商ID下架该供应商下所有渠道的所有商品
     *
     * @param vendorId
     * @return
     */
    @Override
    public Response<Boolean> updateChannelByVendorId(String vendorId,String businessTypeId) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            checkNotNull(vendorId, "vendorId is Null");
            checkNotNull(businessTypeId,"businessTypeId is null");
            Integer count = goodsManager.updateChannelByVendorId(vendorId,businessTypeId);
            if (count < 0) {
                response.setResult(false);
                return response;
            } else {
                response.setResult(true);
                return response;
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update goods channel by vendro error{}", Throwables.getStackTraceAsString(e));
            response.setError("update.goods.error");
        }
        return response;
    }


    /**
     * 根据商品编码List查询商品list
     *
     * @param goodsCodes
     * @return
     */
    @Override
    public Response<List<GoodsModel>> findByCodes(List<String> goodsCodes) {
        Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
        try {
            List<GoodsModel> goodsModelList = goodsDao.findByCodes(goodsCodes);
            response.setResult(goodsModelList);
        } catch (Exception e) {
            log.error("find goods list by code list error{}", Throwables.getStackTraceAsString(e));
            response.setError("findByCodes.goods.error");
        }
        return response;
    }


    @Override
    public Response<Boolean> examGoods(GoodsBatchDto goodsBatchDto, User user) {
        Response<Boolean> result = new Response<>();
        try {
            if ("yg".equalsIgnoreCase(goodsBatchDto.getChannel())) {
                goodsManager.updateGoodsInfoForCheck(goodsBatchDto, user);
            } else {
                goodsManager.examPresent(goodsBatchDto, user);
            }

            result.setResult(Boolean.TRUE);
        } catch (IllegalArgumentException re) {
            log.error("exam goods error{}", Throwables.getStackTraceAsString(re));
            result.setError(re.getMessage());
        } catch (Exception e) {
            log.error("exam goods error{}", Throwables.getStackTraceAsString(e));
            result.setError("exam.goods.error");
        }
        return result;
    }


    /**
     * 申请下架
     *
     * @param goodsmodel
     * @return
     */
    @Override
    public Response<Boolean> shelvesApply(GoodsModel goodsmodel) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            // 调用接口
            Boolean result = goodsManager.updateGoodsInfo(goodsmodel);
            if (!result) {
                response.setError("update.error");
                return response;
            }

            response.setResult(true);
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("approve.to.put.down.shelf.error{}", Throwables.getStackTraceAsString(e));
            response.setError("approve.to.put.down.shelf.error");
            return response;
        }
    }

    /**
     * 查询全部商品 供特殊积分倍率使用
     *
     * @return
     */
    public Response<List<GoodsModel>> findAllGoods(String searchKey) {
        Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
        Map<String, Object> paramMap = Maps.newHashMap();
        if (!StringUtils.isEmpty(searchKey)) {
            paramMap.put("searchKey", searchKey);
        }
        //优惠券只针对广发商城
        paramMap.put("ordertypeId","YG");
        try {
            response.setResult(goodsDao.findAll(paramMap));
            return response;
        } catch (Exception e) {
            log.error("find goods list error", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.list.error");
            return response;
        }
    }


    /**
     * 根据商品编码查询商品情报
     *
     * @param goodsCode
     * @return
     */
    @Override
    public Response<GoodsModel> findById(String goodsCode) {
        Response<GoodsModel> response = new Response<GoodsModel>();
        try {
            response.setResult(goodsDao.findById(goodsCode));
            return response;
        } catch (Exception e) {
            log.error("find.goods.by.goods.code.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.error");
            return response;
        }
    }

    /**
     * 根据商品编码查询商品情报
     *
     * @param goodsCode
     * @return
     */
    @Override
    public Response<GoodsModel> findCacheById(String goodsCode) {
        Response<GoodsModel> response = new Response<GoodsModel>();
        try {
            response.setResult(cacheGoods.getUnchecked(goodsCode));
            return response;
        } catch (Exception e) {
            log.error("find.goods.by.goods.code.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.error");
            return response;
        }
    }

    /**
     * 根据单品编码取得推荐单品的相关信息
     *
     * @param itemCode
     * @return
     */
    @Override
    public Response<RecommendGoodsDto> findItemInfoByItemCode(String itemCode) {
        Response<RecommendGoodsDto> response = new Response<RecommendGoodsDto>();
        RecommendGoodsDto recommendItem = new RecommendGoodsDto();
        try {
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
            response.setResult(recommendItem);
            return response;
        } catch (Exception e) {
            log.error("find recommend item error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.recommedn.item.error");
            return response;
        }
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
     * 根据类目以及 名称的模糊查询-->相关商品-关联的单品信息
     *
     * @param backgoryId 类目
     * @return List
     */
    @Override
    public Response<List<ItemDto>> findbyGoodsNameLike(String backgoryId, Map<String, Object> queryParams) {
        Response<List<ItemDto>> response = Response.newResponse();
        List<ItemDto> resultList = null;// 返回对象
        try {
            // 关联产品的类目ID
            Map<String, Object> params = Maps.newHashMap();
            if (null != queryParams && queryParams.containsKey("name")) {
                params.put("name", queryParams.get("name"));
            }
            if (!Strings.isNullOrEmpty(backgoryId)) {
                // 查询 spus
                List<Long> spuIDs = findSpusByCategoryId(backgoryId);
                if(null == spuIDs || spuIDs.isEmpty()){
                    response.setResult(null);
                    return response;
                }
                params.put("productIds", spuIDs); // spuIds
                // 渠道信息
                params.put("channelMall", "02");
                params.put("channelApp", "02");
                params.put("channelPhone", "02");
                params.put("channelMallWx", "02");
                // 业务id 查商品
                params.put("ordertypeId", "YG");

                // 内宣商品 判断
                if (null != queryParams && queryParams.containsKey("isInner")) {
                    params.put("isInner", queryParams.get("isInner"));
                }

                List<GoodsModel> codeList = goodsDao.findGoodsInfoByNameAndSpuIds(params);
                // 按取得的商品CODE列表取得单品列表
                if (codeList != null && codeList.size() != 0) {
                    params.clear();
                    List<String> goodsCodes = Lists.newArrayList();
                    Map<String, GoodsModel> goodsMap = Maps.newHashMap();
                    for (GoodsModel goodsModel : codeList) {
                        goodsCodes.add(goodsModel.getCode());
                        goodsMap.put(goodsModel.getCode(), goodsModel);
                    }
                    params.put("goodsCodes", goodsCodes);
                    // 置顶商品 判断
                    if (null != queryParams && queryParams.containsKey("stickFlag")) {
                        params.put("stickFlag", queryParams.get("stickFlag"));
                    }

                    List<ItemModel> itemList = itemDao.findItemsByGoodsCodeAndStick(params);
                    if (null != itemList && !itemList.isEmpty()) {
                        // 对查出的itemModelList进行循环
                        for (ItemModel itemModel : itemList) {
                            // 处理单品相关的销售属性信息
                            ItemDto itemDto = new ItemDto();
                            itemDto.setItemModel(itemModel);
                            GoodsModel goodsName = goodsMap.get(itemModel.getGoodsCode());

                            itemDto.setItemDescription(goodsName.getName() + buildItemName(itemModel));
                            if (null == resultList)
                                resultList = Lists.newArrayList();
                            resultList.add(itemDto);
                        }
                    }
                }
                response.setResult(resultList);
            } else {
                response.setError("category.is.null");
            }
        } catch (ResponseException e) {
            log.error("ResponseException->find.goods.list->error，bad info {} is reason",
                    Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("Exception->find.goods.list->error，bad info {} is reason", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.list.error");
        }
        return response;
    }

    /**
     * 查询 spus
     * @param backgoryId 三级类目Id
     * @return String
     */
    private List<Long> findSpusByCategoryId(String backgoryId) {
        if(Strings.isNullOrEmpty(backgoryId)){
            log.error("findbyGoodsNameLike.findByCategoryId.error,code: backgoryId.is.null");
            throw new ResponseException("backgoryId.is.null");
        }

        Response<List<Spu>> spuResponse = spuService.findByCategoryIdNoCache(Long.parseLong(backgoryId));

        if (!spuResponse.isSuccess()) {
            log.error("findbyGoodsNameLike.findByCategoryId.error,code:{}", spuResponse.getError());
            throw new ResponseException(spuResponse.getError());
        }

        List<Spu> spus = spuResponse.getResult();
        // 产品List 判断
        if (null == spus || spus.size()==0) {
            return null;
        }

        final List<Long> spuIDList = Lists.transform(spus, new Function<Spu, Long>() {

            @NotNull
            @Override
            public Long apply(@NotNull Spu input) {
                return input.getId() == null ? 0 : input.getId();
            }
        });
        if (spuIDList.isEmpty()) {
            return null;
        }
        return spuIDList;
    }

    /**
     * 判断单品是否可以置顶
     *
     * @param goodCode
     * @return add by liuhan
     */
    @Override
    public Response<String> findGoodsByItemCode(String goodCode) {
        Response<String> response = new Response<String>();
        try {
            // 调用接口
            GoodsModel goodsModel = goodsDao.findById(goodCode);
            if (!Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())
                    && !Contants.CHANNEL_CC_02.equals(goodsModel.getChannelCc())
                    && !Contants.CHANNEL_MALL_WX_02.equals(goodsModel.getChannelMallWx())
                    && !Contants.CHANNEL_PHONE_02.equals(goodsModel.getChannelPhone())
                    && !Contants.CHANNEL_APP_02.equals(goodsModel.getChannelApp())
                    && !Contants.CHANNEL_SMS_02.equals(goodsModel.getChannelSms())) {
                response.setResult(STICK_ITEM_01);
            } else if (Contants.IS_INNER_0.equals(goodsModel.getIsInner())) {
                response.setResult(STICK_ITEM_02);
            } else {
                response.setResult(STICK_ITEM_00);
            }
            return response;
        } catch (IllegalArgumentException e) {
            response.setError(e.getMessage());
            return response;
        } catch (Exception e) {
            log.error("select.error", Throwables.getStackTraceAsString(e));
            response.setError("select.error");
            return response;
        }

    }

    /**
     * 根据产品id查询商品（产品用）
     *
     * @param productId
     * @return
     * @author :tanliang
     * @time:2016-6-20
     */
    @Override
    public Response<List<GoodsModel>> findGoodsByProductId(Long productId) {
        Response<List<GoodsModel>> result = new Response<List<GoodsModel>>();
        try {
            result.setResult(goodsDao.findGoodsByProductId(productId));
        } catch (Exception e) {
            log.error("find.goods.byproduct.error", Throwables.getStackTraceAsString(e));
            result.setError("find.goods.byproduct.error");
        }
        return result;
    }

    /**
     * 根据指定条件查询单品、商品列表（活动用）
     *
     * @param promGoodsParamDto 参数
     * @return
     */
    @Override
    public Response<List<ItemPromDto>> findItemsListForProm(PromGoodsParamDto promGoodsParamDto, User user) {
        //如果没有限制查询条数则最多每次100条结果
        if (Strings.isNullOrEmpty(promGoodsParamDto.getCount())) {
            promGoodsParamDto.setCount("100");
        }
        Response<List<ItemPromDto>> result = new Response<>();
        List<String> ruledOutList = new ArrayList<>();
        if (StringUtils.isNotEmpty(promGoodsParamDto.getRuledOut())) {
            ruledOutList = Splitter.on(',').omitEmptyStrings().trimResults()
                    .splitToList(promGoodsParamDto.getRuledOut());
        }

        // 将搜索条件封装成一个map传入dao层---start
        Map<String, Object> params = Maps.newHashMap();
        // 指定供应商
        if (StringUtils.isNotEmpty(promGoodsParamDto.getVendorId())) {
            params.put("vendorIds", promGoodsParamDto.getVendorId());
        } else { // 内管平台操作，不指定供应商
            // 供应商名称
            if (!Strings.isNullOrEmpty(promGoodsParamDto.getVendorName())) {
                Response<List<String>> vendorResponse = vendorService.findIdByName(promGoodsParamDto.getVendorName());
                if (vendorResponse.isSuccess()) {
                    List<String> vendorIds = vendorResponse.getResult();
                    String strVendorId = "";
                    for (String id : vendorIds) {
                        if (StringUtils.isNotEmpty(strVendorId)) {
                            strVendorId = strVendorId + ",";
                        }
                        strVendorId = strVendorId + id.trim();
                    }
                    params.put("vendorIds", strVendorId.trim());
                }
            }
        }
        // 商品名称
        if (!Strings.isNullOrEmpty(promGoodsParamDto.getGoodsName())) {
            params.put("name", promGoodsParamDto.getGoodsName());
        }
        // 品牌
        if (!Strings.isNullOrEmpty(promGoodsParamDto.getBrandName())) {
            Response<List<Long>> brandIdsR = brandService.findBrandIdListByName(promGoodsParamDto.getBrandName());
            String strBrandIds = "";
            for (Long id : brandIdsR.getResult()) {
                if (StringUtils.isNotEmpty(strBrandIds)) {
                    strBrandIds = strBrandIds + ",";
                }
                strBrandIds = strBrandIds + id.toString().trim();
            }
            params.put("brandIds", strBrandIds.trim());
        }
        // 关联产品的类目ID
        if (!Strings.isNullOrEmpty(promGoodsParamDto.getBackCategory())) {
            Response<List<Spu>> spuResponse = spuService.findByCategoryId(Long.parseLong(promGoodsParamDto.getBackCategory()));
            if (!spuResponse.isSuccess()) {
                log.error("findItemsListForProm.findByCategoryId.error,code:{}", spuResponse.getError());
                result.setError(spuResponse.getError());
                return result;
            }
            List<Spu> spus = spuResponse.getResult();
            final List<String> spuIDList = Lists.transform(spus, new Function<Spu, String>() {
                @Override
                public String apply(Spu input) {
                    return input.getId().toString();
                }
            });
            if (spuIDList.size() > 0) {
                String spuIDs = Joiner.on(", ").join(spuIDList);
                params.put("productId", spuIDs);
            }else {
                //该类目下无任何产品 那么返回空集合
                result.setResult(Collections.<ItemPromDto>emptyList());
                return result;
            }
        }

        if (!Strings.isNullOrEmpty(promGoodsParamDto.getCount())) {
            params.put("count", Integer.valueOf(promGoodsParamDto.getCount().trim()));
        }
        params.put("ordertypeId", "YG");
        // 将搜索条件封装成一个map传入dao层---end
        try {
            List<GoodsModel> goodsList = goodsDao.findGoodsListByGoodsNameLikeForProm(params);
            List<ItemPromDto> itemPromInfoList = new ArrayList<ItemPromDto>();
            if (goodsList != null && goodsList.size() > 0) {
                // 将数据循环并加入品牌名称及后台类目信息，整合为goodsInfoList
                for (GoodsModel goodsModel : goodsList) {
                    Response<List<ItemDto>> itemResponse = itemService.findItemListByCodeOrNameForProm(goodsModel.getCode());
                    if (itemResponse.isSuccess()) {
                        List<ItemDto> itemList = itemResponse.getResult();
                        if (itemList != null) {
                            String brandName = "";
                            String simpleName = "";
                            // 根据品牌id到品牌表中查询品牌信息，放入goodsInfoDto中
                            Response<GoodsBrandModel> goodsBrandModelR = brandService.findBrandInfoById(goodsModel.getGoodsBrandId());
                            if (goodsBrandModelR.isSuccess()) {
                                brandName = goodsBrandModelR.getResult().getBrandName();
                            }
                            // 根据vendorId查询vendor信息，放入goodsInfoDto中
                            Response<VendorInfoDto> vendorResponse = vendorService.findById(goodsModel.getVendorId());
                            if (vendorResponse.isSuccess()) {
                                if (vendorResponse.getResult() != null) {
                                    simpleName = vendorResponse.getResult().getSimpleName();
                                }
                            }

                            Response<List<Pair>> pairResponse = this.findCategoryByGoodsCode(goodsModel.getCode());
                            if (!pairResponse.isSuccess()) {
                                log.error("findItemsListForProm.findCategoryByGoodsCode.error,code:{}", pairResponse.getError());
                                result.setError(pairResponse.getError());
                                return result;
                            }
                            List<Pair> pairList = pairResponse.getResult();

                            for (ItemDto itemDto : itemList) {
                                // 结果数量上限
                                if (StringUtils.isNotEmpty(promGoodsParamDto.getCount()) && itemPromInfoList
                                        .size() >= Integer.valueOf(promGoodsParamDto.getCount().trim())) {
                                    break;
                                }
                                // 除去已选择单品
                                if (itemDto.getItemModel() != null
                                        && ruledOutList.contains(itemDto.getItemModel().getCode())) {
                                    continue;
                                }
                                ItemPromDto itemPromDto = new ItemPromDto();
                                if (itemDto.getItemModel() != null) {
                                    // 单品CODE
                                    itemPromDto.setItemCode(itemDto.getItemModel().getCode());
                                    itemPromDto.setGoodsCode(itemDto.getItemModel().getGoodsCode());
                                    itemPromDto.setPrice(itemDto.getItemModel().getPrice());
                                    itemPromDto.setStock(itemDto.getItemModel().getStock());
                                }
                                // 商品名+单品属性 （单品描述）
                                itemPromDto.setGoodsName(itemDto.getItemDescription());
                                // 类目维护 第一级是所有分类，不需要显示
                                for (int i = 1; i < pairList.size() && i<4; i++) {
                                    Pair pair = pairList.get(i);
                                    Method methodSetId = itemPromDto.getClass().getMethod("setBackCategory" + String.valueOf(i) + "Id", Long.class);
                                    methodSetId.invoke(itemPromDto, pair.getId());
                                    Method methodSetName = itemPromDto.getClass().getMethod("setBackCategory" + String.valueOf(i) + "Name", String.class);
                                    methodSetName.invoke(itemPromDto, pair.getName());
                                }

                                itemPromDto.setGoodsBrandName(brandName);
                                itemPromDto.setVendorName(simpleName);
                                itemPromInfoList.add(itemPromDto);
                            }
                        }
                    }
                }
                result.setResult(itemPromInfoList);
            } else {
                result.setResult(Collections.<ItemPromDto>emptyList());
            }
        } catch (Exception e) {
            log.error("findItemsListForProm.goods.error", e);
            result.setError("findItemsListForProm.goods.error");
        }
        return result;
    }

    @Override
    public Response<List<GoodsModel>> findGiftByCodes(List<String> goodsCodes) {
        Response<List<GoodsModel>> response = new Response<List<GoodsModel>>();
        try {
            List<GoodsModel> goodsModelList = goodsDao.findGiftByCodes(goodsCodes);
            response.setResult(goodsModelList);
        } catch (Exception e) {
            log.error("findGiftByCodes.goods.error", Throwables.getStackTraceAsString(e));
            response.setError("findGiftByCodes.goods.error");
        }
        return response;
    }

    @Override
    public void updateGoodsJF(String goodsId, Long num) {
        ItemModel goodsModel = new ItemModel();
        goodsModel.setCode(goodsId);
        goodsModel.setStock(num);
        goodsManager.updateGoodsJF(goodsModel);
    }

    @Override
    public void updateGoodsYG(String goodsId, Long num) {
        ItemModel goodsModel = new ItemModel();
        goodsModel.setCode(goodsId);
        goodsModel.setStock(num);
        goodsManager.updateGoodsYG(goodsModel);
    }

    /**
     * 回滚积分池
     *
     * @param usedPoint
     * @param createDate
     */
    @Override
    public void dealPointPoolForDate(Long usedPoint, Date createDate) {
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("used_point", usedPoint);
        paramMap.put("create_time", DateHelper.getyyyyMM(createDate));
        pointPoolManager.dealPointPoolForDate(paramMap);
    }

    /**
     * 返回单品信息
     *
     * @param goodsId
     * @return
     */
    @Override
    public ItemModel findItemInfoById(String goodsId) {
        ItemModel itemModel = itemDao.findById(goodsId);
        return itemModel;
    }

    /**
     * 根据单品编码（goodsId）查询单品信息 niufw
     *
     * @param goodsId
     * @return
     */
    @Override
    public Response<ItemModel> findInfoById(String goodsId) {
        Response<ItemModel> response = Response.newResponse();
        try {
            ItemModel itemModel = itemDao.findById(goodsId);
            response.setResult(itemModel);
            return response;
        } catch (Exception e) {
            log.error("findItemInfoById.goods.error", Throwables.getStackTraceAsString(e));
            response.setError("findGiftByCodes.goods.error");
            return response;
        }
    }


    /**
     * 更新实际库存
     *
     * @param goodsId
     * @return
     */
    @Override
    public Response<Integer> updateStock(String goodsId) {
        Response<Integer> response = new Response<Integer>();
        try {
            Integer count = goodsManager.updateStock(goodsId);
            if (count > 0) {
                response.setResult(count);
                return response;
            }
        } catch (NullPointerException e) {
            response.setError(e.getMessage());
        } catch (Exception e) {
            log.error("update.item.error", Throwables.getStackTraceAsString(e));
            response.setError("update.item.error");
        }
        return response;
    }

    /**
     * @return
     */
    public Response<Boolean> submitGoodsToApprove(GoodsDetailDto goodsDetailDto, User user) {
        Response<Boolean> response = new Response<Boolean>();
        try {
            goodsManager.submitGoodsToApprove(goodsDetailDto, user);
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            log.error("submit.goods.to.approve.error{}", Throwables.getStackTraceAsString(e));
            response.setError("submit.goods.to.approve.error");
            return response;
        }
    }

    /**
     * 查询商品信息
     *
     * @param code
     * @return
     */
    @Override
    public Response<GoodsModel> findGoodsInfo(String code) {
        Response<GoodsModel> response = new Response<GoodsModel>();
        try {
            response.setResult(goodsDao.findById(code));
            return response;
        } catch (Exception e) {
            log.error("find.goods.by.goods.code.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.error");
            return response;
        }

    }

    /**
     * 查询商品信息（网银商品推荐）
     * <p>
     * add by zhoupeng
     *
     * @param mid 单品mid
     * @return Response<GoodsDetailDto>
     */
    @Override
    public Response<GoodsDetailDto> findGoodsInfoByMid(String mid) {
        Response<GoodsDetailDto> response = Response.newResponse();
        try {
            ItemModel itemModel = itemDao.findByMid(mid);
            if (itemModel == null) {
                response.setError("find.goods.item.error");
                return response;
            }
            String goodCode = itemModel.getGoodsCode();
            // 根据商品编码取得商品信息
            GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
            // 商品信息设定
            GoodsDetailDto dto = new GoodsDetailDto();
            String itemDesc = Strings.nullToEmpty(itemModel.getAttributeName1());
            if (!Strings.isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())) {
                itemDesc += "/" + itemModel.getAttributeName2();
            }
            dto.setName(goodsModel.getName() + itemDesc);
            dto.setCode(itemModel.getGoodsCode());
            dto.setMid(itemModel.getMid());
            dto.setItemCode(itemModel.getCode());
            response.setResult(dto);
        } catch (Exception e) {
            log.error("find.goods.by.goods.code.error{}", Throwables.getStackTraceAsString(e));
            response.setError("find.goods.item.error");
            return response;
        }

        return response;
    }

    @Override
    public Response<Integer> findGoodsCountByVendorId(String vendorId,String businessTypeId) {
        Response<Integer> response = new Response<>();
        try {
            Integer goodsCountByVendorId = goodsDao.findGoodsCountByVendorId(vendorId,businessTypeId);
            response.setResult(goodsCountByVendorId);
        } catch (Exception e) {
            log.error("fail to findGoodsCountByVendorId,vendorId={};cause by {}", vendorId,
                    Throwables.getStackTraceAsString(e));
            response.setError("query.error");
        }
        return response;
    }

    /**
     * 根据单品id获得商品信息
     */
    @Override
    public Response<GoodsModel> findGoodsModelByItemCode(String itemCode) {
        Response<GoodsModel> resource = Response.newResponse();
        try {
            ItemModel itemModel = itemDao.findById(itemCode);
            GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
            resource.setResult(goodsModel);
        } catch (Exception e) {
            resource.setError("query.error");
        }
        return resource;
    }

    /**
     * 查询积分类型信息
     */
    public Response<TblCfgIntegraltypeModel> findPointsNameByType(String PointsType) {
        Response<TblCfgIntegraltypeModel> response = Response.newResponse();
        try {
            TblCfgIntegraltypeModel tblCfgIntegraltypeModel = tblCfgIntegraltypeDao.findById(PointsType);
            if (tblCfgIntegraltypeModel != null) {
                response.setResult(tblCfgIntegraltypeModel);
            }
        } catch (Exception e) {
            response.setError("query.error");
        }
        return response;
    }

    @Autowired
    private Forest forest;

    @Override
    public Response<Map<String, Object>> findWithDetailsById(String goodsCode, String channel, Long spuId) {
        log.info("in findWithDetailsById, goodsCode={}", goodsCode);
        Response<Map<String, Object>> result = Response.newResponse();
        Map<String, Object> map = Maps.newHashMap();
        try {
            //  //新增 供应商列表
            if (!isEmpty(channel) && Strings.isNullOrEmpty(goodsCode)) {
                Response<Spu> spu = spuService.findById(spuId);
                Integer brandId = spu.getResult().getBrandId();
                List<String> vendorIds = brandAuthorizeDao.findVendorIdsByBrandId(brandId, channel, StringUtils.isEmpty(goodsCode));
                if (vendorIds.size() == 0) {
                    map.put("vendors", Collections.emptyList());
                } else {
                    Response<List<VendorInfoModel>> vendorInfoListR = vendorService.findByVendorIdsForBrandAuth(vendorIds);
                    if (vendorInfoListR.isSuccess()) {
                        map.put("vendors", vendorInfoListR.getResult());
                    }
                }
            }
            //编辑情况
            if (goodsCode != null) {
                GoodsModel goodsModel = goodsDao.findById(goodsCode);
                if (goodsModel == null) {
                    log.error("goodsModel(id={}) not found", goodsModel);
                    result.setError("goods.not.found");
                    return result;
                }

                List<ItemModel> itemList = itemDao.findItemListByGoodsCode(goodsCode);
                GoodFullDto goodFullDto = new GoodFullDto();
                goodFullDto.setGoodsModel(goodsModel);
                goodFullDto.setItemList(itemList);
                // 供应商信息
                Response<VendorInfoModel> vendorModelR = vendorService.findVendorById(goodsModel.getVendorId());
                if (vendorModelR.isSuccess()) {
                    goodFullDto.setVendorInfoModel(vendorModelR.getResult());
                    List<VendorInfoModel> list = Lists.newArrayList();
                    list.add(vendorModelR.getResult());
                    map.put("vendors", list);
                }

                // 邮购分期类别码
                Response<List<MailStagesModel>> mailResult = mailStatesService.findMailStagesListByVendorId(goodsModel.getVendorId());
                if (mailResult.isSuccess()) {
                    map.put("mailStages", mailResult.getResult());
                }
                Response<List<TblVendorRatioModel>> periodResult = vendorService.findRaditListByVendorId(goodsModel.getVendorId());
                if (periodResult.isSuccess()) {
                    map.put("vendorRatios", periodResult.getResult());
                }

                ItemGroup itemGroup = new ItemGroup(itemList);
                goodFullDto.setItemGroup(itemGroup.getAttributes());
                goodFullDto.setAttributes(forest.getRichAttributes(goodsModel.getProductId()));

                // 推荐关联单品
                List<RecommendGoodsDto> recommendGoodsList = Lists.newArrayList();
                if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods1Code())) {
                    recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods1Code()).getResult());
                }
                if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods2Code())) {
                    recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods2Code()).getResult());
                }
                if (StringUtils.isNotEmpty(goodsModel.getRecommendGoods3Code())) {
                    recommendGoodsList.add(findItemInfoByItemCode(goodsModel.getRecommendGoods3Code()).getResult());
                }
                goodFullDto.setRecommendGoodsList(recommendGoodsList);

                map.put("fullItem", goodFullDto);

            }
            result.setResult(map);
        } catch (Exception e) {
            log.error("failed to find full goods(code={}),cause:{}", goodsCode, Throwables.getStackTraceAsString(e));
            result.setError("goods.query.fail");
            return result;
        }
        return result;
    }

    @Override
    public Response<Boolean> update(GoodsModel goodsModel, List<ItemModel> itemList) {
        Response<Boolean> result = Response.newResponse();
        try {
            boolean updateR = goodsManager.update(goodsModel, itemList);
            result.setResult(updateR);
            return result;
        } catch (Exception e) {
            log.error("good udpate error, cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("goods.update.error");
            return result;
        }
    }

    public static enum ApproveType {
        APPROVE_TYPE_2("2", "初审"),
        APPROVE_TYPE_3("3", "复审"),
        APPROVE_TYPE_4("4", "商品信息变更审核"),
        APPROVE_TYPE_5("5", "价格变更审核"),
        APPROVE_TYPE_6("6", "下架申请审核审核");

        private String value;
        private String desc;

        ApproveType(String value, String desc) {
            this.value = value;
            this.desc = desc;
        }

        public String value() {
            return value;
        }

        public static ApproveType from(String value) {
            for (ApproveType approveType : ApproveType.values()) {
                if (Objects.equal(approveType.value, value)) {
                    return approveType;
                }
            }
            return null;
        }

        @Override
        public String toString() {
            return desc;
        }
    }

    /**
     * 根据商品Id ,查询商品所属的后台类目（一级，二级，三级，四级....或者更多，依据产品Id进行查询）
     * 该方法通用
     *
     * @param goodsCode 商品ID
     * @return 类目信息
     */
    @Override
    public Response<List<Pair>> findCategoryByGoodsCode(String goodsCode) {
        Response<List<Pair>> response = Response.newResponse();
        if (Strings.isNullOrEmpty(goodsCode)) {
            log.error("goodsCode can not be empty,goodsCode:{}", goodsCode);
            response.setError("params.illegal");
            return response;
        }
        try {
            Response<GoodsModel> goodsModelR = findById(goodsCode);
            Long spuId = goodsModelR.getResult().getProductId();
            Response<Spu> spuR = spuService.findById(spuId);
            Long cateGoryId = spuR.getResult().getCategoryId();
            List<BackCategory> backCategoriesR = bch.ancestorsOf(cateGoryId);
            List<Pair> pairs = Lists.newArrayListWithCapacity(backCategoriesR.size());
            for (BackCategory bc : backCategoriesR) {
                pairs.add(new Pair(bc.getName(), bc.getId()));
            }
            response.setResult(pairs);
            return response;
        } catch (Exception e) {
            log.error("failed to find good's categorys by goodsCode,goodsCode:{},cause:{}", goodsCode, Throwables.getStackTraceAsString(e));
            response.setError("");
            return response;
        }
    }

    @Override
    public Response<Long> findGoodsBySpu(Long spuId) {
        Response<Long> response = Response.newResponse();
        if (isNull(spuId)) {
            log.error("spuId can not be empty,spuId:{}", spuId);
            response.setError("params.illegal");
            return response;
        }
        try {
            Long goodsCount = goodsDao.findGoodsBySpu(spuId);
            response.setResult(goodsCount);
            return response;
        } catch (Exception e) {
            log.error("failed to find spu's goods by spuId,spuId:{},cause:{}", spuId, Throwables.getStackTraceAsString(e));
            response.setError("failed.to.find.goods.by.spuId");
            return response;
        }
    }


    @Override
    public Response<Boolean> updateWithoutNull(GoodsModel goodsModel, List<ItemModel> itemList,String channel,User user) {
        Response<Boolean> result = Response.newResponse();
        try {
            boolean updateR = goodsManager.updateWithoutNull(goodsModel, itemList,channel,user);
            result.setResult(updateR);
            return result;
        } catch (Exception e) {
            log.error("good udpate error, cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("goods.update.error");
            return result;
        }
    }
    
    @Override
	public Response<List<GoodsDecorationDto>> findDecorationGoods(String backCategoryId, String goodsName) {
		Response<List<GoodsDecorationDto>> result = new Response<>();
        // 将搜索条件封装成一个map传入dao层---start
        Map<String, Object> params = Maps.newHashMap();
        // 商品名称
        if (!Strings.isNullOrEmpty(goodsName)) {
            params.put("name", goodsName);
        }
        // 关联产品的类目ID
        if (!Strings.isNullOrEmpty(backCategoryId)) {
            Response<List<Spu>> spuResponse = spuService.findByCategoryId(Long.parseLong(backCategoryId));
            if (!spuResponse.isSuccess()) {
                log.error("findDecorationGoods.findByCategoryId.error,code:{}", spuResponse.getError());
                result.setError(spuResponse.getError());
                return result;
            }
            List<Spu> spus = spuResponse.getResult();
            final List<String> spuIDList = Lists.transform(spus, new Function<Spu, String>() {
                @Override
                public String apply(Spu input) {
                    return input.getId().toString();
                }
            });
            if (spuIDList.size() > 0) {
                String spuIDs = Joiner.on(",").join(spuIDList);
                params.put("productId", spuIDs);
            }else {
                //如果查不到产品id 说明该类目下没有任何产品 应该查不到商品 而不是返回所有
                result.setResult(Collections.<GoodsDecorationDto>emptyList());
                return result;
            }
        }
        
        params.put("count", 50);
        
        // 将搜索条件封装成一个map传入dao层---end
        try {
            List<GoodsModel> goodsList = goodsDao.findGoodsListByGoodsNameLikeForDecoration(params);
            List<GoodsDecorationDto> goodsDecorationDtos = new ArrayList<GoodsDecorationDto>();
            if (goodsList != null && goodsList.size() > 0) {
                // 将数据循环并加入品牌名称及后台类目信息，整合为goodsInfoList
                for (GoodsModel goodsModel : goodsList) {
                    Response<List<ItemDto>> itemResponse = itemService.findItemListByCodeOrNameForProm(goodsModel.getCode());
                    if (itemResponse.isSuccess()) {
                        List<ItemDto> itemList = itemResponse.getResult();
                        if (itemList != null) {
                            for (ItemDto itemDto : itemList) {
                                // 结果数量上限
                                if (goodsDecorationDtos.size() >= 50) {
                                    break;
                                }
                                GoodsDecorationDto goodsDecorationDto = new GoodsDecorationDto();
                                ItemModel itemModel = itemDto.getItemModel();
                                if (itemModel == null) {
                                    continue;
                                }
                                
                                // 单品CODE
                                goodsDecorationDto.setItemCode(itemModel.getCode());
                                // 商品名+单品属性 （单品描述）
                                String goodsNm = goodsModel.getName();
                                if(!Strings.isNullOrEmpty(itemModel.getAttributeName1()) && !"无".equals(itemModel.getAttributeName1())){
                                	goodsNm = goodsNm + "/" + itemModel.getAttributeName1();
                                }
                                if(!Strings.isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())){
                                	goodsNm = goodsNm + "/" + itemModel.getAttributeName2();
                                }
                                goodsDecorationDto.setGoodsName(goodsNm);
                                goodsDecorationDto.setIsGift("JF".equals(goodsModel.getOrdertypeId())? "1" : "0");
                                goodsDecorationDtos.add(goodsDecorationDto);
                            }
                        }
                    }
                }
                result.setResult(goodsDecorationDtos);
            } else {
                result.setResult(Collections.<GoodsDecorationDto>emptyList());
            }
        } catch (Exception e) {
            log.error("findDecorationGoods.goods.error", e);
            result.setError("findDecorationGoods.goods.error");
        }
        return result;
	}

    public Response<Map<String , Map<String,String>>> findGoodsMap(List<String> goodsCodes){
        Response<Map<String , Map<String,String>>> response = Response.newResponse();
        try {
            List<GoodsModel> goodsModelList = goodsDao.findByCodes(goodsCodes);
            Map<String , Map<String,String>> goodsListMap = Maps.newHashMap();
            for(GoodsModel goodsModel : goodsModelList){
                Map<String,String> goodsMap = Maps.newHashMap();
                goodsMap.put("code",goodsModel.getCode());
                goodsMap.put("name",goodsModel.getName());
                goodsMap.put("brandName",goodsModel.getGoodsBrandName());
                Long spuId = goodsModel.getProductId();
                Response<Spu> spuR = spuService.findById(spuId);
                List<Pair> pairList = Lists.newArrayList();
                if (spuR.isSuccess()){
                    Long cateGoryId = spuR.getResult().getCategoryId();
                    List<BackCategory> backCategoriesR = bch.ancestorsOf(cateGoryId);
                    pairList = Lists.newArrayListWithCapacity(backCategoriesR.size());
                    for (BackCategory bc : backCategoriesR) {
                        pairList.add(new Pair(bc.getName(), bc.getId()));
                    }
                }
                int size = pairList.size();
                Pair pair;
                // 第一级是所有分类，不需要显示
                for (int i = 1; i < size; i++) {
                    pair = pairList.get(i);
                    switch (i) {
                        case 1:
                            goodsMap.put("backCategory1",pair.getName());
                            break;
                        case 2:
                            goodsMap.put("backCategory2",pair.getName());
                            break;
                        case 3:
                            goodsMap.put("backCategory3",pair.getName());
                            break;
                        default:
                            break;
                    }
                }
                goodsListMap.put(goodsModel.getCode(),goodsMap);
            }
            response.setResult(goodsListMap);
        } catch (Exception e) {
            log.error("goodsService.findGoodsMap.error{}", Throwables.getStackTraceAsString(e));
            response.setError("goodsService.findGoodsMap.error");
        }
        return response;
    }

    @Override
    public Response<GiftsImportDto> createGoodsImport(GoodsModel goodsModel, List<GiftsImportDto.GiftItemDto> itemList, String vendorNo, String channel) {
        Response<GiftsImportDto> result = Response.newResponse();
        GiftsImportDto giftsImportDto = new GiftsImportDto();
        try {
            goodsManager.createGoodsImport(goodsModel, itemList, vendorNo, channel);
            giftsImportDto.setGoodsModel(goodsModel);
            giftsImportDto.setItemModel(itemList);
            result.setResult(giftsImportDto);
        } catch (Exception e) {
            log.error("insert.goods.error{}", Throwables.getStackTraceAsString(e));
            result.setError("insert.goods.error");
        }
        return result;
    }



    private Boolean checkMid(String mid){
        Long count = itemDao.findMidIsExist(mid);
        if(count>0){
            return Boolean.TRUE;//存在
        }
        return Boolean.FALSE;//不存在
    }

}
