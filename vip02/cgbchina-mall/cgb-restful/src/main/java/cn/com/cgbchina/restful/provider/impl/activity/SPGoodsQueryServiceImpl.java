package cn.com.cgbchina.restful.provider.impl.activity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.elasticsearch.common.base.Strings;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.BatchDateUtil;
import cn.com.cgbchina.item.dto.SPGoodsDetailDto;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.dto.MallPromotionSaleInfoDto;
import cn.com.cgbchina.item.dto.PromItemDto;
import cn.com.cgbchina.item.dto.PromotionItemResultDto;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.related.service.CfgProCodeService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsInfo;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsQuery;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsReturn;
import cn.com.cgbchina.rest.provider.service.activity.SPGoodsQueryService;
import cn.com.cgbchina.user.service.UserFavoriteService;

import com.google.common.collect.Lists;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

/**
 * MAL335 特殊商品列表查询
 * 
 * @author huangchaoyong
 * 
 */
@Service
@Slf4j
public class SPGoodsQueryServiceImpl implements SPGoodsQueryService {
	@Resource
	private RestItemService restItemService;
	@Resource
	private UserFavoriteService userFavoriteService;
	@Resource
	private CfgProCodeService cfgProcodeService;
	@Resource
	private MallPromotionService mallPromotionService;
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private PromotionPayWayService promotionPayWayService;
	@Resource
	private PromotionService promotionService;

	@Override
	public SPGoodsReturn query(SPGoodsQuery spGoodsQuery) {
		SPGoodsReturn spGoodsReturn = new SPGoodsReturn();
		String origin = changeOrigin(dealNull(spGoodsQuery.getOrigin()));
		String beginNo = dealNull(spGoodsQuery.getBeginNo());
		String endNo = dealNull(spGoodsQuery.getEndNo());
		String queryType = dealNull(spGoodsQuery.getQueryType());
		String queryCondition = dealNull(spGoodsQuery.getQueryCondition());
		String custId = dealNull(spGoodsQuery.getCustId());
		String sequence = dealNull(spGoodsQuery.getSequence());

		// queryType=01：查询广发商城下品牌的新品上市，注意商城类型mallType=01
		// queryType=02：查询广发商城下品牌的限时抢购，注意商城类型mallType=01
		// queryType=03：查询广发商城下秒杀的场次的商品列表，注意商城类型mallType=01
		// queryType=04：查询积分商城下常规排行的礼品列表，注意商城类型mallType=02
		// queryType=05：查询广发商城下的置顶商品列表，注意商城类型mallType=01
		if ("04".equals(queryType)) {
			spGoodsReturn.setReturnCode("000008");
			spGoodsReturn.setReturnDes("暂不支持查询积分商城下常规排行的礼品列表");
			return spGoodsReturn;
		}
		if ("".equals(queryCondition)) {
			spGoodsReturn.setReturnCode("000008");
			spGoodsReturn.setReturnDes("查询条件必填");
			return spGoodsReturn;
		}

		// 对分页参数进行处理
		int beginNoInt = 1;
		int endNoInt = 1;
		if (!"".equals(beginNo)) {
			beginNoInt = Integer.parseInt(beginNo);
		}
		if (!"".equals(endNo)) {
			endNoInt = Integer.parseInt(endNo);
		}
		beginNoInt = beginNoInt == 0 ? 1 : beginNoInt;
		if (endNoInt < beginNoInt || endNoInt - beginNoInt >= 20) {
			spGoodsReturn.setReturnCode("000008");
			spGoodsReturn.setReturnDes("beginNo和endNo参数值不正确");
			return spGoodsReturn;
		}

		try {
			if ("03".equals(queryType)) {// 秒杀场次
				spGoodsReturn = findSeckillingGoodsList(origin, queryCondition, custId, beginNoInt, endNoInt);
			} else {
				// 根据不同的查询类型查询商品列表信息,并排序
				List<SPGoodsDetailDto> spGoodsDetails = findGoodsList(origin, queryType, queryCondition, sequence);

				// 分页信息
				int totalCount = spGoodsDetails.size();
				spGoodsReturn.setTotalCount(String.valueOf(totalCount));
				spGoodsReturn.setTotalPages(String.valueOf(calTotalPages(totalCount, beginNoInt, endNoInt)));

				// 开始组装循环体数据到报文中
				List<SPGoodsInfo> spGoodsInfos = new ArrayList<SPGoodsInfo>();
				for (SPGoodsDetailDto spGoodsDetailDto : spGoodsDetails) {
					String goodsId = spGoodsDetailDto.getGoodsId();
					// 根据goodsId、渠道获取该单品的活动信息
					Response<MallPromotionResultDto> promotionResponse = mallPromotionService.findPromByItemCodes("0",
							goodsId, origin);

					MallPromotionResultDto mallPromotionResultDto = null;
					PromotionItemResultDto promotionItemResultDto = null;
					if (promotionResponse.isSuccess()) {
						mallPromotionResultDto = promotionResponse.getResult();
						if (mallPromotionResultDto != null) {
							promotionItemResultDto = mallPromotionResultDto.getPromItemResultList().get(0);
						}
					}
					SPGoodsInfo spGoodsInfo = convertVo(spGoodsDetailDto, mallPromotionResultDto,
							promotionItemResultDto, custId);
					spGoodsInfos.add(spGoodsInfo);
				}
				
				// 对品牌商品进行排序
				if ("01".equals(queryType) || "02".equals(queryType)) {
					if ("01".equals(sequence)) {// 按照价格升序
						sort(spGoodsInfos, "price", "asc");
					} else if ("02".equals(sequence)) {// 按照价格降序
						sort(spGoodsInfos, "price", "desc");
					} else if ("03".equals(sequence)) {// 按照销量升序
						sort(spGoodsInfos, "count", "asc");
					} else if ("04".equals(sequence)) {// 按照销量降序
						sort(spGoodsInfos, "count", "desc");
					}
				}
				
				// 截取循环体数据
				List<SPGoodsInfo> spGoodsDetailDtos = new ArrayList<>();
				if(totalCount < beginNoInt){
					//取空集合
				}else{
					if (totalCount < endNoInt) {
						endNoInt = totalCount;
					}
					spGoodsDetailDtos = spGoodsInfos.subList(beginNoInt - 1, endNoInt);
				}
				
				spGoodsDetailDtos = subList(spGoodsDetailDtos);
				spGoodsReturn.setSpGoodsInfos(spGoodsDetailDtos);

			}

			
			// 商城时间
			Date mallDate = new Date();
			spGoodsReturn.setMallDate(BatchDateUtil.fmtDate(mallDate));
			spGoodsReturn.setMallTime(BatchDateUtil.fmtTime(mallDate));

			// 当请求查询置顶产品时，返回预设关键字
			if ("05".equals(queryType)) {
				Response<String> response = cfgProcodeService.findProcode("YG", "CP", "pre_keyword");
				if (response.isSuccess()) {
					String keyWord = response.getResult();
					spGoodsReturn.setKeyWord(dealNull(keyWord));
				}
			}
			spGoodsReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			spGoodsReturn.setReturnDes("查询成功");
		} catch (Exception e) {
			log.info("查询特殊商品列表信息出错", e);
			spGoodsReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			spGoodsReturn.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
		}

		return spGoodsReturn;
	}

	/**
	 * 查询品牌的新品上市、限时抢购商品和商城的置顶商品
	 * 
	 * @param origin
	 * @param queryType
	 * @param queryCondition
	 * @param sequence
	 * @return
	 */

	private List<SPGoodsDetailDto> findGoodsList(String origin, String queryType, String queryCondition, String sequence) {
		// 获取商品信息
		Response<List<SPGoodsDetailDto>> goodsRespone = restItemService.findSPGoodsDetail(origin, queryType,
				queryCondition);
		if (!goodsRespone.isSuccess()) {
			log.error("【MAL335】 特殊商品列表查询失败:" + goodsRespone.getError());
			throw new RuntimeException(goodsRespone.getError());
		}
		List<SPGoodsDetailDto> spGoodsDetailDtos = goodsRespone.getResult();

		return spGoodsDetailDtos;
	}

	/**
	 * 查询秒杀场次的商品列表
	 * 
	 * @param origin
	 * @param queryCondition
	 * @param custId
	 * @param endNoInt
	 * @param beginNoInt
	 * @return
	 */
	private SPGoodsReturn findSeckillingGoodsList(String origin, String queryCondition, String custId, int beginNoInt,
			int endNoInt) {
		SPGoodsReturn spGoodsReturn = new SPGoodsReturn();
		// 根据活动场次获取相应的活动商品
		Response<Pager<PromItemDto>> pagerResponse = promotionService.findRanges(Integer.valueOf(queryCondition), 1, null, null);
		
		if (!pagerResponse.isSuccess() || pagerResponse.getResult() == null) {
			//FIXME 由于营销平台传场次id246，环境没改场次，为了让app不报系统异常，查询不到的场次返回空商品列表
			log.error("【MAL335】 特殊商品列表查询活动信息失败:" + pagerResponse.getError());
			spGoodsReturn.setTotalCount("0");
			spGoodsReturn.setTotalPages("0");
			return spGoodsReturn;
		}

		List<PromItemDto> promItemDtos = pagerResponse.getResult().getData();

		// 该场次下没查到活动商品
		if (promItemDtos == null || promItemDtos.isEmpty()) {
			log.info("该场次下没查到符合的活动商品");
			spGoodsReturn.setTotalCount("0");
			spGoodsReturn.setTotalPages("0");
			return spGoodsReturn;
		}

		List<String> goodsIds = Lists.newArrayList();
		// 保存活动单品信息，便于调用
		for (PromItemDto promItemDto : promItemDtos) {
			String goodsId = promItemDto.getItemCode();
			goodsIds.add(goodsId);
		}

		// 通过活动商品goodsIds 获取商品信息
		Response<List<SPGoodsDetailDto>> goodsRespone = restItemService.findSPGoodsDetailByGoodsIds(origin, goodsIds);
		if (!goodsRespone.isSuccess()) {
			log.error("【MAL335】 特殊商品列表查询失败:" + goodsRespone.getError());
			throw new RuntimeException(goodsRespone.getError());
		}

		List<SPGoodsDetailDto> spGoodsDetailDtos = goodsRespone.getResult();

		if (spGoodsDetailDtos == null || spGoodsDetailDtos.isEmpty()) {
			log.info("该场次下没查到符合的活动商品");
			spGoodsReturn.setTotalCount("0");
			spGoodsReturn.setTotalPages("0");
			return spGoodsReturn;
		}

		// 分页信息
		int totalCount = spGoodsDetailDtos.size();
		spGoodsReturn.setTotalCount(String.valueOf(totalCount));
		spGoodsReturn.setTotalPages(String.valueOf(calTotalPages(totalCount, beginNoInt, endNoInt)));

		// 截取循环体数据
		List<SPGoodsDetailDto> goodsDetailDtos = new ArrayList<>();
		if(totalCount < beginNoInt){
			//取空集合
		}else{
			if (totalCount < endNoInt) {
				endNoInt = totalCount;
			}
			goodsDetailDtos = spGoodsDetailDtos.subList(beginNoInt - 1, endNoInt);
		}
		
		// 处理循环体数据
		List<SPGoodsInfo> spGoodsInfos = new ArrayList<SPGoodsInfo>();
		for (SPGoodsDetailDto spGoodsDetailDto : goodsDetailDtos) {
			String goodsId = spGoodsDetailDto.getGoodsId();
			// 根据goodsId、渠道获取该单品的活动信息
			Response<MallPromotionResultDto> promotionResponse = mallPromotionService.findPromByItemCodes("0",
					goodsId, origin);

			MallPromotionResultDto mallPromotionResultDto = null;
			PromotionItemResultDto promotionItemResultDto = null;
			if (promotionResponse.isSuccess()) {
				mallPromotionResultDto = promotionResponse.getResult();
				if (mallPromotionResultDto != null && mallPromotionResultDto.getPromItemResultList() != null) {
					promotionItemResultDto = mallPromotionResultDto.getPromItemResultList().get(0);
					SPGoodsInfo spGoodsInfo = convertVo(spGoodsDetailDto, mallPromotionResultDto, promotionItemResultDto,
							custId);
					spGoodsInfos.add(spGoodsInfo);
				}
			}
		}

		spGoodsReturn.setSpGoodsInfos(spGoodsInfos);
		return spGoodsReturn;
	}

	/**
	 * 组装报文循环体数据
	 * 
	 * @param spGoodsDetailDto
	 * @param custId
	 * @param origin
	 * @return
	 */
	private SPGoodsInfo convertVo(SPGoodsDetailDto spGoodsDetailDto, MallPromotionResultDto mallPromotionResultDto,
			PromotionItemResultDto promotionItemResultDto, String custId) {
		SPGoodsInfo spGoodsInfo = new SPGoodsInfo();

		spGoodsInfo.setGoodsId(dealNull(spGoodsDetailDto.getGoodsId()));
		spGoodsInfo.setGoodsNm(dealNull(spGoodsDetailDto.getGoodsNm()));
		spGoodsInfo.setGoodsMid(dealNull(spGoodsDetailDto.getGoodsMid()));
		spGoodsInfo.setGoodsOid(dealNull(spGoodsDetailDto.getGoodsOid()));
		spGoodsInfo.setGoodsXid(dealNull(spGoodsDetailDto.getGoodsXid()));
		spGoodsInfo.setPictureUrl(spGoodsDetailDto.getPictureUrl());

		// 查询最高分期支付方式
		Response<TblGoodsPaywayModel> stageInfoResponse = goodsPayWayService.findMaxGoodsPayway(spGoodsDetailDto
				.getGoodsId());
		if (stageInfoResponse.isSuccess()) {
			TblGoodsPaywayModel tblGoodsPaywayModel = stageInfoResponse.getResult();
			BigDecimal perStage = tblGoodsPaywayModel.getPerStage();
			spGoodsInfo.setStagesNum(dealNull(String.valueOf(tblGoodsPaywayModel.getStagesCode())));
			spGoodsInfo.setPerStage(dealNull(perStage == null ? null : perStage.toString()));
		}
		spGoodsInfo.setGoodsPrice(dealNull(spGoodsDetailDto.getGoodsPrice()));
		
		String marketPrice = "";
		String goodsBacklog = spGoodsDetailDto.getGoodsBacklog();
		String goodsTotal = spGoodsDetailDto.getGoodsTotal();
		String goodsActType = "1"; // 1-普通商品，2-团购，3-秒杀

		if (promotionItemResultDto != null) {// 判断是否为活动商品
			
			String actionType = mallPromotionResultDto.getPromType() == null ? "" : mallPromotionResultDto
					.getPromType().toString();
			
			// 如果是团购秒杀商品且维护了市场价，则给市场价,否则为空
			marketPrice = dealNull(spGoodsDetailDto.getMarketPrice());

			if ("".equals(marketPrice) || new BigDecimal(marketPrice).compareTo(BigDecimal.ZERO) == 0) {
				marketPrice = "";
			}
			
			// 团购和秒杀活动，否则算普通商品
			if(Contants.PROMOTION_PROM_TYPE_STRING_30.equals(actionType) || Contants.PROMOTION_PROM_TYPE_STRING_40.equals(actionType)){
				if (Contants.PROMOTION_PROM_TYPE_STRING_40.equals(actionType)) {// 团购
					goodsActType = "2";
				}

				if (Contants.PROMOTION_PROM_TYPE_STRING_30.equals(actionType)) {// 秒杀
					goodsActType = "3";
						
				    Response<MallPromotionSaleInfoDto> promotionSaleInfoResult = mallPromotionService.findPromSaleInfoByPromId(mallPromotionResultDto.getId()
						    .toString(), mallPromotionResultDto.getPeriodId(),spGoodsDetailDto.getGoodsId());
				    if (promotionSaleInfoResult.isSuccess() && promotionSaleInfoResult.getResult() != null) {
				    	MallPromotionSaleInfoDto mallPromotionSaleInfoDto = promotionSaleInfoResult.getResult();
				    	Long actionStock=mallPromotionSaleInfoDto.getStockAmountTody() == null?0:mallPromotionSaleInfoDto.getStockAmountTody();//今天总库存
					    Integer saleCount=mallPromotionSaleInfoDto.getSaleAmountToday()==null?0:mallPromotionSaleInfoDto.getSaleAmountToday();//活动的今天的销售数量
					    Long backLog = actionStock - (long)saleCount;
				    	goodsTotal = actionStock.toString();
				    	goodsBacklog = backLog.toString();
				    }
						
				}
				
				// 设置活动时间
				spGoodsInfo.setBeginDate(dealNull(BatchDateUtil.fmtDate(mallPromotionResultDto.getBeginDate())));
				spGoodsInfo.setBeginTime(dealNull(BatchDateUtil.fmtTime(mallPromotionResultDto.getBeginDate())));
				spGoodsInfo.setEndDate(dealNull(BatchDateUtil.fmtDate(mallPromotionResultDto.getEndDate())));
				spGoodsInfo.setEndTime(dealNull(BatchDateUtil.fmtDate(mallPromotionResultDto.getEndDate())));
				
				Response<PromotionPayWayModel> promotionPayWayResponse = promotionPayWayService.findMaxPromotionPayway(spGoodsDetailDto
						.getGoodsId(), promotionItemResultDto.getPromotionId().toString());
				// 如果是活动商品，设置活动价格
				if(promotionPayWayResponse.isSuccess() && promotionPayWayResponse.getResult() != null){
					PromotionPayWayModel promotionPayWayModel = promotionPayWayResponse.getResult();
					spGoodsInfo.setGoodsPrice(String.valueOf(promotionPayWayModel.getGoodsPrice()));
					BigDecimal perStage = promotionPayWayModel.getPerStage();
					spGoodsInfo.setStagesNum(dealNull(String.valueOf(promotionPayWayModel.getStagesCode())));
					spGoodsInfo.setPerStage(dealNull(perStage == null ? null : perStage.toString()));
				}
			}
			
		} else {
			spGoodsInfo.setBeginDate("");
			spGoodsInfo.setBeginTime("");
			spGoodsInfo.setEndDate("");
			spGoodsInfo.setEndTime("");
		}

		spGoodsInfo.setMarketPrice(marketPrice);
		spGoodsInfo.setGoodsBacklog(goodsBacklog);
		spGoodsInfo.setGoodsTotal(goodsTotal);
		spGoodsInfo.setGoodsActType(goodsActType);
		spGoodsInfo.setBestRate(dealNull(spGoodsDetailDto.getBestRate()));

		// 检验是否收藏
		String collectStatus = isCollect(spGoodsDetailDto.getGoodsId(), custId);
		spGoodsInfo.setCollectStatus(collectStatus);

		return spGoodsInfo;
	}

	/**
	 * 判断商品是否收藏
	 * 
	 * @param goodsId
	 * @param custId
	 * @return
	 */
	private String isCollect(String goodsId, String custId) {
		// 1:收藏 0:未收藏
		String collectStatus = "";
		if (!"".equals(custId)) {
			Response<String> response = userFavoriteService.checkFavorite(goodsId, custId);
			if (response.isSuccess()) {
				collectStatus = response.getResult();
			}
		}
		return collectStatus;
	}

	/**
	 * 转换微信渠道的"发起方" 发起方 微信广发银行：WX；微信信用卡中心：WS 对应数据库 微信广发银行：05；微信信用卡中心：06
	 */
	private String changeOrigin(String origin) {
		if ("WX".equals(origin)) {
			return "05";
		}
		if ("WS".equals(origin)) {
			return "06";
		}
		return origin;
	}

	/**
	 * 去null操作
	 * 
	 * @param str
	 * @return
	 */
	private static String dealNull(String str) {
		return str == null ? "" : str.trim();
	}

	/**
	 * 计算总页数
	 * 
	 * @param totalCount
	 * @param beginNoInt
	 * @param endNoInt
	 * @return
	 */
	private int calTotalPages(int totalCount, int beginNoInt, int endNoInt) {
		int pageSize = endNoInt - beginNoInt + 1;
		int pageCount = totalCount % pageSize == 0 ? totalCount / pageSize : totalCount / pageSize + 1;
		return pageCount;
	}

	/**
	 * 对商品列表排序
	 * 
	 * @param spGoodsInfos
	 * @param field
	 *            价格price、销量count
	 * @param sort
	 *            排序方式 desc降序，默认升序
	 */
	private void sort(List<SPGoodsInfo> spGoodsInfos, final String field, final String sort) {
		
		Collections.sort(spGoodsInfos, new Comparator<SPGoodsInfo>() {
			@Override
			public int compare(SPGoodsInfo goodsDetail1, SPGoodsInfo goodsDetail2) {
				int ret = 0;
				if ("price".equals(field)) {// 按价格排序
					BigDecimal goodsPrice1 = Strings.isNullOrEmpty(goodsDetail1.getGoodsPrice())? new BigDecimal(0) : new BigDecimal(goodsDetail1.getGoodsPrice());
					BigDecimal goodsPrice2 = Strings.isNullOrEmpty(goodsDetail2.getGoodsPrice())? new BigDecimal(0) : new BigDecimal(goodsDetail2.getGoodsPrice());
					if (sort != null && "desc".equals(sort)) {
						ret = goodsPrice2.compareTo(goodsPrice1);
					} else {
						ret = goodsPrice1.compareTo(goodsPrice2);
					}
				} else if ("count".equals(field)) {// 按销量排序
					String total1 = goodsDetail1.getGoodsTotal();
					String total2 = goodsDetail2.getGoodsTotal();
					String backlog1 = goodsDetail1.getGoodsBacklog();
					String backlog2 = goodsDetail1.getGoodsBacklog();
					Long sale1 = Long.parseLong(total1) - Long.parseLong(backlog1);
					Long sale2 = Long.parseLong(total2) - Long.parseLong(backlog2);
					if (sort != null && "desc".equals(sort)) {
						ret = sale2.compareTo(sale1);
					} else {
						ret = sale1.compareTo(sale2);
					}
				}
				return ret;
			}
		});
	}
	
	private <T> List<T> subList(List<T> list){
		ArrayList<T> result=new ArrayList<>();
		for(T t:list){
			result.add(t);
		}
		return result;
	}
	
}
