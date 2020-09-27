package cn.com.cgbchina.item.service;

import java.util.List;
import java.util.Map;

import cn.com.cgbchina.item.dto.GoodsDetailDto;
import cn.com.cgbchina.item.dto.GoodsFavoriteInfoDto;
import cn.com.cgbchina.item.dto.MemberCountBatchDto;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * Created by 张成 on 16-4-25.
 */
public interface FavoriteService {
	/**
	 * * 查找热门收藏商品
	 * 
	 * @return goods 消息个数
	 */
	public List<GoodsDetailDto> find(Map<String, Object> paramMap);

	/**
	 * 分页查询，收藏列表
	 * 
	 * @param pageNo 页码
	 * @param size 条数
	 * @return 结果对象
	 */
	public Response<Pager<GoodsFavoriteInfoDto>> findByPager(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("user") User user);

	/**
	 * * 加入收藏夹
	 * 
	 * @return goods 消息个数
	 */
	public Response<Map<String, Boolean>> add(@Param("item") String item, @Param("user") User user);

	/**
	 * 
	 * Description : 指定时间段前五十收藏商品
	 * 
	 * @param params
	 * @return
	 */
	public Response<List<MemberCountBatchDto>> findTopGoodsFavorite(Map<String, Object> params);
}
