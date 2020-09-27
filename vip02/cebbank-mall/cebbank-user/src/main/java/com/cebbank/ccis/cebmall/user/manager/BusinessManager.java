package com.cebbank.ccis.cebmall.user.manager;

import com.cebbank.ccis.cebmall.user.dao.TblParametersDao;
import com.cebbank.ccis.cebmall.user.model.TblParametersModel;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * @author liuhan
 * @version 1.0
 * @Since 16-6-7.
 */
@Component
@Transactional
public class BusinessManager {
	@Resource
	private TblParametersDao tblParametersDao;// 业务启停表

	/**
	 * 修改启动暂停
	 *
	 * @param tblParametersModel
	 * @return
	 */
	public Boolean update(TblParametersModel tblParametersModel) {
		// 修改
		int i = tblParametersDao.updateOpenCloseFlag(tblParametersModel);
		if (i != 1) {
			return Boolean.FALSE;
		} else {
			return Boolean.TRUE;
		}
	}

	/**
	 * 修改业务话术
	 *
	 * @param tblParametersModel
	 * @return
	 */
	public Boolean updatePrompt(TblParametersModel tblParametersModel) {
		// 修改
		int i = tblParametersDao.updatePrompt(tblParametersModel);
		if (i != 1) {
			return Boolean.FALSE;
		} else {
			return Boolean.TRUE;
		}
	}
}
