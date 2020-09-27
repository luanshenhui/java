package cn.com.cgbchina.restful.provider.service.goods;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.model.AppGoodsDetailModel;
import cn.com.cgbchina.item.model.AppPrivilegeInfo;
import cn.com.cgbchina.item.model.AppStageInfo;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.promotion.model.EspActRemindModel;
import cn.com.cgbchina.promotion.service.EspActRemindService;
import cn.com.cgbchina.related.service.CouPonInfService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPVO;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.restful.provider.service.order.OrderChannelService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.UserFavoriteService;
import cn.com.cgbchina.user.service.VendorService;

import com.google.common.base.Strings;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

/**
 * MAL313 商品详细信息(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL313")
@Slf4j
public class StageMallGoodsDetailByAPPProvideServiceImpl
		implements
		SoapProvideService<StageMallGoodsDetailByAPPQueryVO, StageMallGoodsDetailByAPPReturnVO> {
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	RestItemService restItemService;
	@Resource
	CouponService couponService;
	@Resource
	CouPonInfService couPonInfService;
	@Resource
	PromotionPayWayService promotionPayWayService;
	@Resource
	OrderChannelService orderChannelService;
	@Resource
	EspActRemindService espActRemindService;
	@Resource
	private UserFavoriteService userFavoriteService;
	@Resource
	private VendorService vendorService;


	@Override
	public StageMallGoodsDetailByAPPReturnVO process(
			SoapModel<StageMallGoodsDetailByAPPQueryVO> model,
			StageMallGoodsDetailByAPPQueryVO stageMallGoodsDetailByAPPQuery) {
		// 参数组装
		String[] goodsIds = { stageMallGoodsDetailByAPPQuery.getGoodsId() };
		Response<AppGoodsDetailModel> result = restItemService
				.findGoodsDetailByApp(

						stageMallGoodsDetailByAPPQuery.getGoodsId(),
						stageMallGoodsDetailByAPPQuery.getOrigin(),
						stageMallGoodsDetailByAPPQuery.getContIdcard(),
						stageMallGoodsDetailByAPPQuery.getCustId(),
						stageMallGoodsDetailByAPPQuery.getQueryType(), goodsIds);
		StageMallGoodsDetailByAPPReturnVO appReturn = new StageMallGoodsDetailByAPPReturnVO();
		StageMallGoodsDetailByAPPVO app = new StageMallGoodsDetailByAPPVO();
		// 活动处理---
		boolean WXFlag = false;
		if (Contants.CHANNEL_SN_WX.equals(stageMallGoodsDetailByAPPQuery
				.getOrigin())
				|| Contants.CHANNEL_SN_WS.equals(stageMallGoodsDetailByAPPQuery
				.getOrigin())
				|| Contants.CHANNEL_SN_YX.equals(stageMallGoodsDetailByAPPQuery
				.getOrigin())
				|| Contants.CHANNEL_SN_YS.equals(stageMallGoodsDetailByAPPQuery
				.getOrigin())) {
			WXFlag = true;
		}
		if (result.isSuccess()) {
			AppGoodsDetailModel resultdata = result.getResult();

			if (resultdata == null) {
				if (!result.getError().isEmpty()
						&& result.getError().indexOf(":") != -1) {
					appReturn.setReturnCode(result.getError().split(":")[1]);
					appReturn.setReturnDes(result.getError().split(":")[2]);
					return appReturn;
				}
			}

			// 读取进行中的活动
			boolean promotionFlag = false;
			String sourceId = stageMallGoodsDetailByAPPQuery.getOrigin();
			if (Contants.CHANNEL_SN_WS.equals(stageMallGoodsDetailByAPPQuery
					.getOrigin())) {
				sourceId = Contants.SOURCE_ID_WECHAT_A;
			} else if (Contants.CHANNEL_SN_WX
					.equals(stageMallGoodsDetailByAPPQuery.getOrigin())) {
				sourceId = Contants.SOURCE_ID_WECHAT;
			}
			Response<MallPromotionResultDto> response = mallPromotionService
					.findPromByItemCodes("0",
							stageMallGoodsDetailByAPPQuery.getGoodsId(),
							sourceId);
			log.info("######################313查询活动："+response.getError());
			MallPromotionResultDto dto = new MallPromotionResultDto();
			if (response.isSuccess()) {
				dto = response.getResult();
				// 活动类型 10:折扣  20:满减   30:秒杀 40:团购 50:荷兰拍
				if (dto != null && dto.getPromType() != null) {

					//渠道只有团购   秒杀活动
					if((int)Contants.PROMOTION_PROM_TYPE_3==dto.getPromType()||dto.getPromType()==(int)Contants.PROMOTION_PROM_TYPE_4){
						// 证明有活动
						promotionFlag = true;

					}
				}
			}
			// 开始日期
			GregorianCalendar mallDate = new GregorianCalendar(
					TimeZone.getDefault(), Locale.CHINA);
			SimpleDateFormat date = new SimpleDateFormat("yyyyMMdd");
			String malldate = date.format(mallDate.getTime());
			// 开始时间
			SimpleDateFormat time = new SimpleDateFormat("HHmmss");
			String malltime = time.format(mallDate.getTime());

			// 如果是活动，重新取得商品的活动价格及分期信息
			if (promotionFlag) {
				Response<List<PromotionPayWayModel>> response1 = promotionPayWayService
						.findPromotionByItemCode(stageMallGoodsDetailByAPPQuery.getGoodsId(), dto.getId());
				if (response1.isSuccess()) {
					List<PromotionPayWayModel> models = response1.getResult();
					if (models != null) {
						String goods_price = "";
						List<AppStageInfo> list = new ArrayList<>();
						for (PromotionPayWayModel promotionPayWayModel : models) {
							//微信 只添加1期支付方式
							if(WXFlag&&promotionPayWayModel.getStagesCode()!=1){
								continue;
							}
							AppStageInfo appstageInfo = new AppStageInfo();
							appstageInfo.setStagesNum(promotionPayWayModel
									.getStagesCode() == null ? ""
									: promotionPayWayModel.getStagesCode()
									.toString());
							appstageInfo.setPerStage(promotionPayWayModel
									.getPerStage() == null ? ""
									: promotionPayWayModel.getPerStage()
									.toString());
							appstageInfo.setPaywayIdF(promotionPayWayModel
									.getGoodsPaywayId());
							list.add(appstageInfo);
							goods_price = promotionPayWayModel.getGoodsPrice() == null ? ""
									: promotionPayWayModel.getGoodsPrice()
									.toString();
						}
						resultdata.setStageInfo(list);
						resultdata.setGoodsPrice(goods_price);
						// 如果是手机的请求,无需考虑商品是否维护固定积分，保持现有的规则计算可使用积分，如果是微信/APP的请求，则如果ifFixPoint是1则取固定积分的值返回给微信
						String canIntegral="";
						if (resultdata.getRate()==null||"1".equals(resultdata.getIfFixPoint()) && (WXFlag || Contants.SOURCE_ID_APP.equals(stageMallGoodsDetailByAPPQuery.getOrigin()))) {
							//不涉及活动价格不需要修改
						} else {
							canIntegral = String.valueOf(Math.round(Long.parseLong(resultdata.getUnitIntegral()) * Double.parseDouble(resultdata.getRate())
									* Double.parseDouble(goods_price)));// 单位积分X倍率X售价
							resultdata.setCanIntegral(canIntegral);
						}
					}
				}
			}

			//获取供应商信息
			Response<VendorInfoDto> vendorDto = vendorService.findById(resultdata.getVendorId());
			if(!vendorDto.isSuccess()){
				log.error(vendorDto.getError());
			}
			VendorInfoDto vendorModel = vendorDto.getResult();
			resultdata.setVendorPhone(vendorModel.getPhone());


			// 活动和优惠券信息
			if ("1".equals(stageMallGoodsDetailByAPPQuery.getQueryType())) {
				if (promotionFlag) {
					resultdata.setActId(dto.getId() == null ? "" : dto.getId()
							.toString());

					//如果已经登陆则查询是否设置过提醒
					if(!Strings.isNullOrEmpty(stageMallGoodsDetailByAPPQuery.getCustId())){
						EspActRemindModel espActRemindModel=new EspActRemindModel();
						espActRemindModel.setCustId(stageMallGoodsDetailByAPPQuery.getCustId());
						espActRemindModel.setActId(dto.getId().longValue());
						espActRemindModel.setGoodsId(stageMallGoodsDetailByAPPQuery.getGoodsId());
						Response<Boolean>  rt=espActRemindService.findIsRemidByGoods(espActRemindModel);
						if(rt.isSuccess()){
							if(rt.getResult()!=null&&rt.getResult()){
								resultdata.setRemindStatus("1");
							}else{
								resultdata.setRemindStatus("0");
							}
						}
					}

					Response<MallPromotionSaleInfoDto>  rs=mallPromotionService.findPromSaleInfoByPromId(dto.getId().toString(),dto.getPeriodId(),stageMallGoodsDetailByAPPQuery.getGoodsId());

					MallPromotionSaleInfoDto mallPromotionSaleInfoDto = new MallPromotionSaleInfoDto();
					if(rs.isSuccess() && rs.getResult()!=null){
						mallPromotionSaleInfoDto = rs.getResult();
					}
					if (40 == dto.getPromType()) {
						resultdata.setGoodsType("2");//设置团购类型
						//设置参团人数

						resultdata.setActionCount(mallPromotionSaleInfoDto.getSaleAmountToday()==null?"0":mallPromotionSaleInfoDto.getSaleAmountToday().toString());

					} else if (30 == dto.getPromType()) {// 数量和库存需要设置
						resultdata.setGoodsType("3");// 设置为秒杀
						if(dto.getPromItemResultList()!=null&&dto.getPromItemResultList().get(0)!=null&&dto.getPromItemResultList().get(0).getStock()!=null){
							Long actionStock=mallPromotionSaleInfoDto.getStockAmountTody() == null?0:mallPromotionSaleInfoDto.getStockAmountTody();//今天总库存
							Integer saleCount=mallPromotionSaleInfoDto.getSaleAmountToday()==null?0:mallPromotionSaleInfoDto.getSaleAmountToday();//活动的今天的销售数量
							Long goodsBackLog = actionStock - (long)saleCount;
							if(actionStock!=null){
								resultdata.setGoodsBacklog(goodsBackLog.toString());
								resultdata.setGoodsTotal(actionStock.toString());
								resultdata.getBacklogInfo().get(0).setGoodsBackLog(goodsBackLog.toString());
								resultdata.getBacklogInfo().get(0).setGoodsTotal(actionStock.toString());

							}
						}
						List<PromotionItemResultDto>  itemList=dto.getPromItemResultList();
						if(itemList!=null&&itemList.get(0)!=null){
							for (PromotionItemResultDto promotionItemResultDto : itemList) {
								if(promotionItemResultDto.getSelectCode().equals(stageMallGoodsDetailByAPPQuery.getGoodsId())){
									if(promotionItemResultDto.getPrice().compareTo(BigDecimal.ZERO)==0){
										//判断商品价格为0元设置为0元秒杀
										resultdata.setGoodsType("4");// 设置秒杀
										break;
									}
								}
							}
						}
					}
					resultdata.setMallDate(malldate);// 商城日期
					resultdata.setMallTime(malltime);// 商城时间
					if (promotionFlag) {
						resultdata.setActStatus("1");//xiewl 20161010 活动状态 0:未处理 1:进行中 2:活动未通过 3:活动停止
						String bgdate = date.format(dto.getBeginDate());
						String bgtime = time.format(dto.getBeginDate());
						resultdata.setActBeginDate(bgdate);
						resultdata.setActBeginTime(bgtime);
						resultdata.setActId(dto.getId() == null ? "" : dto.getId()
								.toString());
						String endate = date.format(dto.getEndDate());
						String entime = time.format(dto.getEndDate());
						resultdata.setActEndDate(endate);
						resultdata.setActEndTime(entime);
						resultdata
								.setCountLimit(dto.getRuleLimitBuyCount() == null ? "10"
										: dto.getRuleLimitBuyCount().toString());// 限购数
					}
				}

			} else if ("2"
					.equals(stageMallGoodsDetailByAPPQuery.getQueryType())) {
				// 设置优惠券
				createCoupon(stageMallGoodsDetailByAPPQuery, resultdata,
						promotionFlag, dto, date, malldate, malltime,resultdata.getGoodsModel());

			} else if ("3"
					.equals(stageMallGoodsDetailByAPPQuery.getQueryType())) {
				if (promotionFlag) {
					// 如果是秒杀则给出剩余量和销售总量
					if ("30".equals(stageMallGoodsDetailByAPPQuery.getQueryType())) {
						if (dto != null) {
							Response<MallPromotionSaleInfoDto> promotionSaleInfoResult = mallPromotionService
									.findPromSaleInfoByPromId(dto.getId()
													.toString(), dto.getPeriodId(),
											goodsIds[0]);
							if (promotionSaleInfoResult.isSuccess()) {
								if (promotionSaleInfoResult.getResult() != null) {
									// 设置当前库存
									resultdata.setGoodsBacklog(String.valueOf(promotionSaleInfoResult.getResult().getStockAmountTody()
											- promotionSaleInfoResult.getResult().getSaleAmountToday()));
									// 设置总库存
									resultdata.setGoodsTotal(promotionSaleInfoResult.getResult()
											.getStockAmountTody().toString());
									// 设置已销售数
									resultdata.setSoldNum(promotionSaleInfoResult.getResult().getSaleAmountToday().toString());
								}
							}
						}

					}
				}

			} else {

				// 设置优惠券
				createCoupon(stageMallGoodsDetailByAPPQuery, resultdata,
						promotionFlag, dto, date, malldate, malltime,resultdata.getGoodsModel());
			}
			app = BeanUtils.copy(resultdata, StageMallGoodsDetailByAPPVO.class);
			// 用户登录需要判断是否收藏
			if(!Strings.isNullOrEmpty(stageMallGoodsDetailByAPPQuery.getCustId())){
				// 1:收藏 0:未收藏
				Response<String> collectResponse = userFavoriteService.checkFavorite(app.getGoodsInfo()
						.get(0).getGoodsId(), stageMallGoodsDetailByAPPQuery.getCustId());
				if (response.isSuccess()) {
					app.setCollectStatus(collectResponse.getResult());
				}
			}

			List<StageMallGoodsDetailByAPPVO> infos = new ArrayList<StageMallGoodsDetailByAPPVO>();
			infos.add(app);

			appReturn.setInfos(infos);
			appReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			return appReturn;
		} else {
			appReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			appReturn.setReturnDes("查询商品失败");
			return appReturn;
		}
	}

	private void createCoupon(
			StageMallGoodsDetailByAPPQueryVO stageMallGoodsDetailByAPPQuery,
			AppGoodsDetailModel resultdata, boolean promotionFlag,
			MallPromotionResultDto dto, SimpleDateFormat date, String malldate,
			String malltime, GoodsModel goodsModel) {
		boolean canUseCoupon = true;
		// 设置活动状态
		// 当前价格market_price
		// 当前活动类型 团购2
		if (dto != null) {
			//如果已经登陆则查询是否设置过提醒
			if(!Strings.isNullOrEmpty(stageMallGoodsDetailByAPPQuery.getCustId())){
				EspActRemindModel espActRemindModel=new EspActRemindModel();
				espActRemindModel.setCustId(stageMallGoodsDetailByAPPQuery.getCustId());
				espActRemindModel.setActId(dto.getId().longValue());
				espActRemindModel.setGoodsId(stageMallGoodsDetailByAPPQuery.getGoodsId());
				Response<Boolean>  rt=espActRemindService.findIsRemidByGoods(espActRemindModel);
				if(rt.isSuccess()){
					if(rt.getResult()!=null&&rt.getResult()){
						resultdata.setRemindStatus("1");
					}else{
						resultdata.setRemindStatus("0");
					}
				}
			}
			Response<MallPromotionSaleInfoDto>  rs=mallPromotionService.findPromSaleInfoByPromId(dto.getId().toString(),dto.getPeriodId(),stageMallGoodsDetailByAPPQuery.getGoodsId());

			MallPromotionSaleInfoDto mallPromotionSaleInfoDto = new MallPromotionSaleInfoDto();
			if(rs.isSuccess() && rs.getResult()!=null){
				mallPromotionSaleInfoDto = rs.getResult();
			}
			if (40 == dto.getPromType()) {
				resultdata.setGoodsType("2");//设置团购类型
				//设置参团人数

				resultdata.setActionCount(mallPromotionSaleInfoDto.getSaleAmountToday()==null?"0":mallPromotionSaleInfoDto.getSaleAmountToday().toString());

			} else if (30 == dto.getPromType()) {// 数量和库存需要设置
				resultdata.setGoodsType("3");// 设置为秒杀
				if(dto.getPromItemResultList()!=null&&dto.getPromItemResultList().get(0)!=null&&dto.getPromItemResultList().get(0).getStock()!=null){
					Long actionStock=mallPromotionSaleInfoDto.getStockAmountTody() == null?0:mallPromotionSaleInfoDto.getStockAmountTody();//今天总库存
					Integer saleCount=mallPromotionSaleInfoDto.getSaleAmountToday()==null?0:mallPromotionSaleInfoDto.getSaleAmountToday();//活动的今天的销售数量
					Long goodsBackLog = actionStock - (long)saleCount;
					if(actionStock!=null){
						resultdata.setGoodsBacklog(goodsBackLog.toString());
						resultdata.setGoodsTotal(actionStock.toString());
						resultdata.getBacklogInfo().get(0).setGoodsBackLog(goodsBackLog.toString());
						resultdata.getBacklogInfo().get(0).setGoodsTotal(actionStock.toString());

					}
				}
				List<PromotionItemResultDto>  itemList=dto.getPromItemResultList();
				if(itemList!=null&&itemList.get(0)!=null){
					for (PromotionItemResultDto promotionItemResultDto : itemList) {
						if(promotionItemResultDto.getSelectCode().equals(stageMallGoodsDetailByAPPQuery.getGoodsId())){
							if(promotionItemResultDto.getPrice().compareTo(BigDecimal.ZERO)==0){
								//判断商品价格为0元设置为0元秒杀
								resultdata.setGoodsType("4");// 设置秒杀
								break;
							}
						}
					}
				}
			}
			resultdata.setMallDate(malldate);// 商城日期
			resultdata.setMallTime(malltime);// 商城时间
			// 开始时间
			SimpleDateFormat time = new SimpleDateFormat("HHmmss");
			if (promotionFlag) {
				resultdata.setActId(dto.getId() == null ? "" : dto.getId()
						.toString());
				resultdata.setActStatus("1");//xiewl 20161010 活动状态 0:未处理 1:进行中 2:活动未通过 3:活动停止
				String bgdate = date.format(dto.getBeginDate());
				String bgtime = time.format(dto.getBeginDate());
				resultdata.setActBeginDate(bgdate);
				resultdata.setActBeginTime(bgtime);
				String endate = date.format(dto.getEndDate());
				String entime = time.format(dto.getEndDate());
				resultdata.setActEndDate(endate);
				resultdata.setActEndTime(entime);
			}

			//判断活动是否可以使用优惠券
			if(dto.getPromItemResultList()!=null && !dto.getPromItemResultList().isEmpty()){
				String couponEnable = dto.getPromItemResultList().get(0).getCouponEnable() == null ? "0" : dto
						.getPromItemResultList().get(0).getCouponEnable().toString();
				if(!"1".equals(couponEnable)){//1可以 0不可以
					canUseCoupon = false;
				}
			}
		}

		// 优惠券查询
		if (canUseCoupon) {
			try {
				//没证件号，用户没登陆，不查询优惠券
				if(Strings.isNullOrEmpty(stageMallGoodsDetailByAPPQuery.getContIdcard())){
					return;
				}
				UserInfo user = new UserInfo();
				user.setCertNo(stageMallGoodsDetailByAPPQuery.getContIdcard());
				List<CouponInfo> returnList = orderChannelService.queryCouponInfo(null, user, goodsModel, null, false);
				String projectNo = "";
				if (returnList != null && returnList.size() > 0) {
					List<AppPrivilegeInfo> appPrivilegelist = new ArrayList<>();
					for (CouponInfo couponInfo : returnList) {
						if (couponInfo != null) {
							projectNo = couponInfo.getProjectNO();
							log.info("返回的项目编号:" + projectNo);
							if (projectNo != null && !"".equals(projectNo)) {
								// 小类 大类 供应商 优惠券号
								AppPrivilegeInfo appPrivilegeInfo = new AppPrivilegeInfo();

								BigDecimal privilegeMoney = couponInfo.getPrivilegeMoney();
								BigDecimal limitMoney = couponInfo.getLimitMoney();
								if(!Contants.CHANNEL_PHONE_CODE.equals(stageMallGoodsDetailByAPPQuery.getOrigin())){
									//除了手机银行，其他渠道都另外除了100，所以需要乘以100
									privilegeMoney = privilegeMoney.multiply(new BigDecimal(100));
									limitMoney = limitMoney.multiply(new BigDecimal(100));
								}
								String privilegeName = Strings.nullToEmpty(couponInfo.getPrivilegeName());
								String regulation = Strings.nullToEmpty(couponInfo.getRegulation());

								appPrivilegeInfo.setPrivilegeId(couponInfo.getPrivilegeId());
								appPrivilegeInfo.setPrivilegeName(privilegeName);
								appPrivilegeInfo.setProjectNO(couponInfo.getProjectNO());
								appPrivilegeInfo.setLiquidateRatio(couponInfo.getLiquidateRatio().doubleValue());
								appPrivilegeInfo.setPrivilegeMoney(privilegeMoney.setScale(0).doubleValue());
								appPrivilegeInfo.setUseActivatiState(couponInfo.getUseActivatiState());
								appPrivilegeInfo.setPastDueState(couponInfo.getPastDueState());
								appPrivilegeInfo.setLimitMoney(limitMoney.setScale(0).doubleValue());
								appPrivilegeInfo.setRegulation(regulation);
								appPrivilegeInfo.setBeginDate(couponInfo
										.getBeginDate());
								appPrivilegeInfo.setEndDate(couponInfo
										.getEndDate());
								appPrivilegelist.add(appPrivilegeInfo);
								log.info("优惠券查询成功："
										+ couponInfo.getPrivilegeId());
							}
						}
					}
					// 设置优惠券信息
					resultdata.setPrivilegeInfo(appPrivilegelist);
				}
			} catch (Exception e) {
				log.error("调用增值服务系统出现异常：", e);
			}
		}
	}

}
