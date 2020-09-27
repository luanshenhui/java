package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.CommendRankDao;
import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dto.CommendRankDto;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.model.CommendRankModel;
import com.google.common.base.Stopwatch;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

/**
 * Created by 张成 on 16-4-27.
 */
@Service
@Slf4j
public class AdminTopServiceImpl implements AdminTopService {

    // 注入订单商品SERVICE
    @Resource
    private VendorGoodsService vendorGoodsService;
    @Resource
    private GoodsDetailService goodsDetailService;
    @Resource
    private CommendRankDao commendRankDao;
    @Resource
    private GoodsBrandDao goodsBrandDao;// 品牌表

    @Override
    public Response<Map<String, Object>> find(User user) {
        // 实例化返回Response
        Response<Map<String, Object>> response = new Response<Map<String, Object>>();
        // 返回Response有两个LIST，需要用Map装一下
        Map<String, Object> paramMap = Maps.newHashMap();
        try {
            int threads = 5;
            // 多线程执行start
            ExecutorService executorService = Executors.newFixedThreadPool(threads);
            CompletionService<Map<String, Object>> completionService = new ExecutorCompletionService<Map<String, Object>>(executorService);
            //添加多线程start
            completionService.submit(this.orderCommendRank());
            completionService.submit(this.vendorCommendRank());
            completionService.submit(this.brandcommendRank());
            completionService.submit(this.approve(user));
            completionService.submit(this.approvePoint(user));
            //添加多线程end
            for (int j = 0; j < threads; j++) {
                Map<String, Object> ret = completionService.take().get();
                paramMap.putAll(ret);
            }
            executorService.shutdown();
            // 多线程执行end
            response.setResult(paramMap);
            return response;
        } catch (Exception e) {
            log.error("get.favorite.top.error{}", Throwables.getStackTraceAsString(e));
            response.setError("get.favorite.top.error");
            return response;
        }
    }

    //热销销售统计
    private Callable<Map<String, Object>> orderCommendRank(){
        Callable<Map<String, Object>> ret = new Callable<Map<String, Object>>() {
            @Override
            public Map<String, Object> call() throws Exception {
                try {
                    Map<String, Object> paramMap = Maps.newHashMap();
                    //改造为从批处理获取top统计信息
                    Response<List<CommendRankDto>> orderGoodsList = goodsDetailService.findCommendRank("YG", 3, "0001");
                    Response<List<CommendRankDto>> pointOrderGoodsList = goodsDetailService.findCommendRank("JF", 3, "0001");
                    // 把它放到paramMap里名字叫goods
                    if (orderGoodsList.isSuccess()) {
                        paramMap.put("goods", orderGoodsList.getResult());
                    }
                    if (pointOrderGoodsList.isSuccess()) {
                        paramMap.put("goodsPoint", pointOrderGoodsList.getResult());
                    }
                    return paramMap;
                } catch (Exception e) {
                    Map<String, Object> error = Maps.newHashMap();
                    return error;
                }
            }
        };
        return ret;
    }
    //供应商热销排行
    private Callable<Map<String, Object>> vendorCommendRank(){
        Callable<Map<String, Object>> ret = new Callable<Map<String, Object>>() {
            @Override
            public Map<String, Object> call() throws Exception {
                try {
                    Map<String, Object> paramMap = Maps.newHashMap();
                    //改造为从批处理获取供应商TOP5信息start
                    CommendRankModel commendRankModel = new CommendRankModel();
                    commendRankModel.setStatType("0004");
                    commendRankModel.setOrdertypeId("YG");
                    commendRankModel.setDelFlag(0);
                    List<CommendRankModel> vendorYG = commendRankDao.findCommendRank(commendRankModel);
                    if (null != vendorYG && !vendorYG.isEmpty()) {
                        if (vendorYG.size() > 5) {
                            List<CommendRankModel> orderCateListtemp = Lists.newArrayList();
                            orderCateListtemp.addAll(vendorYG.subList(0, 5));
                            paramMap.put("vendor", orderCateListtemp);
                        } else {
                            paramMap.put("vendor", vendorYG);
                        }
                    }
                    commendRankModel.setOrdertypeId("JF");
                    List<CommendRankModel> vendorPointJF = commendRankDao.findCommendRank(commendRankModel);
                    if (null != vendorPointJF && !vendorPointJF.isEmpty()) {
                        if (vendorPointJF.size() > 5) {
                            List<CommendRankModel> orderCateListtemp = Lists.newArrayList();
                            orderCateListtemp.addAll(vendorPointJF.subList(0, 5));
                            paramMap.put("vendorPoint", orderCateListtemp);
                        } else {
                            paramMap.put("vendorPoint", vendorPointJF);
                        }
                    }
                    //改造为从批处理获取供应商TOP5信息end
                    return paramMap;
                } catch (Exception e) {
                    Map<String, Object> error = Maps.newHashMap();
                    return error;
                }
            }
        };
        return ret;
    }
    //热销品类
    private Callable<Map<String, Object>> brandcommendRank(){
        Callable<Map<String, Object>> ret = new Callable<Map<String, Object>>() {
            @Override
            public Map<String, Object> call() throws Exception {
                try {
                    Map<String, Object> paramMap = Maps.newHashMap();
                    //改造为从批处理获取热销品类TOP5信息start
                    CommendRankModel commendRankModel = new CommendRankModel();
                    commendRankModel.setStatType("0003");
                    commendRankModel.setOrdertypeId("YG");
                    commendRankModel.setDelFlag(0);
                    List<CommendRankModel> brandYG = commendRankDao.findCommendRank(commendRankModel);
                    if (null != brandYG && !brandYG.isEmpty()) {
                        if (brandYG.size() > 5) {
                            List<CommendRankModel> orderCateListtemp = Lists.newArrayList();
                            orderCateListtemp.addAll(brandYG.subList(0, 5));
                            paramMap.put("brand", orderCateListtemp);
                        } else {
                            paramMap.put("brand", brandYG);
                        }
                    }

                    commendRankModel.setOrdertypeId("JF");
                    List<CommendRankModel> brandPointJF = commendRankDao.findCommendRank(commendRankModel);
                    if (null != brandPointJF && !brandPointJF.isEmpty()) {
                        if (brandPointJF.size() > 5) {
                            List<CommendRankModel> orderCateListtemp = Lists.newArrayList();
                            orderCateListtemp.addAll(brandPointJF.subList(0, 5));
                            paramMap.put("brandPoint", orderCateListtemp);
                        } else {
                            paramMap.put("brandPoint", brandPointJF);
                        }
                    }
                    //改造为从批处理获取热销品类TOP5信息end
                    return paramMap;
                } catch (Exception e) {
                    Map<String, Object> error = Maps.newHashMap();
                    return error;
                }
            }
        };
        return ret;
    }
    //商品待办事项
    private Callable<Map<String, Object>> approve(final User user){
        Callable<Map<String, Object>> ret = new Callable<Map<String, Object>>() {
            @Override
            public Map<String, Object> call() throws Exception {
                try {
                    Map<String, Object> paramMap = Maps.newHashMap();
                    GoodsDetailDto goodsDetailDto;
                    Response<GoodsDetailDto> goodsDetailDtoResponse = vendorGoodsService.find(user);
                    if(!goodsDetailDtoResponse.isSuccess()){
                        log.error("Response.error,error code: {}", goodsDetailDtoResponse.getError());
                        throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
                    }
                    goodsDetailDto = goodsDetailDtoResponse.getResult();
                    Map<String, Object> brandParamMap = Maps.newHashMap();
                    brandParamMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
                    brandParamMap.put("status", 2);//待审核
                    Long brandCount = goodsBrandDao.findBrandCountByParam(brandParamMap);
                    goodsDetailDto.setBrandCount(brandCount.intValue());//品牌审核数量
                    paramMap.put("approve", goodsDetailDto);
                    return paramMap;
                } catch (Exception e) {
                    Map<String, Object> error = Maps.newHashMap();
                    return error;
                }
            }
        };
        return ret;
    }
    //礼品待办事项
    private Callable<Map<String, Object>> approvePoint(final User user){
        Callable<Map<String, Object>> ret = new Callable<Map<String, Object>>() {
            @Override
            public Map<String, Object> call() throws Exception {
                try {
                    Map<String, Object> paramMap = Maps.newHashMap();
                    GoodsDetailDto goodsDetailDtoPoint;
                    Response<GoodsDetailDto> goodsDetailDtoPointResponse = vendorGoodsService.findPoint(user);
                    if(!goodsDetailDtoPointResponse.isSuccess()){
                        log.error("Response.error,error code: {}", goodsDetailDtoPointResponse.getError());
                        throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
                    }
                    goodsDetailDtoPoint = goodsDetailDtoPointResponse.getResult();
                    //查询品牌审核数量
                    Map<String, Object> brandParamMap = Maps.newHashMap();
                    brandParamMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
                    brandParamMap.put("status", 2);//待审核
                    Long brandCountPoint = goodsBrandDao.findBrandCountByParam(brandParamMap);
                    goodsDetailDtoPoint.setBrandCount(brandCountPoint.intValue());//品牌审核数量
                    // 把它放到paramMap里名字叫approve
                    paramMap.put("approvePoint", goodsDetailDtoPoint);
                    return paramMap;
                } catch (Exception e) {
                    Map<String, Object> error = Maps.newHashMap();
                    return error;
                }
            }
        };
        return ret;
    }
}
