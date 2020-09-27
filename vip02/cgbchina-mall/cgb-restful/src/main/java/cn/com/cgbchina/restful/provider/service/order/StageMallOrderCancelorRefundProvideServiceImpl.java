package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import com.alibaba.dubbo.common.utils.StringUtils;
import org.springframework.stereotype.Service;

import com.spirit.common.model.Response;

import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefund;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefundReturn;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderCancelorRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderCancelorRefundVO;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.OrderCheckService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.SmsMessageService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL110 订单撤销退货(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL110")
@Slf4j
public class StageMallOrderCancelorRefundProvideServiceImpl implements  SoapProvideService <StageMallOrderCancelorRefundVO,StageMallOrderCancelorRefundReturnVO>{
	@Resource
	OrderCheckService orderCheckService;
    @Resource
    OrderService orderService;
    @Resource
    VendorService vendorService;
    @Resource
    GoodsPayWayService goodsPayWayService;
	@Resource
	PaymentService paymentService;
	@Resource
	SmsMessageService smsMessageService;
	@Override
	public StageMallOrderCancelorRefundReturnVO process(SoapModel<StageMallOrderCancelorRefundVO> model, StageMallOrderCancelorRefundVO content) {
		StageMallOrderCancelorRefund stageMallOrderCancelorRefund = BeanUtils.copy(content, StageMallOrderCancelorRefund.class);
		StageMallOrderCancelorRefundReturnVO stageMallOrderCancelorRefundReturnVO = new StageMallOrderCancelorRefundReturnVO();

		SimpleDateFormat sdf_nyr = new SimpleDateFormat("YYYYMMdd");
		SimpleDateFormat sdf_sfm = new SimpleDateFormat("HHmmss");


		try{
			String origin = stageMallOrderCancelorRefund.getOrigin();	//调用方标识
			String orderMainId = stageMallOrderCancelorRefund.getOrderMainId();
			String orderId = stageMallOrderCancelorRefund.getOrderId();
			String intType = stageMallOrderCancelorRefund.getIntType();	//操作类型【1-撤单，2-退货】
			String doDesc = stageMallOrderCancelorRefund.getDoDesc();	//撤单/退货原因
			String person_flag = stageMallOrderCancelorRefund.getPersonFlag();	//人为标识 0是人为，1为非人为
		/*报表生成方式通过IO表createReport字段控制，状态保存于tbl_order表EXT_3扩展属性字段中(01-生成报表, 02-不生成报表)*/
			String createReport = stageMallOrderCancelorRefund.getCreateReport();//是否生成报表

//		验证订单是否属于正常状态下
			Object object =  orderCheckService.getTblOrderById(orderId, "0");
			OrderDoDetailModel orderDodetail = null;	//插入doDeatil表
			OrderSubModel tblOrder = null;
			TblOrderHistoryModel orderHistory = null;
			OrderBackupModel orderBackup = null;
			if(object!=null){
				if(object instanceof OrderSubModel){
					tblOrder = (OrderSubModel)object;
				}else if(object instanceof TblOrderHistoryModel){
					orderHistory = (TblOrderHistoryModel)object;
				}
				orderDodetail = new OrderDoDetailModel();
			}else{
				object = orderCheckService.getTblOrderById(orderId,"1");
				if(object instanceof OrderBackupModel) orderBackup = (OrderBackupModel)object;
				if(orderBackup == null){
					stageMallOrderCancelorRefundReturnVO.setReturnCode("000013");
					stageMallOrderCancelorRefundReturnVO.setReturnDes("找不到该订单");
					return stageMallOrderCancelorRefundReturnVO;
				}else{
					//如果从备份表中取出数据，则提示用户数据超过两年不能操作
					stageMallOrderCancelorRefundReturnVO.setReturnCode("000071");
					stageMallOrderCancelorRefundReturnVO.setReturnDes("数据超过两年，不可操作！");
					return stageMallOrderCancelorRefundReturnVO;
				}
			}

			//modify by ps
			String curStatusId = "";
			String ordertypeId = "";
			String createDate = "";
			if(tblOrder!=null){
				curStatusId = tblOrder.getCurStatusId();
				ordertypeId = tblOrder.getOrdertypeId();
				createDate = sdf_nyr.format(tblOrder.getCreateTime());
			}else if(orderHistory != null){
				curStatusId = orderHistory.getCurStatusId();
				ordertypeId = orderHistory.getOrdertypeId();
				createDate = sdf_nyr.format(tblOrder.getCreateTime());
			}

			//验证订单当前状态和是否生成表报标识是否匹配可用  支付成功订单才能生成表报   处理中订单不需要生成报表
			if("01".equals(intType) && "0308".equals(curStatusId)&&"02".equals(createReport)){//如果是撤单并且是支付成功并且传来参数是不生成报表
				stageMallOrderCancelorRefundReturnVO.setReturnCode("000055");
				stageMallOrderCancelorRefundReturnVO.setReturnDes("支付成功订单需要生成报表");
				return stageMallOrderCancelorRefundReturnVO;
			}else if("01".equals(intType) && "0305".equals(curStatusId)&&"01".equals(createReport)){//如果是撤单并且是处理中并且传来参数是生成报表
				stageMallOrderCancelorRefundReturnVO.setReturnCode("000054");
				stageMallOrderCancelorRefundReturnVO.setReturnDes("处理中订单不能生成报表");
				return stageMallOrderCancelorRefundReturnVO;
			}else if("01".equals(intType) &&(createReport==null||"".equals(createReport.trim()))){
				stageMallOrderCancelorRefundReturnVO.setReturnCode("000008");
				stageMallOrderCancelorRefundReturnVO.setReturnDes("报文参数错误");
				return stageMallOrderCancelorRefundReturnVO;
			}

			//撤销
			if("01".equals(intType)){
				//CC调用
				if("01".equals(origin)){
					//判断订单状态
					if(!"0308".equals(curStatusId)
							&& !"0305".equals(curStatusId)){//如果不是支付成功和处理中状态
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000052");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("订单状态异常,当前订单状态编码:"+ curStatusId);
						return stageMallOrderCancelorRefundReturnVO;
					}else if("0305".equals(curStatusId)){//如果是处理中
						orderDodetail.setDoTime(new Date());
						orderDodetail.setOrderId(orderId);
						orderDodetail.setStatusId("0312");
						orderDodetail.setStatusNm("已撤单");
						orderDodetail.setDoDesc((doDesc != null && !"".equals(doDesc)) ? doDesc : "CC订单撤单");
						orderDodetail.setDoUserid("Call Center");
						orderDodetail.setUserType("1");
						orderDodetail.setCreateOper("Call Center");
						orderDodetail.setDelFlag(new Integer("0"));
						orderDodetail.setCreateTime(new Date());
						if(tblOrder!=null){
							tblOrder.setCurStatusId("0312");
							tblOrder.setCurStatusNm("已撤单");
//							tblOrder.setModifyDate(DateUtil.getyyyyMMdd());
							tblOrder.setModifyTime(new Date());
							tblOrder.setVendorOperFlag("0");
							tblOrder.setModifyOper("Call Center");
							tblOrder.setExt1(person_flag);//人为标识
							tblOrder.setExt3(createReport);//创建表报标识
						}else if(orderHistory!=null){
							orderHistory.setCurStatusId("0312");
							orderHistory.setCurStatusNm("已撤单");
							orderHistory.setModifyTime(new Date());
							orderHistory.setVendorOperFlag("0");
							orderHistory.setModifyOper("Call Center");
							orderHistory.setExt1(person_flag);//人为标识
							orderHistory.setExt3(createReport);//创建表报标识
						}

						OrderCheckModel orderCheck = getObject(tblOrder,orderHistory);

						if(!judgeDays(createDate, 180)){
							orderCheck = null;
						}

						orderCheckService.orderReturnwithTX(tblOrder,orderDodetail,orderCheck,orderHistory);
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000000");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("撤销成功");
						return stageMallOrderCancelorRefundReturnVO;
					}else{//如果支付成功
//						List roleList = new ArrayList();//tblOrderDao.orderTypeQuery(orderId);//判断是VMI订单方法
                        OrderSubModel orderMoedel = orderService.findOrderId(orderId);
//                        Response<VendorInfoDto>  vResp =  vendorService.findById(orderMoedel.getVendorId());
//                        if(vResp != null){
//                            roleList.add(vResp.getResult().getVendorRole());
//                        }

						String vendorRole = "";
//						if(vendorRole!=null&&roleList.size()>0){
//							vendorRole = String.valueOf(roleList.get(0));
//						}
//						if("0".equals(vendorRole)){//VMI订单：先将订单状态改为撤单申请中
//							orderDodetail.setDoTime(new Date());
//							orderDodetail.setOrderId(orderId);
//							orderDodetail.setStatusId("0313");
//							orderDodetail.setStatusNm("撤单中");
//							orderDodetail.setDoDesc((doDesc != null && !"".equals(doDesc)) ? doDesc : "CC订单撤单申请");
//							orderDodetail.setDoUserid("Call Center");
//							orderDodetail.setUserType("1");
//							orderDodetail.setCreateOper("Call Center");
//							orderDodetail.setDelFlag(new Integer("0"));
//							orderDodetail.setCreateTime(new Date());
//							if(tblOrder!=null){
//								tblOrder.setCurStatusId("0313");
//								tblOrder.setCurStatusNm("撤单中");
//								tblOrder.setModifyTime(new Date());
//								tblOrder.setVendorOperFlag("0");
//								tblOrder.setModifyOper("Call Center");
//								tblOrder.setExt1(person_flag);//人为标识
//								tblOrder.setExt3(createReport);
//							}else if(orderHistory!=null){
//								orderHistory.setCurStatusId("0313");
//								orderHistory.setCurStatusNm("撤单中");
//								orderHistory.setModifyTime(new Date());
//								orderHistory.setVendorOperFlag("0");
//								orderHistory.setModifyOper("Call Center");
//								orderHistory.setExt1(person_flag);//人为标识
//								orderHistory.setExt3(createReport);
//							}
//
//							orderCheckService.orderReturnwithTX(tblOrder,orderDodetail,null,orderHistory);
//
//
//                            stageMallOrderCancelorRefundReturnVO.setReturnCode("000057");
//                            stageMallOrderCancelorRefundReturnVO.setReturnDes("撤单申请中");
////                            return stageMallOrderCancelorRefundReturnVO;
//                            OrderCheckModel orderCheck = getObject(tblOrder,orderHistory);
//							if(judgeDays(createDate, 180)){
//								orderCheck = null;
//							}
//							orderCheckService.orderReturnwithTX(null, null, orderCheck, orderHistory);
//							return stageMallOrderCancelorRefundReturnVO;
//						}
						orderDodetail.setDoTime(new Date());
						orderDodetail.setOrderId(orderId);
						orderDodetail.setStatusId("0312");
						orderDodetail.setStatusNm("已撤单");
						orderDodetail.setDoDesc((doDesc != null && !"".equals(doDesc)) ? doDesc : "CC订单撤单");
						orderDodetail.setDoUserid("Call Center");
						orderDodetail.setUserType("1");
						orderDodetail.setCreateOper("Call Center");
						orderDodetail.setDelFlag(new Integer("0"));
						orderDodetail.setCreateTime(new Date());
						if(tblOrder!=null){
							tblOrder.setCurStatusId("0312");
							tblOrder.setCurStatusNm("已撤单");
							tblOrder.setModifyTime(new Date());
							tblOrder.setVendorOperFlag("0");
							tblOrder.setModifyOper("Call Center");
							tblOrder.setExt1(person_flag);//人为标识
							tblOrder.setExt3(createReport);
						}else if(orderHistory!=null){
							orderHistory.setCurStatusId("0312");
							orderHistory.setCurStatusNm("已撤单");
							orderHistory.setModifyTime(new Date());
							orderHistory.setVendorOperFlag("0");
							orderHistory.setModifyOper("Call Center");
							orderHistory.setExt1(person_flag);//人为标识
							orderHistory.setExt3(createReport);
						}
                        OrderCheckModel orderCheck = getObject(tblOrder,orderHistory);
						if(!judgeDays(createDate, 180)){
							orderCheck = null;
						}
						orderCheckService.orderReturnwithTX(tblOrder,orderDodetail,orderCheck,orderHistory);


						if(ordertypeId!=null && ordertypeId.trim().equals("FQ")){
//					 商品名称
							String goods_nm = "";
							// 实际付款金额
							String total_Money = "";
							// 电话号码
							String cont_mob_phone ="";
							// 商品金额
							String goods_price="";
							Map set = new HashMap();
//							Map set =  tblOrderDao.getTblOrderRs(orderId);
                            OrderSubModel orderModel = orderService.findOrderId(orderId);
                            if(orderModel != null){
								TblOrderExtend1Model tblOrderExtend1Model = orderCheckService.findExtend1ByOrderId(orderModel.getOrderId());
								set.put("tblOrderExtend1Model",tblOrderExtend1Model);
								set.put("orderModel",orderModel);
                                Response<OrderMainModel> orderMainResponse = orderService.findOrderMainById(orderModel.getOrdermainId());
                                if(orderMainResponse != null){
                                    OrderMainModel orderMain = orderMainResponse.getResult();
									set.put("orderMain",orderMain);
									goods_nm = orderModel.getGoodsNm();
                                    if(orderModel.getTotalMoney() != null){
                                        total_Money = orderModel.getTotalMoney().toString();
                                    }else{
                                        total_Money = "0";
                                    }
                                    cont_mob_phone = orderMain.getContMobPhone();
                                }
								Response<TblGoodsPaywayModel> rep = goodsPayWayService.findGoodsPayWayInfo(orderModel.getGoodsPaywayId());
								if(rep != null){
									TblGoodsPaywayModel tblGoodsPaywayModel = rep.getResult();
									set.put("tblGoodsPaywayModel",tblGoodsPaywayModel);
									if(tblGoodsPaywayModel.getGoodsPrice() != null){
										goods_price=tblGoodsPaywayModel.getGoodsPrice().toString();
									}else{
										goods_price = "0";
									}
								}
                            }

							//订单表（TBL_ORDER）现金金额（TOTAL_MONEY）为0,并且走新流程 时不调用支付的接口（NSCT018/NSCT008）进行订单调整--大机补充需求 mod by dengbing start
							boolean isPractiseRun = isPractiseRun(orderModel.getCardno());
							String code ="";
							String msg = "";
							BigDecimal totalMoney = null ;
							int compareResut = -1;
							if(total_Money != null && !"".equals(total_Money)){
								totalMoney = new BigDecimal(total_Money);
								compareResut = totalMoney.compareTo(BigDecimal.ZERO);
							}
							if(compareResut==0 && isPractiseRun){
								code ="000000";
								msg = "";
							}else{
								List retList  = sendPay(orderId,set);
								Map map = new HashMap();
								if(retList.size()!=0){
									map = (Map) retList.get(0);
									code = (String) map.get("retCode");
									msg = (String) map.get("retErrMsg");
								}
							}
							//mod by dengbing end

							// 发送报文到支付超时
							if(code.equals("9999")){
								orderCheckService.insertOutSystem(orderMainId, orderId);
							}
							// 成功则发送短信给客户
							if(code.equals("000000")){
//						SMSMessage message = new SMSMessage();
//						message.sendMsg(goods_nm,goods_price, total_Money, cont_mob_phone);
								if(cont_mob_phone!=null &&!cont_mob_phone.trim().equals("")){
//									SendMobileMsg send=(SendMobileMsg)SpringUtil.getBean("MSG072FH00013");
									Map mobileMap = new HashMap();
									mobileMap.put("mobilephone", cont_mob_phone);
									mobileMap.put("product", goods_nm);
									mobileMap.put("account", goods_price);
									mobileMap.put("reaccount", total_Money);
//									Map returnMap =  send.sendMsg(mobileMap);
									Map returnMap = smsMessageService.sendMsg(mobileMap).getResult();
									if(returnMap!=null){
										String reMsg  = (String) returnMap.get("msg");
									}
								}
							}
						}
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000000");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("撤销成功");
						return stageMallOrderCancelorRefundReturnVO;
					}
				}
				//BPS调用
				if("11".equals(origin)){
					if(!"0308".equals(curStatusId)
							&& !"0305".equals(curStatusId)){
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000052");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("订单状态异常,当前订单状态编码:"+ curStatusId);
						return stageMallOrderCancelorRefundReturnVO;
					}else{
						orderDodetail.setDoTime(new Date());
						orderDodetail.setOrderId(orderId);
						orderDodetail.setStatusId("0312");
						orderDodetail.setStatusNm("已撤单");
						orderDodetail.setDoUserid("BPS");
						orderDodetail.setDoDesc((doDesc != null && !"".equals(doDesc)) ? doDesc : "BPS订单撤单");
						orderDodetail.setUserType("0");
						orderDodetail.setCreateOper("Call Center");
						orderDodetail.setDelFlag(new Integer("0"));
						orderDodetail.setCreateTime(new Date());
						if(tblOrder!=null){
							tblOrder.setCurStatusId("0312");
							tblOrder.setCurStatusNm("已撤单");
							tblOrder.setModifyTime(new Date());
							tblOrder.setModifyOper("BPS");
							tblOrder.setVendorOperFlag("0");
							tblOrder.setExt1(person_flag);//人为标识
							tblOrder.setExt3(createReport);
						}else if(orderHistory!=null){
							orderHistory.setCurStatusId("0312");
							orderHistory.setCurStatusNm("已撤单");
							orderHistory.setModifyTime(new Date());
							orderHistory.setModifyOper("BPS");
							orderHistory.setVendorOperFlag("0");
							orderHistory.setExt1(person_flag);//人为标识
							orderHistory.setExt3(createReport);
						}
						OrderCheckModel orderCheck = getObject(tblOrder,orderHistory);
						if(!judgeDays(createDate, 180)){
							orderCheck = null;
						}
						orderCheckService.orderReturnwithTX(tblOrder,orderDodetail,orderCheck,orderHistory);

//					 	商品名称
						String goods_nm = "";
						// 实际付款金额
						String total_Money = "";
						// 电话号码
						String cont_mob_phone ="";
						// 商品金额
						String goods_price="";
//						Map set =  tblOrderDao.getTblOrderRs(orderId);
						Map set = new HashMap();
//							Map set =  tblOrderDao.getTblOrderRs(orderId);
						OrderSubModel orderModel = orderService.findOrderId(orderId);
						if(orderModel != null){
							TblOrderExtend1Model tblOrderExtend1Model = orderCheckService.findExtend1ByOrderId(orderModel.getOrderId());
							set.put("tblOrderExtend1Model",tblOrderExtend1Model);
							set.put("orderModel",orderModel);
							Response<OrderMainModel> orderMainResponse = orderService.findOrderMainById(orderModel.getOrdermainId());
							if(orderMainResponse != null){
								OrderMainModel orderMain = orderMainResponse.getResult();
								set.put("orderMain",orderMain);
								goods_nm = orderModel.getGoodsNm();
								if(orderModel.getTotalMoney() != null){
									total_Money = orderModel.getTotalMoney().toString();
								}else{
									total_Money = "0";
								}
								cont_mob_phone = orderMain.getContMobPhone();
							}
							Response<TblGoodsPaywayModel> rep = goodsPayWayService.findGoodsPayWayInfo(orderModel.getGoodsPaywayId());
							if(rep != null){
								TblGoodsPaywayModel tblGoodsPaywayModel = rep.getResult();
								set.put("tblGoodsPaywayModel",tblGoodsPaywayModel);
								if(tblGoodsPaywayModel.getGoodsPrice() != null){
									goods_price=tblGoodsPaywayModel.getGoodsPrice().toString();
								}else{
									goods_price = "0";
								}
							}
						}

						//订单表（TBL_ORDER）现金金额（TOTAL_MONEY）为0并且走新流程 时不调用支付的接口（NSCT018/NSCT008）进行订单调整--大机补充需求 mod by dengbing start
						boolean isPractiseRun = isPractiseRun((String) set.get("cardno"));
						String code ="";
						String msg = "";
						BigDecimal totalMoney = null ;
						int compareResut = -1;
						if(total_Money != null && !"".equals(total_Money)){
							totalMoney = new BigDecimal(total_Money);
							compareResut = totalMoney.compareTo(BigDecimal.ZERO);
						}
						if(compareResut==0 && isPractiseRun){
							code ="000000";
							msg = "";
						}else{
							List retList  = sendPay(orderId,set);
							Map map = new HashMap();
							if(retList.size()!=0){
								map = (Map) retList.get(0);
								code = (String) map.get("retCode");
								msg = (String) map.get("retErrMsg");
							}
						}
						//mod by dengbing end

						// 发送报文到支付超时
						if(code.equals("9999")){
							orderCheckService.insertOutSystem(orderMainId, orderId);
						}
						// 成功则发送短信给客户
						if(code.equals("000000")){
//						SMSMessage message = new SMSMessage();
//						message.sendMsg(goods_nm,goods_price, total_Money, cont_mob_phone);
							if(cont_mob_phone!=null &&!cont_mob_phone.trim().equals("")){
//								SendMobileMsg send=(SendMobileMsg)SpringUtil.getBean("MSG072FH00013");
								Map mobileMap = new HashMap();
								mobileMap.put("mobilephone", cont_mob_phone);
								mobileMap.put("product", goods_nm);
								mobileMap.put("account", goods_price);
								mobileMap.put("reaccount", total_Money);
//								Map returnMap =  send.sendMsg(mobileMap);
								Map returnMap = smsMessageService.sendMsg(mobileMap).getResult();
								if(returnMap!=null){
									String reMsg  = (String) returnMap.get("msg");
								}
							}
						}
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000000");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("撤销成功");
						return stageMallOrderCancelorRefundReturnVO;
					}
				}
			}else if("02".equals(intType)){//退货申请
//			CC调用
				if("01".equals(origin)){
					//判断订单状态
					if(!"0310".equals(curStatusId)){//只有已签收的订单能退货
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000053");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("订单状态异常,当前订单状态编码:"+ curStatusId);
						return stageMallOrderCancelorRefundReturnVO;
					}else{
						orderDodetail.setDoTime(new Date());
						orderDodetail.setOrderId(orderId);
						orderDodetail.setStatusId("0334");
						orderDodetail.setStatusNm("退货申请");
						orderDodetail.setDoDesc((doDesc != null && !"".equals(doDesc)) ? doDesc : "CC订单退货");
						orderDodetail.setDoUserid("Call Center");
						orderDodetail.setUserType("1");
						orderDodetail.setCreateOper("Call Center");
						orderDodetail.setDelFlag(new Integer("0"));
						orderDodetail.setCreateTime(new Date());
						if(tblOrder!=null){
							tblOrder.setCurStatusId("0334");
							tblOrder.setCurStatusNm("退货申请");
							tblOrder.setModifyTime(new Date());
							tblOrder.setVendorOperFlag("0");
							tblOrder.setModifyOper("Call Center");
						}else if(orderHistory!=null){
							orderHistory.setCurStatusId("0334");
							orderHistory.setCurStatusNm("退货申请");
							orderHistory.setModifyTime(new Date());
							orderHistory.setVendorOperFlag("0");
							orderHistory.setModifyOper("Call Center");
						}

//					tblOrderDao.updateTblOrder(tblOrder);
						orderCheckService.orderReturnwithTX(tblOrder,orderDodetail,null,orderHistory);
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000000");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("退货成功");
						return stageMallOrderCancelorRefundReturnVO;
					}
				}
				//BPS调用
				if("11".equals(origin)){
					if(!"0310".equals(curStatusId)){//只有已签收的订单能退货
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000053");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("订单状态异常,当前订单状态编码:"+ curStatusId);
						return stageMallOrderCancelorRefundReturnVO;
					}else{
						orderDodetail.setDoTime(new Date());
						orderDodetail.setOrderId(orderId);
						orderDodetail.setStatusId("0334");
						orderDodetail.setStatusNm("退货申请");
						orderDodetail.setDoDesc((doDesc != null && !"".equals(doDesc)) ? doDesc : "BPS订单退货");
						orderDodetail.setDoUserid("BPS");
						orderDodetail.setUserType("0");
						orderDodetail.setCreateOper("Call Center");
						orderDodetail.setDelFlag(new Integer("0"));
						orderDodetail.setCreateTime(new Date());
						if(tblOrder!=null){
							tblOrder.setCurStatusId("0334");
							tblOrder.setCurStatusNm("退货申请");
							tblOrder.setModifyTime(new Date());
							tblOrder.setVendorOperFlag("0");
							tblOrder.setModifyOper("BPS");
						}else if(orderHistory!=null){
							orderHistory.setCurStatusId("0334");
							orderHistory.setCurStatusNm("退货申请");
							orderHistory.setModifyTime(new Date());
							orderHistory.setVendorOperFlag("0");
							orderHistory.setModifyOper("BPS");
						}

//					tblOrderDao.updateTblOrder(tblOrder);
						orderCheckService.orderReturnwithTX(tblOrder,orderDodetail,null,orderHistory);
						stageMallOrderCancelorRefundReturnVO.setReturnCode("000000");
						stageMallOrderCancelorRefundReturnVO.setReturnDes("退货成功");
						return stageMallOrderCancelorRefundReturnVO;
					}
				}
			}
		}catch(Exception e){
			stageMallOrderCancelorRefundReturnVO.setReturnCode("000009");
			stageMallOrderCancelorRefundReturnVO.setReturnDes("系统异常");
			return stageMallOrderCancelorRefundReturnVO;
		}
		return stageMallOrderCancelorRefundReturnVO;
	}


	/**
	 * 获取优惠券对账文件表对象
	 * @param tblOrder
	 * @param orderHistory
	 * @return
	 */
	public OrderCheckModel getObject(OrderSubModel tblOrder,TblOrderHistoryModel orderHistory){
		String ischeck = "";;
		String ispoint = "";
		OrderCheckModel orderCheck = null;
		if(tblOrder!=null){
			if(tblOrder.getVoucherNo()!=null&&!"".equals(tblOrder.getVoucherNo())){
				ischeck = "0";
			}
			if(tblOrder.getBonusTotalvalue()!=null&&tblOrder.getBonusTotalvalue().longValue()!=0){
				ispoint = "0";
			}
			if(!"".equals(ischeck)||!"".equals(ispoint)){
				orderCheck = new OrderCheckModel();
				orderCheck.setOrderId(tblOrder.getOrderId());
				orderCheck.setCurStatusId("0312");
				orderCheck.setCurStatusNm("已撤单");
				orderCheck.setDoDate(new SimpleDateFormat("yyyyMMdd").format(new Date()));
				orderCheck.setDoTime(new SimpleDateFormat("HHmmss").format(new Date()));
				orderCheck.setIscheck(ischeck);
				orderCheck.setIspoint(ispoint);
				orderCheck.setDelFlag(0);
				return orderCheck;
			}
		}else if(orderHistory!=null){
			if(orderHistory.getVoucherNo()!=null&&!"".equals(orderHistory.getVoucherNo())){
				ischeck = "0";
			}
			if(orderHistory.getBonusTotalvalue()!=null&&orderHistory.getBonusTotalvalue().longValue()!=0){
				ispoint = "0";
			}
			if(!"".equals(ischeck)||!"".equals(ispoint)){
				orderCheck = new OrderCheckModel();
				orderCheck.setOrderId(orderHistory.getOrderId());
				orderCheck.setCurStatusId("0312");
				orderCheck.setCurStatusNm("已撤单");
				orderCheck.setDoDate(new SimpleDateFormat("yyyyMMdd").format(new Date()));
				orderCheck.setDoTime(new SimpleDateFormat("HHmmss").format(new Date()));
				orderCheck.setIscheck(ischeck);
				orderCheck.setIspoint(ispoint);
				orderCheck.setDelFlag(0);
				return orderCheck;
			}
		}
		return null;
	}

	/**
	 * 判断当前日期与d1相差与distance天的关系
	 * @param d1
	 * @param distance
	 * @return
	 */
	public static boolean judgeDays(String d1, int distance){
		Date nowDate = new Date();
		long dt = nowDate.getTime()-((long)distance * 24 * 60 * 60 * 1000);
		Date checkDate = new Date(dt);
		String d2 = getyyyyMMdd(checkDate);//减去distance得到的天数
		System.out.println(d2);
		if(Integer.parseInt(d2)>Integer.parseInt(d1)){
			return false;
		}
		return true;
	}
	public static String getyyyyMMdd(Date date) {
		return new SimpleDateFormat("yyyyMMdd").format(date);
	}

	/**
	 * 是否使用新方法
	 * 试运行标识是0(试运行结束，使用新方法);试运行标识是1(试运行中,如果卡号8、9为是44,则使用新方法)
	 * @param cardNo
	 * @return
	 */
	public  boolean isPractiseRun(String cardNo){
		if(needToUpdateRunFlag()){//判断是否需要更新runFlag
//			TblParametersDao tblParametersDao = (TblParametersDao)SpringUtil.getBean("tblParametersDao");
			List<Map> list = orderCheckService.getBigMachineParam();
			if(null == list || 0==list.size()){
				runFlag="0";
			}else{
				Map map = list.get(0);
				//如果试运行标识为空，则给默认值1（试运行结束）
				String pro_pri = trim((String) map.get("proPri"));
				cardNoSubStr = trim((String) map.get("proNm"));
				if(0 == pro_pri.length()){
					runFlag="0";
				}else{
					runFlag=pro_pri;//更新runFlag
				}
				runFlag=pro_pri;//更新runFlag
				list.clear();
			}
		}
		cardNo = trim(cardNo);
		if("0".equals(runFlag)){//0 试运行结束，使用新方法
			return true;
		}else if ("1".equals(runFlag)){//1试运行中，如果卡号8、9位是44的，就走新流程。
			//卡号为空或者卡长度不够9位
			if(null == cardNo || cardNo.length()<9){
				return false;
			}else{
				//卡号第8、9为是44，走新流程
				if(cardNoSubStr != null && cardNoSubStr.length() == 2){
					if(cardNoSubStr.charAt(0) == cardNo.charAt(7) && cardNoSubStr.charAt(1) == cardNo.charAt(8)){
						return true;
					}
				}
			}
			return false;
		}

		return true; //默认试运行结束
	}
	/** hwh add 20150116 大机改造补充需求 */
	/** 大机试运行标识 1：试运行  0：试运行结束 */
	private static String runFlag ;//= "0";
	/** 大机试运行卡号8,9位 */
	private static String cardNoSubStr ;
	/**
	 * 检查runFlag是否需求更新
	 * 如果runFlag为空
	 */
	private static boolean needToUpdateRunFlag(){
		//初始化时候 标识位空时候，查询数据库
		if(null == runFlag || 0 == runFlag.length() ){
			return true;
		}
		return false;
	}
	/**
	 * 清除字符串的左右空格
	 * @param str
	 * @return:返回清除左右空格后的字符串
	 */
	public static String trim(String str) {
		if (null == str) {
			return "";
		}

		return str.trim();
	}

	/**
	 * 发送报文至支付
	 * @param order_id 订单号
	 * @throws Exception
	 * @throws
	 * @throws Exception
	 */
	public List sendPay(String order_id,Map results) {
		SimpleDateFormat sdf = new SimpleDateFormat("YYYYMMddHHmmss");
		OrderSubModel orderModel = (OrderSubModel) results.get("orderModel");
		TblGoodsPaywayModel tblGoodsPaywayModel = (TblGoodsPaywayModel) results.get("tblGoodsPaywayModel");
		TblOrderExtend1Model tblOrderExtend1Model = (TblOrderExtend1Model) results.get("tblOrderExtend1Model");

		String retCode = "";
		String retErrMsg = "";
		List list = new ArrayList();
		Map map = new HashMap();
		ReturnGoodsInfo returnGoodsInfo = new ReturnGoodsInfo();
		try {
			if(results!=null){
				returnGoodsInfo.setChannel("MALL");
				returnGoodsInfo.setOrderId(orderModel.getOrderId());
				returnGoodsInfo.setOrderTime(sdf.format(orderModel.getCreateTime()));
				returnGoodsInfo.setOperTime(new SimpleDateFormat("YYYYMMddHHmmss").format(new Date()));
				returnGoodsInfo.setAcrdNo(orderModel.getCardno());
				returnGoodsInfo.setTradeMoney(tblGoodsPaywayModel.getGoodsPrice());
				returnGoodsInfo.setCashMoney(orderModel.getTotalMoney());
				returnGoodsInfo.setIntegralMoney(orderModel.getUitdrtamt());
				returnGoodsInfo.setMerId(orderModel.getMerId());
				returnGoodsInfo.setQsvendorNo(orderModel.getReserved1());
				returnGoodsInfo.setCategoryNo(orderModel.getSpecShopno());
				returnGoodsInfo.setOrderNbr(tblOrderExtend1Model.getOrdernbr());
				returnGoodsInfo.setStagesNum(orderModel.getStagesNum()+"");
				returnGoodsInfo.setOperId("");
				// 差额金额和活动类型。
				if(StringUtils.isNotEmpty(orderModel.getActType())){
					returnGoodsInfo.setDiscountMoney(orderModel.getFenefit());
					returnGoodsInfo.setTradeCode(codeChange(orderModel.getActType()));
				}else{
					returnGoodsInfo.setDiscountMoney(BigDecimal.ZERO);
					returnGoodsInfo.setTradeCode("");
				}
				//if(0 == orderModel.getCostBy()){//modify by xiewenliang  判断费用承担方
				//	returnGoodsInfo.setPayee("01");
			//	}else {
					returnGoodsInfo.setPayee("02");
				//}
				try {
					BaseResult baseResult = paymentService.returnGoods(returnGoodsInfo);
					retCode = baseResult.getRetCode();
					retErrMsg =baseResult.getRetErrMsg();
					map.put("retCode", retCode);
					map.put("retErrMsg", retErrMsg);
					list.add(map);
					return list;
				}
				catch(Exception eo){
					map.put("retCode", "9999");
					map.put("retErrMsg", "订单号:["+order_id+"]发送撤销请求超时!");
					list.add(map);
					return list;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 活动类型转换
	 * @param tradeCode
	 * @return
	 */
	private String codeChange(String tradeCode ) {
		String code = "";
		if(tradeCode != null && !"".equals(tradeCode)) {
			if (Contants.PROMOTION_PROM_TYPE_STRING_10.equals(tradeCode)) { // 折扣
				code = "12";
			} else if(Contants.PROMOTION_PROM_TYPE_STRING_20.equals(tradeCode)) { // 满减
				code = "11";
			} else if(Contants.PROMOTION_PROM_TYPE_STRING_30.equals(tradeCode)) { // 秒杀
				code = "13";
			} else if(Contants.PROMOTION_PROM_TYPE_STRING_40.equals(tradeCode)) { // 团购
				code = "14";
			} else if(Contants.PROMOTION_PROM_TYPE_STRING_50.equals(tradeCode)) { // 荷兰拍
				code = "08";
			}
		}
		return code;
	}
}
