package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.GoodsBatchDto;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsPaywayDto;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.MakePriceDto;
import cn.com.cgbchina.item.dto.PointPresentDto;
import cn.com.cgbchina.item.dto.PresentRegionDto;
import cn.com.cgbchina.item.model.BrandAuthorizeModel;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.VirtualPrefuctureModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.EspAreaInfService;
import cn.com.cgbchina.item.service.GiftPartitionService;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.related.service.ConfigService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.misc.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by 11150221040129 on 16-6-23
 */
@Controller
@RequestMapping("/api/admin/pointsPresent")
@Slf4j
public class PointsPresent {

	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	private static final String FIND_TYPE = "1";// 调用查看方法传入参数
	private static final String SAVE_TYPE_SAVE = "save";// 保存、编辑方法前台传入标识
	private static final String SAVE_TYPE_AUDIT = "audit";// 保存、编辑方法前台传入标识

	@Autowired
	private BrandService brandService;
	@Autowired
	private GiftPartitionService giftPartitionService;
	@Autowired
	private ItemService itemService;
	@Autowired
	private GoodsPayWayService goodsPayWayService;
	@Autowired
	private EspAreaInfService espAreaInfService;// 礼品区间
	@Autowired
	public MessageSources messageSources;
	@Autowired
	private CfgPriceSystemService cfgPriceSystemService;
	@Autowired
	private ConfigService configService;

	/**
	 * 修改商品各渠道上下架信息
	 * 
	 * @param channel
	 * @param code
	 * @param state
	 * @return
	 */
	@RequestMapping(value = "/updatePresentChannel", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> updatePresentChannel(String channel, String code, String state) {

		Response<Integer> response = null;//presentService.updatePresentChannel(channel, code, state);

		if (response.isSuccess()) {
			return response;
		}

		log.error("failed to find item {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 修改商品各渠道上下架信息（一键上架）
	 * @param code
	 * @param state
	 * @return
	 */
	@RequestMapping(value = "/updatePresentChannelAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> updatePresentChannelAll(String code, String state) {

		Response<Integer> response = null;//presentService.updatePresentChannelAll(code, state);
		if (response.isSuccess()) {
			return response;
		}
		log.error("failed to find item {},error code:{}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}


	/**
	 * 根据商品编码查找商品信息(弹出框信息) 1.改价 信息查询 2.改库存 信息查询
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/findPresentByGoodsCode", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public GoodsDetailDto findPresentByGoodsCode(String goodsCode) {
		// 统一使用查看礼品详情接口
		Response<GoodsDetailDto> result = null;//presentService.findDetailByType(FIND_TYPE, goodsCode);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("PointsPresent.findPresentByGoodsCode:failed to find ,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据品牌名称模糊查询品牌list
	 * 
	 * @param brandName
	 * @return
	 */
	@RequestMapping(value = "/findBrandList", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BrandAuthorizeModel> findBrandList(String brandName, String vendorId) {
		// 校验
		Response<List<BrandAuthorizeModel>> result = brandService.findBrandListForVendor(vendorId, "",
				Contants.BUSINESS_TYPE_JF);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", brandName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 商品管理列表页提交审核按钮事件
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/submitGoodsToApprove", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String submitGoodsToApprove(String goodsCode) {
		GoodsModel goodsModel = new GoodsModel();
		Response<GoodsDetailDto> response = null;//presentService.findDetailByType(FIND_TYPE, goodsCode);
		if (response.isSuccess()) {
			GoodsDetailDto goodsDetailDto = response.getResult();
			List<ItemDto> itemDtoList = goodsDetailDto.getItemDtoList();
			List<ItemModel> resultList = Lists.newArrayList();
			for (ItemDto itemDto : itemDtoList) {
				resultList.add(itemDto.getItemModel());
			}
			goodsDetailDto.setItemList(resultList);
			String goodsDetail = jsonMapper.toJson(goodsDetailDto);
			goodsModel.setCode(goodsCode);
			goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
			goodsModel.setApproveDifferent(goodsDetail);
			Response<Integer> result = null;//presentService.updateGdInfo(goodsModel);
			if (result.isSuccess()) {
				return "ok";
			}
		}
		log.error("failed to update goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 审核商品
	 * 
	 * @param presentCode 礼品Id
	 * @param approveType 2:初审 3：复审 4：商品变更审核 5：商品价格变更审核 6：商品下架申请审核
	 * @param approveResult 审核类型，通过or拒绝
	 * @param approveMemo 审核意见
	 * @return
	 */
	@RequestMapping(value = "/examinePresent", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> examinePresent(String presentCode, String approveType, String approveResult,
			String approveMemo) {
		User user = UserUtil.getUser();

		Response<Boolean> result = null;//presentService.examinePresent(presentCode, approveType, approveResult, approveMemo,
				//user);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to edit goods {},error code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询所有分区数据
	 * 
	 * @return
	 */
	@RequestMapping(value = "/findAll", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<PresentRegionDto> findAll() {
		Response<List<PresentRegionDto>> result = giftPartitionService.findAll();
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to edit goods {},error code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}


	/**
	 * 推荐单品列表取得
	 * 
	 * @param searchKey
	 * @return
	 */
	@RequestMapping(value = "/findRecommendationItemList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ItemDto> findRecommendationItemList(String searchKey) {

		Response<List<ItemDto>> itemDtoList = itemService.findItemListByCodeOrName(searchKey,Contants.BUSINESS_TYPE_JF);

		if (itemDtoList.isSuccess()) {
			return itemDtoList.getResult();
		}
		log.error("failed to find itemList {},error code:{}", searchKey, itemDtoList.getError());
		throw new ResponseException(500, messageSources.get(itemDtoList.getError()));

	}

	/**
	 * 保存礼品（新增）
	 *
	 * @param json
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/addPresent", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String addPresent(@RequestParam("present") String json, String type) {
		PointPresentDto pointPresentDto = jsonMapper.fromJson(json, PointPresentDto.class);

		if (pointPresentDto.getCardsLevel().equals("")) {
			pointPresentDto.setCardsLevel("00");
		}

		computePrice(pointPresentDto);//计算金普价格
		// 创建类型(平台创建)
		pointPresentDto.setCreateType(Contants.CERATE_TYPE_ADMIN_0);
		// 审核状态
		if ("save".equals(type)) {
			// 编辑中
			pointPresentDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_00);
		} else if ("audit".equals(type)) {
			// 待初审
			pointPresentDto.setApproveStatus(Contants.GOODS_APPROVE_STATUS_01);
		}
		// 获取用户信息
		User user = UserUtil.getUser();
		Response<Boolean> result = null;//presentService.createPresent(pointPresentDto, user);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to save goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 编辑商品
	 *
	 * @param json
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "/editPresent", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean editGoods(@RequestParam("present") String json, String type) {
		// 校验
		PointPresentDto pointPresentDto = jsonMapper.fromJson(json, PointPresentDto.class);
		// 获取用户信息
		User user = UserUtil.getUser();

		computePrice(pointPresentDto);//计算金普价格
		Response<Boolean> result = null;//presentService.updatePresent(pointPresentDto, user, type);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to edit goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}


	/**
	 * 查询商品支付方式表
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/findGoodsPayway", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<GoodsPaywayDto>> findGoodsPayway(String goodsCode) {
		Response<List<GoodsPaywayDto>> result = goodsPayWayService.findGoodsPayway(goodsCode);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to edit goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 积分定价显示
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/makePrice", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<GoodsPaywayDto>> makePrice(String goodsCode) {

		String stockParam = "";
		Response<TblConfigModel> tblconfigModel = configService.findByCfgType("stock_param");
		if(tblconfigModel.isSuccess()){
			TblConfigModel tblConfig = tblconfigModel.getResult();
			stockParam = tblConfig.getCfgValue1();
		}

		List<MakePriceDto> makePriceDtos = new ArrayList<MakePriceDto>();
		Response<List<CfgPriceSystemModel>> response =
				cfgPriceSystemService.findByPriceSystemId(Contants.MEMBER_LEVEL_JP_CODE);
		if(response.isSuccess()){
			List<CfgPriceSystemModel> jpModels = response.getResult();
			makePriceDtos = BeanMapper.mapList(jpModels, MakePriceDto.class);
		}

		// 尊越/臻享白金+钛金卡
		BigDecimal argumentTJ = getArgumentOther(Contants.MEMBER_LEVEL_TJ_CODE);
		// 顶级/增值白金价
		BigDecimal argumentDJ = getArgumentOther(Contants.MEMBER_LEVEL_DJ_CODE);
		// VIP
		BigDecimal argumentVIP = getArgumentOther(Contants.MEMBER_LEVEL_VIP_CODE);
		// 生日
		BigDecimal argumentBirth = getArgumentOther(Contants.MEMBER_LEVEL_BIRTH_CODE);
		// 积分+现金
		BigDecimal argumentPP = getArgumentOther(Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE);

		Response<List<GoodsPaywayDto>> result = goodsPayWayService.makePrice(goodsCode, stockParam, argumentTJ,
				argumentDJ, argumentVIP, argumentBirth, argumentPP, makePriceDtos);
		if (result.isSuccess()) {
			return result;
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	private BigDecimal getArgumentOther(String memberLevel){
		BigDecimal argumentOther = new BigDecimal(0);
		Response<List<CfgPriceSystemModel>> response = cfgPriceSystemService.findByPriceSystemId(memberLevel);
		if(response.isSuccess()){
			List<CfgPriceSystemModel> models = response.getResult();
			if(models != null && models.size() > 0){
				CfgPriceSystemModel model = models.get(0);
				if(model != null){
					argumentOther = model.getArgumentOther();
				}
			}
		}
		return argumentOther;
	}

	/**
	 * 保存礼品定价
	 *
	 * @param json, user
	 * @return
	 */
	@RequestMapping(value = "/pengingPriced", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> savePengingPriced(@RequestParam("goods") String json) {
		User user = UserUtil.getUser();
		Response<Boolean> result = goodsPayWayService.saveChangePriced(json, user, Contants.GOODS_APPROVE_STATUS_08);
		if (result.isSuccess()) {
			return result;
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 保存礼品改价
	 *
	 * @param json, user
	 * @return
	 */
	@RequestMapping(value = "/saveChangePriced", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> saveChangePriced(@RequestParam("goods") String json) {
		User user = UserUtil.getUser();
		Response<Boolean> result = goodsPayWayService.saveChangePriced(json, user, Contants.GOODS_APPROVE_STATUS_04);
		if (result.isSuccess()) {
			return result;
		}
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询goods表临时字段内容（改价信息）
	 *
	 * @param goodsCode
	 * @return
	 */
	@RequestMapping(value = "/findChangePriceInfo", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<GoodsPaywayDto>> findChangePriceInfo(String goodsCode) {
		Response<List<GoodsPaywayDto>> result = goodsPayWayService.findChangePriceInfo(goodsCode);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to edit goods {},errco code:{}");
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询礼品分区
	 *
	 * add by zhoupeng
	 * 
	 * @return
	 */
	@RequestMapping(value = "/findRegionType", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<EspAreaInfModel> findRegionType() {
		Map<String, Object> map = Maps.newHashMap();
		map.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		map.put("curStatus", Contants.PARTITION_STATUS_QY);// 0101：未启用,0102：已启用
		Response<List<EspAreaInfModel>> response = espAreaInfService.findAreaInfoByParams(map);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to find RegionTypes");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 修改库存
	 *
	 * @param json
	 * @return
	 */
	@RequestMapping(value = "/storage", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean editItemStock(@RequestParam("goods") @NotNull String json) {
		Response<Boolean> response;
		User user = UserUtil.getUser();
		GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);

		response = null;//presentService.updatePresentStock(goodsDetailDto, user);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to find item {},error code:{}", goodsDetailDto, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

	/**
	 * 修改商品价格
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/modPrice", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String editItemPrice(@RequestParam("goods") @NotNull String json) {
		Response<Boolean> result;
		GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
		User user = UserUtil.getUser();

		result = null;//presentService.updatePresentPrice(goodsDetailDto, user);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update item {},error code:{}", json, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询专区
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/findVirtualPrefucture", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<VirtualPrefuctureModel> findVirtualPrefucture() {
		// 专区
		Response<List<VirtualPrefuctureModel>> virtualList = null;//presentService.findVirtualPrefucture();
		if (virtualList.isSuccess()) {
			return virtualList.getResult();
		}
		log.error("failed to update item {},error code:{}", virtualList.getError());
		throw new ResponseException(500, messageSources.get(virtualList.getError()));
	}

	/**
	 * 批量 审批
	 *
	 * @param goodsBatchDtoList
	 * @return
	 */
	@RequestMapping(value = "/audit-multi", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> updateAllGoodsStatus(@RequestBody GoodsBatchDto[] goodsBatchDtoList) {
		User user = UserUtil.getUser();
		Response<Integer> updateStatus = null;//presentService.updateAllGoodsStatus(Arrays.asList(goodsBatchDtoList), user);
		if (updateStatus.isSuccess()) {
			return updateStatus;
		}
		log.error("failed to find product {},error code:{}", goodsBatchDtoList, updateStatus.getError());
		throw new ResponseException(500, messageSources.get(updateStatus.getError()));
	}

	/**
	 * 价格计算
	 *
	 * @param pointPresentDto
     */
	private void computePrice(PointPresentDto pointPresentDto){
		Response<List<CfgPriceSystemModel>> response = cfgPriceSystemService.findByPriceSystemId("0000");// 金普价
		if (response.isSuccess()) {
			Response<TblConfigModel> tblconfigModel = configService.findByCfgType("stock_param");
			if (tblconfigModel.isSuccess()) {
				for (ItemModel itemModel : pointPresentDto.getItemList()) {
					BigDecimal cgbValue1 = new BigDecimal(tblconfigModel.getResult().getCfgValue1());
					BigDecimal price = itemModel.getPrice();
					BigDecimal goldCommon = price.multiply(cgbValue1.add(new BigDecimal(String.valueOf("1"))));
					for (CfgPriceSystemModel cfgPriceSystemModel : response.getResult()) {
						if (cfgPriceSystemModel.getUpLimit() > goldCommon.intValue()
								&& cfgPriceSystemModel.getDownLimit() <= goldCommon.intValue()) {
							BigDecimal argumentNormal = cfgPriceSystemModel.getArgumentNormal();
							BigDecimal result = goldCommon.divide(argumentNormal, 0, BigDecimal.ROUND_HALF_UP);
//							pointPresentDto.setPoints(result);
							itemModel.setMarketPrice(result);//金普价临时存储在市场价中
						}
					}
				}
			}
		}
	}

}
