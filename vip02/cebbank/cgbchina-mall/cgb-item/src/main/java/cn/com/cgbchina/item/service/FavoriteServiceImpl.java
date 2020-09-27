package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsFavoriteInfoDto;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Optional;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * Created by 张成 on 16-4-25.
 */

@Service
@Slf4j
public class FavoriteServiceImpl implements FavoriteService {
	@Resource
	private GoodsDao goodsDao;
	@Resource
	ItemDao itemDao;
	@Resource
	private UserFavoriteService userFavoriteService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private ItemService itemService;

	// 本地缓存(单品信息)
	private final LoadingCache<String, Optional<ItemModel>> cacheItem;
	// 本地缓存(商品信息)
	private final LoadingCache<String, Optional<GoodsModel>> cacheGoods;

	// 构造函数
	public FavoriteServiceImpl() {
		cacheItem = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, Optional<ItemModel>>() {
					public Optional<ItemModel> load(String code) throws Exception {
						// 允许为空
						return Optional.fromNullable(itemDao.findById(code));
					}
				});
		cacheGoods = CacheBuilder.newBuilder().expireAfterAccess(5, TimeUnit.MINUTES)
				.build(new CacheLoader<String, Optional<GoodsModel>>() {
					public Optional<GoodsModel> load(String code) throws Exception {
						// 允许为空
						return Optional.fromNullable(goodsDao.findById(code));
					}
				});
	}

	@Override
	public List<GoodsDetailDto> find(Map<String,Object> paramMap) {
		// 实例化返回GoodsDetailDto的list
		List<GoodsDetailDto> goodsList = new ArrayList<GoodsDetailDto>();
		try {
			// 从数据库查找收藏的top10
			List<MemberGoodsFavoriteModel> goodsFavoriteList = userFavoriteService.findTop(paramMap);
			if(null == goodsFavoriteList){//暂无收藏商品
				return goodsList;
			}
			// 循环找到的list
			for (int i = 0; i < goodsFavoriteList.size(); i++) {
				if(i > 3){//只选择四件商品，进行展示
					break;
				}
				MemberGoodsFavoriteModel memberGoodsFavoriteModel = goodsFavoriteList.get(i);
				// 商品model
				GoodsModel goodsModel;
				GoodsDetailDto goodsDto = new GoodsDetailDto();

				// 根据收藏表中的商品code检索商品信息
				goodsModel = goodsDao.findDetailById(memberGoodsFavoriteModel.getGoodsCode());
				if(null != goodsModel){
					// copy给dto
					BeanMapper.copy(goodsModel, goodsDto);
				}
				//TODO 设置单品Code 供热门收藏使用。
				goodsDto.setItemCode(memberGoodsFavoriteModel.getItemCode());
				// 把收藏的数赋值
				// goodsDto.setFavCount(memberGoodsFavoriteModel.getCount());
				// 放到list里
				goodsList.add(goodsDto);
			}
		} catch (Exception e) {
			log.error("get.favorite.top.error,error code: {}", Throwables.getStackTraceAsString(e));
		}
		// 返回这个list
		return goodsList;
	}

	/**
	 * 分页取得收藏情报列表
	 * 
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<GoodsFavoriteInfoDto>> findByPager(Integer pageNo, Integer size, User user) {
		Response<Pager<GoodsFavoriteInfoDto>> result = new Response<Pager<GoodsFavoriteInfoDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			Response<Pager<MemberGoodsFavoriteModel>> response = userFavoriteService.findByPager(pageInfo, user);
			if (response == null) {
				result.setResult(new Pager<GoodsFavoriteInfoDto>(0L, Collections.<GoodsFavoriteInfoDto> emptyList()));
				return result;
			}
			Pager<MemberGoodsFavoriteModel> pager = response.getResult();
			if (pager.getTotal() == 0) {
				result.setResult(new Pager<GoodsFavoriteInfoDto>(0L, Collections.<GoodsFavoriteInfoDto> emptyList()));
				return result;
			} else {
				List<MemberGoodsFavoriteModel> list = pager.getData();
				List<GoodsFavoriteInfoDto> dtoList = new ArrayList<>();
				for (MemberGoodsFavoriteModel model : list) {
					GoodsFavoriteInfoDto dto = new GoodsFavoriteInfoDto();
					// 单品详情
					ItemModel itemModel = new ItemModel();
							//this.findItemById(model.getItemCode());
					// 商品详情
					GoodsModel goodsModel = this.findGoodsById(model.getGoodsCode());
					Response<List<ItemDto>> itemRes = itemService.findItemListByCodeOrName(model.getItemCode());
					if (itemRes.isSuccess()
							&& itemRes.getResult() != null
							&& itemRes.getResult().size() > 0) {
						ItemDto itemDto = (ItemDto)itemRes.getResult().get(0);
						itemModel = itemDto.getItemModel();
						// 单品名称
						//dto.setItemName(itemDto.getItemDescription());
					}
					dto.setItemName(goodsModel.getName());
					// 收藏详情
					dto.setMemberGoodsFavoriteModel(model);
					// 单品详情
					dto.setItemModel(itemModel);
					// 商品详情
					dto.setGoodsModel(goodsModel);
					// 收藏时点价格
					BigDecimal oldPrice = model.getPrice();
					// 单品状态（失效，直降）
					dto.setGoodsFavoriteType("0");

					if (goodsModel != null && itemModel != null) {
						// 现时点价格
						BigDecimal newPrice = itemModel.getPrice();
						if (newPrice != null) {
							if (StringUtils.isNotEmpty(itemModel.getInstallmentNumber())) {
								dto.setItemPrice(newPrice.divide(new BigDecimal(itemModel.getInstallmentNumber()), 2, BigDecimal.ROUND_UP).toString());
							} else {
								dto.setItemPrice(newPrice.toString());
							}
						}
						// 商品为上架状态以外的单品显示失效
						if (Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
							if (oldPrice != null && newPrice != null) {
								if (oldPrice.compareTo(newPrice) == 1) {
									// 直降
									dto.setGoodsFavoriteType("1");
								}
							}
						} else {
							// 失效
							dto.setGoodsFavoriteType("2");
						}
					}
					dtoList.add(dto);
				}
				result.setResult(new Pager<GoodsFavoriteInfoDto>(pager.getTotal(), dtoList));
				return result;
			}
		} catch (Exception e) {
			log.error("FavoriteService.findByPager.fail,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("FavoriteService.findByPager.fail");
			return result;
		}
	}

	/*
	 * 根据CODE取得单品信息
	 *
	 * @return 单品信息
	 */
	private ItemModel findItemById(String code) {
		Optional<ItemModel> itemModel = this.cacheItem.getUnchecked(code);
		if (itemModel.isPresent()) {
			return itemModel.get();
		}
		return null;
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

	@Override
	public Response<Map<String, Boolean>> add(String item, User user) {
		// 实例化返回GoodsDetailDto的list
		Response<Map<String, Boolean>> response = new Response<Map<String, Boolean>>();
		try {
			if (StringUtils.isEmpty(item)) {
				response.setSuccess(false);
				return response;
			}
			List<String> parts = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(item);
			List<String> itemList = Lists.newArrayListWithCapacity(parts.size());
			for (String id : parts) {
				itemList.add(id);
			}
			// 单品详情
			List<MemberGoodsFavoriteModel> modelList = new ArrayList<MemberGoodsFavoriteModel>();
			for (String itemCode : itemList) {
				ItemModel itemModel = this.findItemById(itemCode);
				if (itemModel == null) {
					continue;
				}
				GoodsModel goodsModel = this.findGoodsById(itemModel.getGoodsCode());
				MemberGoodsFavoriteModel model = new MemberGoodsFavoriteModel();
				model.setItemCode(itemModel.getCode()); // 单品编码
				model.setGoodsCode(itemModel.getGoodsCode()); // 商品编码
				model.setPrice(itemModel.getPrice()); // 实际价格
				model.setCreateOper(user.getId()); // 创建人
				model.setCreateTime(new Date()); // 创建时间
				model.setDelFlag(0); // 逻辑删除标记 0：未删除 1：已删除
				model.setCustId(user.getId()); // 会员编号
				model.setVendorId(goodsModel.getVendorId()); // 供应商id
				modelList.add(model);
			}
			if (modelList.size() > 0) {
				response = userFavoriteService.addFavorite(modelList);
			} else {
				Map<String, Boolean> responseMap = Maps.newHashMap();
				responseMap.put("result", false);
				response.setSuccess(false);
				response.setResult(responseMap);
			}
		} catch (Exception e) {
			log.error("add.favorite.error", Throwables.getStackTraceAsString(e));
		}
		// 返回执行结果
		return response;
	}
}
