package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.related.model.AuctionQuestionInfModel;
import cn.com.cgbchina.related.service.AuctionQuestionInfService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 外网链接白名单
 *
 */
@Slf4j
@Controller
@RequestMapping("/api/admin/whiteList")
public class AuctionQuestionInf {

	@Autowired
	private MessageSources messageSources;
	@Autowired
	private AuctionQuestionInfService auctionQuestionInfService;

	/**
	 * 新增白名单
	 * 
	 * @param auctionQuestionInfModel
	 * @return
	 */
	@RequestMapping(value = "/insertAqInf", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response insertAqInf(AuctionQuestionInfModel auctionQuestionInfModel) {

		User user = UserUtil.getUser();

		if (auctionQuestionInfModel.getType() == 1) {
			auctionQuestionInfModel.setName("规则");
		} else if (auctionQuestionInfModel.getType() == 2) {
			auctionQuestionInfModel.setName("答疑");
		} else if (auctionQuestionInfModel.getType() == 3) {
			auctionQuestionInfModel.setName("链接");
		}

		auctionQuestionInfModel.setCreateOper(user.getName());
		auctionQuestionInfModel.setModifyOper(user.getName());

		// 调用接口
		Response<Integer> result = auctionQuestionInfService.insertAuctionQuestion(auctionQuestionInfModel);

		if (result.isSuccess()) {
			return result;
		}

		log.error("insert.error, {},error code:{}", auctionQuestionInfModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 *
	 * @param auctionQuestionInfModel
	 * @return
	 */
	@RequestMapping(value = "/updateAqInf", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response updateAqInf(AuctionQuestionInfModel auctionQuestionInfModel) {

		User user = UserUtil.getUser();

		if (auctionQuestionInfModel.getType() == 3) {
			auctionQuestionInfModel.setName("链接");
		} else if (auctionQuestionInfModel.getType() == 2) {
			auctionQuestionInfModel.setName("答疑");
		} else if (auctionQuestionInfModel.getType() == 1) {
			auctionQuestionInfModel.setName("规则");
		}

		auctionQuestionInfModel.setModifyOper(user.getName());

		// 调用接口
		Response<Integer> result = auctionQuestionInfService.updateAuctionQuestion(auctionQuestionInfModel);

		if (result.isSuccess()) {
			return result;
		}

		log.error("insert.error, {},error code:{}", auctionQuestionInfModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> deleteAqInf(@PathVariable Long id) {
		Response<Integer> response = new Response<Integer>();
		if (id == null) {
			response.setError("delete.id.notNull");
			return response;
		}
		Response<Integer> result = auctionQuestionInfService.deleteAuctionQuestion(id);
		if (result.isSuccess()) {
			response.setResult(result.getResult());
			return response;
		}
		log.error("failed to create {},error code:{}", id, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 查询白名单是否存在
	 *
	 * @param linkUrl
	 * @return
	 */
	@RequestMapping(value = "/findLinkUrl", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> findLinkUrl(String linkUrl,Integer type) {
		try {
			String url = linkUrl.substring(0, linkUrl.length() - 1);
			// 查询白名单是否存在
			Response<Boolean> result = auctionQuestionInfService.findLinkUrl(url,type);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}
}
