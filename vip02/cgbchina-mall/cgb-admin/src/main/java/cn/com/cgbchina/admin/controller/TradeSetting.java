package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.related.dto.MessageSettingDto;
import cn.com.cgbchina.related.service.TradeSettingService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 交易设置开关 Created by 11150721040343 on 16-4-26.
 */
@Controller
@RequestMapping("/api/admin/tradeSetting")
@Slf4j
public class TradeSetting {
	@Autowired
	TradeSettingService tradeSettingService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 更新支付开关
	 * 
	 * @param messageSettingDto
	 * @return
	 */
	@RequestMapping(value = "/switch",method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response saveSetting(MessageSettingDto messageSettingDto) {
		// 校验支付开关是否为空
		checkArgument(StringUtils.isNotBlank(messageSettingDto.getTradeOpen()), "tradeOpen is null");
		User user = UserUtil.getUser();
		// 更新操作
		Response<Boolean> result = tradeSettingService.update(messageSettingDto,user);
		if (result.isSuccess()){
			return result;
		}
		log.error("saveSetting.error, error:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
