package cn.com.cgbchina.item.service;

/*
 * Created by liuchang on 16-08-01.
*/

import cn.com.cgbchina.item.dto.GoodsCommendDto;
import cn.com.cgbchina.item.model.GoodsCommendModel;
import com.spirit.common.model.Response;

import java.util.List;

public interface GoodsCommendService {

	/**
	 * 新增推荐商品
	 *
	 * @param model，user
	 * @return
	 */
	public Response<Boolean> createGoodsCommend(GoodsCommendModel model);

	/**
	 * 获取推荐商品
	 *
	 * @param brandId
	 * @return
	 */
	public Response<List<GoodsCommendDto>> findGoodsCommends(String brandId);

	/**
	 * 根据mid取得推荐单品名称
	 *
	 * @param mid
	 * @return
	 */
	public Response<String> findItemNameByMid(String mid);

	/**
	 * 删除推荐商品
	 *
	 * @param id
	 * @return
	 */
	public Response<Boolean> deleteGoodsCommend(Long id);
}
