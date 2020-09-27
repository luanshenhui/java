package cn.com.cgbchina.restful.provider.impl.activity;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.spirit.common.model.Response;

import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.item.dto.GoodsDetailExtend;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQuery;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.activity.WXYXo2oGoodsQueryService;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL421 微信易信O2O0元秒杀商品详情查询
 * 
 * @author huangchaoyong
 * 
 */
@Service
@Slf4j
public class WXYXo2oGoodsQueryServiceImpl implements WXYXo2oGoodsQueryService {
	@Resource
	private RestItemService restItemService;
	@Resource
	private MallPromotionService mallPromotionService;
	@Resource
	private PromotionPayWayService promotionPayWayService;

	@Override
	public WXYXo2oGoodsQueryReturn query(WXYXo2oGoodsQuery wxYXo2oGoodsQuery) {
		WXYXo2oGoodsQueryReturn wxyXo2oGoodsQueryReturn = new WXYXo2oGoodsQueryReturn();
		try {
			// 发起方
			String sourceId = wxYXo2oGoodsQuery.getOrigin();
			String mid = wxYXo2oGoodsQuery.getGoodsMid();
			// 获取分期商品信息
			Response<GoodsDetailExtend> response = restItemService.findWXYXo2oGoodsDetail(mid);
			if (response.isSuccess()) {
				GoodsDetailExtend goodsDetailExtend = response.getResult();
				if (goodsDetailExtend != null) {
					String goodsId = goodsDetailExtend.getGoodsId();
					// 根据goodsId、渠道获取该单品的活动信息
					Response<MallPromotionResultDto> promotionResponse = mallPromotionService.findPromByItemCodes("0",
							goodsId, sourceId);
					if (!promotionResponse.isSuccess()) {
						throw new RuntimeException(promotionResponse.getError());
					}
					MallPromotionResultDto goodsPromotionDetailDto = promotionResponse.getResult();
					if (goodsPromotionDetailDto == null) {
						throw new RuntimeException("没查到活动信息");
					}

					// 获取一期支付方式
					Response<List<PromotionPayWayModel>> paywayResponse = promotionPayWayService
							.findPromotionByItemCode(goodsId, goodsPromotionDetailDto.getId());
					if (paywayResponse.isSuccess()) {
						for (PromotionPayWayModel promotionPayWayModel : paywayResponse.getResult()) {
							if (1 == promotionPayWayModel.getStagesCode()) {
								wxyXo2oGoodsQueryReturn.setPaywayIdY(promotionPayWayModel.getGoodsPaywayId());
								BigDecimal goodsPrice = promotionPayWayModel.getGoodsPrice();
								wxyXo2oGoodsQueryReturn
										.setGoodsPrice(goodsPrice == null ? null : goodsPrice.toString());
								break;
							}
						}
					}

					wxyXo2oGoodsQueryReturn.setGoodsId(goodsDetailExtend.getGoodsId());
					wxyXo2oGoodsQueryReturn.setGoodsNm(goodsDetailExtend.getGoodsNm());
					wxyXo2oGoodsQueryReturn.setGoodsMid(goodsDetailExtend.getGoodsMid());
					wxyXo2oGoodsQueryReturn.setGoodsColor(goodsDetailExtend.getGoodsColor());
					wxyXo2oGoodsQueryReturn.setGoodsSize(goodsDetailExtend.getGoodsSize());
					wxyXo2oGoodsQueryReturn.setGoodsBacklog(goodsDetailExtend.getGoodsBacklog());
					wxyXo2oGoodsQueryReturn.setGoodsDetailDesc(goodsDetailExtend.getGoodsDetailDesc());
					wxyXo2oGoodsQueryReturn.setMarketprice(goodsDetailExtend.getMarketPrice());
					// TODO 待处理
					wxyXo2oGoodsQueryReturn.setPictureUrl(goodsDetailExtend.getImage1());
					wxyXo2oGoodsQueryReturn.setGoodsDesc(goodsDetailExtend.getGoodsDesc());

					String buyingRestrictions = "";
					if ("0".equals(goodsPromotionDetailDto.getRuleLimitBuyType())) {
						buyingRestrictions = "1";
					} else if ("1".equals(goodsPromotionDetailDto.getRuleLimitBuyType())) {
						buyingRestrictions = "0";
					}
					wxyXo2oGoodsQueryReturn.setBuyingRestrictions(buyingRestrictions);
					wxyXo2oGoodsQueryReturn.setLimitedNumber(goodsPromotionDetailDto.getRuleLimitBuyCount().toString());

					// 活动日期
					String beginDate = BatchDateUtil.fmtDate(goodsPromotionDetailDto.getBeginDate());
					String endDate = BatchDateUtil.fmtDate(goodsPromotionDetailDto.getEndDate());
					wxyXo2oGoodsQueryReturn.setBeginDate(beginDate);
					wxyXo2oGoodsQueryReturn.setEndDate(endDate);
					PromotionItemResultDto promotionItemResultDto = goodsPromotionDetailDto.getPromItemResultList()
							.get(0);
					// 参加活动销量
					String stock = promotionItemResultDto.getStock().toString();
					// 活动频率与活动时间处理
					String loopType = goodsPromotionDetailDto.getLoopType();
					if (!Strings.isNullOrEmpty(loopType) && "d".equals(loopType)) {
						String actFrequency = doActFrequency(goodsPromotionDetailDto.getLoopData());
						wxyXo2oGoodsQueryReturn.setActFrequency(actFrequency);
						wxyXo2oGoodsQueryReturn
								.setBeginTime(BatchDateUtil.fmtTime(goodsPromotionDetailDto.getLoopBeginTime1()));
						wxyXo2oGoodsQueryReturn
								.setEndTime(BatchDateUtil.fmtTime(goodsPromotionDetailDto.getLoopEndTime1()));
						wxyXo2oGoodsQueryReturn
								.setBeginTime2(BatchDateUtil.fmtTime(goodsPromotionDetailDto.getLoopBeginTime2()));
						wxyXo2oGoodsQueryReturn
								.setEndTime2(BatchDateUtil.fmtTime(goodsPromotionDetailDto.getLoopEndTime2()));
						wxyXo2oGoodsQueryReturn.setGoodsCount(stock);
						wxyXo2oGoodsQueryReturn.setGoodsCount2(stock);
					} else {
						wxyXo2oGoodsQueryReturn.setActFrequency("");
						wxyXo2oGoodsQueryReturn
								.setBeginTime(BatchDateUtil.fmtTime(goodsPromotionDetailDto.getBeginDate()));
						wxyXo2oGoodsQueryReturn.setEndTime(BatchDateUtil.fmtTime(goodsPromotionDetailDto.getEndDate()));
						wxyXo2oGoodsQueryReturn.setBeginTime2("");
						wxyXo2oGoodsQueryReturn.setEndTime2("");
						wxyXo2oGoodsQueryReturn.setGoodsCount(stock);
						wxyXo2oGoodsQueryReturn.setGoodsCount2("");
					}

					wxyXo2oGoodsQueryReturn.setSourceId(sourceId);
					if ("05".equals(sourceId)) {
						wxyXo2oGoodsQueryReturn.setStatus(statusChange(goodsDetailExtend.getChannelMallWx()));
					} else if ("06".equals(sourceId)) {
						wxyXo2oGoodsQueryReturn.setStatus(statusChange(goodsDetailExtend.getChannelCreditWx()));
					}
					wxyXo2oGoodsQueryReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
				}
			} else {
				throw new RuntimeException(response.getError());
			}

		} catch (Exception e) {
			log.error("【MAL421】微信易信O2O0元秒杀商品详情查询 exception:", e);
			wxyXo2oGoodsQueryReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			wxyXo2oGoodsQueryReturn.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
		}
		return wxyXo2oGoodsQueryReturn;
	}

	/**
	 * 处理活动频率
	 * 
	 * @param loopData
	 * @return
	 */
	private static String doActFrequency(String loopData) {
		if (Strings.isNullOrEmpty(loopData)) {
			return "";
		}
		String actFrequency = "";
		List<String> days = Splitter.on(",").omitEmptyStrings().trimResults().splitToList(loopData);
		for (String day : days) {
			switch (day) {
			case "0":
				day = "2";
				break;
			case "1":
				day = "3";
				break;
			case "2":
				day = "4";
				break;
			case "3":
				day = "5";
				break;
			case "4":
				day = "6";
				break;
			case "5":
				day = "7";
				break;
			case "6":
				day = "1";
				break;
			default:
				break;
			}
			actFrequency += day;
		}
		return actFrequency;
	}

	/**
	 * 转换商品对应状态码
	 * @param status
	 * @return
	 */
	private String statusChange(String status) {
		String newStatus = "";
		if ("00".equals(status)){ // 处理中
			newStatus = "0202";
		}else if ("01".equals(status)){ // 在库
			newStatus = "0204";
		}else if ("02".equals(status)){ // 上架
			newStatus = "0203";
		}else {
			newStatus = status;
		}
		return newStatus;
	}
}
