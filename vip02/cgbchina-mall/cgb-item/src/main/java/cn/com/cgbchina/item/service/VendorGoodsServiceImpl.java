package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.model.GoodsModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-4-26.
 */

@Service
@Slf4j
public class VendorGoodsServiceImpl implements VendorGoodsService {

    // 注入商品SERVICE
    @Resource
    private GoodsDao goodsDao;

    @Override
    public Response<GoodsDetailDto> find(User user) {
        Response<GoodsDetailDto> response = new Response<GoodsDetailDto>();
        Map<String, Object> paramMap = Maps.newHashMap();
        Map<String, Object> shelfMap = Maps.newHashMap();
        List<GoodsModel> goodsList = new ArrayList<GoodsModel>();
        try {
            if (user != null) {
                // 把商品检索的条件写上
                paramMap.put("vendorId", user.getVendorId());
                shelfMap.put("vendorId", user.getVendorId());
            }
            paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
            shelfMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
            goodsList = goodsDao.findGoodsCount(paramMap);// 查询所有状态的商品goodsList
            GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
            Integer changeCount = 0;
            Integer waitCount = 0;
            Integer unPassCount = 0;
            Integer unSubmitCount = 0;
            // 循环list判断属于那种，把数量附上
            for (GoodsModel goodsModelEach : goodsList) {
                String approveStatus = goodsModelEach.getApproveStatus();//审核状态
                Integer count = goodsModelEach.getEachCount();//数量
                if (Contants.GOODS_APPROVE_STATUS_00.equals(approveStatus)) {//未提交审核
                    unSubmitCount+=count;//未提交审核数量（供应商平台）
                } else if (Contants.GOODS_APPROVE_STATUS_01.equals(approveStatus)) { //待初审
                    goodsDetailDto.setWaitFirstCount(count);// 商品初审数量
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_02.equals(approveStatus)) { //待复审
                    goodsDetailDto.setWaitSecondCount(count);// 商品复审数量
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_03.equals(approveStatus) || Contants.GOODS_APPROVE_STATUS_04.equals(approveStatus)) { //信息变更审核
                    changeCount += count;
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_05.equals(approveStatus)) { ///商品下架审核
                    goodsDetailDto.setShelfApproveCount(count);//商品下架审核
                    waitCount += count;
                }else if (Contants.GOODS_APPROVE_STATUS_70.equals(approveStatus) || Contants.GOODS_APPROVE_STATUS_71.equals(approveStatus)){
                    unSubmitCount+=count;//未提交审核数量（供应商平台）
                    unPassCount += count;
                }
                else if (Contants.GOODS_APPROVE_STATUS_72.equals(approveStatus)|| Contants.GOODS_APPROVE_STATUS_73.equals(approveStatus)
                        || Contants.GOODS_APPROVE_STATUS_74.equals(approveStatus)) {
                    unPassCount += count;
                }
            }
            Integer saleCount = goodsDao.findUpShelfGoodsCount(shelfMap);//上架的商品数量即为出售中的商品数量
            Integer waitUpCount = goodsDao.findDownShelfGoodsCount(shelfMap); //下架的商品数量即为待上架的商品数量
            goodsDetailDto.setChangeCount(changeCount);//变更审核数量
            goodsDetailDto.setUnPassCount(unPassCount);//未通过审核数量（供应商平台首页）
            goodsDetailDto.setWaitCount(waitCount);//待审核商品数量（供应商平台首页）
            goodsDetailDto.setSaleCount(saleCount);//出售中的商品数量（供应商平台首页）
            goodsDetailDto.setWaitUpCount(waitUpCount);//待上架商品数量
            goodsDetailDto.setUnSubmitCount(unSubmitCount);//未提交审核数量
            response.setResult(goodsDetailDto);
            // 返回
            return response;
        } catch (Exception e) {
            log.error("get.goods.status.error", Throwables.getStackTraceAsString(e));
            response.setError("get.admin.top.error");
            return response;
        }
    }

    @Override
    public Response<GoodsDetailDto> findPoint(User user) {
        Response<GoodsDetailDto> response = Response.newResponse();
        Map<String, Object> paramMap = Maps.newHashMap();
        Map<String, Object> shelfMap = Maps.newHashMap();
        List<GoodsModel> goodsList = new ArrayList<GoodsModel>();
        try {
            // 把商品检索的条件写上
            if (user != null) {
                paramMap.put("vendorId", user.getVendorId());
                shelfMap.put("vendorId", user.getVendorId());
            }
            paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
            shelfMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
            GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
            Integer changeCount = 0;
            Integer waitCount = 0;
            Integer unPassCount = 0;
            Integer unSubmitCount = 0;
            goodsList = goodsDao.findGoodsCount(paramMap);// 查询所有状态的商品goodsList
            // 循环list判断属于那种，把数量附上
            for (GoodsModel goodsModelEach : goodsList) {
                String approveStatus = goodsModelEach.getApproveStatus();//审核状态
                Integer count = goodsModelEach.getEachCount();//数量
                if (Contants.GOODS_APPROVE_STATUS_00.equals(approveStatus)) {//未提交审核
                    unSubmitCount+=count;//未提交审核数量（供应商平台）
                    goodsDetailDto.setUnSubmitCount(count);//未提交审核数量（供应商平台）
                } else if (Contants.GOODS_APPROVE_STATUS_01.equals(approveStatus)) { //待初审
                    goodsDetailDto.setWaitFirstCount(count);// 礼品初审数量
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_02.equals(approveStatus)) { //待复审
                    goodsDetailDto.setWaitSecondCount(count);// 礼品复审数量
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_03.equals(approveStatus) || Contants.GOODS_APPROVE_STATUS_04.equals(approveStatus)) { //信息变更审核
                    changeCount += count;
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_05.equals(approveStatus)) { ///礼品下架审核
                    goodsDetailDto.setShelfApproveCount(count);//礼品下架审核
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_07.equals(approveStatus)) { //待定价
                    goodsDetailDto.setWaitForPriceCount(count); //定价数量
                    waitCount += count;
                } else if (Contants.GOODS_APPROVE_STATUS_08.equals(approveStatus)) { //定价审核
                    goodsDetailDto.setPriceAudit(count);//定价审核数量
                    waitCount += count;
                } else if(Contants.GOODS_APPROVE_STATUS_70.equals(approveStatus) || Contants.GOODS_APPROVE_STATUS_71.equals(approveStatus)){
                    unSubmitCount+=count;//未提交审核数量（供应商平台）
                    unPassCount += count;
                }else if (Contants.GOODS_APPROVE_STATUS_72.equals(approveStatus) || Contants.GOODS_APPROVE_STATUS_73.equals(approveStatus)
                        || Contants.GOODS_APPROVE_STATUS_74.equals(approveStatus) || Contants.GOODS_APPROVE_STATUS_75.equals(approveStatus)) {
                    unPassCount += count;
                }
            }
            Integer saleCount = goodsDao.findUpShelfGoodsCount(shelfMap);//上架的礼品数量即为出售中的礼品数量
            Integer waitUpCount = goodsDao.findDownShelfGoodsCount(shelfMap); //下架的礼品数量即为待上架的礼品数量
            goodsDetailDto.setChangeCount(changeCount);//变更审核数量
            goodsDetailDto.setUnPassCount(unPassCount);//未通过审核数量（供应商平台首页）
            goodsDetailDto.setWaitCount(waitCount);//待审核礼品数量（供应商平台首页）
            goodsDetailDto.setSaleCount(saleCount);//出售中的礼品数量（供应商平台首页）
            goodsDetailDto.setWaitUpCount(waitUpCount);//待上架礼品数量
            goodsDetailDto.setUnSubmitCount(unSubmitCount);//未提交审核数量
            response.setResult(goodsDetailDto);
            // 返回
            return response;
        } catch (Exception e) {
            log.error("get.goods.status.error", Throwables.getStackTraceAsString(e));
            response.setError("get.favorite.top.error");
            return response;
        }
    }
}
