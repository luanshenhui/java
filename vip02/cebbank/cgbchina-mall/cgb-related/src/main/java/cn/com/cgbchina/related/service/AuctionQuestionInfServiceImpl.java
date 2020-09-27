package cn.com.cgbchina.related.service;

import static com.google.common.base.Preconditions.checkNotNull;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.related.dao.AuctionQuestionInfDao;
import cn.com.cgbchina.related.manager.AuctionQuestionInfManager;
import cn.com.cgbchina.related.model.AuctionQuestionInfModel;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11141021040453 on 16-4-13.
 */
@Slf4j
@Service
public class AuctionQuestionInfServiceImpl implements AuctionQuestionInfService {

	@Resource
	private AuctionQuestionInfDao auctionQuestionInfDao;

	@Resource
	private AuctionQuestionInfManager auctionQuestionInfManager;

	@Override
	public Response<Pager<AuctionQuestionInfModel>> findAll(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("linkUrl") String linkUrl, @Param("type") Integer type,
			@Param("user") User user) {
		Response<Pager<AuctionQuestionInfModel>> response = new Response<Pager<AuctionQuestionInfModel>>();

		PageInfo pageInfo = new PageInfo(pageNo, size);

		Map<String, Object> paramMap = Maps.newHashMap();

		if (type == null) {
			paramMap.put("type", null);
		} else {
			paramMap.put("type", type);
		}

		if (linkUrl == null) {
			paramMap.put("linkUrl", null);
		} else {
			paramMap.put("linkUrl", linkUrl);
		}

		try {
			Pager<AuctionQuestionInfModel> auctionQuestionList = auctionQuestionInfDao.findByPage(paramMap,
					pageInfo.getOffset(), pageInfo.getLimit());

			Pager<AuctionQuestionInfModel> pager = new Pager<AuctionQuestionInfModel>(auctionQuestionList.getTotal(),
					auctionQuestionList.getData());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("tblAuctionQuestionInf.error", Throwables.getStackTraceAsString(e));
			response.setError("tblAuctionQuestionInf.error");
			return response;
		}

	}

	/**
	 * 添加数据
	 * 
	 * @param auctionQuestionModel
	 * @return
	 */
	@Override
	public Response<Integer> insertAuctionQuestion(AuctionQuestionInfModel auctionQuestionModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			// 调用接口
			Integer result = auctionQuestionInfManager.insertAuctionQuestion(auctionQuestionModel);
			if (result <= 0) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert.error", Throwables.getStackTraceAsString(e));
			response.setError("insert.error");
			return response;
		}
	}

	/**
	 * 更新白名单
	 * 
	 * @param auctionQuestion
	 * @return
	 */
	@Override
	public Response<Integer> updateAuctionQuestion(AuctionQuestionInfModel auctionQuestion) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(auctionQuestion, "tblAuctionQuestion is null");
			Integer count = auctionQuestionInfManager.updateAuctionQuestion(auctionQuestion);

			if (count <= 0) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(count);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.tblAuctionQuestion.error", Throwables.getStackTraceAsString(e));
			response.setError("update.tblAuctionQuestion.error");
		}
		return response;
	}

	/**
	 * 删除白名单
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Integer> deleteAuctionQuestion(Long id) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = auctionQuestionInfManager.deleteAuctionQuestion(id);
			if (count <= 0) {
				response.setError("insert.error");
				return response;
			}
			response.setResult(count);
		} catch (Exception e) {
			log.error("fail to delete {} ,cause:{}", id, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
		}
		return response;
	}

	/**
	 * 查询白名单是否存在
	 *
	 * @param linkUrl
	 * @return
	 */
	@Override
	public Response<Boolean> findLinkUrl(String linkUrl) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Integer count = auctionQuestionInfManager.findLinkUrl(linkUrl);
			if (count > 0) {
				response.setResult(Boolean.FALSE);
			} else {
				response.setResult(Boolean.TRUE);
			}
		} catch (Exception e) {
			log.error("fail to delete {} ,cause:{}", linkUrl, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
		}
		return response;
	}
}