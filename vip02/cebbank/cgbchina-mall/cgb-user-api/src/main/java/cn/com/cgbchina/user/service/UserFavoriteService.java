package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.model.MemberGoodsFavoriteModel;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import java.util.List;
import java.util.Map;

/**
 * Created by 张成 on 16-4-25.
 */
public interface UserFavoriteService {

	/**
	 * 查找收藏的最多商品TOP10
	 * 
	 * @return List<MemberGoodsFavoriteModel>
	 */
	public List<MemberGoodsFavoriteModel> findTop(Map<String,Object> paramMap);

	/**
	 * 分页查询，收藏列表
	 * 
	 * @param pageInfo
	 * @return 结果对象
	 */
	public Response<Pager<MemberGoodsFavoriteModel>> findByPager(PageInfo pageInfo, User user);

	/**
	 * 取消收藏
	 *
	 * @return 操作结果
	 */
	public Response<Map<String, Boolean>> cancelFavorite(@Param("itemCode") String id, User user);

	/**
	 * 加入收藏夹
	 *
	 * @return 操作结果
	 */
	public Response<Map<String, Boolean>> addFavorite(List<MemberGoodsFavoriteModel> modelList);

	/**
	 * 判断是否已经收藏
	 *
	 * @param itemCode
	 * @param user
	 * @return 是否已经收藏（1:收藏 0:未收藏）
	 */
	public Response<String> checkFavoriteUser(@Param("itemCode") String itemCode, @Param("user") User user);

	/**
	 * 判断是否已经收藏
	 * 
	 * @param itemCode
	 * @param CustId
	 * @return 是否已经收藏（1:收藏 0:未收藏）
	 */
	public Response<String> checkFavorite(@Param("itemCode") String itemCode, @Param("CustId") String CustId);
}
