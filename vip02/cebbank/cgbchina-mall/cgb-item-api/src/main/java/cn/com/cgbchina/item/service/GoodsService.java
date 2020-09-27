package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ProductModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.Date;
import java.util.List;

/*
 * Created by 陈乐 on 16-4-14.
*/

public interface GoodsService {

	public Response<Pager<GoodsInfoDto>> findGoodsListByPage(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("type") String type, @Param("goodsCode") String goodsCode,
			@Param("vendorName") String vendorName, @Param("goodsName") String goodsName,
			@Param("brandName") String brandName, @Param("backCategory1") String backCategory1,
			@Param("backCategory2") String backCategory2, @Param("backCategory3") String backCategory3,
			@Param("approveStatus") String approveStatus, @Param("channelMall") String channelMall,
			@Param("channelCc") String channelCc, @Param("channelMallWx") String channelMallWx,
			@Param("channelCreditWx") String channelCreditWx, @Param("channelPhone") String channelPhone,
			@Param("channelApp") String channelApp, @Param("channelSms") String channelSms,
			@Param("installmentNumber") Integer installmentNumber, @Param("User") User user);

	/**
	 * 查找新增商品时所需的基本信息
	 *
	 * @return
	 */
	public Response<GoodsDetailDto> findCreateGoods(@Param("User") User user);

	/**
	 * 查看商品详情
	 *
	 * @param type
	 * @param goodsCode
	 * @return
	 */
	public Response<GoodsDetailDto> findDetailByType(@Param("type") String type, @Param("goodsCode") String goodsCode);

	/**
	 * 新增商品
	 *
	 * @param goodsDetailDto
	 * @return
	 */
	public Response<Boolean> createGoods(GoodsDetailDto goodsDetailDto, User user);

	/**
	 * 更新单品信息
	 *
	 * @param itemModel
	 * @return
	 */
	public Response<Integer> updateItemDetail(ItemModel itemModel);

	/**
	 * 更新商品上下架信息
	 *
	 * @param goodsModel
	 * @return
	 */
	public Response<Integer> updateGoodsShelf(GoodsModel goodsModel);

	/**
	 * 更新商品表
	 *
	 * @param goodsModel
	 * @return
	 */
	public Response<Integer> updataGdInfo(GoodsModel goodsModel);

	/**
	 * 根据供应商ID下架该供应商下所有渠道的所有商品
	 *
	 * @param vendorId
	 * @return
	 */
	public Response<Boolean> updateChannelByVendorId(String vendorId);

	/**
	 * 更新商品和单品信息
	 *
	 * @param goodsDetailDto
	 * @param user
	 * @return
	 */
	public Response<Boolean> updataGoodsDetail(GoodsDetailDto goodsDetailDto, User user);

	/**
	 * 根据商品编码List查询商品list
	 *
	 * @param goodsCodes
	 * @return
	 */
	public Response<List<GoodsModel>> findByCodes(List<String> goodsCodes);

	public Response<Boolean> examGoods(String goodsCode, String approveType, String approveResult, String approveMemo,
			User user);

	/**
	 * 批量更新商品状态
	 *
	 * @param goodsBatchDtoList
	 * @return
	 */
	public Response<Integer> updateAllGoodsStatus(List<GoodsBatchDto> goodsBatchDtoList);

	/**
	 * 申请下架
	 *
	 * @param goodsmodel
	 * @return
	 */
	public Response<Boolean> shelvesApply(GoodsModel goodsmodel);

	/**
	 * 查询全部商品 供特殊积分倍率使用
	 * 
	 * @return
	 */
	public Response<List<GoodsModel>> findAllGoods(String searchKey);

	/**
	 * 根据商品编码查询商品情报
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<GoodsModel> findById(String goodsCode);

	/**
	 * 根据类目，商品名称查询产品信息
	 *
	 * @param goodsmodel
	 * @return
	 */
	public Response<List<ItemDto>> findbyGoodsNameLike(GoodsModel goodsmodel);

	/**
	 * 判断单品是否可以置顶
	 * 
	 * @param goodCode
	 * @return add by liuhan
	 */
	public Response<String> findGoodsByItemCode(String goodCode);

	/**
	 * 根据单品编码取得推荐单品的相关信息
	 *
	 * @param itemCode
	 * @return
	 */
	public Response<RecommendGoodsDto> findItemInfoByItemCode(String itemCode);

	/**
	 * 根据产品id查询商品（产品用）
	 * 
	 * @param productId
	 * @return
	 * @author :tanliang
	 * @time:2016-6-20
	 */
	public Response<List<GoodsModel>> findGoodsByProductId(Long productId);

	/**
	 * 分页查询商品列表
	 *
	 * @param promGoodsParamDto 参数
	 * @return
	 */
	public Response<List<ItemPromDto>> findItemsListForProm(PromGoodsParamDto promGoodsParamDto, User user);

    public void updateGoodsJF(String goodsId, Long num);

	public void updateGoodsYG(String goodsId, Long num);

    /**
     * 回滚积分池
     * @param usedPoint
     * @param createDate
     */
    public void dealPointPoolForDate(Long usedPoint,Date createDate);


	/**
	 * 导入商品数据的insert
	 * @param goodsItemDto
	 * @return
	 */
	public Response<GoodsAndItemCodeDto> importGoodsData(GoodsItemDto goodsItemDto,User user);

	/**
	 * 返回单品信息
	 * @param goodsId
	 * @return
	 */
	public ItemModel findItemInfoById(String goodsId);

	/**
	 * 返回商品信息
	 * @param goodsCode
	 * @return
	 */
	public GoodsModel findGoodsInfoById(String goodsCode);

	/**
	 * 更新实际库存
	 *
	 * @param goodsId
	 * @return
	 */
	public Response<Integer> updateStock(String goodsId);

	public Response<Boolean> submitGoodsToApprove(GoodsDetailDto goodsDetailDto,User user);
}
