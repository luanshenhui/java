package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.GoodFullDto;
import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.model.ItemModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.security.PublicKey;
import java.util.List;
import java.util.Map;

/**
 * Created by 11140721050130 on 16-2-26.
 */
public interface ItemService {



	/**
	 * 更新
	 * 
	 * @param item
	 * @return
	 */
	public Response<Boolean> update(final ItemModel item);


	/**
	 * 根据查询条件查找单品
	 * 
	 * @param params
	 * @param offset
	 * @param limit
	 * @return
	 */
	public Pager<ItemModel> findByPage(Map<String, Object> params, int offset, int limit);

	/**
	 * 根据编码查找单品
	 *
	 * @param code
	 * @return
	 */
	public ItemModel findById(String code);

	/**
	 * 根据编码查找单品
	 * 
	 * @param code
	 * @return
	 */
	public Response<ItemModel> findInfoById(String code);

	/**
	 * 根据商品、单品编码或商品名称查询单品列表
	 * 
	 * @param searchKey
	 * @return
	 */
	public Response<List<ItemDto>> findItemListByCodeOrName(String searchKey, String orderTypeId);

	/**
	 * 根据商品、单品编码或商品名称查询单品列表
	 *
	 * @param searchKey
	 * @return
	 */
	public Response<List<ItemDto>> findItemListByCodeOrNameForProm(String searchKey);

	/**
	 * 根据单品编码List查询单品list
	 * 
	 * @param itemCodes
	 * @return
	 */
	public Response<List<ItemModel>> findByCodes(List<String> itemCodes);

	/**
	 * 通过商品ID List 查询商品详细信息
	 *
	 * @param ids
	 * @return
	 */
	public Response<List<ItemGoodsDetailDto>> findByIds(@Param("ids") List<String> ids);

	public Response<List<ItemGoodsDetailDto>> findByIdsForDecoration(@Param("ids") List<String> ids);
	/**
	 * 品牌楼层展示
	 *
	 * @param id1s id2s id3s
	 * @return
	 */
	public Response<Map<String, Object>> findByIdList(@Param("id1s") List<String> id1s,
			@Param("id2s") List<String> id2s, @Param("id3s") List<String> id3s);

	/**
	 * 品牌管接口
	 *
	 * @param id1s id2s
	 * @return
	 */
	public Response<Map<String, Object>> findGoodsAndBrands(@Param("id1s") List<String> id1s,
			@Param("id2s") List<Long> id2s);

	/**
	 * 根据itemCode查询单品相关信息 niufw
	 * 
	 * @return
	 */
	public Response<ItemModel> findByItemcode(String itemCode);

	/**
	 * 根据itemCode查询数据
	 * 
	 * @param itemCode
	 * @return add by liuhan
	 */
	public ItemModel findItemDetailByCode(String itemCode);

	/**
	 * 查询置顶商品
	 * 
	 * @return
	 * @return add by liuhan
	 */
	public Response<Pager<ItemDto>> findAllstickFlag(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("code") String code, @Param("itemName") String itemName);



	/**
	 * 置顶 信息更新
	 *
	 * @param itemCode 更新Code
	 * @param user 用户信息
	 * @param operate 操作方式
	 * @param stickOrder 排序值
	 * @return Boolean
	 * edit by zhoupeng
	 */
	public Response<Boolean> updateStickOrder(String itemCode,Integer stickOrder,String operate,User user);



	/**
	 * 根据商品code取得所对应的单品信息
	 *
	 * @param goodsCodeList
	 * @return
	 * @author TanLiang
	 * @time 2016-6-14
	 */
	public Response<List<ItemModel>> findItemListByGoodsCodeList(List<String> goodsCodeList);


	/**
	 *
	 *
	 * @param itemCodes
	 * @return
	 */
	public Response<List<ItemModel>> findByCodesNoOrder(List<String> itemCodes);

	/**
	 * 根据编码、oId、mid 查找单品
	 *
	 * @param code
	 * @param omid(可能是oId也可能是mid 不为空就作为or条件 使用)
	 * @return ItemModel
	 * @author ZJQ @2016-7-8
	 */
	public Response<ItemModel> findByIdAndOidOrMid(String code, String omid);



	/**
	 * 积分商城首页展示
	 *
	 * @param newItemIds hotItemIds
	 * @return
	 */
	public Response<Map<String, Object>> findIntegralItemsByIdList(@Param("newItemIds") List<String> newItemIds,
			@Param("hotItemIds") List<String> hotItemIds);



	/**
	 * 根据单品编码List查询单品list(包含已删除)
	 *
	 * @param itemCodes
	 * @return
	 * @add by yanjie.cao
	 *
	 */
	public Response<List<ItemModel>> findByCodesAll(List<String> itemCodes);

	/**
	 * 根据单品编码查询单品(包含已删除)
	 *
	 * @param itemCode
	 * @return
	 * @add by yanjie.cao
	 *
	 */
	public Response<ItemModel> findByCodeAll(String itemCode);

	/**
	 * 根据品牌ID查询前十条单品数据
	 * 
	 * @param brandId
	 * @return
	 */
	public Response<List<RecommendGoodsDto>> findByBrandId(String brandId);


	/**
	 * 根据itemModel查询RecommendGoodsDto-商城前台展示使用
	 *
	 * @param itemCode
	 * @return
	 */
	public Response<RecommendGoodsDto> finRecommendGoodsByItemModel(String itemCode);

	/**
	 * 更新单品销量
	 * 
	 * @param itemModel
	 * @return
	 */
	public Response<Integer> updateItemTotal(ItemModel itemModel);

	/**
	 * 批量更新库存
	 *
	 * @param map
	 * @param user
	 * @return
	 */
	public Response<Boolean> updateBatchStock(Map<String, Integer> map, User user);


	/**
	 * MAL502 回滚库存 niufw
	 * 
	 * @param code
	 * @param backNum
	 * @return
	 */
	public Response<Boolean> rollbackBacklogByNum(String code, int backNum);

	/**
	 * 接口MAL501
	 *
	 * @param code
	 * @return
	 */
	public Response<ItemModel> findItemByXid(String code);

	/**
	 * MAL115 减库存
	 * 
	 * @param code
	 * @param goodsNum
	 * @return
	 */
	public Response<Integer> subtractStock(String code, long goodsNum);

	public Response<ItemModel> findByMid(String mid);

	/**
	 * 根据单品code查库存
     * add by wenjia.hao
	 * @param itemCode
	 * @return
	 */
	public Response<Long> findStockByItemCode(String itemCode);

	/**
	 * 根据单品codes批量查询库存  只有code和stock,price字段有值 其他没有值  注意
	 * add by wenjia.hao
	 * @param itemCodes
	 * @return
	 */
	public Response<List<ItemModel>> findStocksByItemCodes(List<String> itemCodes);

	/**
	 * 更新库存
	 * @param itemModelMap
	 * @return
	 */
	Response<Boolean> updateStockForOrder(Map<String, Long> itemModelMap);

	/**
	 * 批量更新库存
	 *
	 * @param map
	 * @param user
	 * @return
	 */
	public Response<Boolean> updateRollBackStockForJF(Map<String, Integer> map, User user);

	/**
	 * 根据非空mid或Xid模糊查询单品id
	 * @param midOrXid
	 * @return
	 */
	public Response<List<String>> findItemCodeListByMidOrXid(String midOrXid);
	
	/**
	 * Description : 根据xids 获取单品数据 MAL104
	 * @author xiewl
	 * @param asList
	 * @return
	 */
	public Response<List<ItemGoodsDetailDto>> findByXids(List<String> xids);

	public Response<List<GoodFullDto>> findIntegrateAreaGoods(@Param("itemIds") List<String> itemIds);
	public Response<List<String>> findItemCodesByItemCode(String itemCode);


	public Response<Boolean> updateStock(String actId,String actType, Integer periodId, String goodsId, Integer goodsNum, String createOper, Long bonusTotalvalue, ItemModel itemModel);
}
