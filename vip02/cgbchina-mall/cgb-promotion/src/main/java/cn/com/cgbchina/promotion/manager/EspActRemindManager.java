package cn.com.cgbchina.promotion.manager;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import cn.com.cgbchina.promotion.dao.EspActRemindDao;
import cn.com.cgbchina.promotion.model.EspActRemindModel;

/**
 * 活动提醒manager
 *
 * geshuo 20160721
 */
@Component
@Transactional
public class EspActRemindManager {
	@Resource
	private EspActRemindDao espActRemindDao;

	/**
	 * 添加活动提醒
	 * 
	 * @param espActRemindModel 添加数据
	 * @return 添加结果
	 *
	 *         geshuo 20160721
	 */
	public Integer insert(EspActRemindModel espActRemindModel) {
		return espActRemindDao.insert(espActRemindModel);
	}

	/**
	 * 根据参数逻辑删除
	 * 
	 * @param paramMap 删除参数
	 * @return 删除结果
	 *
	 *         geshuo 20160722
	 */
	public Integer deleteRemindByParams(Map<String, Object> paramMap) {
		return espActRemindDao.deleteRemindByParams(paramMap);
	}
	
	
	/**
	 * 查询是否设置过提醒
	 * 设置提醒 true else false
	 * 
	 */
	public Boolean findIsRemidByGoods(EspActRemindModel espActRemindModel) {
	    	int isRemid=espActRemindDao.findIsRemidByGoods(espActRemindModel);
	    	if(isRemid>0){
	    	return true;
	    	}
		return false;
	}

}
