package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDateDto;
import cn.com.cgbchina.item.dto.BrowseHistoryInfoDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import cn.com.cgbchina.user.service.UserBrowseHistoryService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Optional;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.TimeUnit;

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

	// 本地缓存(单品信息)
	private final LoadingCache<String, Optional<ItemModel>> cacheItem;
	// 本地缓存(商品信息)
	private final LoadingCache<String, Optional<GoodsModel>> cacheGoods;

	// 构造函数
	public BrowseHistoryServiceImpl() {
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

	/**
	 * 分页取得浏览历史列表
	 * 
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<BrowseHistoryInfoDateDto>> browseHistoryByPager(Integer pageNo, Integer size) {
		Response<Pager<BrowseHistoryInfoDateDto>> result = new Response<>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		try {
			Response<Pager<MemberBrowseHistoryModel>> response = userBrowseHistoryService
					.browseHistoryByPager(pageInfo);
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
					ItemModel itemModel = this.findItemById(model.getItemCode());
					// 商品详情
					GoodsModel goodsModel = this.findGoodsById(model.getGoodsCode());

					// 旧数据最高分期数未录入 临时赋予默认值 1
					if (itemModel.getInstallmentNumber()== null){
						itemModel.setInstallmentNumber("1");
					}

					// 浏览信息
   					dto.setMemberBrowseHistoryModel(model);
					// 单品详情
					dto.setItemModel(itemModel);
					// 商品详情
					dto.setGoodsModel(goodsModel);
					// 收藏时点价格
					BigDecimal oldPrice = model.getPrice();

					// 单品状态（失效，直降）
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

						dto.setPriceType("0");
						// 商品为上架状态以外的单品显示失效
						if (Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
							if (oldPrice != null && newPrice != null) {
								if (oldPrice.compareTo(newPrice) == 1) {
									// 直降
									dto.setPriceType("1");
								}
							}
						} else {
							// 失效
							dto.setPriceType("2");
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

}
