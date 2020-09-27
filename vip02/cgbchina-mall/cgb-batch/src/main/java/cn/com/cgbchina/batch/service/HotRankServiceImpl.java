package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.HotRankDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.HotRankManager;
import cn.com.cgbchina.batch.model.CommendRankBatchModel;
import cn.com.cgbchina.batch.model.HotRankModel;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * Created by tongxueying on 2016/8/23.
 */
@Service
@Slf4j
public class HotRankServiceImpl implements HotRankService {
    @Autowired
    private HotRankManager hotRankManager;
    @Resource
    private HotRankDao hotRankDao;
    @Autowired
    private SpuService spuService;
    @Autowired
    private BackCategoryHierarchy bch;
    private static final String HOTSALERANKCODE = "0001";//热销商品统计
    private static final String HOTCOLLECTIONRANKCODE = "0002";//热门收藏排行
    private static final String VENDORHOTSALERANKCODE = "0007";//供应商热销商品统计
    private static final String VENDORHOTCOLLECTIONRANKCODE = "0006";//供应商热门收藏统计
    /**
     * 热门销售统计排行
     *
     * @return
     */
    @Override
    public Response<Boolean> hotSaleRank() {
        Response<Boolean> response = Response.newResponse();
        try {
            priHotSaleRank();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 热门收藏排行
     *
     * @return
     */
    @Override
    public Response<Boolean> hotCollectionRank() {
        Response<Boolean> response = Response.newResponse();
        try {
            priHotCollectionRank();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 供应商热销统计排行
     *
     * @return
     */
    @Override
    public Response<Boolean> hotSaleRankForVendor() {
        Response<Boolean> response = Response.newResponse();
        try {
            priHotSaleRankForVendor();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (Exception e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 供应商热门收藏排行
     * @return
     */
    @Override
    public Response<Boolean> hotCollectionRankForVendor() {
        Response<Boolean> response = Response.newResponse();
        try {
            priHotCollectionRankForVendor();
            response.setResult(Boolean.TRUE);
            return response;
        }catch (Exception e){
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 热销品类统计
     * @return 执行结果
     *
     * geshuo 20160902
     */
    @Override
    public Response<Boolean> countHotCategory(){
        Response<Boolean> response = Response.newResponse();
        try {
            priCountHotCategory();
            response.setResult(Boolean.TRUE);
        } catch (Exception e){
            log.error("HotRankServiceImpl.countHotCategory.error Exception:{}",Throwables.getStackTraceAsString(e));
            response.setResult(Boolean.FALSE);
            response.setError(Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    /**
     * 通用统计（供应商销量统计）
     * @return 执行结果
     *
     * geshuo 20160902
     */
    @Override
    public Response<Boolean> countHotVendor(){
        Response<Boolean> response = Response.newResponse();
        try {
            //执行统计
            priCountHotVendor();
            response.setResult(Boolean.TRUE);
        } catch (Exception e){
            log.error("HotRankServiceImpl.countHotVendor.error Exception:{}",Throwables.getStackTraceAsString(e));
            response.setResult(Boolean.FALSE);
            response.setError(Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    /**
     * 通用统计（供应商一周数据统计）
     * @return 执行结果
     *
     * geshuo 20160902
     */
    @Override
    public Response<Boolean> countVendorWeekSale(){
        Response<Boolean> response = Response.newResponse();
        try {
            //执行统计
            priCountVendorWeekSale();
            response.setResult(Boolean.TRUE);
        } catch (Exception e){
            log.error("HotRankServiceImpl.countVendorWeekSale.error Exception:{}",Throwables.getStackTraceAsString(e));
            response.setResult(Boolean.FALSE);
            response.setError(Throwables.getStackTraceAsString(e));
        }
        return response;
    }

    /**
     * 熱銷商品（礼品）统计排行
     *
     * @throws BatchException
     */
    private void priHotSaleRank() throws BatchException {
        try {
            String currentDate = DateTime.now().toString(DateHelper.YYYYMMDD);
            String lastDate = DateTime.now().minusDays(30).toString(DateHelper.YYYYMMDD);
            Map<String, Object> paramYg = Maps.newHashMap();
            paramYg.put("currentDate", currentDate);
            paramYg.put("lastDate", lastDate);
            paramYg.put("orderTypeIdYg", Contants.BUSINESS_TYPE_YG);//广发商城
            paramYg.put("statType", HOTSALERANKCODE);
            List<HotRankModel> hotRankListYg = hotRankDao.findItemList(paramYg);//广发商城的单品销量查询
            int i = 0;
            if (hotRankListYg != null && hotRankListYg.size() != 0) {
                hotRankManager.updateRank(paramYg);// 删除之前排行的数据
                for (HotRankModel hotRankModel : hotRankListYg) {
                    if (i > 9) {
                        break;
                    }
                    Map<String, Object> createYgParam = Maps.newHashMap();
                    createYgParam.put("statType", HOTSALERANKCODE);
                    createYgParam.put("orderTypeId", Contants.BUSINESS_TYPE_YG);
                    createYgParam.put("itemCode", hotRankModel.getItemCode());//单品编码
                    createYgParam.put("goodsName", hotRankModel.getGoodsNm());//商品名称
                    createYgParam.put("price", hotRankModel.getPrice());//价格
                    createYgParam.put("installmentNumber", hotRankModel.getInstallmentNumber());//最高期数
                    createYgParam.put("image1", hotRankModel.getImage1());//商品第一个图片
                    createYgParam.put("rank", i + 1);//排行
                    createYgParam.put("statNum01", hotRankModel.getNum());//统计数量
                    createYgParam.put("rankDate", new Date());
                    createYgParam.put("rankTime", new Date());
                    hotRankManager.createRank(createYgParam);
                    i++;
                }
            }
            Map<String, Object> paramJf = Maps.newHashMap();
            paramJf.put("currentDate", currentDate);
            paramJf.put("lastDate", lastDate);
            paramJf.put("orderTypeIdJf", Contants.BUSINESS_TYPE_JF);//积分商城
            paramJf.put("statType", HOTSALERANKCODE);
            List<HotRankModel> hotRankListJf = hotRankDao.findItemList(paramJf);//积分商城的单品销量查询
            i = 0;
            if (hotRankListJf != null && hotRankListJf.size() != 0) {
                hotRankManager.updateRank(paramJf);// 删除之前排行的数据
                for (HotRankModel hotRankJf : hotRankListJf) {
                    if (i > 9) {
                        break;
                    }
                    Map<String, Object> createJfParam = Maps.newHashMap();
                    createJfParam.put("statType", HOTSALERANKCODE);
                    createJfParam.put("orderTypeId", Contants.BUSINESS_TYPE_JF);
                    createJfParam.put("itemCode", hotRankJf.getItemCode());//单品编码
                    createJfParam.put("goodsName", hotRankJf.getGoodsNm());//商品名称
                    createJfParam.put("price", hotRankJf.getPrice());//价格
                    createJfParam.put("image1", hotRankJf.getImage1());//商品第一个图片
                    createJfParam.put("rank", i + 1);//排行
                    createJfParam.put("statNum01", hotRankJf.getNum());//统计数量
                    createJfParam.put("rankDate",  new Date());
                    createJfParam.put("rankTime", new Date());
                    hotRankManager.createRank(createJfParam);
                    i++;
                }
            }
        } catch (Exception e) {
            log.error("hotSaleRank Excpetion {}.", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 热门收藏排行
     *
     * @throws BatchException
     */
    private void priHotCollectionRank() throws BatchException {
        try {
            String currentDate = DateTime.now().toString(DateHelper.YYYYMMDD);
            String lastDate = DateTime.now().minusDays(30).toString(DateHelper.YYYYMMDD);
            Map<String, Object> paramYg = Maps.newHashMap();
            paramYg.put("currentDate", currentDate);
            paramYg.put("lastDate", lastDate);
            paramYg.put("orderTypeIdYg", Contants.BUSINESS_TYPE_YG);//广发商城
            paramYg.put("statType", HOTCOLLECTIONRANKCODE);
            List<HotRankModel> itemList = hotRankDao.findItemListForCollection(paramYg);
            int i = 0;
            if (itemList != null && itemList.size() != 0) {
                hotRankManager.updateRank(paramYg);// 删除之前排行的数据
                for (HotRankModel hotRankModel : itemList) {
                    if (i > 9) {
                        break;
                    }
                    Map<String, Object> createParamYg = Maps.newHashMap();
                    createParamYg.put("statType", HOTCOLLECTIONRANKCODE);
                    createParamYg.put("orderTypeId", Contants.BUSINESS_TYPE_YG);
                    createParamYg.put("itemCode", hotRankModel.getItemCode());//单品编码
                    createParamYg.put("goodsName", hotRankModel.getGoodsNm());//商品名称
                    createParamYg.put("price", hotRankModel.getPrice());//价格
                    createParamYg.put("installmentNumber", hotRankModel.getInstallmentNumber());//最高期数
                    createParamYg.put("image1", hotRankModel.getImage1());//商品第一个图片
                    createParamYg.put("rank", i + 1);//排行
                    createParamYg.put("statNum01", hotRankModel.getCnt());//统计数量
                    createParamYg.put("rankDate", new Date());
                    createParamYg.put("rankTime", new Date());
                    hotRankManager.createRank(createParamYg);
                    i++;
                }
            }
            Map<String, Object> paramJf = Maps.newHashMap();
            paramJf.put("currentDate", currentDate);
            paramJf.put("lastDate", lastDate);
            paramJf.put("orderTypeIdJf", Contants.BUSINESS_TYPE_JF);//积分商城
            paramJf.put("statType", HOTCOLLECTIONRANKCODE);
            List<HotRankModel> itemJfList = hotRankDao.findItemListForCollection(paramJf);//积分商城的单品销量查询
            i = 0;
            if (itemJfList != null && itemJfList.size() != 0) {
                hotRankManager.updateRank(paramJf);// 删除之前排行的数据
                for (HotRankModel itemJf : itemJfList) {
                    if (i > 9) {
                        break;
                    }
                    Map<String, Object> createJfParam = Maps.newHashMap();
                    createJfParam.put("statType", HOTCOLLECTIONRANKCODE);
                    createJfParam.put("orderTypeId", Contants.BUSINESS_TYPE_JF);
                    createJfParam.put("itemCode", itemJf.getItemCode());//单品编码
                    createJfParam.put("goodsName", itemJf.getGoodsNm());//商品名称
                    createJfParam.put("price", itemJf.getPrice());//价格
                    createJfParam.put("image1", itemJf.getImage1());//商品第一个图片
                    createJfParam.put("rank", i + 1);//排行
                    createJfParam.put("statNum01", itemJf.getCnt());//统计数量
                    createJfParam.put("rankDate", new Date());
                    createJfParam.put("rankTime", new Date());
                    hotRankManager.createRank(createJfParam);
                    i++;
                }
            }
        } catch (Exception e) {
            log.error("hotSaleRank Excpetion {}.", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 供应商热销统计排行
     *
     * @throws BatchException
     */
    private void priHotSaleRankForVendor() throws BatchException {
        try {
            String currentDate = DateTime.now().toString(DateHelper.YYYYMMDD);
            String lastDate = DateTime.now().minusDays(30).toString(DateHelper.YYYYMMDD);//30天前的日期
            Map<String, Object> selectParam = Maps.newHashMap();
            selectParam.put("shopType", Contants.BUSINESS_TYPE_YG);
            List<String> vendorIdList = hotRankDao.findValidVendorId(selectParam);
            selectParam.put("currentDate", currentDate);
            selectParam.put("lastDate", lastDate);
            selectParam.put("orderTypeIdYg", Contants.BUSINESS_TYPE_YG);//广发商城
            selectParam.put("statType", VENDORHOTSALERANKCODE);
            selectParam.put("vendorIdList", vendorIdList);
            List<HotRankModel> hotSaleVendorYg = hotRankDao.findVendorHotSaleItem(selectParam);
            int i = 0;
            String vendorId = "";
            String fltVendorId = "";
            if (hotSaleVendorYg != null && hotSaleVendorYg.size() != 0) {
                hotRankManager.updateRank(selectParam);// 删除之前排行的数据
                for (HotRankModel hotSaleYg : hotSaleVendorYg) {
                    vendorId = hotSaleYg.getVendorId();
                    if (!fltVendorId.equals(vendorId)) {
                        i = 0;
                    }
                    if (i > 9) {
                        continue;
                    }
                    Map<String, Object> createYgParam = Maps.newHashMap();
                    createYgParam.put("statType", VENDORHOTSALERANKCODE);
                    createYgParam.put("orderTypeId", Contants.BUSINESS_TYPE_YG);
                    createYgParam.put("vendorId", hotSaleYg.getVendorId());//供应商Id
                    createYgParam.put("vendorName", hotSaleYg.getFullName());//供应商全名
                    createYgParam.put("itemCode", hotSaleYg.getItemCode());//单品编码
                    createYgParam.put("goodsName", hotSaleYg.getGoodsNm());//商品名称
                    createYgParam.put("price", hotSaleYg.getPrice());//价格
                    createYgParam.put("installmentNumber",hotSaleYg.getInstallmentNumber());//最高期数
                    createYgParam.put("image1", hotSaleYg.getImage1());//商品第一个图片
                    createYgParam.put("rank", i + 1);//排行
                    createYgParam.put("statNum01", hotSaleYg.getNum());//统计数量
                    createYgParam.put("rankDate", new Date());
                    createYgParam.put("rankTime", new Date());
                    hotRankManager.createRank(createYgParam);
                    i++;
                    fltVendorId = hotSaleYg.getVendorId();
                }
            }

            Map<String, Object> selectJfParam = Maps.newHashMap();
            selectJfParam.put("shopType", Contants.BUSINESS_TYPE_JF);
            List<String> vendorIdJfList = hotRankDao.findValidVendorId(selectJfParam);
            selectJfParam.put("currentDate", currentDate);
            selectJfParam.put("lastDate", lastDate);
            selectJfParam.put("orderTypeIdJf", Contants.BUSINESS_TYPE_JF);
            selectJfParam.put("statType", VENDORHOTSALERANKCODE);
            selectJfParam.put("vendorIdList", vendorIdJfList);
            List<HotRankModel> hotSaleVendorJf = hotRankDao.findVendorHotSaleItem(selectJfParam);
            int k = 0;
            String vendorIdJF = "";
            String fltJFVendorId = "";
            if (hotSaleVendorJf != null && hotSaleVendorJf.size() != 0) {
                hotRankManager.updateRank(selectJfParam);// 删除之前排行的数据
                for (HotRankModel hotSaleJf : hotSaleVendorJf) {
                    vendorIdJF = hotSaleJf.getVendorId();
                    if (!fltJFVendorId.equals(vendorIdJF)) {
                        k = 0;
                    }
                    if (k > 9) {
                        continue;
                    }
                    Map<String, Object> createJfParam = Maps.newHashMap();
                    createJfParam.put("statType", VENDORHOTSALERANKCODE);
                    createJfParam.put("orderTypeId", Contants.BUSINESS_TYPE_JF);
                    createJfParam.put("vendorId", hotSaleJf.getVendorId());//供应商Id
                    createJfParam.put("vendorName", hotSaleJf.getFullName());//供应商全名
                    createJfParam.put("itemCode", hotSaleJf.getItemCode());//单品编码
                    createJfParam.put("goodsName", hotSaleJf.getGoodsNm());//商品名称
                    createJfParam.put("price", hotSaleJf.getPrice());//价格
                    createJfParam.put("image1", hotSaleJf.getImage1());//商品第一个图片
                    createJfParam.put("rank", k + 1);//排行
                    createJfParam.put("statNum01", hotSaleJf.getNum());//统计数量
                    createJfParam.put("rankDate", new Date());
                    createJfParam.put("rankTime", new Date());
                    hotRankManager.createRank(createJfParam);
                    k++;
                    fltJFVendorId = hotSaleJf.getVendorId();
                }
            }
        } catch (Exception e) {
            log.error("hotSaleRankForVendor Excpetion {}.", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 供应商热门收藏排行
     *
     * @throws BatchException
     */
    private void priHotCollectionRankForVendor() throws BatchException {
        try {
            String currentDate = DateTime.now().toString(DateHelper.YYYYMMDD);
            String lastDate = DateTime.now().minusDays(30).toString(DateHelper.YYYYMMDD);
            Map<String, Object> selectYgParam = Maps.newHashMap();
            selectYgParam.put("shopType", Contants.BUSINESS_TYPE_YG);
            List<String> vendorIdList = hotRankDao.findValidVendorId(selectYgParam);
            selectYgParam.put("currentDate", currentDate);
            selectYgParam.put("lastDate", lastDate);
            selectYgParam.put("orderTypeIdYg", Contants.BUSINESS_TYPE_YG);//广发商城
            selectYgParam.put("statType", VENDORHOTCOLLECTIONRANKCODE);
            selectYgParam.put("vendorIdList", vendorIdList);
            List<HotRankModel> hotRankYg = hotRankDao.findVendorHotCollectionItem(selectYgParam);
            int i = 0;
            String vendorId = "";
            String fltVendorId = "";
            if (hotRankYg != null && hotRankYg.size() != 0) {
                hotRankManager.updateRank(selectYgParam);//删除之前的排行数据
                for (HotRankModel hotRankModel : hotRankYg) {
                    vendorId = hotRankModel.getVendorId();
                    if (!fltVendorId.equals(vendorId)) {
                        i = 0;
                    }
                    if (i > 9) {
                        continue;
                    }
                    Map<String, Object> createYgParam = Maps.newHashMap();
                    createYgParam.put("statType", VENDORHOTCOLLECTIONRANKCODE);
                    createYgParam.put("orderTypeId", Contants.BUSINESS_TYPE_YG);
                    createYgParam.put("vendorId", hotRankModel.getVendorId());//供应商Id
                    createYgParam.put("vendorName", hotRankModel.getFullName());//供应商全名
                    createYgParam.put("itemCode", hotRankModel.getItemCode());//单品编码
                    createYgParam.put("goodsName", hotRankModel.getGoodsNm());//商品名称
                    createYgParam.put("price", hotRankModel.getPrice());//价格
                    createYgParam.put("image1", hotRankModel.getImage1());//商品第一个图片
                    createYgParam.put("installmentNumber",hotRankModel.getInstallmentNumber());//最高期数
                    createYgParam.put("rank", i + 1);//排行
                    createYgParam.put("statNum01", hotRankModel.getCnt());//统计数量
                    createYgParam.put("rankDate", new Date());
                    createYgParam.put("rankTime", new Date());
                    hotRankManager.createRank(createYgParam);
                    i++;
                    fltVendorId = hotRankModel.getVendorId();
                }
            }


            Map<String, Object> selectJfParam = Maps.newHashMap();
            selectJfParam.put("shopType", Contants.BUSINESS_TYPE_JF);
            List<String> vendorJfList = hotRankDao.findValidVendorId(selectJfParam);
            selectJfParam.put("currentDate", currentDate);
            selectJfParam.put("lastDate", lastDate);
            selectJfParam.put("orderTypeIdJf", Contants.BUSINESS_TYPE_JF);//积分商城
            selectJfParam.put("statType", VENDORHOTCOLLECTIONRANKCODE);
            selectJfParam.put("vendorIdList", vendorJfList);
            List<HotRankModel> hotRankJf = hotRankDao.findVendorHotCollectionItem(selectJfParam);
            int k = 0;
            String vendorJFId = "";
            String fltVendorJFId = "";
            if (hotRankJf != null && hotRankJf.size() != 0) {
                hotRankManager.updateRank(selectJfParam);//删除之前的排行数据
                for (HotRankModel hotRankModel : hotRankJf) {
                    vendorJFId = hotRankModel.getVendorId();
                    if (!fltVendorJFId.equals(vendorJFId)) {
                        k = 0;
                    }
                    if (k > 9) {
                        continue;
                    }
                    Map<String, Object> createJfParam = Maps.newHashMap();
                    createJfParam.put("statType", VENDORHOTCOLLECTIONRANKCODE);
                    createJfParam.put("orderTypeId", Contants.BUSINESS_TYPE_JF);
                    createJfParam.put("vendorId", hotRankModel.getVendorId());//供应商Id
                    createJfParam.put("vendorName", hotRankModel.getFullName());//供应商全名
                    createJfParam.put("itemCode", hotRankModel.getItemCode());//单品编码
                    createJfParam.put("goodsName", hotRankModel.getGoodsNm());//商品名称
                    createJfParam.put("price", hotRankModel.getPrice());//价格
                    createJfParam.put("image1", hotRankModel.getImage1());//商品第一个图片
                    createJfParam.put("rank", k + 1);//排行
                    createJfParam.put("statNum01", hotRankModel.getCnt());//统计数量
                    createJfParam.put("rankDate", new Date());
                    createJfParam.put("rankTime", new Date());
                    hotRankManager.createRank(createJfParam);
                    k++;
                    fltVendorJFId = hotRankModel.getVendorId();
                }
            }
        } catch (Exception e) {
            log.error("hotCollectionForVendor Excpetion {}.", Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 热销品类统计
     *
     * geshuo 20160902
     */
    private void priCountHotCategory() throws Exception{
        try{
            //校验今天是否已经统计过
            Map<String,Object> checkParamMap = Maps.newHashMap();
            checkParamMap.put("statType","0003");
            checkParamMap.put("todayDate",DateHelper.getCurrentDate());
            Long dataCount = hotRankDao.checkDataCount(checkParamMap);
            if(dataCount > 0){
                return;
            }

            Date startDate = DateTime.now().minusDays(30).toDate();//30天前
            Date nowDate = DateTime.now().toDate();

            //查询广发商城符合条件的订单
            Map<String,Object> ygParamMap = Maps.newHashMap();
            ygParamMap.put("orderTypeIdYg","YG");
            ygParamMap.put("startDate",startDate);
            ygParamMap.put("endDate",nowDate);
            List<HotRankModel> ygRankList = hotRankDao.findHotCategory(ygParamMap);

            //查询积分商城符合条件的订单
            Map<String,Object> jfParamMap = Maps.newHashMap();
            jfParamMap.put("orderTypeIdJf","JF");
            jfParamMap.put("startDate",startDate);
            jfParamMap.put("endDate",nowDate);
            List<HotRankModel> jfRankList = hotRankDao.findHotCategory(jfParamMap);

            //组装排行数据
            List<CommendRankBatchModel> rankInsertList = Lists.newArrayList();

            //广发商城数据解析
            if(ygRankList != null && ygRankList.size() > 0){
                rankInsertList.addAll(parseCategoryRankList(ygRankList, nowDate, "YG"));
            }

            //积分商城数据解析
            if(jfRankList != null && jfRankList.size() > 0){
                rankInsertList.addAll(parseCategoryRankList(jfRankList, nowDate, "JF"));
            }

            if(!rankInsertList.isEmpty()) {
                //删除
                Map<String, Object> deleteParams = Maps.newHashMap();
                deleteParams.put("statType", "0003");//删除所有热销品类统计数据
                hotRankManager.updateRank(deleteParams);

                //批量插入排行表
                hotRankManager.insertBatchRank(rankInsertList);
            }
        } catch (Exception e){
            log.error("HotRankManager.countHotCategory.error Exception:{}" ,Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /*
    * 使用 Map按value进行排序
    * @param map
    */
    private static Map<Long,Integer>  sortMapByValue(Map<Long,Integer> oriMap) {
        if (oriMap == null || oriMap.isEmpty()) {
            return null;
        }
        Map<Long, Integer> sortedMap = new LinkedHashMap<Long, Integer>();
        List<Map.Entry<Long, Integer>> entryList = new ArrayList<Map.Entry<Long, Integer>>(
                oriMap.entrySet());
        Collections.sort(entryList, new MapValueComparator());
        Iterator<Map.Entry<Long, Integer>> iter = entryList.iterator();
        Map.Entry<Long, Integer> tmpEntry = null;
        while (iter.hasNext()) {
            tmpEntry = iter.next();
            sortedMap.put(tmpEntry.getKey(), tmpEntry.getValue());
        }
        return sortedMap;
    }

    private static class MapValueComparator implements Comparator<Map.Entry<Long, Integer>>{
        public int compare(Map.Entry<Long, Integer> me1, Map.Entry<Long, Integer> me2) {
            return me2.getValue().compareTo(me1.getValue());
        }
    }
    /**
     * 热销品类数据解析
     * @param modelList 待处理数据
     * @param nowDate 当前时间
     * @param ordertypeId 业务类型
     * @return 处理结果
     *
     * geshuo 20160902
     */
    private List<CommendRankBatchModel> parseCategoryRankList(List<HotRankModel> modelList,Date nowDate,String ordertypeId){
        List<CommendRankBatchModel> resultList = Lists.newArrayList();

        Map<Long,Integer> cateCount = Maps.newHashMap();
        for (HotRankModel hotRankModel:modelList){
            Long product = hotRankModel.getProductId();
            if (product == null){
                continue;
            }
            Response<Spu> spuR = spuService.findById(product);
            if(!spuR.isSuccess() || spuR.getResult() == null){
                continue;
            }
            Long cateGoryId = spuR.getResult().getCategoryId();
            if(cateGoryId == null){
                continue;
            }
            if (cateCount.get(cateGoryId)==null){
                cateCount.put(cateGoryId,hotRankModel.getGoodsCount());
            }else{
                cateCount.put(cateGoryId,cateCount.get(cateGoryId) + hotRankModel.getGoodsCount());
            }
        }
        Map<Long, Integer> sortedMap = sortMapByValue(cateCount);
        int i = 0;
        for (Map.Entry<Long, Integer> entry : sortedMap.entrySet()) {
            if (i > 10){
                break;
            }
            List<BackCategory> backCategoriesR = bch.ancestorsOf(entry.getKey());
            if(backCategoriesR == null) {
                continue;
            }
            if(backCategoriesR.size() < 4 || backCategoriesR.get(3)==null){
                continue;
            }
            CommendRankBatchModel model = new CommendRankBatchModel();
            model.setBackCategory1Id(backCategoriesR.get(3).getId());
            model.setBackCategory1Name(backCategoriesR.get(3).getName());
            model.setStatType("0003");
            model.setOrdertypeId(ordertypeId);//业务类型 YG  JF
            model.setRank(i + 1);//已经排好顺序,索引作为顺序使用
            model.setStatNum01(entry.getValue());//商品销量
            model.setRankDate(nowDate);
            model.setRankTime(nowDate);
            resultList.add(model);
            i++;
        }
        return resultList;
    }

    /**
     * 通用统计（供应商销量统计）
     *
     * geshuo 20160902
     */
    private void priCountHotVendor() throws Exception{
        try{
            //校验今天是否已经统计过
            Map<String,Object> checkParamMap = Maps.newHashMap();
            checkParamMap.put("statType","0004");
            checkParamMap.put("todayDate",DateHelper.getCurrentDate());
            Long dataCount = hotRankDao.checkDataCount(checkParamMap);
            if(dataCount > 0){
                return;
            }

            Date startDate = DateTime.now().minusDays(30).toDate();//30天前
            Date nowDate = DateTime.now().toDate();

            //查询广发商城供应商
            Map<String,Object> ygParamMap = Maps.newHashMap();
            ygParamMap.put("orderTypeIdYg","YG");
            ygParamMap.put("startDate",startDate);
            ygParamMap.put("endDate",nowDate);
            List<HotRankModel> ygRankList = hotRankDao.findHotVendor(ygParamMap);

            //查询积分商城供应商
            Map<String,Object> jfParamMap = Maps.newHashMap();
            jfParamMap.put("orderTypeIdJf","JF");
            jfParamMap.put("startDate",startDate);
            jfParamMap.put("endDate",nowDate);
            List<HotRankModel> jfRankList = hotRankDao.findHotVendor(jfParamMap);

            //组装排行数据
            List<CommendRankBatchModel> rankInsertList = Lists.newArrayList();

            //广发商城数据解析
            if(ygRankList != null && ygRankList.size() > 0){
                rankInsertList.addAll(parseVendorRankList(ygRankList, nowDate, "YG"));
            }

            //积分商城数据解析
            if(jfRankList != null && jfRankList.size() > 0){
                rankInsertList.addAll(parseVendorRankList(jfRankList, nowDate, "JF"));
            }

            if (!rankInsertList.isEmpty()) {
                hotRankManager.createCountHotVendor(rankInsertList);
            }
        } catch (Exception e) {
            log.error("HotRankManager.countHotVendor.error Exception:{}" ,Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }

    /**
     * 热销供应商数据解析
     * @param modelList 待处理数据
     * @param nowDate 当前时间
     * @param ordertypeId 业务类型
     * @return 处理结果
     *
     * geshuo 20160902
     */
    private List<CommendRankBatchModel> parseVendorRankList(List<HotRankModel> modelList,Date nowDate,String ordertypeId){
        List<CommendRankBatchModel> resultList = Lists.newArrayList();
        for(int i = 0,len = modelList.size(); i < len;i++){
            HotRankModel hotRankModel = modelList.get(i);
            CommendRankBatchModel model = new CommendRankBatchModel();
            model.setVendorId(hotRankModel.getVendorId());
            model.setVendorName(hotRankModel.getFullName());
            model.setStatType("0004");
            model.setOrdertypeId(ordertypeId);//业务类型 YG  JF
            model.setRank(i + 1);//已经排好顺序,索引作为顺序使用
            model.setStatNum01(hotRankModel.getGoodsCount());//商品销量
            model.setRankDate(nowDate);
            model.setRankTime(nowDate);
            resultList.add(model);
        }
        return resultList;
    }

    /**
     * 通用统计（供应商一周数据统计）
     *
     * geshuo 20160902
     */
    private void priCountVendorWeekSale() throws Exception{
        try{
            //FIXME 时间有问题
            String statType = "0005";//统计类型

            DateTime nowDateTime = DateTime.now();
            Date nowDate = nowDateTime.toDate();

            //获取上个星期一的时间
            DateTime lastMonday = DateTime.now().minusWeeks(1).withDayOfWeek(1).withHourOfDay(0).withMinuteOfHour(0).withSecondOfMinute(0).withMillisOfSecond(0);//设置为0点

            //获取本星期一的时间
            DateTime thisMonday = DateTime.now().withDayOfWeek(1).withHourOfDay(0).withMinuteOfHour(0).withSecondOfMinute(0).withMillisOfSecond(0);


            //查询统计表中是否存在上周的数据,如果存在,抛出业务异常,避免重复统计
            Map<String,Object> checkParamMap = Maps.newHashMap();
            checkParamMap.put("startDate",thisMonday.toDate());//本周一
            checkParamMap.put("endDate",thisMonday.plusDays(7).toDate());//下周一
            checkParamMap.put("statType",statType);
            Long dataCount = hotRankDao.checkDataCount(checkParamMap);
            if(dataCount > 0){
                return;
            }

            //查询时间段  上星期一 <=  time  <本星期一
            Map<String,Object> paramMap = Maps.newHashMap();
            paramMap.put("startDate",lastMonday.toDate());
            paramMap.put("endDate",thisMonday.toDate());

            List<HotRankModel> rankList = hotRankDao.findVendorCountData(paramMap);

            //组装排行数据
            List<CommendRankBatchModel> rankInsertList = Lists.newArrayList();
            for(HotRankModel hotRankModel:rankList){
                CommendRankBatchModel model = new CommendRankBatchModel();
                model.setVendorId(hotRankModel.getVendorId());
                model.setVendorName(hotRankModel.getFullName());
                model.setStatType(statType);

                Date doTime = hotRankModel.getDoTime();
                DateTime dateTime = new DateTime(doTime);
                model.setRank(dateTime.getDayOfWeek());// 1～7 表示星期一到星期日

                model.setStatNum01(hotRankModel.getOrderCount());//	订单成交笔数
                model.setStatNum02(hotRankModel.getMemberCount()); //	成交用户数
                model.setRankDate(nowDate);
                model.setRankTime(nowDate);
                rankInsertList.add(model);
            }

            if(rankInsertList.size() > 0){
                hotRankManager.createCountVendorWeekSale(statType, rankInsertList);
            }

        } catch (Exception e) {
            log.error("HotRankManager.countVendorWeekSale.error Exception:{}" ,Throwables.getStackTraceAsString(e));
            throw new BatchException(e);
        }
    }


}
