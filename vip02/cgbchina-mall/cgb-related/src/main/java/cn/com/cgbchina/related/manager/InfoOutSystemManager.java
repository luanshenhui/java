package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.InfoOutSystemDao;
import cn.com.cgbchina.related.model.InfoOutSystemModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 *
 * Created by zhoupeng on 2016/9/23.
 */
@Component
@Transactional
public class InfoOutSystemManager {

	@Resource
	private InfoOutSystemDao infoOutSystemDao;

	/**
	 * 新增
	 * 
	 * @param infoOutsystem 新增对象
	 * @return Integer
	 */
	public Integer insert(InfoOutSystemModel infoOutsystem) {
		return infoOutSystemDao.insert(infoOutsystem);
	}

	/**
	 * 修改
	 * 
	 * @param updateOutSystemModel 修改对象
	 * @return Integer
	 */
	public Integer updateValidateCode(InfoOutSystemModel updateOutSystemModel) {
		return infoOutSystemDao.updateValidateCode(updateOutSystemModel);
	}

	/**
	 * 更新状态
	 * 
	 * @param infoOutModel 更新对象
	 * @return Integer
	 */
	public Integer updateMsgStatus(InfoOutSystemModel infoOutModel) {
		return infoOutSystemDao.updateMsgStatus(infoOutModel);
	}

    /**
     * 更新
     * @param infoOutSystemModel
     * @return Integer
     */
	public Integer updateInfoByOrderId(InfoOutSystemModel infoOutSystemModel) {
		return infoOutSystemDao.updateInfoByOrderId(infoOutSystemModel);
	}

}
