/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.TblGoodsPaywayDao;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.OrderTieinSaleItemDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import lombok.extern.slf4j.Slf4j;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/6/13.
 */
@Service
@Slf4j
public class OrderTieinSaleServiceImpl implements OrderTieinSaleService {

	@Resource
	GoodsDao goodsDao;
	@Resource
	ItemDao itemDao;
	@Resource
	GoodsBrandDao goodsBrandDao;
	@Resource
	TblGoodsPaywayDao tblGoodsPaywayDao;

	@Override
	public Response<Pager<OrderTieinSaleItemDto>> findItemDetail(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("itemCode") String itemCode, @Param("itemName") String itemName,
			@Param("vendorId") String vendorId,List<String> itemCodes) {

		// 构造返回值及参数
		Response<Pager<OrderTieinSaleItemDto>> response = new Response<Pager<OrderTieinSaleItemDto>>();
		List<OrderTieinSaleItemDto> orderTieinSaleItemDtoList = Lists.newArrayList();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMapForGoods = Maps.newHashMap();
		Map<String, Object> paramMap = Maps.newHashMap();

		try {
			paramMapForGoods.put("vendorId", vendorId);
			// 状态上架
			paramMapForGoods.put("channelMall", Contants.CHANNEL_MALL_02);
			// 是否内宣商品 1 否  暂定内宣商品可搭销
			// paramMapForGoods.put("isInner", "1");
			// 未逻辑删除
			paramMapForGoods.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
			if (StringUtils.isNotBlank(itemName)) {
				paramMapForGoods.put("name", itemName.trim());
			}
			// 获取供应商下默认可用商品列表
			List<String> goodsCodeList = Lists.newArrayList();
			goodsCodeList = goodsDao.findGoodsInVendor(paramMapForGoods);
			// 当不存在可以搭销的商品
			if (goodsCodeList.isEmpty()) {
				response.setResult(new Pager<OrderTieinSaleItemDto>((long) 0, orderTieinSaleItemDtoList));
				return response;
			}
			if (StringUtils.isNotBlank(itemCode)) {
				paramMap.put("code", itemCode.trim());
			}
			if(itemCodes!=null&&!itemCodes.isEmpty()){
				paramMap.put("itemCodes",itemCodes);
			}
			paramMap.put("goodsCodeList", goodsCodeList);
			Pager<ItemModel> pager = itemDao.findByPageExtra(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			List<ItemModel> itemModelList = Lists.newArrayList();
			GoodsModel goodsModel = new GoodsModel();
			itemModelList = pager.getData();
			for (ItemModel itemModel : itemModelList) {
				OrderTieinSaleItemDto orderTieinSaleItemDto = new OrderTieinSaleItemDto();
				String goodsCode = itemModel.getGoodsCode();
				goodsModel = goodsDao.findById(goodsCode);
				GoodsBrandModel brandModel = goodsBrandDao.findById(goodsModel.getGoodsBrandId());
				orderTieinSaleItemDto.setGoodsBrandModel(brandModel);
				orderTieinSaleItemDto.setGoodsModel(goodsModel);
				orderTieinSaleItemDto.setItemModel(itemModel);
				orderTieinSaleItemDtoList.add(orderTieinSaleItemDto);
			}
			response.setResult(new Pager<OrderTieinSaleItemDto>(pager.getTotal(), orderTieinSaleItemDtoList));
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderTieinSaleService findItemDetail.eroor", Throwables.getStackTraceAsString(e));
			response.setError("OrderTieinSaleService.findItemDetail.eroor");
			return response;
		}
	}

	@Override
	public Response<TblGoodsPaywayModel> findGoodsPrice(String goodsPaywayId) {
		Response<TblGoodsPaywayModel>response=new Response<>();
		try{
			checkArgument(StringUtils.isNotBlank(goodsPaywayId), "goodsPaywayId.can.not.be.empty");
			TblGoodsPaywayModel tblGoodsPaywayModel=new TblGoodsPaywayModel();
			tblGoodsPaywayModel=tblGoodsPaywayDao.findById(goodsPaywayId);
			response.setResult(tblGoodsPaywayModel);
		}catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderTieinSaleService findGoodsPrice.eroor", Throwables.getStackTraceAsString(e));
			response.setError("OrderTieinSaleService.findGoodsPrice.eroor");
			return response;
		}
		return response;
	}

	@Override
	public Response<List<TblGoodsPaywayModel>> findByItemCode(String itemCode) {
		Response<List<TblGoodsPaywayModel>>response=new Response<>();
		List<TblGoodsPaywayModel>tblGoodsPaywayModelList=Lists.newArrayList();
		try {
			checkArgument(StringUtils.isNoneBlank(itemCode),"itemCode.be.empty");
			tblGoodsPaywayModelList=tblGoodsPaywayDao.findByItemCode(itemCode);
			response.setResult(tblGoodsPaywayModelList);
		}catch (IllegalArgumentException e){
			response.setError(e.getMessage());
			return response;
		}catch (Exception e){
			log.error("OrderTieinSaleService findByItemCode eroor",Throwables.getStackTraceAsString(e));
			response.setError("OrderTieinSaleService.findByItemCode.eroor");
			return response;
		}
		return response;
	}
}
