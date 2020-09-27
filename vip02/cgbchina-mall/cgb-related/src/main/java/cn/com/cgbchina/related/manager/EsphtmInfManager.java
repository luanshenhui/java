package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.EsphtmInfDao;
import cn.com.cgbchina.related.model.EsphtmInfModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * 静态页面上传 manager Created by zhoupeng on 2016/9/23.
 */
@Component
@Transactional
public class EsphtmInfManager {

	@Resource
	private EsphtmInfDao esphtmInfDao;

	/**
	 * 更新
	 * 
	 * @param esphtmInf 更新对像
	 * @return Integer
	 */
	public Integer update(EsphtmInfModel esphtmInf) {
		return esphtmInfDao.update(esphtmInf);
	}

	/**
	 * 新增
	 * 
	 * @param esphtmInf 新增对象
	 * @return Integer
	 */
	public Integer create(EsphtmInfModel esphtmInf) {
		return esphtmInfDao.insert(esphtmInf);
	}

	/**
	 * 更新供应商 id
	 * 
	 * @param esphtmInfModel 更新对像
	 * @return Integer
	 */
	public Integer updateVendorId(EsphtmInfModel esphtmInfModel) {
		return esphtmInfDao.updateVendorId(esphtmInfModel);
	}

	/**
	 * 删除
	 * @param actId 主键ID
	 * @return Boolean
     */
	public Boolean delByActId(String actId){
		return esphtmInfDao.delete(actId) == 1;
	}
}
