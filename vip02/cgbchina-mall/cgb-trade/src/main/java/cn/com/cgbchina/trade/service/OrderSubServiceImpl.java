package cn.com.cgbchina.trade.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import com.google.common.base.Throwables;
import com.spirit.search.Pair;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.trade.dto.OrderCommitInfoDto;
import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

@Service
@Slf4j
public class OrderSubServiceImpl implements OrderSubService {

//	@Resource
//	private PriorJudgeServiceImpl priorJudgeService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	PriorJudgeService priorJudgeService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private GoodsService goodsService;


	/**
	 * 广发商城生成订单表和订单处理历史明细表
	 *
	 * @param orderMainDto
	 * @param user
	 * @param orderMainModel
	 * @return
	 */
	@Override
	public Response<OrderSubDetailDto> createOrderSubDoDetail_new(OrderMainDto orderMainDto, User user,
			OrderMainModel orderMainModel) {
		Response<OrderSubDetailDto> response = Response.newResponse();
		try {
			OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();
			// 商品信息
			Map<String, GoodsModel> goodsInfo = orderMainDto.getGoodsInfo();
			// 供应商信息
			Map<String, VendorInfoModel> vendorInfo = orderMainDto.getVendorInfo();
			int subCnt = 0;
			for (ItemModel itemModel : orderMainDto.getItemModels()) {
				for (OrderCommitInfoDto orderCommitInfoDto : orderMainDto.getOrderCommitInfoDtoListMultimap()
						.get(itemModel.getCode())) {
					// 用来平摊积分用的 bug-304524 fixed by ldk
					BigDecimal totalAfterPoint = new BigDecimal(orderCommitInfoDto.getAfterDiscountJf());
					BigDecimal count = new BigDecimal(orderCommitInfoDto.getItemCount());
					BigDecimal stretchedPoint = null;
					BigDecimal lastPoint = null;
					BigDecimal[] arr = totalAfterPoint.divideAndRemainder(count);
					if (arr[1].intValue() > 0) {
						stretchedPoint = arr[0];
						lastPoint = arr[0].add(arr[1]);
					} else {
						stretchedPoint = arr[0];
						lastPoint = arr[0];
					}

					for (int index = 0; index < orderCommitInfoDto.getItemCount(); index++) {
						OrderSubModel orderSubModel = new OrderSubModel();

						orderSubModel.setOrdermainId(orderMainModel.getOrdermainId());
						subCnt++;
						orderSubModel.setOrderId(
								orderMainModel.getOrdermainId() + StringUtils.leftPad(String.valueOf(subCnt), 2, "0"));
						orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());

						orderSubModel.setOperSeq(new Integer(0));
						orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
						orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());// 业务类型名称
						String stagesNum = StringUtils.isBlank(orderCommitInfoDto.getInstalments()) ? "1"
								: orderCommitInfoDto.getInstalments();
						TblGoodsPaywayModel tblGoodsPaywayModel = orderMainDto.getGoodsPaywayModelMap()
								.get(orderCommitInfoDto.getPayWayId());
						orderSubModel.setGoodsPaywayId(tblGoodsPaywayModel.getGoodsPaywayId());// 商品支付编码
						orderSubModel.setSpecShopno(tblGoodsPaywayModel.getCategoryNo());// 邮购分期类别码
						orderSubModel.setCalMoney(tblGoodsPaywayModel.getCalMoney());// 清算总金额
						String paywayCode = tblGoodsPaywayModel.getPaywayCode();
						orderSubModel.setPaywayCode(
								tblGoodsPaywayModel.getPaywayCode() == null ? "" : tblGoodsPaywayModel.getPaywayCode());// 支付方式代码0001:
																														// 现金0002:
																														// 积分0003:
																														// 积分+现金0004:手续费0005:
																														// 现金+手续费0006:
																														// 积分+手续费0007:积分+现金+手续费
						String PaywayName = "";
						if (StringUtils.isNotEmpty(paywayCode)) {
							if (paywayCode.equals("0001")) {
								PaywayName = "现金";
							} else if (paywayCode.equals("0002")) {
								PaywayName = "积分";
							} else if (paywayCode.equals("0003")) {
								PaywayName = "积分+现金";
							} else if (paywayCode.equals("0004")) {
								PaywayName = " 手续费";
							} else if (paywayCode.equals("0005")) {
								PaywayName = "现金+手续费";
							} else if (paywayCode.equals("0006")) {
								PaywayName = "积分+手续费";
							} else if (paywayCode.equals("0007")) {
								PaywayName = "积分+现金+手续费";
							}
						}
						orderSubModel.setPaywayNm(PaywayName);
						// 商品代码
						orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
						GoodsModel goodsModel = goodsInfo.get(itemModel.getGoodsCode());
						String vendorId = goodsModel.getVendorId();
						orderSubModel.setVendorId(vendorId);// 供应商代码
						orderSubModel.setVendorSnm(vendorInfo.get(vendorId).getSimpleName());// 供应商简称
						orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00: 商城01: CallCenter02: IVR渠道03:
						// 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡
						orderSubModel.setSourceNm(orderMainModel.getSourceNm());
						orderSubModel.setGoodsCode(itemModel.getGoodsCode());// 商品code
						orderSubModel.setGoodsId(itemModel.getCode());// 商（单）品代码
						orderSubModel.setGoodsNum(1);// 商品数量
						orderSubModel.setGoodsNm(goodsModel.getName());
						orderSubModel.setCurrType("156");// 商品币种
						orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
						orderSubModel.setGoodssendFlag("0");// 发货标记0－未发货[默认]1－已发货2－已签收
						orderSubModel.setGoodsaskforFlag("0");// 请款标记0－未请款[默认]1－已请款
						orderSubModel.setSpecShopnoType("");// 特店类型
						orderSubModel.setPayTypeNm("");// 佣金代码名称
						orderSubModel.setIncCode("");// 手续费率代码
						orderSubModel.setIncCodeNm("");// 手续费名称
						orderSubModel.setStagesNum(Integer.valueOf(stagesNum));// 现金[或积分]分期数
						orderSubModel.setCommissionType("");// 佣金计算类别
						orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
						orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
						orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
						orderSubModel.setIncWay("00");// 手续费获取方式
						orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
						orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额
						orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
						orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
						orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
						if (orderCommitInfoDto.getSinglePrice() != 0l) {
							orderSubModel.setUitdrtamt(new BigDecimal(orderCommitInfoDto.getJfCount())
									.divide(new BigDecimal(orderCommitInfoDto.getSinglePrice()))
									.divide(new BigDecimal(orderCommitInfoDto.getItemCount()), 2,
											BigDecimal.ROUND_DOWN));// 本金减免金额
						}
						orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
						orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
						orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
						orderSubModel.setCreditFlag("");// 授权额度不足处理方式
						orderSubModel.setCalWay("");// 退货方式
						orderSubModel.setLockedFlag("0");// 订单锁标记
						orderSubModel.setVendorOperFlag("0");// 供应商操作标记
						orderSubModel.setCurStatusId(orderMainModel.getCurStatusId());// 当前状态代码
						orderSubModel.setCurStatusNm(orderMainModel.getCurStatusNm());// 当前状态名称
						orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
						orderSubModel.setGoodsBrand("");// 品牌
						orderSubModel.setGoodsModel("");// 型号
						orderSubModel.setGoodsColor("");// 商品颜色
						orderSubModel.setActType(orderCommitInfoDto.getPromotion().getPromType() == null ? null
								: orderCommitInfoDto.getPromotion().getPromType().toString());// 活动类型
						orderSubModel.setActId(orderCommitInfoDto.getPromotion().getId() == null ? null
								: orderCommitInfoDto.getPromotion().getId().toString());// 活动Id
						orderSubModel.setPeriodId(orderCommitInfoDto.getPromotion().getPeriodId() == null ? null
								: Integer.parseInt(orderCommitInfoDto.getPromotion().getPeriodId()));// 活动场次
						orderSubModel.setMerId(vendorInfo.get(vendorId).getMerId());// 商户号
						orderSubModel.setReserved1(vendorInfo.get(vendorId).getUnionPayNo());// 保存银联商户号
						orderSubModel.setGoodsAttr1(itemModel.getAttributeName1());// 销售属性（json串）
						orderSubModel.setGoodsAttr2("");
						orderSubModel.setGoodsPresent("");// 赠品 未完成
						orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
						orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
						orderSubModel.setTmpStatusId("0000");// 临时状态代码
						orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
						orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
						orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
						orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
						orderSubModel.setCardtype("W");// 借记卡信用卡标识 未明
						orderSubModel.setCustCartId(orderCommitInfoDto.getCartId());// 此订单对应的购物车id
						// 0元秒杀flag
						String miaoshaFlag = orderMainDto.getMiaoshaFlag();
						if (Contants.AD_CHECK_STATUS_1.equals(miaoshaFlag)) {
							orderSubModel.setMiaoshaActionFlag(new Integer(1));
						} else {
							orderSubModel.setMiaoshaActionFlag(new Integer(0));
						}
						String goodsTypeItem = goodsModel.getGoodsType();
						orderSubModel.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
						if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
							orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
						}
						if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
							orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
						}
						if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
							orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
						}

						Response<List<Pair>> pairListResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
						if(pairListResponse.isSuccess()){
							List<Pair> categoryList = pairListResponse.getResult();
							String categoryId = categoryList.get(categoryList.size() - 1).getId().toString();
							orderSubModel.setTypeId(categoryId); // 最后一级类目
						}
						orderSubModel.setLevelNm(goodsModel.getGiftDesc());// 赠品信息
						orderSubModel.setMemberName(user.getName());// 会员名称
						orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
						orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
						// 数据库不为空项
						orderSubModel.setVerifyFlag("");
						String voucherId = "";
						String voucherNo = "";
						String voucherNm = "";
						BigDecimal voucherPrice = new BigDecimal(0);
						if (index == 0) {// 同一个商品中优惠券只放在第一个小订单
							voucherId = orderCommitInfoDto.getVoucherId();// 优惠券ID
							voucherNo = orderCommitInfoDto.getVoucherNo();// 优惠券ID
							voucherNm = orderCommitInfoDto.getVoucherNm();// 优惠券名称
							voucherPrice = orderCommitInfoDto.getVoucherPrice();// 优惠券价格
						}
						orderSubModel.setVoucherId(Strings.nullToEmpty(voucherId));// 优惠券ID
						orderSubModel.setVoucherNo(Strings.nullToEmpty(voucherNo));// 优惠券No
						orderSubModel.setVoucherNm(Strings.nullToEmpty(voucherNm));// 优惠券名称
						orderSubModel.setVoucherPrice(voucherPrice);// 优惠券价格
						BigDecimal totalMoney = orderCommitInfoDto.getPrice();
						// - 积分抵扣
						if (orderCommitInfoDto.isFixFlag() == false && orderCommitInfoDto.getSinglePrice() != 0l) {
							totalMoney = totalMoney.subtract(new BigDecimal(orderCommitInfoDto.getJfCount())
									.divide(new BigDecimal(orderCommitInfoDto.getSinglePrice()))
									.divide(new BigDecimal(orderCommitInfoDto.getItemCount()), 2,
											BigDecimal.ROUND_DOWN));
							if (totalMoney.intValue() < 0) {
								totalMoney = new BigDecimal("0");
							}
						}
						if (!"".equals(voucherNo) && voucherPrice != null) {
							// - 优惠券
							totalMoney = totalMoney.subtract(voucherPrice);
						}
						orderSubModel.setTotalMoney(totalMoney);// 现金总金额
						orderSubModel.setSinglePrice(totalMoney);// 单个商品对应的价格
						if (orderCommitInfoDto.getInstalments() != null
								&& !orderCommitInfoDto.getInstalments().equals("0")) {
							orderSubModel.setInstallmentPrice(totalMoney.divide(
									new BigDecimal(orderCommitInfoDto.getInstalments()), 2, BigDecimal.ROUND_DOWN));// 分期价格
						} else {
							orderSubModel.setInstallmentPrice(new BigDecimal(0));
						}
						orderSubModel.setIncTakePrice(orderSubModel.getInstallmentPrice());// 退单时收取指定金额手续费(未用)
						// TODO : bug-304524 modify by ldk
						BigDecimal jf = stretchedPoint;
						if (index + 1 == orderCommitInfoDto.getItemCount()) {
							jf = lastPoint;
						}
						orderSubModel.setSingleBonus(jf.longValue());
						orderSubModel.setBonusTotalvalue(jf.longValue());

						orderSubModel.setIntegraltypeId(goodsModel.getPointsType());// 广发商城积分类型默认1
						orderSubModel
								.setFenefit(orderCommitInfoDto.getOriPrice().subtract(orderCommitInfoDto.getPrice()));
						if (null != orderCommitInfoDto.getPromotion().getPromItemResultList()) {
							// 因为建活动时默认Null时，为供应商
							if (orderCommitInfoDto.getPromotion().getPromItemResultList().get(0).getCostBy() == null) {
								orderSubModel.setCostBy(1);
							} else {
								orderSubModel.setCostBy(
										orderCommitInfoDto.getPromotion().getPromItemResultList().get(0).getCostBy());
							}
						}
						orderSubModel.setO2oExpireFlag(0);
						OrderSubModel orderSubModelNew = new OrderSubModel();
						BeanUtils.copyProperties(orderSubModel, orderSubModelNew);
						orderSubDetailDto.addOrderSubModel(orderSubModelNew);
						OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
						orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
						orderDoDetailModel.setDoTime(new Date());
						orderDoDetailModel.setDoUserid(user.getId());// 处理用户
						orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
						orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
						orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 状态名称
						orderDoDetailModel.setMsgContent("");
						orderDoDetailModel.setDoDesc("乐购下单");
						orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
						orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
						orderSubDetailDto.addOrderDoDetailModel(orderDoDetailModel);
					}
				}
			}
			response.setResult(orderSubDetailDto);
			return response;
		} catch (Exception e) {
			log.error("OrderSubService createOrderSubDoDetail error:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderSubService createOrderSubDoDetail error");
			return response;
		}
	}

	/**
	 * 积分商城生成订单表和订单处理历史明细表
	 *
	 * @param orderCommitSubmitDto
	 * @param orderMainDto
	 * @param user
	 * @param orderMainModel
	 * @return
	 */
	@Override
	public Response<OrderSubDetailDto> createJfOrderSubDoDetail_new(OrderCommitSubmitDto orderCommitSubmitDto,
			OrderMainDto orderMainDto, User user, OrderMainModel orderMainModel) {
		Response<OrderSubDetailDto> response = Response.newResponse();
		try {
			OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();
			// 商品信息
			Map<String, GoodsModel> goodsInfo = orderMainDto.getGoodsInfo();
			// 供应商信息
			Map<String, VendorInfoModel> vendorInfo = orderMainDto.getVendorInfo();
			int subCnt = 0;
			for (ItemModel itemModel : orderMainDto.getItemModels()) {
				for (OrderCommitInfoDto orderCommitInfoDto : orderMainDto.getOrderCommitInfoDtoListMultimap()
						.get(itemModel.getCode())) {
					// 虚拟商品不拆单
					int orderCount = orderCommitSubmitDto.getGoodsType().equals("01") ? 1
							: orderCommitInfoDto.getItemCount();
					int itemCount = orderCommitSubmitDto.getGoodsType().equals("01") ? orderCommitInfoDto.getItemCount()
							: 1;
					for (int index = 0; index < orderCount; index++) {
						OrderSubModel orderSubModel = new OrderSubModel();
						orderSubModel.setOrdermainId(orderMainModel.getOrdermainId());
						subCnt++;
						orderSubModel.setOrderId(
								orderMainModel.getOrdermainId() + StringUtils.leftPad(String.valueOf(subCnt), 2, "0"));
						orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
						orderSubModel.setOperSeq(new Integer(0));
						orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
						orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());// 业务类型名称
						String stagesNum = StringUtils.isBlank(orderCommitInfoDto.getInstalments()) ? "1"
								: orderCommitInfoDto.getInstalments();
						TblGoodsPaywayModel tblGoodsPaywayModel = orderMainDto.getGoodsPaywayModelMap()
								.get(orderCommitInfoDto.getPayWayId());
						orderSubModel.setGoodsPaywayId(tblGoodsPaywayModel.getGoodsPaywayId());// 商品支付编码
						orderSubModel.setSpecShopno(tblGoodsPaywayModel.getCategoryNo());// 邮购分期类别码
						orderSubModel
								.setCalMoney(new BigDecimal(itemCount).multiply(tblGoodsPaywayModel.getCalMoney()));// 清算总金额
						String paywayCode = tblGoodsPaywayModel.getPaywayCode();
						orderSubModel.setPaywayCode(
								tblGoodsPaywayModel.getPaywayCode() == null ? "" : tblGoodsPaywayModel.getPaywayCode());// 支付方式代码0001:
																														// 现金0002:
																														// 积分0003:
																														// 积分+现金0004:手续费0005:
																														// 现金+手续费0006:
																														// 积分+手续费0007:积分+现金+手续费
						String PaywayName = "";
						if (StringUtils.isNotEmpty(paywayCode)) {
							if (paywayCode.equals("0001")) {
								PaywayName = "现金";
							} else if (paywayCode.equals("0002")) {
								PaywayName = "积分";
							} else if (paywayCode.equals("0003")) {
								PaywayName = "积分+现金";
							} else if (paywayCode.equals("0004")) {
								PaywayName = " 手续费";
							} else if (paywayCode.equals("0005")) {
								PaywayName = "现金+手续费";
							} else if (paywayCode.equals("0006")) {
								PaywayName = "积分+手续费";
							} else if (paywayCode.equals("0007")) {
								PaywayName = "积分+现金+手续费";
							}
						}
						orderSubModel.setPaywayNm(PaywayName);
						// 商品代码
						orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
						GoodsModel goodsModel = goodsInfo.get(itemModel.getGoodsCode());
						String vendorId = goodsModel.getVendorId();
						orderSubModel.setVendorId(vendorId);// 供应商代码
						orderSubModel.setVendorSnm(vendorInfo.get(vendorId).getSimpleName());// 供应商简称
						orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00: 商城01: CallCenter02: IVR渠道03:
						// 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡
						orderSubModel.setSourceNm(orderMainModel.getSourceNm());
						orderSubModel.setGoodsCode(itemModel.getGoodsCode());// 商品code
						orderSubModel.setGoodsId(itemModel.getCode());// 商（单）品代码
						orderSubModel.setGoodsNum(itemCount);// 商品数量
						orderSubModel.setGoodsNm(goodsModel.getName());
						orderSubModel.setCurrType("156");// 商品币种
						orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
						orderSubModel.setGoodssendFlag("0");// 发货标记0－未发货[默认]1－已发货2－已签收
						orderSubModel.setGoodsaskforFlag("0");// 请款标记0－未请款[默认]1－已请款
						orderSubModel.setSpecShopnoType("");// 特店类型
						orderSubModel.setPayTypeNm("");// 佣金代码名称
						orderSubModel.setIncCode("");// 手续费率代码
						orderSubModel.setIncCodeNm("");// 手续费名称
						orderSubModel.setStagesNum(Integer.valueOf(stagesNum));// 现金[或积分]分期数
						orderSubModel.setCommissionType("");// 佣金计算类别
						orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
						orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
						orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
						orderSubModel.setIncWay("00");// 手续费获取方式
						orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
						orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额
						orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
						orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
						orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
						orderSubModel.setUitdrtamt(new BigDecimal(0));// 本金减免金额
						orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
						orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
						orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
						orderSubModel.setCreditFlag("");// 授权额度不足处理方式
						orderSubModel.setCalWay("");// 退货方式
						orderSubModel.setLockedFlag("0");// 订单锁标记
						orderSubModel.setVendorOperFlag("0");// 供应商操作标记
						orderSubModel.setCurStatusId(orderMainModel.getCurStatusId());// 当前状态代码
						orderSubModel.setCurStatusNm(orderMainModel.getCurStatusNm());// 当前状态名称
						orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
						orderSubModel.setGoodsBrand("");// 品牌
						orderSubModel.setGoodsModel("");// 型号
						orderSubModel.setGoodsColor("");// 商品颜色
						orderSubModel.setActType("");// 活动类型
						orderSubModel.setActId("");// 活动Id
						orderSubModel.setPeriodId(null);// 活动场次
						orderSubModel.setMerId(vendorInfo.get(vendorId).getMerId());// 商户号
						orderSubModel.setReserved1(vendorInfo.get(vendorId).getUnionPayNo());// 保存银联商户号
						orderSubModel.setGoodsAttr1(itemModel.getAttributeName1());// 销售属性（json串）
						orderSubModel.setGoodsAttr2("");
						orderSubModel.setGoodsPresent("");// 赠品 未完成
						orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
						orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
						orderSubModel.setTmpStatusId("0000");// 临时状态代码
						orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
						orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
						orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
						orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
						orderSubModel.setCardtype("W");// 借记卡信用卡标识 未明
						orderSubModel.setCustCartId(orderCommitInfoDto.getCartId());// 此订单对应的购物车id
						if (orderCommitInfoDto.getPromotion().getPromType() != null
								&& orderCommitInfoDto.getPromotion().getPromType() == 30) {
							orderSubModel.setMiaoshaActionFlag(new Integer(1));
						} else {
							orderSubModel.setMiaoshaActionFlag(new Integer(0));
						}
						String goodsTypeItem = goodsModel.getGoodsType();
						orderSubModel.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
						if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
							orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
						}
						if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
							orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
						}
						if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
							orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
						}
						Response<List<Pair>> pairListResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
						if(pairListResponse.isSuccess()){
							List<Pair> categoryList = pairListResponse.getResult();
							String categoryId = categoryList.get(categoryList.size() - 1).getId().toString();
							orderSubModel.setTypeId(categoryId); // 最后一级类目
						}
						orderSubModel.setLevelNm("");// 赠品信息
						orderSubModel.setMemberName(user.getName());// 会员名称
						orderSubModel.setMemberLevel(tblGoodsPaywayModel.getMemberLevel());// 会员等级
						orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
						orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
						// 数据库不为空项
						orderSubModel.setVerifyFlag("");
						String voucherId = "";
						String voucherNo = "";
						String voucherNm = "";
						BigDecimal voucherPrice = new BigDecimal(0);
						orderSubModel.setVoucherId(Strings.nullToEmpty(voucherId));
						orderSubModel.setVoucherNo(Strings.nullToEmpty(voucherNo));
						orderSubModel.setVoucherNm(Strings.nullToEmpty(voucherNm));
						orderSubModel.setVoucherPrice(voucherPrice);
						BigDecimal totalMoney = orderCommitInfoDto.getPrice();
						orderSubModel.setTotalMoney(new BigDecimal(itemCount).multiply(totalMoney));// 现金总金额
						orderSubModel.setSinglePrice(totalMoney);// 单个商品对应的价格
						if (orderCommitInfoDto.getInstalments() != null
								&& !orderCommitInfoDto.getInstalments().equals("0")) {
							orderSubModel.setInstallmentPrice(totalMoney.divide(
									new BigDecimal(orderCommitInfoDto.getInstalments()), 2, BigDecimal.ROUND_DOWN));// 分期价格
						} else {
							orderSubModel.setInstallmentPrice(new BigDecimal(0));
						}
						orderSubModel.setIncTakePrice(orderSubModel.getInstallmentPrice());// 退单时收取指定金额手续费(未用)
						orderSubModel
								.setSingleBonus(orderCommitInfoDto.getJfCount() / orderCommitInfoDto.getItemCount());
						orderSubModel.setBonusTotalvalue(
								orderCommitInfoDto.getJfCount() / orderCommitInfoDto.getItemCount() * itemCount);
						orderSubModel.setIntegraltypeId(goodsModel.getPointsType());// 积分商城 积分类型
						orderSubModel.setBonusType(goodsModel.getPointsType());// 积分商城 积分类型
						orderSubModel
								.setFenefit(orderCommitInfoDto.getOriPrice().subtract(orderCommitInfoDto.getPrice()));
						if (null != orderCommitInfoDto.getPromotion().getPromItemResultList()) {
							orderSubModel.setCostBy(
									orderCommitInfoDto.getPromotion().getPromItemResultList().get(0).getCostBy());
						}
						orderSubModel.setO2oExpireFlag(0);
						OrderSubModel orderSubModelNew = new OrderSubModel();
						BeanUtils.copyProperties(orderSubModel, orderSubModelNew);
						orderSubDetailDto.addOrderSubModel(orderSubModelNew);
						if (orderCommitSubmitDto.getGoodsType().equals("01")) {
							OrderVirtualModel orderVirtual = new OrderVirtualModel();
							orderVirtual.setOrderId(orderSubModel.getOrderId());// 小订单号
							orderVirtual.setGoodsXid(itemModel.getXid());// 礼品编码
							orderVirtual.setGoodsMid(itemModel.getMid());// 商品ID(分期唯一值用于外系统)
							orderVirtual.setGoodsOid(itemModel.getOid());// 商品ID(一次性唯一值用于外系统)
							orderVirtual.setGoodsBid(itemModel.getBid());// 礼品代号
							String entry_card = orderCommitSubmitDto.getEntryCard();
							if (StringUtils.isNotEmpty(entry_card)) {//判断附属卡是否正常
								orderVirtual.setEntryCard(entry_card);// 兑换卡
							} else {// 为方便出报表，如果入账卡为空，则存支付卡号
								orderVirtual.setEntryCard(orderCommitSubmitDto.getCardNo());// 支付卡号
							}
							orderVirtual.setVirtualCardType(orderCommitSubmitDto.getCardType());// 卡类
							orderVirtual.setExtend2(orderCommitSubmitDto.getCardFormat());// 记录卡板
							orderVirtual.setGoodsType(goodsModel.getGoodsType());// 礼品类别（此处为虚拟礼品）
							orderVirtual.setVirtualLimit(goodsModel.getLimitCount());// 限购次数
							orderVirtual.setVirtualSingleMileage(itemModel.getVirtualMileage());// 里程
							int mileage = 0;
							BigDecimal goods_mun = new BigDecimal(orderSubModel.getGoodsNum().intValue());
							BigDecimal virtual_price = new BigDecimal(itemModel.getVirtualPrice().doubleValue());
							BigDecimal price_result = goods_mun.multiply(virtual_price).setScale(2,
									BigDecimal.ROUND_HALF_UP);// 商品价格乘以商品数量，保留两位小数
							if (itemModel.getVirtualMileage() != null) {
								mileage = itemModel.getVirtualMileage().intValue();
							}
							orderVirtual.setVirtualAllMileage(
									new Integer(orderSubModel.getGoodsNum().intValue() * mileage));
							orderVirtual.setVirtualSinglePrice(itemModel.getVirtualPrice());// 兑换金额
							orderVirtual.setVirtualAllPrice(new BigDecimal(price_result.doubleValue()));
							orderVirtual.setVirtualMemberId(orderCommitSubmitDto.getVirtualMemberId());// 会员id
							orderVirtual.setVirtualMemberNm(orderCommitSubmitDto.getVirtualMemberNm());// 会员姓名
							orderVirtual.setSerialno(orderCommitSubmitDto.getSerialno()); // 客户所输入的保单号
							orderVirtual.setVirtualAviationType(orderCommitSubmitDto.getVirtualAviationType());// 航空类型
							orderVirtual.setPrepaidMob(orderCommitSubmitDto.getPrepaidMob());// 充值卡的电话号码
							orderVirtual.setTradedesc("");
							// tradeCode是用来给支付平台出对账文件
							String tradeCode = "";
							if (priorJudgeService.isNianFee(itemModel.getXid())) {// 积分换年费交易码
								tradeCode = "3400";
							} else if (priorJudgeService.isQianzhane(itemModel.getXid())) {// 红利卡兑换免签帐额调整交易码
								tradeCode = "8200";
							}
							orderVirtual.setTradecode(tradeCode);
							orderVirtual.setAttachName(orderCommitSubmitDto.getAttachName());
							orderVirtual.setAttachIdentityCard(orderCommitSubmitDto.getAttachIdentityCard());
							orderSubDetailDto.addOrderVirtualModel(orderVirtual);
						}
						OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
						orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
						orderDoDetailModel.setDoTime(new Date());
						orderDoDetailModel.setDoUserid(user.getId());// 处理用户
						orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
						orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
						orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 状态名称
						orderDoDetailModel.setMsgContent("");
						orderDoDetailModel.setDoDesc("乐购下单");
						orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
						orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
						orderSubDetailDto.addOrderDoDetailModel(orderDoDetailModel);
					}
				}
			}
			response.setResult(orderSubDetailDto);
			return response;
		} catch (Exception e) {
			log.error("OrderSubService createJfOrderSubDoDetail error:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderSubService createJfOrderSubDoDetail error");
			return response;
		}
	}
}
