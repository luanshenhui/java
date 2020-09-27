/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.TblBankDao;
import cn.com.cgbchina.related.manager.BankManager;
import cn.com.cgbchina.related.model.TblBankModel;
import lombok.extern.slf4j.Slf4j;

/**
 * @author A111503210500871
 * @version 1.0
 * @Since 2016/8/1
 */
@Service
@Slf4j
public class BankServiceImpl implements BankService {
	@Resource
	private TblBankDao tblBankDao;

	/**
	 * 根据分行ID查询分行信息
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<TblBankModel> findBankById(Long id) {
		Response<TblBankModel> response = new Response<TblBankModel>();
		try{
			// 校验分行ID是否为空
			checkArgument(id == null, "bankid is null");
			//根据分行ID获取分行信息
			TblBankModel tblBankModel = tblBankDao.findById(id);
			response.setResult(tblBankModel);
			return response;
		}catch  (Exception e) {
			log.error("bank.query.error", Throwables.getStackTraceAsString(e));
			response.setError("banks.query.error");
			return response;
		}
	}

	@Resource
	private BankManager bankManager;

	@Override
	public Response<Pager<TblBankModel>> findAllBank(@Param("pageNo") Integer pageNo, @Param("size") Integer size) {
		Response<Pager<TblBankModel>> response = new Response<Pager<TblBankModel>>();
		try {
			PageInfo pageInfo = new PageInfo(pageNo, size);
			Map<String, Object> paramMap = Maps.newHashMap();
			Pager<TblBankModel> pager = tblBankDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			response.setResult(pager);
			return response;
		} catch (Exception e) {
			log.error("banks.query.error", Throwables.getStackTraceAsString(e));
			response.setError("banks.query.error");
			return response;
		}
	}

	@Override
	public Response<Boolean> update(TblBankModel tblBankModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验分行名称是否为空
			checkArgument(StringUtils.isNotBlank(tblBankModel.getName()), "bankname is null");
			// 校验分行城市名称是否为空
			checkArgument(StringUtils.isNotBlank(tblBankModel.getBankCityNm()), "bankcityname is null");
			Boolean result = bankManager.update(tblBankModel);
			response.setResult(result);
		}  catch (ResponseException re) {
			log.error("bank.update.error,error code:{}", Throwables.getStackTraceAsString(re));
			response.setError(re.getMessage());
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), tblBankModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("bank.update.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "bank.update.error");
		}
		return response;
	}

	/**
	 * 创建分行信息
	 *
	 * @param tblBankModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(TblBankModel tblBankModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验分行名称是否为空
			checkArgument(StringUtils.isNotBlank(tblBankModel.getName()), "bankname is null");
			// 校验分行城市名称是否为空
			checkArgument(StringUtils.isNotBlank(tblBankModel.getBankCityNm()), "bankcityname is null");
			Boolean result = bankManager.create(tblBankModel);
			response.setResult(result);
		} catch (ResponseException re) {
			log.error("bank.create.error,error code:{}", Throwables.getStackTraceAsString(re));
			response.setError(re.getMessage());
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), tblBankModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("bank.create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "bank.create.error");
		}
		return response;

	}

	@Override
	public Response<Integer> deleteBanks(List<Long> idList,String userId) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(idList, "idList is Null");
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("idList", idList);//id列表
			paramMap.put("modifyOper",userId);//修改人
			// 删除操作 批量删除
			Integer count = bankManager.deleteBanks(paramMap);
			if (count > 0) {
				response.setResult(count);
				return response;
			} else {
				response.setError("detele.all.banks.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.info("detele all banks error", Throwables.getStackTraceAsString(e));
			response.setError("detele.all.banks.error");
			return response;
		}
	}
}
