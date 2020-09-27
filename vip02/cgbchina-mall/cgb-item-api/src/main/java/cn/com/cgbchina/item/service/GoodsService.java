package cn.com.cgbchina.item.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.search.Pair;
import com.spirit.user.User;

/*
 * Created by 陈乐 on 16-4-14.
*/

public interface GoodsService {

    /**
     * 商品展示列表（内管）
     * @param pageNo
     * @param size
     * @param channel
     * @param params
     * @return
     */
    public Response<Map<String,Object>> findGoodList(@Param("pageNo") Integer pageNo,
                                                      @Param("size") Integer size,
                                                      @Param("channel") String channel,
                                                      @Param("user") User user, // 供应商 取vendorId
                                                      @Param("params") Map<String, String> params);



    /**
     * 商品查看----新
     * @param type
     * @param goodsCode
     * @return
     */


    public  Response<GoodFullDto> findDetail_new(@Param("type") String type, @Param("goodsCode") String goodsCode);



    /**
     * 新增商品 --- 新方法
     *
     * @param goodsModel 商品信息
     * @param itemList   单品list
     * @return
     */
    public Response<Boolean> createGoods(GoodsModel goodsModel, List<ItemModel> itemList, String vendorNo,String channel);


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
    public Response<Integer> updateGoodsShelf(GoodsModel goodsModel,String channel,String state);

    /**
     * 更新商品表
     *
     * @param goodsModel
     * @return
     */
    public Response<Boolean> updataGdInfo(GoodsModel goodsModel);

    /**
     * 根据供应商ID下架该供应商下所有渠道的所有商品
     *
     * @param vendorId
     * @return
     */
    public Response<Boolean> updateChannelByVendorId(String vendorId,String businessTypeId);


    /**
     * 根据商品编码List查询商品list
     *
     * @param goodsCodes
     * @return
     */
    public Response<List<GoodsModel>> findByCodes(List<String> goodsCodes);

    /**
     * 商品审核
     * @param user
     * @return
     */
    public Response<Boolean> examGoods(GoodsBatchDto goodsBatchDto,User user);

    /**
     * 批量更新商品状态
     *
     * @param goodsBatchDtoList
     * @return
     */
   // public Response<Integer> updateAllGoodsStatus(List<GoodsBatchDto> goodsBatchDtoList);

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
	 * 根据商品编码查询商品情报 最新
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<GoodsModel> findById(String goodsCode);
	/**
	 * 根据商品编码查询商品情报 缓存
	 *
	 * @param goodsCode
	 * @return
	 */
	public Response<GoodsModel> findCacheById(String goodsCode);

    /**
     * 根据类目，商品名称查询产品信息
     *
     * @param backgoryId 类目
     * @return List
     */
    public Response<List<ItemDto>> findbyGoodsNameLike(String backgoryId, Map<String, Object> queryParams);

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

    /**
     * 根据商品编码List查询礼品list
     *
     * @param goodsCodes
     * @return
     */
    public Response<List<GoodsModel>> findGiftByCodes(List<String> goodsCodes);

    public void updateGoodsJF(String goodsId, Long num);

    public void updateGoodsYG(String goodsId, Long num);

    /**
     * 回滚积分池
     *
     * @param usedPoint
     * @param createDate
     */
    public void dealPointPoolForDate(Long usedPoint, Date createDate);

    /**
     * 返回单品信息
     *
     * @param goodsId
     * @return
     */
    public ItemModel findItemInfoById(String goodsId);

    /**
     * 根据单品编码（goodsId）查询单品信息 niufw
     *
     * @param goodsId
     * @return
     */
    public Response<ItemModel> findInfoById(String goodsId);

	/**
	 * 更新实际库存
	 *
	 * @param goodsId
	 * @return
	 */
	public Response<Integer> updateStock(String goodsId);

    public Response<Boolean> submitGoodsToApprove(GoodsDetailDto goodsDetailDto, User user);

	/**
	 * 查询商品信息
	 *
	 * @param mid
	 * @return
	 */
	public Response<GoodsDetailDto> findGoodsInfoByMid(String mid);
    /**
     * 查询商品信息
     *
     * @param code
     * @return
     */
    public Response<GoodsModel> findGoodsInfo(String code);


    /**
     * 根据供应商id查询该供应商下的商品
     *
     * @param vendorId
     * @return
     */
    public Response<Integer> findGoodsCountByVendorId(String vendorId,String businessTypeId);

    /**
     * 根据单品id获得商品信息
     */
    public Response<GoodsModel> findGoodsModelByItemCode(String itemCode);

    /**
     * 查询积分类型
     */
    public Response<TblCfgIntegraltypeModel> findPointsNameByType(String PointsType);

    /**
     * 查找商品的全部信息,包括商品,图片,sku,属性等
     *
     * @param goodsCode 商品id
     * @return 商品的全部信息和模版商品信息
     */
    Response<Map<String, Object>> findWithDetailsById(@Param("goodsCode") String goodsCode,@Param("channel") String channel,@Param("spuId") Long spuId);

    /**
     * 商品更新操作
     * @param goodsModel
     * @param itemList
     * @return
     */
    Response<Boolean> update(GoodsModel goodsModel, List<ItemModel> itemList);

    /**
     * 根据商品Id ,查询商品所属的后台类目（一级，二级，三级，四级....或者更多，依据产品Id进行查询）
     * @param goodsCode 商品ID
     * @return 类目信息
     */
    public Response<List<Pair>> findCategoryByGoodsCode(String goodsCode);

    /**
     * 根据产品编码查询该产品下商品的数量
     * @param spuId
     * @return
     */
    public Response<Long>  findGoodsBySpu(Long spuId);


    /**
     * 更新商品and单品信息
     * 不带null条件判断
     * @param goodsModel
     * @param itemList
     * @return
     */
    Response<Boolean> updateWithoutNull(GoodsModel goodsModel, List<ItemModel> itemList,String channel,User user);
    /**
     * 根据类目以及 名称的模糊查询
     * @param backCategoryId
     * @param goodsName
     * @return
     */
    Response<List<GoodsDecorationDto>> findDecorationGoods(String backCategoryId, String goodsName);

    /**
     * 根据商品codes查询商品信息
     * @param goodsCodes
     * @return
     */
    public Response<Map<String , Map<String,String>>> findGoodsMap(List<String> goodsCodes);

    /**
     * 新增商品 --- 新方法
     *
     * @param goodsModel 商品信息
     * @param itemList   单品list
     * @return
     */
    public Response<GiftsImportDto> createGoodsImport(GoodsModel goodsModel, List<GiftsImportDto.GiftItemDto> itemList, String vendorNo, String channel);


}
