package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.ConstantlyExportDao;
import cn.com.cgbchina.batch.dao.OrderExportDao;
import cn.com.cgbchina.batch.model.OrderExportModel;
import cn.com.cgbchina.batch.model.OrderOutputAdminModel;
import cn.com.cgbchina.batch.util.ConstantlyExported;
import cn.com.cgbchina.batch.util.ReportTaskUtil;
import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.ExcelUtilAgency;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Ordering;
import com.google.common.primitives.Ints;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.Spu;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.*;

/**
 * Created by zhangLin on 2016/12/1.
 */
@Service
@Slf4j
public class OrderExportServiceImpl implements OrderExportService{
    @Resource
    private OrderExportDao orderExportDao;
    @Autowired
    private SpuService spuService;
    @Autowired
    private BackCategoryHierarchy bch;
    @Autowired
    private ExcelUtilAgency excelUtilAgency;
    @Autowired
    private ReportTaskUtil reportTaskUtil;
    @Autowired
    private ConstantlyExportDao constantlyExportDao;
    @Value("${admin.orderExportYG.outpath}")
    private String orderExportYG; // 广发商城路径导出
    @Value("${admin.orderExportYG.reportName}")
    private String ygReportName;// 广发报表名称
    @Value("${admin.orderExportYG.tempPath}")
    private String templatePathYG;// 广发商城模板路径
    @Value("${admin.orderExportJF.outpath}")
    private String orderExportJF; // 积分商城路径导出
    @Value("${admin.orderExportJF.reportName}")
    private String jfReportName;// 积分报表名称
    @Value("${admin.orderExportJF.tempPath}")
    private String templatePathJF;// 积分商城模板路径
    private final static Long pagerCount = 25000l;//每次页数


    private Map<String,Map<String,Date>> findOrderDoDetail(List<String> orderids,Boolean isold){
        Map<String,Map<String,Date>> doMap = Maps.newHashMap();
        try {
            List<Map<String,Object>> orderDos;
            if (isold){
                orderDos = orderExportDao.getOrderDodetailOld(orderids);
            }else {
                orderDos = orderExportDao.getOrderDodetail(orderids);
            }
            String tempId = null;
            Map<String,Date> tempmap = Maps.newHashMap();
            for (Map<String,Object> doDetailMap : orderDos){
                if(tempId == null){
                    tempId = doDetailMap.get("orderId").toString();
                }
                if(!tempId.equals(doDetailMap.get("orderId").toString())){
                    doMap.put(tempId,tempmap);
                    tempId = doDetailMap.get("orderId").toString();
                    tempmap = Maps.newHashMap();
                    tempmap.put(doDetailMap.get("statusId").toString(),(Date)doDetailMap.get("doTime"));
                }else{
                    tempmap.put(doDetailMap.get("statusId").toString(),(Date)doDetailMap.get("doTime"));
                }
            }
        }catch (Exception e) {
            log.error(this.getClass().getSimpleName() + ":findOrderDodetail.error",e);
        }
        return doMap;
    }

    public Long getDataAssembledCount(Map<String, Object> paraMap){
        Long count;
        if ("on".equals(paraMap.get("limitFlag"))){
            count = orderExportDao.getExportedExcelOrderOldCount(paraMap);
        }else {
            count = orderExportDao.getExportedExcelOrderCount(paraMap);
        }
        return count;
    }

    public List<OrderOutputAdminModel> getDataAssembled(Map<String, Object> paraMap, long limit, long offset) throws Exception {
        int lm = (int)limit/2000 + 1;
        ExecutorService executorService = Executors.newCachedThreadPool();
        //多线程处理，2000条数据执行一个线程
        CompletionService<List<OrderOutputAdminModel>> completionService = new ExecutorCompletionService<List<OrderOutputAdminModel>>(executorService);
        //商品,礼品编码，商品,礼品名称
        for (int j = 0; j < lm; j++) {
            Map<String, Object> paraNewMap = Maps.newHashMap();
            paraNewMap.putAll(paraMap);
            if (j == lm - 1) {
                paraNewMap.put("offset", offset + 2000l * j);
                paraNewMap.put("limit", limit - 2000l * j);
                submitService(completionService, paraNewMap, (int)offset + 2000 * j);
            } else {
                paraNewMap.put("offset", offset + 2000l * j);
                paraNewMap.put("limit", 2000l);
                submitService(completionService, paraNewMap, (int)offset + 2000 * j);
            }
        }
        List<OrderOutputAdminModel> gfData = Lists.newArrayList();
        for (int j = 0; j < lm; j++){
            gfData.addAll(completionService.take().get());
        }
        executorService.shutdown();
        Ordering<OrderOutputAdminModel> ordering = new Ordering<OrderOutputAdminModel>() {
            @Override
            public int compare(@NotNull OrderOutputAdminModel left, @NotNull OrderOutputAdminModel right) {
                return Ints.compare(left.getNumber(), right.getNumber());
            }
        };
        return ordering.sortedCopy(gfData);
    }

    public void runOrderExport(Map<String, Object> paraMap){
        final String fileName;
        final String filePath;
        final String redisKey;
        String userid = paraMap.get("findUserId").toString();
        log.info("runOrderExport.start", paraMap.toString());
        if (Contants.BUSINESS_TYPE_JF.equals(paraMap.get("ordertypeId"))) {
            fileName = ExcelUtilAgency.encodingOutputFilePathOrder(orderExportJF,jfReportName,userid,DateHelper.getCurrentTimess());
            filePath = templatePathJF;
            redisKey = Contants.REDIS_KEY_ORDEREXPORT + "JF" + userid;
        }else{
            fileName = ExcelUtilAgency.encodingOutputFilePathOrder(orderExportYG,ygReportName,userid,DateHelper.getCurrentTimess());
            filePath = templatePathYG;
            redisKey = Contants.REDIS_KEY_ORDEREXPORT + "YG" + userid;
        }
        try {
            Long count = getDataAssembledCount(paraMap);
            log.info("订单报表总件数:"+count);
            if (count > 100000l) {
                constantlyExportDao.create(redisKey,"97",null);
                return;
            }
            final Long page = count/pagerCount;
            String fileNamePage;
            String paths = null;
            for (int i = 0 ; i <= page; i++) {
                List<OrderOutputAdminModel> data = getDataAssembled(paraMap, pagerCount, pagerCount * i);
                if (page == i) {
                    fileNamePage = fileName + "_end.xlsx";
                } else {
                    fileNamePage = fileName + "_" + page.toString() + ".xlsx";
                }
                log.info("订单报表文件"+fileNamePage);
                String outPath = excelUtilAgency.exportExcel(data, filePath, fileNamePage);
                String path = reportTaskUtil.removeDiskPath(outPath);
                if (paths == null || paths.isEmpty()) {
                    paths = "--" + path;
                } else {
                    paths = paths + "," + path;
                }
                if (page == i) {
                    constantlyExportDao.create(redisKey, paths, null);
                } else {
                    constantlyExportDao.create(redisKey, paths, 1800);
                }
            }
        } catch (Exception e) {
            log.error("订单报表生成异常,erro{}", Throwables.getStackTraceAsString(e));
            constantlyExportDao.create(redisKey,"98",null);
        }
    }

    /**
     *  积分商城数据组成
     *
     *
     * @param orderSubModelList
     * @param orderDoDetailMap
     * @param num
     * @return
     */
    private List<OrderOutputAdminModel> dataAssembledJF(List<OrderExportModel> orderSubModelList,
                                                        Map<String,Map<String,Date>> orderDoDetailMap,int num){
        List<OrderOutputAdminModel> dataList = Lists.newArrayList();

        for (OrderExportModel orderSubModel: orderSubModelList){
            num++;
            Map<String,Date> orderDoDetail = orderDoDetailMap.get(orderSubModel.getOrderId());
            if (orderDoDetail == null ){
                orderDoDetail = Maps.newHashMap();
            }
            //防null处理
            OrderOutputAdminModel orderOutputAdminDto = new OrderOutputAdminModel();
            orderOutputAdminDto.setNumber(num);
            orderOutputAdminDto.setOrdermainId(orderSubModel.getOrdermainId()); //大订单号(AL)
            orderOutputAdminDto.setOrderId(orderSubModel.getOrderId()); //子订单号(AL)
            orderOutputAdminDto.setVendorSnm(orderSubModel.getVendorSnm()); //合作商名称（供应商名称简写）(AL)
            orderOutputAdminDto.setXid(orderSubModel.getXid()); //礼品编码(JF)
            orderOutputAdminDto.setItemName(orderSubModel.getGoodsNm()); //商品,礼品名称(AL)
            orderOutputAdminDto.setPaywayPrice(orderSubModel.getTotalMoney() == null ? "" : orderSubModel.getTotalMoney().toString()); //订单总金额(AL)(payway-> price)
            orderOutputAdminDto.setCreateTime(DateHelper.date2string(orderSubModel.getCreateTime(),DateHelper.YYYY_MM_DD_HH_MM_SS)); //生成订单时间(AL)

            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0309) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0309),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setSendTime(timeString);//发货时间(AL)
                orderOutputAdminDto.setDeliveryTime(intervalsDay(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0309),orderSubModel.getCreateTime())); //发货时效(JF)
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0310) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0310),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setReceivedTime(timeString);//签收时间(AL)
                orderOutputAdminDto.setSignInTime(intervalsDay(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0310),orderSubModel.getCreateTime())); //签收时效(JF)
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0334) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0334) ,DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setApplyReturnTime(timeString);//申请退货时间(AL)
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0327) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0327),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setAgreeReturnTime(timeString);//同意退货时间(AL)
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0335) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0335),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setRefusedReturnTime(timeString);//拒绝退货时间(AL)
            }
            if(orderDoDetail.get(Contants.SUB_SIN_STATUS_0332) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_SIN_STATUS_0332),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setApplyFundsTime(timeString);//申请请款时间(AL)
            }
            if(orderDoDetail.get(Contants.SUB_SIN_STATUS_0311) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_SIN_STATUS_0311),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setOrderSettlementTime(timeString);//订单结算时间(JF)
                orderOutputAdminDto.setSettlementAging(intervalsDay(orderDoDetail.get(Contants.SUB_SIN_STATUS_0311),orderSubModel.getCreateTime())); //结算时效(JF)
            }

            orderOutputAdminDto.setGoodsNum(orderSubModel.getGoodsNum()==null?"":orderSubModel.getGoodsNum().toString()); //订单数量(JF)
            String csgAddress = orderSubModel.getCsgProvince()==null?"":orderSubModel.getCsgProvince()
                    + orderSubModel.getCsgCity()==null?"":orderSubModel.getCsgCity()
                    + orderSubModel.getCsgBorough()==null?"":orderSubModel.getCsgBorough()
                    + orderSubModel.getCsgAddress()==null?"":orderSubModel.getCsgAddress();
            if (org.apache.commons.lang3.StringUtils.isEmpty(csgAddress)) {
                csgAddress = "";
            }
            orderOutputAdminDto.setArea(csgAddress); //地区(JF)
            orderOutputAdminDto.setLogisticsCompany(orderSubModel.getTranscorpNm()); //物流公司(JF)
            orderOutputAdminDto.setLogisticsNumber(orderSubModel.getMailingNum()); //物流单号(JF)
            dataList.add(orderOutputAdminDto);
        }
        return dataList;
    }



    //广发商城数据组成
    private List<OrderOutputAdminModel> dataAssembledYG(List<OrderExportModel> orderSubModelList,
                                                        Map<String,Map<String,Date>> orderDoDetailMap,
                                                        Map<Long,BackCateModel> proBackCate,int num){
        List<OrderOutputAdminModel> dataList = Lists.newArrayList();
        for (OrderExportModel orderSubModel: orderSubModelList){
            num++;
            //防null处理
            BackCateModel backCateModel = proBackCate.get(orderSubModel.getProductId());
            Map<String,Date> orderDoDetail = orderDoDetailMap.get(orderSubModel.getOrderId());
            if (backCateModel == null ){
                backCateModel = new BackCateModel();
            }
            if (orderDoDetail == null ){
                orderDoDetail = Maps.newHashMap();
            }
            OrderOutputAdminModel orderOutputAdminDto = new OrderOutputAdminModel();
            orderOutputAdminDto.setNumber(num);
            orderOutputAdminDto.setOrdermainId(orderSubModel.getOrdermainId());
            orderOutputAdminDto.setOrderId(orderSubModel.getOrderId());
            orderOutputAdminDto.setVendorSnm(orderSubModel.getVendorSnm());
            orderOutputAdminDto.setMid(orderSubModel.getMid());
            orderOutputAdminDto.setItemName(orderSubModel.getGoodsNm());
            orderOutputAdminDto.setGoodsBrand(orderSubModel.getGoodsBrandName());
            orderOutputAdminDto.setBackCategory1(backCateModel.getBackCategory1());
            orderOutputAdminDto.setBackCategory2(backCateModel.getBackCategory2());
            orderOutputAdminDto.setBackCategory3(backCateModel.getBackCategory3());
            orderOutputAdminDto.setActName(orderSubModel.getPromotionName());
            String actType = "";
            if(orderSubModel.getActType()!=null && !orderSubModel.getActType().isEmpty()) {
                //活动类型- 10 折扣 20 满减 30 秒杀 40 团购 50 荷兰拍
                switch (orderSubModel.getActType()) {
                    case "10":
                        actType = "折扣";
                        break;
                    case "20":
                        actType = "满减";
                        break;
                    case "30":
                        actType = "秒杀";
                        break;
                    case "40":
                        actType = "团购";
                        break;
                    case "50":
                        actType = "荷兰拍";
                        break;
                    default:
                        break;
                }
            }
            orderOutputAdminDto.setActType(actType);
            orderOutputAdminDto.setO2oCode(orderSubModel.getO2oCode());
            orderOutputAdminDto.setO2oVoucherCode(orderSubModel.getO2oVoucherCode());
            BigDecimal paywayPrice = BigDecimal.ZERO;
            if(orderSubModel.getTotalMoney()!=null){
                paywayPrice = paywayPrice.add(orderSubModel.getTotalMoney());
            }
            if(orderSubModel.getVoucherPrice()!=null){
                paywayPrice = paywayPrice.add(orderSubModel.getVoucherPrice());
            }
            if(orderSubModel.getUitdrtamt()!=null){
                paywayPrice = paywayPrice.add(orderSubModel.getUitdrtamt());
            }
            orderOutputAdminDto.setPaywayPrice(paywayPrice.toString());
            orderOutputAdminDto.setTotalMoney(orderSubModel.getTotalMoney()==null?"":orderSubModel.getTotalMoney().toString());
            orderOutputAdminDto.setVoucherNm(orderSubModel.getVoucherNm());
            orderOutputAdminDto.setVoucherPrice(orderSubModel.getVoucherPrice()==null?"":orderSubModel.getVoucherPrice().toString());
            orderOutputAdminDto.setSingleBonus(orderSubModel.getSingleBonus()==null?"":orderSubModel.getSingleBonus().toString());
            orderOutputAdminDto.setUitdrtamt(orderSubModel.getUitdrtamt()==null?"":orderSubModel.getUitdrtamt().toString());
            orderOutputAdminDto.setSpecShopno(orderSubModel.getSpecShopno());
            orderOutputAdminDto.setCurStatusNm(orderSubModel.getCurStatusNm());
            orderOutputAdminDto.setCreateTime(DateHelper.date2string(orderSubModel.getCreateTime(),DateHelper.YYYY_MM_DD_HH_MM_SS));

            //状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货
            // 0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请
            // 0380--拒绝签收0381--无人签收0382--订单推送失败
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0309) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0309),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setSendTime(timeString);
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0310) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0310),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setReceivedTime(timeString);
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0334) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0334),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setApplyReturnTime(timeString);
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0327) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0327),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setAgreeReturnTime(timeString);
            }
            if(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0335) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_ORDER_STATUS_0335),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setRefusedReturnTime(timeString);
            }
            if(orderDoDetail.get(Contants.SUB_SIN_STATUS_0332) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_SIN_STATUS_0332),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setApplyFundsTime(timeString);
            }
            if(orderDoDetail.get(Contants.SUB_SIN_STATUS_0350) !=null){
                String timeString = DateHelper.date2string(orderDoDetail.get(Contants.SUB_SIN_STATUS_0350),DateHelper.YYYY_MM_DD_HH_MM_SS);
                orderOutputAdminDto.setAgreeFundsTime(timeString);
            }
            orderOutputAdminDto.setBankOrderNumber(orderSubModel.getOrdernbr());
            orderOutputAdminDto.setSinStatusNm(orderSubModel.getSinStatusNm());
            dataList.add(orderOutputAdminDto);
        }
        return dataList;
    }
    private void submitService(CompletionService<List<OrderOutputAdminModel>> completionService,
                                final Map<String, Object> paraMap, final int start) {
        completionService.submit(new Callable<List<OrderOutputAdminModel>>() {
            @Override
            public List<OrderOutputAdminModel> call() throws Exception {
                try {
                    if(Contants.BUSINESS_TYPE_JF.equals(paraMap.get("ordertypeId"))) {
                        return getPointMaps(paraMap, start);
                    } else {
                        return getGoodsMaps(paraMap, start);
                    }
                } catch (Exception e) {
                    log.error("msg.error------>{}", Throwables.getStackTraceAsString(e));
                    return new ArrayList<OrderOutputAdminModel>();
                }
            }
        });
    }
    //广发商城获取类目信息
    private List<OrderOutputAdminModel> getGoodsMaps(Map<String, Object> paraMap, int start){
        List<OrderOutputAdminModel> goodsList = Lists.newArrayList();
        List<OrderExportModel> orderSubModelList;
        Boolean isold;
        if ("on".equals(paraMap.get("limitFlag"))){
            isold = true;
            log.info(paraMap.get("limit").toString() + "--" +paraMap.get("offset").toString());
            orderSubModelList = orderExportDao.getExportedExcelOrderOld(paraMap);
        }else {
            isold = false;
            log.info(paraMap.get("limit").toString() + "--" +paraMap.get("offset").toString());
            orderSubModelList = orderExportDao.getExportedExcelOrder(paraMap);
        }
        if (orderSubModelList == null || orderSubModelList.size() == 0 ){
            return new ArrayList<>();
        }
        log.info("getGoodsMaps DBnums:" + orderSubModelList.size()+ " start:" + start);
        try {
            Set<Long> products = new HashSet<Long>();
            Set<String> orderids = new HashSet<String>();
            for (OrderExportModel orderExportModel : orderSubModelList){
                products.add(orderExportModel.getProductId());
                orderids.add(orderExportModel.getOrderId());
            }
            Map<String,Map<String,Date>> orderDoDetailMap = findOrderDoDetail(new ArrayList<String>(orderids),isold);
            Map<Long,BackCateModel> proBackCate = Maps.newHashMap();
            for (Long product : products){
                Response<Spu> spuR = spuService.findById(product);
                if (spuR.isSuccess()){
                    Long cateGoryId = spuR.getResult().getCategoryId();
                    List<BackCategory> backCategoriesR = bch.ancestorsOf(cateGoryId);
                    BackCateModel backCateModel = new BackCateModel();
                    for (int i = 0; i<backCategoriesR.size();i++) {
                        BackCategory bc = backCategoriesR.get(i);
                        Pair pair = new Pair(bc.getName(), bc.getId());
                        switch (i) {
                            case 1:
                                backCateModel.setBackCategory1(pair.getName());
                                break;
                            case 2:
                                backCateModel.setBackCategory2(pair.getName());
                                break;
                            case 3:
                                backCateModel.setBackCategory3(pair.getName());
                                break;
                            default:
                                break;
                        }
                    }
                    proBackCate.put(product,backCateModel);
                }
            }
            goodsList = dataAssembledYG(orderSubModelList,orderDoDetailMap,proBackCate,start);
        } catch (Exception e) {
            log.error("fail to getGoodsMap",e);
        }
        return goodsList;
    }

    private List<OrderOutputAdminModel> getPointMaps(Map<String, Object> paraMap, int start){
        List<OrderOutputAdminModel> goodsList = Lists.newArrayList();
        List<OrderExportModel> orderSubModelList;
        Boolean isold;
        if ("on".equals(paraMap.get("limitFlag"))){
            isold = true;
            orderSubModelList = orderExportDao.getExportedExcelOrderOld(paraMap);
        }else {
            isold = false;
            orderSubModelList = orderExportDao.getExportedExcelOrder(paraMap);
        }
        if (orderSubModelList == null || orderSubModelList.size() == 0 ){
            return new ArrayList<>();
        }
        log.info("getPointMaps DBnums:" + orderSubModelList.size()+ " start:" + start);
        try {
            final List<String> orderids = Lists.transform(orderSubModelList, new Function<OrderExportModel, String>() {
                @Override
                public String apply(@NotNull OrderExportModel input) {
                    return input.getOrderId();
                }
            });
            Map<String,Map<String,Date>> orderDoDetailMap = findOrderDoDetail(new ArrayList<String>(orderids),isold);
            goodsList = dataAssembledJF(orderSubModelList,orderDoDetailMap,start);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return goodsList;
    }

    @Setter
    @Getter
    private class BackCateModel {

        private String backCategory1;

        private String backCategory2;

        private String backCategory3;

    }

    private String intervalsDay(Date date1, Date date2) {
        if (date1 == null || date2 == null) {
            return null;
        }
        long l = date1.getTime() - date2.getTime();
        long day = l / ( 24 * 60 * 60 * 1000);
        return String.valueOf(day);
    }

    //删除指定的临时文件
    public Boolean deleteOrderExcel(String userId, String ordertypeId) {
        try{
            String filepath;
            if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId)){
                filepath = ExcelUtilAgency.encodingOutputFilePathOrder(orderExportJF, jfReportName, userId, null);
            }else{
                filepath = ExcelUtilAgency.encodingOutputFilePathOrder(orderExportYG, ygReportName, userId, null);
            }
            filepath = reportTaskUtil.addDiskPath(filepath);
            File f1 = new File(filepath);
            log.info("delete.orderExcel.filepaht:{}",filepath);
            ConstantlyExported constantlyExported = new ConstantlyExported();
            if (!constantlyExported.deleteDir(f1)){
                log.error("delete.orderExcel.filepaht.fail");
                return false;
            }
            return true;
        }catch (Exception e){
            log.error("delete.orderExcel.filepaht.fail:",e);
            return false;
        }
    }
}
