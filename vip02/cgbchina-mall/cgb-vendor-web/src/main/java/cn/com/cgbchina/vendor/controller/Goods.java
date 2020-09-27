/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import cn.com.cgbchina.related.service.AuctionQuestionInfService;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.related.service.ConfigService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.MailStatesService;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.html.HtmlEscapers;
import com.spirit.category.dto.RichCategory;
import com.spirit.category.model.*;
import com.spirit.category.model.BackCategory;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.BackCategoryService;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import jodd.jerry.Jerry;
import jodd.lagarto.dom.Node;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.util.IOUtils;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.util.*;

import static com.google.common.base.Objects.equal;
import static com.spirit.util.Arguments.isNull;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/5/30.
 */
@Controller
@RequestMapping("/api/vendor/goods")
@Slf4j
public class Goods {
    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
    @Resource
    private MessageSources messageSources;
    @Resource
    private GoodsService goodsService;
    @Resource
    private ItemService itemService;
    @Resource
    private AuditLoggingService auditLoggingService;
    @Resource
    private GoodsOperateDetailService goodsOperateDetailService;
    @Resource
    private MallPromotionService mallPromotionService;
    @Resource
    private VendorService vendorService;
    @Autowired
    private ServicePromiseService servicePromiseService;// 服务承诺
    @Resource
    private MailStatesService mailStatesService;
    @Resource
    private SpuService spuService;
    @Resource
    private PointsPoolService pointsPoolService;
    @Resource
    private BackCategoryService backCategoryService;
    @Resource
    private SpecialPointsRateService specialPointsRateService;
    @Autowired
    private CfgPriceSystemService cfgPriceSystemService;
    @Autowired
    private ConfigService configService;
    @Resource
    private BrandService brandService; // 品牌
    @Autowired
    private GoodsExportService goodsExportService;

    // TODO 两个分区service 会不会有问题？
    @Resource
    private EspAreaInfService espAreaInfService; // 分区
    @Resource
    private GiftPartitionService giftPartitionService; // 礼品分区
    @Resource
    private AuctionQuestionInfService auctionQuestionInfService;
    @Resource
    private AttributeService attributeService;

    @Autowired
    BackCategoryHierarchy bch;

    private final static Set<String> allowed_types = ImmutableSet.of("xlsx", "xls");
    private static final String SAVE_TYPE_SAVE = "save";// 保存、编辑方法前台传入标识
    private static final String SAVE_TYPE_AUDIT = "audit";// 保存、编辑方法前台传入标识
    private String rootFilePath;
    private static int BUFSIZE = 65535;

    public Goods() {
        this.rootFilePath = this.getClass().getResource("/upload").getPath();
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
            String fileName = "item_import_vendor_template.xlsx"; // 输出给前台显示的文件名

            String filePath = "";
            if(Contants.BUSINESS_TYPE_YG.equals(channel)){
                filePath = rootFilePath + "/template/item_import_vendor.xlsx";// 文件的绝对路径
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

            // 邮购分期类别码(广发商城特有)
            if(Contants.BUSINESS_TYPE_YG.equals(channel)){
                List<MailStagesModel> mailList = Lists.newArrayList();
                Response<List<MailStagesModel>> mailStageR = mailStatesService.findMailStagesListByVendorId(user.getVendorId());
                if(mailStageR.isSuccess()){
                    mailList = mailStageR.getResult();
                }
                context.put("mails",mailList);
            }

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




    /**
     * 根据供应商id 查询该供应商下的有关邮购 分期 角色信息
     *
     * @return MailStagesAndInstallmentDto
     */
    @RequestMapping(value = "/add-findMailStagesAndPeriodAndVendorRole", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> findMailStagesAndPeriodAndVendorRole() {
        // 获取用户信息
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        String vendorId = user.getVendorId();
        Map<String, Object> resultMap = Maps.newHashMapWithExpectedSize(3);
        MailStagesAndInstallmentDto mailStagesAndInstallmentDto = null;
        try {
            Response<List<MailStagesModel>> mailResult = mailStatesService.findMailStagesListByVendorId(vendorId);
            if (mailResult.isSuccess()) {
                mailStagesAndInstallmentDto = new MailStagesAndInstallmentDto();
                mailStagesAndInstallmentDto.setMailStagesModelList(mailResult.getResult());
            }
        } catch (Exception e) {
            log.error("Goods.findMailStagesAndPeriodAndVendorRole.findMailStagesListByVendorId.findFailed {} ",
                    Throwables.getStackTraceAsString(e));
        }
        try {
            Response<List<TblVendorRatioModel>> periodResult = vendorService.findRaditListByVendorId(vendorId);
            if (periodResult.isSuccess()) {
                if (null == mailStagesAndInstallmentDto)
                    mailStagesAndInstallmentDto = new MailStagesAndInstallmentDto();
                List<TblVendorRatioModel> list = periodResult.getResult();
                List<Integer> periodList = Lists.newArrayList();
                for (TblVendorRatioModel tblVendorRatioModel : list) {
                    periodList.add(tblVendorRatioModel.getPeriod());
                }
                mailStagesAndInstallmentDto.setPeriodList(periodList);
            }
        } catch (Exception e) {
            log.error("Goods.findMailStagesAndPeriodAndVendorRole.findRaditListByVendorId.findFailed {} ",
                    Throwables.getStackTraceAsString(e));
        }
        try {
            Response<VendorInfoModel> vendorInfoModelResponse = vendorService.findVendorById(vendorId);
            if (vendorInfoModelResponse.isSuccess()) {
                if (null != vendorInfoModelResponse.getResult())
                    resultMap.put("vendorRole", vendorInfoModelResponse.getResult().getVendorRole());
            }
        } catch (Exception e) {
            log.error("Goods.findMailStagesAndPeriodAndVendorRole.findVendorById.findFailed {} ",
                    Throwables.getStackTraceAsString(e));
        }
        resultMap.put("mailStagesAndInstallment", mailStagesAndInstallmentDto);

        return resultMap;
    }

    /**
     * 查询 所有可用的 服务承诺
     *
     * @return List
     */
    @RequestMapping(value = "/findAllPromise", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    private List<ServicePromiseModel> findAllPromise() {
        // 查询所有可用的服务列表
        Response<List<ServicePromiseModel>> servicesR = servicePromiseService.findAllebled();
        if (servicesR.isSuccess()) {
            return servicesR.getResult();
        }
        return Lists.newArrayList();
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
    public String addGoods(@RequestParam("goods") @org.antlr.v4.runtime.misc.NotNull String json,
                           @RequestParam String type, @RequestParam String channel) {
        // 获取用户信息
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        try {
            // 校验
            if (Strings.isNullOrEmpty(type)) {
                throw new ResponseException("save.type.is.null");
            }
            ChannelType channelType = ChannelType.from(channel);
            // 渠道不存在
            if (isNull(channelType)) {
                log.error("channel is not existed,channel:{}", channel);
                throw new ResponseException("channel.not.exist");
            }

            GoodsDto goodsDto = jsonMapper.fromJson(json, GoodsDto.class);
            GoodsModel goodsModel = goodsDto.getGoods();
            if (goodsModel.getName().length() > 80) {
                throw new ResponseException("goods.name.too.long");
            }
            // 设置渠道信息
            goodsModel.setOrdertypeId(channelType.value());

            // 第三级卡编码 校验
            String cards = goodsModel.getCards();
            if (Strings.isNullOrEmpty(cards) || cards.length() > 5000)
                throw new ResponseException("cards.is.error");

            // 供应商 校验
            String vendorId = user.getVendorId();
            if (Strings.isNullOrEmpty(goodsModel.getVendorId())) {
                if (!Strings.isNullOrEmpty(vendorId)) {
                    goodsModel.setVendorId(vendorId);
                } else {
                    log.error("save.vendor.info.is.null");
                    throw new ResponseException("save.vendor.is.null");
                }
            }
            Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(goodsModel.getVendorId());
            if (!vendorInfoDtoResponse.isSuccess()) {
                log.error("vendor is not exist");
                throw new ResponseException("vendor.not.exist");
            }
            VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();

            if (equal(Contants.VENDOR_COMMON_STATUS_0101, vendorInfoDto.getVendorModel().getStatus())) {
                log.error("vendor can not used");
                throw new ResponseException(500, messageSources.get("vendor.can.not.used"));
            }

            // 产品信息
            Long spuId = goodsModel.getProductId();
            Response<Spu> spuResult = spuService.findById(spuId);
            if (!spuResult.isSuccess()) {
                throw new ResponseException("spu.not.found");
            }
            Spu spu = spuResult.getResult();

            // 品牌信息
            Response<GoodsBrandModel> brandResponse = brandService.findBrandInfoById(Long.valueOf(spu.getBrandId()));
            if (!brandResponse.isSuccess()) {
                throw new ResponseException("find.brand.info.by.brand.Id.has.error");
            }
            if (brandResponse.getResult() == null) {
                log.error("brand.not.exit");
                throw new ResponseException("brand.not.exit");
            }

            Response<Boolean> authorizeResponse = brandService.checkBrandAuthorize(Long.valueOf(spu.getBrandId()),
                    goodsModel.getVendorId(), channelType.value());
            if (!authorizeResponse.isSuccess()) {
                throw new ResponseException("check.brand.authorize.by.brand.Id.has.error");
            }
            if (!authorizeResponse.getResult()) {
                log.error("can.not.use.the.brand");
                throw new ResponseException("can.not.use.the.brand");
            }

            goodsModel.setGoodsBrandId(Long.valueOf(spu.getBrandId())); // 品牌Id
            goodsModel.setGoodsBrandName(brandResponse.getResult().getBrandName());// 品牌名称

            // 品牌Id
            goodsModel.setGoodsBrandId(Long.valueOf(spu.getBrandId()));
            goodsModel.setName(HtmlEscapers.htmlEscaper().escape(goodsModel.getName()));
            if (SafeHtmlValidator.checkScriptAndEvent(goodsModel.getIntroduction())) {
                log.error("has invalid html content:template{}", goodsModel.getIntroduction());
                throw new ResponseException("invalid html");
            }

            if (!Strings.isNullOrEmpty(goodsModel.getIntroduction())) {
                checkUrlInWhiteList(goodsModel.getIntroduction());
            }

            List<ItemModel> itemList = goodsDto.getItemList();
            // 推荐商品
            if (!Strings.isNullOrEmpty(goodsDto.getRecommendGoodsCodes())) {
                List<String> strings = Splitter.on(",").omitEmptyStrings()
                        .splitToList(goodsDto.getRecommendGoodsCodes());
                for (int i = 0; i < strings.size(); i++) {
                    try {
                        Method method = goodsModel.getClass().getMethod("setRecommendGoods" + (i + 1) + "Code",
                                String.class);
                        method.invoke(goodsModel, strings.get(i));
                    } catch (Exception e) {
                        log.error("no such method error，add goods bad:{}", Throwables.getStackTraceAsString(e));
                    }
                }
            }

            // 创建类型(供应商创建)
            goodsModel.setCreateType(Contants.CREATE_TYPE_AUTO_1);
            switch (channel) {
                case Contants.ORDERTYPEID_YG:
                    checkGoodDto(goodsDto);// 校验数据
                    goodsModel.setChannelMall(GoodsModel.Status.INIT.value()); // 广发商城渠道的销售状态置为处理中
                    goodsModel.setChannelMallWx(GoodsModel.Status.INIT.value()); // 广发商城-微信
                    goodsModel.setChannelCreditWx(GoodsModel.Status.INIT.value()); // 信用卡中心-微信
                    goodsModel.setChannelApp(GoodsModel.Status.INIT.value()); // APP
                    goodsModel.setPointsType(Contants.JGID_COMMON);// 商品积分类型默认设为普通积分
                    getBestRate(goodsDto);
                    break;
                case Contants.ORDERTYPEID_JF:
                    checkPresentDto(goodsDto);
                    goodsModel.setChannelPoints(GoodsModel.Status.INIT.value());// 积分商城渠道
                    goodsModel.setChannelIvr(GoodsModel.Status.INIT.value());// IVR 渠道
                    computePrice(goodsDto.getItemList());// 计算金普价格
                    for (ItemModel itemModel : goodsDto.getItemList()) {
                        itemModel.setIsShow(goodsDto.getIsShow());// 是否隐藏
                    }
                    break;
            }
            goodsModel.setChannelCc(GoodsModel.Status.INIT.value()); // CC
            goodsModel.setChannelPhone(GoodsModel.Status.INIT.value()); // 手机商城
            goodsModel.setChannelSms(GoodsModel.Status.INIT.value()); // 短信

            goodsModel.setCreateOper(user.getId());
            goodsModel.setModifyOper(user.getId());

            goodsModel.setApproveStatus(GoodsModel.ApproveStatus.EDITING_00.value());// 编辑中

            Response<Boolean> result = goodsService.createGoods(goodsModel, itemList, vendorInfoDto.getVendorNo(),channel);
            if (result.isSuccess()) {
                return "ok";
            }
            throw new ResponseException(result.getError());
        } catch (ResponseException e) {
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
    }

    /**
     * 价格计算
     *
     * @param itemList
     */
    private void computePrice(List<ItemModel> itemList) {
        Response<List<CfgPriceSystemModel>> response = cfgPriceSystemService.findByPriceSystemId("0000");// 金普价
        if (response.isSuccess()) {
            Response<TblConfigModel> tblconfigModel = configService.findByCfgType("stock_param");
            if (tblconfigModel.isSuccess()) {
                for (ItemModel itemModel : itemList) {
                    BigDecimal cgbValue1 = new BigDecimal(tblconfigModel.getResult().getCfgValue1());
                    BigDecimal price = itemModel.getPrice();
                    BigDecimal goldCommon = price.multiply(cgbValue1.add(new BigDecimal(String.valueOf("1"))));
                    for (CfgPriceSystemModel cfgPriceSystemModel : response.getResult()) {
                        if (cfgPriceSystemModel.getUpLimit() > goldCommon.intValue()
                                && cfgPriceSystemModel.getDownLimit() <= goldCommon.intValue()) {
                            BigDecimal argumentNormal = cfgPriceSystemModel.getArgumentNormal();
                            BigDecimal result = goldCommon.divide(argumentNormal, 0, BigDecimal.ROUND_HALF_UP);
                            itemModel.setMarketPrice(result);// 金普价临时存储在市场价中
                        }
                    }
                }
            }
        }
    }

    /**
     * 外网链接白名单校验
     *
     * @param html
     */
    public void checkUrlInWhiteList(String html) {
        Response<List<String>> whiteR = auctionQuestionInfService.findLinkUrl();
        if (whiteR.isSuccess()) {
            List<String> whiteList = whiteR.getResult();
            Jerry doc = Jerry.jerry(html);
            Node[] ns = doc.$("a").get();
            for (Node n : ns) {
                String attrValue = n.getAttribute("href");
                if (!whiteList.contains(attrValue)) {
                    log.error("has.url.not.in.white.list:template{}", html);
                    throw new ResponseException(403, messageSources.get("has.url.not.in.white.list"));
                }
            }
        } else {
            log.error("failed to find white list");
            throw new ResponseException(500, messageSources.get(whiteR.getError()));
        }
    }

    /**
     * 修改商品
     *
     * @param json 数据
     * @param type 保存、提交 flag
     * @return Boolean
     */
    @RequestMapping(value = "/update/{code}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean update(@PathVariable("code") String code,
                          @RequestParam("goods") @org.antlr.v4.runtime.misc.NotNull String json, @RequestParam String type,
                          @RequestParam String channel) {
        // 获取用户信息
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        try {
            // 校验
            if (Strings.isNullOrEmpty(type)) {
                throw new ResponseException("save.type.is.null");
            }

            // 渠道不存在
            if (isNull(ChannelType.from(channel))) {
                log.error("channel is not existed,channel:{}", channel);
                throw new ResponseException("channel.not.exist");
            }
            // 查询商品信息
            Response<GoodsModel> goodsModelR = goodsService.findById(code);
            if (!goodsModelR.isSuccess()) {
                log.error("goods not found ,good code:{}", code);
                throw new ResponseException("goods.not.found");
            }

            GoodsModel existGoods = goodsModelR.getResult();

            Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(existGoods.getVendorId());
            if (!vendorInfoDtoResponse.isSuccess()) {
                log.error("vendor is not exist");
                throw new ResponseException("vendor.not.exist");
            }
            VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();

            if (equal(Contants.VENDOR_COMMON_STATUS_0101, vendorInfoDto.getVendorModel().getStatus())) {
                log.error("vendor can not used");
                throw new ResponseException(500, messageSources.get("vendor.can.not.used"));
            }

            // 解析页面输入的值
            GoodsDto goodsDto = jsonMapper.fromJson(json, GoodsDto.class);

            GoodsModel goodsModel = goodsDto.getGoods();// 如果是直接更新表中数据的状态用
            List<ItemModel> itemList = goodsDto.getItemList();

            if (!Strings.isNullOrEmpty(goodsModel.getIntroduction())) {
                checkUrlInWhiteList(goodsModel.getIntroduction());
            }
            if (Contants.ORDERTYPEID_YG.equals(channel)) {
                // 计算最佳倍率需要品牌信息
                goodsDto.getGoods().setGoodsBrandId(existGoods.getGoodsBrandId());
                checkGoodDto(goodsDto);// 校验数据
                getBestRate(goodsDto);
            } else {
                checkPresentDto(goodsDto);
                computePrice(itemList);// 计算金普价格
                for (ItemModel itemModel : itemList) {
                    itemModel.setIsShow(goodsDto.getIsShow());// 是否隐藏
                }
            }

            // 如果商品code不匹配，抛出异常
            if (!equal(goodsModel.getCode(), existGoods.getCode())) {
                log.error("goodscode not correct");
                throw new ResponseException("goods.not.found");
            }
            if (goodsModel.getName().length() > 80) {
                throw new ResponseException("goods.name.too.long");
            }
            goodsModel.setName(HtmlEscapers.htmlEscaper().escape(goodsModel.getName()));

            Response<Boolean> result;
            if (SAVE_TYPE_SAVE.equals(type)) {
                goodsModel.setApproveStatus(GoodsModel.ApproveStatus.EDITING_00.value());
                result = goodsService.updateWithoutNull(goodsModel, itemList, channel, user);
                // result = goodsService.update(goodsModel, itemList);
            } else {
                // 如果是编辑中或者初审拒绝或者是复审拒绝，则将状态置为待初审
                if (equal(existGoods.getApproveStatus(), GoodsModel.ApproveStatus.EDITING_00.value())
                        || equal(existGoods.getApproveStatus(), GoodsModel.ApproveStatus.REFUSE_FIRST_O1.value())
                        || equal(existGoods.getApproveStatus(), GoodsModel.ApproveStatus.REFUSE_SECOND_02.value())) {
                    goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_FIRST_01.value());
                    result = goodsService.updateWithoutNull(goodsModel, itemList, channel, user);
                    // result = goodsService.update(goodsModel, itemList);
                } else {
                    GoodsModel newGoods = new GoodsModel();
                    GoodFullDto goodFullDto = new GoodFullDto();

                    // 推荐商品
                    if (!Strings.isNullOrEmpty(goodsDto.getRecommendGoodsCodes())) {
                        List<String> strings = Splitter.on(",").omitEmptyStrings()
                                .splitToList(goodsDto.getRecommendGoodsCodes());
                        for (int i = 0; i < strings.size(); i++) {
                            try {
                                Method method = goodsDto.getGoods().getClass()
                                        .getMethod("setRecommendGoods" + (i + 1) + "Code", String.class);
                                method.invoke(goodsDto.getGoods(), strings.get(i));
                            } catch (Exception e) {
                                e.printStackTrace();
                                log.error("no such method error", e);// won't happen
                            }
                        }
                    }
                    // 不允许变更的数据
                    goodsDto.getGoods().setVendorId(existGoods.getVendorId());
                    goodsDto.getGoods().setOrdertypeId(existGoods.getOrdertypeId());
                    goodsDto.getGoods().setGoodsBrandId(existGoods.getGoodsBrandId());
                    goodsDto.getGoods().setGoodsBrandName(existGoods.getGoodsBrandName());
                    goodFullDto.setGoodsModel(goodsDto.getGoods());
                    goodFullDto.setItemList(itemList);
                    String diff = jsonMapper.toJson(goodFullDto);
                    // 其他情况将状态置为商品变更审核,将json串存在approve_different 字段中
                    newGoods.setApproveStatus(GoodsModel.ApproveStatus.TRILA_CHANGE_03.value());
                    newGoods.setApproveDifferent(diff);
                    newGoods.setCode(goodsDto.getGoods().getCode());
                    result = goodsService.update(newGoods, Collections.<ItemModel>emptyList());
                }
            }
            if (result.isSuccess()) {
                return Boolean.TRUE;
            }
            throw new ResponseException("goods.update.error");
        } catch (ResponseException e) {
            throw new ResponseException(500, messageSources.get(e.getMessage()));
        }
    }

    /**
     * 商品 校验
     *
     * @param goodsDto
     */
    private void checkGoodDto(GoodsDto goodsDto) {
        try {
            GoodsCheckUtil.checkGoodName(goodsDto.getGoods().getName());// 商品名称校验
            if (goodsDto.getGoods().getAutoOffShelfTime() != null) {
                GoodsCheckUtil
                        .timeAfterNow(LocalDateTime.fromDateFields(goodsDto.getGoods().getAutoOffShelfTime()).toDateTime());// 自动下架时间
            }
            GoodsModel model = goodsDto.getGoods();
            String mailOrderCode = model.getMailOrderCode();
            if (Strings.isNullOrEmpty(mailOrderCode)) {
                throw new ResponseException("mailOrderCode.is.null");
            }
            // 校验单品信息
            List<ItemModel> itemList = goodsDto.getItemList();
            for (ItemModel itemModel : itemList) {
                if (itemModel.getProductPointRate() != null) {
                    GoodsCheckUtil.checkRate(itemModel.getProductPointRate().toString());// 商品积分输入
                }
                if (!Strings.isNullOrEmpty(itemModel.getO2oCode())) {
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oCode(), "item.o2oCode.error");//
                }
                if (!Strings.isNullOrEmpty(itemModel.getO2oVoucherCode())) {
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oVoucherCode(), "item.o2oVoucherCode.error");
                }
                GoodsCheckUtil.checkPrice(itemModel.getPrice().toString());// 商品售价有误
                if (itemModel.getMarketPrice() != null) {
                    GoodsCheckUtil.checkPrice(itemModel.getMarketPrice().toString());// 市场价
                }
                GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStock()), "stock.format.error");// 库存校验
                if (null != itemModel.getFixPoint()) {
                    GoodsCheckUtil.checkNum1To9(String.valueOf(itemModel.getFixPoint()), "fixpoint.format.error");// 固定积分
                }
                if (itemModel.getStockWarning() != null) {
                    GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStockWarning()),
                            "stockWarning.format.error");// 库存预警
                }
                if (itemModel.getStock() != null && itemModel.getStockWarning() != null) {
                    if (itemModel.getStockWarning() > itemModel.getStock()) {
                        throw new IllegalArgumentException("stock.greater.than.stockPrice.error");
                    }
                }

            }
        } catch (IllegalArgumentException e) {
            throw new ResponseException(e.getMessage());
        }
    }

    /**
     * 礼品数据 check
     *
     * @param goodsDto
     */
    private void checkPresentDto(GoodsDto goodsDto) {
        try {
            GoodsCheckUtil.checkGoodName(goodsDto.getGoods().getName());// 商品名称校验
            GoodsCheckUtil
                    .timeAfterNow(LocalDateTime.fromDateFields(goodsDto.getGoods().getAutoOffShelfTime()).toDateTime());// 自动下架时间
            // 分区校验
            String areaId = goodsDto.getGoods().getRegionType();
            if (!Strings.isNullOrEmpty(areaId)) {
                Map<String, Object> params = Maps.newHashMapWithExpectedSize(1);
                params.put("areaId", areaId);
                EspAreaInfModel model = espAreaInfService.findByAreaId(params).getResult();
                if (!Objects.equals("0102", model.getCurStatus())) {
                    throw new IllegalArgumentException("goods.regionType.invalid");
                }
            } else {
                throw new IllegalArgumentException("goods.regionType.null");
            }
            // 校验单品信息
            List<ItemModel> itemList = goodsDto.getItemList();
            for (ItemModel itemModel : itemList) {

                if (itemModel.getO2oCode() != null) {
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oCode(), "item.o2oCode.error");// o2o编码
                }
                if (itemModel.getO2oVoucherCode() != null) {
                    GoodsCheckUtil.checkSpecial(itemModel.getO2oVoucherCode(), "item.O2OVoucher.error");
                }
                GoodsCheckUtil.checkPrice(itemModel.getPrice().toString());// 商品售价有误
                GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStock()), "stock.format.error");// 库存校验
                if (itemModel.getStockWarning() != null) {
                    GoodsCheckUtil.checkNum0To9(String.valueOf(itemModel.getStockWarning()),
                            "stockWarning.format.error");// 库存预警
                }
                if (itemModel.getStock() != null && itemModel.getStockWarning() != null) {
                    if (itemModel.getStockWarning() > itemModel.getStock()) {
                        throw new IllegalArgumentException("stock.greater.than.stockPrice.error");
                    }
                }
                if (itemModel.getVirtualPrice() != null) {
                    GoodsCheckUtil.checkPrice(itemModel.getVirtualPrice().toString());
                }
                if (itemModel.getBid() != null && itemModel.getBid().length() != 0
                        && Integer.valueOf(itemModel.getBid()) <= 0) {
                    throw new IllegalArgumentException("item.bid.greater.than.zero");
                }
            }
        } catch (IllegalArgumentException e) {
            throw new ResponseException(e.getMessage());
        }

    }

    /**
     * 获取最佳倍率并计算最大积分返回给itemList
     *
     * @param goodsDto
     */
    private void getBestRate(GoodsDto goodsDto) {
        List<ItemModel> itemList = goodsDto.getItemList();
        // 获取当月积分池的单位积分
        Response<PointPoolModel> pointPoolResponse = pointsPoolService.getCurMonthInfo();
        if (!pointPoolResponse.isSuccess() || pointPoolResponse.getResult() == null) {
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
            itemModel.setBestRate(bestRate);// 最佳倍率
            itemModel.setProductPointRate(goodsDto.getProductPointRateParam());// 积分支付比例
            itemModel.setMaxPoint(
                    BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());// 最大积分数量
            itemModel.setDisplayFlag(goodsDto.getDisplayFlag());// 是否仅显示全积分支付
            // itemModel.setCardLevelId(Contants.GOODS_LEVEL_CODE_0);//商品卡等级默认为00
        }
    }

    /**
     * 根据商品编码取得商品、单品信息
     *
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/getGoodInfo", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public GoodFullDto getGoodInfo(@RequestParam("goodsCode") String goodsCode) {
        Response<GoodFullDto> response = goodsService.findDetail_new("1", goodsCode);// 走商品查看
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to get goods info {},error code:{}", goodsCode, response.getError());
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
    public String editItemStock(@RequestParam("goods") @org.antlr.v4.runtime.misc.NotNull String json) {
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
     * 申请下架
     *
     * @param goodsmodel
     * @return Boolean
     */
    @RequestMapping(value = "/shelvesApply", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Response<Boolean> shelvesApply(GoodsModel goodsmodel) {
        // 获取用户信息
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }

        Response<Boolean> result = new Response<>();
        // 调用接口
        AuditLoggingModel auditLoggingModel = new AuditLoggingModel();
        auditLoggingModel.setOuterId(goodsmodel.getCode());
        auditLoggingModel.setPresenter(user.getName());
        auditLoggingModel.setAuditor(user.getName());
        auditLoggingModel.setAuditorMemo(goodsmodel.getIntroduction());
        auditLoggingModel.setBusinessType(Contants.SQXJ);
        auditLoggingModel.setCreateOper(user.getName());
        auditLoggingModel.setModifyOper(user.getName());

        Response<Integer> flag = auditLoggingService.create(auditLoggingModel);

        if (flag.isSuccess()) {
            goodsmodel.setModifyOper(user.getName());
            goodsmodel.setApproveStatus(Contants.GOODS_APPROVE_STATUS_05);
            goodsmodel.setIntroduction(null);
            result = goodsService.shelvesApply(goodsmodel);
            if (result.isSuccess()) {
                GoodsOperateDetailModel goodsOperateDetailModel = new GoodsOperateDetailModel();
                Response<GoodsModel> resultGoods = goodsService.findById(goodsmodel.getCode());
                if (!resultGoods.isSuccess()) {
                    log.error("Response.error,error code: {}", resultGoods.getError());
                    throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(resultGoods.getError()));
                }
                GoodsModel goodsModel = resultGoods.getResult();
                BeanMapper.copy(goodsModel, goodsOperateDetailModel);
                goodsOperateDetailModel.setGoodCode(goodsModel.getCode());
                goodsOperateDetailModel.setGoodName(goodsModel.getName());
                goodsOperateDetailModel.setOperateType(Contants.GOODS_OPERATE_TYPE_5);
                goodsOperateDetailModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
                goodsOperateDetailModel.setCreateOper(user.getName());
                Response<Boolean> operateResult = goodsOperateDetailService.createGoodsOperate(goodsOperateDetailModel);
                if (operateResult.isSuccess()) {
                    return result;
                }
                throw new ResponseException(500, messageSources.get(operateResult.getError()));
            }
        }
        log.error("update.error, {},error code:{}", goodsmodel, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 商品提交审核事件
     *
     * @param goodsCode
     * @return
     */
    @RequestMapping(value = "/submitGoodsToAudit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean submitGoodsToAudit(String goodsCode) {
        if (Strings.isNullOrEmpty(goodsCode)) {
            throw new ResponseException(500, messageSources.get("good.not.exist"));
        }
        GoodsModel goodsModel = new GoodsModel();
        goodsModel.setCode(goodsCode);
        goodsModel.setApproveStatus(GoodsModel.ApproveStatus.TRIAL_FIRST_01.value());// 变为待初审状态
        Response<Boolean> result = goodsService.update(goodsModel, Collections.<ItemModel>emptyList());
        if (result.isSuccess()) {
            return Boolean.TRUE;
        }
        log.error("failed to submit goods to audit {},error code:{}", goodsCode, result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
    }

    /**
     * 查询商品是否存在活动期间的单品
     *
     * @param itemCodes
     * @return
     */
    @RequestMapping(value = "/modPrice-findGoodsIsActivity", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Integer findGoodsIsActivity(@RequestParam(value = "itemCodes[]") String[] itemCodes) {
        Response<MallPromotionResultDto> mallPromotion = null;
        Integer count = 0;
        if (itemCodes.length == 0) {
            return 0;
        }
        for (String itemCode : itemCodes) {
            mallPromotion = mallPromotionService.findPromByItemCodes("1", itemCode, Contants.PROMOTION_SOURCE_ID_00);
            if (mallPromotion.isSuccess()) {
                if (mallPromotion.getResult() != null) {
                    count++;
                }
            }
        }
        return count;
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
        // 获取用户信息
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
        Response<Boolean> response = goodsService.update(goodsModel, Collections.<ItemModel>emptyList());
        if (response.isSuccess()) {
            return response.getResult();
        }
        log.error("failed to update item {},error code:{}", result.getError());
        throw new ResponseException(500, messageSources.get(result.getError()));
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
     * 推荐单品列表 取得
     *
     * @param searchKey 检索关键字
     * @return List
     */
    @RequestMapping(value = "/add-findRecommendationItemList", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<ItemDto> findRecommendationItemList(String searchKey) {
        Response<List<ItemDto>> itemDtoList = itemService.findItemListByCodeOrName(searchKey,
                Contants.BUSINESS_TYPE_YG);
        if (itemDtoList.isSuccess()) {
            return itemDtoList.getResult();
        }
        log.error("Vendor-findRecommendationItemList:failed to find recommendation itemList {},error code:{}",
                searchKey, itemDtoList.getError());
        throw new ResponseException(500, messageSources.get(itemDtoList.getError()));
    }

    /**
     * 根据id查询下级list 用于搜索条件中后台类目层级显示
     *
     * @param id
     * @return
     */
    @RequestMapping(value = "/toAddGdCat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
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
     * 查询 所有分区数据
     *
     * @return List<PresentRegionDto>
     */
    @RequestMapping(value = "/findAreaInfAll", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<PresentRegionDto> findAreaInfAll() {
        Response<List<PresentRegionDto>> result = giftPartitionService.findAll();
        if (result.isSuccess()) {
            return result.getResult();
        }
        log.error("failed to edit goods {},error code:{}");
        throw new ResponseException(500, messageSources.get(result.getError()));
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
                log.error("failed to execute exportOrderSign {},error code:{}", params.toString(),
                        goodsItems.getError());
                throw new ResponseException(500, messageSources.get(goodsItems.getError()));
            }
        } catch (Exception e) {
            log.error("fail to export exportOrderSign data, bad code{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, e.getMessage());
        }
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
        private String recommendGoodsCodes;// 推荐商品
        @Getter
        @Setter
        private Integer displayFlag;// 是否仅显示全积分支付
        @Getter
        @Setter
        private Integer isShow;// 是否隐藏
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

}
