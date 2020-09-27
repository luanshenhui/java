package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.CouponScaleDto;
import cn.com.cgbchina.item.model.CouponScaleModel;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * Created by niufw on 16-6-6.
 */
public interface CouponScaleService {
	/**
	 * 积分优惠折扣比例设置查询
	 *
	 * @return
	 */
	public Response<CouponScaleDto> findAll();

	/**
	 * 积分优惠折扣比例设置
	 *
	 * @param couponScaleDto
	 * @return
	 */
	public Response<Boolean> update(CouponScaleDto couponScaleDto);

	/**
	 * 获取生日折扣
	 *
	 * @return
	 */
	public String getBirthScale();

}
