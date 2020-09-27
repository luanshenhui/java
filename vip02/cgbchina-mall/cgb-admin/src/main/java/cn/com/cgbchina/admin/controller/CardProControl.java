package cn.com.cgbchina.admin.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.service.CardProService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 2016/5/18.
 */
@Controller
@RequestMapping("/api/admin/CardPro")
@Slf4j
public class CardProControl {
	@Autowired
	private MessageSources messageSources;
	@Resource
	CardProService cardProService;

	/**
	 * 新增卡类卡板信息
	 *
	 * @param cardPro
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean changeCardPro(CardPro cardPro) {
		User user = UserUtil.getUser();
		Response<Map<String, Boolean>> result = cardProService.changeCardPro(cardPro, user);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
		log.error("failed to addCardPro{},error code:{}", cardPro.getCardproNm(), result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 删除卡类卡板信息
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/deleteCardPro", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean deleteCardPro(String id) {
		Response<Map<String, Boolean>> result = cardProService.delete(id);
		if (result.isSuccess()) {
			if (result.getResult().get("result")) {
				return Boolean.TRUE;
			} else {
				return Boolean.FALSE;
			}
		}
		log.error("failed to addCardPro{},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 根据ID取得卡类卡板信息
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/findCardProById", method = RequestMethod.GET)
	@ResponseBody
	public CardPro findCardProById(String id) {
		Response<CardPro> result = cardProService.findCardProById(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to cancelOrder{},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
