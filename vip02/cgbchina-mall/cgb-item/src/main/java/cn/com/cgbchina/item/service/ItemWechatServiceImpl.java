package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.ItemMakeDto;
import cn.com.cgbchina.item.dto.ItemWechatDto;
import cn.com.cgbchina.item.dto.UploadItemWeChatDto;
import cn.com.cgbchina.item.indexer.ItemRealTimeIndexer;
import cn.com.cgbchina.item.manager.ItemManager;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static cn.com.cgbchina.item.model.GoodsModel.Status.ON_SHELF;
import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author Tanliang
 * @since 2016-6-13
 */
@Service
@Slf4j
public class ItemWechatServiceImpl implements ItemWechatService {

	@Resource
	private GoodsDao goodsDao;
	@Resource
	private VendorService vendorService;
	@Resource
	private ItemManager itemManager;
	@Resource
	private GoodsService goodsService;
	@Resource
	private ItemDao itemDao;
	@Resource
	private ItemRealTimeIndexer itemRealTimeIndexer;

	/**
	 * 分页查询微信商品
	 * 
	 * @param pageNo
	 * @param size
	 * @param mid
	 * @param name
	 * @param vendorName
	 * @return
	 */
	@Override
	public Response<Pager<ItemWechatDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("code") String mid, @Param("name") String name, @Param("vendorName") String vendorName) {
		Response<Pager<ItemWechatDto>> result = Response.newResponse();
		Map<String, Object> paramMap = Maps.newHashMap();

		// 搜索条件封装--goods表查询
		// 商品名称
		if (!Strings.isNullOrEmpty(name)) {
			paramMap.put("name", name);
		}
		// 供应商名称
		if (!Strings.isNullOrEmpty(vendorName)) {
			Response<List<String>> vendorResponse = vendorService.findIdByName(vendorName);
			if (vendorResponse.isSuccess()) {
				List<String> vendorIds = vendorResponse.getResult();
				if (null != vendorIds && 0 != vendorIds.size()) {
					paramMap.put("vendorIds", vendorIds);
				}
			}
		}

		// 微信广发银行或微信广发信用卡渠道【已上架】
		paramMap.put("channelState", "true");
		try {
			// 根据搜索条件以及查询商品
			List<GoodsModel> goodsModelList = goodsDao.findAllWxGoods(paramMap);
			if (goodsModelList == null || goodsModelList.size() == 0) {
				result.setResult(Pager.empty(ItemWechatDto.class));
				return result;
			}

			// 商品
			final Map<String, GoodsModel> goodsMaps = Maps.uniqueIndex(goodsModelList,
					new Function<GoodsModel, String>() {
						@Override
						public String apply(@NotNull GoodsModel from) {
							return from.getCode();
						}
					});

			List<String> goodsCodes = Lists.newArrayList(goodsMaps.keySet());

			// 根据codelist分页查询item表
			Map<String, Object> params = Maps.newHashMap();
			PageInfo pageInfo = new PageInfo(pageNo, size);

			if (!Strings.isNullOrEmpty(mid)) {
				params.put("mid", mid);
			}
			params.put("goodsCodeList", goodsCodes);
			Pager<ItemModel> pager = itemDao.findWxItemByPage(params, pageInfo.getOffset(), pageInfo.getLimit());
			// 整理数据返回结果
			if (pager.getTotal() > 0) {

				List<ItemWechatDto> itemWechatDtoList = null;
				List<ItemModel> itemModelList = pager.getData();
				ItemWechatDto itemWechatDto;
				List<VendorInfoModel> vendorModelList;

				// 供应商 ———————————》
				final List<String> vendorIds = Lists.transform(goodsModelList, new Function<GoodsModel, String>() {
					@Override
					public String apply(@NotNull GoodsModel input) {
						return input.getVendorId();
					}
				});
				Set<String> set = new HashSet<String>();
				set.addAll(vendorIds);// 去重
				Response<List<VendorInfoModel>> vendorResponse = vendorService.findByVendorIds(Lists.newArrayList(set));
				if (!vendorResponse.isSuccess()) {
					log.error("findAll.VendorService,reason: -> {}", vendorResponse.getError());
					result.setError(vendorResponse.getError());
					return result;
				}
				vendorModelList = vendorResponse.getResult();
				if (null == vendorModelList || vendorModelList.isEmpty()) {
					log.error("findAll.VendorService: result.is.null");
					result.setError("vendorResult.is.null");
					return result;
				}
				final Map<String, VendorInfoModel> vendorModelMap = Maps.uniqueIndex(vendorModelList,
						new Function<VendorInfoModel, String>() {
							@NotNull
							@Override
							public String apply(@NotNull VendorInfoModel input) {
								return input.getVendorId();
							}
						});
				// ——————————————————《 end

				// 循环匹配单品及商品的数据
				for (ItemModel itemModel : itemModelList) {

					GoodsModel goodsModel = goodsMaps.get(itemModel.getGoodsCode());
					if (goodsModel == null) {
						continue;
					}

					// 如果商品编码匹配，则表示该单品属于该商品
					itemWechatDto = new ItemWechatDto();
					itemWechatDto.setCode(itemModel.getCode());// 单品编码
					itemWechatDto.setMid(itemModel.getMid());// 五位单品编码
					itemWechatDto.setImage(itemModel.getImage1());// 商品图片
					itemWechatDto.setName(goodsModel.getName());// 商品名称

					if (goodsModel.getVendorId() != null) {
						VendorInfoModel vendorModel = vendorModelMap.get(goodsModel.getVendorId());
						if (null != vendorModel)
							itemWechatDto.setVendorName(vendorModel.getSimpleName());// 供应商名称
					}
					itemWechatDto.setPrice(itemModel.getPrice());// 售价
					itemWechatDto.setWxOrder(itemModel.getWxOrder());// 显示顺序

					//调用共通方法，查找单品最高期数
					Integer maxInstallmentNumber = GoodsCheckUtil.getMaxInstallmentNumber(itemModel.getInstallmentNumber());
					itemWechatDto.setInstallmentNumber(maxInstallmentNumber);// 最高期数
					if (Contants.CHANNEL_CREDIT_WX_02.equals(goodsModel.getChannelCreditWx())) {
						itemWechatDto.setChannelCreditWx(Contants.CHANNEL_CREDIT_WX_02_NAME);
					} else {
						itemWechatDto.setChannelCreditWx(Contants.CHANNEL_CREDIT_WX_01_NAME);
					}
					if (Contants.CHANNEL_MALL_WX_02.equals(goodsModel.getChannelMallWx())) {
						itemWechatDto.setChannelMallWx(Contants.CHANNEL_MALL_WX_02_NAME);
					} else {
						itemWechatDto.setChannelMallWx(Contants.CHANNEL_MALL_WX_01_NAME);
					}
					if (null == itemWechatDtoList)
						itemWechatDtoList = Lists.newArrayListWithExpectedSize(itemModelList.size());
					itemWechatDtoList.add(itemWechatDto);
				}
				result.setResult(new Pager<ItemWechatDto>(pager.getTotal(), itemWechatDtoList));
				return result;
			} else {
				result.setResult(new Pager<ItemWechatDto>(0L, Collections.<ItemWechatDto> emptyList()));
				return result;
			}
		} catch (Exception e) {
			log.error("findAll.failed,bad code{}", Throwables.getStackTraceAsString(e));
			result.setError("ItemWechat.findAll.failed");
			return result;
		}
	}

	/**
	 * 编辑微信商品（更改排序）
	 *
	 * @param wxOrder
	 * @param code
	 * @return
	 */
	@Override
	public Response<Boolean> editItemWeChat(Long wxOrder, String code) {
		Response<Boolean> response = Response.newResponse();
		try {
			checkArgument(StringUtils.isNotBlank(code), "item.code.not.be.null");// 入参：单品code
			ItemModel itemModel = new ItemModel();
			itemModel.setCode(code);
			itemModel.setWxOrder(wxOrder);
			itemManager.updateWxOrder(itemModel);
			ItemModel itemModelIndex = itemDao.findById(code);
			if (itemModelIndex != null) {
				ItemMakeDto itemMakeDto = new ItemMakeDto();
				itemMakeDto.setGoodsCode(itemModelIndex.getGoodsCode());
				itemMakeDto.setStatus(ON_SHELF);
				itemRealTimeIndexer.index(itemMakeDto); // ON_SHELF("02", "上架"),OFF_SHELF("01", "下架"), DELETED("-1",
														// "删除");
			}
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error("params.is.null.item.code.is{}.wxOrder.is{}", code, wxOrder);
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("edit.item.wx.order.error{}", Throwables.getStackTraceAsString(e));
			response.setError("edit.item.wx.order.error");
		}
		return response;
	}

	/**
	 * 导入---微信商品信息
	 *
	 * @param models 即将操作的数据
	 * @param user 操作人
	 *
	 *            throw Exception 异常抛出
	 */
	@Override
	public Response<Map<String, Object>> uploadItemWeChat(List<UploadItemWeChatDto> models, User user)
			throws Exception {

		Response<Map<String, Object>> response = Response.newResponse();
		Map<String, Object> resultMap = Maps.newHashMap();
		Boolean isImportSuccess = false;

		List<UploadItemWeChatDto> resultList = Lists.newArrayList();
		List<ItemModel> updateList = Lists.newArrayList(); // 即将 批量更新的 数据
		Map<String, Object> params = Maps.newHashMap();// 查询条件

		// 查询 DB中所有相关的单品信息
		params.put("list", models);
		List<ItemModel> itemModels = itemDao.findByMids(params);
		final List<String> codes;
		final Map<String, ItemModel> itemMap;
		// 判断查询结果是否为空
		if (null != itemModels && !itemModels.isEmpty()) {
			// 组装 数据
			itemMap = Maps.uniqueIndex(itemModels, new Function<ItemModel, String>() {
				@Nullable
				@Override
				public String apply(@NotNull ItemModel input) {
					return input.getMid();
				}
			});

			params.clear();
			// 查询 符合条件的商品（微信渠道上架的商品） 用于后续校验
			params.put("channelMallWX", "02");
			params.put("channelCreditWX", "02");
			params.put("ordertypeId", "YG");
			params.put("list", itemModels);

			List<GoodsModel> goodsModels = goodsDao.findGoodsByIds(params);

			if (null != goodsModels && !goodsModels.isEmpty()) {

				codes = Lists.transform(goodsModels, new Function<GoodsModel, String>() {
					@Override
					public String apply(@NotNull GoodsModel input) {
						return input.getCode();
					}
				});
			} else {
				codes = Lists.newArrayListWithCapacity(1);
			}

		} else {
			codes = Lists.newArrayListWithCapacity(1);
			itemMap = Maps.newHashMapWithExpectedSize(1);
		}

		for (UploadItemWeChatDto item : models) {
			// 判断 查询结果中是否 存在 导入的商品的mid
			if (itemMap.containsKey(item.getItemCode())) {
				ItemModel itemModel = itemMap.get(item.getItemCode());
				String goodsCode = itemModel.getGoodsCode();
				// 判断 查询结果中是否 存在 商品的code
				if (codes.contains(goodsCode)) {
					// 判断导入的顺序是否为数字
					if (isNumeric(item.getWxOrder())) {
						isImportSuccess = true;
						ItemModel itemData = new ItemModel();
						itemData.setCode(itemModel.getCode());
						itemData.setWxOrder(Long.parseLong(item.getWxOrder()));
						itemData.setModifyOper(user.getId());
						updateList.add(itemData);
						item.setUploadFlag("成功");
					} else {
						item.setUploadFlag("失败");
						item.setUploadFailedReason("显示顺序字段不是数字");
					}
				} else {
					item.setUploadFlag("失败");
					item.setUploadFailedReason("该单品未上架");
				}
			} else {
				item.setUploadFlag("失败");
				item.setUploadFailedReason("该单品不存在");
			}
			resultList.add(item);
		}

		// 判断更新 item数据
		if (updateList.size() > 0) {
			Integer num = itemManager.batchUpdateItemInfo(updateList);
			if (num > 0) {
				resultMap.put("uploadItemWeChatDtos", resultList);
				resultMap.put("isImportSuccess", isImportSuccess);
				response.setResult(resultMap);
			} else {
				response.setError("update.error");
				log.error("ItemWechatServiceImpl.uploadItemWeChat.batchUpdateItemInfo is failed");
			}
		} else {
			resultMap.put("uploadItemWeChatDtos", resultList);
			resultMap.put("isImportSuccess", isImportSuccess);
			response.setResult(resultMap);
		}
		return response;
	}

	public Response<Boolean> deleteItemWechate(String itemCode) {
		Response<Boolean> response = Response.newResponse();
		try {
			Integer number = itemManager.deleteItemWechate(itemCode);
			if (number == 1) {
				response.setResult(true);
				return response;
			}
		} catch (Exception e) {
			log.error("itemWechatServiceImpl.deleteItemWechate.error:{}", Throwables.getStackTraceAsString(e));
		}
		response.setError("itemWechatServiceImpl.deleteItemWechate");
		return response;
	}

	/**
	 * 判断字符串是否为数字
	 *
	 * @param str 字符串
	 * @return
	 */
	private boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9]*");
		Matcher isNum = pattern.matcher(str);
		if (!isNum.matches()) {
			return false;
		}
		return true;
	}

	/**
	 * 判断文件是否存在.
	 *
	 * @param fileDir 文件路径
	 * @return
	 */
	// private boolean fileExist(String fileDir) {
	// boolean flag = false;
	// File file = new File(fileDir);
	// flag = file.exists();
	// return flag;
	// }

	/**
	 * 删除文件.
	 *
	 * @param fileDir 文件路径
	 * @return
	 */
	// private boolean deleteExcel(String fileDir) {
	// boolean flag = false;
	// File file = new File(fileDir);
	// // 判断目录或文件是否存在
	// if (!file.exists()) { // 不存在返回 false
	// return flag;
	// } else {
	// // 判断是否为文件
	// if (file.isFile()) { // 为文件时调用删除文件方法
	// try {
	// file.delete();
	// } catch (Exception e) {
	// e.printStackTrace();
	// }
	//
	// flag = true;
	// }
	// }
	// return flag;
	// }

}
