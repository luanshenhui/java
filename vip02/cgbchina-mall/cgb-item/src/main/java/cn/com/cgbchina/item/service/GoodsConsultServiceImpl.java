package cn.com.cgbchina.item.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.item.dao.GoodsBrandDao;
import cn.com.cgbchina.item.dao.GoodsConsultDao;
import cn.com.cgbchina.item.dao.GoodsDao;
import cn.com.cgbchina.item.dao.ItemDao;
import cn.com.cgbchina.item.dto.GoodsConsultDto;
import cn.com.cgbchina.item.manager.ConsultationManger;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by liuhan on 16-4-12.
 */
@Slf4j
@Service
public class GoodsConsultServiceImpl implements GoodsConsultService {

	@Resource
	private GoodsConsultDao goodsConsultDao;

	@Resource
	private GoodsDao goodsDao;

	@Resource
	private VendorService vendorService;

	@Resource
	private ConsultationManger consultationManger;

	@Resource
	private GoodsBrandDao goodsBrandDao;

	@Resource
	private ItemDao itemDao;

	/**
	 * 查询数据
	 *
	 * @param pageNo
	 * @param size
	 * @param isShow
	 * @param goodsName
	 * @return
	 */
	@Override
	public Response<Pager<GoodsConsultDto>> findConsultAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("isShow") Integer isShow, @Param("goodsName") String goodsName, @Param("user") User user) {

		Response<Pager<GoodsConsultDto>> response = new Response<Pager<GoodsConsultDto>>();

		PageInfo pageInfo = new PageInfo(pageNo, size);

		// 把查询条件放到Map
		Map<String, Object> paramMap = Maps.newHashMap();

		// 获取登录的用户
		if (StringUtils.isNotEmpty(user.getCustId())) {
			paramMap.put("memberId", user.getCustId());
		} else if (StringUtils.isNotEmpty(user.getVendorId())) {
			paramMap.put("vendorId", user.getVendorId());
		}

		// 状态
		if (isShow == null || isShow == -1) {
			paramMap.put("isShow", null);
		} else {
			paramMap.put("isShow", isShow);
		}

		try {

			List<String> goodsNameList = null;
			List<GoodsConsultDto> goodsConsultDtoList = new ArrayList<GoodsConsultDto>();

			// 根据商品名称模糊查询，判断是否有这件商品，然后根据查出来的ID，在到consult表查询
			if (StringUtils.isNotEmpty(goodsName)) {
				goodsNameList = goodsDao.findGoodsByGoodsName(goodsName);
				if (goodsNameList.size() == 0) {
					response.setResult(new Pager<GoodsConsultDto>(0L, Collections.<GoodsConsultDto> emptyList()));
					return response;
				} else {
					// 放到map里，当查询条件
					paramMap.put("goodsName", goodsNameList);
				}
			}

			Pager<GoodsConsultModel> goodsConsultList = goodsConsultDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());

			// 循环，把商品名称放到model里
			for (GoodsConsultModel goodsConsultModel : goodsConsultList.getData()) {
				GoodsConsultDto gcDto = new GoodsConsultDto();
				GoodsModel goodsModel = goodsDao.findDetailById(goodsConsultModel.getGoodsCode());
				List<ItemModel> itemList = itemDao.findItemDetailByGoodCode(goodsModel.getCode());
				gcDto.setId(goodsConsultModel.getId()); // ID
				gcDto.setGoodsCode(goodsConsultModel.getGoodsCode()); // 商品ID
				gcDto.setGoodsName(goodsModel.getName()); // 商品名称
				gcDto.setBrandId(goodsConsultModel.getGoodsBrandId()); // 品牌IDs
				gcDto.setVendorId(goodsConsultModel.getVendorId());
				gcDto.setAdviceContent(goodsConsultModel.getAdviceContent()); // 咨询内容
				gcDto.setAdviceDateTime(goodsConsultModel.getAdviceDatetime());// 咨询时间
				gcDto.setReplyContent(goodsConsultModel.getReplyContent());
				gcDto.setReplyDateTime(goodsConsultModel.getReplyDatetime());
				gcDto.setIsShow(goodsConsultModel.getIsShow()); // 咨询状态
				if (itemList.size() > 0) {
					gcDto.setImage1(itemList.get(0).getImage1());
				}

				goodsConsultDtoList.add(gcDto);
			}

			Pager<GoodsConsultDto> pager = new Pager<GoodsConsultDto>(goodsConsultList.getTotal(), goodsConsultDtoList);
			response.setResult(pager);
			return response;

		} catch (Exception e) {
			log.error("goods.consult.query.error", Throwables.getStackTraceAsString(e));
			response.setError("goods.consult.query.error");
			return response;
		}

	}

	/**
	 * 更改状态，已显示0，已屏蔽1
	 *
	 * @param idsList
	 * @param isShow
	 * @param userName
	 * @return
	 */
	@Override
	public Response<Boolean> updateIsShowByIds(List<String> idsList, String isShow, String userName) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 把idsList，isShow放到Map
			Map<String, Object> params = Maps.newHashMap();
			params.put("idsList", idsList);
			params.put("isShow", isShow);
			params.put("modifyOper", userName);
			// 调用接口
			Boolean result = consultationManger.updateIsShowByIds(params);
			if (!result) {
				response.setError("update.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}
	}

	/**
	 * 回复功能
	 *
	 * @param goodsConsultModel
	 * @param userName
	 * @return
	 */
	public Response<Boolean> updateReplyContent(GoodsConsultModel goodsConsultModel, String userName) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 把idsList，isShow放到Map
			Map<String, Object> params = Maps.newHashMap();
			params.put("id", goodsConsultModel.getId());
			params.put("replyContent", goodsConsultModel.getReplyContent());
			params.put("modifyOper", userName);
			// 调用接口
			Boolean result = consultationManger.updateReplyContent(params);
			if (!result) {
				response.setError("update.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}
	}

	/**
	 * 添加咨询
	 *
	 * @param goodsConsultModel
	 * @return
	 */
	public Response<Boolean> insertGoodsConsult(GoodsConsultModel goodsConsultModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 调用接口
			Boolean result = consultationManger.insertGoodsConsult(goodsConsultModel);
			if (!result) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

}