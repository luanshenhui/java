package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.PromotionPayWayDao;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.dto.ItemMakeDto;
import cn.com.cgbchina.item.dto.ItemRichDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;

import com.google.common.base.Function;
import com.google.common.base.Splitter;
import com.google.common.collect.Collections2;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Ordering;
import com.spirit.category.model.RichAttribute;
import com.spirit.category.model.Spu;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.BackCategoryService;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.exception.ServiceException;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;

import static com.google.common.base.Objects.equal;
import static com.google.common.base.Strings.isNullOrEmpty;

/**
 * Created by 11140721050130 on 2016/9/5.
 */
@Lazy(true)
@Component
@Slf4j
public class ItemIndexs {

    private final GoodsDao goodsDao;

    private final BackCategoryService backCategoryService;
    private final AttributeService attributeService;
    private final SpuService spuService;
    private final GoodsBrandDao goodsBrandDao;
    @Autowired
    private MallPromotionService mallPromotionService;
    private final PromotionPayWayDao promotionPayWayDao;
    @Autowired
    private TblGoodsPaywayDao tblGoodsPaywayDao;
    @Autowired
    private VendorService vendorService;
    @Autowired
    private PointsPoolService pointsPoolService;

    private final static Splitter splitter = Splitter.on(',').trimResults().omitEmptyStrings();
    private final static ImmutableList<String> channels=ImmutableList.of(Contants.CHANNEL_MALL_CODE, Contants.CHANNEL_PHONE_CODE,
            Contants.CHANNEL_SMS_CODE, Contants.CHANNEL_CC_CODE, Contants.CHANNEL_APP_CODE,
            Contants.CHANNEL_MALL_WX_CODE, Contants.CHANNEL_CREDIT_WX_CODE, Contants.CHANNEL_IVR_CODE);

    @Autowired
    public ItemIndexs(BackCategoryService backCategoryService, AttributeService attributeService,
                      SpuService spuService, GoodsBrandDao goodsBrandDao, GoodsDao goodsDao,
                      PromotionPayWayDao promotionPayWayDao) {
        this.attributeService = attributeService;
        this.backCategoryService = backCategoryService;
        this.spuService = spuService;
        this.goodsBrandDao = goodsBrandDao;
        this.goodsDao = goodsDao;
        this.promotionPayWayDao = promotionPayWayDao;
    }

    public ItemRichDto make(final ItemModel itemModel, final ItemMakeDto parItemMakeDto) {
        ItemMakeDto itemMakeDto = parItemMakeDto == null ? new ItemMakeDto() : parItemMakeDto;
        ItemRichDto richItem = BeanMapper.map(itemModel, ItemRichDto.class);
        String itemName = "";
        Long points=0L;//积分
        GoodsModel goodsModel = goodsDao.findById(itemModel.getGoodsCode());
        if (goodsModel == null) {
            log.error("goodMode(goodsCode={}) has no goodCode set", itemModel.getGoodsCode());
            throw new ServiceException("goods.id.null");
        }
        BeanMapper.copy(goodsModel, richItem);
        // 期数
        if (!equal(goodsModel.getOrdertypeId(), ChannelType.JFMALL.value())) {
            BigDecimal price = itemModel.getPrice();//商品原价,下面会被处理为最高期的分期价格
            richItem.setTotalPrice(price);//总价放商品原价
            //处理各渠道活动差异
            richItem.setOriginalTotalPrice(itemModel.getPrice());//商品原总价  不变 跟活动没关系
            //获取当月积分池的单位积分
            Long singlePoint=0L;
            Response<PointPoolModel> curMonthInfoR = pointsPoolService.getCurMonthInfo();
            if(curMonthInfoR.isSuccess()){
                singlePoint=curMonthInfoR.getResult().getSinglePoint();
            }
            //最佳倍率
            BigDecimal bestRate=itemModel.getBestRate();
            //积分数量=售价*最佳倍率*单位积分（广发商城）
            //积分数量=金普价（积分商城）
            // 需要同步活动信息
            if (itemMakeDto.isSynchroPromoData()) {
                // 临时先用循环
                boolean hasSetPrice = false;
                for (String channel : channels) {
                    Response<MallPromotionResultDto> mallPromotionResultDtoR = mallPromotionService.findPromByItemCodes("1", itemModel.getCode(), channel);
                    if (mallPromotionResultDtoR.isSuccess() && mallPromotionResultDtoR.getResult() != null) {
                        MallPromotionResultDto mallPromotionResultDto = mallPromotionResultDtoR.getResult();
//                richItem.setPromotionType(mallPromotionResultDto.getPromType());// 活动类型
                        PromotionItemResultDto promotionItemResultDto = mallPromotionResultDto.getPromItemResultList().get(0);
                        // 各渠道活动类型
                        this.setChannelPromoType(richItem, channel, mallPromotionResultDto.getPromType());
                        if (!hasSetPrice) {
                            hasSetPrice = true;
                            //如果是活动商品 总价为活动价 分期价待处理
                            switch (mallPromotionResultDto.getPromType()) {
                                case 10:
                                    price = price.multiply(mallPromotionResultDto.getRuleDiscountRate());
                                    richItem.setTotalPrice(price.multiply(mallPromotionResultDto.getRuleDiscountRate()));//折扣
                                    break;
                                case 30:
                                    price = promotionItemResultDto.getPrice();
                                    richItem.setTotalPrice(promotionItemResultDto.getPrice());//秒杀总价
                                    break;
                                case 40:
                                    price = promotionItemResultDto.getLevelPrice();
                                    richItem.setTotalPrice(promotionItemResultDto.getLevelPrice());//团购获取阶梯价
                                default:
                                    break;//满减和荷兰拍在搜索页面都显示原价
                            }
                        }
                    }
                }
            }
            //计算积分数量
            points=price.multiply(bestRate).multiply(BigDecimal.valueOf(singlePoint)).longValue();
            if(itemModel.getFixPoint()==null || "".equals(itemModel.getFixPoint())){
                richItem.setPoints(points);
                //放入原始积分数量 跟活动无关
                richItem.setOriginalPoints(itemModel.getPrice().multiply(bestRate).multiply(BigDecimal.valueOf(singlePoint)).longValue());
            }
            //普通和活动商品都需要这个处理
            if (StringUtils.isNotEmpty(itemModel.getInstallmentNumber())) {
                // 获取分期数组
                List<String> numberList = splitter.splitToList(itemModel.getInstallmentNumber());
                // 取最大分期数
                Integer maxNumber = Ordering.natural().max(Collections2.transform(numberList, new Function<String, Integer>() {
                    @Override
                    public Integer apply(String s) {
                        return Integer.valueOf(s);
                    }
                }));
                if (maxNumber > 0 && price != null) {
                    // 计算每期价格
                    price = price.divide(new BigDecimal(maxNumber), BigDecimal.ROUND_HALF_EVEN);
                    //原始分期价 跟活动没关系
                    richItem.setOriginalPrice(itemModel.getPrice().divide(new BigDecimal(maxNumber), BigDecimal.ROUND_HALF_EVEN));

                }
                richItem.setInstallmentNumber(String.valueOf(maxNumber));
            }
            richItem.setPrice(price);
            //积分商城
        } else {
            List<TblGoodsPaywayModel> paywayList = tblGoodsPaywayDao.findListForSearch(itemModel.getId());
            if(paywayList != null && paywayList.size() > 0){
                for(TblGoodsPaywayModel paywayModel:paywayList){
                    switch (paywayModel.getMemberLevel()){
                        case Contants.MEMBER_LEVEL_JP_CODE:
                            richItem.setPoints(paywayModel.getGoodsPoint());//金普价
                            richItem.setOriginalPoints(paywayModel.getGoodsPoint());//积分商城无活动 每次都取原价
                            break;
                        case Contants.MEMBER_LEVEL_TJ_CODE:
                            richItem.setTjPoints(paywayModel.getGoodsPoint());//钛金卡价
                            break;
                        case Contants.MEMBER_LEVEL_DJ_CODE:
                            richItem.setDjPoints(paywayModel.getGoodsPoint());//顶级卡
                            break;
                        case Contants.MEMBER_LEVEL_VIP_CODE:
                            richItem.setVipPoints(paywayModel.getGoodsPoint());// VIP
                            break;
                        case Contants.MEMBER_LEVEL_BIRTH_CODE:
                            richItem.setBirthPoints(paywayModel.getGoodsPoint());//生日
                            break;
                        case Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE:
                            richItem.setJfPoints(paywayModel.getGoodsPoint());//积分+现金场合的积分
                            richItem.setXjPrice(paywayModel.getGoodsPrice());//积分+现金场合的现金
                            break;
                        default:
                            richItem.setPoints(paywayModel.getGoodsPoint());//金普价
                            richItem.setOriginalPoints(paywayModel.getGoodsPoint());//积分商城无活动 每次都取原价
                            break;
                    }
                }
            }
        }
        richItem.setGoodsCode(itemModel.getGoodsCode());
        richItem.setCode(itemModel.getCode());
        richItem.setOrdertypeId(goodsModel.getOrdertypeId());
        // 销售数量
        richItem.setSalesNum(itemModel.getGoodsTotal());
        // 供应商信息
        String vendorId = goodsModel.getVendorId();
        if (!isNullOrEmpty(vendorId)) {
            Response<VendorInfoModel> vendorInfoR = vendorService.findVendorById(vendorId);
            if (vendorInfoR.isSuccess()) {
                VendorInfoModel vendorInfoModel = vendorInfoR.getResult();
                // 供应商名
                richItem.setVendorName(vendorInfoModel.getSimpleName());
            }
        }

        itemName = goodsModel.getName();
//        Long brandId = goodsModel.getGoodsBrandId();
//        GoodsBrandModel goodsBrandModel = goodsBrandDao.findById(brandId);
//        if (goodsBrandModel == null) {
//            log.error("failed to find brand by id {}", brandId);
//        } else {
//            itemName = itemName + "  " + goodsBrandModel.getBrandName();
//        }

        Long spuId = goodsModel.getProductId();
        if (spuId == null) {
            log.error("item(id={}) has no spuId set", richItem.getId());
            throw new ServiceException("spu.id.null");
        }
        final Response<Spu> spuR = spuService.findById(spuId);
        if (!spuR.isSuccess()) {
            log.error("failed to find spu by id={}, error code:{}", spuId, spuR.getError());
            throw new ServiceException("spu.not.found");
        }
        Spu spu = spuR.getResult();
        Long categoryId = spu.getCategoryId();
        Response<List<Long>> ancestorsR = backCategoryService.ancestorsOf(categoryId);
        if (!ancestorsR.isSuccess()) {
            log.error("fail to find ancestor category by leaf category id={}, item id={}, error code:{}",
                    categoryId, goodsModel.getCode(), ancestorsR.getError());
            throw new ServiceException("category.not.found");
        }
        List<Long> ancestors = ancestorsR.getResult();
        List<RichAttribute> attributes = attributeService.findSpuAttributesBy(spuId);
        richItem.setCategoryIds(ancestors);
        ImmutableSet.Builder<Long> builder = new ImmutableSet.Builder<Long>();
        for (RichAttribute attribute : attributes) {
            builder = builder.add(attribute.getAttributeValueId());
        }
        richItem.setAttributeIds(builder.build());
        // 商品名 添加属性 和品牌 名 便于单品搜索
        richItem.setName(buildItemName(itemName,itemModel));

        return richItem;
    }

    public String buildItemName(String itemName,ItemModel itemModel) {
        if (!isNullOrEmpty(itemModel.getAttributeName1()) && !"无".equals(itemModel.getAttributeName1())) {
            itemName += "/" + itemModel.getAttributeName1();
        }
        if (!isNullOrEmpty(itemModel.getAttributeName2()) && !"无".equals(itemModel.getAttributeName2())) {
            itemName += "/" + itemModel.getAttributeName2();
        }
        return itemName;
    }

    // 各渠道活动类型
    private void setChannelPromoType(ItemRichDto richItem, String channel, Integer promType) {
        // 渠道类型过滤
        switch (channel) {
            case Contants.CHANNEL_MALL_CODE: // 00:网上商城（包括广发，积分商城）
                richItem.setMallPromoType(promType);
                break;
            case Contants.CHANNEL_PHONE_CODE: // "03" 手机商城
                richItem.setPhonePromoType(promType);
                break;
            case Contants.CHANNEL_SMS_CODE: // "04"短信渠道
                richItem.setSmsPromoType(promType);
                break;
            case Contants.CHANNEL_CC_CODE: // "01"呼叫中心
                richItem.setCcPromoType(promType);
                break;
            case Contants.CHANNEL_APP_CODE: // "09"APP渠道
                richItem.setAppPromoType(promType);
                break;
            case Contants.CHANNEL_MALL_WX_CODE: // "05"广发银行(微信)
                richItem.setMallWxPromoType(promType);
                break;
            case Contants.CHANNEL_CREDIT_WX_CODE: // "06"广发信用卡(微信)
                richItem.setCreditWxPromoType(promType);
                break;
            case Contants.CHANNEL_IVR_CODE: // "02"IVR渠道
                richItem.setIvrPromoType(promType);
                break;
            default:
                break;
        }
    }
}
