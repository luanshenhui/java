package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.dto.GiftsImportDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import static com.spirit.util.Arguments.isNull;

/**
 * Created by 11140721050130 on 2016/12/6.
 */
public class GoodsImportAnalyzer {

    private static boolean isFirstRow(Sheet sheet, int row) {
        for (int i = 0; i < sheet.getNumMergedRegions(); ++i) {
            CellRangeAddress address = sheet.getMergedRegion(i);
            if (address.getFirstColumn() == 0 && address.getLastColumn() == 0) {
                if (address.getFirstRow() <= row && address.getLastRow() >= row) {
                    // in merge cell
                    return address.getFirstRow() == row;
                }
            }
        }
        // not merge cell, also the first row
        return true;
    }

    private static String getString(Row row, int col) {
        if(isNull(row.getCell(col))){
            return "";
        }
        row.getCell(col).setCellType(Cell.CELL_TYPE_STRING);
        return row.getCell(col).getStringCellValue();
    }

    private static Long getLong(Row row, int col) {
        String value = getString(row, col);
        if (Strings.isNullOrEmpty(value)) {
            return null;
        }
        return Long.parseLong(value);
    }

    private static Integer getInt(Row row, int col) {
        String value = getString(row, col);
        if (Strings.isNullOrEmpty(value)) {
            return null;
        }
        return Integer.parseInt(value);
    }


    private static Date getDate(Row row, int col){
        if(isNull(row.getCell(col))){
            return null;
        }
        return row.getCell(col).getDateCellValue();
    }

    public static Workbook assembleYG(InputStream is,List<GiftsImportDto> goodsDtoList)throws Exception {
        Workbook workbook = new XSSFWorkbook(is);
        try {
            for(GiftsImportDto gift : goodsDtoList){
                List<GiftsImportDto.GiftItemDto> itemModelList = gift.getItemModel();
                for(GiftsImportDto.GiftItemDto itemModel : itemModelList){
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(3).setCellValue(itemModel.getMid());
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(2).setCellValue(gift.getGoodsModel().getCode());
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(0).setCellValue(gift.getSuccessFlag());
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(1).setCellValue(itemModel.getFailReason());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return workbook;
    }


    public static Response<List<GiftsImportDto>> analyzeYG(InputStream is) throws Exception {
        Response<List<GiftsImportDto>> response = Response.newResponse();
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0);
        try {
            List<GiftsImportDto> goodsDtos = Lists.newArrayList();
            GiftsImportDto goodsDto = null;
            List<GiftsImportDto.GiftItemDto> itemModels = null;
            for (int r = 3; r <= sheet.getLastRowNum(); ++r) {
                Row row = sheet.getRow(r);
                if(isNull(row)){
                    continue;
                }
                String isEqual = getString(row, 5).trim();
                if(Strings.isNullOrEmpty(isEqual)){
                    isEqual = "1";
                }
                if (!"0".equals(isEqual)){
                    goodsDto = new GiftsImportDto();
                    goodsDto.setSuccessFlag(true);
                    goodsDtos.add(goodsDto);
                    try{
                        itemModels = Lists.newArrayList();
                        GoodsModel goodsModel = new GoodsModel();
                        goodsModel.setProductId(getLong(row, 4));// spuId
                        goodsModel.setName(getString(row, 6));// 商品名称
                        goodsModel.setIsInner(getString(row, 7));// 是否内宣
                        goodsModel.setCards(getString(row, 8));// 第三级卡产品编码
                        goodsModel.setGoodsType(getString(row, 9));// 商品类型
                        goodsModel.setMailOrderCode(getString(row, 10));//邮购分期类别码
                        goodsModel.setAutoOffShelfTime(getDate(row,11));//自动下架时间
                        goodsModel.setAdWord(getString(row, 12));// 商品卖点
                        goodsModel.setGiftDesc(getString(row, 13));// 赠品信息
                        goodsModel.setServiceType(getString(row, 14));// 服务承诺
                        String recommendGoodsCodes = getString(row, 15); // 关联商品推荐
                        if (!Strings.isNullOrEmpty(recommendGoodsCodes)) {
                            List<String> parts = Splitter.on(',').trimResults().splitToList(recommendGoodsCodes);
                            if (parts.size() == 1){
                                goodsModel.setRecommendGoods1Code(parts.get(0));
                            }
                            if (parts.size() == 2){
                                goodsModel.setRecommendGoods2Code(parts.get(1));
                            }
                            if (parts.size() == 3){
                                goodsModel.setRecommendGoods3Code(parts.get(2));
                            }
                        }
                        goodsModel.setIntroduction(getString(row, 16));// 商品描述
                        goodsDto.setGoodsModel(goodsModel);
                    }catch (Exception e){
                        goodsDto.setSuccessFlag(false);
                    }
                }
                GiftsImportDto.GiftItemDto itemModel = new GiftsImportDto.GiftItemDto();
                itemModel.setItemRow(r);
                itemModels.add(itemModel);
                goodsDto.setItemModel(itemModels);
                try {
                    itemModel.setImage1(getString(row, 17)); //图片1
                    itemModel.setImage2(getString(row, 18));  //图片2
                    itemModel.setImage3(getString(row, 19));  //图片3
                    itemModel.setImage4(getString(row, 20));  //图片4
                    itemModel.setImage5(getString(row, 21));  //图片5
                    itemModel.setAttributeKey1(getString(row, 22)); //属性名称1 例如颜色
                    itemModel.setAttributeName1(getString(row, 23));  //属性值1 例如红色
                    itemModel.setAttributeKey2(getString(row, 24));  //属性名称2 例如尺码
                    itemModel.setAttributeName2(getString(row, 25));  //属性值2 例如xxl
                    itemModel.setStock(getLong(row, 26)); //库存
                    itemModel.setStockWarning(getLong(row,27)); //库存预警值
                    itemModel.setPrice(getString(row,28)==""?null:new BigDecimal(getString(row,28))); //售价
                    itemModel.setMarketPrice(getString(row,29)==""?null:new BigDecimal(getString(row,29))); //参考价
                    itemModel.setFixPoint(getLong(row,30)); //固定积分
                    itemModel.setInstallmentNumber(getString(row,31)); //期数
                    itemModel.setStagesCode(getString(row,32)); //一期邮购分期类别码
                    itemModel.setO2oCode(getString(row, 33));  //O2O商品编码
                    itemModel.setO2oVoucherCode(getString(row, 34)); //O2O兑换券编码
                    if(goodsDto.getSuccessFlag()!=null && !goodsDto.getSuccessFlag()){
                        itemModel.setFailReason("部分数据不符合录入格式");
                    }
                }catch (Exception e){
                    goodsDto.setSuccessFlag(false);
                    itemModel.setFailReason("部分数据不符合录入格式");
                }
            }
            response.setResult(goodsDtos);
        } catch (Exception e) {
            response.setError("数据导入失败");
        }
        return response;
    }



    public static Workbook assembleJF(InputStream is,List<GiftsImportDto> goodsDtoList)throws Exception {
        Workbook workbook = new XSSFWorkbook(is);
        try {
            for(GiftsImportDto gift : goodsDtoList){
                List<GiftsImportDto.GiftItemDto> itemModelList = gift.getItemModel();
                for(GiftsImportDto.GiftItemDto itemModel : itemModelList){
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(0).setCellValue(gift.getSuccessFlag()?"成功":"失败");
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(1).setCellValue(itemModel.getFailReason());
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(2).setCellValue(gift.getGoodsModel().getCode());
                    workbook.getSheetAt(0).getRow(itemModel.getItemRow()).createCell(3).setCellValue(itemModel.getXid());


                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return workbook;
    }

    //导入所有信息，如果发生异常置successFlag 为false
    public static Response<List<GiftsImportDto>> analyzeJF(InputStream is) throws Exception {
        Response<List<GiftsImportDto>> response = Response.newResponse();
        Workbook workbook = new XSSFWorkbook(is);
        Sheet sheet = workbook.getSheetAt(0);
        try {
            List<GiftsImportDto> goodsDtos = Lists.newArrayList();
            GiftsImportDto goodsDto = null;
            List<GiftsImportDto.GiftItemDto> itemModels = null;
            for (int r = 3; r <= sheet.getLastRowNum(); ++r) {
                Row row = sheet.getRow(r);
                if(isNull(row)){
                    continue;
                }
                String isEqual = getString(row, 5).trim();
                if(Strings.isNullOrEmpty(isEqual)){
                    isEqual = "1";
                }
                if (!"0".equals(isEqual)){
                    goodsDto = new GiftsImportDto();
                    goodsDto.setSuccessFlag(true);
                    goodsDtos.add(goodsDto);
                    try{
                        itemModels = Lists.newArrayList();
                        GoodsModel goodsModel = new GoodsModel();
                        goodsDto.setGoodsModel(goodsModel);
                        goodsModel.setProductId(getLong(row, 4));// spuId
                        goodsModel.setName(getString(row, 6));// 商品名称
                        goodsModel.setIsInner(getString(row, 7));// 是否内宣
                        goodsModel.setRegionType(getString(row,8));//分区
                        goodsModel.setCards(getString(row, 9));// 第三级卡产品编码
                        goodsModel.setGoodsType(getString(row, 10));// 商品类型
                        goodsModel.setAutoOffShelfTime(getDate(row,11));//自动下架时间
                        goodsModel.setLimitCount(getInt(row, 12));//当月限购数量
                        goodsModel.setAdWord(getString(row, 13));// 商品卖点
                        goodsModel.setGiftDesc(getString(row, 14));// 赠品信息
                        goodsModel.setServiceType(getString(row, 15));// 服务承诺
                        String recommendGoodsCodes = getString(row, 16); // 关联商品推荐
                        if (!Strings.isNullOrEmpty(recommendGoodsCodes)) {
                            List<String> parts = Splitter.on(',').trimResults().splitToList(recommendGoodsCodes);
                            if (parts.size() > 0){
                                goodsModel.setRecommendGoods1Code(parts.get(0));
                            }
                            if (parts.size() > 1){
                                goodsModel.setRecommendGoods2Code(parts.get(1));
                            }
                            if (parts.size() > 2){
                                goodsModel.setRecommendGoods3Code(parts.get(2));
                            }
                        }
                        goodsModel.setIntroduction(getString(row, 17));// 商品描述
                        goodsDto.setGoodsModel(goodsModel);
                    }catch (Exception e){
                        goodsDto.setSuccessFlag(false);
                    }
                }
                GiftsImportDto.GiftItemDto itemModel = new GiftsImportDto.GiftItemDto();
                itemModel.setItemRow(r);
                itemModels.add(itemModel);
                goodsDto.setItemModel(itemModels);
                try {
                    itemModel.setImage1(getString(row, 18));
                    itemModel.setImage2(getString(row, 19));
                    itemModel.setImage3(getString(row, 20));
                    itemModel.setImage4(getString(row, 21));
                    itemModel.setImage5(getString(row, 22));
                    itemModel.setAttributeKey1(getString(row, 23));
                    itemModel.setAttributeName1(getString(row, 24));
                    itemModel.setAttributeKey2(getString(row, 25));
                    itemModel.setAttributeName2(getString(row, 26));
                    itemModel.setStock(getLong(row, 27));
                    itemModel.setStockWarning(getLong(row,28));
                    itemModel.setPrice(new BigDecimal(getString(row, 29)));
                    itemModel.setO2oCode(getString(row, 30));
                    itemModel.setO2oVoucherCode(getString(row, 31));
                    if(goodsDto.getSuccessFlag()!=null && !goodsDto.getSuccessFlag()){
                        itemModel.setFailReason("部分数据不符合录入格式");
                    }
                }catch (Exception e){
                    goodsDto.setSuccessFlag(false);
                    itemModel.setFailReason("部分数据不符合录入格式");
                }
            }
            response.setResult(goodsDtos);
        } catch (Exception e) {
            response.setError("数据导入失败");
        }
        return response;
    }

}
