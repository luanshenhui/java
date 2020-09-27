package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsFavoriteInfoDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MemberCountBatchDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.user.dto.MemberBatchDto;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Function;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.ComparisonChain;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Created by 张成 on 16-4-25.
 */

@Service
@Slf4j
public class FavoriteServiceImpl implements FavoriteService {
    @Resource
    private GoodsDao goodsDao;
    @Resource
    ItemDao itemDao;
    @Resource
    private UserFavoriteService userFavoriteService;
    @Resource
    private ItemService itemService;
    @Resource
    private TblGoodsPaywayDao tblGoodsPaywayDao;
    @Resource
    private MallPromotionService mallPromotionService;// 活动
    @Resource
    private PromotionPayWayService promotionPayWayService;// 活动价格

    // 本地缓存(单品信息)
    private final LoadingCache<String, Optional<ItemModel>> cacheItem;
    // 本地缓存(商品信息)
    private final LoadingCache<String, Optional<GoodsModel>> cacheGoods;

    // 构造函数
    public FavoriteServiceImpl() {
        cacheItem = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<ItemModel>>() {
                    public Optional<ItemModel> load(String code) throws Exception {
                        // 允许为空
                        return Optional.fromNullable(itemDao.findById(code));
                    }
                });
        cacheGoods = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
                .build(new CacheLoader<String, Optional<GoodsModel>>() {
                    public Optional<GoodsModel> load(String code) throws Exception {
                        // 允许为空
                        return Optional.fromNullable(goodsDao.findById(code));
                    }
                });
    }

    @Override
    public List<GoodsDetailDto> find(Map<String, Object> paramMap) {
        // 实例化返回GoodsDetailDto的list
        List<GoodsDetailDto> goodsList = new ArrayList<GoodsDetailDto>();
        try {
            // 从数据库查找收藏的top10
            List<MemberGoodsFavoriteModel> goodsFavoriteList = userFavoriteService.findTop(paramMap);
            if (null == goodsFavoriteList) {// 暂无收藏商品
                return goodsList;
            }
            // 循环找到的list
            for (int i = 0; i < goodsFavoriteList.size(); i++) {
                MemberGoodsFavoriteModel memberGoodsFavoriteModel = goodsFavoriteList.get(i);
                // 商品model
                GoodsModel goodsModel;
                GoodsDetailDto goodsDto = new GoodsDetailDto();

                // 根据收藏表中的商品code检索商品信息
                goodsModel = goodsDao.findDetailById(memberGoodsFavoriteModel.getGoodsCode());
                if (null != goodsModel) {
                    // copy给dto
                    BeanMapper.copy(goodsModel, goodsDto);
                }
                // TODO 设置单品Code 供热门收藏使用。
                goodsDto.setItemCode(memberGoodsFavoriteModel.getItemCode());
                // 把收藏的数赋值
                // goodsDto.setFavCount(memberGoodsFavoriteModel.getCount());
                // 放到list里
                goodsList.add(goodsDto);
            }
        } catch (Exception e) {
            log.error("get.favorite.top.error,error code: {}", Throwables.getStackTraceAsString(e));
        }
        // 返回这个list
        return goodsList;
    }

    /**
     * 分页取得收藏情报列表
     *
     * @param pageNo
     * @param size
     * @return
     */
    public Response<Pager<GoodsFavoriteInfoDto>> findByPager(Integer pageNo, Integer size, User user) {
        Response<Pager<GoodsFavoriteInfoDto>> result = new Response<Pager<GoodsFavoriteInfoDto>>();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            Response<Pager<MemberGoodsFavoriteModel>> response = userFavoriteService.findByPager(pageInfo, user);
            if (!response.isSuccess()) {
                log.error("Response.error,error code: {}", response.getError());
                throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
            }
            if (response.getResult() == null) {
                result.setResult(new Pager<GoodsFavoriteInfoDto>(0L, Collections.<GoodsFavoriteInfoDto>emptyList()));
                return result;
            }
            Pager<MemberGoodsFavoriteModel> pager = response.getResult();
            if (pager.getTotal() == 0) {
                result.setResult(new Pager<GoodsFavoriteInfoDto>(0L, Collections.<GoodsFavoriteInfoDto>emptyList()));
                return result;
            } else {
                List<MemberGoodsFavoriteModel> list = pager.getData();

                Map<String, ItemModel> itemModelMap = getItemModelMap(list);
                if(null == itemModelMap)
                    itemModelMap = Maps.newHashMapWithExpectedSize(1);
                List<GoodsFavoriteInfoDto> dtoList = new ArrayList<>();
                for (MemberGoodsFavoriteModel model : list) {
                    GoodsFavoriteInfoDto dto = new GoodsFavoriteInfoDto();
                    // 单品详情
                    ItemModel itemModel = null;
                    // this.findItemById(model.getItemCode());
                    // 商品详情
                    GoodsModel goodsModel = this.findGoodsById(model.getGoodsCode());
                    // Response<List<ItemDto>> itemRes = itemService.findItemListByCodeOrName(model.getItemCode(),"");
//                    Response<ItemModel> itemRes = itemService.findByItemcode(model.getItemCode());
//                    if (itemRes.isSuccess()) {
//                        // if (itemRes.getResult().size() != 0) {
//                        // ItemDto itemDto = itemRes.getResult().get(0);
//                        // itemModel = itemDto.getItemModel();
//                        // }
//                        itemModel = itemRes.getResult();
//                    }
                    itemModel = itemModelMap.get(model.getItemCode());

                    // 正常数据流程
                    if (goodsModel != null && itemModel != null) {
                        // 单品状态（失效，直降）
                        dto.setGoodsFavoriteType("0");
                        dto.setItemName(goodsModel.getName());
                        // 收藏详情
                        dto.setMemberGoodsFavoriteModel(model);
                        // 单品详情
                        dto.setItemModel(itemModel);
                        // 商品详情
                        dto.setGoodsModel(goodsModel);
                        // 广发商城
                        if (Contants.ORDERTYPEID_YG.equals(goodsModel.getOrdertypeId())) {
                            // 商品为上架状态以外的单品显示失效
                            if (Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
                                dto = findYGgoodsFavorite(dto, itemModel, model);
                                dto.setOrderTypeId("YG");
                            } else {
                                // 失效
                                dto.setGoodsFavoriteType("2");
                            }
                        } else if (Contants.ORDERTYPEID_JF.equals(goodsModel.getOrdertypeId())) {
                            // 商品为上架状态以外的单品显示失效
                            if (Contants.CHANNEL_POINTS_02.equals(goodsModel.getChannelPoints())) {
                                dto = findJFgoodsFavorite(dto, itemModel);
                                dto.setOrderTypeId("JF");
                            } else {
                                // 失效
                                dto.setGoodsFavoriteType("2");
                            }
                        }
                    } else {// 异常数据流程
                        // 失效
                        dto.setGoodsFavoriteType("2");
                    }
                    dtoList.add(dto);
                }
                result.setResult(new Pager<GoodsFavoriteInfoDto>(pager.getTotal(), dtoList));
                return result;
            }
        } catch (Exception e) {
            log.error("FavoriteService.findByPager.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("FavoriteService.findByPager.fail");
            return result;
        }
    }

    /**
     * 取 item集合
     * @param list
     * @return
     */
    private Map<String, ItemModel> getItemModelMap(List<MemberGoodsFavoriteModel> list) {
        List<String> itemCodes = Lists.transform(list, new Function<MemberGoodsFavoriteModel, String>() {
            @NotNull
            @Override
            public String apply(@NotNull MemberGoodsFavoriteModel input) {
                return input.getItemCode();
            }
        });
        Response<List<ItemModel>> response = itemService.findByCodesNoOrder(Lists.newArrayList(itemCodes));
        if(response.isSuccess()){
            List<ItemModel> itemModels = response.getResult();
            if(null == itemModels || itemCodes.isEmpty()){
                log.error("ItemService.findByCodesNoOrder.failed");
                return null;
            }
            return Maps.uniqueIndex(itemModels, new Function<ItemModel, String>() {
                @NotNull
                @Override
                public String apply(@NotNull ItemModel input) {
                    return input.getCode();
                }
            });

        }
        return null;
    }

    /**
     * 我的收藏积分商城数据
     */
    private GoodsFavoriteInfoDto findJFgoodsFavorite(GoodsFavoriteInfoDto goodsFavoriteInfoDto, ItemModel itemModel) {
        List<TblGoodsPaywayModel> goodsPaywayModelList = tblGoodsPaywayDao.findByItemCode(itemModel.getCode());// 支付方式获取
        // 根据指定字段排序
        Collections.sort(goodsPaywayModelList, new Comparator<TblGoodsPaywayModel>() {
            @Override
            public int compare(TblGoodsPaywayModel o1, TblGoodsPaywayModel o2) {
                return ComparisonChain.start().compare(o1.getMemberLevel(), o2.getMemberLevel()).result();
            }
        });
        TblGoodsPaywayModel goodsPaywayModel = goodsPaywayModelList.get(0);
        if (goodsPaywayModel.getGoodsPoint() == null || goodsPaywayModel.getGoodsPoint() == 0l) {
            goodsFavoriteInfoDto.setItemPoint("0");// 积分抵扣
        } else {
            DecimalFormat df = new DecimalFormat("#,###");
            goodsFavoriteInfoDto.setItemPoint(df.format(goodsPaywayModel.getGoodsPoint()));// 积分抵扣
        }
        if (goodsPaywayModel.getGoodsPrice() != null
                && BigDecimal.ZERO.compareTo(goodsPaywayModel.getGoodsPrice()) != 0) {
            DecimalFormat f1 = new DecimalFormat("0.00");
            goodsFavoriteInfoDto.setItemPrice(f1.format(goodsPaywayModel.getGoodsPrice()));// 积分加现金
        }
        return goodsFavoriteInfoDto;
    }

    /**
     * 我的收藏广发商城数据
     */
    private GoodsFavoriteInfoDto findYGgoodsFavorite(GoodsFavoriteInfoDto goodsFavoriteInfoDto, ItemModel itemModel,
                                                     MemberGoodsFavoriteModel model) {

        //调用共通方法，查找单品最高期数
        Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
        // 最高分期数
        goodsFavoriteInfoDto.setMaxInstallmentNumber(maxInstallmentNumber.toString());
        // 收藏时点价格
        BigDecimal oldPrice = model.getPrice();
        // 现时点价格
//		BigDecimal newPrice = itemModel.getPrice();
        BigDecimal newPrice = getShowPrice(itemModel);

        if (newPrice != null) {
            goodsFavoriteInfoDto.setItemPrice(
                    newPrice.divide(new BigDecimal(maxInstallmentNumber), 2, BigDecimal.ROUND_UP).toString());
        }
        if (oldPrice != null && newPrice != null) {
            if (oldPrice.compareTo(newPrice) == 1) {
                // 直降
                goodsFavoriteInfoDto.setGoodsFavoriteType("1");
            }
        }
        return goodsFavoriteInfoDto;
    }

    /**
     * @param itemModel
     * @return
     */
    private BigDecimal getShowPrice(ItemModel itemModel) {

        Integer promType = null;// 活动类型 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
        String itemCode = itemModel.getCode();

        // 调用活动接口获得该商品的活动信息
        Response<MallPromotionResultDto> mallPromotion = mallPromotionService.findPromByItemCodes("1", itemCode,
                Contants.PROMOTION_SOURCE_ID_00);

        if (!mallPromotion.isSuccess() || mallPromotion.getResult() == null) {
            return itemModel.getPrice();
        }

        MallPromotionResultDto mallPromotionResultDto = mallPromotion.getResult();

        promType = mallPromotionResultDto.getPromType();
        // 满减 荷兰拍
        if (promType != null && (promType.equals(20) || promType.equals(50))) {
            log.error("MallPromotionService.getShowPrice,error code: { GoodsDetail.check.HeLanPai }");
            return itemModel.getPrice();
        }

        Response<List<PromotionPayWayModel>> findInfoByItemCode = promotionPayWayService
                .findPromotionByItemCode(itemCode, mallPromotionResultDto.getId());
        if (!findInfoByItemCode.isSuccess() || findInfoByItemCode.getResult() == null) {
            log.error("PromotionPayWayService.getShowPrice,error reason: {}", findInfoByItemCode.getError());
            return itemModel.getPrice();
        }
        if (!findInfoByItemCode.getResult().get(0).getGoodsId().equals(itemCode)) {
            log.error("PromotionPayWayService.getShowPrice,error reason: {goodsDetail.check.goodspayway.warning}");
            return itemModel.getPrice();
        }

        return findInfoByItemCode.getResult().get(0).getGoodsPrice();
    }

    /*
     * 根据CODE取得单品信息
     *
     * @return 单品信息
     */
    private ItemModel findItemById(String code) {
        Optional<ItemModel> itemModel = this.cacheItem.getUnchecked(code);
        if (itemModel.isPresent()) {
            return itemModel.get();
        }
        return null;
    }

    /*
     * 根据CODE取得商品信息
     *
     * @return 商品信息
     */
    private GoodsModel findGoodsById(String code) {
        Optional<GoodsModel> goodsModel = this.cacheGoods.getUnchecked(code);
        if (goodsModel.isPresent()) {
            return goodsModel.get();
        }
        return null;
    }

    @Override
    public Response<Map<String, Boolean>> add(String item, User user) {
        // 实例化返回GoodsDetailDto的list
        Response<Map<String, Boolean>> response = new Response<Map<String, Boolean>>();
        try {
            if (StringUtils.isEmpty(item)) {
                response.setSuccess(false);
                return response;
            }
            //校验收藏数量是否超过50个
            Long count = 0L;
            Response<Long> countR = userFavoriteService.findMyFavoriteCount(user);
            if(countR.isSuccess()){
                count = countR.getResult();
            }
            if(count>=50){
                response.setError("my.favorite.count.more.than.fifty");
                return response;
            }
            List<String> parts = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(item);
            List<String> itemList = Lists.newArrayListWithCapacity(parts.size());
            for (String id : parts) {
                itemList.add(id);
            }
            // 单品详情
            List<MemberGoodsFavoriteModel> modelList = new ArrayList<MemberGoodsFavoriteModel>();
            for (String itemCode : itemList) {
                ItemModel itemModel = this.findItemById(itemCode);
                if (itemModel == null) {
                    continue;
                }
                GoodsModel goodsModel = this.findGoodsById(itemModel.getGoodsCode());
                MemberGoodsFavoriteModel model = new MemberGoodsFavoriteModel();
                model.setItemCode(itemModel.getCode()); // 单品编码
                model.setGoodsCode(itemModel.getGoodsCode()); // 商品编码
                model.setPrice(itemModel.getPrice()); // 实际价格
                model.setCreateOper(user.getId()); // 创建人
                model.setCreateTime(new Date()); // 创建时间
                model.setDelFlag(0); // 逻辑删除标记 0：未删除 1：已删除
                model.setCustId(user.getId()); // 会员编号
                model.setVendorId(goodsModel.getVendorId()); // 供应商id
                modelList.add(model);
            }
            if (modelList.size() > 0) {
                response = userFavoriteService.addFavorite(modelList);
            } else {
                Map<String, Boolean> responseMap = Maps.newHashMap();
                responseMap.put("result", false);
                response.setSuccess(false);
                response.setResult(responseMap);
            }
        } catch (Exception e) {
            log.error("add.favorite.error", Throwables.getStackTraceAsString(e));
        }
        // 返回执行结果
        return response;
    }

    /**
     * Description : 指定时间段前五十收藏商品
     */
    @Override
    public Response<List<MemberCountBatchDto>> findTopGoodsFavorite(Map<String, Object> params) {
        Response<List<MemberCountBatchDto>> response = new Response<List<MemberCountBatchDto>>();
        try {
            // 用于缓存已有的MemberCountBatchDto
            Map<Integer, MemberCountBatchDto> memberCountBatchDtoCache = Maps.newHashMap();
            int pageNo = 1;
            int pageSize = 500;
            int indexYg = 0;// 当前广发统计索引
            int indexJf = 0;// 当前积分统计索引
            while (indexYg < 50 || indexJf < 50) {// 当广发、积分商城的前五十统计都取完后，就不再去取数据
                Response<List<MemberBatchDto>> memberBatchDtoPager = userFavoriteService
                        .findGoodsFavoriteByPager(pageNo++, pageSize, params);// 分页取数据
                if (!memberBatchDtoPager.isSuccess()) {
                    response.setError(memberBatchDtoPager.getError());
                    return response;
                }
                List<MemberBatchDto> memberBatchDtos = memberBatchDtoPager.getResult();
                if (memberBatchDtos == null || memberBatchDtos.isEmpty()) {// 没数据后停止去取数据
                    break;
                }
                MemberCountBatchDto memberCountBatchDto = null;
                GoodsModel goodsModel = null;
                ItemModel itemModel = null;
                for (MemberBatchDto memberBatchDto : memberBatchDtos) {
                    String goodsCode = memberBatchDto.getGoodsCode();
                    goodsModel = this.findGoodsById(goodsCode);
                    String itemCode = memberBatchDto.getItemCode();
                    itemModel = this.findItemById(itemCode);
                    if (goodsModel == null || itemModel == null) {
                        continue;
                    }
                    String orderTypeId = goodsModel.getOrdertypeId();
                    if (Contants.BUSINESS_TYPE_YG.equals(orderTypeId)) {
                        if (indexYg < 50) {// 缓存够50条记录就不再缓存
                            memberCountBatchDto = memberCountBatchDtoCache.get(++indexYg);
                            if (memberCountBatchDto == null) {// 缓存不存在时要创建
                                memberCountBatchDto = new MemberCountBatchDto();
                            }
                            memberCountBatchDto.setGoodsCodeYG(itemModel.getCode());
                            memberCountBatchDto.setGoodsNameYG(goodsModel.getName());
                            memberCountBatchDto.setTimeYG(Integer.valueOf(memberBatchDto.getCount()));
                            memberCountBatchDtoCache.put(indexYg, memberCountBatchDto);
                        }
                    } else if (Contants.BUSINESS_TYPE_JF.equals(orderTypeId)) {
                        if (indexJf < 50) {// 缓存够50条记录就不再缓存
                            memberCountBatchDto = memberCountBatchDtoCache.get(++indexJf);
                            if (memberCountBatchDto == null) {
                                memberCountBatchDto = new MemberCountBatchDto();
                            }
                            memberCountBatchDto.setGoodsCodeJF(itemModel.getCode());
                            memberCountBatchDto.setGoodsNameJF(goodsModel.getName());
                            memberCountBatchDto.setTimeJF(Integer.valueOf(memberBatchDto.getCount()));
                            memberCountBatchDtoCache.put(indexJf, memberCountBatchDto);
                        }
                    }
                }
                if (memberBatchDtos.size() < pageSize) {// 没数据后停止去取数据
                    break;
                }
            }

            List<MemberCountBatchDto> memberCountBatchDtos = Lists.newArrayList();
            int size = memberCountBatchDtoCache.size() > 50 ? 50 : memberCountBatchDtoCache.size();
            for (int index = 1; index <= size; index++) {
                MemberCountBatchDto memberCountBatchDto = memberCountBatchDtoCache.get(index);
                if (memberCountBatchDto == null) {
                    break;
                }
                memberCountBatchDto.setIndex(index);
                memberCountBatchDtos.add(memberCountBatchDto);
            }
            response.setResult(memberCountBatchDtos);
            return response;
        } catch (Exception e) {
            log.error("FavoriteService.findTopGoodsFavorite.fail,cause:{}", Throwables.getStackTraceAsString(e));
            response.setError("FavoriteService.findTopGoodsFavorite.fail");
            return response;
        }
    }
}
