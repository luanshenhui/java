package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.enums.ChannelType;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.GiftsImportDto;
import cn.com.cgbchina.item.dto.PresentRegionDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.GiftPartitionService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.model.TblConfigModel;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.related.service.ConfigService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.SafeHtmlValidator;
import com.google.common.base.*;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.html.HtmlEscapers;
import com.google.common.io.ByteStreams;
import com.google.common.io.Files;
import com.spirit.category.model.Spu;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.ServiceException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.google.common.base.Objects.equal;
import static com.spirit.util.Arguments.isNull;

/**
 * Created by zhangLin on 2016/12/21.
 */
@Controller
@RequestMapping("/api/vendor/goods")
@Slf4j
public class PointsImport {
    @Resource
    private GoodsService goodsService;
    @Resource
    private MessageSources messageSources;
    @Autowired
    private CfgPriceSystemService cfgPriceSystemService;
    @Autowired
    private ConfigService configService;
    @Autowired
    private GoodsImport goodsImport;
    @Resource
    private GiftPartitionService giftPartitionService;
    @Autowired
    private SpuService spuService;
    @Autowired
    private BrandService brandService;

    private final static Set<String> allowed_types = ImmutableSet.of("xlsx", "xls");
    private static int GOODS_IMPORT_TOTAL_LIMIT=1000;

    private String rootFilePath;
    public PointsImport() {
        this.rootFilePath = this.getClass().getResource("/upload").getPath();
    }



    /**
     * 商品导入
     *
     * @param file
     */
    @RequestMapping(value = "/importGiftsData", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
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
            Response<List<GiftsImportDto>>  result= GoodsImportAnalyzer.analyzeJF(file.getInputStream());
            if (!result.isSuccess()){
                throw new ResponseException(500 , messageSources.get(result.getError()));
            }
            List<GiftsImportDto> goodsDtoList = result.getResult();
            if(goodsDtoList.size()>GOODS_IMPORT_TOTAL_LIMIT){
                throw new ResponseException(500 , messageSources.get("items.import.list.too.long"));
            }

            //校验数据
            Response<Boolean> results = checkGiftsImport(goodsDtoList,user);
            List<GiftsImportDto> reGoodsDtoList = Lists.newArrayList();
            if (results.isSuccess()){
                for(GiftsImportDto giftsImportDto : goodsDtoList){
                    if (giftsImportDto.getSuccessFlag()){
                        GiftsImportDto giftsDto = creatGiftsImport(giftsImportDto);
                        reGoodsDtoList.add(giftsDto);
                    }else{
                        reGoodsDtoList.add(giftsImportDto);
                    }
                }
            }else {
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(results.getError()));
            }
            //下载文件处理
            Workbook workbook = GoodsImportAnalyzer.assembleJF(file.getInputStream(),reGoodsDtoList);
            String rtn = "";
            String new_filename = URLEncoder.encode(file.getOriginalFilename(), "UTF-8");
            // 如果没有UA，则默认使用IE的方式进行编码
            rtn = "filename=\"" + new_filename + "\"";
            response.setContentType("application/octet-stream");
            response.addHeader("Content-Disposition",
                    "attachment;" + rtn + ";target=_blank");
            workbook.write(response.getOutputStream());
        } catch (ResponseException e){
            throw e;
        } catch (Exception e) {
            log.error("importGiftData.error{}",e.getMessage());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("importGiftData.error"));
        }
        return JsonMapper.JSON_NON_EMPTY_MAPPER.toJson("ok");
    }

    private Response<Boolean> checkGiftsImport(List<GiftsImportDto> goodsDtoList,User user){
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
                checkGiftModel(failReason,goodsDto.getGoodsModel(),user);
            }catch (Exception e){
                failReason.setFailReason("礼品校验异常");
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
    private void checkGiftModel(GiftsImportDto.failReason failReason , GoodsModel goodsModel,User user){
        checkRegionType(failReason,goodsModel);//分区,第三级卡产品编码
//        goodsModel.getAutoOffShelfTime();// 自动下架时间
        if(goodsModel.getLimitCount()==null){//当月限购数量
            failReason.setFailReason("当月限购数量不能为空");
        }
        if(goodsModel.getLimitCount()!=null && goodsModel.getLimitCount()<0){//当月限购数量
            failReason.setFailReason("当月限购数量不符合要求");
        }
        checkStringLength(failReason,goodsModel.getAdWord());// 商品卖点
        checkStringLength(failReason,goodsModel.getGiftDesc());// 赠品信息
        goodsModel.getIntroduction();// 商品描述
        goodsImport.checkSpu(failReason,goodsModel.getProductId());//校验产品
        goodsImport.checkName(failReason,goodsModel.getName());//校验商品名称
        goodsImport.checkInner(failReason,goodsModel.getIsInner()); //校验是否内宣
        goodsImport.checkGoodsType(failReason,goodsModel.getGoodsType());//校验商品类型
        goodsImport.checkServiceType(failReason,goodsModel.getServiceType());// 服务承诺
        goodsImport.checkAutoOffShelfDate(failReason,goodsModel.getAutoOffShelfTime());//校验自动下架时间
        goodsImport.checkVendorId(failReason,user.getVendorId(),goodsModel.getProductId(),Contants.BUSINESS_TYPE_JF);//校验供应商编码
        Joiner joiner = Joiner.on(",").skipNulls();
        String recommendGoods = joiner.join(goodsModel.getRecommendGoods1Code(),goodsModel.getRecommendGoods2Code(),goodsModel.getRecommendGoods3Code());
        goodsImport.checkRecommendGoods(failReason,recommendGoods); //校验关联推荐商品

    }

    private void checkItemDto(GiftsImportDto.failReason failReason , GiftsImportDto.GiftItemDto itemDto, GoodsModel goodsModel) {
        checkImage(failReason,itemDto.getImage1(), itemDto.getImage2(), itemDto.getImage3(), itemDto.getImage4(), itemDto.getImage5());
//        itemDto.getStockWarning();
        if(Strings.isNullOrEmpty(itemDto.getAttributeKey1())){
            failReason.setFailReason("请填写属性");
        }
        goodsImport.checkAttributeKey(failReason,itemDto.getAttributeKey1(),goodsModel.getProductId());

        if(!Strings.isNullOrEmpty(itemDto.getAttributeKey2())){
            goodsImport.checkAttributeKey(failReason,itemDto.getAttributeKey2(),goodsModel.getProductId());//属性2不为空则校验
        }
        if(Strings.isNullOrEmpty(itemDto.getAttributeName1())){
            failReason.setFailReason("请填写属性");
        }

        goodsImport.checkAttributeName(failReason,itemDto.getAttributeName1(),itemDto.getAttributeKey1(),goodsModel.getProductId());

        if(!Strings.isNullOrEmpty(itemDto.getAttributeKey2())){
            goodsImport.checkAttributeName(failReason,itemDto.getAttributeName2(),itemDto.getAttributeKey2(),goodsModel.getProductId());//属性2不为空则校验
        }
        goodsImport.checkStock(failReason,itemDto.getStock());
        goodsImport.checkPrice(failReason,itemDto.getPrice());
        goodsImport.checko2oCode(failReason,itemDto.getO2oCode(),goodsModel.getGoodsType());
        goodsImport.checko2oVoucherCode(failReason,itemDto.getO2oVoucherCode(),goodsModel.getGoodsType());
    }

    private void checkRegionType(GiftsImportDto.failReason failReason , GoodsModel goodsModel){
        Response<List<PresentRegionDto>> result = giftPartitionService.findAll();
        if (result.isSuccess()){
            Map<String,PresentRegionDto> regionDtoMap = Maps.uniqueIndex(result.getResult(), new Function<PresentRegionDto, String>() {
                @Nullable
                @Override
                public String apply(@Nullable PresentRegionDto input) {
                    return input.getAreaId();
                }
            });
            if(Strings.isNullOrEmpty(goodsModel.getRegionType())){
                failReason.setFailReason("礼品分区不能为空");
            }
            PresentRegionDto presentRegionDto = regionDtoMap.get(goodsModel.getRegionType().trim());
            if (presentRegionDto == null){
                failReason.setFailReason("礼品分区输入错误");
            }
            goodsModel.setPointsType(presentRegionDto.getIntegraltypeId());
            if(Strings.isNullOrEmpty(goodsModel.getCards())){
                goodsModel.setCards(presentRegionDto.getLimitCards());
            }else{
                goodsImport.checkCards(failReason,goodsModel.getCards());
            }
        }else{
            failReason.setFailReason("分区信息获取失败");
        }
    }


    //插入数据库(通过校验的数据)
    private GiftsImportDto creatGiftsImport(GiftsImportDto giftsImportDto){
        // 获取用户信息
        User user = UserUtil.getUser();
        try {
            GoodsModel goodsModel = giftsImportDto.getGoodsModel();
            goodsModel.setVendorId(user.getVendorId());//供应商编码
            goodsModel.setOrdertypeId(Contants.BUSINESS_TYPE_JF);//业务类型
            // 产品信息
            Long spuId = goodsModel.getProductId();
            Response<Spu> spuResult = spuService.findById(spuId);

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
                    goodsModel.getVendorId(), Contants.BUSINESS_TYPE_JF);
            if (!authorizeResponse.isSuccess()) {
                throw new ResponseException("check.brand.authorize.by.brand.Id.has.error");
            }
            goodsImport.getAttributeValue(giftsImportDto.getItemModel());
            //默认卡等级无限制 “00”
            goodsModel.setCardLevelId("00");
            goodsModel.setGoodsBrandId(Long.valueOf(spu.getBrandId())); // 品牌Id
            goodsModel.setGoodsBrandName(brandResponse.getResult().getBrandName());// 品牌名称
            goodsModel.setCreateType(Contants.CREATE_TYPE_AUTO_1);//供应商创建
            // 创建类型(供应商创建)
            goodsModel.setCreateType(Contants.CREATE_TYPE_AUTO_1);
            goodsModel.setChannelPoints(GoodsModel.Status.INIT.value());// 积分商城渠道
            goodsModel.setChannelIvr(GoodsModel.Status.INIT.value());// IVR 渠道
            computePrice(giftsImportDto.getItemModel());// 计算金普价格
            goodsModel.setChannelCc(GoodsModel.Status.INIT.value()); // CC
            goodsModel.setChannelPhone(GoodsModel.Status.INIT.value()); // 手机商城
            goodsModel.setChannelSms(GoodsModel.Status.INIT.value()); // 短信
            goodsModel.setCreateOper(user.getId());
            goodsModel.setModifyOper(user.getId());
            // 自动下架时间
            goodsModel.setAutoOffShelfTime(goodsModel.getAutoOffShelfTime());
            // 审核状态
            goodsModel.setApproveStatus(GoodsModel.ApproveStatus.EDITING_00.value());// 编辑中
            Response<GiftsImportDto> response = goodsService.createGoodsImport(
                    giftsImportDto.getGoodsModel(), giftsImportDto.getItemModel(), user.getVendorId(),
                    Contants.BUSINESS_TYPE_JF);
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
     * 价格计算
     *
     * @param itemList
     */
    private void computePrice(List<GiftsImportDto.GiftItemDto> itemList) {
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
     * 校验字符串长度
     */
    private void checkStringLength (GiftsImportDto.failReason failReason,String input){
        if (input!= null){
            Integer inputLength = input.length();
            if (inputLength > 100){
                failReason.setFailReason("描述长度超过限制");
            }
        }
    }

    /**
     * 校验图片
     */
    private void checkImage(GiftsImportDto.failReason failReason, String image1, String image2, String image3, String image4, String image5){
        //保留校验
        if (Strings.isNullOrEmpty(image1)){
            failReason.setFailReason("至少有一张图片");
        }
    }
}
