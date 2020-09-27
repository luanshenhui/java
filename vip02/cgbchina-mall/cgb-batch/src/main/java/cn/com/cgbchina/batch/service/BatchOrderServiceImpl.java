package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.BatchOrderDao;
import cn.com.cgbchina.batch.dao.PromotionRedisBatchDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.BatchOrderManager;
import cn.com.cgbchina.batch.model.BatchOrderModel;
import cn.com.cgbchina.batch.model.ItemModel;
import cn.com.cgbchina.batch.model.OrderCheckModel;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * Created by dhc on 2016/7/15.
 */
@Service
@Slf4j
public class BatchOrderServiceImpl implements BatchOrderService{
    @Autowired
    private BatchOrderManager batchOrderManager;
    @Autowired
    private BatchOrderDao batchOrderDao;
    @Resource
    private NewMessageService newMessageService;
    @Resource
    private MallPromotionService mallPromotionService;
    @Resource
    private PromotionRedisBatchDao promotionRedisBatchDao;
    @Override
    public Response<Boolean> overdueOrderProc() {
        Response<Boolean> response = new Response<>();
        try{
            log.info("废单批处理开始......");
            overdueOrderProc1();
            log.info("废单批处理结束......");
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            log.error("废单批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    public void overdueOrderProc1() throws BatchException {
        try {
            log.info("废单批处理开始......");
            String predate = DateTime.now().minusDays(1).toString(DateHelper.YYYY_MM_DD_HH_MM_SS);
            int count = batchOrderDao.getCountOverOrder(predate);
            if (count > 0) {
                log.info("废单数量count:" + count);
            }
            for (int i = 0; i < count; i = i + 100) {
                List<BatchOrderModel> orderModelList = batchOrderDao.getOverOrders(predate, 0, 100);
                if (orderModelList == null || orderModelList.size() == 0) {
                    break;
                }
                log.info("废单list数量：" + orderModelList.size());
                for (BatchOrderModel batchOrderModel : orderModelList) {
                    try {
                        overdueOneOrderProcWithTxn(batchOrderModel);
                    }catch(Exception e) {
                        log.error("订单：{} 废单失败......error:{}", batchOrderModel.getOrderId(),Throwables.getStackTraceAsString(e));
                    }
                }
            }
            log.info("废单批处理结束......");
        } catch (Exception e) {
            log.error("废单批处理失败..... erro:{}", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 订单废单处理
     *
     * @param orderModel
     */
    public void overdueOneOrderProcWithTxn(BatchOrderModel orderModel) {
        log.info("开始处理废单:" + orderModel.getOrderId());
        Map<String, Object> paramMap = Maps.newHashMap();
        paramMap.put("order_id", orderModel.getOrderId());
        paramMap.put("cur_status_id", "0304");
        paramMap.put("cur_status_nm", "已废单");
        paramMap.put("modify_time", DateHelper.getCurrentTime());
        paramMap.put("modify_oper", "SYSTEM");
        batchOrderManager.updateOrderStatus(paramMap); //改小订单状态
        // 广发状态未明订单，根据订单号查询有没有插正交易，如果有，则查撤销记录
        if ("FQ".equals(orderModel.getOrdertypeId())
                && "0316".equals(orderModel.getCurStatusId())
                && null != orderModel.getBonusTotalvalue() && orderModel.getBonusTotalvalue().longValue() > 0L) {

            List<OrderCheckModel> tempList = batchOrderDao.orderCancelService(orderModel.getOrderId());
            if (null != tempList && tempList.size() > 0) {
                boolean successFlag = false;
                boolean errorFlag = false;
                for (OrderCheckModel tempOrderCheck : tempList) {
                    String tempStatusId = tempOrderCheck.getCurStatusId();
                    //0305 处理中 0308 成功
                    if ("0305".equals(tempStatusId) || "0308".equals(tempStatusId)) {
                        successFlag = true;
                    }
                    //0312--已撤单 0327--退货成功 0307--支付失败 0380--拒绝签收 0381--无人签收
                    if ("0312".equals(tempStatusId) || "0327".equals(tempStatusId)
                            || "0307".equals(tempStatusId) || "0380".equals(tempStatusId)
                            || "0381".equals(tempStatusId)) {
                        errorFlag = true;
                        break;
                    }
                }
                //有成功记录，没有撤销记录
                if (successFlag && !errorFlag) {
                    OrderCheckModel orderCheck = new OrderCheckModel();
                    orderCheck.setOrderId(orderModel.getOrderId());
                    orderCheck.setCurStatusId("0312");
                    orderCheck.setCurStatusNm("已撤单");
                    orderCheck.setDoDate(DateHelper.getyyyyMMdd(orderModel.getCreateTime()));
                    orderCheck.setDoTime(DateHelper.getHHmmss(orderModel.getCreateTime()));
                    orderCheck.setIspoint("0");
                    batchOrderManager.saveTblOrderCheck(orderCheck);
                }
            }
        }

        if ("JF".equals(orderModel.getOrdertypeId())) {//如果是积分商城
            // 回滚库存
            log.info("商品数量回滚。。。。。" + orderModel.getGoodsNum());
            ItemModel goodsModel = new ItemModel();
            goodsModel.setCode(orderModel.getGoodsId());
            goodsModel.setStock(orderModel.getGoodsNum().longValue());
            batchOrderManager.updateGoodsJF(goodsModel);//回滚商品数量
        }  else {
            // 普通商品回滚库存
            if ("".equals(orderModel.getActId()) || null == orderModel.getActId()){
                log.info("商品数量回滚。。。。。" + orderModel.getGoodsNum());
                ItemModel goodsModel = new ItemModel();
                goodsModel.setCode(orderModel.getGoodsId());
                goodsModel.setStock(orderModel.getGoodsNum().longValue());
                batchOrderManager.updateGoodsYG(goodsModel);//回滚商品数量
            }else{
                // 判断活动，荷兰拍回滚，其他活动不回滚。。。
                if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderModel.getActType())){
                    String promId = orderModel.getActId();// 活动id
                    String periodId = String.valueOf(orderModel.getPeriodId());
                    String itemId = orderModel.getGoodsId(); //单品号
                    String userId = orderModel.getCreateOper();
                    String today = DateHelper.getyyyyMMdd();
                    //操作redis,回滚库存
                    promotionRedisBatchDao.updatePromSaleInfo(promId, periodId, itemId, 1L, today, userId);
                }
                // 活动回滚库存
                Map<String, Object> proMap = Maps.newHashMap();
                proMap.put("promId", orderModel.getActId());
                proMap.put("itemCode", orderModel.getGoodsId());
                proMap.put("itemCount", orderModel.getGoodsNum());
                Response<Boolean> ret = mallPromotionService.updateRollbackPromotionStock(Lists.newArrayList(proMap));
                if (!ret.isSuccess() || !ret.getResult()) {
                    throw new RuntimeException(ret.getError());
                }
            }
            if (orderModel.getBonusTotalvalue() != null && orderModel.getBonusTotalvalue().longValue() != 0L) {//回滚积分池
                // 修改废单回滚积分池回滚时间按订单创建时间为准
                log.info("积分池回滚。。。。。。");
                Map<String, Object> paramJF = Maps.newHashMap();
                paramJF.put("used_point", -orderModel.getBonusTotalvalue());
                paramJF.put("cur_month", DateHelper.getyyyyMM(orderModel.getCreateTime()));
                batchOrderManager.dealPointPoolForDate(paramJF);
            }
        }

        //改大订单状态(业务修改，都更新大订单状态)
        paramMap = Maps.newHashMap();
        paramMap.put("ordermainId", orderModel.getOrderMainId());
        paramMap.put("curStatusId", "0304");
        paramMap.put("curStatusNm", "已废单");
        paramMap.put("modifyOper", "SYSTEM");
        paramMap.put("modifytime", DateHelper.getCurrentTime());
        batchOrderManager.updateOrderMainStatus(paramMap); //改大订单状态

        try{
            if("0004".equals(orderModel.getMemberLevel())){//如果是生日价
                Integer birthCount = batchOrderDao.getTblEspCustNew(orderModel.getCreateOper());
                if (birthCount != null) {
                    if(orderModel.getGoodsNum() != null &&
                            birthCount.intValue() > orderModel.getGoodsNum().intValue()) {
                        paramMap = Maps.newHashMap();
                        paramMap.put("cust_id", orderModel.getCreateOper());
                        paramMap.put("birth_used_count", orderModel.getGoodsNum());
                        batchOrderManager.updateTblEspCustNew(paramMap);
                    } else {
                        paramMap = Maps.newHashMap();
                        paramMap.put("cust_id", orderModel.getCreateOper());
                        batchOrderManager.updateTblEspCustNew0(paramMap);
                    }
                }
            }

            log.info("插入订单处理历史：" + orderModel.getOrderId());
            OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
            orderDoDetailModel.setOrderId(orderModel.getOrderId());
            orderDoDetailModel.setStatusId("0304");
            orderDoDetailModel.setStatusNm("已废单");
            orderDoDetailModel.setModifyOper("SYSTEM");
            orderDoDetailModel.setUserType("0");//0：系统用户[批量]
            orderDoDetailModel.setDoUserid("SYSTEM");
            orderDoDetailModel.setCreateOper("SYSTEM");
            orderDoDetailModel.setDelFlag(0);
            batchOrderManager.insertOrderDoDetail(orderDoDetailModel); //插入履历

            // 插入履历后再插入消息
            MessageDto messageDto = new MessageDto();
            messageDto.setOrderId(orderModel.getOrderId());
            messageDto.setOrderStatus("0304");
            messageDto.setCustId(orderModel.getCreateOper());
            messageDto.setGoodName(orderModel.getGoodsNm());
            messageDto.setVendorId(orderModel.getVendorId());
            messageDto.setUserType("0");
            messageDto.setCreateOper("SYSTEM");
            newMessageService.insertUserMessage(messageDto);
        } catch (Exception e) {
            log.error("exception{}",Throwables.getStackTraceAsString(e));
        }
        log.info("完成处理废单:" + orderModel.getOrderId());
    }
}
