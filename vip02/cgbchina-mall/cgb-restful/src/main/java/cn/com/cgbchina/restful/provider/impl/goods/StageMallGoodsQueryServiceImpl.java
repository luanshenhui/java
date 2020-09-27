/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.restful.provider.impl.goods;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.dto.ItemRichDto;
import cn.com.cgbchina.item.dto.ItemSearchFactDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemSearchService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.item.service.PromotionService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQueryInfo;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsQueryService;
import cn.com.cgbchina.user.service.UserFavoriteService;

import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.Response;

/**
 * 接口312 : 商品搜索列表 日期 : 2016-7-19<br>
 * 作者 : xiewenliang<br>
 * 项目 : cgb-rest<br>
 * 功能 : <br>
 */
@Service
@Slf4j
public class StageMallGoodsQueryServiceImpl implements StageMallGoodsQueryService {

	@Resource
	RestItemService restItemService;
	@Resource
	GoodsService goodsService;
	@Resource
	BackCategoryService backCategoriesService;
	@Resource
	PromotionService promotionService;
	@Resource
	UserFavoriteService userFavoriteService;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	ItemSearchService itemSearchService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	ItemService itemService;
	@Resource
	PromotionPayWayService promotionPayWayService;
	
	private final static Splitter splitter = Splitter.on('|').trimResults().omitEmptyStrings();

	@Override
	public StageMallGoodsQueryReturn query(StageMallGoodsQuery stageMallGoodsQuery) {
		StageMallGoodsQueryReturn stageMallGoodsQueryReturn = new StageMallGoodsQueryReturn();
		stageMallGoodsQueryReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
		stageMallGoodsQueryReturn.setAreaNm("");
		stageMallGoodsQueryReturn.setReturnDes("");
		try {

			stageMallGoodsQueryReturn = getGoodsInfosBySearch(stageMallGoodsQueryReturn, stageMallGoodsQuery);

		} catch (Exception e) {
			log.error("获取信息出错：" , e);
			stageMallGoodsQueryReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			stageMallGoodsQueryReturn.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
		}
		return stageMallGoodsQueryReturn;
	}
	
	/**
	 * 新改方法：通过搜索引擎获取查询商品信息1
	 * @param queryReturn
	 * @param stageMallGoodsQuery
	 * @return
	 */
	private StageMallGoodsQueryReturn getGoodsInfosBySearch(StageMallGoodsQueryReturn queryReturn,StageMallGoodsQuery stageMallGoodsQuery){				
		int pageNo = Strings.isNullOrEmpty(stageMallGoodsQuery.getCurrentPage()) ? 1 : Integer.valueOf(stageMallGoodsQuery.getCurrentPage());
		int size = Integer.valueOf(stageMallGoodsQuery.getRowsPage());
		// 调用搜索的参数
		Map<String, String> params = Maps.newHashMap();
		// 商城类型
		String mallType = stageMallGoodsQuery.getMallType();
		// 搜索条件
		String query = stageMallGoodsQuery.getQuery();
		String regex = "^[a-z0-9A-Z]+$";
		// 渠道
		String orgin = stageMallGoodsQuery.getOrigin();
		if (Contants.CHANNEL_SN_WX.equals(orgin)) {			
			params.put("c_t", "05");
		} else if (Contants.CHANNEL_SN_WS.equals(orgin)) {
			params.put("c_t", "06");
		} else if (Contants.CHANNEL_APP_CODE.equals(orgin)) {
			params.put("c_t", "09");
		} else {
			params.put("c_t", "03");
		}
		// 搜索类型
		String searchType = stageMallGoodsQuery.getGoodsType();
		if (Strings.isNullOrEmpty(searchType) || "0".equals(searchType) || "1".equals(searchType)) {
			params.put("p_t", "0");
		} else if ("2".equals(searchType)) {
			params.put("p_t", "4");
		} else if ("3".equals(searchType)) {
			params.put("p_t", "3");
		}
		if("01".equals(mallType)){ // 分期
			params.put("b_t", Contants.BUSINESS_TYPE_YG); // 广发商城
			if (!Strings.isNullOrEmpty(query) && query.matches(regex) && query.length() == 5) {
				params.put("m_i", query);
			} else {
				params.put("keywords", query);
			}
		}else{
			params.put("b_t", Contants.BUSINESS_TYPE_JF); // 积分商城
			if (!Strings.isNullOrEmpty(query) && query.matches(regex) && query.length() == 5) {
				params.put("x_i", query);
			} else {
				params.put("keywords", stageMallGoodsQuery.getQuery());
			}
		}
		
		String typeId = stageMallGoodsQuery.getTypeId(); // 类型id
		String typePid = stageMallGoodsQuery.getTypePid(); // 类型父id
		if(!Strings.isNullOrEmpty(typeId)){
			params.put("fcid", typeId);
		}else if(!Strings.isNullOrEmpty(typePid)){
			params.put("fcid", typePid);
		}
		
		// 排序 (排序规则)
		String sort = stageMallGoodsQuery.getSequence();
		if (Contants.CHANNEL_SN_WX.equals(orgin) || Contants.CHANNEL_SN_WS.equals(orgin)) {
			params.put("sort", "0_0_0_1");
		} else {
			if ("1".equals(sort)) {
				params.put("sort", "0_0_1");
			} else if ("2".equals(sort)) {
				params.put("sort", "0_1_0");
			} else if ("3".equals(sort)) {
				params.put("sort", "0_2_0");
			} else if ("4".equals(sort)) {
				params.put("sort", "1_0_0");
			} else if ("5".equals(sort)) {
				params.put("sort", "2_0_0");
			} else {
				params.put("sort", "0_0_2");
			}
		}

		String point = stageMallGoodsQuery.getQuerybyPoint(); // 积分段查询（手机客户端）
		if ("0".equals(point)) {
			// 0，10000以下
			params.put("q_f", "0");
			params.put("q_t", "9999");			
		} else if ("1".equals(point)) {
			// 1，10000分-49999分
			params.put("q_f", "10000");
			params.put("q_t", "49999");
		} else if ("2".equals(point)) {
			// 2，50000分-99999分
			params.put("q_f", "50000");
			params.put("q_t", "99999");
		} else if ("3".equals(point)) {
			// 3，100000分-199999分
			params.put("q_f", "100000");
			params.put("q_t", "199999");
		} else if ("4".equals(point)) {
			// 4，200000分以上
			params.put("q_f", "200000");
			params.put("q_t", "");
		}
		if (!Strings.isNullOrEmpty(stageMallGoodsQuery.getQuerybyArea())) {
			params.put("r_t", stageMallGoodsQuery.getQuerybyArea()); // 按分区查询
		}
					
		// 可输入积分查询: 起始积分和终止积分以“|”作为分隔符，起始积分、终止积分为空或者是大于等于0的整数（APP渠道使用）
		String pointRange = stageMallGoodsQuery.getQuerybyPointRange();
		if(!Strings.isNullOrEmpty(pointRange)){
			List<String> parts = splitter.splitToList(pointRange);
			params.put("q_f", parts.get(0));
			params.put("q_t", parts.get(1));			
		}
		
		Response<ItemSearchFactDto> result = itemSearchService.itemSearch(pageNo, size, params);
		if(result.isSuccess()){
			// 搜索结果数据
			ItemSearchFactDto searchDto = result.getResult();
			List<ItemRichDto> resultDtos = searchDto.getResultDtos();
			List<StageMallGoodsQueryInfo> infos = Lists.newArrayList();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			SimpleDateFormat sdf1 = new SimpleDateFormat("HHmmss");
			
			for (ItemRichDto item : resultDtos) {
				StageMallGoodsQueryInfo info = new StageMallGoodsQueryInfo();
				// 根据是否有客户号，显示收藏状态
				if (stageMallGoodsQuery.getCustId() != null) {
					Response<String> response = userFavoriteService.checkFavorite(item.getCode(),stageMallGoodsQuery.getCustId());
					if (response.isSuccess()) {
						// 1:收藏 0:未收藏
						info.setCollectStatus(response.getResult());
					}
				}
				info.setGoodsMid(item.getMid() == null ? "" : item.getMid());
				info.setGoodsOid(item.getOid() == null ? "" : item.getOid());
				info.setGoodsXid(item.getXid() == null ? "" : item.getXid());
				info.setMarketPrice(item.getMarketPrice() == null ? "" : String.valueOf(item.getMarketPrice()));
				// 总库存
				long amount = item.getGoodsTotal() + item.getStock();
				info.setGoodsTotal(Long.toString(amount));
				info.setBestRate(Double.valueOf(String.valueOf(item.getBestRate() == null ? 0 : item.getBestRate())));
				info.setGoodsId(item.getCode());
				info.setGoodsNm(item.getName());
				info.setGoodsType(item.getGoodsType());
				info.setGoodsActType("1");				
				info.setPictureUrl(item.getImage1() == null ? "" : item.getImage1());
				String sourceId = "";
				if (Contants.CHANNEL_SN_WX.equals(orgin)) {
					sourceId = "05";
					info.setUpdate(item.getOnShelfMallWxDate());
					if(item.getMallWxPromoType() == 30){ // 秒杀
						info.setGoodsActType("3");
					} else if(item.getMallWxPromoType() == 40){ // 团购
						info.setGoodsActType("2");
					}	
				} else if (Contants.CHANNEL_SN_WS.equals(orgin)) {
					sourceId = "06";
					info.setUpdate(item.getOnShelfCreditWxDate());
					if(item.getCreditWxPromoType() == 30){ // 秒杀
						info.setGoodsActType("3");
					} else if(item.getCreditWxPromoType() == 40){ // 团购
						info.setGoodsActType("2");
					}
				} else if (Contants.CHANNEL_APP_CODE.equals(orgin)) {
					sourceId = orgin;
					info.setUpdate(item.getOnShelfAppDate());
					if(item.getAppPromoType() == 30){ // 秒杀
						info.setGoodsActType("3");
					} else if(item.getAppPromoType() == 40){ // 团购
						info.setGoodsActType("2");
					}
				} else {
					sourceId = orgin;
					info.setUpdate(item.getOnShelfPhoneDate());
					if(item.getPhonePromoType() == 30){ // 秒杀
						info.setGoodsActType("3");
					} else if(item.getPhonePromoType() == 40){ // 团购
						info.setGoodsActType("2");
					}
				}
				info.setStagesNum(item.getInstallmentNumber());
				info.setPerStage(String.valueOf(item.getPrice()));
				info.setGoodsPrice(String.valueOf(item.getTotalPrice()));
				info.setJpPrice("");
				info.setTzPrice("");
				info.setDzPrice("");
				info.setVipPrice("");
				info.setBrhPrice("");
				info.setJfPart("");
				info.setXjPart("");
				info.setBeginDate("");
				info.setBeginTime("");
				info.setEndDate("");
				info.setEndTime("");
				//如果是积分商城，取不同等级价格
				if("jf".equals(item.getOrdertypeId().toLowerCase())){
					info.setJpPrice(item.getPoints() == null ? "" : String.valueOf(item.getPoints()));//金普价
					info.setTzPrice(item.getTjPoints() == null ? "" : String.valueOf(item.getTjPoints()));//钛金
					info.setDzPrice(item.getDjPoints() == null ? "" : String.valueOf(item.getDjPoints()));//顶级
					info.setVipPrice(item.getVipPoints() == null ? "" : String.valueOf(item.getVipPoints()));//vip
					info.setBrhPrice(item.getBirthPoints() == null ? "" : String.valueOf(item.getBirthPoints()));//生日
					info.setJfPart(item.getJfPoints() == null ? "" : String.valueOf(item.getJfPoints()));//积分+现金中的积分
					info.setXjPart(item.getXjPrice() == null ? "" : String.valueOf(item.getXjPrice()));//积分+现金中的现金
				}

				// 当商品为活动商品时，查出该商品当前参加的活动，从中取出活动开始结束时间。
				if(!"1".equals(info.getGoodsActType())){
					Response<MallPromotionResultDto> response = mallPromotionService.findPromByItemCodes("1", item.getCode(), sourceId);
					if(response.isSuccess() && response.getResult() != null){
						MallPromotionResultDto dto = response.getResult();
						info.setBeginDate(sdf.format(dto.getBeginDate()));
						info.setBeginTime(sdf1.format(dto.getBeginDate()));
						info.setEndDate(sdf.format(dto.getEndDate()));
						info.setEndTime(sdf1.format(dto.getEndDate()));						
					}
				}
				if (!StringUtils.isEmpty(info.getPerStage()) && !StringUtils.isEmpty(info.getGoodsPrice())) {
					infos.add(info);
				}
			}
			if (!infos.isEmpty()) {				
				queryReturn.setMallDate(sdf.format(new Date()));
				queryReturn.setMallTime(sdf1.format(new Date()));
				// 分页
				double totalCount = Double.valueOf(searchDto.getTotal());
				int totalPages = (int) Math.ceil(totalCount / size);
				queryReturn.setTotalCount(String.valueOf(searchDto.getTotal()));// 总数
				queryReturn.setTotalPages(String.valueOf(totalPages));// 总页数
				queryReturn.setStageMallGoodsQueryInfo(infos);
			}
		}
		return queryReturn;
	}

}
