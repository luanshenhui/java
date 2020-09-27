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
		// 实例化返回Response
		Response<GoodsDetailDto> response = new Response<GoodsDetailDto>();
		// 实例化商品检索的条件
		Map<String, Object> paramMap = Maps.newHashMap();
		Map<String, Object> upMap = Maps.newHashMap();
		Map<String, Object> downMap = Maps.newHashMap();
		// 实例化商品mode
		List<GoodsModel> goodsList = new ArrayList<GoodsModel>();
		try {
			if (user != null) {
				// 把商品检索的条件写上
				paramMap.put("vendorId", user.getVendorId());
				upMap.put("vendorId", user.getVendorId());
				downMap.put("vendorId", user.getVendorId());
			}
			paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
			upMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
			downMap.put("ordertypeId", Contants.BUSINESS_TYPE_YG);
			// 查询所有状态的商品goodsList
			goodsList = goodsDao.findGoodsCount(paramMap);
			// 查询上架商品数量
			Integer upCount = goodsDao.findUpShelfGoodsCount(upMap);
			Integer downCount = goodsDao.findDownShelfGoodsCount(downMap);
			GoodsDetailDto goodsDetailDto = new GoodsDetailDto();
			// 设置默认的数量都是0
			// 未提交审核的商品数
			goodsDetailDto.setUnSubmitCount(0);
			// 待初审核的商品
			goodsDetailDto.setWaitFirstCount(0);
			// 待复审核的商品
			goodsDetailDto.setWaitSecondCount(0);
			// 出售中的商品
			goodsDetailDto.setSaleCount(0);
			// 05待上架数
			goodsDetailDto.setWaitUpCount(0);
			// 下架的商品
			goodsDetailDto.setDeadCount(0);
			goodsDetailDto.setPriceCount(0);
			goodsDetailDto.setChangeCount(0);
			Integer waitCount = 0;
			Integer rejectCount = 0;
			// 循环list判断属于那种，把数量附上
			for (GoodsModel goodsModelEach : goodsList) {
				if (Contants.GOODS_APPROVE_STATUS_00.equals(goodsModelEach.getApproveStatus())) {
					// 判断商品状态商品审核状态 00编辑中时
					goodsDetailDto.setUnSubmitCount(goodsModelEach.getEachCount());// 未提交数
				} else if (Contants.GOODS_APPROVE_STATUS_01.equals(goodsModelEach.getApproveStatus())) {
					// 判断商品状态商品审核状态 01待初审
					goodsDetailDto.setWaitFirstCount(goodsModelEach.getEachCount());// 待初审数
					waitCount += goodsModelEach.getEachCount();//待初审
				} else if (Contants.GOODS_APPROVE_STATUS_02.equals(goodsModelEach.getApproveStatus())) {
					// 判断商品状态商品审核状态 02待复审
					goodsDetailDto.setWaitSecondCount(goodsModelEach.getEachCount());// 待复审数
					waitCount+= goodsModelEach.getEachCount();//待复审
				} else if(Contants.GOODS_APPROVE_STATUS_03.equals(goodsModelEach.getApproveStatus())){
					waitCount+= goodsModelEach.getEachCount();//商品变更审核
				} else if(Contants.GOODS_APPROVE_STATUS_04.equals(goodsModelEach.getApproveStatus())){
					goodsDetailDto.setPriceCount(goodsModelEach.getEachCount());// 价格变更审核数量
					waitCount+=goodsModelEach.getEachCount();//04价格变更审核
				} else if(Contants.GOODS_APPROVE_STATUS_05.equals(goodsModelEach.getApproveStatus())){
					waitCount+= goodsModelEach.getEachCount();//05下架申请审核
					goodsDetailDto.setShelfApproveCount(goodsModelEach.getEachCount());//下架申请审核数量
				} else if (Contants.GOODS_APPROVE_STATUS_70.equals(goodsModelEach.getApproveStatus())
						||Contants.GOODS_APPROVE_STATUS_71.equals(goodsModelEach.getApproveStatus())
						||Contants.GOODS_APPROVE_STATUS_72.equals(goodsModelEach.getApproveStatus())
						||Contants.GOODS_APPROVE_STATUS_73.equals(goodsModelEach.getApproveStatus())
						||Contants.GOODS_APPROVE_STATUS_74.equals(goodsModelEach.getApproveStatus())) {
					// 初审拒绝||复审拒绝||商品变更审核拒绝||价格变更审核拒绝||74下架申请审核拒绝
                    rejectCount += goodsModelEach.getEachCount();
				}
			}
			// 未通过审核商品=70初审拒绝+ 71复审拒绝 +72商品变更审核拒绝+ 73 价格变更审核拒绝+ 74下架申请审核拒绝
			goodsDetailDto.setUnPassCount(rejectCount);

			// 待审核商品 = 01待初审+02待复审+03商品变更审核+04价格变更审核 +05下架申请审核
			goodsDetailDto.setWaitCount(waitCount);
			goodsDetailDto.setChangeCount(goodsDetailDto.getUnPassCount() + goodsDetailDto.getPriceCount());
			goodsDetailDto.setSaleCount(upCount);// 上架数量
			goodsDetailDto.setDeadCount(downCount);// 下架数量

			//查询待上架商品数量--内管首页用
			paramMap.put("type",5);//传递参数type=5，和商品管理页面一致
			Long waitUpCount = goodsDao.findGoodsCountByParams(paramMap);
			goodsDetailDto.setWaitUpCount(waitUpCount.intValue());

			// 扔给response
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
