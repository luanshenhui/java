package cn.com.cgbchina.related.service;

import cn.com.cgbchina.related.dao.InfoOutSystemDao;
import cn.com.cgbchina.related.manager.InfoOutSystemManager;
import cn.com.cgbchina.related.model.InfoOutSystemModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author
 * @version 1.0
 * @Since 2016/7/25.
 */
@Service
@Slf4j
public class InfoOutSystemServiceImpl implements InfoOutSystemService {

	@Resource
	private InfoOutSystemDao infoOutSystemDao;
	@Resource
	private InfoOutSystemManager infoOutSystemManager;

	@Override
	public Response<Integer> updateInfoByOrderId(InfoOutSystemModel infoOutSystemModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer result = 0;
			result = infoOutSystemManager.updateInfoByOrderId(infoOutSystemModel);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			// log.error("infoOutSystemModel.update.error", Throwables.getStackTraceAsString(e));
			// response.setError("infoOutSystemModel.update.error");
			return response;
		}

	}

	@Override
	public Response<List<InfoOutSystemModel>> findByOrderId(String orderId) {
		Response<List<InfoOutSystemModel>> response = new Response<>();
		try {
			List<InfoOutSystemModel> infoOutSystemList = infoOutSystemDao.findByOrderId(orderId);
			response.setResult(infoOutSystemList);
		} catch (Exception e) {
			log.error("infoOutSystemModel.query.error", Throwables.getStackTraceAsString(e));
			response.setError("infoOutSystemModel.query.error");
			return response;
		}
		return response;
	}

	/**
	 * 倒序获取对象集合
	 * 
	 * @return
	 * @add by yanjie.cao
	 */
	@Override
	public Response<List<InfoOutSystemModel>> findByOrderIdDesc(String orderId) {
		Response<List<InfoOutSystemModel>> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			List<InfoOutSystemModel> infoOutSystemModelList = Lists.newArrayList();
			infoOutSystemModelList = infoOutSystemDao.findByOrderIdDesc(orderId);
			response.setResult(infoOutSystemModelList);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("InfoOutSystemService findByOrderIdDesc error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("InfoOutSystemService findByOrderIdDesc error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("InfoOutSystemService.findByOrderIdDesc.error");
			return response;
		}
	}

	@Override
	public Response<InfoOutSystemModel> validateOrderId(String subOrderNo) {
		Response<InfoOutSystemModel> response = new Response<InfoOutSystemModel>();
		try {
			InfoOutSystemModel infoOutSystem = infoOutSystemDao.validateOrderId(subOrderNo);
			response.setResult(infoOutSystem);
		} catch (Exception e) {
			log.error("InfoOutSystemServiceImpl.validateOrderId.error ", Throwables.getStackTraceAsString(e));
			response.setError("InfoOutSystemServiceImpl.validateOrderId.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<Integer> insert(InfoOutSystemModel infoOutSystemModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer infoOutSystem = infoOutSystemManager.insert(infoOutSystemModel);
			response.setResult(infoOutSystem);
		} catch (Exception e) {
			log.error("InfoOutSystemServiceImpl.insert.error ", Throwables.getStackTraceAsString(e));
			response.setError("InfoOutSystemServiceImpl.insert.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<Integer> updateValidateCode(InfoOutSystemModel infoOutSystemModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer infoOutSystem = infoOutSystemManager.updateValidateCode(infoOutSystemModel);
			response.setResult(infoOutSystem);
		} catch (Exception e) {
			log.error("InfoOutSystemServiceImpl.updateValidateCode.error ", Throwables.getStackTraceAsString(e));
			response.setError("InfoOutSystemServiceImpl.updateValidateCode.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<Integer> insertMsgStatus(InfoOutSystemModel infoOutSystemModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer infoOutSystem = infoOutSystemManager.updateMsgStatus(infoOutSystemModel);
			response.setResult(infoOutSystem);
		} catch (Exception e) {
			log.error("InfoOutSystemServiceImpl.insertMsgStatus.error ", Throwables.getStackTraceAsString(e));
			response.setError("InfoOutSystemServiceImpl.insertMsgStatus.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<List<InfoOutSystemModel>> findInfoByValidateStatus(Map<String, Object> paramMap) {
		Response<List<InfoOutSystemModel>> response = new Response<>();
		try {
			List<InfoOutSystemModel> orderSubModelList = infoOutSystemDao.findInfoByValidateStatus(paramMap);
			response.setResult(orderSubModelList);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findInfoByCurStatusId query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);

			return response;
		}
	}

	@Override
	public Response<List<InfoOutSystemModel>> findInfoByOrderId(String orderId) {
		Response<List<InfoOutSystemModel>> response = new Response<>();
		try {
			List<InfoOutSystemModel> orderSubModelList = infoOutSystemDao.findInfoByOrderId(orderId);
			response.setResult(orderSubModelList);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findInfoByCurStatusId query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);

			return response;
		}
	}

}
