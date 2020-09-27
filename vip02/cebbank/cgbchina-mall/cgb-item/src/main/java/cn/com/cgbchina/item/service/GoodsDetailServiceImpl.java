package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dao.*;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.*;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

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
    private FavoriteService favoriteService;
    @Resource
    private ServicePromiseDao servicePromiseDao;
    @Resource
    private ACustToelectronbankService aCustToelectronbankService;
    @Resource
    private CouponScaleService couponScaleService;
    @Resource
    private PointsPoolService pointsPoolService;
    @Resource
    private CustInfoCommonService custInfoCommonService;
    @Resource
    private UserBrowseHistoryService userBrowseHistoryService;
    @Resource
    private TblGoodsPaywayDao tblGoodsPaywayDao;
    @Autowired
    private ACardCustToelectronbankService aCardCustToelectronbankService;

    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    @Override
    public Response<Map<String, Object>> findDetailByGoodCode(@Param("itemCode") String itemCode,
                                                              @Param("goodCode") String goodCode) {
        Response<Map<String, Object>> result = new Response<Map<String, Object>>();
        if (goodCode == null) {
            log.error("goodCode id can not be null");
            result.setError("goodCode.id.null");
            return result;
        }
        // 根据商品Code 查询商品信息
        GoodsModel goodsModel = goodsDao.findById(goodCode);
        if (goodsModel == null) {
            log.error("goodsModel(id={}) not found", goodCode);
            result.setError("goodsModel.not.found");
            return result;
        }
        // 根据商品code查询单品信息
        List<ItemModel> itemList = itemDao.findItemDetailByGoodCode(goodCode);
        GoodFullDto goodsDetail = new GoodFullDto();
        goodsDetail.setGoodsModel(goodsModel);
        ItemModel defaultItem = null;
        // 默认选择第一条单品
        if (itemList != null) {
            defaultItem = itemList.get(0);
        }
        // 设置默认单品信息
        if (!Strings.isNullOrEmpty(itemCode)) {
            for (ItemModel itemModel : itemList) {
                if (itemCode.equals(itemModel.getCode())) {
                    defaultItem = itemModel;
                }
            }
        }
        //goodsDetail.setDefaultItem(defaultItem);
        // 单品组
        ItemGroup itemGroup = new ItemGroup(itemList);
        goodsDetail.setItemGroup(itemGroup.getAttributes());
        Map<String, Object> map = Maps.newHashMapWithExpectedSize(2);
        map.put("fullItem", goodsDetail);
        result.setResult(map);
        return result;
    }

    /**
     * 获取商品信息 图片 属性
     *
     * @param goodsCode
     * @param itemCode
     * @return
     */
    @Override
    public Response<GoodsItemDto> findGoodsInfo(@Param("goodsCode") String goodsCode,
                                                @Param("itemCode") String itemCode) {

        Response<GoodsItemDto> result = new Response<GoodsItemDto>();
        try {
            // 商品信息
            GoodsItemDto goodsItemDto = new GoodsItemDto();
            // 商品信息
            GoodsModel goodsModel = new GoodsModel();
            // 单品信息
            ItemModel itemModel = new ItemModel();
            // 该商品的所有单品
            List<ItemModel> itemModelList = new ArrayList<>();
            //商品规格属性信息
            ItemsAttributeDto goodsAttribute = new ItemsAttributeDto();
            //单品规格属性信息
            ItemsAttributeDto itemsAttribute = new ItemsAttributeDto();

            // 未选择单品进入商品详情页面 先取得itemCode 显示商品的第一顺位单品信息 若itemCode不为空显示单品信息
            if (itemCode == null || itemCode.trim().isEmpty()) {
                itemCode = itemDao.findItemDetailByGoodCode(goodsCode).get(0).getCode();
            }

            // 若仅给传itemcod未传递goodscode 先查询goodscode
            if (goodsCode == null || goodsCode.trim().isEmpty()) {
                goodsCode = itemDao.findItemDetailByCode(itemCode).getGoodsCode();
            }
            goodsModel = goodsDao.findById(goodsCode);
            itemModel = itemDao.findById(itemCode);
            itemModelList = itemDao.findItemDetailByGoodCode(goodsCode);
            goodsAttribute = jsonMapper.fromJson(goodsModel.getAttribute(), ItemsAttributeDto.class);
            itemsAttribute = jsonMapper.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);

            // 去除规格中的空属性
            ItemsAttributeDto goodsAttributeNoNull = new ItemsAttributeDto();// 用于页面展示的规格
            List<ItemsAttributeSkuDto> itemsAttrNoNullList = new ArrayList<>();// 有具体属性的商品规格
            // 如果有具体规格则添加到List中
            if (goodsAttribute != null) {
                List<ItemsAttributeSkuDto> itemsAttributeSkuDtoList = goodsAttribute.getSkus();
                if (itemsAttributeSkuDtoList != null) {
                    for (ItemsAttributeSkuDto itemsAttributeSkuDto : itemsAttributeSkuDtoList) {
                        List<ItemAttributeDto> itemAttributeDtoList = itemsAttributeSkuDto.getValues();
                        if (itemAttributeDtoList != null) {
                            itemsAttrNoNullList.add(itemsAttributeSkuDto);
                        }
                    }
                }
            }
            // 去除未维护的属性
            List<ItemsAttributeSkuDto> tempskus = new ArrayList<ItemsAttributeSkuDto>();
            for (ItemsAttributeSkuDto skus : itemsAttrNoNullList) {
                //临时存储一种属性的对应的规格信息
                Map<Long, String> valuemap = new HashMap<Long, String>();
                for (ItemModel itemModel1 : itemModelList) {
                    ItemsAttributeDto tempitemsAttribute = jsonMapper.fromJson(itemModel1.getAttribute(),
                            ItemsAttributeDto.class);
                    for (ItemsAttributeSkuDto tempItemsAttributeSkuDto : tempitemsAttribute.getSkus()) {
                        // 详细规格与商品规格一致
                        if (tempItemsAttributeSkuDto.getAttributeValueKey().equals(skus.getAttributeValueKey())) {
                            valuemap.put(tempItemsAttributeSkuDto.getValues().get(0).getAttributeValueKey(),
                                    tempItemsAttributeSkuDto.getValues().get(0).getAttributeValueName());
                        }
                    }
                }
                // 商品一种属性对应的所有已维护的单品规格
                List<ItemAttributeDto> valueList = new ArrayList<ItemAttributeDto>();
                for (Map.Entry<Long, String> entry : valuemap.entrySet()) {
                    ItemAttributeDto tempE = new ItemAttributeDto();
                    tempE.setAttributeValueKey(entry.getKey());
                    tempE.setAttributeValueName(entry.getValue());
                    valueList.add(tempE);
                }
                ItemsAttributeSkuDto tempItemsAttributeSkuDto = new ItemsAttributeSkuDto();
                tempItemsAttributeSkuDto.setAttributeValueKey(skus.getAttributeValueKey());
                tempItemsAttributeSkuDto.setAttributeValueName(skus.getAttributeValueName());
                tempItemsAttributeSkuDto.setValues(valueList);
                tempskus.add(tempItemsAttributeSkuDto);
            }
            goodsAttributeNoNull.setSkus(tempskus);
            goodsAttributeNoNull.setAttributes(goodsAttribute != null ? goodsAttribute.getAttributes() : null);

            // 获取服务承诺 多个值逗号分割
            List<ServicePromiseModel> servicePromiseModelList = new ArrayList<ServicePromiseModel>();
            if (goodsModel.getServiceType() != null && !goodsModel.getServiceType().trim().isEmpty()) {
                String[] servicetTypes = goodsModel.getServiceType().split(",");
                ServicePromiseModel servicePromiseModel = new ServicePromiseModel();
                for (String servicetType : servicetTypes) {
                    servicePromiseModel = servicePromiseDao.findById(Long.parseLong(servicetType));
                    if (servicePromiseModel != null) {
                        servicePromiseModelList.add(servicePromiseModel);
                    }
                }
            }

            // 获取当月积分池比例Start
            PointPoolModel pointPoolModel = new PointPoolModel();
            Long lastSinglePoint = null;
            Response<PointPoolModel> response = pointsPoolService.getLastInfo();
            pointPoolModel = response.getResult();
            if (pointPoolModel != null) {
                lastSinglePoint = pointPoolModel.getSinglePoint();
            }
            // 获取当月积分池比例End

            // 全积分兑换End
            // 商品支付方式start
            List<ItemGoodsDetailDto> itemGoodsDetailDtoList = new ArrayList<ItemGoodsDetailDto>();
            //默认显示的商品信息
            ItemGoodsDetailDto itemGoodsDetailDto = new ItemGoodsDetailDto();
            //单品支付价格
            TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
            tblGoodsPaywayModel.setGoodsId(itemModel.getCode());
            List<TblGoodsPaywayModel> goodsPaywayModelList = tblGoodsPaywayDao.getPayWayforItemId(tblGoodsPaywayModel);
            BeanMapper.copy(itemModel, itemGoodsDetailDto);
            itemGoodsDetailDto.setTblGoodsPaywayModelList(goodsPaywayModelList);
            if (itemModelList != null) {
                //单品的支付价格（分期 每期价格和期数信息）
                for (ItemModel tempItemModel : itemModelList) {
                    ItemGoodsDetailDto tempItemGoodsDetailDtos = new ItemGoodsDetailDto();
                    BeanMapper.copy(tempItemModel, tempItemGoodsDetailDtos);
                    tblGoodsPaywayModel = new TblGoodsPaywayModel();
                    tblGoodsPaywayModel.setGoodsId(tempItemModel.getCode());
                    List<TblGoodsPaywayModel> goodsPaywayModelLists = tblGoodsPaywayDao
                            .getPayWayforItemId(tblGoodsPaywayModel);
                    tempItemGoodsDetailDtos.setTblGoodsPaywayModelList(goodsPaywayModelLists);
                    itemGoodsDetailDtoList.add(tempItemGoodsDetailDtos);
                }
            }

            // 商品支付方式end
            goodsItemDto.setGoodsModel(goodsModel);
            goodsItemDto.setItemGoodsDetailDto(itemGoodsDetailDto);
            goodsItemDto.setGoodAttr(goodsAttributeNoNull);
            goodsItemDto.setItemAttr(itemsAttribute);
            goodsItemDto.setItemGoodsDetailDtoList(itemGoodsDetailDtoList);
            goodsItemDto.setServicePromiseModelList(servicePromiseModelList);
            goodsItemDto.setLastSinglePoint(lastSinglePoint);
            // 插入浏览历史记录
//            try {
//                if (user != null && user.getCustId() != null) {
//                    // 最大分期数
//                    int insta = 1;
//                    if (itemModel.getInstallmentNumber() != null) {
//                        String[] installs = itemModel.getInstallmentNumber().split(",");
//                        insta = Integer.valueOf(installs[0]).intValue();
//                        for (int i = 0; i < installs.length; i++) {
//                            if (insta < Integer.valueOf(installs[i]).intValue()) {
//                                insta = Integer.valueOf(installs[i]).intValue();
//                            }
//                        }
//                    }
//                    // 插入用户浏览历史
//                    userBrowseHistoryService.loinBrowseHistory(itemModel.getGoodsCode(), itemModel.getCode(),
//                            itemModel.getPrice(), user.getCustId(), insta);
//                }
//            } catch (Exception e) {
//            }
            result.setResult(goodsItemDto);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.findGoodsInfo.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.findGoodsDescribe.fail");
            return result;
        }
    }

    /**
     * 查询商品详情 商品规格 购买咨询
     *
     * @param goodsCode
     * @param itemCode
     * @return
     */
    @Override
    public Response<GoodsDescribeDto> findGoodsDescribe(@Param("goodsCode") String goodsCode,
                                                        @Param("itemCode") String itemCode, @Param("pageNo") Integer pageNo, @Param("size") Integer size) {

        Response<GoodsDescribeDto> result = new Response<GoodsDescribeDto>();
        // 商品详情 商品规格 购买咨询实体
        GoodsDescribeDto goodsDescribeDto = new GoodsDescribeDto();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        if (goodsCode == null || goodsCode.trim().isEmpty()) {
            goodsCode = itemDao.findItemDetailByCode(itemCode).getGoodsCode();
        }
        try {
            // 商品信息
            GoodsModel goodsModel = new GoodsModel();
            // 单品信息
            ItemModel itmeModel = new ItemModel();
            // 供应商信息
            VendorInfoModel vendorInfoModel = new VendorInfoModel();
            // 购买咨询信息
            Pager<GoodsConsultModel> goodsConsultModelPager = new Pager<GoodsConsultModel>();
            // 商品描述
            ItemsAttributeDto goodsAttributeDto = new ItemsAttributeDto();
            // 商品信息
            goodsModel = goodsDao.findById(goodsCode);
            goodsDescribeDto.setGoodsModel(goodsModel);
            // 单品信息
            itmeModel = itemDao.findById(itemCode);
            goodsDescribeDto.setItemModel(itmeModel);
            // 供应商信息
            String vendorId = goodsModel.getVendorId();
            // 供应商信息
            vendorInfoModel = vendorService.findById(vendorId).getResult();
            goodsDescribeDto.setVendorInfoModel(vendorInfoModel);

            Map<String, Object> params = new HashMap<String, Object>();
            params.put("goodsCode", goodsCode);

            goodsConsultModelPager = goodsConsultDao.findByPageByCode(params, pageInfo.getOffset(),
                    pageInfo.getLimit());
            goodsDescribeDto.setGoodsConsultModelPager(goodsConsultModelPager);

            goodsAttributeDto = jsonMapper.fromJson(goodsModel.getAttribute(), ItemsAttributeDto.class);
            goodsDescribeDto.setGoodAttr(goodsAttributeDto);

            result.setResult(goodsDescribeDto);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.findGoodsFormat.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.findGoodsFormat.fail");
            return result;
        }
    }

    /**
     * 获取热门收藏
     *
     * @return
     */
    @Override
    public Response<List<Map<String, Object>>> findGoodsCollectTop() {

        Response<List<Map<String, Object>>> result = new Response<List<Map<String, Object>>>();
        try {
            Map<String, Object> paramMap = Maps.newHashMap();
            List<GoodsDetailDto> topCollectList = favoriteService.find(paramMap);
            if (!topCollectList.isEmpty()) {
                List<Map<String, Object>> maps = new ArrayList<Map<String, Object>>();
                for (int i = 0; i < topCollectList.size(); i++) {
                    // 只获得收藏前三个
                    if (i > 3) {
                        break;
                    }
                    try {
                        Map<String, Object> findItem = findItemInfoByItemCode(topCollectList.get(i).getItemCode());
                        if (findItem != null) {
                            maps.add(findItem);
                        }
                    } catch (Exception e) {
                        log.error("GoodsDetailService.findItemInfoByItemCode.fail,cause:{}", Throwables.getStackTraceAsString(e));
                    }
                }
                result.setResult(maps);
            }
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.findGoodsCollect.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.findGoodsCollect.fail");
            return result;
        }
    }

    /**
     * 获取推荐商品
     *
     * @param goodsCode
     * @return
     */
    @Override
    public Response<List<Map<String, Object>>> findGoodsRecommend(@Param("goodsCode") String goodsCode,
                                                                  @Param("itemCode") String itemCode) {
        Response<List<Map<String, Object>>> result = new Response<List<Map<String, Object>>>();
        if (goodsCode == null || goodsCode.trim().isEmpty()) {
            goodsCode = itemDao.findItemDetailByCode(itemCode).getGoodsCode();
        }
        try {
            // 商品信息
            List<Map<String, Object>> itemInfoModels = new ArrayList<>();
            //商品信息
            GoodsModel goodsModel = new GoodsModel();
            goodsModel = goodsDao.findById(goodsCode);
            //关联推荐商品
            List<String> rocommendList = new ArrayList<>();
            rocommendList.add(goodsModel.getRecommendGoods1Code());
            rocommendList.add(goodsModel.getRecommendGoods2Code());
            rocommendList.add(goodsModel.getRecommendGoods3Code());
            // 获得推荐商品对应的单品信息
            if (rocommendList != null) {
                for (String data : rocommendList) {
                    GoodsModel rmdGdDetail = new GoodsModel();
                    ItemModel itemModel = new ItemModel();
                    itemModel = itemDao.findById(data);
                    //查询商品的展示信息
                    Map<String, Object> findItem = findItemInfoByItemCode(itemModel.getCode());
                    if (findItem != null) {
                        itemInfoModels.add(findItem);
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
        Pager<GoodsConsultModel> goodsConsultModelPager = new Pager<GoodsConsultModel>();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("goodsCode", goodsCode);
        //分页获得商品信息
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
    //TODO:开发中
    public Response<BirthdayTipDto> getUserBirth(@Param("certNo") String certNo) {
        Response<BirthdayTipDto> result = new Response<BirthdayTipDto>();
        BirthdayTipDto dto = new BirthdayTipDto();
        String birthDay = "";
        aCustToelectronbankService.getUserBirth(certNo);
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
        // 检索优惠折扣比例表
        Response<CouponScaleDto> couponScaleDtoResponse = couponScaleService.findAll();
        if (couponScaleDtoResponse.isSuccess() && certNo != null && !certNo.equals("")) {
            BigDecimal birthday = couponScaleDtoResponse.getResult().getBirthday();
            BigDecimal vip = couponScaleDtoResponse.getResult().getVIP();
            BigDecimal topCard = couponScaleDtoResponse.getResult().getTopCard();
            BigDecimal platinumCard = couponScaleDtoResponse.getResult().getPlatinumCard();
            BigDecimal commonCard = couponScaleDtoResponse.getResult().getCommonCard();
            // 通过客户证件号码取得客户最高卡等级对应的信息
            ACustToelectronbankModel aCustToelectronbankModel = custInfoCommonService
                    .getMaxCardLevelCustInfoByCertNbr(certNo);
            if (aCustToelectronbankModel != null) {
                // 通过最高卡等级取得客户最优等级
                String memberLevel = custInfoCommonService.calMemberLevel(certNo,
                        aCustToelectronbankModel.getCardLevelCd(), aCustToelectronbankModel.getVipTpCd());
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
                if (scale.compareTo(new BigDecimal(1)) < 0) {
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
            //商品维护的第三级卡信息
            String[] cards = goodsModel.getCards() != null ? goodsModel.getCards().split(",") : null;
            //用户是否有银行卡符合要求
            Boolean canBy = false;
            List<UserAccount> userCartDtoList = user.getAccountList();
            if (userCartDtoList != null && cards != null && cards.length > 0) {
                //有一张卡符合第三级卡要求则允许用户购买
                a:
                for (UserAccount userAccount : userCartDtoList) {
                    if (UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
                        ACardCustToelectronbankModel aCardCustToelectronbankModel = aCardCustToelectronbankService
                                .findByCardNbr(userAccount.getCardNo());
                        for (String card : cards) {
                            if (card.equals(aCardCustToelectronbankModel.getCardFormatNbr())) {
                                canBy = true;
                                break a;
                            }
                        }
                    }
                }
            }
            result.setResult(true);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.checkThreeCard.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.checkThreeCard.fail");
            return result;
        }
    }

    /**
     * 校验用户信用卡中是否含有普通积分
     */
    //TODO:开发中
    @Override
    public Response<Boolean> checkCommonAmount(User user) {
        Response<Boolean> result = new Response<Boolean>();
        try {
            Boolean isCommon = false;
            // 用户积分比较
            String cardNo = "";
            List<UserAccount> userCartDtoList = user.getAccountList();

            for (UserAccount userAccount : userCartDtoList) {
                if (UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
                    cardNo = userAccount.getCardNo();
                    break;
                }
            }
            Map amountMap = new HashMap();
            BigDecimal commonAmount = BigDecimal.valueOf(0);
            BigDecimal hopeAmount = BigDecimal.valueOf(0);
            BigDecimal truthAmount = BigDecimal.valueOf(0);

            // QueryPointsInfo queryPointsInfo = new QueryPointsInfo();
            // queryPointsInfo.setChannelID("MALL");
            // queryPointsInfo.setCurrentPage("1");
            // queryPointsInfo.setCardNo(cardNo);
            // SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");//设置日期格式
            // queryPointsInfo.setStartDate(df.format(new Date()));
            // queryPointsInfo.setEndDate(df.format(new Date()));
            //
            // List<QueryPointsInfoResultVO> queryPointsInfoResultVOList =
            // pointService.queryPoint(queryPointsInfo).getQueryPointsInfoResults();
            // String successCode = pointService.queryPoint(queryPointsInfo).getSuccessCode();
            // if ("00".equals(successCode)) {
            // for (QueryPointsInfoResultVO queryPointsInfoResultVO : queryPointsInfoResultVOList) {
            // if ("001".equals(queryPointsInfoResultVO.getJgId())) {
            // commonAmount = commonAmount.add(queryPointsInfoResultVO.getAmount());
            // isCommon = true;
            // break;
            // }
            // }
            // }
            result.setResult(isCommon);
            return result;
        } catch (Exception e) {
            log.error("GoodsDetailService.checkCommonAmount.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.checkCommonAmount.fail");
            return result;
        }
    }

    /**
     * 根据单品编码取得推荐单品的相关信息
     *
     * @param itemCode
     * @return
     */
    @Override
    public Map<String, Object> findItemInfoByItemCode(String itemCode) {
        Response<RecommendGoodsDto> response = new Response<RecommendGoodsDto>();
        RecommendGoodsDto recommendItem = new RecommendGoodsDto();
        ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
        Map<String, Object> map = null;
        try {
            // 根据单品编码取得单品信息没有除去失效的商品
            ItemModel itemModel = itemDao.findById(itemCode);
            if (itemModel != null) {
                itemsAttributeDto = jsonMapper.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
                if (itemsAttributeDto != null) {
                    List<ItemsAttributeSkuDto> skus = itemsAttributeDto.getSkus();
                    // 根据商品编码取得商品信息
                    GoodsModel recommendGoods = goodsDao.findById(itemModel.getGoodsCode());
                    // 单品描述
                    StringBuffer sb = new StringBuffer();
                    sb.append(recommendGoods.getName());
                    for (ItemsAttributeSkuDto sku : skus) {
                        sb.append(sku.getValues().get(0).getAttributeValueName());
                    }
                    int insta = 1;
                    if (itemModel.getInstallmentNumber() != null) {
                        String[] installs = itemModel.getInstallmentNumber().split(",");
                        insta = Integer.valueOf(installs[0]).intValue();
                        for (int i = 0; i < installs.length; i++) {
                            if (insta < Integer.valueOf(installs[i]).intValue()) {
                                insta = Integer.valueOf(installs[i]).intValue();
                            }
                        }
                    }
                    double totalPrice = itemModel.getPrice() == null ? 0d : itemModel.getPrice().doubleValue();
                    double price = Math.ceil(totalPrice / insta);
                    DecimalFormat f1 = new DecimalFormat("0.00");
                    // 单品信息设定
                    map = Maps.newHashMap();
                    map.put("goodsName", sb.toString());//商品名
                    map.put("prices", f1.format(price));//每期价格
                    map.put("image", itemModel.getImage1());//商品图片
                    map.put("itemCode", itemModel.getCode());//单品编码
                    map.put("maxInstallmentNumber", String.valueOf(insta));//最大分期数
                }
            }
            return map;
        } catch (Exception e) {
            return null;
        }
    }

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
                }
                cardScaleDtoList.add(cardScaleDto);
            }
        } catch (Exception e) {
            log.error("GoodsDetailService.couponScaleModels.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("GoodsDetailService.couponScaleModels.fail");
            return result;
        }
        result.setResult(cardScaleDtoList);
        return result;
    }
}