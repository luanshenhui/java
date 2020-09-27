package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.PromDao;
import cn.com.cgbchina.batch.dao.PromotionRedisBatchDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.PromBatchManager;
import cn.com.cgbchina.batch.model.MallPromotionSaleInfoBatchDto;
import cn.com.cgbchina.batch.model.PromotionRangeBatchModel;
import cn.com.cgbchina.batch.model.PromotionRedisBatchModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.MoreObjects;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.Duration;
import org.joda.time.Interval;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;

/**
 * @author wenjia.hao
 * @version 1.0
 */
@Slf4j
@Service
public class PromotionSyncServiceImpl implements PromotionSyncService {
    private DateTimeFormatter dft = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");

    @Resource
    private PromDao promDao;
    @Autowired
    private PromBatchManager promBatchManager;
    @Autowired
    private PromotionRedisBatchDao promotionRedisBatchDao;
    private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
    private final DateTimeFormatter dateFormat = DateTimeFormat.forPattern("yyyyMMdd");
    @Override
//    @Transactional
    public Response<Boolean> syncDBtoRedis(String... args) {
        Response<Boolean> response = new Response<>();
        try {
            if(args!=null && args.length>0){
                //传入的参数为昨天的日期 处理的是今天的数据
                promBatchManager.syncDBtoRedis(args[0]);//昨天的批处理
                DateTime parse = DateTime.parse(args[0], DateTimeFormat.forPattern(DateHelper.YYYYMMDD));
                //在跑一次今天的  处理明天的数据  防止明天的数据没有刷新
                promBatchManager.syncDBtoRedis(parse.plusDays(1).toString(DateHelper.YYYYMMDD));
            }else {
                promBatchManager.syncDBtoRedis(null);
            }
            //成功执行
            response.setResult(Boolean.TRUE);
        } catch (BatchException e) {
            log.error("同步活动数据批处理异常{}", Throwables.getStackTraceAsString(e));
            response.setError("同步活动数据批处理异常" + Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    @Override
//    @Transactional
    public Response<Boolean> syncDBtoRedis() {
        return syncDBtoRedis(null);
    }

    /**
     * 批处理，荷兰拍数据实时运算
     *
     * @return true:有效 false:无效 wangqi 20160713
     */
    @Override
    public Response<Boolean> batchProm() {
        Response<Boolean> response = new Response<>();
        try {
            // 判断活动是否开始
            // 取得今日所有活动ID
            // 当前日期
            String todayDate = LocalDateTime.fromDateFields(LocalDate.now().toDate()).toString(dateFormat);
            List<String> promIdList = promotionRedisBatchDao.findPromIdListByDate(todayDate);
            for (String str : promIdList) {
                List<String> strList = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(str);
                if(strList.size() > 3) {
                    String promId = strList.get(0);
                    String promType = strList.get(1);
                    String startDate = strList.get(2);
                    String endDate = strList.get(3);

                    String periodId = strList.get(4);
                    // 荷兰拍
                    if(StringUtils.isNotEmpty(promType)
                            && promType.equals(String.valueOf(Contants.PROMOTION_PROM_TYPE_5))) {
                        // 取得活动基本
                        PromotionRedisBatchModel model = promotionRedisBatchDao.findPromById(promId);
                        String isOnline = this.isOnlinePromotion(startDate, endDate);
                        // 进行中
                        if("0".equals(isOnline)) {
                            //为了判断是否已经插入过
                            Map<String, String> hashMap = promotionRedisBatchDao
                                    .findAuctionsFieldsByKey(1, promId, periodId);
                            // 活动所属单品信息 一共多少个单品信息
                            List<PromotionRangeBatchModel> list = promDao.findByPromId(model.getId());
                            if(hashMap != null && hashMap.size() > 0) {
                                // 刷新redis栏位
                                refurbishRedisPromRange(promId, periodId, model.getRuleFrequency());
                            } else {
                                this.insertRedisPromRange(promId, periodId, list);
                            }
                            break;
                        }
                    }
                }
            }
            response.setResult(Boolean.TRUE);
        } catch (Exception e) {
            response.setError("荷兰拍同步批处理失败");
            log.error("荷兰拍同步批处理失败{}", Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    /**
     * 荷兰拍选品初始写入redis
     */
    private void insertRedisPromRange(String promId, String periodId, List<PromotionRangeBatchModel> list) {
        if(list != null) {
            // 存入栏位
            List<String> itemList = new ArrayList<>();
            for (int i = 0; i < list.size(); i++) {
                if(i <= 5) {
                    // 写入Redis 1-6个栏位数据
                    String rangeId = list.get(i).getId().toString();
                    this.insertAuctions(i + 1, rangeId, promId, periodId);
                } else {
                    itemList.add(list.get(i).getId().toString());
                }
            }
            promotionRedisBatchDao.insertAuctionsRangeList(promId, periodId, itemList);
        }

    }

    /**
     * 插入前六个栏位
     */
    private void insertAuctions(int no, String rangeId, String promId, String periodId) {
        Map<String, String> paramMap = new HashMap<>();
        // 第一栏位
        paramMap.put("rangeId", rangeId);
        if(no > 0 && no < 4) {
            // 当前时间
            paramMap.put("startTime",
                    LocalDateTime.now().toString(dateTimeFormat));
        }
        promotionRedisBatchDao.insertAuctionsFields(no, promId, periodId, paramMap);
    }

    /**
     * 荷兰拍刷新
     *
     */
    private void refurbishRedisPromRange(String promId, String periodId, Integer ruleFrequency) {
        // 判断已拍完数据是否存在
        List<String> rangeIdList = new ArrayList<>();
        // 取得栏位1-6数据
        List<Map<String, String>> mapList = promotionRedisBatchDao.findAuctionsFieldsByKeyForSix(promId, periodId, 6);
        //等待的集合
        List<String> waitList = promotionRedisBatchDao.findAuctionsRangeListByKey(promId, periodId);
        //取出所有有效rangeId
        for (Map<String, String> map : mapList) {
            String rangeId = map.get("rangeId");
            if (StringUtils.isNotEmpty(rangeId)) {
                rangeIdList.add(rangeId);
            }
        }
        rangeIdList.addAll(waitList);
        List<PromotionRangeBatchModel> overlist = null;
        //加上等待列表 就是所有有效的活动单品
        if (rangeIdList.size() > 0) {
            // 已售完 findSaleOverByRangIds
            Map<String, Object> paramMap = Maps.newHashMap();
            paramMap.put("promotionId",promId);
            paramMap.put("rangeList",rangeIdList);
            //得到剩下的不在redis中的rangid判断销售情况 如果商品被回滚了  需要拉回来
            overlist = promDao.findSaleOverByRangIds(paramMap);
        } else {
            //都被拍走了  需要检查所有的活动范围
            overlist =promDao.findByPromId(Integer.valueOf(promId));
        }
        // 栏位一
        this.refurbishAuctions(1, promId, periodId, ruleFrequency, overlist);
        // 栏位二
        this.refurbishAuctions(2, promId, periodId, ruleFrequency, overlist);
        // 栏位三
        this.refurbishAuctions(3, promId, periodId, ruleFrequency, overlist);
    }

    /**
     * 判断第一轮3个拍卖位数据
     *
     */
    private void refurbishAuctions(Integer beforeNo, String promId, String periodId, Integer ruleFrequency, List<PromotionRangeBatchModel> overlist) {

        Integer endNo = beforeNo + 3;
        Map<String, String> beforeHashMap = promotionRedisBatchDao
                .findAuctionsFieldsByKey(beforeNo, promId, periodId);
        if (beforeHashMap == null ) {
            return;
        }
        //处于等待列表的单品  waitList
        List<String> itemCodeList = promotionRedisBatchDao
                .findAuctionsRangeListByKey(promId, periodId);
		/* ××栏位 */
        // 开始时间
        String startTime = beforeHashMap.get("startTime");
        // 活动ID
        String rangeId = beforeHashMap.get("rangeId");
        if (rangeId == null || "".equals(rangeId)) {
            if (overlist.size() > 0) {
                for (int i = 0;i < overlist.size(); i++) {
                    PromotionRangeBatchModel model = overlist.get(i);
                    MallPromotionSaleInfoBatchDto sale = promotionRedisBatchDao.findPromBuyCountForbatch(promId, periodId, model.getSelectCode());
                    if (sale.getStockAmountTody() != null && sale.getSaleAmountToday() != null
                            && sale.getStockAmountTody() > sale.getSaleAmountToday()) {
                        rangeId = String.valueOf(overlist.get(i).getId());
                        beforeHashMap.put("rangeId", rangeId);
                        overlist.remove(i);
                        break;
                    }
                }
            }
            if (rangeId == null || "".equals(rangeId)) {
                return;
            }
        }
        //查看活动单品
        PromotionRangeBatchModel rangeModel = promDao.findPromRangeById(Integer.valueOf(rangeId));
        if(rangeModel != null) {
            Integer stock ;
            // 库存  redis中的库存  不取db中的库存  db中的库存会在下订单后扣减 但是redis中的增计数器 不减库存的那个数

            String redisStock = promotionRedisBatchDao.getRedisStock(promId, periodId, rangeModel.getSelectCode());
            //非空  直接取
            if( StringUtils.isNotEmpty(redisStock)){
              stock= Integer.valueOf(redisStock);
            }else {
                //空的 取db  小概率事件  商品
                stock=rangeModel.getPerStock();
                //放入redis中
                promotionRedisBatchDao.setRedisStock(promId,periodId,rangeModel.getSelectCode(),String.valueOf(stock));
            }
            // 销量
            String buyCount = promotionRedisBatchDao.findPromBuyCount(promId, periodId, rangeModel.getSelectCode());
            //栏位数据 包含starttime和rangeId
            Map<String, String> afterHashMap = promotionRedisBatchDao
                    .findAuctionsFieldsByKey(endNo, promId, periodId);
           //TODO  如果底下的数据没有了 说明已经被拍完了 要查找有没有被库存回滚的数据 有的话 填到这个位置再往下走
           if(afterHashMap==null ||afterHashMap.size()==0){
               if(afterHashMap==null){
                   afterHashMap=Maps.newHashMap();
               }
               //没了
               if(overlist.size()>0){
                   //被拍走的  判断是否有库存回滚的
                   ListIterator<PromotionRangeBatchModel> promotionRangeBatchModelListIterator = overlist.listIterator();
                   while (promotionRangeBatchModelListIterator.hasNext()){
                       PromotionRangeBatchModel next = promotionRangeBatchModelListIterator.next();
                       MallPromotionSaleInfoBatchDto overItemSale = promotionRedisBatchDao.findPromBuyCountForbatch(promId, periodId, next.getSelectCode());
                       //库存大于销量说明有     有就放进去
                       if (overItemSale.getStockAmountTody() != null && overItemSale.getSaleAmountToday() != null
                               && overItemSale.getStockAmountTody() > overItemSale.getSaleAmountToday()) {
                           afterHashMap.put("rangeId",String.valueOf(next.getId()));
                           promotionRangeBatchModelListIterator.remove();

                       }
                   }
           }
           }


            //TODO END
            // 已卖完  销量大于库存
            if(StringUtils.isNotEmpty(buyCount) && Integer.valueOf(MoreObjects.firstNonNull(buyCount,"0"))>=stock) {
                // 单品数不大于6个
                if (itemCodeList == null || itemCodeList.size() == 0) {
                    // 重新编辑栏位
                    beforeHashMap.remove("rangeId");
                    beforeHashMap.remove("startTime");
                    // 重新编辑栏位

                    this.idetAuctionsForLack(beforeNo, endNo, beforeHashMap,afterHashMap, itemCodeList, promId, periodId);
                } else { // 单品数大于6个
                    // 重新编辑栏位
                    this.idetAuctions(beforeNo, endNo, afterHashMap, itemCodeList, promId, periodId);
                }
            } else {
                // 是否流拍
                if(calculateSecond(startTime, rangeModel.getStartPrice(), rangeModel.getMinPrice(), rangeModel.getFeeRange(), ruleFrequency)) {
                    //已经流拍的话  上下的位置对调
                    // 单品数不大于6个
                    if (itemCodeList == null || itemCodeList.size() == 0) {

                        this.idetAuctionsForLack(beforeNo, endNo, beforeHashMap,afterHashMap, itemCodeList, promId, periodId);
                    } else { // 单品数大于6个
                        itemCodeList.add(rangeId);

                        // 重新编辑栏位
                        this.idetAuctions(beforeNo, endNo, afterHashMap, itemCodeList, promId, periodId);
                    }
                }else {
                    //未流拍的话 说明这个商品还在这个位置不动  但是aftermap 可能有别的商品加进来了  需要处理 如果别的商品因为库存回滚在前面加进来了 要把这个栏位补齐
                if(afterHashMap.size()>0){
                    //有可能是原来就有的  也有可能是因为库存添进来的 重复添加无所谓
                     promotionRedisBatchDao.insertAuctionsFields(endNo,promId,periodId,afterHashMap);

                }
                }
            }
        }
    }

    /**
     * 栏位次第补位
     *
     *  true 流拍 false 未流拍
     */
    private void idetAuctions(Integer beforeNo, Integer endNo, Map<String, String> afterMap, List<String> itemCodeList, String promId, String periodId) {
        // 第二轮栏位 ——> 第一轮栏位
        afterMap.put("startTime",
                LocalDateTime.now().toString(dateTimeFormat));

        promotionRedisBatchDao.insertAuctionsFields(beforeNo, promId, periodId, afterMap);

        // 等候区 ——> 第二轮栏位
        Map<String, String> paramMap = new HashMap<>();
        if(itemCodeList != null && itemCodeList.size() > 0) {
            paramMap.put("rangeId", itemCodeList.get(0));
            itemCodeList.remove(0);
        }
        promotionRedisBatchDao.insertAuctionsFields(endNo, promId, periodId, paramMap);
        promotionRedisBatchDao.insertAuctionsRangeList(promId, periodId, itemCodeList);
    }

    /**
     * 栏位次第补位(单品数不大于6个)
     *
     *  true 流拍 false 未流拍
     */
    private void idetAuctionsForLack(Integer beforeNo, Integer endNo, Map<String, String> beforeMap, Map<String, String> afterMap, List<String> itemCodeList, String promId, String periodId) {
        // 第二轮栏位 ——> 第一轮栏位
        Boolean flg = true;
        if (afterMap == null) {
            flg = false;
        } else {
            afterMap.put("startTime",
                    LocalDateTime.fromDateFields(new Date()).toString(dateTimeFormat));
            String rangeId = afterMap.get("rangeId");
            if (StringUtils.isEmpty(rangeId)) {
                flg = false;
            }
        }
        if (flg) {
            //底下有人等  上下对调
            promotionRedisBatchDao.insertAuctionsFields(beforeNo, promId, periodId, afterMap);
            // 去掉起始时间
            beforeMap.remove("startTime");
            promotionRedisBatchDao.insertAuctionsFields(endNo, promId, periodId, beforeMap);
        } else {
            //地下没人等  保持原位不动
            beforeMap.put("startTime",
                    LocalDateTime.fromDateFields(new Date()).toString(dateTimeFormat));
            promotionRedisBatchDao.insertAuctionsFields(beforeNo, promId, periodId, beforeMap);
        }
    }

    /**
     * 计算是否已经流拍
     *
     * @return true 流拍 false 未流拍
     */
    private Boolean calculateSecond(String startTime, BigDecimal startPrice, BigDecimal minPrice, BigDecimal feeRange, Integer ruleFrequency) {

        if(startPrice == null || minPrice == null || feeRange == null || ruleFrequency == null) {
            return true;
        }
        // 降价频率大于差额
        if(feeRange.compareTo(startPrice.subtract(minPrice)) > 0) {
            return true;
        } else {
            // 计算时间差
            DateTime dateTime1 = dateTimeFormat.parseDateTime(startTime);
            DateTime dateTime2 = dateTimeFormat.parseDateTime(LocalDateTime.fromDateFields(new Date()).toString(dateTimeFormat));
            Duration duration = new Duration(dateTime1, dateTime2);

            Integer second = duration.toStandardSeconds().getSeconds();
            // 每0.5秒减价数
            BigDecimal money = feeRange.divide(new BigDecimal(ruleFrequency).multiply(
                    new BigDecimal(2)), 2, BigDecimal.ROUND_UP);

            // 降至最低价所需的降价次数
            BigDecimal count = startPrice.subtract(minPrice).divide(money, 0, RoundingMode.HALF_UP);

            // 已跳完价格
            return count.intValue() <= second * 2;
        }
    }

    /**
     * 检验是否 活动状态
     *
     * @return 0：进行中 1：待开始 2：已结束 ""：失败
     */
    private String isOnlinePromotion(String startDate, String endDate) {
        try {
            DateTime now = DateTime.now();
            Date bDate = dft.parseLocalDateTime(startDate).toDate();
            Date eDate = dft.parseLocalDateTime(endDate).toDate();
            Interval interval = new Interval(bDate.getTime(), eDate.getTime());
            if (interval.contains(now)) {
                return "0";
            } else if (eDate.before(now.toDate())) {

                return "2";
            } else if (bDate.after(now.toDate())) {
                return "1";
            } else {
                return "";
            }
        } catch (Exception e) {
            log.error("MallPromotionServiceImpl.isOnlinePromotion.error{}", Throwables.getStackTraceAsString(e));
            return "";
        }
    }

    /**
     * 荷兰拍释放批处理
     * <p>
     * geshuo 20160726
     */
    @Override
//    @Transactional
    public Response<Boolean> batchDutchAuctionRelease() {
        Response<Boolean> response = new Response<>();
        try {
            //业务处理放到manager中做
            promBatchManager.releaseAuction();
            response.setResult(Boolean.TRUE);
        } catch (BatchException e) {
            log.error("PromotionSyncServiceImpl.batchDutchAuctionRelease.error Exception:{}", Throwables.getStackTraceAsString(e));
            response.setError(e.getMessage());
        }
        return response;
    }

//    @Transactional
    @Override
    public Response<Boolean> batchAuctionStockRelease(String[] args){
        Response<Boolean> response=Response.newResponse();
        try{
            log.info("荷兰拍订单过期释放参数{}",Arrays.deepToString(args));
            promBatchManager.releaseOrderForMq(args[0]);
            response.setResult(Boolean.TRUE);
        }catch (BatchException e){
            log.info("PromotionSyncServiceImpl.batchDutchAuctionRelease.error Exception:{}", Throwables.getStackTraceAsString(e));
            response.setResult(Boolean.TRUE);
        }catch (Exception e){
            log.error("PromotionSyncServiceImpl.batchDutchAuctionRelease.error Exception:{}", Throwables.getStackTraceAsString(e));
            response.setResult(Boolean.TRUE);
        }
        return response;

    }


}
