package cn.com.cgbchina.batch.service;

import cn.com.cgbchina.batch.dao.DealBestRateDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.manager.DealBestRateManager;

import cn.com.cgbchina.batch.model.DealBestRateModel;
import cn.com.cgbchina.common.utils.DateHelper;
import com.google.common.base.Splitter;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.category.model.Spu;
import com.spirit.category.service.SpuService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;


/**
 * Created by tongxueying on 2016/7/18.
 */
@Service
@Slf4j
public class DealBestRateServiceImpl implements DealBestRateService {
    @Autowired
    private DealBestRateManager dealBestRateManager;
    @Autowired
    private SpuService spuService;
    @Resource
    private DealBestRateDao dealBestRateDao;
    private BigDecimal singlePoint;// 当月单位积分
    private BigDecimal pointRate;//积分池中的当月最高倍率
    private String curMonth;// 当前月
    private Map<String, Map<String, BigDecimal>> rateMap = Maps.newHashMap();
    @Override
    public Response<Boolean> executeDealBestRate() {
        Response<Boolean> response = new Response<>();
        try {
            dealBestRate();
            response.setResult(Boolean.TRUE);
            return response;
        } catch (BatchException e) {
            response.setError(Throwables.getStackTraceAsString(e));
            return response;
        }
    }

    /**
     * 计算最佳倍率
     *
     * @throws BatchException
     */
    public void dealBestRate() throws BatchException {
        curMonth = DateHelper.getyyyyMM();

        try {
            Map<String, Object> runningBatchParam = Maps.newHashMap();
            runningBatchParam.put("jobName", "DealBestRate");
            runningBatchParam.put("jobParam1", "bestRate");
            runningBatchParam.put("jobParam2", "计算最佳倍率");
            runningBatchParam.put("isSuccess", "I");
            dealBestRateManager.createBatchStatus(runningBatchParam);//插入任务表
            initRate();
            log.info("查询当月积分池中的单位积分、最高倍率 以及 特殊积分兑换比例");
            long count = dealBestRateDao.findGoodsInfCount();
            // 多线程执行
            ExecutorService executorService = Executors.newCachedThreadPool();
            CompletionService<Boolean> completionService = new ExecutorCompletionService<Boolean>(executorService);
            boolean retFlg = true;
            for (int i = 0; i < count; i = i + 1000) {
                submitService(completionService, i);
            }
            for (int i = 0; i < count; i = i + 1000) {
                if (!completionService.take().get()) {
                    retFlg = false;
                }
            }
            if (retFlg) {
                DealBestRateModel dealBestRateModel = new DealBestRateModel();
                dealBestRateModel.setParamJobName("DealBestRate");//作业名
                dealBestRateModel.setParamJobParam1("bestRate");//作业参数1
                dealBestRateModel.setParamIsSuccess("Y");//是否成功标识
                dealBestRateManager.updateStatusByRunning(dealBestRateModel);
                log.info("计算最佳倍率 成功");
            } else {
                DealBestRateModel dealBestRateModel = new DealBestRateModel();
                dealBestRateModel.setParamJobName("DealBestRate");//作业名
                dealBestRateModel.setParamJobParam1("bestRate");//作业参数1
                dealBestRateModel.setParamIsSuccess("N");//是否成功标识
                dealBestRateManager.updateStatusByRunning(dealBestRateModel);
                log.info("计算最佳倍率 部分不成功");
            }
        } catch (Exception e) {
            DealBestRateModel dealBestRateModel = new DealBestRateModel();
            dealBestRateModel.setParamJobName("DealBestRate");//作业名
            dealBestRateModel.setParamJobParam1("bestRate");//作业参数1
            dealBestRateModel.setParamIsSuccess("N");//是否成功标识
            dealBestRateManager.updateStatusByRunning(dealBestRateModel);
            log.error("计算最佳倍率 异常");
            throw new BatchException(e);
        }
    }
    /**
     * 线程开始
     *
     * @param completionService
     * @param index
     */
    private void submitService(CompletionService<Boolean> completionService, final int index) {
        completionService.submit(new Callable<Boolean>() {
            @Override
            public Boolean call() throws Exception {
                boolean flg = true;
                log.info("查询最佳倍率" + index);
                List<DealBestRateModel> goodsInfs = dealBestRateDao.findGoodsInf(index, 1000);
                for (DealBestRateModel goodsInf : goodsInfs) {
                    try {
                        dealOne(goodsInf);//计算最佳倍率，并存入单品表
                    } catch (Exception e) {
                        log.error("进行商品[" + goodsInf.getCode() + "]最佳倍率更新时出现错误:" + e.getMessage(), e);
                        flg = false;
                    }
                }
                return flg;
            }
        });
    }

    /**
     * 查询当月积分池中的单位积分、最高倍率 以及 特殊积分兑换比例
     */
    private void initRate() {
        //查询当月积分池表中的单位积分，最高倍率
        List<DealBestRateModel> pointPool = dealBestRateDao.findPointsPool(curMonth);
        if (pointPool != null && pointPool.size() > 0) {
            singlePoint = new BigDecimal(pointPool.get(0).getSinglePoint() != null ?
                    pointPool.get(0).getSinglePoint().toString() : "0");
            pointRate = pointPool.get(0).getPointRate();// 积分池中的当月最高倍率
        } else {
            log.error("获取单月积分池中的数据出现异常");
        }
        List<DealBestRateModel> dealBestRateModels = dealBestRateDao.findSpecialPointScale();
        for (DealBestRateModel dealBestRateModel : dealBestRateModels) {
            makeMap(dealBestRateModel);
        }
    }

    private void makeMap(DealBestRateModel dealBestRateModel) {
        String type = dealBestRateModel.getType();
        BigDecimal scaleRate;
        switch (type) {
            case "0":
            case "1":
            case "3":
                scaleRate = dealBestRateModel.getScale();//品牌类别兑换比率
                String brandId = dealBestRateModel.getTypeId();//品牌类别ID
                splitSetMap(brandId, scaleRate, type);
                break;
            case "2":
                scaleRate = dealBestRateModel.getScale();//后台类目兑换比例
                String backCategoriesId = dealBestRateModel.getTypeId();//后台类目ID
                String[] backCategories3Id = backCategoriesId.split(">");//找到三级类目ID
                splitSetMap(backCategories3Id[2], scaleRate, type);
                break;
            default:
                break;
        }
    }

    /**
     * 计算最佳倍率
     *
     * @param goodsInfs
     */
    private void dealOne(DealBestRateModel goodsInfs) {
        if (goodsInfs != null) {
            BigDecimal bestRate;// 最佳倍率
            String goodsId = goodsInfs.getCode();//商品Id
            String vendorId = goodsInfs.getVendorId();//供应商id
            String brandId = goodsInfs.getGoodsBrandId() == null ? "" : goodsInfs.getGoodsBrandId().toString();//品牌ID
            Long spuId = goodsInfs.getSpuId();//产品id
            Response<Spu> spuR = spuService.findById(spuId);
            String backCategory3Id = spuR.getResult().getCategoryId() == null ?"":spuR.getResult().getCategoryId().toString(); //三级类目id

            long maxPoint = 0L;
            BigDecimal goodsPrice;
            if (goodsInfs.getProductPointRate() != null) { //如果此单品的商品积分不为空，最佳倍率为商品积分
                bestRate = goodsInfs.getProductPointRate();
            }// 如果商品积分为空，则根据特殊倍率计算最佳倍率
            else if (rateMap.containsKey("3") && rateMap.get("3").containsKey(goodsId)) {
                // 如果商品类别的特殊积分兑换比例存在的话，最佳倍率为商品的特殊积分兑换比例
                bestRate = (BigDecimal) rateMap.get("3").get(goodsId);
                //如果商品类别为空，后台类目类别的特殊积分比例存在，则最佳倍率为后台类目的特殊积分兑换比例
            } else if (rateMap.containsKey("2") && rateMap.get("2").containsKey(backCategory3Id)) {
                bestRate = (BigDecimal) rateMap.get("2").get(backCategory3Id);
                // 如果商品和后台类目的积分兑换比例都不存在的话，最佳倍率为品牌的特殊积分兑换比例
            } else if (rateMap.containsKey("1") && rateMap.get("1").containsKey(brandId)) {
                bestRate = (BigDecimal) rateMap.get("1").get(brandId);
                // 如果商品、后台类目、品牌的积分兑换比例都不存在，最佳倍率为供应商的特殊积分兑换比例
            } else if (rateMap.containsKey("0") && rateMap.get("0").containsKey(vendorId)) {
                bestRate = (BigDecimal) rateMap.get("0").get(vendorId);
            } else {
                bestRate = pointRate;// 如果都不存在，则取积分池中的当月最高倍率
            }
            goodsPrice = goodsInfs.getPrice();//单品价格
            //最大积分计算
            maxPoint = goodsPrice.multiply(singlePoint).multiply(bestRate).
                    setScale(0, BigDecimal.ROUND_UP).longValue();
            // 把条件封成一个map
            Map<String, Object> updateParams = Maps.newHashMap();
            updateParams.put("bestRate", bestRate);
            updateParams.put("maxPoint", maxPoint);
            updateParams.put("itemCode", goodsInfs.getItemCode());
            dealBestRateManager.updateItemInf(updateParams);//将最佳倍率和最大积分值存入相应的单品信息中
        }
    }

    /**
     * 拆分id串，设置入map
     *
     * @param strIds
     * @param scaleRate
     * @param type
     */
    private void splitSetMap(String strIds, BigDecimal scaleRate, String type) {
        if (strIds != null) {
            Map<String, BigDecimal> map;
            if (!rateMap.containsKey(type)) {
                rateMap.put(type, Maps.<String, BigDecimal>newHashMap());
            }
            map = rateMap.get(type);

            List<String> arrId = Splitter.on(',').omitEmptyStrings().trimResults().splitToList(strIds);
            for (int i = 0; i < arrId.size(); i++) {
                String id = arrId.get(i);
                if (id != null) {
                    map.put(id, scaleRate);
                }
            }
        }
    }
}
