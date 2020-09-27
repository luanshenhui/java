/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderOutSystemDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.manager.OrderCheckManager;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 *
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/27
 */
@Service
@Slf4j
public class OrderPushServiceImpl implements OrderPushService{
    @Resource
    private OrderSubDao orderSubDao;
    @Resource
    OrderMainDao orderMainDao;
    @Resource
    private OrderOutSystemDao orderOutSystemDao;
    @Resource
    private ItemService itemService;
    @Resource
    private cn.com.cgbchina.rest.visit.service.order.OrderService orderService;
    @Resource
    private OrderService orderService1;
    @Resource
    OrderCheckManager orderCheckManager;


    // 判断非空
    private Boolean isNotBlank(String str) {
        if (StringUtils.isNotBlank(str) && StringUtils.isNotBlank(str.trim().replace(" ", "")))
            return Boolean.TRUE;
        return Boolean.FALSE;
    }
    /**
     * 手动推送订单
     * @param user
     * @param pageNo
     * @param size
     * @param orderId
     * @param startTime
     * @param endTime
     * @param orderType
     * @return
     */
    @Override
    public Response<Pager<RequestOrderDto>> find(@Param("pageNo") Integer pageNo,
                                          @Param("size") Integer size, @Param("orderId") String orderId, @Param("startTime") String startTime,
                                          @Param("endTime") String endTime,@Param("orderType") String orderType,@Param("_USER_") User user){
        Response<Pager<RequestOrderDto>> response = new Response<>();
        Map<String, Object> paramMap = Maps.newHashMap();
        List<RequestOrderDto> requestOrderDtos = Lists.newArrayList();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        // 默认选择逻辑删除
        paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
        //默认选择支付成功的订单
        paramMap.put("curStatusId",Contants.SUB_ORDER_STATUS_0308);
        if (StringUtils.isNotEmpty(startTime)) {
            paramMap.put("startTime", startTime);// 下单开始时间
        }
        if (StringUtils.isNotEmpty(endTime)) {
            paramMap.put("endTime", endTime);// 下单结束时间
        }
        String vendorId = user.getVendorId();
        if (StringUtils.isNotEmpty(vendorId)) {
            paramMap.put("vendorId", vendorId);// 供应商Id
        }
        if (StringUtils.isNotEmpty(orderType) && "2".equals(orderType)) {
            paramMap.put("orderType", orderType);//业务类型：积分
            paramMap.put("orderTypeJF",Contants.BUSINESS_TYPE_JF);
        }else {
            paramMap.put("orderType", Contants.CERATE_TYPE_ADMIN_0);//业务类型：广发商城
            paramMap.put("orderTypeYG",Contants.BUSINESS_TYPE_YG);
            paramMap.put("orderTypeFQ",Contants.BUSINESS_TYPE_FQ);
        }
        //先查询推送表中的数据，根据推送表中的数据查询订单数据中的数据
        List<OrderOutSystemModel> orderOutSystemModelList = this.findOrderOutSystem(orderId);
        //判断list是否时空，如果是空直接返回空集合
        if (orderOutSystemModelList.size() == 0){
            response.setResult(null);
            return response;
        }
        //推送表中的orderId作为订单表中的搜索条件
        List<String> orderIds = Lists.newArrayList();
        for (OrderOutSystemModel orderOutSystemModel : orderOutSystemModelList){
            orderIds.add(orderOutSystemModel.getOrderId());
        }
        paramMap.put("orderIds",orderIds);
        try {
            //查询子订单数据
            Pager<OrderSubModel> pager = orderSubDao.findLikeByPageForPush(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
            List<OrderSubModel> orderSubModelList = pager.getData();
            //遍历orderSubModel,构造返回值
            for (OrderSubModel orderSubModel:orderSubModelList){
                RequestOrderDto requestOrderDto = new RequestOrderDto();
                requestOrderDto.setOrderSubModel(orderSubModel);
                //主订单
                OrderMainModel orderMainModel = new OrderMainModel();
                if (isNotBlank(orderSubModel.getOrdermainId())) {
                    orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
                    if (orderMainModel == null) {
                        response.setError("Ordermain.can.not.be.null");
                        return response;
                    }
                    requestOrderDto.setOrderMainModel(orderMainModel);
                }
                // 分期编码
                String goodsId = orderSubModel.getGoodsId();
                ItemModel itemModel = itemService.findById(goodsId);
                if (itemModel != null){
                    requestOrderDto.setMid(itemModel.getMid());
                    requestOrderDto.setXid(itemModel.getXid());
                }
                requestOrderDtos.add(requestOrderDto);
            }
            response.setResult(new Pager<RequestOrderDto>(pager.getTotal(), requestOrderDtos));
            return response;
        } catch (Exception e) {
            log.error("reject goods query error{}", Throwables.getStackTraceAsString(e));
            response.setError("reject.goods.query.error");
            return response;
        }
    }

    /**
     * 查询订单推送表中的数据
     * @param orderId
     * @return
     */
    private List<OrderOutSystemModel> findOrderOutSystem(String orderId){
        Map<String,Object> dataMap = Maps.newHashMap();
        dataMap.put("orderId",orderId);
        dataMap.put("times",6);
        dataMap.put("tuisongFlag","0");
        return orderOutSystemDao.findAll(dataMap);
    }

    /**
     * 手动推送订单
     * @param orderId
     * @param vendorName
     * @return
     */
    @Override
    public Response<Boolean> pushOrder(String orderId,String vendorName,String vendorId){
        Response<Boolean> response = Response.newResponse();
        Response<List<O2OOrderInfo>> response1 = Response.newResponse();
        BaseResult baseResult = new BaseResult();
        SendOrderToO2OInfo sendOrderToO2OInfo = new SendOrderToO2OInfo();
        try{
            OrderSubModel orderSubModel = orderSubDao.findById(orderId);
            if (orderSubModel == null){
                response.setError("Order.can.not.find");
                return response;
            }
            //组装接口需要的参数
            String ordermainId = orderSubModel.getOrdermainId();
            BigDecimal payMent = new BigDecimal(0);
            //供应商ID
            sendOrderToO2OInfo.setVendorName(vendorId);
            sendOrderToO2OInfo.setOrganId("");
            List<O2OOrderInfo> o2OOrderInfos = Lists.newArrayList();
            //组装o2oOrderInfos
            response1 = orderService1.findpushOrder(ordermainId);
            if (response1.isSuccess()){
                o2OOrderInfos = response1.getResult();
            }
            sendOrderToO2OInfo.setO2OOrderInfos(o2OOrderInfos);
            //构造payMent
            for (O2OOrderInfo o2OOrderInfo:o2OOrderInfos){
                payMent.add(o2OOrderInfo.getPrice());
            }
            sendOrderToO2OInfo.setPayment(payMent);
            //organId暂时不处理
            //调用推送接口
            baseResult = orderService.sendO2OOrderInfo(sendOrderToO2OInfo);
            Boolean result = null;
            if (Contants.GOODS_SEND_FLAG_0.equals(baseResult.getRetCode())){
                Integer tuisongFlag = 1;
                result = updateInfo(ordermainId,tuisongFlag,vendorId);
            }else {
                Integer tuisongFlag = 0;
                result = updateInfo(ordermainId,tuisongFlag,vendorId);
            }
            if ((Boolean.FALSE).equals(result)){
                response.setError("failed.order.not.found");
                return response;
            }else {
                //调用接口失败
                if (!Contants.GOODS_SEND_FLAG_0.equals(baseResult.getRetCode())){
                    response.setError("failed.push.O2OOrder");
                    return response;
                }
            }
            response.setResult(Boolean.TRUE);
            return response;
        }catch(Exception e){
            log.error("pushOrder error{}", Throwables.getStackTraceAsString(e));
            response.setError("pushOrder.error");
            return response;
        }
    }

    /**
     * 根据返回值更新推送表
     * @param ordermainId
     * @param tuisongFlag
     * @return
     */
    private Boolean updateInfo(String ordermainId,Integer tuisongFlag,String vendorId){
        Map<String,Object> dataMap = Maps.newHashMap();
        dataMap.put("ordermainId",ordermainId);
        dataMap.put("modifyOper",vendorId);
        if (tuisongFlag == 1){
            dataMap.put("tuisongFlag","1");
        }
        Integer result = orderCheckManager.updateByFlag(dataMap);
        if (result > 0){
            return Boolean.TRUE;
        }else {
            return Boolean.FALSE;
        }
    }
}
