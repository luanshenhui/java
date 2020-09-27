package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.ItemDto;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.model.ItemModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;
import java.util.Map;

/**
 * Created by 11140721050130 on 16-2-26.
 */
public interface ItemService {

	/**
	 * 添加
	 * 
	 * @param item
	 * @return
	 */
	public Response<Long> create(ItemModel item);

	/**
	 * 删除
	 * 
	 * @param item
	 * @return
	 */
	public Response<Boolean> delete(ItemModel item);

	/**
	 * 更新
	 * 
	 * @param item
	 * @return
	 */
	public Response<Boolean> update(final ItemModel item);

	/**
	 * 查找
	 * 
	 * @return
	 */
	public Response<Pager<ItemModel>> find(@Param("pageNo") Integer pageNo);

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
	 * 根据商品、单品编码或商品名称查询单品列表
	 * 
	 * @param searchKey
	 * @return
	 */
	public Response<List<ItemDto>> findItemListByCodeOrName(String searchKey);

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

    /**
     * 品牌楼层展示
     *
     * @param id1s id2s id3s
     * @return
     */
    public Response<Map<String, Object>> findByIdList(@Param("id1s") List<String> id1s,@Param("id2s") List<String> id2s,@Param("id3s") List<String> id3s);

    /**
     * 品牌管接口
     *
     * @param id1s id2s
     * @return
     */
    public Response<Map<String, Object>> findGoodsAndBrands(@Param("id1s") List<String> id1s,@Param("id2s") List<Long> id2s);

	/**
	 * 根据itemCode查询单品相关信息  niufw
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
	 * 查询置顶商品显示顺序
	 * 
	 * @return
	 * @return add by liuhan
	 */
	public Response<Integer> findAllstickOrder();

	/**
	 * 新增置顶
	 * 
	 * @param itemModel
	 * @return add by liuhan
	 */
	public Response<Boolean> updateadd(ItemModel itemModel);

	/**
	 * 修改置顶
	 * 
	 * @param itemModel
	 * @return add by liuhan
	 */
	public Response<Boolean> updateEdit(ItemModel itemModel);

	/**
	 * 删除置顶
	 * 
	 * @param itemModel
	 * @return add by liuhan
	 */
	public Response<Boolean> updateDel(ItemModel itemModel);

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
	 * 微信商品顺序check
	 * 
	 * @param order
	 * @return
	 * @author TanLiang
	 * @time 2016-6-15
	 */
	public Long wxOrderCheck(Long order);

	/**
	 * 测试取得商品列表
	 *
	 * @return
	 */
	public Response<List<ItemModel>> getItemListTest();
}
