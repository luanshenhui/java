package cn.com.cgbchina.item.service;

//import com.spirit.Annotation.Param;

import java.util.List;

import cn.com.cgbchina.item.dto.CCJudgeGoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsDetailExtend;
import cn.com.cgbchina.item.dto.GoodsItemDto;
import cn.com.cgbchina.item.dto.SPGoodsDetailDto;
import cn.com.cgbchina.item.dto.XnlpODSDto;
import cn.com.cgbchina.item.model.AppGoodsDetailModel;
import cn.com.cgbchina.item.model.CCIntergalPresentParams;
import cn.com.cgbchina.item.model.GoodsDetaillModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.GoodsPayWayModelExtend;
import cn.com.cgbchina.item.model.IntegrationGiftModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.RestCCIntergalPresentDetail;
import cn.com.cgbchina.item.model.StageMallGoodsDetailStageInfoVO;
import cn.com.cgbchina.item.model.StageMallGoodsParams;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.model.TblGoodsRecommendationYgModel;

import com.spirit.common.model.Response;

/**
 * 接口调用
 */
public interface RestItemService {
	/**
	 * MAL102 CC积分商城礼品详细查询 通过GOODID查找礼品
	 * 
	 * @param itemId
	 * @author :lizeyuan
	 * @time:2016-7-4
	 * @return
	 */
	public Response<RestCCIntergalPresentDetail> findGoodsByItemid(String itemId, String origin);

	/**
	 * Description : 通过第三类目找查相应的商品 (MAL109用)
	 * 
	 * @param backCategory1Id 第1类目ID
	 * @return
	 */
	public Response<List<TblGoodsRecommendationYgModel>> findGoodsByBackCategory1Id4109(Long backCategory1Id);

	/**
	 * MAL118使用 根据积分值查找相应区间，返回区间记录的id，如果没有，返回-1
	 * 
	 * @param bonus 积分值
	 * @return RegionId 区间ID
	 * @author :zjq
	 * @time:2016-7-4
	 */
	public Response<Integer> getRegionFromBonus(long bonus);

	/**
	 * MAL118使用 根据积分区间ID查找积分礼品信息集合
	 * 
	 * @param regionId
	 * @return List<String>
	 * @author :zjq
	 * @time:2016-7-4
	 * */
	public Response<List<IntegrationGiftModel>> getItemGiftListByRegionId(Integer regionId);

	/**
	 * Description : MAL202 IVR排行列表查询 根据商品列表查出对应库存大于0且在上架时间内的商品
	 * 
	 * @param code
	 * @return
	 */
	public Response<List<GoodsItemDto>> findIVRRankGoodsInfoByGoodsCodes(List code);

	/**
	 * MAL117 查询商品详情 by goods_omid(分期编码和一期编码) and itemCode(商品编码、商品mid、商品oid必须并且只能输入一个)
	 * 
	 * @param omid
	 * @param itemCode
	 * @return list
	 * @author ZJQ
	 * @time 2016-7-7
	 * 
	 * */
	public Response<GoodsDetaillModel> getGoodsDetailByItemCodeAndOmid(String omid, String itemCode, String contIdCard);

	Response<List<GoodsPayWayModelExtend>> findGoodsByBackCategory1Id(Long backCategory1Id);

	/**
	 * MAL421 微信易信O2O0元秒杀商品详情查询
	 * 
	 * @param mid
	 * @return
	 * @author huangchaoyong
	 * 
	 */
	public Response<GoodsDetailExtend> findWXYXo2oGoodsDetail(String mid);

	/**
	 * MAL335 特殊商品列表查询
	 * 
	 * @param origin
	 * @param queryType
	 * @param queryCondition
	 * @return
	 * @author huangchaoyong
	 */
	public Response<List<SPGoodsDetailDto>> findSPGoodsDetail(String origin, String queryType, String queryCondition);

	/**
	 * MAL335 根据商品编号查询 特殊商品列表
	 * 
	 * @param origin
	 * @param goodsIds
	 * @return
	 * @author huangchaoyong
	 */
	public Response<List<SPGoodsDetailDto>> findSPGoodsDetailByGoodsIds(String origin, List<String> goodsIds);

	/**
	 * 根据商品编号查询最高分期信息
	 * 
	 * @param goodsId
	 * @return
	 * @author huangchaoyong
	 */
	public Response<StageMallGoodsDetailStageInfoVO> findHighestStageInfoByGoodsId(String goodsId);

	/**
	 * MAL201 CC积分商城预判商品信息
	 * 
	 * @param goodsXid
	 * @return
	 * @author huangchaoyong
	 */
	public Response<CCJudgeGoodsDetailDto> findGoodsInfByXid(String goodsXid);

//	/**
//	 * 查询分区卡板
//	 *
//	 * @param regionType
//	 * @return
//	 * @author huangchaoyong
//	 */
//	public Response<String> findAreaFormatId(String regionType);

	/**
	 * 根据证件和卡号查询ods导入的虚拟礼品数据
	 * 
	 * @param certNo 证件号
	 * @param cardNo 卡号
	 * @param type 虚拟礼品种类
	 * @return
	 * @author huangchaoyong
	 */
	public Response<List<XnlpODSDto>> findXnlpByCertAndCardNo(String certNo, String cardNo, String type);

	/**
	 * Description MAL322: 判断客户卡板和商品卡板是否满足需求
	 * 
	 * @param goodsId
	 * @param cardFormatNbr
	 * @return
	 */
	public Response<Boolean> judgeCardFormatNbr(String goodsId, List<String> cardFormatNbr);

	/**
	 * Description MAL322: 获取客户可使用生日价的次数
	 * 
	 * @param custId
	 * @return
	 */
	public Response<String> findCustBirthTimes(String custId);

	/**
	 * Description : MAL322: 获取最优等级支付方式
	 * 
	 * @param custLevel
	 * @param goodsId
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findPreferencePayway(String custLevel, String goodsId);

	/**
	 * Description : MAL322: 获取生日价支付方式
	 * 
	 * @param goodsId
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findBirthPayway(String goodsId);

	/**
	 * Description : MAL322: 获取积分加现金支付方式
	 * 
	 * @param goodsId
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findJmPayway(String goodsId);

//	/**
//	 * Description : 通用 根据id获取分区信息
//	 *
//	 * @param id
//	 * @return
//	 */
//	public Response<GoodsRegionModel> findGoodsRegionById(String id);

	/**
	 * Description : MAL312 获取支付方式
	 * 
	 * @param stageMallGoodsQuery
	 * @return
	 * @author xiewl
	 */
	public Response<List<TblGoodsPaywayModel>> queryGoodsPayway(StageMallGoodsParams stageMallGoodsQuery);

	/**
	 * Description : MAL312 获取商品信息
	 * 
	 * @param stageMallGoodsParams
	 * @return
	 */
	public Response<List<GoodsModel>> findGood(StageMallGoodsParams stageMallGoodsParams);

	/**
	 * Description : MAL312 获取商品信息
	 * 
	 * @param stageMallGoodsParams
	 * @return
	 */
	public Response<List<ItemModel>> findItems(StageMallGoodsParams stageMallGoodsParams);

	/**
	 * Description : MAL101 分期商城(商品搜索列表)
	 * 
	 * @param params
	 * @return
	 */
	public Response<List<GoodsModel>> findGoodsByCCIntergalPresent(CCIntergalPresentParams params);

	/**
	 * Description : MAL101 根据goodsid 获取payway
	 * 
	 * @param goodsIds
	 * @return
	 */
	public Response<List<TblGoodsPaywayModel>> findPaywayByGoodsId(List<String> goodsIds);

	/**
	 * Description : MAL101 分期商城(商品搜索列表)
	 * 
	 * @param params
	 * @return
	 */
	public Response<List<ItemModel>> findItemsByCCIntergralPresent(CCIntergalPresentParams params);

	/**
	 * Description : MAL101 分期商城(商品搜索列表)
	 * 
	 * @param params
	 * @return
	 */
	public Response<List<TblGoodsPaywayModel>> findPaywaysByCCIntergralPresent(CCIntergalPresentParams params);
	
	/**
	 * Description : MAL313 查询商品详情
	 * 
	 * @param itemCode 商品code
	 * @param origin 发起方
	 * @param contIdcard 证件号码
	 * @param custId 证件号
	 * @param queryType 查询类型
	 * 
	 * @return
	 */
	public Response<AppGoodsDetailModel> findGoodsDetailByApp(String itemCode, String origin, String contIdcard,
			String custId, String queryType, String[] goodsIds);

}
