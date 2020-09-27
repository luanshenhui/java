package cn.com.cgbchina.restful.provider.impl.goods;

import java.text.DecimalFormat;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.RestItemService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoods;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.MyLoveCGBGoodsQueryService;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;

import com.google.common.base.Function;
import com.google.common.collect.Maps;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;

/**
 * MAL119 猜我喜欢广发商品查询
 * 
 * @author lizy 2016/7/4
 */
@Service
@Slf4j
public class MyLoveCGBGoodsQueryServiceImpl implements MyLoveCGBGoodsQueryService {
	 @Resource
	 GoodsService goodsService;
	// @Resource
	// OrderService orderService;
	@Resource
	RestOrderService restOrderService;
	@Resource
	RestItemService restItemService;
	@Resource
	BackCategoryService backCategoriesService;
	@Resource
	VendorService vendorService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Value("#{app.mallGiftUrl}")
	private String mallGiftUrl;

	@Override
	public MyLoveCGBGoodsQueryReturn query(MyLoveCGBGoodsQuery query) {
		MyLoveCGBGoodsQueryReturn result = new MyLoveCGBGoodsQueryReturn();
		List<MyLoveCGBGoods> myLoveCGBGoodsList = new ArrayList<MyLoveCGBGoods>();
		try {

			result.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			
			// 查出客户已经签收 的订单的商品快照
			Response<GoodsModel> orderGoodsDetailModelResp = restOrderService.findGoodsByUserId(query
					.getCreateOper());			
			if (orderGoodsDetailModelResp.isSuccess() && orderGoodsDetailModelResp.getResult() != null) {
				GoodsModel orderGoodsDetailModel = orderGoodsDetailModelResp.getResult();
				// 根据数据迁移的资料，新商城的类目1等于旧商城的大类
				Long backCategory1Id = null;
	            Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(orderGoodsDetailModel.getCode());
	            if (pairResponse.isSuccess()) {
		            List<Pair> pairList = pairResponse.getResult();
		            backCategory1Id = pairList.get(3).getId();
	            }
				Response<List<TblGoodsRecommendationYgModel>> goodsPayWayModelExtendsResp = restItemService
						.findGoodsByBackCategory1Id4109(backCategory1Id);
				if (goodsPayWayModelExtendsResp.isSuccess() && goodsPayWayModelExtendsResp != null && goodsPayWayModelExtendsResp.getResult() != null) {
					// 返回支付方式列表
					List<TblGoodsRecommendationYgModel> goodsPayWayModelExtends = goodsPayWayModelExtendsResp.getResult();
					List<String> ids=new ArrayList<>();
					for(TblGoodsRecommendationYgModel model:goodsPayWayModelExtends){
						ids.add(model.getGoodsId());
					}
					Response<List<ItemGoodsDetailDto>> itemList = itemService.findByIds(ids);
					if(itemList.isSuccess() && itemList.getResult()!=null){
						//查询价格和分期价格
						Response<List<TblGoodsPaywayModel>> paywayList = goodsPayWayService.findGoodsPayWayByCodes(ids);
						if(paywayList.isSuccess() && paywayList!=null&&paywayList.getResult()!=null){
							
							//装载价格信息
							Map<String,TblGoodsPaywayModel> paywayMap=new HashMap<String, TblGoodsPaywayModel>();
							for(TblGoodsPaywayModel model:paywayList.getResult()){
								TblGoodsPaywayModel tblGoodsPaywayModel = paywayMap.get(model.getGoodsId());
								if(tblGoodsPaywayModel==null||tblGoodsPaywayModel.getStagesCode()<model.getStagesCode()){
									paywayMap.put(model.getGoodsId(), model);
								}
							}
							
							//查询供应商信息
							List<String> verndorIds=new ArrayList<>();
							for(ItemGoodsDetailDto itemdto:itemList.getResult()){
								verndorIds.add(itemdto.getVendorId());
							}
							Response<List<VendorInfoModel>> vendorModelsResp = vendorService.findByVendorIds(verndorIds);
							Map<String,VendorInfoModel> vendorInfoModels = null;
							if (vendorModelsResp.isSuccess() && vendorModelsResp != null && vendorModelsResp.getResult() != null) {
								vendorInfoModels=Maps.uniqueIndex(vendorModelsResp.getResult(),new Function< VendorInfoModel,String>() {
									@Override
									@Nullable
									public String apply(@Nullable VendorInfoModel input) {
										return input.getVendorId();
									}
								} );
							}

							DecimalFormat df=new DecimalFormat("0.00");
							// 组装返回 的数据
							packageResult(myLoveCGBGoodsList, itemList,
									paywayMap, vendorInfoModels, df);
						}
					}
				}

			}
		} catch (RuntimeException ex) {
			log.error("【MAL119】 猜我喜欢广发商品查询 exception:", ex);
			result.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			result.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);

		} finally {
			result.setMyLoveCGBGoodsList(myLoveCGBGoodsList);
		}
		return result;
	}

	private void packageResult(List<MyLoveCGBGoods> myLoveCGBGoodsList,
			Response<List<ItemGoodsDetailDto>> itemList,
			Map<String, TblGoodsPaywayModel> paywayMap,
			Map<String, VendorInfoModel> vendorInfoModels, DecimalFormat df) {
		if (!itemList.isSuccess()) {
			throw new RuntimeException(itemList.getError());
		}
		for (ItemGoodsDetailDto itemModel : itemList.getResult()) {
			TblGoodsPaywayModel tblGoodsPaywayModel = paywayMap.get(itemModel.getCode());
			if (tblGoodsPaywayModel == null) {
				continue;
			}
			MyLoveCGBGoods mylove = new MyLoveCGBGoods();
			mylove.setGoodsId(itemModel.getCode());// 商品id
			mylove.setGoodsNm(itemModel.getGoodsName());// 商品名称
			
			String goodsPrice = df.format(tblGoodsPaywayModel.getGoodsPrice());
			String perStage = df.format(tblGoodsPaywayModel.getPerStage());
			String stageNum=String.valueOf(tblGoodsPaywayModel.getStagesCode());
			
			mylove.setGoodsPrice(goodsPrice);// 商品一期价格
			mylove.setStagesNum(stageNum);// 分期数
			mylove.setPerStage(perStage);// 分期价格
			if (vendorInfoModels != null) {
				VendorInfoModel vendorInfoModel = vendorInfoModels.get(itemModel.getVendorId());
				if(vendorInfoModel!=null){
					mylove.setVendorFnm(vendorInfoModel.getFullName());// 供应商全称
				}
			}
			mylove.setGoodsMid(itemModel.getMid());
			mylove.setGoodsOid(itemModel.getOid());
			mylove.setPictureUrl(itemModel.getImage1());// 图片url
			mylove.setGoodsUrl(MessageFormat.format(mallGiftUrl, itemModel.getGoodsCode(),itemModel.getCode()));// 详细页面url
			myLoveCGBGoodsList.add(mylove);
		}
	}
}
