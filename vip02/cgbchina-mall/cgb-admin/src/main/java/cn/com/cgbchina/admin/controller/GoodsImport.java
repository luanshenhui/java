package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.GiftsImportDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.ServicePromiseModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.item.service.ServicePromiseService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.MailStagesModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.service.MailStatesService;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.html.HtmlEscapers;
import com.google.common.io.Files;
import com.spirit.category.model.AttributeKey;
import com.spirit.category.model.AttributeValue;
import com.spirit.category.model.Spu;
import com.spirit.category.service.AttributeService;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.ServiceException;
import com.spirit.redis.JedisTemplate;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.util.KeyUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import redis.clients.jedis.Jedis;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.google.common.base.Objects.equal;
import static com.spirit.util.Arguments.isNull;

/**
 * Created by 111140821050151 on 2016/12/20.
 */

    @Controller
    @RequestMapping("/api/admin/item")
    @Slf4j
    public class GoodsImport {

    @Autowired
    private AttributeService attributeService;
    @Autowired
    private SpuService spuService;
    @Autowired
    private VendorService vendorService;
    @Autowired
    private MailStatesService mailStatesService;
    @Autowired
    private ServicePromiseService servicePromiseService;
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private BrandService brandService;
    @Autowired
    private ItemService itemService;
    @Resource
    private PointsPoolService pointsPoolService;
    @Autowired
    private  JedisTemplate jedisTemplate;
    @Resource
    private MessageSources messageSources;


    private final Pattern o2oPattern = Pattern.compile("^[^\\\"'<>%]*$");;

    private static int GOODS_IMPORT_TOTAL_LIMIT=1000;

    private final static Set<String> allowed_types = ImmutableSet.of("xlsx", "xls");

    private final static Splitter splitter = Splitter.on(',').trimResults().omitEmptyStrings();

    private final Pattern cardsPattern = Pattern.compile("^(\\d{4}\\,)*?\\d{4}$");

    private String rootFilePath;

    public GoodsImport() {
        this.rootFilePath = this.getClass().getResource("/upload").getPath();
    }


    /**
     * 商品导入
     *
     * @param file
     * @param
     */
    @RequestMapping(value = "/importGoodsData", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
    @ResponseBody
    public String importGoodsData(MultipartFile file, HttpServletResponse response) {
        User user = UserUtil.getUser();
        if (user == null) {
            throw new ResponseException(401, messageSources.get("user.not.login"));
        }
        try {
            String ext = Files.getFileExtension(file.getOriginalFilename()).toLowerCase();
            if (!allowed_types.contains(ext)) {
                throw new ResponseException(500, messageSources.get("file.illegal.ext"));
            }

            //获得文件中的数据
            Response<List<GiftsImportDto>>  result= GoodsImportAnalyzer.analyzeYG(file.getInputStream());
            if (!result.isSuccess()){
                throw new ResponseException(500 , messageSources.get(result.getError()));
            }
            List<GiftsImportDto> goodsDtoList = result.getResult();
            if(goodsDtoList.size()>GOODS_IMPORT_TOTAL_LIMIT){
                throw new ResponseException(500 , messageSources.get("items.import.list.too.long"));
            }

            //校验数据
            Response<Boolean> results = checkGoodsImport(goodsDtoList,user);
            List<GiftsImportDto> reGoodsDtoList = Lists.newArrayList();
            if (results.isSuccess()){
                for(GiftsImportDto giftsImportDto : goodsDtoList){
                    if (giftsImportDto.getSuccessFlag()){
                        GiftsImportDto giftsDto = creatGoodsImport(giftsImportDto);
                        reGoodsDtoList.add(giftsDto);
                    }else{
                        reGoodsDtoList.add(giftsImportDto);
                    }
                }
            }else {
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(results.getError()));
            }
            //下载文件处理
            Workbook workbook = GoodsImportAnalyzer.assembleYG(file.getInputStream(),reGoodsDtoList);
            String rtn = "";
            String new_filename = URLEncoder.encode("goods_import_result.xlsx", "UTF-8");
            // 如果没有UA，则默认使用IE的方式进行编码
            rtn = "filename=\"" + new_filename + "\"";
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Disposition",
                    "attachment;" + rtn + ";target=_blank");
            workbook.write(response.getOutputStream());
        }catch (ResponseException e){
            throw e;
        } catch (Exception e) {
            log.error("importGoodsData.error{}",e.getMessage());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("importGoodsData.error"));
        }
        return JsonMapper.JSON_NON_EMPTY_MAPPER.toJson("ok");
    }



    private Response<Boolean> checkGoodsImport(List<GiftsImportDto> goodsDtoList,User user){
        Response<Boolean> response = Response.newResponse();
        if (goodsDtoList == null || goodsDtoList.size() == 0){
            response.setError("pointsimport.goodsDtoList.null");
            return response;
        }
        for(GiftsImportDto goodsDto : goodsDtoList){
            GiftsImportDto.failReason failReason = new GiftsImportDto.failReason();
            failReason.setSuccessFlag(goodsDto.getSuccessFlag());//礼品插入是否成功（这里指是否通过校验）
            try{
                //礼品数据校验
                checkGoodsModel(failReason,goodsDto.getGoodsModel());
            }catch (Exception e){
                failReason.setFailReason("商品校验异常");
                log.error("pointsImport.checkGiftsImport.error{}", Throwables.getStackTraceAsString(e));
            }
            List<GiftsImportDto.GiftItemDto> itemdtos = goodsDto.getItemModel();
            for(GiftsImportDto.GiftItemDto itemDto : itemdtos){
                GiftsImportDto.failReason failReasonItem = new GiftsImportDto.failReason();//错误信息单品
                failReasonItem.setSuccessFlag(true);
                try{
                    checkItemDto(failReasonItem,itemDto, goodsDto.getGoodsModel());
                }catch (Exception e){
                    failReasonItem.setFailReason("单品校验异常");
                    log.error("pointsImport.checkGiftsImport.Item.error{}", Throwables.getStackTraceAsString(e));
                }
                if (!failReasonItem.getSuccessFlag()){
                    failReason.setSuccessFlag(failReasonItem.getSuccessFlag());
                }
                Joiner joiner = Joiner.on(",").skipNulls();
                itemDto.setFailReason(joiner.join(failReason.getFailReason(),failReasonItem.getFailReason()));
            }
            goodsDto.setSuccessFlag(failReason.getSuccessFlag());
        }
        response.setResult(true);
        return response;
    }




    private void checkGoodsModel(GiftsImportDto.failReason failReason , GoodsModel goodsModel){
        checkSpu(failReason,goodsModel.getProductId());//校验产品
        checkVendorId(failReason,goodsModel.getVendorId(),goodsModel.getProductId(),Contants.BUSINESS_TYPE_YG);//校验供应商编码
        checkName(failReason,goodsModel.getName());//校验商品名称
        checkInner(failReason,goodsModel.getIsInner()); //校验是否内宣
        checkCards(failReason,goodsModel.getCards()); //校验第三级卡产品编码
        checkGoodsType(failReason,goodsModel.getGoodsType());//校验商品类型
        checkMailOrderCode(failReason,goodsModel.getMailOrderCode(),goodsModel.getVendorId());//校验邮购分期类别码
        checkAutoOffShelfDate(failReason,goodsModel.getAutoOffShelfTime());//校验自动下架时间
        checkServiceType(failReason,goodsModel.getServiceType());
        Joiner  joiner = Joiner.on(",").skipNulls();
        String recommendGoods = joiner.join(goodsModel.getRecommendGoods1Code(),goodsModel.getRecommendGoods2Code(),goodsModel.getRecommendGoods3Code());
        checkRecommendGoods(failReason,recommendGoods); //校验关联推荐商品
        checkIntroduction(failReason,goodsModel.getIntroduction());//商品描述

    }


    private void checkItemDto(GiftsImportDto.failReason failReason , GiftsImportDto.GiftItemDto itemDto, GoodsModel goodsModel) {
        if(Strings.isNullOrEmpty(itemDto.getImage1())){
            failReason.setFailReason("请填写图片1");
        }
        if(Strings.isNullOrEmpty(itemDto.getAttributeKey1())){
            failReason.setFailReason("请填写属性");
        }
        checkAttributeKey(failReason,itemDto.getAttributeKey1(),goodsModel.getProductId());

        if(!Strings.isNullOrEmpty(itemDto.getAttributeKey2())){
            checkAttributeKey(failReason,itemDto.getAttributeKey2(),goodsModel.getProductId());//属性2不为空则校验
        }
        if(Strings.isNullOrEmpty(itemDto.getAttributeName1())){
            failReason.setFailReason("请填写属性");
        }
        checkAttributeName(failReason,itemDto.getAttributeName1(),itemDto.getAttributeKey1(),goodsModel.getProductId());

        if(!Strings.isNullOrEmpty(itemDto.getAttributeName2())){
            checkAttributeName(failReason,itemDto.getAttributeName2(),itemDto.getAttributeKey2(),goodsModel.getProductId());//属性2不为空则校验
        }
        checkStock(failReason,itemDto.getStock());
        checkPrice(failReason,itemDto.getPrice());
        checkInstallmentNumber(failReason,itemDto.getInstallmentNumber(),goodsModel.getVendorId());
        if(!Strings.isNullOrEmpty(itemDto.getStagesCode())){
            checkMailOrderCode(failReason,itemDto.getStagesCode(),goodsModel.getVendorId());
        }
        checko2oCode(failReason,itemDto.getO2oCode(),goodsModel.getGoodsType());
        checko2oVoucherCode(failReason,itemDto.getO2oVoucherCode(),goodsModel.getGoodsType());
    }


    //插入数据库(通过校验的数据)
    private GiftsImportDto creatGoodsImport(GiftsImportDto giftsImportDto){
        // 获取用户信息
        User user = UserUtil.getUser();
        try {

            GoodsModel goodsModel = giftsImportDto.getGoodsModel();
            goodsModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);//业务类型

            Long spuId = goodsModel.getProductId();
            Response<Spu> spuResult = spuService.findById(spuId); // 产品信息
            Spu spu = spuResult.getResult();
            // 品牌信息
            Response<GoodsBrandModel> brandResponse = brandService.findBrandInfoById(Long.valueOf(spu.getBrandId()));
            goodsModel.setGoodsBrandId(Long.valueOf(spu.getBrandId())); // 品牌Id
            goodsModel.setGoodsBrandName(brandResponse.getResult().getBrandName());// 品牌名称

            goodsModel.setName(HtmlEscapers.htmlEscaper().escape(goodsModel.getName()));

            goodsModel.setChannelMall(GoodsModel.Status.INIT.value()); // 广发商城渠道的销售状态置为处理中
            goodsModel.setChannelMallWx(GoodsModel.Status.INIT.value()); // 广发商城-微信
            goodsModel.setChannelCreditWx(GoodsModel.Status.INIT.value()); // 信用卡中心-微信
            goodsModel.setChannelApp(GoodsModel.Status.INIT.value()); // APP
            goodsModel.setChannelCc(GoodsModel.Status.INIT.value());//CC
            goodsModel.setChannelSms(GoodsModel.Status.INIT.value());//短信
            goodsModel.setChannelPhone(GoodsModel.Status.INIT.value());//手机银行
            goodsModel.setPointsType(Contants.JGID_COMMON);// 商品积分类型默认设为普通积分
            goodsModel.setCreateType(Contants.CREATE_TYPE_0);//管理平台创建
            goodsModel.setCreateOper(user.getId());
            goodsModel.setModifyOper(user.getId());
            goodsModel.setApproveStatus(GoodsModel.ApproveStatus.EDITING_00.value());// 编辑中

            getBestRate(giftsImportDto.getItemModel());
            getAttributeValue(giftsImportDto.getItemModel());//根据属性值获取对应的id

            Response<GiftsImportDto> response = goodsService.createGoodsImport(
                    giftsImportDto.getGoodsModel(), giftsImportDto.getItemModel(), goodsModel.getVendorId(),
                    Contants.BUSINESS_TYPE_YG);
            if(response.isSuccess()){
                GiftsImportDto respon = response.getResult();
                respon.setSuccessFlag(giftsImportDto.getSuccessFlag());
                return response.getResult();
            }else{
                giftsImportDto.setSuccessFlag(false);
                for(GiftsImportDto.GiftItemDto giftItemDto: giftsImportDto.getItemModel()){
                    giftItemDto.setFailReason("数据库插入异常"+giftItemDto.getFailReason());
                }
                return giftsImportDto;
            }
        }catch(Exception e){
            giftsImportDto.setSuccessFlag(false);
            for(GiftsImportDto.GiftItemDto giftItemDto: giftsImportDto.getItemModel()){
                giftItemDto.setFailReason("数据库插入异常"+giftItemDto.getFailReason());
            }
            return giftsImportDto;
        }
    }



    /**
     * 获取属性值对应的id
     * 例如，红色对应的id
     */
    public String getAttributeValueKey(final String attributeName){
        if(Strings.isNullOrEmpty(attributeName)){
            return "";
        }
        String id = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            public String action(Jedis jedis) {
                return jedis.get(KeyUtil.attributeValue(attributeName));
            }
        });
        return id;
    }

    /**
     * 获取属性名对应的id
     * 例如，颜色对应的id
     */
    public String getAttributeKeyId(final String attributeKey){
        if(Strings.isNullOrEmpty(attributeKey)){
            return "";
        }
        String id = jedisTemplate.execute(new JedisTemplate.JedisAction<String>() {
            public String action(Jedis jedis) {
                return jedis.get(KeyUtil.attributeKey(attributeKey));
            }
        });
        return id;
    }


    /**
     * 获取最佳倍率并计算最大积分返回给itemList
     */
    public void getBestRate(List<GiftsImportDto.GiftItemDto> itemList){
        //获取当月积分池的单位积分
        Response<PointPoolModel> pointPoolResponse = pointsPoolService.getCurMonthInfo();
        if(!pointPoolResponse.isSuccess() || pointPoolResponse.getResult()==null){
            throw new ResponseException(500, "积分查找失败");
        }
        Long singlePoint = pointPoolResponse.getResult().getSinglePoint();
        // 获取最佳倍率
        BigDecimal bestRate = pointPoolResponse.getResult().getPointRate();
        for(ItemModel itemModel : itemList){
            itemModel.setBestRate(bestRate);//最佳倍率
            itemModel.setMaxPoint(BigDecimal.valueOf(singlePoint).multiply(itemModel.getPrice()).multiply(bestRate).longValue());//最大积分数量
        }
    }

    /**
     * 获取属性值对应的id 返回给itemlist
     * @param itemList
     *
     */
    public void getAttributeValue(List<GiftsImportDto.GiftItemDto>itemList){
        for(ItemModel item:itemList){
            item.setAttributeValue1(getAttributeValueKey(item.getAttributeName1()));
            item.setAttributeValue2(getAttributeValueKey(item.getAttributeName2()));
        }
    }


    /**
     * 校验spuId
     * 非空、长度20、是否存在
     */
    public void checkSpu(GiftsImportDto.failReason failReason,Long spuId){
        if(isNull(spuId)){
            failReason.setFailReason("请填写产品id");
        }
        Response<Spu> spuR = spuService.findById(spuId);
        if(!spuR.isSuccess() || spuR.getResult()==null){
            failReason.setFailReason("产品id错误");
        }
    }

    /**
     * 校验商品名称
     * 特殊字符
     */
    public void checkName(GiftsImportDto.failReason failReason ,String name){
        if(Strings.isNullOrEmpty(name)){
            failReason.setFailReason("请输入商品名称");
        }

        Pattern pattern = Pattern.compile("^[^\\\"'<>%]*$");
        Matcher matcher = pattern.matcher(name);
        if (!matcher.matches()) {
            failReason.setFailReason("商品名称不允许输入特殊字符");
        }
    }

    /**
     * 校验供应商编码
     * 存在、品牌授权
     */
    public void checkVendorId(GiftsImportDto.failReason failReason,String vendorId,Long spuId,String ordertypeId){
        if(Strings.isNullOrEmpty(vendorId)){
            failReason.setFailReason("请填写供应商编码");
        }

        Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(vendorId);
        if (!vendorInfoDtoResponse.isSuccess()) {
            failReason.setFailReason("供应商编码填写错误");
        }
        VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();
        if (vendorInfoDto.getVendorModel() == null || equal(Contants.VENDOR_COMMON_STATUS_0101, vendorInfoDto.getVendorModel().getStatus())) {
            failReason.setFailReason("供应商编码填写错误");
        }

        Response<Spu> spuResult = spuService.findById(spuId);
        Spu spu = spuResult.getResult();

        Response<Boolean> authorizeResponse = brandService.checkBrandAuthorize(Long.valueOf(spu.getBrandId()),vendorId,
                ordertypeId);
        if (!authorizeResponse.isSuccess() || !authorizeResponse.getResult()) {
            failReason.setFailReason("该供应商不可使用该品牌发布商品");
        }
    }


    /**
     * 校验是否内宣商品
     * 非空，只存在0、1两个值
     */
    public void checkInner(GiftsImportDto.failReason failReason,String isInner){
        if(Strings.isNullOrEmpty(isInner)){
            failReason.setFailReason("请选择是否为内宣商品");
        }
    }

    /**
     * 校验商品描述
     */
    public void checkIntroduction(GiftsImportDto.failReason failReason,String introduction){
        if(!Strings.isNullOrEmpty(introduction)){
            if (SafeHtmlValidator.checkScriptAndEvent(introduction)) {
                failReason.setFailReason("商品描述填写错误");
            }
        }
    }

    /**
     * 校验第三级卡产品编码
     * 非空，规则
     */
    public void checkCards(GiftsImportDto.failReason failReason,String cards) {
        if(Strings.isNullOrEmpty(cards)){
            failReason.setFailReason("请填写第三级卡产品编码");
        }
        Matcher cardMatcher = cardsPattern.matcher(cards);
        if(!cards.equals("WWWW")&&!cardMatcher.matches()){
            failReason.setFailReason("第三级卡产品编码填写错误");
        }
    }

    /**
     * 校验商品类型
     * 非空，长度，只有三个值00/01/02
     */
    public void checkGoodsType(GiftsImportDto.failReason failReason,String goodsType){
        if(Strings.isNullOrEmpty(goodsType)){
            failReason.setFailReason("请选择商品类型");
        }
    }

    /**
     * 校验邮购分期类别码
     * 非空，长度，是否供应商下
     */
    public void checkMailOrderCode(GiftsImportDto.failReason failReason,String mailOrderCode,String vendorId){
        if(Strings.isNullOrEmpty(mailOrderCode)){
            failReason.setFailReason("邮购分期类别码或一期邮购分期类别码填写错误");
            throw new ServiceException("");
        }
        Response<List<MailStagesModel>> mailStageR = mailStatesService.findMailStagesListByVendorId(vendorId);
        if(!mailStageR.isSuccess() || mailStageR.getResult()==null || mailStageR.getResult().isEmpty()){
            failReason.setFailReason("邮购分期类别码或一期邮购分期类别码填写错误");
        }
        List<String> mailCodes = Lists.transform(mailStageR.getResult(), new Function<MailStagesModel, String>() {
            @Nullable
            @Override
            public String apply(@Nullable MailStagesModel input) {
                return input.getCode();
            }
        });
        if(!mailCodes.contains(mailOrderCode)){
            failReason.setFailReason("邮购分期类别码或一期邮购分期类别码填写错误");
        }
    }


    /**
     * 校验自动下架时间
     * @param failReason
     * @param autoOffShelfTime
     */
    public void checkAutoOffShelfDate(GiftsImportDto.failReason failReason,Date autoOffShelfTime){
        if(isNull(autoOffShelfTime)){
            failReason.setFailReason("请填写自动下架时间");
        }
    }

    /**
     * 校验服务承诺
     * 是否存在
     */
    public void  checkServiceType(GiftsImportDto.failReason failReason,String serviceType){
        if(!Strings.isNullOrEmpty(serviceType)){
            List<String> serviceList = splitter.splitToList(serviceType);
            Response<List<ServicePromiseModel>> spRe = servicePromiseService.findAllebled();
            if(!spRe.isSuccess()||spRe.getResult()==null||spRe.getResult().isEmpty()){
                failReason.setFailReason("服务承诺填写错误");
            }
            List<String> serviceNames = Lists.transform(spRe.getResult(), new Function<ServicePromiseModel, String>() {
                @Nullable
                @Override
                public String apply(@Nullable ServicePromiseModel input) {
                    return input.getCode().toString();
                }
            });
            for(String service:serviceList){
                if(!serviceNames.contains(service)){
                    failReason.setFailReason("服务承诺填写错误");
                }
            }
        }
    }

    /**
     * 校验关联推荐商品id
     * 是否存在
     */
    public void checkRecommendGoods(GiftsImportDto.failReason failReason,String recommendGoods){
        if(!Strings.isNullOrEmpty(recommendGoods)){
            List<String> recommendList = splitter.splitToList(recommendGoods);
            Response<List<ItemModel>> itemListR = itemService.findByCodesNoOrder(recommendList);
            if(!itemListR.isSuccess()){
                failReason.setFailReason("关联推荐商品id填写错误");
            }
            if(recommendList.size()!=itemListR.getResult().size()){
                failReason.setFailReason("关联推荐商品id填写错误");
            }
        }
    }

    /**
     * 校验属性名是不是该产品id下
     */
    public void checkAttributeKey(GiftsImportDto.failReason failReason, String attributeKey,Long spuId){
        //根据spuId 查找其有哪些销售属性
        List<AttributeKey> attributeKeyList = attributeService.findSkuKeysNoCacheBy(spuId);
        if(attributeKeyList==null || attributeKeyList.isEmpty()){
            failReason.setFailReason("属性名不存在");
            return;
        }
        //属性名称list
        List<String> attributeKeys = Lists.transform(attributeKeyList, new Function<AttributeKey, String>() {
            @Nullable
            @Override
            public String apply(@Nullable AttributeKey input) {
                return input.getName();
            }
        });
        if(!attributeKeys.contains(attributeKey)){
            failReason.setFailReason("属性名不存在");
        }
    }

    /**
     * 校验属性值在不在属性名下
     */
    public void checkAttributeName(GiftsImportDto.failReason failReason , String attributeName,String attributeKey,Long spuId){
        if(Strings.isNullOrEmpty(attributeName) || Strings.isNullOrEmpty(attributeKey)){
            failReason.setFailReason("属性值或属性名填写错误");
        }
        Response<Spu> spuR = spuService.findById(spuId);
        Long categoryId = spuR.getResult().getCategoryId();
        String attributeKeyId = getAttributeKeyId(attributeKey);
        if(Strings.isNullOrEmpty(attributeKeyId)){
            failReason.setFailReason("属性值或属性名填写错误");
            return;
        }
        List<AttributeValue> attributeValueList = attributeService.findCategoryAttributeValuesNoCacheBy(categoryId, Long.parseLong(attributeKeyId));
        List<String> attributeValues = Lists.transform(attributeValueList, new Function<AttributeValue, String>() {
            @Nullable
            @Override
            public String apply(@Nullable AttributeValue input) {
                return input.getValue();
            }
        });

        if(!attributeValues.contains(attributeName)){
            failReason.setFailReason("属性值不存在");
        }
    }

    /**
     * 校验库存
     * 非空，长度，规则
     */
    public void checkStock(GiftsImportDto.failReason failReason , Long stock){
        if(isNull(stock)){
            failReason.setFailReason("请填写库存值");
        }
    }



    /**
     * 校验售价
     * 非空、长度、规则
     */
    public void checkPrice(GiftsImportDto.failReason failReason , BigDecimal price){
        if(isNull(price)){
            failReason.setFailReason("请填写价格");
        }
    }


    /**
     * 校验期数
     * 非空，规则
     */
    public void checkInstallmentNumber(GiftsImportDto.failReason failReason , String installmentNumber,String vendorId){
        if(Strings.isNullOrEmpty(installmentNumber)){
            failReason.setFailReason("请填写分期数");
        }
        Response<List<TblVendorRatioModel>> periodR = vendorService.findRaditListByVendorId(vendorId);
        if(!periodR.isSuccess() || periodR.getResult()==null ||  periodR.getResult().isEmpty()){
            failReason.setFailReason("分期数填写错误");
        }
        List<String> installmentNumbers = Lists.transform(periodR.getResult(), new Function<TblVendorRatioModel, String>() {
            @Nullable
            @Override
            public String apply(@Nullable TblVendorRatioModel input) {
                return input.getPeriod().toString();
            }
        });
        List<String> numberList = splitter.splitToList(installmentNumber);
        for(String number:numberList){
            if(!installmentNumbers.contains(number)){
                failReason.setFailReason("分期数填写错误");
            }
        }
    }

    /**
     * 校验o2o商品编码
     * 如果是o2o商品则非空，长度，规则
     */
    public void checko2oCode(GiftsImportDto.failReason failReason , String o2oCode,String goodsType){
        if("02".equals(goodsType)){
            if(Strings.isNullOrEmpty(o2oCode)){
                failReason.setFailReason("请填写O2O商品编码");
            }

            Matcher matcher = o2oPattern.matcher(o2oCode);
            if (!matcher.matches()) {
                failReason.setFailReason("O2O商品编码填写错误");
            }
        }
        if("01".equals(goodsType)&&!Strings.isNullOrEmpty(o2oCode)){
            failReason.setFailReason("O2O商品编码填写错误");
        }
    }

    /**
     * 校验O2O兑换券编码
     * 如果是o2o商品则非空，长度，规则
     */
    public void checko2oVoucherCode(GiftsImportDto.failReason failReason , String o2oVoucherCode,String goodsType){
        if("02".equals(goodsType)){
            if(Strings.isNullOrEmpty(o2oVoucherCode)){
                failReason.setFailReason("请填写O2O兑换券编码");
            }
            Matcher matcher = o2oPattern.matcher(o2oVoucherCode);
            if (!matcher.matches()) {
                failReason.setFailReason("O2O兑换券编码填写错误");
            }
        }
        if("01".equals(goodsType)&&!Strings.isNullOrEmpty(o2oVoucherCode)){
            failReason.setFailReason("O2O兑换券编码填写错误");
        }
    }


}
