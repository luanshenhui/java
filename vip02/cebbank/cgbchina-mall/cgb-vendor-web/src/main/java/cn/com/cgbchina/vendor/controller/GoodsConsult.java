package cn.com.cgbchina.vendor.controller;

import cn.com.cgbchina.item.model.GoodsConsultModel;
import cn.com.cgbchina.item.service.GoodsConsultService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/api/vendor/goodsConsult")
@Slf4j
public class GoodsConsult {

	@Autowired
	private GoodsConsultService goodsConsultService;
	@Autowired
	private MessageSources messageSources;

	/**
	 * 更改状态，已显示0，已屏蔽1
	 *
	 * @param idsList
	 * @param isShow
	 * @return
	 */
	@RequestMapping(value = "/{isShow}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response updateIsShowById(@RequestBody List<String> idsList, @PathVariable String isShow) {
		// 获取用户
		User user = UserUtil.getUser();

		// 调用接口
		Response<Boolean> result = goodsConsultService.updateIsShowByIds(idsList, isShow, user.getName());

		if (result.isSuccess()) {
			return result;
		}

		log.error("update.error, {},error code:{}", idsList, isShow, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 回答功能
	 *
	 * @param goodsConsultModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response updateReplyContent(GoodsConsultModel goodsConsultModel) {
		// 获取用户
		User user = UserUtil.getUser();

		// 调用接口
		Response<Boolean> result = goodsConsultService.updateReplyContent(goodsConsultModel, user.getName());

		if (result.isSuccess()) {
			return result;
		}

		log.error("update.error, {},error code:{}", goodsConsultModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
