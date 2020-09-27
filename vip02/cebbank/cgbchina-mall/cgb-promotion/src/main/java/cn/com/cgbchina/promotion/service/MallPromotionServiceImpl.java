package cn.com.cgbchina.promotion.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.ItemsAttributeDto;
import cn.com.cgbchina.item.dto.ItemsAttributeSkuDto;
import cn.com.cgbchina.item.model.FrontCategory;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.FrontCategoriesService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.promotion.dao.PromotionDao;
import cn.com.cgbchina.promotion.dao.PromotionPeriodDao;
import cn.com.cgbchina.promotion.dao.PromotionRangeDao;
import cn.com.cgbchina.promotion.dto.GoodsGroupBuyDto;
import cn.com.cgbchina.promotion.dto.MallPromotionResultDto;
import cn.com.cgbchina.promotion.model.PromotionModel;
import cn.com.cgbchina.promotion.model.PromotionRangeModel;
import cn.com.cgbchina.trade.service.OrderService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

@Service
@Slf4j
public class MallPromotionServiceImpl implements MallPromotionService {

    @Resource
    private PromotionDao promotionDao;
    @Resource
    private PromotionRangeDao promotionRangeDao;
    @Resource
    PromotionPeriodDao promotionPeriodDao;
    @Resource
    private ItemService itemService;
    //    @Resource
//    private OrderService orderService;
    @Resource
    private FrontCategoriesService frontCategoriesService;

    /**
     * 获取广发团信息
     *
     * @return geshuo 20160704
     */
    @Override
    public Response<Map<String, Object>> findGroupBuyData(@Param("ids") List<Long> ids) {
        //TODO:推荐单品id集合
        List<String> recItemIdList = Lists.newArrayList();
        recItemIdList.add("dmin16070600576");
        recItemIdList.add("dmin16070600590");
        recItemIdList.add("dmin16070600592");
        recItemIdList.add("dmin16070600596");

        Response<Map<String, Object>> response = new Response<>();
        try {
            Map<String, Object> result = Maps.newHashMap();

            List<Integer> groupPromotionIds = Lists.newArrayList();//团购活动id列表
            //查询活动
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);//广发商城
            paramMap.put("currentDate", new Date());//当前时间
            paramMap.put("promType", Contants.PROMOTION_PROM_TYPE_4);//活动类型:团购
            paramMap.put("noLoopType", -1);//传值-1时 ，SQL判断条件为 loopType为空

            List<Integer> statusList = Lists.newArrayList();
            statusList.add(Contants.PROMOTION_STATE_7);//已提交(已通过)
            statusList.add(Contants.PROMOTION_STATE_8);//已提交(部分通过)
            statusList.add(Contants.PROMOTION_STATE_9);//正在进行
            paramMap.put("statusList", statusList);
            List<Integer> noLoopIdList = promotionDao.findPromotionIds(paramMap);//不循环执行的id列表
            for (Integer noLoopPromotionId : noLoopIdList) {
                groupPromotionIds.add(noLoopPromotionId);
            }

            List<Integer> periodPromotionIds = promotionPeriodDao.findNowPromotionIds();//循环执行的活动id列表

            List<PromotionModel> periodPromotionList = promotionDao.findPromotionByIds(periodPromotionIds);

            Map<Integer, PromotionModel> promotionMap = Maps.newHashMap();//团购活动map
            for (PromotionModel promModel : periodPromotionList) {
                if (promModel.getPromType() == Contants.PROMOTION_PROM_TYPE_4) {
                    Integer promId = promModel.getId();
                    groupPromotionIds.add(promId);//添加团购活动id
                    promotionMap.put(promId, promModel);//id作为key
                }
            }


            if (groupPromotionIds.size() == 0) {
                //当前没有团购活动
                response.setResult(result);
                return response;
            }
            if (groupPromotionIds.size() == 1) {
                Integer promotionId = groupPromotionIds.get(0);
                //查询正在进行的活动详情
                PromotionModel promotionModel = promotionMap.get(groupPromotionIds.get(0));
                if (promotionModel == null) {
                    promotionModel = promotionDao.findById(promotionId);
                }

                //获取活动结束时间
                Calendar cal = Calendar.getInstance();
                cal.setTime(promotionModel.getEndDate());
                cal.add(Calendar.DAY_OF_MONTH, 1);//因为存的数据是00:00:00,所以加1天
                Date endDate = cal.getTime();//活动结束时间
                result.put("endDate", endDate.getTime());
            }

            //TODO:获取活动一级类目,以后应该从promotion_range表中获取
            Response<List<FrontCategory>> catResponse = frontCategoriesService.findChildById(0l);
            if (!catResponse.isSuccess()) {
                response.setSuccess(false);
                response.setError("MallPromotionServiceImpl.findGroupBuyData.error");
                return response;
            }
            List<FrontCategory> categoryList = catResponse.getResult();
            List<FrontCategory> newCatList = new ArrayList<>();

            for (int i = 0, size = categoryList.size(); i < 4 && i < size; i++) {
                newCatList.add(categoryList.get(i));
            }
            FrontCategory catAll = new FrontCategory();
            catAll.setId(0l);
            catAll.setName("全部");
            newCatList.add(catAll);
            result.put("categoryList", newCatList);

            //获取活动推荐单品（4个）
            Response<List<ItemGoodsDetailDto>> recResponse = itemService.findByIds(recItemIdList);
            List<GoodsGroupBuyDto> recommendList = Lists.newArrayList();//推荐商品结果
            if (!recResponse.isSuccess()) {
                response.setSuccess(false);
                response.setError("MallPromotionServiceImpl.findGroupBuyData.error");
                return response;
            }

            List<ItemGoodsDetailDto> itemDetailList = recResponse.getResult();
            for (ItemGoodsDetailDto itemDetailDto : itemDetailList) {
                String itemCode = itemDetailDto.getCode();
                String goodsCode = itemDetailDto.getGoodsCode();
                GoodsGroupBuyDto recItem = new GoodsGroupBuyDto();
                recItem.setItemCode(itemDetailDto.getCode());
                recItem.setGoodsCode(goodsCode);//商品编码
                recItem.setGoodsImg(itemDetailDto.getImage1());//图片
                BigDecimal price = itemDetailDto.getPrice();
                recItem.setGroupPrice(price.setScale(2, BigDecimal.ROUND_HALF_UP).toString());//TODO:推荐单品活动价格,暂时用单品价格代替

                String number = itemDetailDto.getInstallmentNumber() == null ? "1" : itemDetailDto.getInstallmentNumber();//如果分期数为空，默认为1
                recItem.setInstallmentNumber(number);//分期数
                recItem.setGoodsName(itemDetailDto.getGoodsName());//显示商品名称 = 商品名称+单品属性
                recommendList.add(recItem);
            }
            Map<String, Object> countParamMap = Maps.newHashMap();
            countParamMap.put("itemIdList", recItemIdList);//设置单品id参数
            countParamMap.put("actType", Contants.ORDER_ACT_TYPE_TEAM);//设置活动类型 1-团购 2-秒杀
            //TODO：查询已付款件数
            for (GoodsGroupBuyDto recItem : recommendList) {
                recItem.setBuyCount(5234l);//TODO：先写死
            }

            result.put("recommendList", recommendList);//推荐商品结果

            //查询最近一场已经结束的活动
            PromotionModel lastPromotion = promotionDao.findLastPromotion(paramMap);
            if (lastPromotion != null) {
                groupPromotionIds.add(lastPromotion.getId());//添加到查询列表中
            }

            //查询第一个类目的活动商品
            Response<List<GoodsGroupBuyDto>> goodsResponse = findGroupBuyGoodsByCategory(groupPromotionIds, categoryList.get(0).getId());
            List<GoodsGroupBuyDto> promotionGoodsList = Lists.newArrayList();
            if (goodsResponse.isSuccess()) {
                //获取类目下的活动商品
                promotionGoodsList = goodsResponse.getResult();
            }

            result.put("promotionGoodsList", promotionGoodsList);//活动商品结果

            StringBuffer idBuffer = new StringBuffer();
            for (Integer id : groupPromotionIds) {
                idBuffer.append(id);
                idBuffer.append(",");
            }

            result.put("promotionId", idBuffer.toString());//活动id列表
            response.setResult(result);
            return response;
        } catch (Exception e) {
            log.error("MallPromotionServiceImpl.findGroupBuyData.error{}", Throwables.getStackTraceAsString(e));
            response.setSuccess(false);
            response.setError("MallPromotionServiceImpl.findGroupBuyData.error");
            return response;
        }
    }

    /**
     * 根据类目id查询团购活动商品列表
     *
     * @return geshuo 20160705
     */
    @Override
    public Response<List<GoodsGroupBuyDto>> findGroupBuyGoodsByCategory(List<Integer> promotionIdList, Long categoryId) {
        //定义返回结果c
        Response<List<GoodsGroupBuyDto>> response = new Response<>();
        try {

            List<PromotionModel> promotionList = promotionDao.findPromotionByIds(promotionIdList);
            Map<Integer, PromotionModel> promotionMap = Maps.newHashMap();
            for (PromotionModel promotionItem : promotionList) {
                promotionMap.put(promotionItem.getId(), promotionItem);
            }

            Long nowTime = new Date().getTime();

            //查询活动商品详情
            List<GoodsGroupBuyDto> promotionGoodsList = Lists.newArrayList();
            //TODO:查询正在进行的团购商品,以后需要添加类目条件
            List<PromotionRangeModel> rangeList = promotionRangeDao.findRangeByPromIdList(promotionIdList);
            // 活动单品id列表
            List<String> itemCodesList = Lists.newArrayList();
            Map<String, PromotionRangeModel> rangeMap = Maps.newHashMap();
            for (PromotionRangeModel rangeItem : rangeList) {
                String itemCode = rangeItem.getSelectCode();
                itemCodesList.add(itemCode);//单品id
                rangeMap.put(itemCode, rangeItem);
            }

            //查询活动单品详细
            Response<List<ItemGoodsDetailDto>> itemDetailResponse = itemService.findByIds(itemCodesList);
            if (!itemDetailResponse.isSuccess()) {
                response.setSuccess(false);
                response.setError("itemService.findByIds.error");
                return response;
            }

            List<ItemGoodsDetailDto> itemDetailList = itemDetailResponse.getResult();
            List<GoodsGroupBuyDto> expireItemList = Lists.newArrayList();
            //获取类目下的活动商品
            for (ItemGoodsDetailDto itemDetailDto : itemDetailList) {
                String goodsCode = itemDetailDto.getGoodsCode();
                String itemCode = itemDetailDto.getCode();
                PromotionRangeModel rangeItem = rangeMap.get(itemCode);//活动商品Model

                GoodsGroupBuyDto promotionGoodsItem = new GoodsGroupBuyDto();
                promotionGoodsItem.setGoodsCode(goodsCode);//商品编码
                promotionGoodsItem.setItemCode(itemCode);//单品id
                promotionGoodsItem.setGoodsImg(itemDetailDto.getImage1());//使用单品第一张图片
                promotionGoodsItem.setGroupPrice(String.valueOf(rangeItem.getLevelPrice()));//价格

                String number = itemDetailDto.getInstallmentNumber() == null ? "1" : itemDetailDto.getInstallmentNumber();//如果分期数为空，默认为1
                promotionGoodsItem.setInstallmentNumber(number);//分期数

                //显示商品名称 = 商品名称+单品属性
                promotionGoodsItem.setGoodsName(itemDetailDto.getGoodsName());

                PromotionModel promotionModel = promotionMap.get(rangeItem.getPromotionId());
                Boolean expired = promotionModel.getEndDate().getTime() < nowTime;//活动结束时间小于当前，说明已经结束
                promotionGoodsItem.setExpired(expired);//活动结束标志
                if(expired){
                    expireItemList.add(promotionGoodsItem);
                } else {
                    promotionGoodsList.add(promotionGoodsItem);
                }
            }
            //活动已结束商品添加到最后
            for(GoodsGroupBuyDto expireItem:expireItemList){
                promotionGoodsList.add(expireItem);
            }
            response.setResult(promotionGoodsList);
            return response;
        } catch (Exception e) {
            log.error("MallPromotionServiceImpl.findGroupBuyGoods.error{}", Throwables.getStackTraceAsString(e));
            response.setSuccess(false);
            response.setError("MallPromotionServiceImpl.findGroupBuyGoods.error");
            return response;
        }
    }

    /**
     * 根据活动ID 获取活动基本信息和活动选品集合（List）
     *
     * @return
     * wangqi 20160713
     */
    @Override
    public Response<MallPromotionResultDto> findPromotionByPromId(String promId) {
        Response<MallPromotionResultDto> response = new Response<>();
        // TODO 待实现
        return response;
    }

    /**
     * 取得正在进行或即将开始的活动
     *
     * @return
     * wangqi 20160713
     */
    @Override
    public Response<MallPromotionResultDto> findPromInfoForOnline() {
        Response<MallPromotionResultDto> response = new Response<>();
        // TODO 待实现
        return response;
    }

    /**
     * 根据活动类型获取活动基本信息列表（距离现时点最近的活动包含选品列表）
     *
     * @return
     * wangqi 20160713
     */
    @Override
    public Response<List<MallPromotionResultDto>> findPromListByPromType() {
        Response<List<MallPromotionResultDto>> response = new Response<>();
        // TODO 待实现
        return response;
    }

    /**
     * 根据单品CODE 获取现时点参加的活动
     *
     * @param type 0:包含即将开始活动 1：只需要进行中活动
     * @param itemCodes 单品CODE 逗号分隔拼接
     * @return 活动信息
     * wangqi 20160713s
     */
    public Response<MallPromotionResultDto> findPromByItemCodes(String type, String itemCodes){
        Response<MallPromotionResultDto> response = new Response<>();
        // TODO 待实现
        return response;
    }

    /**
     * 根据活动ID、选品ID、用户ID 记录销售数量（同时判断是否达到限购标准）
     *
     * @return 是否更新成功
     * wangqi 20160713
     */
    public Response<Boolean> changePromSaleInfo(String promId, String itemCode, User user) {
        Response<Boolean> response = new Response<>();
        // TODO 待实现
        return response;
    }

    /**
     * 根据活动ID 获取活动参加情报
     *
     * @return 是否更新成功
     * wangqi 20160713
     */
    public Response<MallPromotionResultDto> findPromSaleInfoByPromId(String promId, String itemCode, User user) {
        Response<MallPromotionResultDto> response = new Response<>();
        // TODO 待实现
        return response;
    }
}
