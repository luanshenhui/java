/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.manager;

import cn.com.cgbchina.related.dao.TblBankDao;
import cn.com.cgbchina.related.model.TblBankModel;
import com.google.common.collect.Maps;
import com.spirit.exception.ResponseException;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/8/1
 */
@Component
@Transactional
public class BankManager {
	@Resource
	private TblBankDao tblBankDao;

	/**
	 * 更新分行信息
	 * 
	 * @param tblBankModel
	 * @return
	 */
	public Boolean update(TblBankModel tblBankModel) {
		// 校验分行号是否重复
		Map<String,Object> codeParamMap = Maps.newHashMap();
		codeParamMap.put("code",tblBankModel.getCode());
		codeParamMap.put("id",tblBankModel.getId());
		Integer codeCount = tblBankDao.checkByCodeOrName(codeParamMap);
		if(codeCount != 0){
			throw new ResponseException("bank.code.duplicated.error");
		}

		//校验分行名称是否重复
		codeParamMap.remove("code");
		codeParamMap.put("name",tblBankModel.getName());
		Integer nameCount = tblBankDao.checkByCodeOrName(codeParamMap);
		if(nameCount != 0){
			throw new ResponseException("bank.name.duplicated.error");
		}

		int updateFlag = tblBankDao.update(tblBankModel);
		if (updateFlag != 1) {
			return Boolean.FALSE;
		} else {
			return Boolean.TRUE;
		}
	}

	/**
	 * 创建分行信息
	 * 
	 * @param tblBankModel
	 * @return
	 */
	public Boolean create(TblBankModel tblBankModel) throws Exception{
		// 校验分行号是否重复
		Map<String,Object> codeParamMap = Maps.newHashMap();
		codeParamMap.put("code",tblBankModel.getCode());
		Integer codeCount = tblBankDao.checkByCodeOrName(codeParamMap);
		if(codeCount != 0){
			throw new ResponseException("bank.code.duplicated.error");
		}

		//校验分行名称是否重复
		codeParamMap.remove("code");
		codeParamMap.put("name",tblBankModel.getName());
		Integer nameCount = tblBankDao.checkByCodeOrName(codeParamMap);
		if(nameCount != 0){
			throw new ResponseException("bank.name.duplicated.error");
		}

		//执行插入操作
		Integer insertCount = tblBankDao.insert(tblBankModel);
		if (insertCount != 1) {
			return Boolean.FALSE;
		} else {
			return Boolean.TRUE;
		}
	}

	/**
	 * 批量删除银行信息
	 * 
	 * @param paramMap
	 * @return
	 */
	public Integer deleteBanks(Map<String, Object> paramMap) {
		return tblBankDao.deleteAll(paramMap);
	}
}
