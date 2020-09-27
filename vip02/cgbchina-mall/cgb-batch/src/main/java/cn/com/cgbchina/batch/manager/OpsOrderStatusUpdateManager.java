package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.OpsOrderProgressSearchDao;
import cn.com.cgbchina.batch.dao.OpsOrderStatusUpdateDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.OrderCheckModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by dhc on 2016/7/19.
 */
@Component
@Slf4j
public class OpsOrderStatusUpdateManager {
    @Resource
    private OpsOrderProgressSearchDao opsOrderProgressSearchDao;
    @Resource
    private OpsOrderStatusUpdateDao opsOrderStatusUpdateDao;
    @Resource
    private PaymentService paymentService;
    @Autowired
    private IdGenarator idGenarator;
    @Resource
    private ItemService itemService;
    @Resource
    private PromotionService promotionService;
    @Resource
    private MallPromotionService mallPromotionService;
    @Resource
    private NewMessageService newMessageService;
    @Transactional
    public void updateIsCancelOps(String orderId) {
        opsOrderProgressSearchDao.updateIsCancelOps(orderId);
    }
    @Transactional
    public void updateOPSOrderWithTxn(String orderId, String curStatusId, String curStatusNm,
                                      String modifyDate, String modifyTime,
                                      final OrderDoDetailModel orderDodetail, String orderNbr) throws BatchException{
        String selCurStatusId = opsOrderProgressSearchDao.findCurStatusIdById(orderId);
        Map<String, Object> params = Maps.newHashMap();
        params.put("orderId", orderId);
        params.put("curStatusId", curStatusId);
        params.put("curStatusNm", curStatusNm);
        params.put("modifyTime", modifyTime);
        int i = opsOrderStatusUpdateDao.updateOPSOrderStatus(params);
        if (!Strings.isNullOrEmpty(orderNbr)) { //如果银行订单号不为空,更新银行订单号
            Map<String, Object> paramEx = Maps.newHashMap();
            paramEx.put("orderId", orderId);
            paramEx.put("orderNbr", orderNbr);
            opsOrderStatusUpdateDao.updateTblOrderExtend1(paramEx);
        }
        if (i > 0) { //如果成功更新了订单状态
            OrderCheckModel orderCheck = null;
            final OrderSubModel order = opsOrderStatusUpdateDao.findOrderById(orderId);
            String ischeck = "";
            String ispoint = "";
            ExecutorService executorService = Executors.newFixedThreadPool(2);
            if ("0307".equals(curStatusId) && !"0307".equals(selCurStatusId)) { // BPS返回支付失败
                if ("0316".equals(selCurStatusId) || "0305".equals(selCurStatusId)) {// 原来是处理中或者状态未明，送优惠劵+积分负交易
                    if (StringUtils.isTrimEmpty(order.getVoucherNo())) { // 优惠券代码
                        ischeck = "0"; // 送优惠劵负交易
                    }
                    if (order.getBonusTotalvalue() != null && order.getBonusTotalvalue().longValue() != 0L) {  // 积分总数
                        ispoint = "0"; // 送积分负交易
                    }
                    if (!"".equals(ischeck) || !"".equals(ispoint)) {
                        orderCheck = getObject(orderId, "0307", "支付失败", ischeck, ispoint);// 送优惠劵+积分负交易
                        /** bps返回失败，插负交易，并发起退积分 */
                        String jfRefundSerialno = "";
                        if (!"".equals(ispoint)) {
                            // 获取积分退款流水
                            jfRefundSerialno = idGenarator.jfRefundSerialNo();
                            orderCheck.setJfRefundSerialno(jfRefundSerialno);
                            // 调用积分撤销接口
                            final String dodate = orderCheck.getDoDate();
                            final String doTime = orderCheck.getDoTime();
                            final String finalJfRefundSerialno = jfRefundSerialno;
                            executorService.submit(new Runnable() {
                                @Override
                                public void run() {
                                    try {
                                        sendNSCT009(order, dodate, doTime, finalJfRefundSerialno);
                                    } catch (Exception e) {
                                        log.error("支付成功，bps失败，主动退积分:{}." + Throwables.getStackTraceAsString(e));
                                    }
                                }
                            });
                        }
                    }
                } else if ("0301".equals(selCurStatusId)) {// 原来是待付款，只送优惠劵负交易
                    if (order.getVoucherNo() != null && !"".equals(order.getVoucherNo())) {
                        orderCheck = getObject(orderId, "0307", "支付失败", "0", "");// 只送优惠劵负交易
                    }
                }
                // 回滚库存
                if (order.getGoodsId() != null) {
                    if (null == order.getActId() || "".equals(order.getActId())){
                        opsOrderStatusUpdateDao.updateGoodsStock(order.getGoodsId());
                    }else {
                        // 判断活动，荷兰拍回滚，其他活动不回滚。。。
                        if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(order.getActType())){
                            String promId = order.getActId();// 活动id
                            String periodId = String.valueOf(order.getPeriodId());
                            String itemCode = order.getGoodsId(); //单品号
                            String buyCount = "-" + String.valueOf(order.getGoodsNum()); //回滚库存，减销量，所以传负数
                            User user = new User();
                            user.setId(order.getCreateOper());
                            mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
                        }
                        // 活动回滚库存
                        Map<String, Object> proMap = Maps.newHashMap();
                        proMap.put("promId", order.getActId());
                        proMap.put("itemCode", order.getGoodsId());
                        proMap.put("itemCount", order.getGoodsNum());
                        Response<Boolean> ret = mallPromotionService.updateRollbackPromotionStock(Lists.newArrayList(proMap));
                        if (!ret.isSuccess() || !ret.getResult()) {
                            throw new RuntimeException(ret.getError());
                        }
                    }
                }

                // 业务更改：积分不回滚
//                if (order.getBonusTotalvalue() != null && order.getBonusTotalvalue().longValue() != 0L) {
//                    Map<String, Object> param = Maps.newHashMap();
//                    param.put("curMonth", DateHelper.getyyyyMM());
//                    param.put("usedPoint", order.getBonusTotalvalue());
//                    opsOrderStatusUpdateDao.dealPointPool(param);//回滚积分池
//                }
                 // 回滚活动(没有对应表) 业务要求；活动不需回滚
//                tblOrderDao.updateOrderAct(orderId);	 //回滚活动
               // 荷兰式拍卖回滚
                if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(order.getActType())){
                    opsOrderStatusUpdateDao.updateRecordOrderReleased(order.getCustCartId());
                }
            } else if ("0308".equals(curStatusId) && !"0308".equals(selCurStatusId)) { // BPS返回支付成功
                if ("0305".equals(selCurStatusId)) { // 原来是处理中，只送优惠劵正交易
                    if (StringUtils.isTrimEmpty(order.getVoucherNo())) {
                        ischeck = "0"; // 送优惠劵正交易
                    }
                } else if ("0316".equals(selCurStatusId) || "0301".equals(selCurStatusId)) { // 原来是状态未明或代付款，送优惠劵+积分正交易
                    if (order.getVoucherNo() != null && !"".equals(order.getVoucherNo())) {
                        ischeck = "0"; // 送优惠劵正交易
                    }
                }
                if (!"".equals(ischeck)) {
                    orderCheck = getObject(order.getOrderId(), "0308", "支付成功", ischeck, "");
                    orderCheck.setDoDate(DateHelper.getyyyyMMdd(order.getOrder_succ_time())); // 正交易为下单时间
                    orderCheck.setDoTime(DateHelper.getHHmmss(order.getOrder_succ_time()));
                }
                //opsOrderStatusUpdateDao.updateTblEspCustCartByOrderId(orderId,"1");//更新购物车
                if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(order.getActType())){//荷兰式订单判断
                    opsOrderStatusUpdateDao.updateRecordSucc(order.getCustCartId());
                }
                // 更新销量
                updateSaleCount(order);
            } else if ("0305".equals(curStatusId) && !"0305".equals(selCurStatusId)) { // BPS返回处理中
                log.debug("BPS返回处理中");
            }
            // 修改如果原来是处理中的Dodetail记录则不再重复插入
            if ("0305".equals(curStatusId) && "0305".equals(selCurStatusId)) {
                //如果原来是处理中的Dodetail记录则不再重复插入
                log.debug("处理中的Dodetail记录则不再重复插入");
            } else {
                opsOrderStatusUpdateDao.insertOrderDoDetail(orderDodetail);
                executorService.submit(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            // 插入履历后再插入消息
                            MessageDto messageDto = new MessageDto();
                            messageDto.setOrderId(order.getOrderId());
                            messageDto.setOrderStatus(orderDodetail.getStatusId());
                            messageDto.setCustId(order.getCreateOper());
                            messageDto.setGoodName(order.getGoodsNm());
                            messageDto.setVendorId(order.getVendorId());
                            messageDto.setUserType("0");
                            messageDto.setCreateOper("SYSTEM");
                            Response messgeRsp = newMessageService.insertUserMessage(messageDto);
                            if (!messgeRsp.isSuccess()) {
                                log.info("插入消息 error:{}", messgeRsp.getError());
                            }
                        } catch (Exception e) {
                            log.error("插入消息 error:{}." + Throwables.getStackTraceAsString(e));
                        }
                    }
                });
            }
            executorService.shutdown();
            log.info("orderCheck:" + orderCheck);
            if (orderCheck != null) {
                opsOrderStatusUpdateDao.saveTblOrderCheck(orderCheck);
            }
        }
    }

    /**
     * 获取优惠券对账文件表对象
     *
     * @param order_id
     * @param cur_status_id
     * @param cur_status_nm
     * @param ischeck       1代表优惠券需要出对账文件，2代表积分需要出对账文件
     * @param ispoint
     * @return
     */
    public OrderCheckModel getObject(String order_id, String cur_status_id,
                                     String cur_status_nm, String ischeck, String ispoint) {
        OrderCheckModel orderCheck = new OrderCheckModel();
        orderCheck.setOrderId(order_id);
        orderCheck.setCurStatusId(cur_status_id);
        orderCheck.setCurStatusNm(cur_status_nm);
        orderCheck.setDoDate(DateHelper.getyyyyMMdd());
        orderCheck.setDoTime(DateHelper.getHHmmss());
        orderCheck.setIscheck(ischeck);
        orderCheck.setIspoint(ispoint);
        orderCheck.setDelFlag(0);
        orderCheck.setCreateOper("ops");
        orderCheck.setModifyOper("ops");
        return orderCheck;
    }

    /**
     * 发起撤销积分申请
     *
     * @param order 修改:增加参数createDate创建日期、createTime创建时间 jfRefundSerialno积分撤销流水
     * @param createDate
     * @param createTime
     * @param jfRefundSerialno
     */
    private void sendNSCT009(OrderSubModel order, String createDate, String createTime, String jfRefundSerialno) throws Exception {
        // bsp分期失败需要调用积分撤销接口
        log.info("积分撤销接口.....start");
        ReturnPointsInfo info = new ReturnPointsInfo();
        info.setChannelID(sourceIdChangeToChannel(order.getSourceId()));
        info.setMerId(order.getMerId());
        info.setOrderId(order.getOrderId());
        info.setConsumeType(StringUtils.isTrimEmpty(order.getVoucherNo()) ? "2" : "1");
        info.setCurrency("CNY");
        info.setTranDate(createDate);
        info.setTranTiem(createTime);
        info.setTradeSeqNo(jfRefundSerialno);
        info.setSendDate(DateHelper.getyyyyMMdd(order.getOrder_succ_time()));
        info.setSendTime(DateHelper.getHHmmss(order.getOrder_succ_time()));
        info.setSerialNo(order.getOrderIdHost());
        info.setCardNo(order.getCardno());
        info.setExpiryDate("0000");
        info.setPayMomey(BigDecimal.ZERO);
        info.setJgId(Contants.JGID_COMMON);
        paymentService.returnPoint(info);
        log.info("积分撤销接口.....end");
    }

    /**
     * 上送积分系统渠道标志转换
     *
     * @param sourceId
     * @return
     */
    private String sourceIdChangeToChannel(String sourceId) {
        switch (sourceId) {
            case Contants.SOURCE_ID_MALL :
                return Contants.SOURCE_ID_MALL_TYPY;
            case Contants.SOURCE_ID_CC :
                return Contants.SOURCE_ID_CC_TYPY;
            case Contants.SOURCE_ID_IVR :
                return Contants.SOURCE_ID_IVR_TYPY;
            case Contants.SOURCE_ID_CELL :
                return Contants.SOURCE_ID_CELL_TYPY;
            case Contants.SOURCE_ID_MESSAGE :
                return Contants.SOURCE_ID_MESSAGE_TYPY;
            case Contants.SOURCE_ID_WX_BANK :
            case Contants.SOURCE_ID_WX_CARD :
                return Contants.SOURCE_ID_WX_TYPY;
            case Contants.SOURCE_ID_APP :
                return Contants.SOURCE_ID_APP_TYPY;
            default:
                return Contants.SOURCE_ID_MALL_TYPY;
        }
    }

    /**
     * 更新销量
     *
     * @param orderSubModel
     */
    private void updateSaleCount(OrderSubModel orderSubModel) {
        //支付成功更新销量
        if ("".equals(orderSubModel.getActId()) || null == orderSubModel.getActId()) {
            ItemModel itemModel = new ItemModel();
            itemModel.setCode(orderSubModel.getGoodsId());
            itemModel.setGoodsTotal(Long.valueOf(orderSubModel.getGoodsNum()));
            itemService.updateItemTotal(itemModel);
        } else {
            //内管
            Integer promIdN = Integer.valueOf(orderSubModel.getActId());// 活动id
            String selectCodeN = orderSubModel.getGoodsId(); //单品号
            Integer saleCountN = orderSubModel.getGoodsNum(); //销量
            promotionService.updateSaleCount(promIdN, selectCodeN, saleCountN);
            //商城
            String promId = orderSubModel.getActId();// 活动id
            String periodId = String.valueOf(orderSubModel.getPeriodId());
            String itemCode = orderSubModel.getGoodsId(); //单品号
            String buyCount = String.valueOf(orderSubModel.getGoodsNum()); //销量
            User user = new User();
            user.setId(orderSubModel.getCreateOper());
            mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
        }
        //更新radis
        //itemIndexService.deltaItemIndex(orderSubModel.getGoodsId());
    }
}
