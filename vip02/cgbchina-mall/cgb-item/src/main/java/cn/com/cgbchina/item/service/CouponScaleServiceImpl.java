package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.CouponScaleDao;
import cn.com.cgbchina.item.dto.CouponScaleDto;
import cn.com.cgbchina.item.manager.CouponScaleManager;
import cn.com.cgbchina.item.model.CouponScaleModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by niufw on 16-4-7.
 */
@Service
@Slf4j
public class CouponScaleServiceImpl implements CouponScaleService {
	@Resource
	private CouponScaleDao couponScaleDao;
	@Resource
	private CouponScaleManager couponScaleManager;

	/**
	 * 积分优惠折扣比例设置查询
	 *
	 * @return
	 */
	@Override
	public Response<CouponScaleDto> findAll() {
		Response<CouponScaleDto> response = new Response<CouponScaleDto>();
		CouponScaleDto couponScaleDto = new CouponScaleDto();
		try {
			List<CouponScaleModel> couponScaleModels = couponScaleDao.findValidAll();
			for (CouponScaleModel couponScaleModel : couponScaleModels) {
				String type = couponScaleModel.getType();
				BigDecimal scale = couponScaleModel.getScale();
				if (Contants.COUPON_SCALE_0.equals(type)) {
					BigDecimal commonCard = scale;
					couponScaleDto.setCommonCard(commonCard);
				} else if (Contants.COUPON_SCALE_1.equals(type)) {
					BigDecimal platinumCard = scale;
					couponScaleDto.setPlatinumCard(platinumCard);
				} else if (Contants.COUPON_SCALE_2.equals(type)) {
					BigDecimal topCard = scale;
					couponScaleDto.setTopCard(topCard);
				} else if (Contants.COUPON_SCALE_3.equals(type)) {
					BigDecimal VIP = scale;
					couponScaleDto.setVIP(VIP);
				} else if (Contants.COUPON_SCALE_4.equals(type)) {
					BigDecimal birthday = scale;
					couponScaleDto.setBirthday(birthday);
				}
			}
			response.setResult(couponScaleDto);
			return response;
		} catch (Exception e) {
			log.error("couponScale.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("CouponScale.time.query.error");
			return response;
		}
	}

	/**
	 * 积分优惠折扣比例设置
	 *
	 * @param couponScaleDto
	 * @return
	 */
	@Override
	public Response<Boolean> update(CouponScaleDto couponScaleDto) {
		Response<Boolean> response = new Response<Boolean>();
		// 获取修改问信息
		// String modifyOper = couponScaleDto.getModifyOper();
		// 将dto拆分成数组
		BigDecimal[] couponScaleDtoArray = new BigDecimal[5];
		if (couponScaleDto != null) {
			couponScaleDtoArray = new BigDecimal[] { couponScaleDto.getCommonCard(), couponScaleDto.getPlatinumCard(),
					couponScaleDto.getTopCard(), couponScaleDto.getVIP(), couponScaleDto.getBirthday() };
		}

		try {
			// 校验
			if (couponScaleDto == null) {
				response.setError("update.couponScale.error");
				return response;
			}
			// for循环实现更新
			List<CouponScaleModel> couponScaleModels = Lists.newArrayList();
			CouponScaleModel couponScaleModel = null;
			for (int i = 0; i < couponScaleDtoArray.length; i++) {
				couponScaleModel = new CouponScaleModel();
				couponScaleModel.setType(Integer.toString(i));
				couponScaleModel.setScale(couponScaleDtoArray[i]);
				couponScaleModel.setModifyOper(couponScaleDto.getModifyOper());
				couponScaleModels.add(couponScaleModel);
			}
			Boolean result = couponScaleManager.update(couponScaleModels);
			if (!result) {
				response.setError("update.couponScale.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.couponScale.error", Throwables.getStackTraceAsString(e));
			response.setError("update.couponScale.error");
			return response;
		}
	}

	/**
	 * 获取生日折扣
	 *
	 * @return
	 */
	public String getBirthScale() {
		List<CouponScaleModel> models = couponScaleDao.getBirthScale();
		String vipScale = "0";
		String birthScale = "0";
		String result = null;
		for (CouponScaleModel item : models) {
			if (item.getType().equals(Contants.COUPON_SCALE_3)) {
				vipScale = item.getScale().toString();
			}
			if (item.getType().equals(Contants.COUPON_SCALE_4)) {
				birthScale = item.getScale().toString();
			}
		}
		if (Double.valueOf(birthScale) < Double.valueOf(vipScale)) {
			result = birthScale;
		}

		return result;
	}
}
