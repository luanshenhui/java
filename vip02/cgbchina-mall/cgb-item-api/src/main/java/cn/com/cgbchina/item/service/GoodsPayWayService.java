package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.MakePriceDto;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.spirit.common.model.Response;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.spirit.common.model.Response;

import cn.com.cgbchina.item.dto.GoodsPaywayDto;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.spirit.user.User;

/**
 * @author
 * @version 1.0
 * @Since 2016/6/6.
 */
public interface GoodsPayWayService {

	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findGoodsPayWayInfo(String goodsPaywayId);

	/**
	 * 通过单品ＩＤ和分期数查询返回支付方式信息
	 *
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findByItemCodeAndStagesCode(Map<String, Object> params);

	/**
	 * 查询商品支付方式表
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<List<GoodsPaywayDto>> findGoodsPayway(String goodsCode);

	public Response<Integer> updatePayWayMemberLevel(List<TblGoodsPaywayModel> tblGoodsPaywayModelList);

	public Response<List<TblGoodsPaywayModel>> findInfoByItemCode(String itemCode);

	/**
	 * 根据单品id返回最大分期数的支付方式
	 */
	public Response<TblGoodsPaywayModel> findMaxGoodsPayway(String itemCode);

	/**
	 * 根据单品编码list查询支付信息
	 * @param itemCodes
	 * @return
	 */
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayByCodes(List<String> itemCodes);

	/**
	 * 通过单品ID和是否待复核查询(分期方式代码降序)
	 * @param itemCode
	 * @return
	 */
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayInfoList(String itemCode);

	/**
	 * 通过单品ID和是否待复核查询(会员等级升序)
	 * @param itemCode
	 * @return
	 */
	public Response<List<TblGoodsPaywayModel>> findGoodsPayWayInfoJFList(String itemCode);

	/***
	 * 通过 goodsPayWayIdList获取ModelList
	 * @param goodsPayWayIdList
     * @return
	 * @add by yanjie.cao
     */
	public Response<List<TblGoodsPaywayModel>> findByGoodsPayWayIdList(List<String> goodsPayWayIdList);

	public Response<List<TblGoodsPaywayModel>> findByGoodsIdAndMemberLevel(Map<String, Object> params);

	/**
	 * 积分定价
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<List<GoodsPaywayDto>> makePrice(String goodsCode, String stockParam, BigDecimal argumentTJ,
													BigDecimal argumentDJ, BigDecimal argumentVIP,
													BigDecimal argumentBirth, BigDecimal argumentPP,
													List<MakePriceDto> makePriceDtos);

	/**
	 * 插入商品支付方式表
	 *
	 * @param tblGoodsPaywayModelList
	 * @return
	 */
	public Response<Integer> createPayWayMemberLevel(List<TblGoodsPaywayModel> tblGoodsPaywayModelList);


	/**
	 * 保存礼品改价
	 *
	 * @param json, user
	 * @return
	 */
	public Response<Boolean> saveChangePriced(String json, User user, String status);

	/**
	 * 查询goods表临时字段内容（改价信息）
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<List<GoodsPaywayDto>> findChangePriceInfo(String goodsCode);

	public Response<List<TblGoodsPaywayModel>> findPaywayByGoodsIds(String goodsId);

	public Response<List<TblGoodsPaywayModel>> findJxpayway(String goodsId,String goodsPaywayId,String isMoney);

	/**
	 * 根据参数查询支付方式
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160818
	 */
	Response<List<TblGoodsPaywayModel>> findGoodsPayWayByParams(Map<String,Object> paramMap);

	Response<TblGoodsPaywayModel> getBirthPayway(String goodsId);

	/**
	 * 返回支付方式信息
	 *
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findGoodsPayWayInfoById(String goodsPaywayId);
}
