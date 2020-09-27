/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.LocalCardRelateDao;
import cn.com.cgbchina.user.manager.LocalCardRelateManager;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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

				Map<String,Object> paramMap = Maps.newHashMap();
//				paramMap.put("proCode", proCode);
				paramMap.put("formatId",formatId);
				Boolean cboolean = false;
				List<LocalCardRelateModel> relateList = localCardRelateDao.findLocalCardByParams(paramMap);
				if(relateList == null || relateList.size() == 0){
					// 不存在相同的卡板
					localCardRelateModel.setProCode(proCode);
					localCardRelateModel.setFormatId(formatId);
					cardPro.setFormatId(formatId);
					cboolean = true;
					result = localCardRelateManager.create(localCardRelateModel);
				}else{
					for(LocalCardRelateModel localcard : relateList){
						if(proCode.equals(localcard.getProCode())){
							cboolean = true;
							cardPro.setFormatId(formatId);
						}
					}
				}

				if (cboolean){
					//更新卡板表＂是否绑定＂字段
					Response<Boolean> isBinding = cardProService.updateIsBinding(cardPro);
					if (!isBinding.isSuccess()||!isBinding.getResult()) {
						response.setError("insert.error");
						return response;
					}
				}else{
					//该卡板已在其他等级下绑定，如需更改卡板所在等级，请先进行解绑操作
					response.setError("insert.localProcode.business.error");
					return response;
				}
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("insert localProcode error{}", Throwables.getStackTraceAsString(e));
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
			return localCardRelateDao.findFormatIdAll(proCode);
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

			if (!result || !isBinding.isSuccess()) {
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
    public Response<LocalCardRelateModel> findByFormatId(String formatId){
    	Response<LocalCardRelateModel> response = new Response<>();
    	try {			
    		LocalCardRelateModel localCardRelateModel =	localCardRelateDao.findByFormatId(formatId);
    		if (localCardRelateModel != null) {
    			response.setSuccess(true);
			}else {
				response.setSuccess(false);
			}
    		response.setResult(localCardRelateModel);
    		return response;
		} catch (Exception e) {
			log.error("find.findByFormatId.error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("find.error");
			return response;
		}
    }

	/**
	 * 根据参数查询列表
	 * @param paramMap 查询参数
	 * @return 结果列表
	 *
	 * geshuo 20160721
	 */
	public Response<List<LocalCardRelateModel>> findLocalCardByParams(Map<String,Object> paramMap){
		Response<List<LocalCardRelateModel>> response = Response.newResponse();
		try{
			List<LocalCardRelateModel> resultList = localCardRelateDao.findLocalCardByParams(paramMap);
			response.setResult(resultList);
		}catch(Exception e){
			log.error("LocalCardRelateServiceImpl.findLocalCardByParams.error{}", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("LocalCardRelateServiceImpl.findLocalCardByParams.error");
			return response;
		}
		return response;
	}

}
