/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import cn.com.cgbchina.user.dao.LocalCardRelateDao;
import cn.com.cgbchina.user.manager.LocalCardRelateManager;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.service.CardProService;
import lombok.extern.slf4j.Slf4j;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-13.
 */
@Service
@Slf4j
public class LocalCardRelateServiceImpl implements LocalCardRelateService {
	@Resource
	private LocalCardRelateManager localCardRelateManager;
	@Autowired
	private CardProService cardProService;
	@Resource
	private LocalCardRelateDao localCardRelateDao;

	/**
	 * 绑定关系新增
	 *
	 * @param proCode
	 * @return
	 */
	@Override
	public Response<Boolean> create(String[] array, String proCode) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			LocalCardRelateModel localCardRelateModel = new LocalCardRelateModel();
			CardPro cardPro = new CardPro();
			// 循环取出
			Boolean result = false;
			for (String formatId : array) {
				if (Strings.isNullOrEmpty(formatId)) {
					continue;
				}
				localCardRelateModel.setProCode(proCode);
				localCardRelateModel.setFormatId(formatId);
				cardPro.setFormatId(formatId);
				result = localCardRelateManager.create(localCardRelateModel);
				Response<Boolean> isBinding = cardProService.updateIsBinding(cardPro);
				if (!result) {
					response.setError("insert.error");
					return response;
				}
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert localProcode error", Throwables.getStackTraceAsString(e));
			response.setError("insert.localProcode.error");
			return response;
		}
	}

	/**
	 * 根据proCode取得全部formatId
	 * 
	 * @return
	 */
	public List<LocalCardRelateModel> findFormatIdAll(String proCode) {
		List<LocalCardRelateModel> result = new ArrayList<>();
		try {
			List<LocalCardRelateModel> localCardRelateModelList = localCardRelateDao.findFormatIdAll(proCode);
			return localCardRelateModelList;
		} catch (Exception e) {
			log.error("CardProService.findCardProProCode.fail,cause:{}", Throwables.getStackTraceAsString(e));
			return result;
		}
	}

	/**
	 * 解除绑定关系
	 *
	 * @param localCardRelateModel
	 * @return
	 */
	@Override
	public Response<Boolean> delete(LocalCardRelateModel localCardRelateModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = localCardRelateManager.delete(localCardRelateModel);
			// 删除关系表中的数据同时 更新绑定字段
			Response<Boolean> isBinding = cardProService.updateUnBinding(localCardRelateModel.getFormatId());

			if (!result) {
				response.setError("delete.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.localCardRelate.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.error");
			return response;
		}
	}

    /**
     * 根据主键查询结果
     *
     * @param formatId
     * @return
     */
    public LocalCardRelateModel findByFormatId(String formatId){
       return localCardRelateDao.findByFormatId(formatId);
    }

}
