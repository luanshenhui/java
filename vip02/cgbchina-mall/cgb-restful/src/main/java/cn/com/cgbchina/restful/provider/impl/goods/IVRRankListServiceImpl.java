package cn.com.cgbchina.restful.provider.impl.goods;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import com.spirit.category.model.FrontCategory;
import org.springframework.stereotype.Service;

import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GiftPartitionService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.related.model.CustLevelInfo;
import cn.com.cgbchina.related.service.RestACardCustToelectronbankService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListGoodsInfo;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListQuery;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListReturn;
import cn.com.cgbchina.rest.provider.service.goods.IVRRankListService;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class IVRRankListServiceImpl implements IVRRankListService {
	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;
	@Resource
	PointService pointService;
	@Resource
	RestOrderService restOrderService;
	@Resource
	RestACardCustToelectronbankService restACardCustToelectronbankService;
	@Resource
	GiftPartitionService giftPartitionService;
	@Resource
	LocalCardRelateService localCardRelateService;
	@Resource
	GoodsService goodsService;

	@Override
	public IVRRankListReturn getRankList(IVRRankListQuery iVRRankListQuery) {

		IVRRankListReturn res = new IVRRankListReturn();
		res.setChannelSN(MallReturnCode.CHANNELCN_CCAG);
		res.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
		res.setReturnDes("");
		res.setLoopCount("");
		res.setLoopTag("");
		res.setSuccessCode("01");
		List<IVRRankListGoodsInfo> ivrRankListGoodsInfos = Lists.newArrayList(); 
		String cardNbr = iVRRankListQuery.getCardNo();// 卡号
		String jfType = iVRRankListQuery.getJfType();// 积分类型
		Map<String ,String> pointsTypeMap = getIntegralNames();
		Map<String,String> memberLevelM = getMemberLevel();
		List<String> custLevelList = Lists.newArrayList();
		
		Response<CustLevelInfo> custlevelInfoResp = restACardCustToelectronbankService.getCustLevelInfoByCard(cardNbr);
		if (!custlevelInfoResp.isSuccess()) {
			log.error("Can't find cust level info, cardNo=" + cardNbr);
			custLevelList = queryCustInfoFromPointService(iVRRankListQuery.getCardNo() ,iVRRankListQuery.getJfType());
		} else {
			custLevelList = genCustLevelList(custlevelInfoResp.getResult().getMemberLevel());
		}

		Response<List<GoodsItemDto>> goodsItemDtoResp = restOrderService.findSaleRankByjfType(jfType);
		if (goodsItemDtoResp.isSuccess() && goodsItemDtoResp.getResult() !=null && !goodsItemDtoResp.getResult().isEmpty()) {
			List<GoodsItemDto> goodsItems = goodsItemDtoResp.getResult();
			//获取商品的前台类目
			Map<Long, FrontCategory> frontCategories =  getFrontCategories(goodsItems);
			for (GoodsItemDto goodsItemDto : goodsItems) {
				IVRRankListGoodsInfo info = newIVRRankListGoodsInfo();
				ItemModel itemModel =  goodsItemDto.getItemModel();
				if (itemModel != null && !Strings.isNullOrEmpty(itemModel.getCode())) {
					info.setGoodsId(itemModel.getXid());//五位虚拟编码
					info.setInventory(itemModel.getStock().toString());//库存
				}
				GoodsModel goodsModel = goodsItemDto.getGoodsModel();
				if (goodsModel != null ) {
					if (!Strings.isNullOrEmpty(goodsModel.getName())) {						
						info.setGoodsName(goodsModel.getName());						
					}
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
						info.setGoodsFType(frontCategory2 == null ? "" : frontCategory2.getName());// 礼品大类
						FrontCategory frontCategory3 = frontCategories.get(backCategory3Id);
						info.setGoodsCType(frontCategory3 == null ? "" : frontCategory3.getName());// 礼品小类
					}else{
						info.setGoodsFType("");// 礼品大类
						info.setGoodsCType("");// 礼品小类
					}
					info.setGoodsType(goodsModel.getGoodsType());//礼品类型
					String pointType = goodsModel.getPointsType();
					if (!Strings.isNullOrEmpty(pointType)) {					
						info.setJfType(pointType);//积分类型
						info.setJfTypeName(pointsTypeMap.get(pointType));//积分类型名称
					}
				}
				List<TblGoodsPaywayModel> payways = goodsItemDto.getTblGoodsPaywayModels();
				TblGoodsPaywayModel paywayBonus =  getCustTopLevelPaywayBonus(payways, custLevelList);
				if (paywayBonus != null) {
					String memberLevel = paywayBonus.getMemberLevel();
					if (!Strings.isNullOrEmpty(memberLevel)) {						
						info.setCusLevel(memberLevel);//会员等级
						info.setCusLevelName(memberLevelM.get(memberLevel));//会员等级中文名称
					}
					info.setCusPrice(paywayBonus.getGoodsPoint()== null ? "":paywayBonus.getGoodsPoint().toString());//会员价(积分)
					info.setPayCodeByM(paywayBonus.getPaywayCode()== null ? "":paywayBonus.getPaywayCode());//支付编码(会员价)
				}
				TblGoodsPaywayModel paywayCashAndBonus = getCustTopLevelPaywayBonusAndCush(payways);
				if (paywayCashAndBonus != null) {
					info.setIntergralPart(paywayCashAndBonus.getGoodsPoint()== null ? "":paywayCashAndBonus.getGoodsPoint().toString());//积分和现金的积分
					info.setMoneyPart(paywayBonus.getGoodsPrice()== null ? "":paywayBonus.getGoodsPrice().toString());//积分和现金的现金
					info.setPayCodeByBoth(paywayCashAndBonus.getPaywayCode()== null ? "":paywayCashAndBonus.getPaywayCode());//支付编码(积分和现金)					
				}
				ivrRankListGoodsInfos.add(info);
			}
		}else {
			res.setReturnCode(MallReturnCode.NotFound_Goods_Code);
			res.setReturnDes(MallReturnCode.NotFound_Goods_Des);
		}
		res.setIvrRankListGoodsInfos(ivrRankListGoodsInfos);
		res.setLoopTag("0000");
		res.setLoopCount(StringUtil.intToString(ivrRankListGoodsInfos.size(), 5));
		return res;
	}
	
	/**
	 * Description : 获取当前客户最高客户级别的礼品对应的【积分+现金】支付方式
	 * @param payways
	 * @return
	 */
	private TblGoodsPaywayModel getCustTopLevelPaywayBonusAndCush(List<TblGoodsPaywayModel> payways) {
		TblGoodsPaywayModel paywayBonusAndCush = new TblGoodsPaywayModel();
		if (payways != null) {
			for (TblGoodsPaywayModel payway : payways) {
				if (Contants.PAY_WAY_CODE_JFXJ.equals(payway.getPaywayCode())) {
					paywayBonusAndCush = payway;
				}
			}
		}
		return paywayBonusAndCush;
	}
	
	/**
	 * Description : 获取当前客户最高客户级别的礼品对应的【纯积分】支付方式
	 * 
	 * @param payways
	 * @return
	 */
	private TblGoodsPaywayModel getCustTopLevelPaywayBonus(List<TblGoodsPaywayModel> payways,
			List<String> custLevels) {
		TblGoodsPaywayModel custTopLevelPaywayBonus = new TblGoodsPaywayModel();
		if (payways != null && custLevels != null) {
			for (String custLevel : custLevels) {
				for (TblGoodsPaywayModel payway : payways) {
					if (custLevel.equals(payway.getMemberLevel())
							&& Contants.PAY_WAY_CODE_JF.equals(payway.getPaywayCode())) {
						if ( custLevel.equals(payway.getMemberLevel())) {// 客户等级与支付等级相等且为纯积分
							custTopLevelPaywayBonus= payway;
						}else if(custTopLevelPaywayBonus != null && custTopLevelPaywayBonus.getGoodsPoint() != null && custTopLevelPaywayBonus.getGoodsPoint() > 0) {
							if (payway.getGoodsPoint() < custTopLevelPaywayBonus.getGoodsPoint()) {// 对比支付积分取更低的
								custTopLevelPaywayBonus= payway;
							}
						}
					}
				}
			}
		}
		return custTopLevelPaywayBonus;
	}
	
	/**
	 * Description : 从积分系统获取用户等级
	 * 
	 * @param cardNo
	 * @param jfType
	 * @return
	 */
	private List<String> queryCustInfoFromPointService(String cardNo,String jfType) {
		QueryPointsInfo info = new QueryPointsInfo();
		info.setCardNo(cardNo);
		info.setJgId(jfType);
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
				}
			} else if (Contants.GOODS_LEVEL_CODE_2.equals(pointCustLevel)) {
				tempSet.add(Contants.MEMBER_LEVEL_TJ_CODE);
			}
		}
		custLevels.addAll(tempSet);
		return custLevels;
	}

	private List<String> genCustLevelList(String custLevel) {
		List<String> lt = new ArrayList<>();
		if (Contants.MEMBER_LEVEL_DJ_CODE.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_DJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_TJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_TJ_CODE.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_TJ_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_VIP_CODE);
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		} else {
			lt.add(Contants.MEMBER_LEVEL_JP_CODE);
		}
		return lt;
	}

	/**
	 * Description : 新建商品信息
	 * @return
	 */
	private IVRRankListGoodsInfo newIVRRankListGoodsInfo(){
		IVRRankListGoodsInfo info = new IVRRankListGoodsInfo();
		info.setGoodsId("");
		info.setGoodsName("");
		info.setGoodsFType("");
		info.setGoodsCType("");
		info.setCusLevel("");
		info.setCusLevelName("");
		info.setCusPrice("");
		info.setPayCodeByM("");
		info.setIntergralPart("");
		info.setMoneyPart("");
		info.setPayCodeByBoth("");
		info.setInventory("");
		info.setJfType("");
		info.setJfTypeName("");
		info.setGoodsType("");
		return info;
	}
	
	/**
	 * Description : 获取所有的会员等级
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
	 * @param goodsItemDtos
	 * @return
	 */
	private Map<Long, FrontCategory> getFrontCategories(List<GoodsItemDto> goodsItemDtos) {
		Map<Long, FrontCategory> map = Maps.newHashMap();
		List<Long> backCategoryIds = Lists.newArrayList();
		Set<Long> idSet = Sets.newHashSet();
		for (GoodsItemDto goodsItemDto : goodsItemDtos) {
			if (goodsItemDto != null && goodsItemDto.getGoodsModel() != null) {
				GoodsModel goodsModel = goodsItemDto.getGoodsModel();
				// 重新取得后台类目
                Long backCategory2Id = null;
                Long backCategory3Id = null;
                Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(goodsModel.getCode());
                if (pairResponse.isSuccess() && pairResponse.getResult() != null) {
                	List<Pair> pairList = pairResponse.getResult();
                	backCategory2Id = pairList.get(2).getId();
                	backCategory3Id = pairList.get(3).getId();
                }
				idSet.add(backCategory2Id);
				idSet.add(backCategory3Id);
			}
		}
		if (idSet.size() > 0) {
			backCategoryIds = Lists.newArrayList(idSet);
		}
//		Response<Map<Long, FrontCategory>> response = categoryMappingService.findFrontCategoryByBackCategoryIds(backCategoryIds, "JF");//指定为积分商品
//		if (response.isSuccess()) {
//			map = response.getResult();
//		}else {
//			log.error(response.getError());
//		}
		return map;
	}
}
