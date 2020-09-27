package cn.com.cgbchina.restful.provider.service.order;

import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.dom4j.Document;
import org.dom4j.Element;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefund;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefundReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderCancelOrRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderCancelOrRefundVO;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.Orderluck;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.model.OrderCancelModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderCancelService;
import cn.com.cgbchina.trade.service.OrderCheckService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.web.utils.Tools;

import com.spirit.common.model.Response;

/**
 * MAL107 CC积分商城订单撤单和退货 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL107")
@Slf4j
public class CCIntergralOrderCancelOrRefundProvideServiceImpl implements  SoapProvideService <CCIntergralOrderCancelOrRefundVO,CCIntergralOrderCancelOrRefundReturnVO>{
	@Resource
	OrderService orderService;
	@Resource
	GoodsService goodsService;
	@Resource
	ItemService itemService;
	@Resource
	OrderCheckService orderCheckService;
	@Resource
	OrderCancelService orderCancelService;
	@Resource
	PaymentService paymentService;
	@Value("#{app.hongliCardChange}")
	private String feeGoodsId;
	@Value("#{app.nianfeiChange}")
	private String signGoodsId;
	@Value("#{app.sevenDay}")
	private String sevenDays;
	@Override
	public CCIntergralOrderCancelOrRefundReturnVO process(SoapModel<CCIntergralOrderCancelOrRefundVO> model, CCIntergralOrderCancelOrRefundVO content) {
		CCIntergralOrderCancelOrRefund cCIntergralOrderCancelOrRefund = BeanUtils.copy(content, CCIntergralOrderCancelOrRefund.class);
		CCIntergralOrderCancelOrRefundReturn cCIntergralOrderCancelOrRefundReturn = new CCIntergralOrderCancelOrRefundReturn();
		CCIntergralOrderCancelOrRefundReturnVO cCIntergralOrderCancelOrRefundReturnVO = BeanUtils.copy(cCIntergralOrderCancelOrRefundReturn,
				CCIntergralOrderCancelOrRefundReturnVO.class);
		String curDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
		String curTime = new SimpleDateFormat("HHmmss").format(new Date());
//		String ns = document.getRootElement().getNamespacePrefix();
//		String senderSN = GatewayEnvelopeUtil.getSenderSN(document);

		String orderMainId = cCIntergralOrderCancelOrRefund.getOrderMainId();
		String orderId = cCIntergralOrderCancelOrRefund.getOrderId();
		/*
		 * "01：撤销
			02：退货"
		 */
		String intType = cCIntergralOrderCancelOrRefund.getIntType();
		//原因
		String doDesc = cCIntergralOrderCancelOrRefund.getDoDesc();
		//客户留言
		String cust_message = cCIntergralOrderCancelOrRefund.getCustMessage();
		String origin =  cCIntergralOrderCancelOrRefund.getOrigin();//GatewayEnvelopeUtil.getNoAS400BodyField(document, "origin",ns,"gateway");//发起方 add by APP需求 20151020
		// add by APP需求 20151020
		String channelSN = "CCAG";
		String sourceNm = "Call Center";
		if("09".equals(origin)){  //SOURCE_ID_APP 09:APP渠道
			channelSN = "MH";//信用卡移动门户
			sourceNm = "APP";  //SOURCE_NM_APP="APP";
		}
		//APP渠道 中文需要用UTF-8转码
		/*
		 * 如果请求来自APP渠道返回失败报文。
		 */
		if ("09".equals(origin)) {//09:APP渠道
			try {
				if (!Tools.isEmpty(doDesc)) {
					doDesc = URLDecoder.decode(doDesc,"UTF-8");
				}
				if (!Tools.isEmpty(cust_message)) {
					cust_message = URLDecoder.decode(cust_message,"UTF-8");
				}
			} catch (Exception e) {
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000009");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("系统异常");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}
		}

		//mod by APP需求 20151020-- 03：取消订单 ,04：删除订单,05：催货
		/*
		 * intType:01：撤销 02：退货
		 */
		 //如果（业务类型 not in(01\02\03\04\05）或者（大订单号为空或大订单号错误或小订单号为空或小订单号错误）
		if(((!"01".equals(intType))
				&&(!"02".equals(intType))
				&&(!"03".equals(intType))
				&&(!"04".equals(intType))
				&&(!"05".equals(intType)))
				||orderMainId==null||orderMainId.length()!=16||orderId==null||orderId.length()!=18){
			//开始组装CC-订单撤销和退货报文体内容- MAL107
			cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
			cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000008");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("报文参数错误");
			return cCIntergralOrderCancelOrRefundReturnVO;
		}

		//intType=“03”（取消订单），只支持积分商城取消订单，只有待付款的订单才能取消，待付款的订单取消后变为已废单，如果是生日价则回滚生日价,APP一期不实现此功能
		//如果请求是“取消订单” -APP渠道
		if("03".equals(intType)){//APP一期不实现"取消订单"功能
			//返回失败报文。
			cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
			cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000100");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("暂不支持此功能");
			return cCIntergralOrderCancelOrRefundReturnVO;
		}
		//String hql = "from TblOrder where ordermainId=? and orderId=?";
		//根据订单号查询小订单
		OrderSubModel tblOrder = orderService.findOrderId(orderId);
		//TblOrderCancel 取消订单表
		OrderCancelModel tblOrderCancel = new OrderCancelModel();
		//如果找不到订单，返回错误信息
		if(tblOrder==null){
			cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
			cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000013");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("找不到订单");
			return cCIntergralOrderCancelOrRefundReturnVO;
		}
		//下单时间
		SimpleDateFormat sdf_ = new SimpleDateFormat("YYYYMMddHHmmss");
		String createDate = sdf_.format( tblOrder.getCreateTime());
		int year1 = Integer.parseInt(createDate.substring(0, 4));
		int month1 = Integer.parseInt(createDate.substring(4, 6));
		int date1 = Integer.parseInt(createDate.substring(6, 8));

		//当前系统操作时间
		String operateDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
		int year2 = Integer.parseInt(operateDate.substring(0, 4));
		int month2 = Integer.parseInt(operateDate.substring(4, 6));
		int date2 = Integer.parseInt(operateDate.substring(6, 8));
		Calendar cal1 = Calendar.getInstance();
		cal1.set(year1, month1-1, date1);
		int day1 = cal1.get(cal1.DAY_OF_YEAR);//下单
		cal1.set(year2, month2-1, date2);
		int day2 = cal1.get(cal1.DAY_OF_YEAR);//操作时间
		cal1.set(year1, 11, 31);
		int day3 = cal1.get(cal1.DAY_OF_YEAR);//获取下单那年的天数
		int day =0;
		if(year2 - year1 == 1){
			day = day2 + (day3 - day1);
		}else{
			day = day2 - day1;
		}
		//如果该订单下单超过了180天
		if(year2-year1>1 || day> 180 || year2-year1<0){
			cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
			cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000026");
			cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("超过180天不能撤单、退货、删除订单、催货");
			return cCIntergralOrderCancelOrRefundReturnVO;
		}
		//取得小订单中的商品ID
		String goodsId = tblOrder.getGoodsId();
		//通过商品编码获得该商品的对象goodsInf
		ItemModel itemModel = itemService.findById(goodsId);
		Response<GoodsModel> goodsInfResponse = goodsService.findById(tblOrder.getGoodsCode());
		GoodsModel goodsInf = null;
		if(goodsInfResponse != null ){
			goodsInf = goodsInfResponse.getResult();
		}
		// donghb 0905 start
//		goodsService.findById(tblOrder.getGoodsCode()).getResult();
		// donghb 0905 end
		//如果（商品为虚拟礼品 &&请求的类型是撤销或退货）
		if(goodsInf!=null && "01".equals(goodsInf.getGoodsType()) && ("01".equals(intType)||"02".equals(intType))){//虚拟礼品
			//如果是退货，返回失败报文。虚拟礼品不支持退货
			if("02".equals(intType)){//判断1:虚拟礼品不支持退货
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000063");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("虚拟礼品不支持退货");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}
			/**
			 * 年费免签额：【用积分兑换免年费】，这是一种虚拟商品。
			 */
			//判断2：撤单、退货校验【年费签帐额只支持当天18：00前撤单】
			//hongli.card.change#红利卡兑换免签帐额调整
			//nianfei.change#年费调整
			// donghb 0905 start
			if(feeGoodsId.indexOf(itemModel.getXid())!=-1||signGoodsId.indexOf(itemModel.getXid())!=-1){
				// donghb 0905 end
				if(!tblOrder.getCreateTime().equals(curDate)){//不是当天下单
					cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
					cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000064");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("不是当天下单");
					return cCIntergralOrderCancelOrRefundReturnVO;
				}
				if(Integer.parseInt(curTime)>180000){//不是当天18:00之前
					cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
					cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000064");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("年费、签帐额只支持当天18:00之前撤单");
					return cCIntergralOrderCancelOrRefundReturnVO;
				}
			}
			//判断3:校验【所有虚拟礼品在出报表之前才能进行撤单（出报表时间是每周六的晚上24：00）】
			if(!judgeTime(sdf_.format(tblOrder.getCreateTime()))){
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000065");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("虚拟礼品只能在出报表之前才能撤单");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}
			/*年费签帐额撤单调用支付网关的接口*/
			// donghb 0905 start
//			String feeGoodsId = SystemProperties.getProperty("hongli.card.change");//需要配置年费签帐额
//			String signGoodsId = SystemProperties.getProperty("nianfei.change");
			// donghb 0905 end
			//年费签帐额
			if(feeGoodsId.indexOf(itemModel.getXid())!=-1||signGoodsId.indexOf(itemModel.getXid())!=-1){
				Document netBankResDoc=null;
				String retCode = "";
				try {
					/*
					 * 调用NSCT004 订单撤销接口
					 */
					Orderluck orderluck = new Orderluck();
					orderluck.setOrderId(tblOrder.getOrderId());
					BaseResult baseResult = paymentService.luckPackReturn(orderluck);
					String errorCode = baseResult.getRetCode();
					String errorDesc = baseResult.getRetErrMsg();
					if(!"000000".equals(errorCode)){
						cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
						cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
						cCIntergralOrderCancelOrRefundReturnVO.setReturnCode(errorCode);
						cCIntergralOrderCancelOrRefundReturnVO.setReturnDes(errorDesc);
						return cCIntergralOrderCancelOrRefundReturnVO;
					}

				} catch (Exception e) {
					cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
					cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000069");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("找不到对应积分区间");
					return cCIntergralOrderCancelOrRefundReturnVO;
				}
				//支付网关返回不成功，发送失败报文,000068	支付网关拒绝撤单
				if(!"000000".equals(retCode)){
					cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
					cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000068");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("支付网关拒绝撤单");
					return cCIntergralOrderCancelOrRefundReturnVO;
				}
			}
			// donghb 0905 start
			/*7天联名卡虚拟礼品*/
//			String sevenDays = SystemProperties.getProperty("seven.day");
			// donghb 0905 end
			if(sevenDays.indexOf(itemModel.getXid())!=-1){
				try {
					// 根据【下单日期】判断是否7天礼品已出报表，如果是，发送报文-000065	虚拟礼品只能在出报表之前才能撤单
					if(isReport(sdf_.format(tblOrder.getCreateTime()))){
						cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
						cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
						cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000065");
						cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("虚拟礼品只能在出报表之前才能撤单");
						return cCIntergralOrderCancelOrRefundReturnVO;
					}
				} catch (ParseException e) {

				}
			}
		}
		//取得系统当前时间
		String currDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
		String currTime = new SimpleDateFormat("HHmmss").format(new Date());
		/*
		 * 如果请求是撤销
		 */
		if("01".equals(intType)){//撤销
			//如果订单状态 是0308-支付成功
			if("0308".equals(tblOrder.getCurStatusId())){
				//设置订单状态-0312 已撤单
				tblOrder.setCurStatusId("0312");
				tblOrder.setCurStatusNm("已撤单");
				tblOrder.setModifyTime(new Date());//当前系统时间
				tblOrder.setModifyOper(sourceNm);
				//更新订单状态为“已撤单”。
				orderCheckService.updateOrder(tblOrder);
				//tblOrderCancel 取消订单表
				tblOrderCancel.setOrderId(orderId); //子订单号
				tblOrderCancel.setCancelCheckStatus("0");
				tblOrderCancel.setCurStatusId("0312"); //当前状态 0312 已撤单
				tblOrderCancel.setCancelTime(new Date());
				//保存到取消订单表信息，保存状态为已撤单。
				orderCheckService.insertOrderCancel(tblOrderCancel);
				//新建订单处理历史明细表，设置参数后保存。
				OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
				tblOrderDodetail.setOrderId(tblOrder.getOrderId());
				tblOrderDodetail.setDoTime(new Date());
				tblOrderDodetail.setDoUserid(sourceNm);
				tblOrderDodetail.setUserType("1");
				tblOrderDodetail.setStatusId(tblOrder.getCurStatusId());
				tblOrderDodetail.setStatusNm(tblOrder.getCurStatusNm());
				tblOrderDodetail.setDoDesc(doDesc==null?"":doDesc);
				tblOrderDodetail.setMsgContent(cust_message==null?"":cust_message);//该字段作为客户留言
				tblOrderDodetail.setCreateOper(sourceNm);
				tblOrderDodetail.setDelFlag(new Integer("0"));
				tblOrderDodetail.setCreateTime(new Date());
				orderCheckService.insertOrderDoDetail(tblOrderDodetail);
			}else{
				//发送失败报文。
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000014");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("订单无法修改");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}
		}else if("02".equals(intType)){//请求是退货
			//只有是已经签收状态的订单才允许退货
			//如果小订单状态为【0310-已签收或0309-已发货或0335-拒绝退货申请】
			if("0310".equals(tblOrder.getCurStatusId())||
					"0309".equals(tblOrder.getCurStatusId())||
					"0335".equals(tblOrder.getCurStatusId())){
				//设置小订单状态 0334 -退货申请
				tblOrder.setCurStatusId("0334");
				tblOrder.setCurStatusNm("退货申请");
				tblOrder.setModifyTime(new Date());
				tblOrder.setModifyOper(sourceNm);
				tblOrder.setSpecShopnoType("0");//退货流转标志 0:流转到合作商 1:流转到商城后台
				//保存订单。
				orderCheckService.updateOrder(tblOrder);
				OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
				tblOrderDodetail.setOrderId(tblOrder.getOrderId());
				tblOrderDodetail.setDoTime(new Date());
				tblOrderDodetail.setDoUserid(sourceNm);
				tblOrderDodetail.setUserType("1");
				tblOrderDodetail.setStatusId(tblOrder.getCurStatusId());
				tblOrderDodetail.setStatusNm(tblOrder.getCurStatusNm());
				tblOrderDodetail.setDoDesc(doDesc==null?"":doDesc);
				tblOrderDodetail.setMsgContent(cust_message==null?"":cust_message);//该字段作为客户留言
				tblOrderDodetail.setCreateOper(sourceNm);
				tblOrderDodetail.setDelFlag(new Integer("0"));
				tblOrderDodetail.setCreateTime(new Date());
				//保存订单历史表
				orderCheckService.insertOrderDoDetail(tblOrderDodetail);
			}else{
				//发送失败报文-000014
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000014");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("订单无法修改");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}
		}else if("04".equals(intType)){//04：删除订单 --add by APP需求 20151020
			//只有是已废单(0304)、待付款(0301)、支付失败(0307)、已签收(0310)的订单可以进行删除
			if("0304".equals(tblOrder.getCurStatusId())
					||"0301".equals(tblOrder.getCurStatusId())
					||"0307".equals(tblOrder.getCurStatusId())
					||"0310".equals(tblOrder.getCurStatusId())){
				int cnt = 0;//tblOrderBySqlDao.deleteOrder(orderId, sourceNm,currDate,currTime);
				OrderSubModel orderModel2Update = orderService.findOrderId(orderId);
				if("0304".equals(orderModel2Update.getCurStatusId())
						|| "0301".equals(orderModel2Update.getCurStatusId())
						||"0307".equals(orderModel2Update.getCurStatusId())
						||"0310".equals(orderModel2Update.getCurStatusId())){
					orderModel2Update.setModifyOper(sourceNm);
					orderModel2Update.setDelFlag("1");
					orderModel2Update.setModifyTime(new Date());
					cnt = orderCheckService.updateOrder(orderModel2Update);
				}
				//如果删除订单失败，发送失败报文
				if(cnt<1){
					cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
					cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000014");
					cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("订单无法修改");
					return cCIntergralOrderCancelOrRefundReturnVO;
				}
				//保存订单处理历史表，操作订单状态为已删除。
				OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
				tblOrderDodetail.setOrderId(tblOrder.getOrderId());
				tblOrderDodetail.setDoTime(new Date());
				tblOrderDodetail.setDoUserid(sourceNm);
				if("09".equals(origin)){
					tblOrderDodetail.setUserType("3");//3：持卡人
				}else{
					tblOrderDodetail.setUserType("1");//1：内部用户[CC]
				}
				tblOrderDodetail.setStatusId("0001");
				tblOrderDodetail.setStatusNm("已删除");
				tblOrderDodetail.setDoDesc(doDesc==null?"用户申请删除订单":doDesc);
				tblOrderDodetail.setMsgContent(cust_message==null?"":cust_message);//该字段作为客户留言
				tblOrderDodetail.setCreateOper(sourceNm);
				tblOrderDodetail.setDelFlag(new Integer("0"));
				tblOrderDodetail.setCreateTime(new Date());
				orderCheckService.insertOrderDoDetail(tblOrderDodetail);
			}else{
				//发送失败报文。
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000014");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("订单无法修改");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}

		}else if("05".equals(intType)){//05：催货--add by APP需求 20151020
			//订单状态是支付成功(0308)、发货处理中(0306)的订单才可以催货
			if("0308".equals(tblOrder.getCurStatusId())
					||"0306".equals(tblOrder.getCurStatusId())){
				orderService.updateOrderRemind(tblOrder.getOrderId(), tblOrder.getCreateOper());
			}else{
				cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
				cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("00");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000014");
				cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("订单无法修改");
				return cCIntergralOrderCancelOrRefundReturnVO;
			}
		}
		//组装MAL107CC积分商城订单撤单和退货报文，发送成功处理结果。
		cCIntergralOrderCancelOrRefundReturnVO.setChannelSN(channelSN);
		cCIntergralOrderCancelOrRefundReturnVO.setSuccessCode("01");
		cCIntergralOrderCancelOrRefundReturnVO.setReturnCode("000000");
		cCIntergralOrderCancelOrRefundReturnVO.setReturnDes("正常");
		return cCIntergralOrderCancelOrRefundReturnVO;
	}

	/**
	 * 取得非AS400主机报文中 <soapenv:Body><gateway:NoAS400><gateway:field
	 * name='******'>的属性值
	 *
	 * @param document
	 * @param name
	 * @return
	 */
	public static String getNoAS400BodyField(Document document, String name,
											 String ns1, String ns2) {

		Element bodyElement = (Element) document.selectSingleNode("//" + ns1
				+ ":Envelope/" + ns1 + ":Body/" + ns2 + ":NoAS400");
		Element fieldNamElement = (Element) bodyElement.selectSingleNode("//"
				+ ns2 + ":field[@name='" + name + "']");

		// return fieldNamElement==null?null:fieldNamElement.getStringValue();
		if (fieldNamElement == null)
			return null;

		return fieldNamElement.getStringValue() == null ? null
				: fieldNamElement.getStringValue().trim();

	}
	/**
	 * 判断下单时间跟当前时间是否在同一周
	 * @param orderDate 下单日期
	 * @return
	 */
	private boolean judgeTime(String orderDate){
		Calendar cal = Calendar.getInstance();
		int year = Integer.parseInt(orderDate.substring(0, 4));//年
		int month = Integer.parseInt(orderDate.substring(4, 6));//月
		int date = Integer.parseInt(orderDate.substring(6, 8));//日
		cal.clear();
		cal.set(year, month-1, date);
		int orderweek = cal.get(cal.WEEK_OF_YEAR);//下单时间在这一年的第几周
		cal.clear();
		String curDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
		year = Integer.parseInt(curDate.substring(0, 4));
		month = Integer.parseInt(curDate.substring(4, 6));
		date = Integer.parseInt(curDate.substring(6, 8));
		cal.set(year, month-1, date);
		int curweek = cal.get(cal.WEEK_OF_YEAR);//当前时间是这一年的第几周
		if(orderweek != curweek){
			return false;
		}
		return true;
	}

	/**
	 * 判断是否7天礼品已出报表
	 * @return
	 * @throws ParseException
	 */
	private boolean isReport(String orderDate) throws ParseException{

		Calendar cal = Calendar.getInstance();
		SimpleDateFormat  format = new SimpleDateFormat("yyyyMMdd");
		cal.setTimeInMillis(System.currentTimeMillis());
		int curDay = cal.get(cal.DAY_OF_WEEK);//当天是本周第几天
		cal.set(Calendar.DAY_OF_WEEK, Calendar.TUESDAY);
		String d2 = format.format(cal.getTime());//本周二
		cal.add(Calendar.DATE, -7);//一周前设置
		cal.set(Calendar.DAY_OF_WEEK, Calendar.WEDNESDAY);
		String d1 = format.format(cal.getTime());//上周三
		Date d = new SimpleDateFormat("yyyyMMdd").parse(orderDate);//下单日期
		if(Integer.parseInt(orderDate)>=Integer.parseInt(d1)){
			if(curDay>3){//当前日期大于周二
				if(Integer.parseInt(orderDate)>=Integer.parseInt(d1)&&Integer.parseInt(orderDate)<=Integer.parseInt(d2)){//下单日期大于等于上周三小于等于本周二
					return true;
				}
			}
		}else{
			return true;
		}
		return false;
	}


}
