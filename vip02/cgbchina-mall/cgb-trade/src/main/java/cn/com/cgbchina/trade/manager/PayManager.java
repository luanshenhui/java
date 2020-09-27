package cn.com.cgbchina.trade.manager;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PayReturnCode;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.rest.provider.vo.order.PayReturnOrderVo;
import cn.com.cgbchina.trade.dao.OrderDoDetailDao;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderOutSystemDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblEspCustCartDao;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblEspCustCartModel;
import cn.com.cgbchina.user.service.EspCustNewService;

import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.util.JsonMapper;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import lombok.extern.slf4j.Slf4j;

/**
 * 订单处理
 * <p/>
 * geshuo 20160818
 */
@Component
@Transactional
@Slf4j
public class PayManager {

    @Resource
    MallPromotionService mallPromotionService;

    @Resource
    OrderMainDao orderMainDao;

    @Resource
    OrderSubDao orderSubDao;

    @Resource
    OrderDoDetailDao orderDoDetailDao;

    @Resource
    OrderOutSystemDao orderOutSystemDao;
    
    @Resource
    OrderMainManager orderMainManager;
	@Resource
	TblEspCustCartDao tblEspCustCartDao;
	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	EspCustNewService espCustNewService;
	private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();

    /**
     * 微信0元秒杀下单
     * @param orderMainModel 主订单
     * @param orderSubModel 子订单
     * @param orderDoDetailModel 订单操作历史
     * @param orderOutSystemModel 订单推送
     * @param user 用户
     * @param paramMap 其他参数
     * @throws Exception
     *
     * geshuo 20160818
     */
    public void paywithTX(OrderMainModel orderMainModel, OrderSubModel orderSubModel, OrderDoDetailModel orderDoDetailModel,
                          OrderOutSystemModel orderOutSystemModel, User user, Map<String, String> paramMap) throws Exception {
        //插入大订单
        orderMainDao.insert(orderMainModel);

        //插入子订单
        orderSubDao.insert(orderSubModel);

        //更新订单处理历史
        orderDoDetailDao.insert(orderDoDetailModel);

        //更新外系统订单推送表
        orderOutSystemDao.insert(orderOutSystemModel);

        String promotionId = paramMap.get("promotionId");//活动id
        String periodId = paramMap.get("periodId");//活动场次id
        String itemCode = paramMap.get("itemCode");//单品id
        String buyCount = paramMap.get("buyCount");//购买数量
        //调用活动接口，记录销售数量  
        Response<Boolean> saleUpdateResponse = mallPromotionService.updatePromSaleInfo(promotionId, periodId, itemCode, buyCount, user);
        if (!saleUpdateResponse.isSuccess()) {
            //系统异常
            throw new ResponseException("000009");
        }

        if (!saleUpdateResponse.getResult()) {
            //更新销量信息失败
            throw new ResponseException("000074");
        }
    }

    public Integer insert(OrderOutSystemModel orderOutSystemModel){
        return orderOutSystemDao.insert(orderOutSystemModel);
    }
    
	public Response<Map<String,String>> dealJFOrderWithTX(String ordermain_id, String payAccountNo, String cardType,
			List<PayReturnOrderVo> checkList, List<OrderSubModel> orderList, String custType) {
        //定义返回数据 map  key为订单号 value为订单状态
        Map<String,String> resultMap=new HashMap<>();
		Response<Map<String,String>> result = Response.newResponse();
		boolean orderMainFlag = true;
		PayReturnOrderVo payReturnOrderVo = checkList.get(0);
		/**
         * =============处理小订单信息 start============
         */
        for (OrderSubModel order : orderList) {
            String returnCode = payReturnOrderVo.getReturnCode(); //响应码

            Map<String, Object> params=null;
            if (PayReturnCode.isSucess(returnCode)) {
            	// 成功支付
                log.info("[支付成功]订单号"+order.getOrderId());
                //更新子订单表（控制只有待付款(0301)和支付失败(0307)的情况下进行处理, 参数2只是为了避免与mal315调用的更新订单方法重载冲突）
                params = createOrderMap(payAccountNo,
						cardType, custType, payReturnOrderVo, order,Contants.SUB_ORDER_STATUS_0308);
                int updateTempFlag = orderSubDao.updateOrderUnderControl(params);
                if (updateTempFlag <= 0) {
                	throw new RuntimeException("找不到子订单:"+jsonMapper.toJson(params));
                }
                TblEspCustCartModel tblEspCustCartModel = new TblEspCustCartModel();
                tblEspCustCartModel.setId(Long.getLong(order.getCustCartId()));
                tblEspCustCartModel.setPayFlag("1");
                tblEspCustCartDao.update(tblEspCustCartModel);// 清理购物车{根据购物车ID）


            } else if (PayReturnCode.isStateNoSure(returnCode)) {
            	// 状态未明
                log.info("[状态未明]订单号"+order.getOrderId());
                //更新子订单表（控制只有待付款和支付失败的情况下进行处理, 参数2只是为了避免与mal315调用的更新订单方法重载冲突）
                params = createOrderMap(payAccountNo,
						cardType, custType, payReturnOrderVo, order,Contants.SUB_ORDER_STATUS_0316);
                int updateTempFlag = orderSubDao.updateOrderUnderControl(params);
                if (updateTempFlag <= 0) {
                	throw new RuntimeException("找不到子订单:"+jsonMapper.toJson(params));
                }
                
            } else {
            	// 支付失败
                log.info("[支付失败]订单号"+order.getOrderId());
                String errorCode = order.getErrorCode();// 根据订单表查询返回错误码
                if (errorCode == null || "".equals(errorCode.trim())) {// 如果没成功返回过支付结果
                    log.info("[没成功返回过支付结果，做相关回滚动作]订单号"+order.getOrderId());
                    Response<ItemModel> reponse = itemService.findByCodeAll(order.getGoodsId());
                    if(!reponse.isSuccess()){
                        log.error("Response.error,error code: {}", reponse.getError());
                        throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
                    }
                    ItemModel goodsInf = reponse.getResult();
                    if (goodsInf.getStock().intValue() <= 9999) {//如果库存数大于9999则不回滚
                        goodsService.updateGoodsJF(goodsInf.getCode(), goodsInf.getStock());// 回滚商品数量
                    }
                }
                //更新子订单表（控制只有待付款和支付失败的情况下进行处理, 参数2只是为了避免与mal315调用的更新订单方法重载冲突）
                params =createOrderMap(payAccountNo,
						cardType, custType, payReturnOrderVo, order,Contants.SUB_ORDER_STATUS_0307);
                orderSubDao.updateOrderUnderControl(params);
                orderMainFlag = false;
            }
            //订单处理历史明细表
            OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
            orderDodetail.setOrderId(order.getOrderId());
            orderDodetail.setDoUserid("System");
            orderDodetail.setUserType("0");
            orderDodetail.setStatusId((String)params.get("curStatusId"));
            orderDodetail.setStatusNm((String)params.get("curStatusNm"));
            orderDodetail.setDoDesc("手机商城积分支付");
            orderDodetail.setCreateOper("System");
            orderDodetail.setDelFlag(0);
            orderDoDetailDao.insert(orderDodetail);

            //将小订单设置到返回参数
            resultMap.put(order.getOrderId(),(String)params.get("curStatusId"));
		}
        /**
         * =============处理小订单信息 end============
         */
        /**
         * =============处理大订单信息 start============
         */
        Map<String, Object> params = Maps.newHashMap();
		if (orderMainFlag) {// 大订单成功
			// 更新大订单表（控制只有待付款[0301]和支付失败[0307]的情况下进行处理, 参数2只是为了避免与mal315调用的更新订单方法重载冲突）
			params.put("ordermainId", ordermain_id);
			params.put("payAccountNo", payAccountNo);
			params.put("payResultTime", DateHelper.getyyyyMMdd() + DateHelper.getHHmmss());
			params.put("curStatusId", "0308");
			params.put("curStatusNm", "支付成功");
			params.put("curStatusIdPrecondition1", "0301");
			params.put("curStatusIdPrecondition2", "0307");
            orderMainManager.updateorderMainStatusUnderControl(params);
		} else {// 大订单异常
			// 更新大订单表（控制只有待付款和支付失败的情况下进行处理, 参数2只是为了避免与mal315调用的更新订单方法重载冲突）
			params.put("ordermainId", ordermain_id);
			params.put("payAccountNo", payAccountNo);
			params.put("payResultTime", DateHelper.getyyyyMMdd() + DateHelper.getHHmmss());
			params.put("curStatusId", "0307");
			params.put("curStatusNm", "支付失败");
			params.put("curStatusIdPrecondition1", "0301");
			params.put("curStatusIdPrecondition2", "");
            orderMainManager.updateorderMainStatusUnderControl(params);
		}
		/**
         * =============处理大订单信息 end============
         */
		result.setSuccess(true);
        resultMap.put(ordermain_id,String.valueOf(params.get("curStatusId")));
		result.setResult(resultMap);
		return result;
	}

	private Map<String, Object> createOrderMap(String payAccountNo,
			String cardType, String custType,
			PayReturnOrderVo payReturnOrderVo, OrderSubModel order,String curStatusId) {
		Map<String, Object> params = Maps.newHashMap();
		params.put("orderId", order.getOrderId());
		params.put("payAccountNo", payAccountNo);
		params.put("cardType", cardType);
		params.put("curStatusId", curStatusId);
		params.put("order_succ_time", order.getOrder_succ_time());
		String curStatusIdStr=null;
		switch(curStatusId){
			case Contants.SUB_ORDER_STATUS_0316:
				curStatusIdStr=Contants.SUB_ORDER_UNCLEAR;
				break;
			case Contants.SUB_ORDER_STATUS_0307:
				curStatusIdStr=Contants.SUB_ORDER_PAYMENT_FAILED;
				params.put("curStatusIdPrecondition1", "0301");
                params.put("curStatusIdPrecondition2", "");
				break;
			case Contants.SUB_ORDER_STATUS_0308:
				curStatusIdStr=Contants.SUB_ORDER_PAYMENT_SUCCEED;
				break;
			default:
				throw new RuntimeException("未知订单状态");
		}
		params.put("curStatusNm", curStatusIdStr);
		params.put("errorCode", payReturnOrderVo.getReturnCode());
		params.put("custType", custType);
		params.put("curStatusIdPrecondition1", "0301");
		params.put("curStatusIdPrecondition2", "0307");
		return params;
	}
}
