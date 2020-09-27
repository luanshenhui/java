package cn.com.cgbchina.promotion.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

import cn.com.cgbchina.promotion.manager.EspActRemindManager;
import cn.com.cgbchina.promotion.model.EspActRemindModel;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class EspActRemindServiceImpl implements EspActRemindService {

	@Resource
	private EspActRemindManager espActRemindManager;

	/**
	 * 添加活动提醒
	 * 
	 * @param espActRemindModel 添加数据
	 * @return 添加结果
	 *
	 *         geshuo 20160721
	 */
	public Response<Integer> insert(EspActRemindModel espActRemindModel) {
		Response<Integer> response = new Response<>();
		try {
			Integer result = espActRemindManager.insert(espActRemindModel);
			response.setResult(result);
		} catch (Exception e) {
			log.error("EspActRemindServiceImpl.insert.error Exception:{}", Throwables.getStackTraceAsString(e));
			response.setError("EspActRemindServiceImpl.insert.error");
		}
		return response;
	}

	/**
	 * 根据参数逻辑删除
	 * 
	 * @param paramMap 删除参数
	 * @return 删除结果
	 *
	 *         geshuo 20160722
	 */
	public Response<Integer> deleteRemindByParams(Map<String, Object> paramMap) {
		Response<Integer> response = new Response<>();
		try {
			Integer result = espActRemindManager.deleteRemindByParams(paramMap);
			response.setResult(result);
		} catch (Exception e) {
			log.error("EspActRemindServiceImpl.deleteRemindByParams.error Exception:{}",
					Throwables.getStackTraceAsString(e));
			response.setError("EspActRemindServiceImpl.deleteRemindByParams.error");
		}
		return response;
	}
	
	
	/**
	 * 查询是否设置过提醒
	 * 设置提醒 true else false
	 * 
	 */
	public Response<Boolean> findIsRemidByGoods (EspActRemindModel espActRemindModel) {
	    Response<Boolean> response = new Response<>();
		try {
			Boolean result = espActRemindManager.findIsRemidByGoods(espActRemindModel);
			response.setResult(result);
		} catch (Exception e) {
			log.error("EspActRemindServiceImpl.findIsRemidByGoods.error Exception:{}",
					Throwables.getStackTraceAsString(e));
			response.setError("EspActRemindServiceImpl.findIsRemidByGoods.error");
		}
		return response;
	}
}
