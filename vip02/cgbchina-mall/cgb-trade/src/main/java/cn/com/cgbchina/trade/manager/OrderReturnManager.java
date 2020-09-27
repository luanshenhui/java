/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.trade.dao.OrderDoDetailDao;
import cn.com.cgbchina.trade.dao.OrderReturnTrackDetailDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Map;

/**
 *
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/15
 */
@Component
@Transactional
public class OrderReturnManager {
    @Resource
    OrderSubDao orderSubDao;
    @Resource
    OrderDoDetailDao orderDoDetailDao;
    @Resource
    OrderReturnTrackDetailDao orderReturnTrackDetailDao;
    @Resource
    NewMessageService newMessageService;

    /**
     * 供应商退货审核更新订单表，插入订单历史表，插入退货履历表
     * @param orderSubModel
     * @param orderDoDetailModel
     * @param orderReturnTrackDetailModel
     * @param messageDto
     * @return
     * @throws Exception
     */
    @Transactional(rollbackFor = { Exception.class })
    public Boolean updateReturnVendor(OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
                                      OrderReturnTrackDetailModel orderReturnTrackDetailModel,
                                      MessageDto messageDto) throws Exception {
        Map<String,Object> orderSubModelMap = Maps.newHashMap();
        orderSubModelMap.put("orderId",orderSubModel.getOrderId());
        orderSubModelMap.put("vendorOperFlag",orderSubModel.getVendorOperFlag());
        orderSubModelMap.put("curStatusId",orderSubModel.getCurStatusId());
        orderSubModelMap.put("curStatusNm",orderSubModel.getCurStatusNm());
        orderSubModelMap.put("modifyOper",orderSubModel.getModifyOper());
        orderSubModelMap.put("referenceNo",orderSubModel.getReferenceNo());
        Boolean flag1 = orderSubDao.updateForReturn(orderSubModelMap);
        Boolean flag2 = orderDoDetailDao.insert(orderDoDetailModel) == 1;
        Boolean flag3 = orderReturnTrackDetailDao.insert(orderReturnTrackDetailModel) == 1;
        Response response = newMessageService.insertUserMessage(messageDto);
        if(!response.isSuccess()){
            throw new Exception(response.getError());
        }
        //全部通过
        if ((Boolean.TRUE).equals(flag1) && (Boolean.TRUE).equals(flag2) && (Boolean.TRUE).equals(flag3)){
            return Boolean.TRUE;
        }else {
            //事物回滚
            throw new IllegalArgumentException("current.order.status.illegal");
        }
    }

}
