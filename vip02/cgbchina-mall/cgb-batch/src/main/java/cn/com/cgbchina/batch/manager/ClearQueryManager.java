package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.ClearQueryDao;
import cn.com.cgbchina.batch.model.OrderDoDetailModel;
import cn.com.cgbchina.batch.model.OrderSubModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.Map;

/**
 * Created by CuiZhengwei on 2016/7/15.
 */
@Component
@Slf4j
@Transactional
public class ClearQueryManager {
    @Resource
    private ClearQueryDao clearQueryDao;
    @Resource
    private NewMessageService newMessageService;
    @Transactional
    public void updateClearFlagStatus() {
        // 将需要发送请款报文的订单clearFlag置为2
        Map<String, Object> params = Maps.newHashMap();
        params.put("updateclearFlag", "2");
        params.put("changeClearFlag", "0");
        params.put("statusId", Contants.SUB_SIN_STATUS_0350);
        clearQueryDao.updateClearFlagStatus(params);
    }
    @Transactional
    public void updateClearFlagStatus2() {
        // 将需要发送请款报文的订单clearFlag置为2
        Map<String, Object> params = Maps.newHashMap();
        params.put("updateclearFlag", "0");
        params.put("changeClearFlag", "2");
        params.put("statusId", Contants.SUB_SIN_STATUS_0350);
        clearQueryDao.updateClearFlagStatus(params);
    }
    /**
     * 成功时更新状态
     *
     * @param orderId
     * @param orderClearId
     */
    @Transactional
    public void updateOrderstatusWithTxn(String orderId, long orderClearId, OrderSubModel orderSubModel) {
        Map<String, Object> paramOC = Maps.newHashMap();
        paramOC.put("orderClearId", orderClearId);
        paramOC.put("statusId", "0311");
        paramOC.put("clearFlag", "1"); // 1:请款报文成功发送
        paramOC.put("clearTime", new Date());
        clearQueryDao.updateOrderClear(paramOC);
        Map<String, Object> params = Maps.newHashMap();
        params.put("orderId", orderId);
        params.put("sinStatusId", "0311");
        params.put("sinStatusNm", "请款成功");
        params.put("balanceStatus", "0000");
        clearQueryDao.updateSinStatusId(params);
        // 插入订单操作履历
        OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
        orderDoDetailModel.setOrderId(orderId);
        orderDoDetailModel.setStatusId("0311");
        orderDoDetailModel.setStatusNm("请款成功");
        orderDoDetailModel.setDoDesc("自动任务跑清算");
        orderDoDetailModel.setDoUserid("SYSTEM");
        orderDoDetailModel.setCreateOper("SYSTEM");
        orderDoDetailModel.setUserType("0");
        orderDoDetailModel.setDelFlag(0);
        clearQueryDao.insertOrderDoDetail(orderDoDetailModel);
        try {
            MessageDto messageDto = new MessageDto();
            messageDto.setOrderId(orderId);
            messageDto.setGoodName(orderSubModel.getGoodsNm());
            messageDto.setVendorId(orderSubModel.getVendorId());
            messageDto.setCustId(orderSubModel.getCreateOper());
            messageDto.setOrderStatus("0311");
            messageDto.setUserType("0");
            messageDto.setCreateOper("SYSTEM");
            newMessageService.insertUserMessage(messageDto);
        } catch (Exception e){
            log.error("插入消息异常 orderId:"+orderId+" {}",Throwables.getStackTraceAsString(e));
        }
    }

    /**
     * 失败时修改清算表的前置状态， 修改订单表的状态
     *
     * @param orderId
     * @param orderClearId
     */
    @Transactional
    public void changeOrderstatusWithTxn(String orderId, Long orderClearId) {
        // 结算失败--0001
        Map<String, Object> params = Maps.newHashMap();
        params.put("balanceStatus", "0001");
        params.put("orderId", orderId);
        clearQueryDao.updateBalanceStatus(params);
        Map<String, Object> params1 = Maps.newHashMap();
        params1.put("orderClearId", orderClearId);
        params1.put("clearFlag", "0"); // 0:初始化
        params1.put("clearTime", new Date());
        clearQueryDao.updateOrderClear(params1);
    }
}
