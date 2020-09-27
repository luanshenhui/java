package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.item.service.FavoriteService;
import cn.com.cgbchina.user.service.UserFavoriteService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.Map;

/**
 * Created by 11140721050130 on 2016/5/18.
 */
@Controller
@RequestMapping("/api/mall/Favorite")
@Slf4j
public class Favorite {
	@Autowired
	private MessageSources messageSources;
	@Resource
	UserFavoriteService userFavoriteService;
	@Resource
	FavoriteService favoriteService;

	/**
	 * 取消收藏
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/cancelFavorite", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean cancelFavorite(String id) {
		User user = UserUtil.getUser();
		Response<Map<String, Boolean>> result = userFavoriteService.cancelFavorite(id, user);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
		log.error("failed to cancelOrder{},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 加入收藏夹
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/addFavorite", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean addFavorite(String id) {
		User user = UserUtil.getUser();
		Response<Map<String, Boolean>> result = favoriteService.add(id, user);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
		log.error("failed to cancelOrder{},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
