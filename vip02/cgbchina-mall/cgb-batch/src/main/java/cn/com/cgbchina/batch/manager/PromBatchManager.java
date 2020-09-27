package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.PromDao;
import cn.com.cgbchina.batch.dao.PromotionRedisBatchDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.AuctionRecordBatchModel;
import cn.com.cgbchina.batch.model.BatchOrderModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.batch.model.PromEntry;
import cn.com.cgbchina.batch.model.PromItemEntry;
import cn.com.cgbchina.batch.model.PromotionBatchModel;
import cn.com.cgbchina.batch.model.PromotionPeriodBatchModel;
import cn.com.cgbchina.batch.model.PromotionRedisBatchModel;
import cn.com.cgbchina.batch.service.BatchOrderServiceImpl;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.rest.visit.model.payment.OrderBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResultInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.joda.time.LocalDateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/28.
 */
@Slf4j
@Component
public class PromBatchManager {

    @Autowired
    PaymentService paymentService;
    @Autowired
    private BatchOrderServiceImpl batchOrderServiceImpl;
    @Autowired
    private OpsOrderProgressSearchManager opsOrderProgressSearchManager;
    @Autowired
    private OrderStatusQueryManager orderStatusQueryManager;
    @Resource
    private PromDao promDao;
    @Resource
    private PromotionRedisBatchDao promotionRedisBatchDao;
    private final DateTimeFormatter dateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
    private final DateTimeFormatter dateFormat = DateTimeFormat.forPattern("yyyyMMdd");
    @Autowired
    private PromBatchSubManager promBatchSubManager;

    @Value("#{app.dutchReleaseSkewTime}")
    private Integer dutchReleaseSkewTime;//释放库存偏移时间

    @Value("#{app.dutchFetchSize}")
    private Integer dutchFetchSize;//每次处理行数

    @Value("#{app.dutchOrderReleaseSkewTime}")
    private Integer dutchOrderReleaseSkewTime;//荷兰拍已生成订单后释放库存偏移时间

    @Value("#{app.dutchOrderReleaseAfterPaySkewTime}")
    private Integer dutchOrderReleaseAfterPaySkewTime;//荷兰拍已生成订单后当跳转支付后释放库存偏移时间
    @Autowired
    private JedisTemplate jedisTemplate;
    private static DateTime getNow(String date) {
        if(StringUtils.isTrimEmpty(date)) {
            return DateTime.parse(date, DateTimeFormat.forPattern(DateHelper.YYYYMMDD));
        } else {
            //默认返回今天零点
            return DateTime.now().withTime(0, 0, 0, 0);
        }
    }

//    @Transactional
    public void syncDBtoRedis(String date) {
        try {
            log.info("同步参数{}",date);
            log.info("删除旧活动数据批处理");
            //首先对过期的数据进行清理 然后再插入 业务变更 删除前天的
            String yesterday = getNow(date).minusDays(2).toString(dateFormat);
            //昨天的活动聚合以及昨天过期的单品聚合
            promotionRedisBatchDao.delPromTogether(yesterday);
            //通过db扫描出截止日期是昨天的活动  把redis中的活动基本信息的键删掉
            Map<String, Object> yesterdayExpireQuery = Maps.newHashMap();
            //昨天凌晨
            yesterdayExpireQuery.put("yesterdayStart", LocalDateTime.fromDateFields(getNow(date).minusDays(2).toDate()).toDate());
            //昨天最后一秒
            yesterdayExpireQuery.put("yesterdayEnd", LocalDateTime.fromDateFields(getNow(date).toDate()).minusDays(1).minusSeconds(1).toDate());
            //截止到昨天过期的活动ids，扫描垃圾数据进行清理
            List<String> yesterExpireIds = promDao.getYesterExpire(yesterdayExpireQuery);
            if(yesterExpireIds.size() != 0) {
                //删除活动本身的数据 redis中
                promotionRedisBatchDao.deletePromByIds(yesterExpireIds);
                //删除销量  用户限购等键
                promotionRedisBatchDao.delUserLimitAndSale(yesterExpireIds);
                //清除对应销量库存等过期键
                //查找过期活动的periodId
                List<PromotionPeriodBatchModel> periodModels = promDao.findPeriodsByPromIds(yesterExpireIds);
                //删除库存以及荷兰拍相关
                 promotionRedisBatchDao.delStockAndHolland(periodModels);
                //并把这几个活动的状态置成 已失效[结束时间小于当前时间] 12
                Map<String, Object> updateStatus = Maps.newHashMap();
                updateStatus.put("status", "12");
                updateStatus.put("promIds", yesterExpireIds);
                promBatchSubManager.updatePromStatus(updateStatus);
            }
            //删除昨天的所有单品数据  redis中
            promotionRedisBatchDao.delItem(yesterday);//传入昨天的日期即可


            log.info("--------------------------活动正式数据同步开始--------------------------");
            // 构建明天日期的查询map  业务变更  明天的集合要包含未来所有活动  此处默认未来三个月
            Map<String, Object> tomorrowMap = Maps.newHashMap();
            tomorrowMap.put("startTime",
                    LocalDateTime.fromDateFields(getNow(date).plusDays(1).toDate()).toString(dateTimeFormat));// 明天
            tomorrowMap.put("endTime", LocalDateTime.fromDateFields(getNow(date).plusDays(102).toDate()).minusSeconds(1)
                    .toString(dateTimeFormat));// 明天最后一刻
            //查询出明天参加的活动 一个时间段一条 明天的活动集合
            List<PromEntry> tomorrow = promDao.promOfDay(tomorrowMap);

            // 构建后天日期的查询map
            Map<String, Object> afterTomorrowMap = Maps.newHashMap();
            afterTomorrowMap.put("startTime",
                    LocalDateTime.fromDateFields(getNow(date).plusDays(2).toDate()).toString(dateTimeFormat));// 后天
            afterTomorrowMap.put("endTime", LocalDateTime.fromDateFields(getNow(date).plusDays(103).toDate())
                    .minusSeconds(1).toString(dateTimeFormat));// 后天最后一刻
            //后天的活动集合
            List<PromEntry> afterTomorrow = promDao.promOfDay(afterTomorrowMap);

            // 构建大后天日期的查询map
            Map<String, Object> afterAfterTommorrowMap = Maps.newHashMap();
            afterAfterTommorrowMap.put("startTime",
                    LocalDateTime.fromDateFields(getNow(date).plusDays(3).toDate()).toString(dateTimeFormat));
            afterAfterTommorrowMap.put("endTime", LocalDateTime.fromDateFields(getNow(date).plusDays(104).toDate())
                    .minusSeconds(1).toString(dateTimeFormat));
            //大后天的所有活动集合
            List<PromEntry> afterAfterTommorrow = promDao.promOfDay(afterAfterTommorrowMap);


            //得到未来150天内所有的活动基本信息
            Map<String, Object> future15Days = Maps.newHashMap();
            future15Days.put("startTime", LocalDateTime.fromDateFields(getNow(date).plusDays(1).toDate()).toDate());//明天凌晨开始
            future15Days.put("endTime", LocalDateTime.fromDateFields(getNow(date).plusDays(150).toDate()).minusSeconds(1).toDate());//14天后最后一秒结束

            List<PromotionBatchModel> allPromotion = promDao.getPromotionForBatch(future15Days);
            log.info("----------------------------活动数据已经从数据库中抓取完毕------------------------");
            log.info("-----------------------处理db中的数据到redis中-----------------------");
            List<PromotionRedisBatchModel> redisModels = Lists.newArrayList();
            List<String> promAllIds = Lists.newArrayList();

            PromotionRedisBatchModel promotionRedisModel = null;
            for (PromotionBatchModel promotion : allPromotion) {
                promotionRedisModel = new PromotionRedisBatchModel();
                BeanMapper.copy(promotion, promotionRedisModel);
                /// 此处留着处理db数据与redis数据的差异
                redisModels.add(promotionRedisModel);
                // 维护一个总id的集合 好知道当前数据库中到底有多少活动的基本数据
                promAllIds.add(String.valueOf(promotion.getId()));
            }
            log.info("---------------------------往redis中写入活动基础数据----------------------------");
            promotionRedisBatchDao.syncDBtoRedis(redisModels);//基础数据

            // 写入三个每天维护的活动id总集合
            promotionRedisBatchDao.insertIdsByDate(tomorrow,
                    getNow(date).plusDays(1).toString(dateFormat));
            promotionRedisBatchDao.insertIdsByDate(afterTomorrow,
                    getNow(date).plusDays(2).toString(dateFormat));
            promotionRedisBatchDao.insertIdsByDate(afterAfterTommorrow,
                    getNow(date).plusDays(3).toString(dateFormat));

            // 维护整个活动集合
            insertAllIds(promAllIds);
            //维护单品开始
            //获取所有可用的单品集合  留个空参数方便以后扩展
            List<String> todayItemIds = promDao.getItemByPromoBatch(Collections.<String,Object>emptyMap());
            //这些参加活动的单品id都有哪些活动集合
            List<PromItemEntry> promItemDtos = Lists.newArrayList();
            for (String str : todayItemIds) {
                Map<String, Object> queryMap = Maps.newHashMap();
                queryMap.put("selectCode", str);
                queryMap.put("beginDate", LocalDateTime.fromDateFields(getNow(date).plusDays(1).toDate()).toDate());//明天凌晨开始
                queryMap.put("endDate", LocalDateTime.fromDateFields(getNow(date).plusDays(15).toDate()).minusSeconds(1).toDate());//14天后23：59:59秒结束
                List<PromEntry> promItemEntries = promDao.getPromByItem(queryMap);
                //虽然当前单品是有效的  查出来了  但是根据单品查活动的时候  发现根据这个单品号查询有效的活动查不出来 那么就不用维护
                //这个单品与活动的关系了 就是空
                if(promItemEntries.size() == 0) {
                    continue;
                }
                PromItemEntry promItemEntry = new PromItemEntry();
                promItemEntry.setItemCode(str);
                promItemEntry.setPromEntries(promItemEntries);
                promItemDtos.add(promItemEntry);
            }

            //得到所有单品与活动的一对多映射关系
            //插入redis   插入redis中的数据都是明天的数据  ，今天的数据会在昨天跑批时同步到redis中  所以此处维护的键都是明天的
            if(promItemDtos.size() != 0) {
                //根据单品id如果查不到有效活动的话  那么说明今天没有单品参加活动 不用维护任何键
                promotionRedisBatchDao.insertItemList(promItemDtos, getNow(date).plusDays(1).toString(dateFormat));
            }
        } catch (Exception e) {
            log.error("同步活动db到redis批处理失败{}", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 同步db中的活动id集合到redis中，因为redis中使用了set数据结构，防重，此处直接添加就行，自动去重
     * @param list  db中的活动集合
     */
    private void insertAllIds(List<String> list) {
            promotionRedisBatchDao.insertAllPromIds(list);
    }

    /**
     * 荷兰拍释放批处理
     * <p>
     * geshuo 20160726
     */
    public void releaseAuction() throws BatchException {
        try {
            Date nowDate = getDBDateTime();
            releaseNoOrderAction(nowDate);//释放没有生成订单的记录
        } catch (Exception e) {
            log.error("PromBatchManager.releaseAuction.error Exception:{}", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }
    public void releaseOrderForMq(String orderId) throws BatchException{
        String lockId = "";
        try {
            lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "ORDERID" + orderId, 50, 5000);
            if (lockId == null) {
                log.info("此订单正在处理中，订单号：" + orderId);
                return;
            }
            doOrderReleaseAuction(orderId);
        } catch (Exception e) {
            DistributedLocks.releaseLock(jedisTemplate,  "ORDERID" + orderId, lockId);
            throw new BatchException(e);
        }

    }




    /**
     * 释放一定时间内没有生成订单的拍卖记录，回滚库存
     * <p>
     * geshuo 20160726
     */
    private void releaseNoOrderAction(Date curDateTime) {
        int skewTime = (dutchReleaseSkewTime == null) ? -300 : dutchReleaseSkewTime;//偏移时间,默认-300秒,即5分钟
        Date overTime = new Date();
        overTime.setTime(curDateTime.getTime() + skewTime * 1000);//设置为偏移后的时间

        //获取需要释放的总数
        int count = promDao.findOvertimeRecordCount(overTime);

        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("overTime", overTime);
        //每次处理一定的条数
        for (int i = 0; i < count; i += dutchFetchSize) {
            paramMap.put("offset", i);//从第1条取
            paramMap.put("limit", dutchFetchSize);//每次取size条
            List<AuctionRecordBatchModel> recordList = promDao.findOvertimeRecord(paramMap);
            for (AuctionRecordBatchModel auctionModel : recordList) {
                Long id = auctionModel.getId();//id
                String itemId = auctionModel.getItemId();//单品id
                Long auctionId = auctionModel.getAuctionId();//活动id
                String userId = auctionModel.getCustId();//购买人
                String periodId = String.valueOf(auctionModel.getPeriodId());//活动场次id
                try {
                    doReleaseAuctionWithTxn(id, itemId, auctionId, periodId, userId);
                } catch (Exception ex) {
                    log.info("回滚库存发生异常，继续下一个回滚 id:{}", id);
                    log.error("PromotionSyncServiceImpl.releaseNoOrderAction.error Exception:{}", Throwables.getStackTraceAsString(ex));
                }
            }
        }
    }

    /**
     * 针对对应活动记录回滚商品库存
     *
     * @param id        记录id
     * @param itemId    单品id
     * @param auctionId 活动id
     * @throws Exception geshuo 20160726
     */
    private void doReleaseAuctionWithTxn(Long id, String itemId, Long auctionId, String periodId, String userId) throws Exception {
        //锁定记录表操作
        Map<String, Object> updateParamMap = Maps.newHashMap();
        updateParamMap.put("id", id);
        Integer updateCount = promBatchSubManager.updateRecordReleased(updateParamMap);
        if(updateCount == 0) {
            throw new BatchException("回滚判断出现错误，回滚库存取消");
        } else {
            String promotionId = String.valueOf(auctionId);//活动id
            String today = DateHelper.getyyyyMMdd();
            //操作redis,回滚库存
            promotionRedisBatchDao.updatePromSaleInfo(promotionId, periodId, itemId, 1L, today, userId);
        }
    }

    /**
     * 释放订单记录
     *
     * @param orderId     订单id
     * @throws Exception geshuo 20160726
     */
    private void doOrderReleaseAuction(String orderId) throws Exception {
        //回查订单是否已经支付
        BatchOrderModel order = promDao.findOrderById(orderId);
        if(!"0301".equals(order.getCurStatusId()) && !"0316".equals(order.getCurStatusId())) {
            throw new BatchException("不能释放库存 order_id : " + order.getOrderId() + "，回查后订单状态为：" + order.getCurStatusId());
        }
        if(StringUtils.isTrimEmpty(order.getOrderId())) {
            String cashAuthType = order.getCashAuthType();//分期订单电子支付是否已经验证
            if(StringUtils.isEmpty(cashAuthType)) {//分期订单电子支付未验证
                List<OrderBaseInfo> orderBaseInfos = new ArrayList<>();
                PaymentRequeryInfo paymentRequeryInfo = new PaymentRequeryInfo();
                OrderBaseInfo orderBaseInfo = new OrderBaseInfo();
                orderBaseInfo.setOrderId(orderId);
                orderBaseInfo.setPayDate(order.getCreateTime());
                orderBaseInfo.setMerId(order.getMerId());//商户号
                orderBaseInfos.add(orderBaseInfo);
                paymentRequeryInfo.setOrderBaseInfos(orderBaseInfos);
                //调用电子支付接口检查订单状态
                PaymentRequeryResult nsct002Response = paymentService.paymentRequery(paymentRequeryInfo);
                if("000000".equals(nsct002Response.getRetCode())) {// 如果电子支付返回报文成功
                    List<PaymentRequeryResultInfo> responseOrders = nsct002Response.getInfos();
                    orderStatusQueryManager.dealFQOrderStatus(responseOrders);
                }
                //重新获取订单
                order = promDao.findOrderById(orderId);
                cashAuthType = order.getCashAuthType();
            }
            if("1".equals(cashAuthType)) {//分期订单电子支付平台已验证
                //调用BPS接口检查订单状态
                OrderSubModel orderSubModel = new OrderSubModel();
                orderSubModel.setOrderId(orderId);//订单id
                orderSubModel.setCreateTime(order.getCreateTime());//创建时间
                orderSubModel.setSourceId(order.getSourceId());//渠道
                opsOrderProgressSearchManager.sendOneOPS(orderSubModel);
                //重新获取订单
                order = promDao.findOrderById(orderId);
            }
            if(!"0301".equals(order.getCurStatusId()) && !"0316".equals(order.getCurStatusId())) {
                throw new BatchException("不能释放库存 order_id : " + order.getOrderId() + "，回查后订单状态为：" + order.getCurStatusId());
            }
        } else {
            throw new BatchException("不能释放库存 order_id : " + orderId + "，该订单不存在");
        }

        //回查后一切正常进行回滚
        doOrderReleaseAuctionWithTxn(orderId);
    }

    /**
     * 针对对应活动记录回滚商品库存，需先检查订单支付情况
     *
     * @param orderId     订单id
     * @throws Exception geshuo 20160726
     */
    private void doOrderReleaseAuctionWithTxn(String orderId) throws Exception {
        //锁定记录表操作
        Map<String, Object> updateParamMap = Maps.newHashMap();
        updateParamMap.put("orderId", orderId);
        Integer updateCount = promBatchSubManager.updateRecordReleasedByOrderId(updateParamMap);
        if(updateCount == 0) {
            throw new BatchException("回滚判断出现错误，回滚库存取消");
            //开始废单操作
        } else {
            BatchOrderModel order = promDao.findOrderById(orderId);
            if(order != null) {
                //调用订单批处理的废单方法
                log.info("荷兰拍废单开始，废单id为{}",order.getOrderId());
                batchOrderServiceImpl.overdueOneOrderProcWithTxn(order);
            } else {
                throw new BatchException("订单不存在！！！");
            }
        }
    }

    /**
     * 获取数据库当前时间
     *
     * @return 当前时间
     * <p>
     * geshuo 20160726
     */
    private Date getDBDateTime() {
        try {
            return promDao.findCurrentDate();
        } catch (Exception e) {
            log.error("PromotionSyncServiceImpl.getDBDateTime.error Exception:{}", Throwables.getStackTraceAsString(e));
        }
        return new Date();
    }
}
