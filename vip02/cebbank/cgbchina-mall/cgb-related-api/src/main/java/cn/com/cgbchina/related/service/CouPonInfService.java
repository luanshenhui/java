package cn.com.cgbchina.related.service;

import java.util.List;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.related.model.CouponInfModel;

/**
 * @author wusy
 * @version 1.0
 * @Since 16-6-21.
 */

public interface CouPonInfService {

	/**
	 * 获取首次登录优惠卷信息
	 *
	 * @return
	 */
	public Response<CouponInfModel> findByFirstLogin();

	/**
	 * 我的优惠券，详细
	 *
	 * @param projectNO
	 * @return
	 */
	public Response<List<String>> detailedCoupon(Integer projectNO);

	/**
	 * 分页查询
	 *
	 * @param pageNo 页码
	 * @param size 条数
	 * @return 结果对象
	 */
	public Response<Pager<CouponInfModel>> findByPage(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("couponId") String couponId, @Param("couponNm") String couponNm);

	/**
	 * 根据ID查询
	 *
	 *
	 *
	 * @param id
	 * @return
	 */
	public Response<CouponInfModel> findById(@Param("id") String id);

	/**
	 * 根据couponId查询
	 *
	 *
	 *
	 * @param couponId
	 * @return
	 */
	public Response<CouponInfModel> findByCouponId(@Param("couponId") String couponId);

	/**
	 * 添加优惠券设置
	 *
	 * @param couponInfModel
	 * @return
	 */
	public Response<Boolean> update(CouponInfModel couponInfModel);

	/**
	 * 获取外部接口优惠券数据插入到本地数据库
	 *
	 * @param couponInfModel
	 * @return
	 */
	public Response<Boolean> create(CouponInfModel couponInfModel);

	/**
	 * 查询所有的优惠券
	 *
	 * @return
	 */
	public Response<List<CouponInfModel>> findAll();
}
