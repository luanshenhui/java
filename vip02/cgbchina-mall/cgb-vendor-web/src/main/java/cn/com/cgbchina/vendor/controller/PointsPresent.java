package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dto.BackCategoryAndBrandsDto;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.ItemDto;
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
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.related.service.ConfigService;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.model.BackCategory;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.misc.NotNull;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

/**
 * Created by txy on 2016/8/15.
 */
@Controller
@RequestMapping("/api/vendor/pointsPresent")
@Slf4j
public class PointsPresent {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    private static final String FIND_TYPE = "1";// 调用查看方法传入参数
    @Resource
    MessageSources messageSources;
    @Resource
    private EspAreaInfService espAreaInfService;
    @Resource
    private BrandService brandService;
    @Resource
    private GiftPartitionService giftPartitionService;
    @Resource
    private ItemService itemService;
    @Resource
    private CfgPriceSystemService cfgPriceSystemService;
    @Resource
    private ConfigService configService;

//    /**
//     * 查询所有分区数据
//     *
//     * @return
//     */
//    @RequestMapping(value = "/findAll", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
//    @ResponseBody
//    public List<PresentRegionDto> findAll() {
//        Response<List<PresentRegionDto>> result = giftPartitionService.findAll();
//        if (result.isSuccess()) {
//            return result.getResult();
//        }
//        log.error("failed to edit goods {},error code:{}");
//        throw new ResponseException(500, messageSources.get(result.getError()));
//    }


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










//------------------------------------------------------------------------------------------------------------------
    /**
     * 根据id查询下级list 用于搜索条件中后台类目层级显示
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/V-look-toSearchPointsCategory", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<BackCategory> lookToSearchPointsCategory(Long id) {
//        Response<List<BackCategory>> response = pointsBackCategoriesService.withoutAttribute(id);
//        if (response.isSuccess()) {
//            return response.getResult();
//        }
//        log.error("failed to add backCategory {},errco code:{}");
//        throw new ResponseException(500, messageSources.get(response.getError()));

        return null;
    }

    /**
     * 查询礼品分区
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
     * 根据礼品编码查找礼品信息(弹出框信息) 1.改价 信息查询 2.改库存 信息查询
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
     * 根据礼品编码查找礼品信息
     *
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/findGoodsByGoodsCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GoodsDetailDto findGoodsByGoodsCode(String goodsCode) {
        GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
        Response<GoodsDetailDto> result = null;//presentService.findDetailByType(FIND_TYPE, goodsCode);
        if (result.isSuccess()) {
            goodsDetailDto = result.getResult();
//            if (!Strings.isNullOrEmpty(goodsDetailDto.getAttribute())) {
//                ItemsAttributeDto goodsAttributeDto = jsonMapper.fromJson(goodsDetailDto.getAttribute(),
//                        ItemsAttributeDto.class);
//                goodsDetailDto.setGoodsAttr(goodsAttributeDto);
//            }
            return goodsDetailDto;
        }
        log.error("failed to find item {},error code:{}", goodsDetailDto, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 申请下架
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/shelvesApply", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> shelvesApply(GoodsModel goodsmodel) {
        // 获取用户
        User user = UserUtil.getUser();
        Response<Boolean> response = null;//presentService.shelvesApply(goodsmodel, user);
        if (response.isSuccess()) {
            return response;
        }
        log.error("update.error, {},error code:{}", goodsmodel, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 查询后台类目一级list和授权品牌list
     *
     * @param categoryId
     * @return
     */
    @RequestMapping(value = "/findBackCategoryAndBrands", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public BackCategoryAndBrandsDto findBackCategoryAndBrands(Long categoryId) {
        BackCategoryAndBrandsDto backCategoryAndBrandsDto = new BackCategoryAndBrandsDto();
        // 获取用户信息
        User user = UserUtil.getUser();
        // 获取后台类目
//        Response<List<BackCategory>> cateResult = pointsBackCategoriesService.withoutAttribute(categoryId);
//        if (cateResult.isSuccess()) {
//            backCategoryAndBrandsDto.setBackCategoryList(cateResult.getResult());
//        }
        //授权的品牌List
        Response<List<BrandAuthorizeModel>> brandResult = brandService.findBrandListForVendor(user.getVendorId(), "", Contants.BUSINESS_TYPE_JF);
        if (brandResult.isSuccess()) {
            backCategoryAndBrandsDto.setBrandsList(brandResult.getResult());
        }
        return backCategoryAndBrandsDto;
    }


    /**
     * 后台类目 ：根据父级id查询子级
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/withoutAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<BackCategory> withoutAttribute(Long id) {
        // 后台类目
//        Response<List<BackCategory>> result = pointsBackCategoriesService.withoutAttribute(id);
//        if (result.isSuccess()) {
//            return result.getResult();
//        }
//        log.error("failed to find {},error code:{}", id, result.getError());
//        throw new ResponseException(500, messageSources.get(result.getError()));

        return null;
    }

    /**
     * 根据品牌名称模糊查询品牌list
     *
     * @param brandName
     * @return
     */
    @RequestMapping(value = "/findBrandList", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<BrandAuthorizeModel> findBrandList(String brandName) {
        // 校验
        User user = UserUtil.getUser();
        Response<List<BrandAuthorizeModel>> result = brandService.findBrandListForVendor(user.getVendorId(), "",
                Contants.BUSINESS_TYPE_JF);
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to find {},error code:{}", brandName, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
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
        checkArgument(notNull(type), "save type is null");
        PointPresentDto pointPresentDto = jsonMapper.fromJson(json, PointPresentDto.class);
        if (pointPresentDto.getCardsLevel().equals("")) {
            pointPresentDto.setCardsLevel("00");
        }
		computePrice(pointPresentDto);// 计算金普价格
        // 创建类型(供应商创建)
        pointPresentDto.setCreateType(Contants.CREATE_TYPE_1);
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
        pointPresentDto.setVendorId(user.getVendorId());
        Response<Boolean> result = null;//presentService.createPresent(pointPresentDto, user);
        if (result.isSuccess()) {
            return "ok";
        }
        log.error("failed to save goods {},errco code:{}");
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
     * 礼品管理列表页提交审核按钮事件(供应商）
     *
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/submitGoodsToApprove", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String submitGoodsToApprove(String goodsCode) {
        User user = UserUtil.getUser();
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
            goodsModel.setCreateOper(user.getName());
            Response<Integer> result = null;//presentService.updateGdInfo(goodsModel);
            if (result.isSuccess()) {
                return "ok";
            }
        }
        log.error("failed to update goods {},errco code:{}");
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 编辑礼品
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
		// 计算金普价格
		computePrice(pointPresentDto);

		Response<Boolean> result = null;//presentService.updatePresent(pointPresentDto, user, type);
        if (result.isSuccess()) {
			return result.getResult();
        }
        log.error("failed to edit goods {},errco code:{}");
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

	/**
	 * 价格计算
	 *
	 * @param pointPresentDto
	 */
	private void computePrice(PointPresentDto pointPresentDto) {
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
							// pointPresentDto.setPoints(result);
							itemModel.setMarketPrice(result);// 金普价临时存储在市场价中
						}
					}
				}
			}
		}
	}
}
