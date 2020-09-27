package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateStateRetrunVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateStateVO;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.model.AuctionRecordModel;
import cn.com.cgbchina.trade.model.OrderBackupModel;
import cn.com.cgbchina.trade.model.OrderCheckModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;
import cn.com.cgbchina.trade.service.*;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

/**
 * MAL112 订单状态修改(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL112")
@Slf4j
public class StageMallOrderUpdateStateProvideServiceImpl implements  SoapProvideService <StageMallOrderUpdateStateVO,StageMallOrderUpdateStateRetrunVO>{
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private PaymentService paymentService;
	@Resource
	private DealO2OOrderService dealO2OOrderService;
	@Resource
	private ItemService itemService;
	@Resource
	private PointsPoolService pointsPoolService;
	@Resource
	private OrderService orderService;
	@Resource
	private OrderCancelService orderCancelService;
	@Resource
	private MallPromotionService mallPromotionService;
	@Resource
	private AuctionRecordService auctionRecordService;
	@Resource
	PayService payService;


	@Override
	public StageMallOrderUpdateStateRetrunVO process(SoapModel<StageMallOrderUpdateStateVO> model, StageMallOrderUpdateStateVO content) {
		StageMallOrderUpdateStateRetrunVO envolopeVo = new StageMallOrderUpdateStateRetrunVO();

		log.debug("【MAL112】进入订单查询接口");
		String orderId = content.getOrderId();	//子订单号
		String cur_status_id = content.getCurStatusId();	//变更订单状态
		String ordernbr = content.getOrderNbr();	//银行订单号
		// String[] orderIds = {orderId};

		OrderSubModel tblOrder = null;
		TblOrderHistoryModel orderHistory = null;
		String curStatusId = "";
		//String curStatusNm = "";
		String voucherNo = "";
		Long bonusTotalvalue = null;
		String goodsId = "";
		String createDate = "";
		String createTime = "";

		tblOrder = orderService.findOrderId(orderId);
		if (tblOrder == null){ // 订单表为空时，查订单历史表
			Response<TblOrderHistoryModel> result = orderService.findTblOrderHistoryById(orderId);
			if (result.isSuccess()){
				orderHistory = result.getResult();
				if (orderHistory != null) {
					curStatusId = orderHistory.getCurStatusId();
					voucherNo = orderHistory.getVoucherNo();
					bonusTotalvalue = orderHistory.getBonusTotalvalue();
					goodsId = orderHistory.getGoodsId();
					createDate = DateHelper.getyyyyMMdd(orderHistory.getCreateTime());
					createTime = DateHelper.getHHmmss(orderHistory.getCreateTime());
				}
			}
		}else{
			curStatusId = tblOrder.getCurStatusId();
			voucherNo = tblOrder.getVoucherNo();
			bonusTotalvalue = tblOrder.getBonusTotalvalue();
			goodsId = tblOrder.getGoodsId();
			createDate = DateHelper.getyyyyMMdd(tblOrder.getCreateTime());
			createTime = DateHelper.getHHmmss(tblOrder.getCreateTime());
		}

		if(tblOrder == null&&orderHistory == null){//如果当前表、历史表都为空
			// 查询两年前订单
			Response<OrderBackupModel> orderBackupModel = orderService.findOrderBackupById(orderId);
			if(orderBackupModel != null){
				//如果从备份表中取出数据，则提示用户数据超过两年不能操作
				envolopeVo.setReturnCode("000071");
				envolopeVo.setReturnDes("数据超过两年，不可操作！");
				return envolopeVo;
			}
		}
		Response<TblOrderExtend1Model> response = orderService.queryTblOrderExtend1(orderId);
		TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
		if (response.isSuccess()){
			tblOrderExtend1 = response.getResult();
		}
		tblOrderExtend1.setOrdernbr(ordernbr);

		try{
			if(tblOrder != null||orderHistory != null){
				OrderCheckModel orderCheck = null;
				if(cur_status_id.equals(curStatusId)
						|| (!"0301".equals(curStatusId)
						&& !"0305".equals(curStatusId)
						&& !"0316".equals(curStatusId))){	//订单状态不为待付款，处理中，状态未明不能修改订单状态

					log.info("【无需修改订单状态】只有待付款，处理中，状态未明订单才能修改订单状态，无需修改，订单号:" + orderId
							+ "，订单状态:" + curStatusId + "，变更状态:" + cur_status_id);

					envolopeVo.setReturnCode("000014");
					envolopeVo.setReturnDes("订单状态无需修改");
					return envolopeVo;
				} else if(Contants.SUB_ORDER_STATUS_0307.equals(cur_status_id)){	//订单支付失败，更新商品表库存，更新订单状态
					String orderCurStatus = curStatusId;
					String jfRefundSerialno = "";//退积分流水
					if(bonusTotalvalue!=null&&bonusTotalvalue.longValue()!=0){
						jfRefundSerialno = idGenarator.jfRefundSerialNo();
					}
					if(voucherNo!=null&&!"".equals(voucherNo)||bonusTotalvalue!=null&&bonusTotalvalue.longValue()!=0){//只有由处理中变为支付失败才送负交易
						orderCheck = new OrderCheckModel();
						orderCheck.setOrderId(orderId);
						orderCheck.setCurStatusId(cur_status_id);
						orderCheck.setCurStatusNm("支付失败");
						orderCheck.setDoDate(DateHelper.getyyyyMMdd());
						orderCheck.setDoTime(DateHelper.getHHmmss());
						if(voucherNo!=null&&!"".equals(voucherNo)&&!"0307".equals(orderCurStatus)){//防止进展查询变为支付失败
							//orderCheck = new TblOrderCheck();
							orderCheck.setIscheck("0");
						}
						if(bonusTotalvalue!=null&&bonusTotalvalue.longValue()!=0&&"0305".equals(orderCurStatus)){//只有由处理中变为支付失败才送负交易
							//orderCheck = new TblOrderCheck();
							orderCheck.setIspoint("0");
							orderCheck.setJfRefundSerialno(jfRefundSerialno);//20150202 hwh add 退积分流水
						}
						if(!"0".equals(orderCheck.getIscheck())&&!"0".equals(orderCheck.getIspoint())){
							orderCheck=null;
						}
					}
					if(tblOrder!=null){
						tblOrder.setCurStatusId(cur_status_id);//修改订单状态
						tblOrder.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
					}else if(orderHistory!=null){
						orderHistory.setCurStatusId(cur_status_id);//修改订单状态
						orderHistory.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
					}

					ItemModel tblGoodsInf = itemService.findById(goodsId);		//查询该订单商品
					//订单状态修改，插入dodetail表
					OrderDoDetailModel orderDetail = new OrderDoDetailModel();
					orderDetail.setOrderId(orderId);
					orderDetail.setStatusId(cur_status_id);
					orderDetail.setStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
					orderDetail.setDoTime(new Date());
					orderDetail.setDoUserid("system");	//待定
					orderDetail.setUserType("0");
					orderDetail.setDoDesc("BPS修改订单状态");
					orderDetail.setCreateOper("system");
					orderDetail.setCreateTime(new Date());
					orderDetail.setDelFlag(0);

					//更新订单表，修改库存，记录订单状态
					//orderChangewithTX(tblOrder, tblGoodsInf, orderDetail, tblOrderExtend1, orderCheck, orderHistory);
					payService.orderChangeWithTX(tblOrder, tblGoodsInf, orderDetail, tblOrderExtend1, orderCheck, orderHistory);
					//bps失败需要撤销积分
					if(null!= orderCheck && tblOrder != null && tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue().longValue() != 0){
						try{
							sendNSCT009(tblOrder,orderCheck.getDoDate(),orderCheck.getDoTime(),jfRefundSerialno);
						}catch(Exception e){
							log.error("发送nsct009异常:"+e.getMessage(),e);
						}
					}

					log.info("【订单状态修改】订单状态修改成功，订单号:" + orderId + "，订单状态：" + curStatusId);
					envolopeVo.setReturnCode("000000");
					envolopeVo.setReturnDes("订单状态修改成功");
				} else {
					if(!"0308".equals(curStatusId)){//防止进展查询将订单状态改为支付成功
						if((voucherNo!=null&&!"".equals(voucherNo))||(bonusTotalvalue!=null&&bonusTotalvalue.longValue()!=0)){
							orderCheck = new OrderCheckModel();
							orderCheck.setOrderId(orderId);
							orderCheck.setCurStatusId(cur_status_id);
							orderCheck.setCurStatusNm("支付成功");
							orderCheck.setDoDate(createDate);
							orderCheck.setDoTime(createTime);
							if(voucherNo!=null&&!"".equals(voucherNo)){
								orderCheck.setIscheck("0");
							}

							if(!"0".equals(orderCheck.getIscheck())&&!"0".equals(orderCheck.getIspoint())){
								orderCheck=null;
							}
						}
					}
					if(tblOrder!=null){
						tblOrder.setCurStatusId(cur_status_id);//修改订单状态
						tblOrder.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
					}else if(orderHistory!=null){
						orderHistory.setCurStatusId(cur_status_id);//修改订单状态
						orderHistory.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
					}


					//订单状态修改，插入dodetail表
					OrderDoDetailModel orderDetail = new OrderDoDetailModel();
					orderDetail.setOrderId(orderId);
					orderDetail.setStatusId(cur_status_id);
					orderDetail.setStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
					orderDetail.setDoTime(new Date());
					orderDetail.setDoUserid("system");	//待定
					orderDetail.setUserType("0");
					orderDetail.setDoDesc("BPS修改订单状态");
					orderDetail.setCreateOper("system");
					orderDetail.setCreateTime(new Date());
					orderDetail.setDelFlag(0);

					/*-- 更新补跑任务表--*/
//					String creatDate = tblOrder.getCreateDate();	//下单时间
					Date nowDate = new Date();
					SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
					String strDate = format.format(nowDate);

					int todayInt = Integer.parseInt(strDate);
					int creatDateInt = Integer.parseInt(createDate);

					SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
					Calendar cal = Calendar.getInstance();
					cal.setTime(new SimpleDateFormat("yyyyMMdd").parse(createDate));
					cal.add(Calendar.DAY_OF_WEEK , Calendar.SUNDAY-cal.get(Calendar.DAY_OF_WEEK));
					String creatWeek = formatter.format(cal.getTime());

					cal.setTime(new SimpleDateFormat("yyyyMMdd").parse(createDate));
					cal.add(Calendar.DAY_OF_MONTH , 1-cal.get(Calendar.DAY_OF_MONTH));
					String creatMonth = formatter.format(cal.getTime());

					Map<String,String> runTime = Maps.newHashMap();
					if(todayInt>creatDateInt){
						runTime.put("creatDate", createDate);
						runTime.put("creatWeek", creatWeek);
						runTime.put("creatMonth", creatMonth);
					}
					/*-- 更新补跑任务表结束--*/

					//orderChangeSuccesswithTX(tblOrder, orderDetail, runTime, tblOrderExtend1, orderCheck, orderHistory);
					payService.orderChangeSuccessWithTX(tblOrder, orderDetail, runTime, tblOrderExtend1, orderCheck, orderHistory);
					//返回支付成功，推送O2O订单 start
					if(Contants.ORDER_STATUS_CODE_HAS_ORDERS.equals(cur_status_id)){//返回支付成功
						if(tblOrder!=null){
							dealO2OOrderService.dealO2OOrdersAfterPaySucc(tblOrder.getOrderId(), tblOrder.getOrdermainId(), tblOrder.getVendorId());
						}else if(orderHistory !=null){
							dealO2OOrderService.dealO2OOrdersAfterPaySucc(orderHistory.getOrderId(), orderHistory.getOrdermainId(), orderHistory.getVendorId());
						}
					}
					//返回支付成功，推送O2O订单 end

					log.info("【订单状态修改】订单状态修改成功，订单号:" + orderId + "，订单状态：" + curStatusId);
					envolopeVo.setReturnCode("000000");
					envolopeVo.setReturnDes("订单状态修改成功");
				}
			} else {
				log.info("【查询该订单当前信息有误】找不到该订单，订单号:" + orderId);
				envolopeVo.setReturnCode("000013");
				envolopeVo.setReturnDes("找不到该订单");
			}
		}catch(Exception e){
			log.error("数据库更新异常，异常信息:" + e.getMessage());
			envolopeVo.setReturnCode("000009");
			envolopeVo.setReturnDes("系统异常");
		}
		return envolopeVo;
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
		info.setChannelID(sourceIdChangeToChannel(order.getSourceId()));  //渠道标识
		info.setMerId(order.getMerId());   //大商户号(商城商户号)
		info.setOrderId(order.getOrderId());   //订单号(小)
		String consumeTypeStr = "1";
		if(order.getVoucherNo()!=null&&!"".equals(order.getVoucherNo().trim())){
			consumeTypeStr = "2";
		}
		info.setConsumeType(consumeTypeStr);  //消费类型("0":纯积分(这里不存在)\"1":积分+现金\"2":积分+现金+优惠券)
		info.setCurrency("CNY");  //币种
		info.setTranDate(createDate);    //发起方日期(当前日期)
		info.setTranTiem(createTime);    //发起方时间(当前时间)
		info.setTradeSeqNo(jfRefundSerialno);   //发起方流水号
		info.setSendDate(DateHelper.date2string(order.getOrder_succ_time(), "yyyyMMdd")); // 原发起方日期
		info.setSendTime(DateHelper.date2string(order.getOrder_succ_time(), "HHmmss")); // 原发起方时间
		info.setSerialNo(order.getOrderIdHost());    //原发起方流水号
		info.setCardNo(order.getCardno());   //卡号
		info.setExpiryDate("0000");   //卡片有效期
		info.setPayMomey(BigDecimal.ZERO);  //现金支付金额(默认送0)
		info.setJgId(Contants.JGID_COMMON);  //积分类型
		info.setDecrementAmt(order.getBonusTotalvalue());  //扣减积分额
		info.setTerminalNo("01");    //终端号("01"广发商城，"02"积分商城)
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
	 * //更新订单表，修改库存，记录订单状态
	 * @param tblOrder
	 * @param itemModel
	 * @param orderDetail
	 * @param tblOrderExtend1
	 * @param orderCheck
	 * @param orderHistory
	 */
	// 2017/1/4 谢文亮 将这段代码放进事务管理
//	public void orderChangewithTX(OrderSubModel tblOrder, ItemModel itemModel, OrderDoDetailModel orderDetail,TblOrderExtend1Model tblOrderExtend1,OrderCheckModel orderCheck,TblOrderHistoryModel orderHistory) {
//		log.info("into orderChangewithTX");
//		if(null!=tblOrder && null!=orderDetail && null!=tblOrderExtend1){
//			orderService.insertOrderDoDetail(orderDetail);
//
//			//更新库存 （按新业务更新：普通商品回滚库存，活动商品只有荷兰拍回滚）
//			if (null == tblOrder.getActId() || "".equals(tblOrder.getActId())){
//				itemModel.setStock(itemModel.getStock()+1L); // 库存+1
//				itemService.update(itemModel);
//			}else {
//				// 判断活动，荷兰拍回滚，其他活动不回滚。。。
//				if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(tblOrder.getActType())){
//					String promId = tblOrder.getActId();// 活动id
//					String periodId = String.valueOf(tblOrder.getPeriodId());
//					String itemCode = tblOrder.getGoodsId(); //单品号
//					String buyCount = "-" + String.valueOf(tblOrder.getGoodsNum()); //回滚库存，减销量，所以传负数
//					User user = new User();
//					user.setId(tblOrder.getCreateOper());
//					mallPromotionService.updatePromSaleInfo(promId, periodId, itemCode, buyCount, user);
//				}
//			}
//
//			if(null != tblOrder.getBonusTotalvalue() && tblOrder.getBonusTotalvalue()!=0){ //回滚积分池
//				Map<String,Object> params = Maps.newHashMap();
//				params.put("used_point",tblOrder.getBonusTotalvalue());
//				params.put("cur_month",DateHelper.getyyyyMM());
//				pointsPoolService.dealPointPool(params);
//			}
//			orderService.updateStatues(tblOrder);  // 更新订单状态
//
//			orderService.updateTblOrderExtend1(tblOrderExtend1);
//		}
//		if(orderCheck!=null){
//			orderCancelService.saveOrderCheck(orderCheck);
//		}
//		if(orderHistory!=null){
//			orderService.updateTblOrderHistory(orderHistory);
//		}
//
//		if(tblOrder != null){
//			//荷兰式判断进行回滚
//			if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(tblOrder.getActType())){
//				AuctionRecordModel auctionRecordModel = new AuctionRecordModel();
//				auctionRecordModel.setId(Long.valueOf(tblOrder.getCustCartId()));
//				auctionRecordModel.setIsBacklock("0");
//				auctionRecordModel.setReleaseTime(new Date());
//				auctionRecordService.updateByIdAndBackLock(auctionRecordModel);
//			}
//		}
//		if(orderHistory != null){
//			//荷兰式判断进行回滚
//			if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderHistory.getActType())){
//				AuctionRecordModel auctionRecordModel = new AuctionRecordModel();
//				auctionRecordModel.setId(Long.valueOf(orderHistory.getCustCartId()));
//				auctionRecordModel.setIsBacklock("0");
//				auctionRecordModel.setReleaseTime(new Date());
//				auctionRecordService.updateByIdAndBackLock(auctionRecordModel);
//			}
//		}
//
//	}
	// 2017/1/4 谢文亮 将这段代码放进事务管理
//	public void orderChangeSuccesswithTX(OrderSubModel tblOrder, OrderDoDetailModel orderDetail, Map<String, String> runTime,TblOrderExtend1Model tblOrderExtend1,OrderCheckModel orderCheck,TblOrderHistoryModel orderHistory) {
//		log.info("into orderChangeSuccesswithTX");
//		if(tblOrder != null){//防止空指针异常
//			orderService.updateStatues(tblOrder);  // 更新订单状态
//		}
//
//		if(orderCheck!=null){
//			orderCancelService.saveOrderCheck(orderCheck);
//		}
//		orderService.insertOrderDoDetail(orderDetail);
//		log.info("runTime:"+runTime);
//		if(runTime != null && runTime.size() > 0){	// 如果有补跑时间，更新不跑表，没有则不更新
//			log.info("runTime.size:"+runTime.size());
//			// 更新batch表
//			orderCancelService.updateBatchStatus(runTime);
//		}
//		orderService.updateTblOrderExtend1(tblOrderExtend1);
//		if(orderHistory!=null){
//			orderService.updateTblOrderHistory(orderHistory);
//		}
//	}

}
