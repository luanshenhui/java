package cn.com.cgbchina.trade.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Strings.nullToEmpty;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.service.*;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.SignAndVerify;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.trade.dto.UserPointDto;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.MemberAddressModel;
import com.google.common.base.Joiner;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserAccount;

@Service
@Slf4j
public class OrderJFMainServiceImpl extends DefaultOrderMainServiceImpl implements OrderJFMainService {
	@Resource
	ItemService itemService;
	@Resource
	GoodsService goodsService;
	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;
	@Resource
	private PriorJudgeServiceImpl priorJudgeService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	private CartServiceImpl cartService;
	@Resource
	private OrderServiceImpl orderService;
	@Resource
	VendorService vendorService;
	@Resource
	MemberAddressService memberAddressService;
	@Resource
	private GiftPartitionService giftPartitionService;
	@Resource
	private CardProService cardProService;
	@Resource
	EspCustNewService espCustNewService;
	@Value("#{app.merchId}") String merchId;
	@Value("#{app.returl}") String returl;
	@Value("#{app.mainPrivateKey}") String mainPrivateKey;
	@Value("#{app.payAddress}") String payAddress;
	@Value("#{app.timeStart}")
	private String timeStart;
	@Value("#{app.timeEnd}")
	private String timeEnd;
	@Value("#{app.birthdayLimit}")
	private String birthdayLimit;

	/**
	 * 积分商城生成主订单表
	 * @param orderCommitSubmitDto
	 * @param selectedCardInfo
	 * @param user
     * @return
     */
	@Override
	public Response<OrderMainDto> checkCreateJfOrderArgumentAndGetInfos_new(OrderCommitSubmitDto orderCommitSubmitDto, UserAccount selectedCardInfo, User user) {
		Response<OrderMainDto> retRsp = Response.newResponse();
		try {
			checkArgument(orderCommitSubmitDto != null, "订单信息不能为空");
			// 选择的支付卡卡号
			String cardNo = orderCommitSubmitDto.getCardNo();
			checkArgument(!cardNo.isEmpty(), "卡号不能为空");
			checkArgument(UserAccount.CardType.CREDIT_CARD.equals(selectedCardInfo.getCardType()), "积分商品不能使用借记卡");
			checkArgument(!orderCommitSubmitDto.getPayType().isEmpty(), "支付方式不能为空");
			checkArgument(!orderCommitSubmitDto.getPayType().equals("2"), "积分商品不能使用借记卡");
			List<OrderCommitInfoDto> orderCommitInfoDtoList = orderCommitSubmitDto.getOrderCommitInfoList();
			String goodsType = orderCommitSubmitDto.getGoodsType(); // 商品类型
			Response<OrderMainDto> orderMainDtoResponse = execOrderSubmit(orderCommitSubmitDto, user, null);
			if (!orderMainDtoResponse.isSuccess()) {
				return orderMainDtoResponse;
			}
			OrderMainDto orderMainDto = orderMainDtoResponse.getResult();
			orderMainDto.setGoodsType(goodsType);

			// 判断是否虚拟礼品
			if("01".equals(goodsType)){ //虚拟礼品
				checkArgument(orderCommitInfoDtoList.size() == 1, "虚拟礼品一次只能购买一种");
				boolean lxsyFlag = false;//判断是否留学生意外险礼品
				if (StringUtils.isNotEmpty(orderCommitSubmitDto.getAttachIdentityCard()) && StringUtils.isNotEmpty(orderCommitSubmitDto.getAttachName())) {
					lxsyFlag = true;
				}
				//2.预判
				String retCode = "";
				ItemModel itemModel = orderMainDto.getItemModels().get(0);
				Response<GoodsModel> goodsModelRsp = goodsService.findById(itemModel.getGoodsCode());
				checkArgument(goodsModelRsp.isSuccess() && goodsModelRsp.getResult() != null, "没找到该虚拟礼品");
				// 查询卡类卡板
				Response<ACardCustToelectronbankModel> aCardResponse = aCardCustToelectronbankService.findByCardNbr(orderCommitSubmitDto.getCardNo());
				checkArgument(aCardResponse.isSuccess() && aCardResponse.getResult() != null, "找不到银行卡对应信息");
				// 卡板代码
				Map<String, Object> cardQueryMap = Maps.newHashMap();
				cardQueryMap.put("formatId", aCardResponse.getResult().getCardFormatNbr());
				Response<List<CardPro>> cardResponse = cardProService.findByParams(cardQueryMap);
//				checkArgument(cardResponse.isSuccess() && cardResponse.getResult() !=null && cardResponse.getResult().size() > 0, "找不到卡板对应信息");
				CardPro cardPro = null;
				if (cardResponse.getResult() != null && cardResponse.getResult().size() > 0) {
					cardPro = cardResponse.getResult().get(0);
				}
				orderMainDto.getOrderCommitInfoDtoListMultimap().get(itemModel.getCode()).get(0).setCardType(cardPro != null ? cardPro.getCardproNm() : "");
				orderMainDto.getOrderCommitInfoDtoListMultimap().get(itemModel.getCode()).get(0).setCardFormat(aCardResponse.getResult().getCardFormatNbr());
//				orderCommitSubmitDto.setCardType(cardPro != null ? cardPro.getCardproNm() : "");
//				orderCommitSubmitDto.setCardFormat(aCardResponse.getResult().getCardFormatNbr());
				try {
					if (lxsyFlag) {
						retCode = priorJudgeService.preJudge(orderCommitSubmitDto.getAttachIdentityCard(), orderCommitSubmitDto.getCardNo(),
								aCardResponse.getResult().getCardFormatNbr(), itemModel.getCode(), "0");
					} else {
						retCode = priorJudgeService.preJudge(user.getCertNo(), orderCommitSubmitDto.getCardNo(),
								aCardResponse.getResult().getCardFormatNbr(), itemModel.getCode(), "0", orderCommitInfoDtoList.get(0).getJfCount());
					}
				} catch (Exception e) {
					log.error("OrderJFMainServiceImpl.checkCreateJfOrderArgumentAndGetInfos_new.preJudge.error,{}", e.getMessage());
					retCode = "-1";
				}
				checkArgument(!"-1".equals(retCode), "找不到对应的商品");
				checkArgument(!"1".equals(retCode), "该卡卡板不满足购买此礼品条件");
				checkArgument(!"2".equals(retCode), "尊敬的客户：您可兑换礼品已达限购次数上限");
				checkArgument(!"3".equals(retCode), "程序异常");
				checkArgument(!"4".equals(retCode), "尊敬的客户：您可兑换礼品已达积分上限");
				checkArgument(!"5".equals(retCode), "尊敬的客户：您本月可兑换礼品已达上限");

				checkArgument(orderCommitSubmitDto.getOrderCommitInfoList().get(0).getItemCount() < 100000, "虚拟礼品一次购买不能超过100000件");
				// 限购礼品只能一次购买一件
				int vlimit = itemModel.getVirtualLimit() == null ? 0 : itemModel.getVirtualLimit();// 限购次数
				if(vlimit > 0){// 是限购礼品
					checkArgument(orderCommitSubmitDto.getOrderCommitInfoList().get(0).getItemCount() == 1, "限购礼品一次只能购买一件");
				}
			}

			List<String> goodsCodes = Lists.newArrayList();
			List<String> itemCodeList = new ArrayList<String>();
			for (ItemModel itemModel : orderMainDto.getItemModels()) {
				itemCodeList.add(itemModel.getCode());
				goodsCodes.add(itemModel.getGoodsCode());
				// 判断单品库存数
				Long itemCount = 0L;
				for (OrderCommitInfoDto dto : orderMainDto.getOrderCommitInfoDtoListMultimap().get(itemModel.getCode())) {
					itemCount = itemCount + dto.getItemCount();
				}
				checkArgument(itemModel.getStock() >= itemCount, "库存不够");
				// 如果库存是9999 不更库存 不回滚
				if (itemModel.getStock().equals(9999)) {
					orderMainDto.putStock(itemModel.getCode(), -1L);
				} else {
					orderMainDto.putStock(itemModel.getCode(), itemCount);
				}
			}
			for (OrderCommitInfoDto dto : orderCommitInfoDtoList) {
				checkArgument(itemCodeList.contains(dto.getCode()), "购买的商品发生了变化，请重新购买");
			}
			Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
			checkArgument(goodsModels.isSuccess() && goodsModels.getResult().size() > 0, "购买的商品发生了变化，请重新购买");
			boolean flg = true;
			// 判断商品是否在售
			for (GoodsModel goodsModel : goodsModels.getResult()) {
				checkArgument(Contants.CHANNEL_POINTS_02.equals(goodsModel.getChannelPoints()), "购买的商品已经下架");
				orderMainDto.putGoodsInfo(goodsModel.getCode(), goodsModel);
				orderMainDto.addVendorCode(goodsModel.getVendorId());
				if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType()) && flg) {
					checkArgument(orderCommitSubmitDto.getAddressId() != null, "请选择送货地址");
					Response<MemberAddressModel> memberAddressResult = memberAddressService.findById(orderCommitSubmitDto.getAddressId());
					checkArgument(memberAddressResult.isSuccess(), "收货地址发生变化请重新选择");
					orderMainDto.setMemberAddressModel(memberAddressResult.getResult());
					// 商品类型
					flg = false;
				}
				// 实物，O2O商品结算数量最大为99件
				if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType()) || Contants.SUB_ORDER_TYPE_02.equals(goodsModel.getGoodsType())) {
					checkArgument(orderMainDto.getTotalNum() <= 99, "购买总数量不能大于99");
				}
			}
			log.info("jfTotalNum：商品的积分总数为：" + orderMainDto.getJfTotalNum());
			if (orderMainDto.getJfTotalNum() != 0) {
				Response<Map<String,BigDecimal>> userAccountResponse = cartService.getUserScore(user);// 积分系统返回客户的最高积分
				checkArgument(userAccountResponse.isSuccess(), "查询不到客户积分");
				// 积分是否足够
				List<QueryPointsInfoResult> pointList = orderService.getAmount(orderCommitSubmitDto.getCardNo(), orderCommitSubmitDto.getMergeFlag(), false);
				Map<String, BigDecimal> userPointTypeTotalMap = new HashMap<String, BigDecimal>();
				Map<String, BigDecimal> usedPointTypeTotalMap = new HashMap<String, BigDecimal>();
				BigDecimal account = null;
				for (QueryPointsInfoResult pointInfo : pointList) {
					account = new BigDecimal(0);
					DateTime validDate = new DateTime(DateHelper.string2Date(pointInfo.getValidDate(), DateHelper.YYYYMMDD)).plusDays(1);
					if (validDate.isAfterNow()) {
						account = pointInfo.getAccount();
					}
					if (userPointTypeTotalMap.get(pointInfo.getJgId()) == null) {
						userPointTypeTotalMap.put(pointInfo.getJgId(), account);
					} else {
						userPointTypeTotalMap.put(pointInfo.getJgId(), userPointTypeTotalMap.get(pointInfo.getJgId()).add(account));
					}
				}
				for(OrderCommitInfoDto orderCommitInfoDto : orderCommitInfoDtoList){
					if(usedPointTypeTotalMap.get(orderCommitInfoDto.getJfType()) == null){
						usedPointTypeTotalMap.put(orderCommitInfoDto.getJfType(), new BigDecimal(orderCommitInfoDto.getJfCount()));
					}else{
						usedPointTypeTotalMap.put(orderCommitInfoDto.getJfType(), usedPointTypeTotalMap.get(orderCommitInfoDto.getJfType()).add(new BigDecimal(orderCommitInfoDto.getJfCount())));
					}
				}
				// 积分类型名称List
				Map<String, String> jfTypeMap = Maps.newHashMap();
				Response<List<TblCfgIntegraltypeModel>> jfTypenams = giftPartitionService.findPointsTypeName();
				if (jfTypenams.isSuccess() && jfTypenams.getResult() != null) {
					for (TblCfgIntegraltypeModel tblCfgIntegraltypeModel : jfTypenams.getResult()) {
						jfTypeMap.put(tblCfgIntegraltypeModel.getIntegraltypeId(), tblCfgIntegraltypeModel.getIntegraltypeNm());
					}
				}
				for (Map.Entry<String, BigDecimal> usedMap : usedPointTypeTotalMap.entrySet()) {
					checkArgument(userPointTypeTotalMap.containsKey(usedMap.getKey()),
							jfTypeMap.get(usedMap.getKey()) + "积分不足");
					for (Map.Entry<String, BigDecimal> userMap : userPointTypeTotalMap.entrySet()) {
						if(usedMap.getKey().equals(userMap.getKey()) && usedMap.getValue().compareTo(userMap.getValue()) > 0){
							checkArgument(false, jfTypeMap.get(usedMap.getKey()) + "积分不足");
						}
					}
				}
			}

			// 供应商检证
			vendorCheckJF(orderMainDto);
			// 生日次数校验
			Response<EspCustNewModel> espCustNewModelResponse = espCustNewService.findById(user.getId());
			checkArgument(espCustNewModelResponse.isSuccess(), "查询会员信息失败");
			int birthCount = 0;
			for (ItemModel itemModel : orderMainDto.getItemModels()) {
				for (OrderCommitInfoDto orderCommitInfoDto : orderMainDto.getOrderCommitInfoDtoListMultimap().get(itemModel.getCode())) {
					// 虚拟商品不拆单
					int orderCount = orderCommitSubmitDto.getGoodsType().equals("01") ? 1 : orderCommitInfoDto.getItemCount();
					for (int index = 0; index < orderCount; index++) {
						if ("0004".equals(orderMainDto.getGoodsPaywayModelMap().get(orderCommitInfoDto.getPayWayId()).getMemberLevel())) {
							birthCount = birthCount + 1;
						}
					}
				}
			}
			int birthUsedCount = espCustNewModelResponse.getResult().getBirthUsedCount();
			checkArgument(birthUsedCount + birthCount <= Integer.valueOf(birthdayLimit), "不能支付,超过生日次数限制");
			if (birthCount > 0) {
				EspCustNewModel espCustNewModel = espCustNewModelResponse.getResult();
				espCustNewModel.setBirthUsedCount(espCustNewModel.getBirthUsedCount() + birthCount);
				orderMainDto.setEspCustNewModel(espCustNewModel);
			}
			retRsp.setResult(orderMainDto);
		} catch (IllegalArgumentException e) {
			log.error("OrderFQMainService checkCreateOrderArgumentAndGetInfos error,error code: {}", Throwables.getStackTraceAsString(e));
			retRsp.setError(e.getMessage());
			return retRsp;
		} catch (Exception e) {
			log.error("OrderFQMainService createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			retRsp.setError("OrderFQMainService.checkCreateOrderArgumentAndGetInfos.error");
			return retRsp;
		}
		return retRsp;
	}

	/**
	 * 积分获取返回的报文
	 *
	 * @param orderMain
	 * @param orderSubModelList
	 * @param orderVirtualList
	 * @return response
	 */
	@Override
	public Response<PagePaymentReqDto> getReturnObjForPay_new(OrderMainModel orderMain, List<OrderSubModel> orderSubModelList, List<OrderVirtualModel> orderVirtualList) {
		Response<PagePaymentReqDto> response = Response.newResponse();
		try {
			PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
			log.info("into 积分 getReturnObjForPay");
			String orderid = orderMain.getOrdermainId();// 大订单号
			String amount = orderMain.getTotalPrice().toString();// 总金额
			String payType = "2";// 支付类型
			String pointType = orderSubModelList.get(0).getBonusType();// 积分类型
			String pointSum = orderMain.getTotalBonus().toString();// 总积分值
			String isMerge = orderMain.getIsmerge();// 是否合并支付
			String payAccountNo = orderMain.getCardno();// 支付账号
			String serialNo = orderMain.getSerialNo();// 交易流水号
			String tradeDate = DateHelper.getyyyyMMdd(orderMain.getCreateTime());// 订单日期
			String tradeTime = DateHelper.getHHmmss(orderMain.getCreateTime());// 订单时间
			String certType = orderMain.getContIdType();// 证件类型
			String certNo = orderMain.getContIdcard();// 证件号
			String otherOrdersInf = "";// 优惠券、积分信息串
			pagePaymentReqDto.setSerialNo(serialNo);// 商城生成的流水号
			pagePaymentReqDto.setTradeDate(tradeDate);// 交易日期 为空
			pagePaymentReqDto.setTradeTime(tradeTime);// 交易时间 为空
			pagePaymentReqDto.setOrderid(orderid);// 大订单号
			pagePaymentReqDto.setAmount(amount);// 总金额
			pagePaymentReqDto.setMerchId(merchId);// 大商户号
			pagePaymentReqDto.setReturl(returl);// 回调地址
			pagePaymentReqDto.setPointType(pointType);// 积分类型 为空
			pagePaymentReqDto.setPointSum(pointSum);// 总积分值 为空
			pagePaymentReqDto.setIsMerge(isMerge);// 是否合并支付 为空
			pagePaymentReqDto.setPayAccountNo(payAccountNo);// 支付账号 为空
			pagePaymentReqDto.setPayType(payType);// 支付类型
			String orders = "";
			boolean flag = false;
			DecimalFormat df=new DecimalFormat("0.00");
			BigDecimal totalMoney=new BigDecimal("0");
			BigDecimal totalPoint=new BigDecimal("0");
			for (OrderSubModel orderSubModel : orderSubModelList) {
				orderSubModel.setIntegraltypeId(pointType);
				totalMoney=totalMoney.add(orderSubModel.getTotalMoney());
				totalPoint=totalPoint.add(orderSubModel.getInstallmentPrice());
				if ((orderSubModel != null && !"".equals(orderSubModel.getVoucherNo())) || orderSubModel.getBonusTotalvalue() != 0L) {
					// 存在使用积分、优惠券
					flag = true;
				}
			}
			orders = Joiner.on("|").join(merchId, nullToEmpty(orderid),df.format(totalMoney),
					"1", totalPoint.longValue());

			if (!flag) {// 如果没使用优惠券、积分
				certType = "";
				certNo = "";
				otherOrdersInf = "";
			} else {// 打印出优惠券积分串
				log.info("积分、优惠券串otherOrdersInf:" + otherOrdersInf);
			}
			pagePaymentReqDto.setOrders(orders);// 订单信息串
			pagePaymentReqDto.setOtherOrdersInf(otherOrdersInf);// 优惠券信息串
			pagePaymentReqDto.setCertType(certType);
			pagePaymentReqDto.setCertNo(certNo);
			OrderVirtualModel orderVirtual = orderVirtualList == null || orderVirtualList.size() == 0 ? new OrderVirtualModel() : orderVirtualList.get(0);
			String singGene = Joiner.on("|").join(merchId, nullToEmpty(orderid), amount, pointType, pointSum, isMerge, payType, nullToEmpty(orders), nullToEmpty(payAccountNo), nullToEmpty(serialNo), tradeDate, nullToEmpty(tradeTime), nullToEmpty(orderVirtual.getEntryCard()), nullToEmpty(orderVirtual.getTradecode()), orderVirtual.getVirtualAllPrice() == null ? "" : orderVirtual.getVirtualAllPrice().toString(), nullToEmpty(orderVirtual.getTradedesc())).trim();
			log.info("订单信息串singGene:" + singGene);
			// 改用旧系统加密方式
			String sign;
			try {
				sign = SignAndVerify.sign_md(singGene, mainPrivateKey);
			} catch (Exception e) {
				throw new RuntimeException(e.getMessage(),e);
			}// 签名
			pagePaymentReqDto.setSign(sign);// 签名
			pagePaymentReqDto.setPayAddress(payAddress);// 支付网关地址
			pagePaymentReqDto.setTradeCode(orderVirtual.getTradecode());
			pagePaymentReqDto.setEntry_card(orderVirtual.getEntryCard());
			pagePaymentReqDto.setVirtualPrice(orderVirtual.getVirtualAllPrice() == null ? "" : orderVirtual.getVirtualAllPrice().toString());
			pagePaymentReqDto.setTradeDesc(orderVirtual.getTradedesc());
			pagePaymentReqDto.setIsPractiseRun("0");
			pagePaymentReqDto.setTradeChannel(Contants.TRADECHANNEL);
			pagePaymentReqDto.setTradeSource(Contants.TRADESOURCE);
			pagePaymentReqDto.setBizSight(Contants.BIZSIGHT);
			pagePaymentReqDto.setSorceSenderNo(serialNo);
			pagePaymentReqDto.setOperatorId("");
			if(log.isDebugEnabled()) {
				log.debug("\n************ e-payment request info start ************" +
						pagePaymentReqDto.toString() +
						"\n************ e-payment request info end ************");
			}
			response.setResult(pagePaymentReqDto);
			return response;
		} catch (Exception e) {
			log.error("OrderJFMainService getReturnObjForPay error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderJFMainService.getReturnObjForPay.error");
			return response;
		}
	}

	@Override
	protected OrderMainSingleCheckDto singleCommitCheck(OrderCommitInfoDto orderCommitInfoDto, User user) {
		OrderMainSingleCheckDto retSinle = new OrderMainSingleCheckDto();
		if (orderCommitInfoDto.getJfCount() == null) {
			orderCommitInfoDto.setJfCount(0l);
		}
		// 单品编码
		checkArgument(!orderCommitInfoDto.getCode().isEmpty(), "没找到商品");
		Response<ItemModel> itemModelResponse = itemService.findByItemcode(orderCommitInfoDto.getCode());
		checkArgument(itemModelResponse.isSuccess() && itemModelResponse.getResult() != null, "单品不存在");
		ItemModel itemModel = itemModelResponse.getResult();
		Response<TblGoodsPaywayModel> tblGoodsPaywayResult = goodsPayWayService.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
		checkArgument(tblGoodsPaywayResult.isSuccess() && tblGoodsPaywayResult.getResult() != null, "商品支付方式发生变化请重新提交");
		// 购买数量
		Integer num = orderCommitInfoDto.getItemCount();
		checkArgument(num > 0, "购买数量不能小于1");
		// 积分商城不支持优惠券
		checkArgument(StringUtils.isEmpty(orderCommitInfoDto.getVoucherId()), "借记卡不支持优惠券");

		String entry_card = orderCommitInfoDto.getEntryCard();
		if (StringUtils.isNotEmpty(entry_card)) {//判断附属卡是否正常
			String retCode = priorJudgeService.judgeEntryCard_new(itemModel, entry_card);
			checkArgument(!"-1".equals(retCode), "此礼品不是附属卡礼品");
			checkArgument(!"-2".equals(retCode), "该卡不是附属卡");
		}

		BigDecimal goodsPrice = tblGoodsPaywayResult.getResult().getGoodsPrice() == null ? new BigDecimal(0) : tblGoodsPaywayResult.getResult().getGoodsPrice();

		retSinle.setItemCode(orderCommitInfoDto.getCode());
		retSinle.setTotalPrice(goodsPrice.multiply(new BigDecimal(orderCommitInfoDto.getItemCount().toString())));
		retSinle.setTotalNum(num);
		retSinle.setJfTotalNum(orderCommitInfoDto.getJfCount());
		retSinle.setOrderCommitInfoDto(orderCommitInfoDto);
		retSinle.setItemModel(itemModel);
		retSinle.setPayWayId(orderCommitInfoDto.getPayWayId());
		retSinle.setTblGoodsPaywayModel(tblGoodsPaywayResult.getResult());
		return retSinle;
	}
}
