package cn.com.cgbchina.related.service;

import java.util.List;

import cn.com.cgbchina.rest.visit.model.coupon.CouponProject;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.item.model.GoodsModel;
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
	public Response<List<String>> detailedCoupon(String projectNO);

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

	/**
	 * 检索商品可以手动领取的优惠卷信息
	 * @param goodsModel 商品信息（DataTable Mapped Entity）
	 * @return CouponInfModel 优惠券信息（DataTable Mapped Entity）
	 */
	public Response<List<CouponInfModel>> findByGoodsInfo(GoodsModel goodsModel);

	/**
	 * 根据ID_Coupons查询
	 * @param ids
	 * @return
	 */
	public Response<List<String>> findCouponsByCoupons(List<String> ids);

	/**
	 * 检索商品可以使用的优惠卷信息
	 * @param goodsModel 商品信息（DataTable Mapped Entity）
	 * @return CouponInfModel 优惠券信息（DataTable Mapped Entity）
	 */
	public Response<List<CouponInfModel>> findByGoodsSpendableInfo(GoodsModel goodsModel);

	/**
	 * 跟新优惠券信息
	 */
	public Response<Boolean> updateById(CouponInfModel couponInfModel);

	/**
	 * 获取优惠券
	 *
	 * @param couponInfModelList 接口获取的优惠券
	 * @param couponInfModels 数据库中原本已经存在的优惠券
	 * @return
	 */
	public Response<Boolean> synchronizeCoupon (List<CouponInfModel> couponInfModelList,List<String> couponInfModels);

	/**
	 * 查询已经存在的优惠券
	 *
	 * @param couponids
	 * @return
	 */
	public Response<List<String>> findCouponsExist(List<String> couponids);

}
