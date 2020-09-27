/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dao.GoodsOperateDetailDao;
import cn.com.cgbchina.item.manager.GoodsOperateDetaiManager;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsOperateDetailModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.Map;

/**
 * @author 陈乐
 * @version 1.0
 * @Since 2016/6/20.
 */

@Slf4j
@Service
public class GoodsOperateDetailServiceImpl implements GoodsOperateDetailService {

    @Resource
    private GoodsOperateDetailDao goodsOperateDetailDao;
    @Resource
    private GoodsOperateDetaiManager goodsOperateDetaiManager;
    @Resource
    private BackCategoriesService backCategoriesService;
    @Resource
    private GoodsBrandDao goodsBrandDao;

    /**
     * 查找商品操作历史列表
     * @param pageNo
     * @param size
     * @param goodsCode
     * @return
     */
    @Override
    public Response<Pager<GoodsOperateDetailModel>> findGoodsOperate(Integer pageNo, Integer size, String goodsCode,String goodsName,String startTime,String endTime,User user) {
        Response<Pager<GoodsOperateDetailModel>> result = new Response<>();
        Map<String,Object> params = Maps.newHashMap();
        PageInfo pageInfo = new PageInfo(pageNo, size);
        try {
            params.put("vendorId",user.getVendorId());
            if(!Strings.isNullOrEmpty(goodsCode)){
                params.put("goodCode",goodsCode);
            }
            if(!Strings.isNullOrEmpty(goodsName)){
                params.put("goodName",goodsName);
            }
            if(!Strings.isNullOrEmpty(startTime)){
                params.put("startTime",startTime);
            }
            if(!Strings.isNullOrEmpty(endTime)){
                params.put("endTime",endTime);
            }
            Pager<GoodsOperateDetailModel> pager = goodsOperateDetailDao.findByPage(params,pageInfo.getOffset(),pageInfo.getLimit());
            if (pager.getTotal() == 0) {
                result.setResult(new Pager<GoodsOperateDetailModel>(0L, Collections.<GoodsOperateDetailModel> emptyList()));
            } else {
                result.setResult(pager);
            }
        }catch (Exception e){
            log.error("goods.operate.detail.find.fail,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("goods.operate.detail.find.fail");
        }
        return result;
    }

    @Override
    public Response<Boolean> createGoodsOperate(GoodsOperateDetailModel goodsOperateDetailModel) {
        Response<Boolean> result = new Response<>();
        try {
            //根据传入的后台类目三级id查询相应的name
            Response<BackCategory> backCategory1Response = backCategoriesService.findById(goodsOperateDetailModel.getBackCategory1Id());
            if (backCategory1Response.isSuccess()){
                if(backCategory1Response.getResult()!=null){
                    goodsOperateDetailModel.setBackCategory1Nm(backCategory1Response.getResult().getName());
                }
            }
            Response<BackCategory> backCategory2Response = backCategoriesService.findById(goodsOperateDetailModel.getBackCategory2Id());
            if (backCategory2Response.isSuccess()){
                if(backCategory2Response.getResult()!=null){
                    goodsOperateDetailModel.setBackCategory2Nm(backCategory2Response.getResult().getName());
                }
            }
            Response<BackCategory> backCategory3Response = backCategoriesService.findById(goodsOperateDetailModel.getBackCategory3Id());
            if (backCategory3Response.isSuccess()){
                if(backCategory3Response.getResult()!=null){
                    goodsOperateDetailModel.setBackCategory3Nm(backCategory3Response.getResult().getName());
                }
            }
            //根据传入的品牌id查询相应的品牌name
            GoodsBrandModel goodsBrandModel = goodsBrandDao.findById(goodsOperateDetailModel.getGoodsBrandId());
            goodsOperateDetailModel.setGoodsBrandName(goodsBrandModel.getBrandName());
            goodsOperateDetaiManager.create(goodsOperateDetailModel);
            result.setResult(Boolean.TRUE);
            return result;
        }catch (Exception e){
            log.error("goods operate create error,cause:{}", Throwables.getStackTraceAsString(e));
            result.setError("goods.operate.create.error");
            return result;
        }
    }


}

