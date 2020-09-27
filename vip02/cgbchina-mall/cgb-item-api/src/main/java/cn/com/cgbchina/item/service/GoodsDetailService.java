package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.CommendRankModel;
import cn.com.cgbchina.item.model.GoodsConsultModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.math.BigDecimal;
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
	public Response<GoodsItemDto>  findDetailByGoodCode(String itemCode, String goodCode);


	/**
	 * 通用统计
	 * */
	public Response<List<CommendRankModel>> findCommendRankAll(CommendRankModel commendRankModel);

	/**
	 * 通用统计热门销售和热门收藏（包含价格信息）
	 */
	//public Response<List<Map<String, Object>>>
	/**
	 * 热门销售和热门收藏
	 * @param orderType JF 积分商城 YG 广发商城
	 * @param num 显示数量（最大不超过10个）
	 * @param rankType 0001 热销销售，0002 热门收藏
	 * @return
	 */
	public Response<List<CommendRankDto>> findCommendRank(@Param("orderType") String orderType, @Param("num") Integer num, @Param("rankType") String rankType);

//	/**
//	 * 获取收藏Top4
//	 *
//	 * @param
//	 * @return
//	 */
//	public Response<List<Map<String, Object>>> findGoodsCollectTop(@Param("orderType") String orderType);

	/**
	 * 获取推荐商品
	 * 
	 * @param goodsCode 商品编码
	 * @param itemCode 单品编码
	 * @return
	 */
	public Response<List<CommendRankDto>> findGoodsRecommend(@Param("goodsCode") String goodsCode,
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
	public Response<BirthdayTipDto> getUserBirth(@Param("certNo") String certNo,List<String> cardNos);


	/**
	 * 校验用户的第三级卡是否符合商品要求 借记卡没有第三级卡产品编码，商品设置设置第三级卡产品编码对借记卡不起作用 借记卡也没有卡等级，积分类型，如果礼品管理设置了该项，对借记卡也不起作用。
	 * @param goodsCode 商品编码
	 * @param user 用户信息
	 * @return
	 *
	 */
	public Response<Boolean> checkThreeCard(String goodsCode, User user);

	/**
	 * 留学生卡附属卡金卡旅行意外险”或者“留学生附属卡普卡旅行意外险”的场合，
	 * 仅限留学生卡主卡可兑换(此限制条件通过礼品的第三级卡产品编号进行控制)。
	 * 然后，判断是否该卡号第7位为数字“2”，若不是则提示“您名下无留学生卡附属卡或附属卡未加挂于网银中。
	 * 若您的附属卡未添于网银中，请添加后再作申请。”。
	 */
	public Response<Boolean> checkStudentAbroadCard(String cardss, User user);
	/**
	 * 根据单品编码取得推荐单品的相关信息
	 *
	 * @param itemCode 单品编码
	 * @return
	 */
	public CommendRankDto findItemInfoByItemCode(String itemCode);

	Response<List<CardScaleDto>> findCardScaleByUserId(@Param("user") User user);

	/**
	 * 单品商品详细
	 * @param itemCode 单品编码
	 * @return
	 */
	public Response<GoodsItemDto> findItemDetail(String itemCode);

	public Map<String,BigDecimal> findUserPoints(Map<String,BigDecimal> scroreMap);
}
