package cn.com.cgbchina.related.service;

import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.related.model.AuctionQuestionInfModel;

import java.util.List;

/**
 * Created by 11141021040453 on 16-4-13.
 */

public interface AuctionQuestionInfService {

	/**
	 * 查询数据
	 *
	 * @param pageNo
	 * @param size
	 * @return
	 */
	public Response<Pager<AuctionQuestionInfModel>> findAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("linkUrl") String linkUrl, @Param("type") Integer type);

	/**
	 * 添加白名单
	 * 
	 * @param auctionQuestionModel
	 * @return
	 */
	public Response<Integer> insertAuctionQuestion(AuctionQuestionInfModel auctionQuestionModel);

	/**
	 * 更新白名单
	 * 
	 * @param auctionQuestion
	 * @return
	 */
	public Response<Integer> updateAuctionQuestion(AuctionQuestionInfModel auctionQuestion);

	/**
	 * 删除白名单
	 *
	 * @param id
	 * @return
	 */
	public Response<Integer> deleteAuctionQuestion(Long id);

	/**
	 * 查询白名单是否存在
	 *
	 * @param linkUrl
	 * @return
	 */
	public Response<Boolean> findLinkUrl(String linkUrl,Integer type);

	public Response<List<String>> findLinkUrl();

}
