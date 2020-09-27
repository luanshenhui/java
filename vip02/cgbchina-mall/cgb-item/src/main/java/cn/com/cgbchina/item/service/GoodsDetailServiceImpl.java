package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dao.CommendRankDao;
import cn.com.cgbchina.item.dao.GoodsConsultDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dao.TblCfgIntegraltypeDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.BirthdayTipDto;
import cn.com.cgbchina.item.dto.CardScaleDto;
import cn.com.cgbchina.item.dto.CommendRankDto;
import cn.com.cgbchina.item.dto.CouponScaleDto;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.ItemGroup;
import cn.com.cgbchina.item.model.CommendRankModel;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.ACustToelectronbankService;
import cn.com.cgbchina.user.service.CustInfoCommonService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.ComparisonChain;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.Multimaps;
import com.spirit.Annotation.Param;
import com.spirit.category.model.RichAttribute;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.Forest;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Created by Cong on 2016/5/26.
 */
@Slf4j
@Service
public class GoodsDetailServiceImpl implements GoodsDetailService {

    @Resource
    private GoodsDao goodsDao;
    @Resource
    private ItemDao itemDao;
    @Resource
    private VendorService vendorService; // 供应商
    @Resource
    private GoodsConsultDao goodsConsultDao;
    @Resource
    private ServicePromiseService servicePromiseService;
    @Resource
    private ACustToelectronbankService aCustToelectronbankService;
    @Resource
    private CouponScaleService couponScaleService;
    @Resource
    private PointsPoolService pointsPoolService;
    @Resource
    private CustInfoCommonService custInfoCommonService;
    @Resource
    private TblGoodsPaywayDao tblGoodsPaywayDao;
    @Autowired
    private ACardCustToelectronbankService aCardCustToelectronbankService;
    @Resource
    private CommendRankDao commendRankDao;
    @Resource
    private TblCfgIntegraltypeDao tblCfgIntegraltypeDao;
    @Resource
    private AttributeService attributeService;
    // 留学生旅行意外险
    @Value("${lxsyxGoods}")
    private String lxsyxGoods;
    // ALL常旅客消费
    @Value("${allFlyGoods}")
    private String allFlyGoods;
    // 七天联名卡住宿券
    @Value("${sevenDayGoods}")
    private String sevenDayGoods;
    // 附属卡礼品
    @Value("${attachedGoods}")
    private String attachedGoods;
    //南方航空
    @Value("${southernFlyGoods}")
    private String southernFlyGoods;
    //粤通卡
    @Value("${yuTongKaGoods}")
    private String yuTongKaGoods;


    @Autowired
    private Forest forest;
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    private final LoadingCache<String, List<CommendRankDto>> commendRankCache
            = CacheBuilder.newBuilder().expireAfterWrite(10L, TimeUnit.MINUTES).build(
            new CacheLoader<String, List<CommendRankDto>>() {
                @Override
                public List<CommendRankDto> load(String ranks) throws Exception {
                    CommendRankModel commendRankModel = new CommendRankModel();
                    String[] rank = ranks.split(",");
                    commendRankModel.setDelFlag(0);
                    commendRankModel.setStatType(rank[0]);
                    commendRankModel.setOrdertypeId(rank[1]);
                    List<CommendRankModel> itemCodeRankList = commendRankDao.findCommendRank(commendRankModel);
                    List<CommendRankDto> randklist = Lists.newArrayList();
                    if (itemCodeRankList != null) {
                        for (CommendRankModel commendRank : itemCodeRankList) {
                            CommendRankDto commendRankDto = findItemInfoByItemCode(commendRank.getItemCode());
                            if (commendRankDto != null) {
                                commendRankDto.setStatNum(commendRank.getStatNum01());
                                randklist.add(commendRankDto);
                            }
                        }
                    }
                    return randklist;
                }
            });


    private final LoadingCache<String, TblCfgIntegraltypeModel> integraltypeCache
            = CacheBuilder.newBuilder().expireAfterWrite(10L, TimeUnit.MINUTES).build(
            new CacheLoader<String, TblCfgIntegraltypeModel>() {
                @Override
                public TblCfgIntegraltypeModel load(String point) throws Exception {
                    TblCfgIntegraltypeModel tblCfgIntegraltypeModel = tblCfgIntegraltypeDao
                            .findById(point);
                    if (tblCfgIntegraltypeModel == null){
                        tblCfgIntegraltypeModel = new TblCfgIntegraltypeModel();
                    }
                    return tblCfgIntegraltypeModel;
                }
            });

    //积分类型
    public Map<String,BigDecimal> findUserPoints(Map<String,BigDecimal> scroreMap) {
        Map<String, BigDecimal> userPoints = Maps.newHashMap();
        for (Map.Entry<String, BigDecimal> entry : scroreMap.entrySet()) {
            TblCfgIntegraltypeModel tblCfgIntegraltypeModel = integraltypeCache.getUnchecked(entry.getKey());
            String integraltypeNm = tblCfgIntegraltypeModel.getIntegraltypeNm();
            if (integraltypeNm == null){
                integraltypeNm = "未知类型";
            }
            userPoints.put(integraltypeNm,entry.getValue());
        }
        return userPoints;
    }

    @Override  //商品详情页使用
    public Response<GoodsItemDto> findDetailByGoodCode(String itemCode, String goodCode) {
        Response<GoodsItemDto> result = Response.newResponse();
        // 商品信息
        GoodsItemDto goodsItemDto = new GoodsItemDto();
        // 商品信息
        GoodsModel goodsModel;
        // 该商品的所有单品
        List<ItemModel> itemModelList;
        // 单位积分
        Long singlePoint = null;
        // 积分类型
        String integraltypeNm = null;
        // 给前台传的虚拟商品编码start
        Map<String, Object> bidMap = Maps.newHashMap();

        //主要信息获取（单品信息和支付方式）
        //商品存在性校验 start
        try {
            goodsModel =goodsDao.findById(goodCode);
            itemModelList = itemDao.findItemDetailByGoodCode(goodCode);
            if (goodsModel == null || itemModelList == null) {
                result.setError("goodsdetail.not.found");
                return result;
            }
            //2016-11-30 数据迁移数据处理。视库存0的单品不存在。
            //如果只有一条单品则显示该单品。如果所有单品均无库存则按默认规则处理 start
            if (itemModelList.size() > 1){
                List<ItemModel> tempItemList = Lists.newArrayList();
                ItemModel tempDefaultItem = null;
                for (ItemModel tempMode:itemModelList){
                    if (tempMode.getStock() > 0){
                        tempItemList.add(tempMode);
                    }
                    if (itemCode!=null && itemCode.equals(tempMode.getCode())){
                        tempDefaultItem = tempMode;
                    }
                }
                if(tempItemList.size() > 0){
                    itemModelList = tempItemList;
                }else{
                    if (tempDefaultItem != null){
                        itemModelList.clear();
                        itemModelList.add(tempDefaultItem);
                    }else {
                        tempDefaultItem = itemModelList.get(0);
                        itemModelList.clear();
                        itemModelList.add(tempDefaultItem);
                    }
                }
            }
            //2016-11-30 数据迁移数据处理。视库存0的单品不存在。
            //如果只有一条单品则显示该单品。如果所有单品均无库存则按默认规则处理 end

            //单品绑定支付方式
            final List<String> itemCodes = Lists.transform(itemModelList, new Function<ItemModel, String>() {
                @Override
                public String apply(@NotNull ItemModel input) {
                    return input.getCode();
                }
            });
            final Map<String, ItemModel> itemMaps = Maps.uniqueIndex(itemModelList, new Function<ItemModel, String>() {
                @Override
                public String apply(@NotNull ItemModel from) {
                    return from.getCode();
                }
            });
            List<TblGoodsPaywayModel> itemPayways = tblGoodsPaywayDao.findByGoodsIdsAsc(itemCodes);
            List<ItemGoodsDetailDto> itemGoodsDetailDtoList = Lists.newArrayList();
            Multimap<String, TblGoodsPaywayModel> itemPaywayMap = indexPriceTypeDto(itemPayways);
            for (Map.Entry<String, ItemModel> entry : itemMaps.entrySet()) {
                ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
                List<TblGoodsPaywayModel> tempitempayway = Lists.newArrayList(itemPaywayMap.get(entry.getKey()));
                BeanMapper.copy(entry.getValue(), itemGoodsDetailDto);
                itemGoodsDetailDto.setTblGoodsPaywayModelList(tempitempayway);
                itemGoodsDetailDtoList.add(itemGoodsDetailDto);
            }
            //商品相关信息
            // 获取服务承诺
            List<ServicePromiseModel> servicePromiseModelList = Lists.newArrayList();
            if (!Strings.isNullOrEmpty(goodsModel.getServiceType())) {
                String[] promiseids = goodsModel.getServiceType().split(",");
                servicePromiseModelList = getservicePromise(promiseids);
            }
            // 得到商品页需要展示的所有规格
            //礼品商品数据区分
            //商品独有数据
            if (Contants.BUSINESS_TYPE_YG.equals(goodsModel.getOrdertypeId())){
                // 获取当月积分池比例Start
                PointPoolModel pointPoolModel = pointsPoolService.findPointsPoolService();
                if (pointPoolModel != null) {
                    singlePoint = pointPoolModel.getSinglePoint();
                } else {
                    log.error("goodsDetail.getpointsPool.error");
                }
                // 获取当月积分池比例End
            } else {
                TblCfgIntegraltypeModel tblCfgIntegraltypeModel = integraltypeCache.getUnchecked(goodsModel.getPointsType());
                integraltypeNm = tblCfgIntegraltypeModel.getIntegraltypeNm();

                // 留学生旅行意外险
                bidMap.put("lxsyxGoods", lxsyxGoods);
                bidMap.put("allFlyGoods", allFlyGoods);
                bidMap.put("sevenDayGoods", sevenDayGoods);
                bidMap.put("attachedGoods", attachedGoods);
                bidMap.put("southernFlyGoods",southernFlyGoods);
                bidMap.put("yuTongKaGoods",yuTongKaGoods);
                // 给前台传的虚拟商品编码end
            }

            // 设置默认单品信息
            ItemGoodsDetailDto defaultItem = null;
            // 默认选择第一条单品
            if (itemGoodsDetailDtoList != null) {
                defaultItem = itemGoodsDetailDtoList.get(0);
            }
            if (!Strings.isNullOrEmpty(itemCode)) {
                for (ItemGoodsDetailDto itemGoodsDetailDto : itemGoodsDetailDtoList) {
                    if (itemCode.equals(itemGoodsDetailDto.getCode())) {
                        defaultItem = itemGoodsDetailDto;
                    }
                }
            }
            //商品详情，规格，咨询信息
            //产品基础信息
            List<RichAttribute> spuAttributes = null;
            VendorInfoModel vendorInfoModel = null;
            Pager<GoodsConsultModel> goodsConsultModelPager = null;
            try{
                spuAttributes = attributeService.findSpuAttributesBy(goodsModel.getProductId());
                // 供应商信息
                String vendorId = goodsModel.getVendorId();
                Response<VendorInfoDto> resultVendorInfoDto = vendorService.findById(vendorId);
                // 供应商信息
                vendorInfoModel = resultVendorInfoDto.getResult();
                Map<String, Object> params = Maps.newHashMap();
                params.put("goodsCode", goodsModel.getCode());
                params.put("isShow", "0");// 0显示1隐藏 获得显示的咨询
                goodsConsultModelPager = goodsConsultDao.findByPageByCode(params, 1,
                        20);
            }catch (Exception e){
                log.error("goodsdetail.error:{},Exception:{}",goodCode,Throwables.getStackTraceAsString(e));
            }

            // 单品组
            ItemGroup itemGroup = new ItemGroup(itemModelList);
            goodsItemDto.setGoodAttr(itemGroup.getAttributes());
            // 商品支付方式end
            goodsItemDto.setGoodsModel(goodsModel);
            goodsItemDto.setItemGoodsDetailDto(defaultItem);
            goodsItemDto.setItemGoodsDetailDtoList(itemGoodsDetailDtoList);
            goodsItemDto.setServicePromiseModelList(servicePromiseModelList);
            goodsItemDto.setLastSinglePoint(singlePoint);
            goodsItemDto.setPointsTypeName(integraltypeNm);
            goodsItemDto.setFictitiousGiftType(bidMap);
            //商品描述
            goodsItemDto.setSpuAttributes(spuAttributes);
            goodsItemDto.setVendorInfoModel(vendorInfoModel);
            goodsItemDto.setGoodsConsultModelPager(goodsConsultModelPager);
            result.setResult(goodsItemDto);
        }catch (Exception e) {
            log.error("findDetailByGoodCode.error{}",Throwables.getStackTraceAsString(e));
            result.setError("findDetailByGoodCode.error");
        }
        return result;
    }


    //获取服务承诺
    private List<ServicePromiseModel> getservicePromise(String[] promiseids){
        List<ServicePromiseModel> servicePromiseModelList = Lists.newArrayList();
        try {

            for (String promiseid : promiseids) {
                Response<ServicePromiseModel> promiseResponse = servicePromiseService.findServicePromiseByid(promiseid);
                if (promiseResponse.isSuccess() && promiseResponse.getResult() != null) {
                    servicePromiseModelList.add(promiseResponse.getResult());
                }
            }
            Collections.sort(servicePromiseModelList, new Comparator<ServicePromiseModel>() {
                //重写排序规则
                public int compare(ServicePromiseModel o1, ServicePromiseModel o2) {
                    if (o1.getSort() > o2.getSort()) {
                        return 1;
                    }
                    if (o1.getSort().equals(o2.getSort())) {
                        return 0;
                    }
                    return -1;
                }
            });
        } catch (Exception e) {
            log.error("goodsDetail.getServicePromise.error");
        }
        return servicePromiseModelList;
    }

    private static Multimap<String, TblGoodsPaywayModel> indexPriceTypeDto(List<TblGoodsPaywayModel> itemGoodsDetailDtoList) {
        return Multimaps.index(itemGoodsDetailDtoList, uniqueIndexPriceTypeByVendorItemId());
    }

    private static Function<TblGoodsPaywayModel, String> uniqueIndexPriceTypeByVendorItemId() {
        return new Function<TblGoodsPaywayModel, String>() {
            @Override
            public String apply(@NotNull TblGoodsPaywayModel input) {
                String goodsId = null;
                if(input != null){
                    goodsId = input.getGoodsId();
                }
                return goodsId;
            }
        };
    }

    /**
     * 通用统计
     */
    public Response<List<CommendRankModel>> findCommendRankAll(CommendRankModel commendRankModel) {
        Response<List<CommendRankModel>> result = Response.newResponse();
        try {
            List<CommendRankModel> commendRankList = commendRankDao.findCommendRank(commendRankModel);
            result.setResult(commendRankList);
        } catch (Exception e) {
            log.error("GoodsDetailService.findCommendRank,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.findCommendRank");

        }
        return result;
    }

    /**
     * 热门销售和热门收藏
     *
     * @param orderType JF 积分商城 YG 广发商城
     * @param num       显示数量（最大不超过10个）
     * @param rankType  0001 热销销售，0002 热门收藏
     * @return
     */
    @Override
    public Response<List<CommendRankDto>> findCommendRank(@Param("orderType") String orderType, @Param("num") Integer num, @Param("rankType") String rankType) {
        Response<List<CommendRankDto>> response = Response.newResponse();
        if (Strings.isNullOrEmpty(rankType)||Strings.isNullOrEmpty(orderType)){
            response.setResult(Lists.<CommendRankDto>newArrayList());
            return response;
        }
        String commendRank = rankType + "," + orderType;
        List<CommendRankDto> randklist = commendRankCache.getUnchecked(commendRank);
        if (randklist == null){
            response.setResult(Lists.<CommendRankDto>newArrayList());
            return response;
        }
        if (num != null && randklist.size() > num) {
            randklist = randklist.subList(0, num);
        }
        response.setResult(Lists.newArrayList(randklist));
        return response;
    }


    /**
     * 获取推荐商品
     *
     * @param goodsCode
     * @return
     */
    @Override
    public Response<List<CommendRankDto>> findGoodsRecommend(@Param("goodsCode") String goodsCode,
                                                             @Param("itemCode") String itemCode) {
        Response<List<CommendRankDto>> result = Response.newResponse();
        if (goodsCode == null || goodsCode.trim().isEmpty()) {
            goodsCode = itemDao.findItemDetailByCode(itemCode).getGoodsCode();
        }
        try {
            // 商品信息
            List<CommendRankDto> itemInfoModels = new ArrayList<>();
            // 商品信息
            GoodsModel goodsModel;
            goodsModel = goodsDao.findById(goodsCode);
            // 关联推荐商品
            List<String> rocommendList = new ArrayList<>();
            rocommendList.add(goodsModel.getRecommendGoods1Code());
            rocommendList.add(goodsModel.getRecommendGoods2Code());
            rocommendList.add(goodsModel.getRecommendGoods3Code());
            // 获得推荐商品对应的单品信息
            if (rocommendList != null) {
                for (String data : rocommendList) {
                    if (!Strings.isNullOrEmpty(data)) {
                        // 查询商品的展示信息
                        CommendRankDto findItem = findItemInfoByItemCode(data);
                        if (findItem != null) {
                            itemInfoModels.add(findItem);
                        }
                    }
                }
            }
            result.setResult(itemInfoModels);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.findGoodsRecommend.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.findGoodsRecommend.fail");
            return result;
        }
    }

    /**
     * 分页获取商品咨询
     *
     * @param goodsCode
     * @param pageNo
     * @param size
     * @return
     */
    @Override
    public Pager<GoodsConsultModel> getGoodsConsultList(@Param("goodsCode") String goodsCode,
                                                        @Param("pageNo") Integer pageNo, @Param("size") Integer size) {
        Pager<GoodsConsultModel> goodsConsultModelPager;
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> params = Maps.newHashMap();
        params.put("goodsCode", goodsCode);
        params.put("isShow", "0");// 0显示1隐藏 获得显示的咨询
        // 分页获得商品信息
        goodsConsultModelPager = goodsConsultDao.findByPageByCode(params, pageInfo.getOffset(), pageInfo.getLimit());
        return goodsConsultModelPager;
    }

    /**
     * 获取单品库存
     *
     * @param itemCode
     * @return
     */
    @Override
    public Response<String> getItemStock(@Param("itemCode") String itemCode) {
        Response<String> result = new Response<String>();
        String stock = itemDao.findById(itemCode).getStock().toString();
        result.setResult(stock);
        return result;
    }

    /**
     * 获取用户生日折扣
     *
     * @param certNo
     * @return
     */
    public Response<BirthdayTipDto> getUserBirth(@Param("certNo") String certNo,List<String> cardNos) {
        Response<BirthdayTipDto> result = new Response<BirthdayTipDto>();
        BirthdayTipDto dto = new BirthdayTipDto();
        String birthDay = "";
        birthDay = aCustToelectronbankService.getUserBirth(certNo,cardNos);
        dto.setBirthday(birthDay);
        String birthScale = couponScaleService.getBirthScale();
        dto.setBirthScale(birthScale);
        result.setResult(dto);
        return result;
    }

    /**
     * 信用卡结算的场合取得最优的积分兑换比例,兑换比例小于1时有对应的值返回，不小于1时结果中各属性不存在
     *
     * @Param isUseBirthDiscount 是否使用生日优惠（广发商城默认是使用：true）
     * @Param user 用户
     * @Return
     */
    private Map<String, Object> getBestPointScale(boolean isUseBirthDiscount, User user) {
        Map<String, Object> result = Maps.newHashMap();
        // 类型
        String scaleType = Contants.MEMBER_LEVEL_JP;
        // 类型名称
        String scaleName = Contants.MEMBER_LEVEL_JP_NM;
        // 兑换等级比例
        BigDecimal scale = new BigDecimal(1);
        String certNo = user.getCertNo();
        List<UserAccount> userCartDtoList = user.getAccountList();
        final List<String> cardNos = Lists.transform(userCartDtoList, new Function<UserAccount, String>() {
            @Override
            public String apply(@NotNull UserAccount input) {
                return input.getCardNo();
            }
        });
        // 检索优惠折扣比例表
        Response<CouponScaleDto> couponScaleDtoResponse = couponScaleService.findAll();
        if (couponScaleDtoResponse.isSuccess()) {
            BigDecimal birthday = couponScaleDtoResponse.getResult().getBirthday();
            BigDecimal vip = couponScaleDtoResponse.getResult().getVIP();
            BigDecimal topCard = couponScaleDtoResponse.getResult().getTopCard();
            BigDecimal platinumCard = couponScaleDtoResponse.getResult().getPlatinumCard();
            BigDecimal commonCard = couponScaleDtoResponse.getResult().getCommonCard();
            // 通过客户证件号码取得客户最高卡等级对应的信息
            ACustToelectronbankModel aCustToelectronbankModel = custInfoCommonService
                    .getMaxCardLevelCustInfoByCertNbr(certNo,Lists.newArrayList(cardNos)).getResult();
            if (aCustToelectronbankModel != null) {
                // 通过最高卡等级取得客户最优等级
                Response<String> resultString = custInfoCommonService.calMemberLevel(certNo,
                        aCustToelectronbankModel.getCardLevelCd(), aCustToelectronbankModel.getVipTpCd());
                if (!resultString.isSuccess()) {
                    log.error("Response.error,error code: {}", resultString.getError());
                    throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
                }
                String memberLevel = resultString.getResult();
                switch (memberLevel) {
                    // 普卡/金卡
                    case Contants.MEMBER_LEVEL_JP:
                        scale = commonCard;
                        scaleType = Contants.MEMBER_LEVEL_JP;
                        scaleName = Contants.MEMBER_LEVEL_JP_NM;
                        break;
                    // 钛金卡/臻享白金卡
                    case Contants.MEMBER_LEVEL_TJ:
                        scale = platinumCard;
                        scaleType = Contants.MEMBER_LEVEL_TJ;
                        scaleName = Contants.MEMBER_LEVEL_TJ_NM;
                        break;
                    // 顶级/增值白金卡
                    case Contants.MEMBER_LEVEL_DJ:
                        scale = topCard;
                        scaleType = Contants.MEMBER_LEVEL_DJ;
                        scaleName = Contants.MEMBER_LEVEL_DJ_NM;
                        break;
                    // vip
                    case Contants.MEMBER_LEVEL_VIP:
                        scale = vip;
                        scaleType = Contants.MEMBER_LEVEL_VIP;
                        scaleName = Contants.MEMBER_LEVEL_VIP_NM;
                        break;
                    default:
                        break;
                }
                // 选择生日特权的场合并且生日比例是最优惠比例的场合
                if (birthday.compareTo(scale) < 0 && isUseBirthDiscount) {
                    // 判断是否过期和取得生日特权对应的兑换比例
                    SimpleDateFormat myFmt1 = new SimpleDateFormat(DateHelper.MM);
                    if (myFmt1.format(aCustToelectronbankModel.getBirthDay()).equals(myFmt1.format(new Date()))) {
                        scale = birthday;
                        scaleType = Contants.MEMBER_LEVEL_BIRTH;
                        scaleName = Contants.MEMBER_LEVEL_BIRTH_NM;
                    }
                }
                // 设置返回值积分兑换折扣以及对应的折扣名称,兑换比例小于1时才设置值
                if (scale.compareTo(new BigDecimal(1)) <= 0) {
                    result.put("scale", scale);
                    result.put("scaleType", scaleType);
                    result.put("scaleName", scaleName);
                }
            }
        }
        return result;
    }

    /**
     * 校验用户的第三级卡是否符合商品要求 借记卡没有第三级卡产品编码，商品设置设置第三级卡产品编码对借记卡不起作用 借记卡也没有卡等级，积分类型，如果礼品管理设置了该项，对借记卡也不起作用。
     */
    @Override
    public Response<Boolean> checkThreeCard(String goodsCode, User user) {
        Response<Boolean> result = new Response<Boolean>();
        // 用户积分比较
        try {
            GoodsModel goodsModel = goodsDao.findById(goodsCode);
            // 商品维护的第三级卡信息
            String[] cards = goodsModel.getCards() != null ? goodsModel.getCards().split(",") : null;
            // 用户是否有银行卡符合要求
            Boolean canBy = false;
            List<UserAccount> userCartDtoList = user.getAccountList();
            if (userCartDtoList != null && cards != null && cards.length > 0) {
                // 第三类卡编码为wwww不进行校验
                if ("wwww".equalsIgnoreCase(cards[0])) {
                    canBy = true;
                }
                // 有一张卡符合第三级卡要求则允许用户购买
                if (!canBy) {
                    a:
                    for (UserAccount userAccount : userCartDtoList) {
                        if (UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
                            Response<ACardCustToelectronbankModel> response = aCardCustToelectronbankService
                                    .findByCardNbr(userAccount.getCardNo());
                            if (response.isSuccess()) {
                                ACardCustToelectronbankModel aCardCustToelectronbankModel = response.getResult();
                                if (aCardCustToelectronbankModel != null) {
                                    for (String card : cards) {
                                        if (card.equals(aCardCustToelectronbankModel.getCardFormatNbr())) {
                                            canBy = true;
                                            break a;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            result.setResult(canBy);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.checkThreeCard.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.checkThreeCard.fail");
            return result;
        }
    }


    /**
     * 留学生卡附属卡金卡旅行意外险”或者“留学生附属卡普卡旅行意外险”的场合，
     * 仅限留学生卡主卡可兑换(此限制条件通过礼品的第三级卡产品编号进行控制)。
     * 然后，判断是否该卡号第7位为数字“2”，若不是则提示“您名下无留学生卡附属卡或附属卡未加挂于网银中。
     * 若您的附属卡未添于网银中，请添加后再作申请。”。
     */
    @Override
    public Response<Boolean> checkStudentAbroadCard(String cardss, User user) {
        Response<Boolean> result = new Response<Boolean>();
        // 用户积分比较
        try {
            // 商品维护的第三级卡信息
            String[] cards = cardss != null ? cardss.split(",") : null;
            // 用户是否有银行卡符合要求
            Boolean canBy = false;
            List<UserAccount> userCartDtoList = user.getAccountList();
            if (userCartDtoList != null && cards != null && cards.length > 0) {
                // 第三类卡编码为wwww不进行校验
                if ("wwww".equalsIgnoreCase(cards[0])) {
                    for (UserAccount userAccount : userCartDtoList) {
                        if (userAccount.getCardNo().substring(6,7).equals("2")) {
                            canBy = true;
                            break;
                        }
                    }
                }
                // 有一张卡符合第三级卡要求则允许用户购买
                if (!canBy) {
                    Boolean canByA = false;
                    Boolean canByB = false;
                    a:
                    for (UserAccount userAccount : userCartDtoList) {
                        if (UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
                            Response<ACardCustToelectronbankModel> response = aCardCustToelectronbankService
                                    .findByCardNbr(userAccount.getCardNo());
                            if (response.isSuccess()) {
                                ACardCustToelectronbankModel aCardCustToelectronbankModel = response.getResult();
                                if (aCardCustToelectronbankModel != null) {
                                    for (String card : cards) {
                                        if (card.equals(aCardCustToelectronbankModel.getCardFormatNbr())) {
                                            canByA = true;
                                            break a;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    b:
                    for (UserAccount userAccount : userCartDtoList) {
                        if(userAccount.getCardNo().substring(6,7).equals("2")){
                            canByB = true;
                            break b;
                        }
                    }
                    canBy = canByA&&canByB;
                }
            }
            result.setResult(canBy);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.checkThreeCard.fail.studentAbroad,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.checkThreeCard.studentAbroad");
            return result;
        }
    }
    /**
     * 根据单品编码取得推荐单品的相关信息（自动处理积分商城和广发商城的不同数据）
     *
     * @param itemCode
     * @return
     */
    @Override
    public CommendRankDto findItemInfoByItemCode(String itemCode) {
        //AttributeDto itemsAttributeDto;
        CommendRankDto map = new CommendRankDto();
        try {
            // 根据单品编码取得单品信息除去失效的商品
            ItemModel itemModel = itemDao.findItemDetailByCode(itemCode);
            if (itemModel != null) {
                map.setGoodsCode(itemModel.getGoodsCode());
                // 根据商品编码取得商品信息
                GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
                if (goodsModel == null) {
                    return null;
                }
                //区分处理广发商城和积分商城
                if (Contants.ORDERTYPEID_JF.equals(goodsModel.getOrdertypeId())) {//积分商城
                    if (Contants.CHANNEL_POINTS_02.equals(goodsModel.getChannelPoints())) {
                        List<TblGoodsPaywayModel> goodsPaywayModelList = tblGoodsPaywayDao.findByItemCode(itemModel.getCode());//支付方式获取
                        // 根据指定字段排序
                        Collections.sort(goodsPaywayModelList, new Comparator<TblGoodsPaywayModel>() {
                            @Override
                            public int compare(TblGoodsPaywayModel o1, TblGoodsPaywayModel o2) {
                                return ComparisonChain.start().compare(o1.getMemberLevel(), o2.getMemberLevel()).result();
                            }
                        });
                        TblGoodsPaywayModel goodsPaywayModel = goodsPaywayModelList.get(0);
                        if (goodsPaywayModel.getGoodsPoint() == null || goodsPaywayModel.getGoodsPoint() == 0l) {
                            map.setMinPoint("0");// 积分抵扣
                        } else {
                            DecimalFormat df = new DecimalFormat("#,###");
                            map.setMinPoint(df.format(goodsPaywayModel.getGoodsPoint()));// 积分抵扣
                        }
                        if (goodsPaywayModel.getGoodsPrice() != null && BigDecimal.ZERO.compareTo(goodsPaywayModel.getGoodsPrice()) != 0) {
                            DecimalFormat f1 = new DecimalFormat("0.00");
                            map.setPrices(f1.format(goodsPaywayModel.getGoodsPrice()));// 积分加现金
                        }
                    } else {
                        return null;
                    }
                } else if (Contants.ORDERTYPEID_YG.equals(goodsModel.getOrdertypeId())) {//广发商城
                    if (Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
                        //调用共通方法，查找单品最高期数
                        Integer insta = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
                        double totalPrice = itemModel.getPrice() == null ? 0d : itemModel.getPrice().doubleValue();
                        double price = Math.round(100 * totalPrice / insta) * 0.01d;
                        DecimalFormat f1 = new DecimalFormat("0.00");
                        map.setPrices(f1.format(price));// 每期价格
                        map.setMaxInstallmentNumber(String.valueOf(insta));// 最大分期数
                    } else {
                        return null;
                    }
                } else {
                    //扩展用，暂无此种情况。进入该分支为错误数据
                    return null;
                }
                // 单品信息设定(共同)
                map.setGoodsName(goodsModel.getName());// 商品名
                map.setImage(itemModel.getImage1());// 商品图片
                map.setItemCode(itemModel.getCode());// 单品编码
            }
            return map;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 根据用户取得最优的兑换比例
     *
     * @param user
     * @return
     */
    @Override
    public Response<List<CardScaleDto>> findCardScaleByUserId(User user) {
        Response<List<CardScaleDto>> result = new Response<List<CardScaleDto>>();
        // 全积分兑换Start
        // 判断是否登录浏览详情页 获取全积分信息
        List<CardScaleDto> cardScaleDtoList = Lists.newArrayList();
        try {
            if (user == null) {
                Response<CouponScaleDto> couponScaleModels = couponScaleService.findAll();
                if (couponScaleModels.isSuccess()) {
                    CouponScaleDto couponScaleDto = couponScaleModels.getResult();
                    /**
                     * commonCard;// 普卡/金卡 platinumCard;// 钛金卡/臻享白金卡 topCard;// 顶级/增值白金卡 VIP;// VIP birthday;// 生日
                     */
                    BigDecimal commonCard = couponScaleDto.getCommonCard();
                    BigDecimal platinumCard = couponScaleDto.getPlatinumCard();
                    BigDecimal topCard = couponScaleDto.getTopCard();
                    BigDecimal VIP = couponScaleDto.getVIP();
                    BigDecimal birthday = couponScaleDto.getBirthday();
                    // 普卡/金卡
                    CardScaleDto cardScaleDto = null;
                    if (commonCard != null) {
                        cardScaleDto = new CardScaleDto();
                        cardScaleDto.setCardName(Contants.MEMBER_LEVEL_JP_NM);
                        cardScaleDto.setScal(commonCard);
                        cardScaleDtoList.add(cardScaleDto);
                    }
                    // 钛金卡/臻享白金卡
                    if (platinumCard != null) {
                        cardScaleDto = new CardScaleDto();
                        cardScaleDto.setCardName(Contants.MEMBER_LEVEL_TJ_NM);
                        cardScaleDto.setScal(platinumCard);
                        cardScaleDtoList.add(cardScaleDto);
                    }
                    // 顶级/增值白金卡
                    if (topCard != null) {
                        cardScaleDto = new CardScaleDto();
                        cardScaleDto.setCardName(Contants.MEMBER_LEVEL_DJ_NM);
                        cardScaleDto.setScal(topCard);
                        cardScaleDtoList.add(cardScaleDto);
                    }
                    // VIP
                    if (VIP != null) {
                        cardScaleDto = new CardScaleDto();
                        cardScaleDto.setCardName(Contants.MEMBER_LEVEL_VIP_NM.toUpperCase());
                        cardScaleDto.setScal(VIP);
                        cardScaleDtoList.add(cardScaleDto);
                    }
                    // 生日
                    if (birthday != null) {
                        cardScaleDto = new CardScaleDto();
                        cardScaleDto.setCardName(Contants.MEMBER_LEVEL_BIRTH_NM);
                        cardScaleDto.setScal(birthday);
                        cardScaleDtoList.add(cardScaleDto);
                    }
                }
            } else {
                Map<String, Object> bestPointScale = getBestPointScale(true, user);
                CardScaleDto cardScaleDto = new CardScaleDto();
                if (bestPointScale != null && bestPointScale.get("scaleName") != null) {
                    cardScaleDto.setCardName(bestPointScale.get("scaleName").toString().toUpperCase());
                    cardScaleDto.setScal((BigDecimal) bestPointScale.get("scale"));
                    cardScaleDtoList.add(cardScaleDto);
                } else {
                    Response<CouponScaleDto> couponScaleModels = couponScaleService.findAll();
                    if (!couponScaleModels.isSuccess()) {
                        log.error("Response.error,error code: {}", couponScaleModels.getError());
                        throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
                    }
                    CouponScaleDto couponScaleDto = couponScaleModels.getResult();
                    BigDecimal commonCard = couponScaleDto.getCommonCard();
                    cardScaleDto = new CardScaleDto();
                    cardScaleDto.setCardName(Contants.MEMBER_LEVEL_JP_NM);
                    cardScaleDto.setScal(commonCard);
                    cardScaleDtoList.add(cardScaleDto);
                }
            }
        } catch (Exception e) {
            log.error("GoodsDetailService.couponScaleModels.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.couponScaleModels.fail");
            return result;
        }
        result.setResult(cardScaleDtoList);
        return result;
    }

    /**
     * 单品商品详细
     *
     * @param itemCode 单品编码
     * @return
     */
    @Override
    public Response<GoodsItemDto> findItemDetail(String itemCode) {

        Response<GoodsItemDto> result = new Response<GoodsItemDto>();
        try {
            // 商品信息
            GoodsItemDto goodsItemDto = new GoodsItemDto();
            // 商品信息
            GoodsModel goodsModel;
            // 单品信息
            ItemModel itemModel;
            itemModel = itemDao.findById(itemCode);
            goodsModel = goodsDao.findById(itemModel.getGoodsCode());
            List<RichAttribute> spuAttributes = attributeService.findSpuAttributesBy(goodsModel.getProductId());
            goodsItemDto.setSpuAttributes(spuAttributes);
            goodsItemDto.setGoodsModel(goodsModel);
            goodsItemDto.setItemModel(itemModel);
            result.setResult(goodsItemDto);
        } catch (Exception e) {
            log.error("GoodsDetailService.findGoodsInfo.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.findGoodsDescribe.fail");
        }
        return result;
    }
}