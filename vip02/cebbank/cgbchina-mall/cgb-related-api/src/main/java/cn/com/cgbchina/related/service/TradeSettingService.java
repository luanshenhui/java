package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dto.MessageSettingDto;
import com.spirit.common.model.Response;

/**
 * Created by 11150721040343 on 16-4-26.
 */
public interface TradeSettingService {
	/**
	 * 更新开关状态
	 * 
	 * @param messageSettingDto
	 * @return
	 */
	Response<Boolean> update(MessageSettingDto messageSettingDto);
}
