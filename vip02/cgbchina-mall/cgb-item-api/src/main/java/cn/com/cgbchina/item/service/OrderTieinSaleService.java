package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.OrderTieinSaleItemDto;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import java.util.List;

/**
 * @author yanjie.cao
 * @version 1.0
 * @Since 2016/6/13.
 */
public interface OrderTieinSaleService {

	/**
	 * 搭销时通过单品编码查询单品信息
	 *
	 * @param pageNo
	 * @param size
	 * @param itemCode
	 * @return
	 */

	public Response<Pager<OrderTieinSaleItemDto>> findItemDetail(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("itemCode") String itemCode, @Param("itemName") String itemName,
			@Param("vendorId") String vendorId,List<String> itemCodes);

	/**
	 * 商品支付关系表中获取现金
	 *
	 * @param goodsPaywayId
	 * @return
	 */
	public Response<TblGoodsPaywayModel> findGoodsPrice(String goodsPaywayId);

	/**
	 * 通过单品Id获取对象集合
	 * @param itemCode
	 * @return
	 */
	public Response<List<TblGoodsPaywayModel>> findByItemCode(String itemCode);


}
