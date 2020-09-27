package cn.com.cgbchina.user.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;

import cn.com.cgbchina.user.dao.EspCustNewDao;
import cn.com.cgbchina.user.manager.EspCustNewManager;
import cn.com.cgbchina.user.model.EspCustNewModel;
import lombok.extern.slf4j.Slf4j;

import java.util.Map;

@Service
@Slf4j
public class EspCustNewServiceImpl implements EspCustNewService {

	@Resource
	private EspCustNewDao espCustNewDao;

	@Resource
	private EspCustNewManager espCustNewManager;


	/**
	 * 通过Id查询
	 *
	 * @param custId
	 * @return
	 */
	public Response<EspCustNewModel> findById(String custId){
		Response<EspCustNewModel> response = new Response<EspCustNewModel>();
		try {
			EspCustNewModel espCustNewModel = espCustNewDao.findById(custId);
			if (espCustNewModel != null) {
				response.setResult(espCustNewModel);
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.item.error", Throwables.getStackTraceAsString(e));
			response.setError("update.item.error");
		}
		return response;
	}

	/**
	 * 更新
	 *
	 * @param espCustNewModel
	 * @return
	 */
	public Response<Integer> update(EspCustNewModel espCustNewModel){
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = espCustNewManager.update(espCustNewModel);
			if (count > 0) {
				response.setResult(count);
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.item.error", Throwables.getStackTraceAsString(e));
			response.setError("update.item.error");
		}
		return response;
	}


	/**
	 * 更新使用生日次数
	 *
	 * @param custId
	 * @return
	 */
	@Override
	public Response<Integer> updateBirthUsedCount(String custId) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = espCustNewManager.updateBirthUsedCount(custId);
			if (count > 0) {
				response.setResult(count);
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.item.error", Throwables.getStackTraceAsString(e));
			response.setError("update.item.error");
		}
		return response;
	}

	/**
	 * 获取生日价剩余兑换次数
	 * 
	 * @param custId 客户号
	 * @return 剩余次数
	 *
	 *         geshuo 20160721
	 */
	public Response<Integer> findBirthAvailableCount(String custId, Integer birthdayLimit) {
		Response<Integer> response = new Response<>();
		try {
			Integer availCount = espCustNewManager.findAvailableCount(custId, birthdayLimit);
			response.setResult(availCount);
		} catch (Exception e) {
			log.error("EspCustNewServiceImpl.findBirthAvailableCount.error{}", Throwables.getStackTraceAsString(e));
			response.setError("EspCustNewServiceImpl.findBirthAvailableCount.error.error");
			return response;
		}

		return response;
	}

	/**
	 * 更新数据
	 * 
	 * @param espCustNewModel 生日价使用次数信息表数据
	 * @return 是否成功
	 */
	@Override
	public Response insOrUpdCustNew(EspCustNewModel espCustNewModel) {
		Response response = Response.newResponse();
		try {
			// 有数据就更新，没有数据插入
			EspCustNewModel model = espCustNewDao.findById(espCustNewModel.getCustId());
			if (model == null) {
				espCustNewManager.insert(espCustNewModel);
			}else {
				espCustNewModel.setBirthUsedYear(model.getBirthUsedYear());
				espCustNewModel.setBirthUsedCount(model.getBirthUsedCount());
				espCustNewManager.update(espCustNewModel);
			}
			response.setSuccess(true);
			return response;
		}catch (Exception e){
			log.error("insOrUpdCustNew is error");
			response.setError("insOrUpdCustNew.is.error");
			return response;
		}
	}

	@Override
	public Response updBirthUsedCount(String custId) {
		Response response = Response.newResponse();
		try {
			// 查询数据并且更新
			EspCustNewModel model = espCustNewDao.findById(custId);
			if (model == null) {
				log.error("updBirthUsedCount is error");
				response.setError("updBirthUsedCount.is.error");
				return response;
			}
			model.setBirthUsedCount(model.getBirthUsedCount() - 1);
			espCustNewManager.update(model);
			response.setSuccess(true);
			return response;
		} catch (Exception e){
			log.error("updBirthUsedCount is error");
			response.setError("updBirthUsedCount.is.error");
			return response;
		}
	}

	/**
	 * 根据参数更新生日价使用次数
	 * @param paramMap 更新参数
	 * @return 更新结果
	 *
	 * geshuo 20160824
	 */
	@Override
	public Response<Integer> updateCustNewByParams(Map<String,Object> paramMap){
		Response<Integer> response = Response.newResponse();
		try {
			Integer count = espCustNewManager.updateCustNewByParams(paramMap);
			response.setResult(count);
		} catch (Exception e){
			log.error("EspCustNewServiceImpl.updateCustNewByParams.error");
			response.setError("EspCustNewServiceImpl.updateCustNewByParams.error");
		}
		return response;
	}

	/**
	 * 查询生日次数并更新
	 * @param certNbr 证件号码
	 * @param custId 客户号
	 * @return 查询结果
	 *
	 * geshuo 20160824
	 */
	@Override
	public Response<Map<String,Object>> getBirthUsedCount(String certNbr,String custId){
		Response<Map<String,Object>> response = Response.newResponse();
		try {
			Map<String,Object> map = espCustNewManager.getBirthUsedCount(certNbr,custId);
			response.setResult(map);
		} catch (Exception e){
			log.error("EspCustNewServiceImpl.updateCustNewByParams.error");
			response.setError("EspCustNewServiceImpl.updateCustNewByParams.error");
		}
		return response;
	}
}