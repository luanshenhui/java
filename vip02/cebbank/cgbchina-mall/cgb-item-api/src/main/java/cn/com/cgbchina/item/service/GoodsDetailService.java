package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.model.ItemInfoModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import java.util.List;
import java.util.Map;

/**
 * Created by Cong on 16-4-25.
 *
 */
public interface GoodsDetailService {
	/**
	 * 商品详情页使用
	 *
	 * @param itemCode 单品编码
	 * @param goodCode 商品编码
	 * @return 商品详情数据
	 */
	public Response<Map<String, Object>> findDetailByGoodCode(@Param("itemCode") String itemCode, @Param("goodCode") String goodCode);

	/**
	 * 获取商品单品信息GoodsInfo
	 * 
	 * @param goodsCode 商品编码
	 * @param itemCode 单品编码
	 * @param user 用户信息
	 * @return
	 */
	public Response<GoodsItemDto> findGoodsInfo(@Param("goodsCode") String goodsCode,
			@Param("itemCode") String itemCode);

	/**
	 * 获取商品描述信息（Tab）
	 * 
	 * @param goodsCode 商品编码
	 * @param itemCode 单品编码
	 * @param pageNo 页数
	 * @param size 每页条数
	 * @return
	 */
	public Response<GoodsDescribeDto> findGoodsDescribe(@Param("goodsCode") String goodsCode,
			@Param("itemCode") String itemCode, @Param("pageNo") Integer pageNo, @Param("size") Integer size);

	/**
	 * 获取收藏Top4
	 * 
	 * @param
	 * @return
	 */
	public Response<List<Map<String, Object>>> findGoodsCollectTop();

	/**
	 * 获取推荐商品
	 * 
	 * @param goodsCode 商品编码
	 * @param itemCode 单品编码
	 * @return
	 */
	public Response<List<Map<String, Object>>> findGoodsRecommend(@Param("goodsCode") String goodsCode,
			@Param("itemCode") String itemCode);

	/**
	 * 获取咨询列表
	 * 
	 * @param goodsCode 商品编码
	 * @param pageNo 页数
	 * @param size 每页条数
	 * @return
	 */
	public Pager<GoodsConsultModel> getGoodsConsultList(@Param("goodsCode") String goodsCode,
			@Param("pageNo") Integer pageNo, @Param("size") Integer size);

	/**
	 * 获取库存信息
	 * 
	 * @param itemCode 单品编码
	 * @return
	 */
	public Response<String> getItemStock(@Param("itemCode") String itemCode);

	/**
	 * 获取用户生日折扣
	 * 
	 * @param certNo
	 * @return
	 */
	public Response<BirthdayTipDto> getUserBirth(@Param("certNo") String certNo);

	/**
	 * 校验用户信用卡中是否含有普通积分
	 * @param user 用户信息
	 * @return
	 */
	public Response<Boolean> checkCommonAmount(User user);

	/**
	 * 校验用户的第三级卡是否符合商品要求 借记卡没有第三级卡产品编码，商品设置设置第三级卡产品编码对借记卡不起作用 借记卡也没有卡等级，积分类型，如果礼品管理设置了该项，对借记卡也不起作用。
	 * @param goodsCode 商品编码
	 * @param user 用户信息
	 * @return
	 *
	 */
	public Response<Boolean> checkThreeCard(String goodsCode, User user);
	/**
	 * 根据单品编码取得推荐单品的相关信息
	 *
	 * @param itemCode 单品编码
	 * @return
	 */
	public Map<String, Object> findItemInfoByItemCode(String itemCode);

	Response<List<CardScaleDto>> findCardScaleByUserId(@Param("user") User user);
}
