/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.restful.provider.impl.goods;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.CCIntergalPresentParams;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GiftPartitionService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.related.model.CustLevelInfo;
import cn.com.cgbchina.related.service.RestACardCustToelectronbankService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresent;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentQuery;
import cn.com.cgbchina.rest.provider.model.goods.CCIntergalPresentReturn;
import cn.com.cgbchina.rest.provider.service.goods.CCIntergralPresentsQueryService;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;
import com.spirit.category.model.FrontCategory;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * MAL101 CC积分商城礼品列表查询 日期 : 2016-8-1<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-rest<br>
 * 功能 : <br>
 */
@Slf4j
@Service
public class CCIntergralPresentsQueryServiceImpl implements CCIntergralPresentsQueryService {

	private int pageSize = 30;// 每页条数
	@Resource
	RestItemService restItemService;
	@Resource
	RestACardCustToelectronbankService restACardCustToelectronbankService;
	@Resource
	PointService pointService;
	@Resource
	LocalCardRelateService localCardRelateService;
	@Resource
	GiftPartitionService giftPartitionService;
	@Resource
	GoodsService goodsService;

	@Override
	public CCIntergalPresentReturn query(CCIntergalPresentQuery ccIntergalPresentQueryObj) {
		// 查询商品列表信息
		CCIntergalPresentParams params = BeanUtils.copy(ccIntergalPresentQueryObj, CCIntergalPresentParams.class);
		CCIntergalPresentReturn presentReturn = new CCIntergalPresentReturn();
		if (!checkParams(params)) {
			presentReturn.setChannelSN("CAAG");
			presentReturn.setSuccessCode("00");
			presentReturn.setTotalPages("0");
			presentReturn.setCurPage(ccIntergalPresentQueryObj.getCurrentPage());
			presentReturn.setLoopTag("0000");
			presentReturn.setLoopCount("0");
			presentReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			presentReturn.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
			return presentReturn;
		}
		List<CCIntergalPresent> ccIntergalPresents = queryCCIntergalPresents(params);
		if (ccIntergalPresents != null && !ccIntergalPresents.isEmpty()) {		
			// 排序
			ccIntergalPresents = presentOrdering(ccIntergalPresents);
			// 分页
			List<List<CCIntergalPresent>> pages = Lists.partition(ccIntergalPresents, pageSize);
			String totalPages = String.valueOf(pages.size());
			// 报文信息
			int currentPage = Integer.valueOf(ccIntergalPresentQueryObj.getCurrentPage());
			int loop =  pageSize;//xiewl 20161012
	    	if (pages.size() > 0 && currentPage - 1 <= pages.size()) {
		    	presentReturn.setCcIntergalPresents(pages.get(currentPage - 1));
		    	loop = pages.get(currentPage - 1).size();
	    	}
			presentReturn.setTotalPages(totalPages);
			presentReturn.setChannelSN("CAAG");
			presentReturn.setSuccessCode("01");
			presentReturn.setCurPage(ccIntergalPresentQueryObj.getCurrentPage());
			presentReturn.setLoopTag("0000");
			String loopCount = StringUtil.intToString(loop, 5);//loopCount 表示当前页的记录数 xiewl 20161010
			presentReturn.setLoopCount(loopCount);
			presentReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			presentReturn.setReturnDes("");
			return presentReturn;
		}else {//没有商品数据
			presentReturn.setTotalPages("0");
			presentReturn.setChannelSN("CAAG");
			presentReturn.setSuccessCode("00");
			presentReturn.setCurPage(ccIntergalPresentQueryObj.getCurrentPage());
			presentReturn.setLoopTag("0000");
			String loopCount = StringUtil.intToString(ccIntergalPresents.size(), 5);
			presentReturn.setLoopCount(loopCount);
			presentReturn.setReturnCode(MallReturnCode.NotFound_Goods_Code);
			presentReturn.setReturnDes(MallReturnCode.NotFound_Goods_Des);
			return presentReturn;
		}
	}

	/**
	 * Description : 检查搜索参数是否合理
	 * 
	 * @param params
	 * @return true 合理 false 不合理
	 */
	private boolean checkParams(CCIntergalPresentParams params) {
		boolean flag = true;
		String cardNo = params.getCardNo();
		String jfType = params.getJfType();
		if (Strings.isNullOrEmpty(cardNo) || Strings.isNullOrEmpty(jfType) || Strings.isNullOrEmpty(cardNo.trim())) {
			flag = false;
		}
		String bonusRegions = params.getBonusRegion();
		if (!Strings.isNullOrEmpty(bonusRegions)) {
			if (bonusRegions.length() != 2) {
				flag = false;
			}
			if (!"00".equals(bonusRegions) && !"01".equals(bonusRegions) && !"02".equals(bonusRegions)
					&& !"03".equals(bonusRegions) && !"04".equals(bonusRegions)) {
				flag = false;
			}
		}
		String currentPage = params.getCurrentPage();
		try {
			Integer.parseInt(currentPage);
		} catch (Exception e) {
			flag = false;
			log.error("ccintergralpresentsqueryservice.error {}",e);
		}
		return flag;
	}

	/**
	 * Description : 查询商品列表
	 * 
	 * @param params
	 * @return
	 */
	private List<CCIntergalPresent> queryCCIntergalPresents(CCIntergalPresentParams params) {
		List<CCIntergalPresent> ccIntergalPresents = Lists.newArrayList();
		List<String> goodsIds = Lists.newArrayList();
		// donghb 0902 start
		List<String> goodsCodes = Lists.newArrayList();
		// items
		Response<List<ItemModel>> itemsResponse = restItemService.findItemsByCCIntergralPresent(params);
		List<ItemModel> items = Lists.newArrayList();
		if (itemsResponse.isSuccess()) {
			items = itemsResponse.getResult();
		}
		Set<String> goodCodesInItems = Sets.newHashSet();
		for (ItemModel i : items) {
			goodCodesInItems.add(i.getGoodsCode());
		}
		goodsIds.addAll(goodCodesInItems);
		// goods
		Response<List<GoodsModel>> goodsResponse = restItemService.findGoodsByCCIntergalPresent(params);
		List<GoodsModel> goodsModels = Lists.newArrayList();
		if (goodsResponse.isSuccess()) {
			goodsModels = goodsResponse.getResult();
		}
		Map<String, GoodsModel> goodsM = Maps.uniqueIndex(goodsModels, new Function<GoodsModel, String>() {
			@Override
			@Nullable
			public String apply(@Nullable GoodsModel g) {
				return g.getCode();
			}
		});
		goodsIds.retainAll(goodsM.keySet());
		// payWays
		Response<List<TblGoodsPaywayModel>> goodsPaywayResponse = restItemService
				.findPaywaysByCCIntergralPresent(params);
		List<TblGoodsPaywayModel> payways = Lists.newArrayList();
		if (goodsPaywayResponse.isSuccess()) {
			payways = goodsPaywayResponse.getResult();
		}
		for (String goodsId : goodsIds) {
			for (ItemModel model : items) {
				if (goodsId.equals(model.getGoodsCode())) {
					goodsCodes.add(model.getCode());
				}
			}
			
		}
		
		Set<String> goodCodesInPayways = Sets.newHashSet();
		for (TblGoodsPaywayModel i : payways) {
			goodCodesInPayways.add(i.getGoodsId());
		}
		goodsCodes.retainAll(goodCodesInPayways);
		// 获取当前客户最高级别的各种支付方式(纯积分，积分+现金，生日价)
		List<String> custLevels = Lists.newArrayList();
		boolean isBirthBay = false;
		Response<CustLevelInfo> response = restACardCustToelectronbankService
				.getCustLevelInfoByCard(params.getCardNo());
		if (!response.isSuccess() || response.getResult() == null ) {
			custLevels = queryCustInfoFromPointService(params);
		} else {
			custLevels = genCustLevelList(response.getResult().getMemberLevel());
			if (response.getResult().getBirthDay()!= null) {				
				isBirthBay = DateHelper.isBrithDay(response.getResult().getBirthDay());
			}
		}
		// 所有的payways
		Response<List<TblGoodsPaywayModel>> allPaywayResponse = restItemService.findPaywayByGoodsId(goodsCodes);
		// donghb 0902 end
		List<TblGoodsPaywayModel> allPayways = Lists.newArrayList();
		if (allPaywayResponse.isSuccess()) {
			allPayways = allPaywayResponse.getResult();
		}
		// 获取当前客户最高客户级别的礼品对应的【纯积分】支付方式
		Map<String, TblGoodsPaywayModel> topLevelPaywayBonus = getCustTopLevelPaywayBonus(allPayways, custLevels);
		// 获取当前客户最高客户级别的礼品对应的【积分+现金】支付方式
		Map<String, TblGoodsPaywayModel> topLevelPaywayBonusAndCash = getCustTopLevelPaywayBonusAndCush(allPayways);
		// 获取当前客户最高客户级别的礼品对应的【生日价】支付方式
		Map<String, TblGoodsPaywayModel> topLevelPaywayBirth = getCustTopLevelPaywayBirth(allPayways);
		// 获取所有的积分类型对应
		Map<String, String> integralNames = getIntegralNames();
		// 获取所有的会员等级编号名称对应
		Map<String, String> allMemberNameM = getMemberLevel();
		// 获取所有的前台类目id名称对应
		Map<Long, FrontCategory> frontCategories = getFrontCategories(goodsModels,params.getJfType());
		for (ItemModel item : items) {
			if (goodsIds.contains(item.getGoodsCode())) {
				GoodsModel goodsModel = goodsM.get(item.getGoodsCode());
				TblGoodsPaywayModel paywayBonus = topLevelPaywayBonus.get(item.getCode());
				TblGoodsPaywayModel paywayBounsAndCush = topLevelPaywayBonusAndCash.get(item.getCode());
				TblGoodsPaywayModel paywayBirth = topLevelPaywayBirth.get(item.getCode());
				if (goodsModel != null) {
					CCIntergalPresent ccIntergalPresent = newCCIntergalPresentWithBlank();
					ccIntergalPresent.setGoodsId(item.getXid());
					ccIntergalPresent.setGoodsName(goodsModel.getName());
					if (frontCategories != null && !frontCategories.isEmpty()) {
						// 重新取得后台类目
		                Long backCategory2Id = null;
		                Long backCategory3Id = null;
		                Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
		                if (pairResponse.isSuccess() && pairResponse.getResult() != null) {
		                	List<Pair> pairList = pairResponse.getResult();
		                	backCategory2Id = pairList.get(2).getId();
		                	backCategory3Id = pairList.get(3).getId();
		                }
						FrontCategory frontCategory2 = frontCategories.get(backCategory2Id);
						ccIntergalPresent.setGoodsFType(frontCategory2 == null ? "" : frontCategory2.getName());// 礼品大类
						FrontCategory frontCategory3 = frontCategories.get(backCategory3Id);
						ccIntergalPresent.setGoodsCType(frontCategory3 == null ? "" : frontCategory3.getName());// 礼品小类
					}else{
						ccIntergalPresent.setGoodsFType("");// 礼品大类
						ccIntergalPresent.setGoodsCType("");// 礼品小类
					}
					if (paywayBonus != null) {
						String memberLevel = paywayBonus.getMemberLevel();
						if (!Strings.isNullOrEmpty(memberLevel)) {
							ccIntergalPresent.setCusLevel(paywayBonus.getMemberLevel());// 会员等级
							String cusLevelName = allMemberNameM.get(memberLevel);
							cusLevelName = cusLevelName == null ? "" : cusLevelName;
							ccIntergalPresent.setCusLevelName(cusLevelName);// 会员等级中文名称
						}
						String cusPrice = paywayBonus.getGoodsPoint() == null ? "" : StringUtil.longToString(
								paywayBonus.getGoodsPoint(), 10);
						ccIntergalPresent.setCusPrice(cusPrice);// 会员价(积分)
						ccIntergalPresent.setPayCodeByM(paywayBonus.getGoodsPaywayId());// 支付编码(会员价)
					}
					if (isBirthBay) {
						if (paywayBirth != null) {
							String birthPrice = paywayBirth.getGoodsPoint() == null ? "" : StringUtil.longToString(
									paywayBirth.getGoodsPoint(), 10);
							ccIntergalPresent.setBirthPrice(birthPrice);// 生日价
							ccIntergalPresent.setPayCodeByB(paywayBirth.getGoodsPaywayId());// 支付编码(生日价)
						}
					}
					if (paywayBounsAndCush != null) {
						String intergralPart = paywayBounsAndCush.getGoodsPoint() == null ? "" : StringUtil
								.longToString(paywayBounsAndCush.getGoodsPoint(), 10);
						ccIntergalPresent.setIntergralPart(intergralPart);// 积分和现金的积分
						String moneyPart = paywayBounsAndCush.getGoodsPrice() == null ? "" : StringUtil
								.bigDecimalToString(paywayBounsAndCush.getGoodsPrice(), 10);
						ccIntergalPresent.setMoneyPart(moneyPart);// 积分和现金的现金
						ccIntergalPresent.setPayCodeByBoth(paywayBounsAndCush.getGoodsPaywayId());// 支付编码(积分和现金)
					}
					String stock = StringUtil.longToString(item.getStock(), 8);
					ccIntergalPresent.setInventory(stock);// 库存
					ccIntergalPresent.setJfType(goodsModel.getPointsType());// 积分类型
					String jfTypeName = integralNames.get(integralNames.get(goodsModel.getPointsType()));
					ccIntergalPresent.setJfTypeName(jfTypeName == null ? "" : jfTypeName);// 积分类型的中文名称
					// 数据库的类型为两位（实物、虚拟、O2O）接口为（0000 普通礼品  0001 虚拟礼品  0002 折价礼品  0003 特殊换礼礼品  0004 团购/秒杀礼品）
					// 现在商品类型是虚拟的为虚拟礼品，其余全为普通礼品
					if (Contants.SUB_ORDER_TYPE_01.equals(goodsModel.getGoodsType())) {
						ccIntergalPresent.setGoodsType("0001");// 礼品类型
					} else {
						ccIntergalPresent.setGoodsType("0000");// 礼品类型
					}
					String virtualLimit = item.getVirtualIntegralLimit() == null ? "" : String.valueOf(item
							.getVirtualIntegralLimit());
					ccIntergalPresent.setVirtualLimit(virtualLimit);// 限购
					String virtualMileage = item.getVirtualLimit() == null ? "" : String
							.valueOf(item.getVirtualLimit());
					ccIntergalPresent.setVirtualMileage(virtualMileage);// 里程
					ccIntergalPresent.setGoodsBid(item.getBid());// 礼品代号
					String virtualPrice = item.getVirtualPrice() == null ? "" : StringUtil
							.bigDecimalToString(item.getVirtualPrice(), 10);
					ccIntergalPresent.setVirtualPrice(virtualPrice);// 兑换金额
					ccIntergalPresents.add(ccIntergalPresent);
				}
			}
		}
		return ccIntergalPresents;
	}

	/**
	 * Description : 获取当前客户最高客户级别的礼品对应的【积分+现金】支付方式
	 * 
	 * @param allPayways
	 * @return
	 */
	private Map<String, TblGoodsPaywayModel> getCustTopLevelPaywayBonusAndCush(List<TblGoodsPaywayModel> allPayways) {
		Map<String, TblGoodsPaywayModel> paywayBonusAndCush = Maps.newHashMap();
		if (allPayways != null) {
			for (TblGoodsPaywayModel payway : allPayways) {
				if (Contants.PAY_WAY_CODE_JFXJ.equals(payway.getPaywayCode())) {
					paywayBonusAndCush.put(payway.getGoodsId(), payway);
				}
			}
		}
		return paywayBonusAndCush;
	}

	/**
	 * Description : 获取当前客户最高客户级别的礼品对应的【生日价】支付方式
	 * 
	 * @param allPayways
	 * @return
	 */
	private Map<String, TblGoodsPaywayModel> getCustTopLevelPaywayBirth(List<TblGoodsPaywayModel> allPayways) {
		Map<String, TblGoodsPaywayModel> paywayBirth = Maps.newHashMap();
		if (allPayways != null) {
			for (TblGoodsPaywayModel payway : allPayways) {
				if ("1".equals(payway.getIsBirth())) {
					paywayBirth.put(payway.getGoodsId(), payway);
				}
			}
		}
		return paywayBirth;
	}

	/**
	 * Description : 获取当前客户最高客户级别的礼品对应的【纯积分】支付方式
	 * 
	 * @param allPayways
	 * @return
	 */
	private Map<String, TblGoodsPaywayModel> getCustTopLevelPaywayBonus(List<TblGoodsPaywayModel> allPayways,
			List<String> custLevels) {
		Map<String, TblGoodsPaywayModel> custTopLevelPaywayBonus = Maps.newHashMap();
		if (allPayways != null && custLevels != null) {
			for (String custLevel : custLevels) {
				for (TblGoodsPaywayModel payway : allPayways) {
					if (custLevel.equals(payway.getMemberLevel())
							&& Contants.PAY_WAY_CODE_JF.equals(payway.getPaywayCode())) {
						TblGoodsPaywayModel addPayway = custTopLevelPaywayBonus.get(payway.getGoodsId());
						if (addPayway == null && custLevel.equals(payway.getMemberLevel())) {// 客户等级与支付等级相等且为纯积分
							custTopLevelPaywayBonus.put(payway.getGoodsId(), payway);
						} else if (payway.getGoodsPoint() < addPayway.getGoodsPoint()) {// 对比支付积分取更低的
							custTopLevelPaywayBonus.put(addPayway.getGoodsId(), addPayway);
						}
					}
				}
			}
		}
		return custTopLevelPaywayBonus;
	}

	/**
	 * Description : 排序
	 * 
	 * @param ccIntergalPresents
	 * @return
	 */
	private List<CCIntergalPresent> presentOrdering(List<CCIntergalPresent> ccIntergalPresents) {
		Ordering<CCIntergalPresent> ordering = Ordering.natural().onResultOf(new Function<CCIntergalPresent, Long>() {
			@Override
			@Nullable
			public Long apply(@Nullable CCIntergalPresent p) {
				return p.getGoodsPoint() == null ? new Long(0) : p.getGoodsPoint();
			}
		});
		return ordering.sortedCopy(ccIntergalPresents);
	}

	/**
	 * Description : 从积分系统获取用户等级
	 * 
	 * @param params
	 * @return
	 */
	private List<String> queryCustInfoFromPointService(CCIntergalPresentParams params) {
		QueryPointsInfo info = new QueryPointsInfo();
		info.setCardNo(params.getCardNo());
		info.setJgId(params.getJfType());
		List<String> custLevels = Lists.newArrayList();
		List<String> productCodes = Lists.newArrayList();
		List<String> levels = Lists.newArrayList();
		int curPage = 0;
		int totalPage = 1;
		while (curPage < totalPage) {
			String curPageStr;
			if (curPage < 10) {
				curPageStr = "000" + curPage;
			} else if (curPage < 100) {
				curPageStr = "00" + curPage;
			} else if (curPage < 1000) {
				curPageStr = "0" + curPage;
			} else {
				curPageStr = "" + curPage;
			}
			info.setCurrentPage(curPageStr);
			QueryPointResult queryPointResult = pointService.queryPoint(info);
			List<QueryPointsInfoResult> pointsInfoResults = queryPointResult.getQueryPointsInfoResults();
			productCodes.addAll(getProducts(pointsInfoResults));
			levels.addAll(getLevels(pointsInfoResults));
			String totalPageStr = queryPointResult.getTotalPages();
			try {
				totalPage = Integer.valueOf(totalPageStr);
			} catch (Exception e) {
				log.error("query point error :{}", e);
			}
			curPage++;
		}
		custLevels = getCustLevelStr(levels, productCodes);
		return custLevels;
	}

	/**
	 * Description : 从积分系统 组装客户等级
	 *
	 * @param pointCustLevels
	 * @param productCodes
	 * @return
	 */
	private List<String> getCustLevelStr(List<String> pointCustLevels, List<String> productCodes) {
		Set<String> tempSet = Sets.newHashSet();
		List<String> custLevels = Lists.newArrayList();
		for (int i = 0; i < pointCustLevels.size(); i++) {
			String pointCustLevel = pointCustLevels.get(i);
			if (Contants.GOODS_LEVEL_CODE_3.equals(pointCustLevel)) {
				tempSet.add(Contants.MEMBER_LEVEL_DJ_CODE);
				break;
			} else if (Contants.GOODS_LEVEL_CODE_3.equals(pointCustLevel)) {
				String productCode = productCodes.get(i);
				Response<LocalCardRelateModel> response = localCardRelateService.findByFormatId(productCode);
				if (response.isSuccess()) {
					LocalCardRelateModel localCardRelateModel = response.getResult();
					if (localCardRelateModel != null && localCardRelateModel.getProCode() != null
							&& Contants.GOODS_LEVEL_CODE_2.equals(localCardRelateModel.getProCode())) {
						tempSet.add(Contants.MEMBER_LEVEL_DJ_CODE);
						break;
					} else {
						tempSet.add(Contants.MEMBER_LEVEL_TJ_CODE);
					}
				} else {
					tempSet.add(Contants.MEMBER_LEVEL_TJ_CODE);
				}
			} else if (Contants.GOODS_LEVEL_CODE_2.equals(pointCustLevel)) {
				tempSet.add(Contants.MEMBER_LEVEL_TJ_CODE);
			}else {
				tempSet.add(Contants.MEMBER_LEVEL_JP_CODE);
			}
		}
		custLevels.addAll(tempSet);
		return custLevels;
	}

	private List<String> getLevels(List<QueryPointsInfoResult> pointsInfoResults) {
		List<String> levels = Lists.newArrayList();
		levels = Lists.transform(pointsInfoResults, new Function<QueryPointsInfoResult, String>() {
			@Override
			@Nullable
			public String apply(@Nullable QueryPointsInfoResult r) {
				return r.getLevelCode() == null ? "" : r.getLevelCode();
			}
		});
		return levels;
	}

	/**
	 * Description : 从积分系统中
	 * 
	 * @param pointsInfoResults
	 * @return
	 */
	private List<String> getProducts(List<QueryPointsInfoResult> pointsInfoResults) {
		List<String> products = Lists.newArrayList();
		products = Lists.transform(pointsInfoResults, new Function<QueryPointsInfoResult, String>() {
			@Override
			@Nullable
			public String apply(@Nullable QueryPointsInfoResult r) {
				return r.getProductCode() == null ? "" : r.getProductCode();
			}
		});
		return products;
	}

	private List<String> genCustLevelList(String memberLevel) {
		List<String> lt = new ArrayList<>();
		if (Contants.MEMBER_LEVEL_DJ_CODE.equals(memberLevel)) {
			lt.add(Contants.MEMBER_LEVEL_DJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_TJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(memberLevel)) {
			lt.add(Contants.MEMBER_LEVEL_TJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(memberLevel)) {
			lt.add(Contants.MEMBER_LEVEL_VIP_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else {
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		}
		return lt;
	}

	/**
	 * Description : 新建类，其中所有属性带空字符串
	 * 
	 * @return
	 */
	private CCIntergalPresent newCCIntergalPresentWithBlank() {
		CCIntergalPresent cCIntergalPresent = new CCIntergalPresent();
		cCIntergalPresent.setGoodsId("");
		cCIntergalPresent.setGoodsName("");
		cCIntergalPresent.setGoodsFType("");// 礼品大类
		cCIntergalPresent.setGoodsCType("");// 礼品小类
		cCIntergalPresent.setCusLevel("");// 会员等级
		cCIntergalPresent.setCusLevelName("");// 会员等级中文名称
		cCIntergalPresent.setCusPrice("");// 会员价(积分)
		cCIntergalPresent.setPayCodeByM("");// 支付编码(会员价)
		cCIntergalPresent.setBirthPrice("");// 生日价
		cCIntergalPresent.setPayCodeByB("");// 支付编码(生日价)
		cCIntergalPresent.setIntergralPart("");// 积分和现金的积分
		cCIntergalPresent.setMoneyPart("");// 积分和现金的现金
		cCIntergalPresent.setPayCodeByBoth("");// 支付编码(积分和现金)
		cCIntergalPresent.setInventory("");// 库存
		cCIntergalPresent.setJfType("");// 积分类型
		cCIntergalPresent.setJfTypeName("");// 积分类型的中文名称
		cCIntergalPresent.setGoodsType("");// 礼品类型
		cCIntergalPresent.setVirtualLimit("");// 限购
		cCIntergalPresent.setVirtualMileage("");// 里程
		cCIntergalPresent.setGoodsBid("");// 礼品代号
		cCIntergalPresent.setVirtualPrice("");// 兑换金额
		return cCIntergalPresent;
	}

	/**
	 * Description : 获取所有的会员等级
	 * 
	 * @return
	 */
	private Map<String, String> getMemberLevel() {
		Map<String, String> memberLevel = Maps.newHashMap();
		memberLevel.put(Contants.MEMBER_LEVEL_JP_CODE, Contants.MEMBER_LEVEL_JP_NM);
		memberLevel.put(Contants.MEMBER_LEVEL_TJ_CODE, Contants.MEMBER_LEVEL_TJ_NM);
		memberLevel.put(Contants.MEMBER_LEVEL_DJ_CODE, Contants.MEMBER_LEVEL_DJ_NM);
		memberLevel.put(Contants.MEMBER_LEVEL_VIP_CODE, Contants.MEMBER_LEVEL_VIP_NM);
		memberLevel.put(Contants.MEMBER_LEVEL_BIRTH_CODE, Contants.MEMBER_LEVEL_BIRTH_NM);
		return memberLevel;
	}

	/**
	 * Description : 获取所有积分类型
	 * 
	 * @return
	 */
	private Map<String, String> getIntegralNames() {
		Map<String, String> integralNames = Maps.newHashMap();
		Response<List<TblCfgIntegraltypeModel>> integralTypesResponse = giftPartitionService.findPointsTypeName();
		if (integralTypesResponse.isSuccess()) {
			List<TblCfgIntegraltypeModel> integralTypes = integralTypesResponse.getResult();
			for (TblCfgIntegraltypeModel i : integralTypes) {
				integralNames.put(i.getIntegraltypeId(), i.getIntegraltypeNm());
			}
		}
		return integralNames;
	}
	
	/**
	 * Description : 根据前台类目获取后台类目
	 * @param goodsModels
	 * @param orderType
	 * @return
	 */
	private Map<Long, FrontCategory> getFrontCategories(List<GoodsModel> goodsModels,String orderType) {
		Map<Long, FrontCategory> map = Maps.newHashMap();
		List<Long> backCategoryIds = Lists.newArrayList();
		Set<Long> idSet = Sets.newHashSet();
		if ("1".equals(orderType)) {
			orderType = null; //必须为null  后台方法规定
		}else {
			orderType = "JF";
		}
		for (GoodsModel goodsModel : goodsModels) {
			// 重新取得后台类目
            Long backCategory2Id = null;
            Long backCategory3Id = null;
            Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
            if (pairResponse.isSuccess() && pairResponse.getResult() != null && pairResponse.getResult().size() >= 4) {
            	List<Pair> pairList = pairResponse.getResult();
            	backCategory2Id = pairList.get(2).getId();
            	backCategory3Id = pairList.get(3).getId();
            }
			idSet.add(backCategory2Id);
			idSet.add(backCategory3Id);
		}
		if (idSet.size() > 0) {
			backCategoryIds = Lists.newArrayList(idSet);
		}
//		Response<Map<Long, FrontCategory>> response = categoryMappingService.findFrontCategoryByBackCategoryIds(backCategoryIds, orderType);
//		if (response.isSuccess()) {
//			map = response.getResult();
//		}else {
//			log.error(response.getError());
//		}
		return map;
	}

}
