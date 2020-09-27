package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dto.GoodFullDto;
import cn.com.cgbchina.item.dto.GoodsBatchDto;
import cn.com.cgbchina.item.dto.GoodsDecorationDto;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsExportDto;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.MailStagesAndInstallmentDto;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.EspAreaInfService;
import cn.com.cgbchina.item.service.GoodsExportService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.ServicePromiseService;
import cn.com.cgbchina.item.service.SpecialPointsRateService;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import cn.com.cgbchina.related.service.AuctionQuestionInfService;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.related.service.ConfigService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.service.MailStatesService;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.html.HtmlEscapers;
import com.spirit.category.dto.RichCategory;
import com.spirit.category.model.AttributeKey;
import com.spirit.category.model.AttributeValue;
import com.spirit.category.model.Spu;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.BackCategoryService;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import jodd.jerry.Jerry;
import jodd.lagarto.dom.Node;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.misc.NotNull;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import static com.google.common.base.Objects.equal;
import static com.spirit.util.Arguments.isNull;
import static com.spirit.util.Arguments.notNull;
import static org.elasticsearch.common.base.Preconditions.checkArgument;

/**
 * Created by 陈乐 on 2016/5/19.
 */
@Controller
@RequestMapping("/api/admin/goods")
@Slf4j
public class Goods {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    @Resource
    private MessageSources messageSources;
    @Resource
    private GoodsService goodsService;
    @Resource
    private BackCategoryService backCategoryService;
    @Resource
    private BrandService brandService;
    @Resource
    private ItemService itemService;
    @Resource
    private MailStatesService mailStatesService;
    @Resource
    private VendorService vendorService;
    @Resource
    private SpecialPointsRateService specialPointsRateService;
    @Resource
    private SpuService spuService;
    @Resource
    private PointsPoolService pointsPoolService;
    @Autowired
    private CfgPriceSystemService cfgPriceSystemService;
    @Autowired
    private ConfigService configService;
    @Resource
    private EspAreaInfService espAreaInfService; // 分区
    @Resource
    private AuctionQuestionInfService auctionQuestionInfService;
    @Autowired
    private GoodsExportService goodsExportService;
    @Autowired
    private ServicePromiseService servicePromiseService;
    @Autowired
    private AttributeService attributeService;

    private String rootFilePath;

    public Goods() {
        this.rootFilePath = this.getClass().getResource("/upload").getPath();
    }

    private static final String SAVE_TYPE_SAVE = "save";// 保存、编辑方法前台传入标识
    private static final String SAVE_TYPE_AUDIT = "audit";// 保存、编辑方法前台传入标识


	/**
	 * 修改商品各渠道上下架信息
	 *
	 * @param
	 * @return
	 */
    @RequestMapping(value = "/updateGdShelf", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Integer updateGdShelf(@RequestParam(value = "array[]") String[] array, String channels, String status) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        //多件商品一键上架 FROM 追加 多件商品一键上架 陈乐 2016.11.1 2016.11.1
        if(array==null || array.length==0){
            throw new ResponseException(500, messageSources.get("请至少选择一条记录"));
        }
        int successCount =0;
        for(String code:array){
        //多件商品一键上架 TO 追加 多件商品一键上架 陈乐 2016.11.1 2016.11.1
            Response<GoodsModel> exitGoods = goodsService.findById(code);
            if(!exitGoods.isSuccess()|| exitGoods.getResult()==null){
                throw new ResponseException(500, messageSources.get("goods.not.exists.error"));
            }
            String vendorId=exitGoods.getResult().getVendorId();
            if("02".equals(status)){
                //校验供应商信息是否可用
                checkVendorInfo(vendorId);
            }

            // 根据前台传入的channel字段判断是哪个渠道
            GoodsModel goodsModel = new GoodsModel();
            goodsModel.setCode(code);
            Response<Integer> response = goodsService.updateGoodsShelf(goodsModel, channels, status);
            if(response.isSuccess()){
                successCount++;
            }
        }
        return successCount;
    }



    /**
     * 校验供应商信息
     * 停用或删除不允许进行操作
     * @param vendorId
     * @return
     */
    private void checkVendorInfo(String vendorId){
        //校验供应商
        Response<VendorInfoDto> vendorR = vendorService.findById(vendorId);
        if (!vendorR.isSuccess() || vendorR.getResult()==null) {
            log.error("vendor is not exist");
            throw new ResponseException(500, messageSources.get("vendor.not.exist"));
        }

        VendorInfoDto vendorInfoDto = vendorR.getResult();
        if(equal(Contants.VENDOR_COMMON_STATUS_0101,vendorInfoDto.getVendorModel().getStatus()) || equal(Contants.DEL_FLAG_1,vendorInfoDto.getVendorModel().getDelFlag())){
            log.error("vendor can not used");
            throw new ResponseException(500, messageSources.get("vendor.can.not.used"));
        }
    }


    /**
     * 修改库存
     *
     * @param json
     * @return
     */
    @RequestMapping(value = "/storage", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String editItemStock(@RequestParam("goods") @NotNull String json) {
        Response<Integer> response = new Response<Integer>();
        GoodsDetailDto goodsDetailDto = jsonMapper.fromJson(json, GoodsDetailDto.class);
        List<ItemModel> itemModelList = goodsDetailDto.getItemList();
        for (ItemModel itemModel : itemModelList) {
            response = goodsService.updateItemDetail(itemModel);
        }
        if (response.isSuccess()) {
            return "ok";
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
    public Boolean editItemPrice(@RequestBody GoodFullDto newDto) {
        Response<Boolean> result = new Response<>();
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        GoodsModel goodsModel = newDto.getGoodsModel();
        goodsModel.setModifyOper(user.getId());
        // 根据code更新商品信息
        String dbJson = jsonMapper.toJson(newDto);
        goodsModel.setApproveDifferent(dbJson);
        goodsModel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_04);
        Response<Boolean> response = goodsService.update(goodsModel,Collections.<ItemModel>emptyList());
        if(response.isSuccess()){
            return response.getResult();
        }
        log.error("failed to update item {},error code:{}", result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

	/**
	 * 根据id查询下级list 用于搜索条件中后台类目层级显示
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/look-toAddGdCat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<RichCategory> toAddGoodsCategoryById(Long id) {
        Response<List<RichCategory>> response = backCategoryService.childrenOf(id);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to add backCategory {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}

    /**
     * 保存商品（新增）
     *
     * @param json
     * @param type
     * @return
     */
    @RequestMapping(value = "/addGoods", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String addGoods(@RequestParam("goods") @NotNull String json, @RequestParam String type, @RequestParam String channel) {
        // 获取用户信息
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        // 校验
        if (Strings.isNullOrEmpty(type)) {
            throw new ResponseException(500, messageSources.get("save.type.is.null"));
        }
        // 渠道不存在
        if (isNull(ChannelType.from(channel))) {
            log.error("channel is not existed,channel:{}", channel);
            throw new ResponseException(500, messageSources.get("channel.not.exist"));
        }

        GoodsDto goodsDto = jsonMapper.fromJson(json, GoodsDto.class);
        GoodsModel goodsModel = goodsDto.getGoods();
        if (goodsModel.getName().length() > 80) {
            throw new ResponseException(500, messageSources.get("goods.name.too.long"));
        }

        // 供应商
        if (Strings.isNullOrEmpty(goodsModel.getVendorId())) {
            log.error("vendor.id.is.null");
            throw new ResponseException(500, messageSources.get("vendor.id.is.null"));
        }

        Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(goodsModel.getVendorId());
        if (!vendorInfoDtoResponse.isSuccess()) {
            log.error("vendor is not exist");
            throw new ResponseException(500, messageSources.get("vendor.not.exist"));
        }
        VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();

        if (equal(Contants.VENDOR_COMMON_STATUS_0101, vendorInfoDto.getVendorModel().getStatus())) {
            log.error("vendor can not used");
            throw new ResponseException(500, messageSources.get("vendor.can.not.used"));
        }

        Long spuId = goodsModel.getProductId();
        Response<Spu> spuResult = spuService.findById(spuId);
        if (!spuResult.isSuccess()) {
            throw new ResponseException(500, messageSources.get("spu.not.found"));
        }
        Spu spu = spuResult.getResult();

        Response<GoodsBrandModel> brandResponse = brandService.findBrandInfoById(Long.valueOf(spu.getBrandId()));
        if(!brandResponse.isSuccess()){
            throw new ResponseException(500, messageSources.get("find.brand.info.by.brand.Id.has.error"));
        }
        if(brandResponse.getResult()==null){
            log.error("brand.not.exit");
            throw new ResponseException(500, messageSources.get("brand.not.exit"));
        }

        Response<Boolean> authorizeResponse = brandService.checkBrandAuthorize(Long.valueOf(spu.getBrandId()),goodsModel.getVendorId(),ChannelType.from(channel).value());
        if(!authorizeResponse.isSuccess()){
            throw new ResponseException(500, messageSources.get("check.brand.authorize.by.brand.Id.has.error"));
        }
        if(!authorizeResponse.getResult()){
            log.error("can.not.use.the.brand");
            throw new ResponseException(500, messageSources.get("can.not.use.the.brand",brandResponse.getResult().getBrandName()));
        }


        goodsModel.setGoodsBrandId(Long.valueOf(spu.getBrandId())); // 品牌Id
        goodsModel.setGoodsBrandName(brandResponse.getResult().getBrandName());//品牌名称

        goodsModel.setOrdertypeId(ChannelType.from(channel).value());

        goodsModel.setName(HtmlEscapers.htmlEscaper().escape(goodsModel.getName()));
        if (SafeHtmlValidator.checkScriptAndEvent(goodsModel.getIntroduction())) {
            log.error("has invalid html content:template{}", goodsModel.getIntroduction());
            throw new ResponseException(403, messageSources.get("invalid html"));
        }
        if(!Strings.isNullOrEmpty(goodsModel.getIntroduction())){
            checkUrlInWhiteList(goodsModel.getIntroduction());
        }
        //推荐商品
        if(!Strings.isNullOrEmpty(goodsDto.getRecommendGoodsCodes())){
            List<String> strings = Splitter.on(",").omitEmptyStrings().splitToList(goodsDto.getRecommendGoodsCodes());
            for(int i =0;i<strings.size();i++){
                try {
                    Method method = goodsModel.getClass().getMethod("setRecommendGoods" + (i + 1) + "Code",String.class);
                    method.invoke(goodsModel,strings.get(i));
                } catch (Exception e) {
                    log.error("no such method error",e);//won't happen
                }
            }
        }
        goodsModel.setCreateType(Contants.CERATE_TYPE_ADMIN_0); // 创建类型(平台创建)

        switch (channel){
            case Contants.ORDERTYPEID_YG:
                checkGoodDto(goodsDto);//校验数据
                goodsModel.setChannelMall(GoodsModel.Status.INIT.value()); // 广发商城渠道的销售状态置为处理中
                goodsModel.setChannelMallWx(GoodsModel.Status.INIT.value()); // 广发商城-微信
                goodsModel.setChannelCreditWx(GoodsModel.Status.INIT.value()); // 信用卡中心-微信
                goodsModel.setChannelApp(GoodsModel.Status.INIT.value()); // APP
                goodsModel.setPointsType(Contants.JGID_COMMON);// 商品积分类型默认设为普通积分
                getBestRate(goodsDto);
                break;
            case Contants.ORDERTYPEID_JF:
                checkPresentDto(goodsDto);
                goodsModel.setChannelPoints(GoodsModel.Status.INIT.value());//积分商城渠道
                goodsModel.setChannelIvr(GoodsModel.Status.INIT.value());//IVR 渠道
                computePrice(goodsDto.getItemList());//计算金普价格
                for (ItemModel itemModel : goodsDto.getItemList()) {
                    itemModel.setIsShow(goodsDto.getIsShow());//是否隐藏
                }
                break;
        }
        goodsModel.setChannelCc(GoodsModel.Status.INIT.value()); // CC
        goodsModel.setChannelPhone(GoodsModel.Status.INIT.value()); // 手机商城
        goodsModel.setChannelSms(GoodsModel.Status.INIT.value()); // 短信

        goodsModel.setCreateOper(user.getId());//创建人
        goodsModel.setModifyOper(user.getId());//修改人
        goodsModel.setAutoOffShelfTime(goodsModel.getAutoOffShelfTime());

        // 审核状态
        if (SAVE_TYPE_SAVE.equals(type)) {
            goodsModel.setApproveStatus(GoodsModel.ApproveStatus.EDITING_00.value());// 编辑中
        } else if (SAVE_TYPE_AUDIT.equals(type)) {
            goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_FIRST_01.value());// 待初审
        }

        Response<Boolean> result = goodsService.createGoods(goodsModel, goodsDto.getItemList(), vendorInfoDto.getVendorNo(),channel);
        if (result.isSuccess()) {
            return "ok";
        }
        log.error("failed to save goods {},errco code:{}");
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 外网链接白名单校验
     * @param html
     */
    private void checkUrlInWhiteList(String html){
        Response<List<String>> whiteR = auctionQuestionInfService.findLinkUrl();
        if (whiteR.isSuccess()){
            List<String> whiteList = whiteR.getResult();
            Jerry doc = Jerry.jerry(html);
            Node[] ns = doc.$("a").get();
            for (Node n : ns) {
                String  attrValue = n.getAttribute("href");
                if(!whiteList.contains(attrValue)) {
                    log.error("has.url.not.in.white.list:template{}", html);
                    throw new ResponseException(403, messageSources.get("has.url.not.in.white.list"));
                }
            }
        }else{
            log.error("failed to find white list");
            throw new ResponseException(500, messageSources.get(whiteR.getError()));
        }
    }

    /**
     * 商品校验
     * @param goodsDto
     */
    private void checkGoodDto(GoodsDto goodsDto){
        try {
            GoodsCheckUtil.checkGoodName(goodsDto.getGoods().getName());//商品名称校验
            GoodsCheckUtil.timeAfterNow(LocalDateTime.fromDateFields(goodsDto.getGoods().getAutoOffShelfTime()).toDateTime());//自动下架时间

            //校验单品信息
            List<ItemModel> itemList = goodsDto.getItemList();
            for (ItemModel itemModel : itemList) {
                if(itemModel.getProductPointRate()!=null) {
                    GoodsCheckUtil.checkRate(itemModel.getProductPointRate().toString());//商品积分输入
                }
                if(itemModel.getO2oCode() != null) {
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oCode(), "item.o2oCode.error");//
                }
               if(itemModel.getO2oVoucherCode()!=null){
                   GoodsCheckUtil.checkSpecial(itemModel.getO2oVoucherCode(),"item.o2oVoucherCode.error");
               }
                GoodsCheckUtil.checkPrice(itemModel.getPrice().toString());//商品售价有误
               if (itemModel.getMarketPrice() !=null){
                   GoodsCheckUtil.checkPrice(itemModel.getMarketPrice().toString());//市场价
               }
                GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStock()),"stock.format.error");//库存校验
                if(itemModel.getFixPoint()!=null) {
                    GoodsCheckUtil.checkNum1To9(String.valueOf(itemModel.getFixPoint()), "fixpoint.format.error");//固定积分
                }
                if(itemModel.getStockWarning()!=null){
                    GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStockWarning()),"stockWarning.format.error");//库存预警
                }
                if(itemModel.getStock()!=null && itemModel.getStockWarning()!=null){
                    if(itemModel.getStockWarning()>itemModel.getStock()){
                        throw new  IllegalArgumentException("stock.greater.than.stockPrice.error");
                    }
                }

            }
        }catch (IllegalArgumentException e){
            throw new ResponseException(500,messageSources.get(e.getMessage()));
        }
    }
    private void checkPresentDto(GoodsDto goodsDto){
        try {
            GoodsCheckUtil.checkGoodName(goodsDto.getGoods().getName());//商品名称校验
            GoodsCheckUtil.timeAfterNow(LocalDateTime.fromDateFields(goodsDto.getGoods().getAutoOffShelfTime()).toDateTime());//自动下架时间

            // 分区校验 add by zhoupeng
            String areaId = goodsDto.getGoods().getRegionType();
            if (!Strings.isNullOrEmpty(areaId)) {
                Map<String, Object> params = Maps.newHashMapWithExpectedSize(1);
                params.put("areaId", areaId);
                EspAreaInfModel model = espAreaInfService.findByAreaId(params).getResult();
                if (!Objects.equals("0102", model.getCurStatus())) {
                    throw new IllegalArgumentException("goods.regionType.invalid");
                }
            }else{
                throw new IllegalArgumentException("goods.regionType.null");
            }

            //校验单品信息
            List<ItemModel> itemList = goodsDto.getItemList();
            for (ItemModel itemModel : itemList) {

                if(itemModel.getO2oCode() != null) {
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oCode(), "item.o2oCode.error");//
                }
                if(itemModel.getO2oVoucherCode()!=null){
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oVoucherCode(),"item.o2oVoucherCode.error");
                }
                GoodsCheckUtil.checkPrice(itemModel.getPrice().toString());//商品售价有误
                GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStock()),"stock.format.error");//库存校验
                if(itemModel.getStockWarning()!=null){
                    GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStockWarning()),"stockWarning.format.error");//库存预警
                }
                if(itemModel.getStock()!=null && itemModel.getStockWarning()!=null){
                    if(itemModel.getStockWarning()>itemModel.getStock()){
                        throw new  IllegalArgumentException("stock.greater.than.stockPrice.error");
                    }
                }
                if(itemModel.getVirtualPrice()!=null) {
                    GoodsCheckUtil.checkPrice(itemModel.getVirtualPrice().toString());
                }
                if( itemModel.getBid()!=null && itemModel.getBid().length()!=0 &&Integer.valueOf(itemModel.getBid())<=0){
                    throw new  IllegalArgumentException("item.bid.greater.than.zero");
                }


            }
        }catch (IllegalArgumentException e){
            throw new ResponseException(500,messageSources.get(e.getMessage()));
        }

    }

    /**
     * 价格计算
     *
     * @param itemList
     */
    private void computePrice(List<ItemModel> itemList){
        Response<List<CfgPriceSystemModel>> response = cfgPriceSystemService.findByPriceSystemId("0000");// 金普价
        if (response.isSuccess()) {
            Response<TblConfigModel> tblconfigModel = configService.findByCfgType("stock_param");
            if (tblconfigModel.isSuccess()) {
                for (ItemModel itemModel :itemList) {
                    BigDecimal cgbValue1 = new BigDecimal(tblconfigModel.getResult().getCfgValue1());
                    BigDecimal price = itemModel.getPrice();
                    BigDecimal goldCommon = price.multiply(cgbValue1.add(new BigDecimal(String.valueOf("1"))));
                    for (CfgPriceSystemModel cfgPriceSystemModel : response.getResult()) {
                        if (cfgPriceSystemModel.getUpLimit() > goldCommon.intValue()
                                && cfgPriceSystemModel.getDownLimit() <= goldCommon.intValue()) {
                            BigDecimal argumentNormal = cfgPriceSystemModel.getArgumentNormal();
                            BigDecimal result = goldCommon.divide(argumentNormal, 0, BigDecimal.ROUND_HALF_UP);
                            itemModel.setMarketPrice(result);//金普价临时存储在市场价中
                        }
                    }
                }
            }
        }
    }




    /**
     * 获取最佳倍率并计算最大积分返回给itemList
     * @param goodsDto
     */

    private void getBestRate(GoodsDto goodsDto){
        List<ItemModel> itemList = goodsDto.getItemList();
        //获取当月积分池的单位积分
        Response<PointPoolModel> pointPoolResponse = pointsPoolService.getCurMonthInfo();
        if(!pointPoolResponse.isSuccess() || pointPoolResponse.getResult()==null){
            throw new ResponseException(500, messageSources.get("current.month.point.is.null"));
        }
        Long singlePoint = pointPoolResponse.getResult().getSinglePoint();

        // 获取最佳倍率
        BigDecimal bestRate = new BigDecimal(0);
        if (goodsDto.getProductPointRateParam() != null) {// 商品积分不为空，最佳倍率的值为商品积分
            bestRate = goodsDto.getProductPointRateParam();
        } else {
            Response<BigDecimal> response = specialPointsRateService.calculateBestRate(goodsDto.getGoods());
            if (response.isSuccess()) {
                bestRate = response.getResult();
            }
        }
        for (ItemModel itemModel : itemList) {
            itemModel.setBestRate(bestRate);//最佳倍率
            itemModel.setProductPointRate(goodsDto.getProductPointRateParam());//积分支付比例
            itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
            itemModel.setDisplayFlag(goodsDto.getDisplayFlag());//是否仅显示全积分支付
        }
    }


    /**
     * 保存商品（编辑）
     *
     * @param json
     * @param type
     * @return
     */
    @RequestMapping(value = "/update/{code}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean update(@PathVariable("code") String code, @RequestParam("goods") @NotNull String json, @RequestParam String type, @RequestParam String channel) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(403, messageSources.get("user.not.login"));
        }
        // 校验
        if (Strings.isNullOrEmpty(type)) {
            throw new ResponseException(500, messageSources.get("save.type.is.null"));
        }
        // 渠道不存在
        if (isNull(ChannelType.from(channel))) {
            log.error("channel is not existed,channel:{}", channel);
            throw new ResponseException(500, messageSources.get("channel.not.exist"));
        }
        // 查询商品信息
        Response<GoodsModel> goodsModelR = goodsService.findById(code);
        if (!goodsModelR.isSuccess()) {
            log.error("goods not found ,good code:{}", code);
            throw new ResponseException(500, "goods.not.found");
        }
        GoodsModel existGoods = goodsModelR.getResult();
        // 解析页面输入的值
        GoodsDto goodsDto = jsonMapper.fromJson(json, GoodsDto.class);

        GoodsModel goodsModel = goodsDto.getGoods();//如果是直接更新表中数据的状态用

        // 第三级卡编码 校验
        String cards = goodsModel.getCards();
        if(Strings.isNullOrEmpty(cards) || cards.length() > 5000)
            throw new ResponseException("cards.is.error");

        List<ItemModel> itemList = goodsDto.getItemList();

        //校验供应商信息是否可用
        checkVendorInfo(goodsModel.getVendorId());

        Response<Boolean> authorizeResponse = brandService.checkBrandAuthorize(Long.valueOf(existGoods.getGoodsBrandId()),existGoods.getVendorId(),ChannelType.from(channel).value());
        if(!authorizeResponse.isSuccess()){
            throw new ResponseException(500, messageSources.get("check.brand.authorize.by.brand.Id.has.error"));
        }
        if(!authorizeResponse.getResult()){
            log.error("can.not.use.the.brand");
            throw new ResponseException(500, messageSources.get("can.not.use.the.brand",existGoods.getGoodsBrandName()));
        }

        if(!Strings.isNullOrEmpty(goodsModel.getIntroduction())){
            checkUrlInWhiteList(goodsModel.getIntroduction());
        }

        if(Contants.ORDERTYPEID_YG.equals(channel)){
            //计算最佳倍率需要品牌信息
            goodsDto.getGoods().setGoodsBrandId(existGoods.getGoodsBrandId());
            getBestRate(goodsDto);
            checkGoodDto(goodsDto);//校验数据
        }else{
            checkPresentDto(goodsDto);
            computePrice(itemList);//计算金普价
            for (ItemModel itemModel : itemList) {
                itemModel.setIsShow(goodsDto.getIsShow());//是否隐藏
            }
        }

        // 如果商品code不匹配，抛出异常
        if (!equal(goodsModel.getCode(), existGoods.getCode())) {
            log.error("goodscode not correct");
            throw new ResponseException(500, "goods.not.found");
        }
        if (goodsModel.getName().length() > 200) {
            throw new ResponseException(500, messageSources.get("goods.name.too.long"));
        }
        goodsModel.setName(HtmlEscapers.htmlEscaper().escape(goodsModel.getName()));

        //推荐商品
        List<String> strings = Splitter.on(",").omitEmptyStrings().splitToList(goodsDto.getRecommendGoodsCodes());
        for(int i =0;i<strings.size();i++){
            try {
                Method method = goodsModel.getClass().getMethod("setRecommendGoods" + (i + 1) + "Code",String.class);
                method.invoke(goodsModel,strings.get(i));
            } catch (Exception e) {
                e.printStackTrace();
                log.error("no such method error",e);//won't happen
            }
        }

        Response<Boolean> result;
        if(SAVE_TYPE_SAVE.equals(type)){
            goodsModel.setApproveStatus(GoodsModel.ApproveStatus.EDITING_00.value());
            result = goodsService.updateWithoutNull(goodsModel,itemList,channel,user);
        }else {
            //如果是编辑中或者初审拒绝或者是复审拒绝，则将状态置为待初审
            if(equal(existGoods.getApproveStatus(), GoodsModel.ApproveStatus.EDITING_00.value())
                    || equal(existGoods.getApproveStatus(), GoodsModel.ApproveStatus.REFUSE_FIRST_O1.value())
                    || equal(existGoods.getApproveStatus(), GoodsModel.ApproveStatus.REFUSE_SECOND_02.value())){
                goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_FIRST_01.value());
                result = goodsService.updateWithoutNull(goodsModel,itemList,channel,user);
            }else{
                GoodsModel approveGoods = new GoodsModel();
                GoodFullDto goodFullDto = new GoodFullDto();

                //不允许变更的数据
                goodsModel.setOrdertypeId(existGoods.getOrdertypeId());
                goodsModel.setProductId(existGoods.getProductId());
                goodsModel.setGoodsBrandId(existGoods.getGoodsBrandId());
                goodsModel.setGoodsBrandName(existGoods.getGoodsBrandName());
                goodFullDto.setGoodsModel(goodsModel);
                goodFullDto.setItemList(itemList);
                String diff = jsonMapper.toJson(goodFullDto);
                //其他情况将状态置为商品变更审核,将json串存在approve_different 字段中
                approveGoods.setApproveStatus(GoodsModel.ApproveStatus.TRILA_CHANGE_03.value());
                approveGoods.setApproveDifferent(diff);
                approveGoods.setCode(goodsDto.getGoods().getCode());
                result = goodsService.update(approveGoods, Collections.<ItemModel>emptyList());
            }
        }
        if (result.isSuccess()) {
            return Boolean.TRUE;
        }
        throw new ResponseException(500, "goods.update.error");
    }


    @ToString
    public static class GoodsDto {
        @Getter
        @Setter
        private BigDecimal productPointRateParam;
        @Getter
        @Setter
        private String vendorNo;
        @Getter
        @Setter
        private GoodsModel goods;// 商品
        @Getter
        @Setter
        private List<ItemModel> itemList;// 单品
        @Getter
        @Setter
        private String recommendGoodsCodes;//推荐商品
        @Getter
        @Setter
        private Integer displayFlag;//是否仅显示全积分支付
        @Getter
        @Setter
        private Integer isShow;//是否隐藏
    }


    /**
     * 推荐单品列表取得
     *
     * @param searchKey
     * @return
     */
    @RequestMapping(value = "/add-findRecommendationItemList", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<ItemDto> findRecommendationItemList(String searchKey) {
        Response<List<ItemDto>> itemDtoList = itemService.findItemListByCodeOrName(searchKey, Contants.BUSINESS_TYPE_YG);
        if (itemDtoList.isSuccess()) {
            return itemDtoList.getResult();
        }
        log.error("failed to find itemList {},error code:{}", searchKey, itemDtoList.getError());
        throw new ResponseException(500, messageSources.get(itemDtoList.getError()));

    }


    /**
     * 审核商品
     *
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/audit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean examGoods(@PathVariable("id") String goodsCode, GoodsBatchDto goodsBatchDto) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        checkArgument(notNull(goodsCode), "goodsCode.is.null");
        checkArgument(notNull(goodsBatchDto.getApproveResult()), "approveResult.is.null");
        checkArgument(notNull(goodsBatchDto.getApproveType()), "approveType.is.null");
        String approveMemo = HtmlEscapers.htmlEscaper().escape(goodsBatchDto.getApproveMemo());
        goodsBatchDto.setApproveMemo(approveMemo);
        //校验供应商信息是否可用
        Response<GoodsModel> exitGoods = goodsService.findById(goodsCode);
        if(!exitGoods.isSuccess()|| exitGoods.getResult()==null){
            throw new ResponseException(500, messageSources.get("goods.not.exists.error"));
        }
        String vendorId = exitGoods.getResult().getVendorId();
        if("pass".equals(goodsBatchDto.getApproveResult())){
            checkVendorInfo(vendorId);
        }
        Response<Boolean> result = goodsService.examGoods(goodsBatchDto ,user);
        if(result.isSuccess()){
            return result.getResult();
        }
        log.error("failed to edit goodsCode{},error code:{}",goodsCode,result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }


    /**
     * 批量审核
     *
     * @param goodsBatchDtoList
     * @return
     */
    @RequestMapping(value = "audit-multi/{channel}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Integer updateAllGoodsStatus(@RequestBody GoodsBatchDto[] goodsBatchDtoList,@PathVariable("channel") String channel) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        int successCount=0;
        for (GoodsBatchDto goodsBatchDto : goodsBatchDtoList) {
            //校验供应商信息是否可用
            Response<GoodsModel> exitGoods = goodsService.findById(goodsBatchDto.getCode());
            if(!exitGoods.isSuccess()|| exitGoods.getResult()==null){
                throw new ResponseException(500, messageSources.get("goods.not.exists.error"));
            }
            String vendorId = exitGoods.getResult().getVendorId();
            if("pass".equals(goodsBatchDto.getApproveResult())){
                checkVendorInfo(vendorId);
            }
            Response<Boolean> response = goodsService.examGoods(goodsBatchDto ,user);
            if(response.isSuccess()){
                successCount++;
            }
        }
        return successCount;
    }


    /**
     * 根据供应商id查询邮购分期类别码
     *
     * @param vendorId
     * @return
     */
    @RequestMapping(value = "/add-findMailStagesAndPeriod", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public MailStagesAndInstallmentDto findMailStagesAndPeriod(String vendorId) {
        MailStagesAndInstallmentDto mailStagesAndInstallmentDto = new MailStagesAndInstallmentDto();
        Response<List<MailStagesModel>> mailResult = mailStatesService.findMailStagesListByVendorId(vendorId);
        if (mailResult.isSuccess()) {
            mailStagesAndInstallmentDto.setMailStagesModelList(mailResult.getResult());
        }
        Response<List<TblVendorRatioModel>> periodResult = vendorService.findRaditListByVendorId(vendorId);
        if (periodResult.isSuccess()) {
            List<TblVendorRatioModel> list = periodResult.getResult();
            List<Integer> periodList = Lists.newArrayList();
            for (TblVendorRatioModel tblVendorRatioModel : list) {
                periodList.add(tblVendorRatioModel.getPeriod());
            }
            mailStagesAndInstallmentDto.setPeriodList(periodList);
        }
        return mailStagesAndInstallmentDto;
    }


    /**
     * 修改商品各渠道上下架信息(一键修改全部)
     *
     * @param code 商品ID
     * @return 更新结果
     */
    @RequestMapping(value = "/updateGdShelfAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public String updateGdShelfAll(String code,String channels,String state) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        //校验供应商信息是否可用
        Response<GoodsModel> exitGoods = goodsService.findById(code);
        if(!exitGoods.isSuccess()|| exitGoods.getResult()==null){
            throw new ResponseException(500, messageSources.get("goods.not.exists.error"));
        }
        String vendorId = exitGoods.getResult().getVendorId();
        if("02".equals(state)){
            checkVendorInfo(vendorId);
        }
        GoodsModel goodsModel = new GoodsModel();
        goodsModel.setCode(code);
        // 一键上架，商品全部渠道上架
        Response<Integer> response = goodsService.updateGoodsShelf(goodsModel, channels, state);
        if (response.isSuccess()) {
            return "ok";
        }
        log.error("failed to update goods shelf {},error code:{}", response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }


    /**
     * 根据商品编码取得商品、单品信息
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/getGoodInfo", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GoodFullDto getGoodInfo(@RequestParam("goodsCode") String goodsCode) {
        Response<GoodFullDto> response = goodsService.findDetail_new("1", goodsCode);//走商品查看
        if(response.isSuccess()){
            return response.getResult();
        }
        log.error("failed to get goods info {},error code:{}",goodsCode, response.getError());
        throw new ResponseException(500, messageSources.get(response.getError()));
    }

    /**
     * 商品提交审核事件
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/submitGoodsToAudit",method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean submitGoodsToAudit(String goodsCode){
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        if(Strings.isNullOrEmpty(goodsCode)){
            throw new ResponseException(500, messageSources.get("good.not.exist"));
        }

        //校验供应商信息是否可用
        Response<GoodsModel> exitGoods = goodsService.findById(goodsCode);
        if(!exitGoods.isSuccess()|| exitGoods.getResult()==null){
            throw new ResponseException(500, messageSources.get("goods.not.exists.error"));
        }
        String vendorId = exitGoods.getResult().getVendorId();
        checkVendorInfo(vendorId);

        GoodsModel  goodsModel = new GoodsModel();
        goodsModel.setCode(goodsCode);
        goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_FIRST_01.value());//变为待初审状态
        Response<Boolean> result = goodsService.update(goodsModel, Collections.<ItemModel>emptyList());
        if(result.isSuccess()){
            return Boolean.TRUE;
        }
        log.error("failed to submit goods to audit {},error code:{}",goodsCode, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
	 * 根据指定条件取得单品、商品列表
	 *
	 * @return GoodsDecorationDto
	 */
	@RequestMapping(value = "/findItemListForDecoration", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<List<GoodsDecorationDto>> findItemListForProm(String backCategoryId, String goodsName) {

		Response<List<GoodsDecorationDto>> response = new Response<List<GoodsDecorationDto>>();
		try {
			response = goodsService.findDecorationGoods(backCategoryId, goodsName);
			return response;
		} catch (Exception e) {
			log.error("GoodsDetailService.findDecorationGoods.fail,cause:{}", Throwables.getStackTraceAsString(e));
			return response;
		}
	}

    /**
     * 下载导入模板
     *
     * @param response
     */
    @RequestMapping(value = "/import-exportTemplateExcel")
    public void exportTemplateExcel(HttpServletResponse response, @RequestParam("spuIds") String spuIds,
                                    @RequestParam("channel") String channel) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, "user.not.login");
        }
        ChannelType channelType = ChannelType.from(channel);
        // 渠道不存在
        if (isNull(channelType)) {
            log.error("channel is not existed,channel:{}", channel);
            throw new ResponseException("channel.not.exist");
        }

        try {
            String fileName = "item_import_admin_template.xlsx"; // 输出给前台显示的文件名

            String filePath = "";
            if(Contants.BUSINESS_TYPE_YG.equals(channel)){
                filePath = rootFilePath + "/template/item_import_admin.xlsx";// 文件的绝对路径
            }else{
                filePath = rootFilePath + "/template/point_import.xlsx";
            }
            Map<String, Object> context = Maps.newHashMap();

            List<SpuDto> resultSpus=Lists.newArrayList();
            List<String> spus = Splitter.on(",").trimResults().splitToList(spuIds);
            for(String id:spus){
                makeSpuDtos(Long.valueOf(id),resultSpus);
            }
            context.put("skus", resultSpus);

            // 服务承诺
            List<ServicePromiseModel> serviceList = Lists.newArrayList();
            Response<List<ServicePromiseModel>> serviceRe = servicePromiseService.findAllebled();
            if(serviceRe.isSuccess()){
                serviceList = serviceRe.getResult();
            }
            context.put("services",serviceList);

            //分区(积分商城特有)
            if(Contants.BUSINESS_TYPE_JF.equals(channel)){
                List<EspAreaInfModel> areaList = Lists.newArrayList();
                Response<List<EspAreaInfModel>> areaR = espAreaInfService.findAreaInfoByParams(Collections.<String,Object>emptyMap());
                if(areaR.isSuccess()){
                    areaList = areaR.getResult();
                }
                context.put("areas",areaList);
            }

            ExportUtils.exportTemplate(response, fileName, filePath, context);
        } catch (Exception e) {
            // 此处不处理异常，这些方法不会抛异常，抛出的运行时异常框架会将页面跳走
            log.error("fail to export excel template");
            throw new ResponseException(500, messageSources.get("export.template.excel.error"));
        }
    }

    private void makeSpuDtos(long spuId,List<SpuDto> resultSpus){
        Response<Spu> spuResponse = spuService.findById(spuId);
        Spu spu = spuResponse.getResult();

        // 查询SPU销售属性以及销售属性值
        SpuDto spuDto;
        Map<AttributeKey, List<AttributeValue>> skuAttributeMap = attributeService.findSkuAttributesNoCache(spuId);
        for (Map.Entry<AttributeKey, List<AttributeValue>> entry : skuAttributeMap.entrySet()) {
            AttributeKey attributeKey = entry.getKey();
            List<AttributeValue> values = entry.getValue();
            for(AttributeValue attributeValue:values){
                spuDto=new SpuDto();
                spuDto.setSpuId(spuId);
                spuDto.setSpuName(spu.getName());
                spuDto.setAttrName(attributeKey.getName());
                spuDto.setAttrVal(attributeValue.getValue());
                spuDto.setAttrValId(attributeValue.getId());
                resultSpus.add(spuDto);
            }
        }
    }

    @Setter
    @Getter
    @ToString
    public static class SpuDto{
        private Long spuId;
        private String attrName;
        private String attrVal;
        private Long attrValId;
        private String spuName;
    }


    /**
     * 商品、礼品导出
     * @param params
     * @param httpServletResponse
     */
    @RequestMapping(value = "/exportGoodsData", method = RequestMethod.POST)
    @ResponseBody
    public void exportGoodsData(@RequestParam Map<String, String> params,HttpServletResponse httpServletResponse) {
        // 获取用户信息
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        String fileName = "";
        String filePath = "";
        String channel=params.get("channel");
        if(Contants.BUSINESS_TYPE_YG.equals(channel)){
            fileName = "GoodsItems" + LocalDate.now().toString() + ".xlsx";
            filePath = rootFilePath + "/template/goods_export_file.xlsx";
        }else{
            fileName = "GiftItems" + LocalDate.now().toString() + ".xlsx";
            filePath = rootFilePath + "/template/gift_export_file.xlsx";

            params.put("goodsType","00");
        }

        try {
            Response<List<GoodsExportDto>> goodsItems = goodsExportService.findGoodsItemsData(params,user,channel);
            if (goodsItems.isSuccess()) {
                Map<String, Object> paramMap = Maps.newHashMap();
                List<GoodsExportDto> list = goodsItems.getResult();
                paramMap.put("goods", list == null ? Collections.emptyList() : list);
                ExportUtils.exportTemplate(httpServletResponse, fileName, filePath, paramMap);
            } else {
                log.error("failed to export item {},error code:{}", params.toString(),
                        goodsItems.getError());
                throw new ResponseException(500, messageSources.get(goodsItems.getError()));
            }
        } catch (Exception e) {
            log.error("fail to export exportOrderSign data, bad code{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, e.getMessage());
        }
    }

}
