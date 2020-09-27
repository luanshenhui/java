package cn.com.cgbchina.item.service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;

import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.google.common.base.Function;
import com.spirit.exception.ResponseException;
import org.springframework.stereotype.Service;

import com.google.common.base.Optional;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDateDto;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDto;
import cn.com.cgbchina.item.dto.MemberCountBatchDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.dto.MemberBatchDto;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import cn.com.cgbchina.user.service.UserBrowseHistoryService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 张成 on 16-4-25.
 */

@Service
@Slf4j
public class BrowseHistoryServiceImpl implements BrowseHistoryService {
	@Resource
	private GoodsDao goodsDao;
	@Resource
	private ItemDao itemDao;
	@Resource
	private UserBrowseHistoryService userBrowseHistoryService;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsPayWayService goodsPayWayService;

	// 本地缓存(商品信息)
	private final LoadingCache<String, Optional<GoodsModel>> cacheGoods;

	// 构造函数
	public BrowseHistoryServiceImpl() {
		cacheGoods = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, Optional<GoodsModel>>() {
					@Override
					public Optional<GoodsModel> load(String code) throws Exception {
						// 允许为空
						return Optional.fromNullable(goodsDao.findById(code));
					}
				});
	}

	/**
	 * 分页取得浏览历史列表
	 * 
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@Override
	public Response<Pager<BrowseHistoryInfoDateDto>> browseHistoryByPager(User user, Integer pageNo, Integer size) {
		Response<Pager<BrowseHistoryInfoDateDto>> result = new Response<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			Response<Pager<MemberBrowseHistoryModel>> response = userBrowseHistoryService.browseHistoryByPager(user,
					pageInfo);
			if(!response.isSuccess()){
				log.error("Response.error,error code: {}", response.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			if (response == null) {
				result.setResult(
						new Pager<BrowseHistoryInfoDateDto>(0L, Collections.<BrowseHistoryInfoDateDto> emptyList()));
				return result;
			}
			Pager<MemberBrowseHistoryModel> pager = response.getResult();
			if (pager.getTotal() == 0) {
				result.setResult(
						new Pager<BrowseHistoryInfoDateDto>(0L, Collections.<BrowseHistoryInfoDateDto> emptyList()));
				return result;
			} else {
				List<MemberBrowseHistoryModel> list = pager.getData();
				List<String> itemCodes = Lists.transform(list, new Function<MemberBrowseHistoryModel, String>() {
					@NotNull
					@Override
					public String apply(@NotNull MemberBrowseHistoryModel input) {
						return input.getItemCode();
					}
				});
				Map<String, ItemModel> itemModelMap  = getItemModelMap(itemCodes);
				List<BrowseHistoryInfoDto> dtoList = new ArrayList<>();
				List<BrowseHistoryInfoDateDto> dateDtoList = new ArrayList<>();
				String oldbrowseDate = "";
				String newbrowseDate = "";
				for (int i = 0; i < list.size(); i++) {
					MemberBrowseHistoryModel model = list.get(i);
					BrowseHistoryInfoDateDto ddto = new BrowseHistoryInfoDateDto();

					SimpleDateFormat dateFormater = new SimpleDateFormat("yyyy.MM.dd");
					newbrowseDate = dateFormater.format(model.getCreateTime());
					if (i > 0 && !oldbrowseDate.equals(newbrowseDate)) {
						ddto.setBrowseDate(oldbrowseDate);
						ddto.setBrowseHistoryInfoDto(dtoList);
						dateDtoList.add(ddto);
						dtoList = new ArrayList<>();
					}
					oldbrowseDate = dateFormater.format(model.getCreateTime());
					BrowseHistoryInfoDto dto = new BrowseHistoryInfoDto();
					// 单品详情
					ItemModel itemModel = itemModelMap.get(model.getItemCode());
					// 商品详情
					GoodsModel goodsModel = this.findGoodsById(model.getGoodsCode());
					// 商品详情
					dto.setGoodsModel(goodsModel);
					// 浏览信息
					dto.setMemberBrowseHistoryModel(model);

					if (goodsModel!=null&&!Contants.BUSINESS_TYPE_JF.equals(goodsModel.getOrdertypeId())){
						Integer maxInstallmentNumber = 1;
						//YG or FQ goods
						if (itemModel != null) {
							//调用共通方法，查找单品最高期数
							maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
							itemModel.setInstallmentNumber(maxInstallmentNumber.toString());
						}

						// 单品详情
						dto.setItemModel(itemModel);
						// 收藏时点价格
						BigDecimal oldPrice = model.getPrice();

						// 单品状态（失效，直降）
						if (goodsModel != null && itemModel != null) {
							// 现时点价格
							BigDecimal newPrice = itemModel.getPrice();

							if (newPrice != null) {
								dto.setItemPrice(newPrice
										.divide(new BigDecimal(maxInstallmentNumber), 2, BigDecimal.ROUND_UP).toString());
							}
							dto.setPriceType("0");
							// 商品为上架状态以外的单品显示失效
							if (Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
								if (Contants.DEL_FLAG_1.equals(itemModel.getDelFlag())){
									// 失效 item be deleted
									dto.setPriceType("2");
								}else {
									if (oldPrice != null && newPrice != null) {
										if (oldPrice.compareTo(newPrice) == 1) {
											// 直降
											dto.setPriceType("1");
										}
									}
								}
							} else {
								// 失效
								dto.setPriceType("2");
							}
						}
					}else {
						if (itemModel != null) {
							dto.setItemModel(itemModel);
							if (!Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelPoints()) || Contants.DEL_FLAG_1.equals(itemModel.getDelFlag())) {
								// 失效
								dto.setPriceType("2");
							}else {
								dto.setPriceType("0");
								Response<List<TblGoodsPaywayModel>>tblGoodsPaywayModelResponse=goodsPayWayService.findInfoByItemCode(itemModel.getCode());
								if (!tblGoodsPaywayModelResponse.isSuccess()||tblGoodsPaywayModelResponse.getResult()==null||tblGoodsPaywayModelResponse.getResult().isEmpty()){
									log.error("BrowseHistoryService browseHistoryByPager,itemCode:" + itemModel.getCode() + "goodsPayWayService findInfoByItemCode failed");
									throw new Exception("goodsPayWayService.findInfoByItemCode.failed");
								}
								//默认第一条，第一条为金普价
								TblGoodsPaywayModel tblGoodsPaywayModel=tblGoodsPaywayModelResponse.getResult().get(0);
								Long newGoodsPoints=tblGoodsPaywayModel.getGoodsPoint();
								//浏览时积分数
								Long oldGoodsPoints=model.getGoodsPoint();
								if (newGoodsPoints==null||oldGoodsPoints==null){
									log.error("BrowseHistoryService browseHistoryByPager,itemCode:" + itemModel.getCode() + "newGoodsPoints or oldGoodsPoints be null");
									throw new Exception("newGoodsPoints.or.oldGoodsPoints.be.null");
								}
								//记录新积分数
								dto.setGoodsPoint(newGoodsPoints);
								if(newGoodsPoints<oldGoodsPoints){
									dto.setPriceType("1");
								}
							}
						}
					}
					dtoList.add(dto);

					if (i == list.size() - 1) {
						ddto = new BrowseHistoryInfoDateDto();
						ddto.setBrowseDate(oldbrowseDate);
						ddto.setBrowseHistoryInfoDto(dtoList);
						dateDtoList.add(ddto);
					}

				}
				result.setResult(new Pager<BrowseHistoryInfoDateDto>(0L, dateDtoList));
				return result;
			}
		} catch (Exception e) {
			log.error("BrowseHistoryService.browseHistoryByPager.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("BrowseHistoryService.browseHistoryByPager.fail");
			return result;
		}
	}

	/**
	 * Description : 指定时间段广发、积分前五十浏览商品(会员报表)
	 */
	@Override
	public Response<List<MemberCountBatchDto>> findTopBrowseHistory(Map<String, Object> params) {
		Response<List<MemberCountBatchDto>> response = new Response<List<MemberCountBatchDto>>();
		try {
			// 用于缓存已有的MemberCountBatchDto
			Map<Integer, MemberCountBatchDto> memberCountBatchDtoCache = Maps.newHashMap();
			int pageNo = 1;
			int pageSize = 500;
			int indexYg = 0;// 当前广发统计索引
			int indexJf = 0;// 当前积分统计索引
			while (indexYg < 50 || indexJf < 50) {// 当广发、积分商城的前五十统计都取完后，就不再去取数据
				Response<List<MemberBatchDto>> memberBatchDtoPager = userBrowseHistoryService
						.findBrowseHistoryByPager(pageNo++, pageSize, params);
				if (!memberBatchDtoPager.isSuccess()) {
					response.setError(memberBatchDtoPager.getError());
					return response;
				}
				List<MemberBatchDto> memberBatchDtos = memberBatchDtoPager.getResult();
				if (memberBatchDtos == null || memberBatchDtos.isEmpty()) {// 没数据后停止去取数据
					break;
				}
				MemberCountBatchDto memberCountBatchDto = null;
				GoodsModel goodsModel = null;
				ItemModel itemModel = null;
				List<String> itemCodes = Lists.transform(memberBatchDtos, new Function<MemberBatchDto, String>() {
					@NotNull
					@Override
					public String apply(@NotNull MemberBatchDto input) {
						return input.getItemCode();
					}
				});
				Map<String, ItemModel> itemModelMap  = getItemModelMap(itemCodes);
				for (MemberBatchDto memberBatchDto : memberBatchDtos) {
					String goodsCode = memberBatchDto.getGoodsCode();
					goodsModel = this.findGoodsById(goodsCode);
					String itemCode = memberBatchDto.getItemCode();
					itemModel = itemModelMap.get(itemCode);
					if (goodsModel == null || itemModel == null) {
						continue;
					}
					String orderTypeId = goodsModel.getOrdertypeId();
					if (Contants.BUSINESS_TYPE_YG.equals(orderTypeId)) {
						if (indexYg < 50) {// 缓存够50条记录就不再缓存
							memberCountBatchDto = memberCountBatchDtoCache.get(++indexYg);
							if (memberCountBatchDto == null) {// 缓存不存在时要创建
								memberCountBatchDto = new MemberCountBatchDto();
							}
							memberCountBatchDto.setGoodsCodeYG(itemModel.getCode());
							memberCountBatchDto.setGoodsNameYG(goodsModel.getName());
							memberCountBatchDto.setTimeYG(Integer.valueOf(memberBatchDto.getCount()));
							memberCountBatchDtoCache.put(indexYg, memberCountBatchDto);
						}
					} else if (Contants.BUSINESS_TYPE_JF.equals(orderTypeId)) {
						if (indexJf < 50) {// 缓存够50条记录就不再缓存
							memberCountBatchDto = memberCountBatchDtoCache.get(++indexJf);
							if (memberCountBatchDto == null) {
								memberCountBatchDto = new MemberCountBatchDto();
							}
							memberCountBatchDto.setGoodsCodeJF(itemModel.getCode());
							memberCountBatchDto.setGoodsNameJF(goodsModel.getName());
							memberCountBatchDto.setTimeJF(Integer.valueOf(memberBatchDto.getCount()));
							memberCountBatchDtoCache.put(indexJf, memberCountBatchDto);
						}
					}
				}

				if (memberBatchDtos.size() < pageSize) {// 没数据后停止去取数据
					break;
				}
			}

			List<MemberCountBatchDto> memberCountBatchDtos = Lists.newArrayList();
			int size = memberCountBatchDtoCache.size() > 50 ? 50 : memberCountBatchDtoCache.size();
			for (int index = 1; index <= size; index++) {
				MemberCountBatchDto memberCountBatchDto = memberCountBatchDtoCache.get(index);
				if(memberCountBatchDto == null){
					break;
				}
				memberCountBatchDto.setIndex(index);
				memberCountBatchDtos.add(memberCountBatchDto);
			}
			response.setResult(memberCountBatchDtos);
			return response;
		} catch (Exception e) {
			log.error("BrowseHistoryService.findTopBrowseHistory.fail,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("BrowseHistoryService.findTopBrowseHistory.fail");
			return response;
		}
	}


	/*
	 * 根据CODE取得商品信息
	 * 
	 * @return 商品信息
	 */
	private GoodsModel findGoodsById(String code) {
		Optional<GoodsModel> goodsModel = this.cacheGoods.getUnchecked(code);
		if (goodsModel.isPresent()) {
			return goodsModel.get();
		}
		return null;
	}
	/**
	 * 取 item集合
	 * @return
	 */
	private Map<String, ItemModel> getItemModelMap(List<String> itemCodes) {

		Response<List<ItemModel>> response = itemService.findByCodesNoOrder(Lists.newArrayList(itemCodes));
		if(response.isSuccess()){
			List<ItemModel> itemModels = response.getResult();
			if(null == itemModels || itemCodes.isEmpty()){
				log.error("ItemService.findByCodesNoOrder.failed");
				return null;
			}
			return Maps.uniqueIndex(itemModels, new Function<ItemModel, String>() {
				@NotNull
				@Override
				public String apply(@NotNull ItemModel input) {
					return input.getCode();
				}
			});

		}
		return null;
	}
}
