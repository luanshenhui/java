/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import static com.google.common.base.Preconditions.checkNotNull;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.related.dao.SmspRecordDao;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;

import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.related.dao.SmspCustDao;
import cn.com.cgbchina.related.dao.SmspInfDao;
import cn.com.cgbchina.related.dao.SmspMdlDao;
import cn.com.cgbchina.related.manager.MessageTemplateManager;
import cn.com.cgbchina.related.model.SmspCustModel;
import cn.com.cgbchina.related.model.SmspInfModel;
import cn.com.cgbchina.related.model.SmspMdlModel;
import cn.com.cgbchina.related.model.SmspRecordModel;
import lombok.extern.slf4j.Slf4j;

/**
 * @author niufw
 * @version 1.0
 * @since 16-6-20.
 */
@Slf4j
@Service
public class SmsTemplateServiceImpl implements SmsTemplateService {
	@Resource
	private SmspInfDao smspInfDao;
	@Resource
	private MessageTemplateManager messageTemplateManager;
	@Resource
	private SmspMdlDao smspMdlDao;
	@Resource
	private SmspCustDao smspCustDao;
	@Resource
	private SmspRecordDao smspRecordDao;
	@Resource
	private GoodsService goodsService;

	/**
	 * 内管短信模板分页查询 niufw
	 *
	 * @param pageNo
	 * @param size
	 * @param id
	 * @param status
	 * @return
	 */
	@Override
	public Response<Pager<SmspInfModel>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("id") String id, @Param("status") String status) {
		Response<Pager<SmspInfModel>> response = new Response<Pager<SmspInfModel>>();
		List<SmspInfModel> smspInfModelList = new ArrayList<>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		// 去除前后空格
		if (StringUtils.isNotEmpty(id)) {
			id = id.trim(); // 去除前后空格
		}
		if (StringUtils.isNotEmpty(id)) {
			// 将查询条件放入到paramMap
			paramMap.put("id", id);// id
		}
		if (StringUtils.isNotEmpty(status)) {
			paramMap.put("status", status);// 当前状态
		}
		try {
			// 分页查询
			Pager<SmspInfModel> pager = smspInfDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			if (pager.getTotal() > 0) {
				smspInfModelList = pager.getData();
				for (SmspInfModel smspInfModel : smspInfModelList) {
					String itemCode = smspInfModel.getItemCode();
					// 获取单品名称
					Response<RecommendGoodsDto> recommendGoodsDtoResponse = goodsService
							.findItemInfoByItemCode(itemCode);
					if (recommendGoodsDtoResponse.getResult() != null) {
						RecommendGoodsDto recommendGoodsDto = recommendGoodsDtoResponse.getResult();
						// 将单品描述存入单品名称
						smspInfModel.setItemName(recommendGoodsDto.getGoodsName());
					}
				}
			}

			response.setResult(new Pager<SmspInfModel>(pager.getTotal(), pager.getData()));
			return response;
		} catch (Exception e) {
			log.error("vendor time query error", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
			return response;
		}
	}

	/**
	 * 内管短信模板添加 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */

	@Override
	public Response<Boolean> create(SmspInfModel smspInfModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (smspInfModel == null) {
				response.setError("create.error");
				return response;
			}
			Boolean result = messageTemplateManager.create(smspInfModel);
			if (!result) {
				response.setError("create.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.vendor.error", Throwables.getStackTraceAsString(e));
			response.setError("create.error");
			return response;
		}
	}

	/**
	 * 内管短信模板编辑 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(SmspInfModel smspInfModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (smspInfModel == null) {
				response.setError("update.error");
				return response;
			}
			Boolean result = messageTemplateManager.update(smspInfModel);
			if (!result) {
				response.setError("update.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.vendor.error", Throwables.getStackTraceAsString(e));
			response.setError("update.error");
			return response;
		}
	}

	/**
	 * 内管短信模板删除 niufw
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> delete(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (id == null) {
				response.setError("delete.error");
				return response;
			}
			Boolean result = messageTemplateManager.delete(id);
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
			log.error("delete.vendor.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.error");
			return response;
		}
	}

	/**
	 * 内管短信模板提交 niufw
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> submit(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (id == null) {
				response.setError("submit.error");
				return response;
			}
			Boolean result = messageTemplateManager.submit(id);
			if (!result) {
				response.setError("submit.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("submit.vendor.error", Throwables.getStackTraceAsString(e));
			response.setError("submit.error");
			return response;
		}
	}

	/**
	 * 内管短信模板审核 niufw
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> smsTemplateCheck(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (id == null) {
				response.setError("check.error");
				return response;
			}
			Boolean result = messageTemplateManager.smsTemplateCheck(id);
			if (!result) {
				response.setError("check.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("check.vendor.error", Throwables.getStackTraceAsString(e));
			response.setError("check.error");
			return response;
		}
	}

	/**
	 * 内管短信模板拒绝 niufw
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> smsTemplateRefuse(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (id == null) {
				response.setError("refuse.error");
				return response;
			}
			Boolean result = messageTemplateManager.smsTemplateRefuse(id);
			if (!result) {
				response.setError("refuse.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("refuse.vendor.error", Throwables.getStackTraceAsString(e));
			response.setError("refuse.error");
			return response;
		}
	}

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	@Override
	public Response<Integer> submitAll(List<SmspInfModel> smspInfModelList) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(smspInfModelList, "smspInfModelList is Null");
			for (SmspInfModel smspInfModel : smspInfModelList) {
				messageTemplateManager.submitAll(smspInfModel);
			}
			response.setResult(1);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.all.goods.status.error", Throwables.getStackTraceAsString(e));
			response.setError("update.all.goods.status.error");
		}
		return response;
	}

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	@Override
	public Response<Integer> deleteAll(List<SmspInfModel> smspInfModelList) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(smspInfModelList, "smspInfModelList is Null");
			for (SmspInfModel smspInfModel : smspInfModelList) {
				messageTemplateManager.deleteAll(smspInfModel);
			}
			response.setResult(1);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("update.all.goods.status.error", Throwables.getStackTraceAsString(e));
			response.setError("update.all.goods.status.error");
		}
		return response;
	}

	/**
	 * 查询所有的短信模板 niufw
	 *
	 * @return
	 */
	@Override
	public Response<List<SmspMdlModel>> findAllSmsTemplate() {
		Response<List<SmspMdlModel>> response = new Response<List<SmspMdlModel>>();
		try {
			List<SmspMdlModel> smspMdlModels = smspMdlDao.findAll();
			response.setResult(smspMdlModels);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("vendor time query error", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
		}
		return response;
	}

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	@Override
	public Response<Pager<SmspCustModel>> findByPager(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("id") Long id) {
		Response<Pager<SmspCustModel>> response = new Response<Pager<SmspCustModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (id != null) {
			// 将查询条件放入到paramMap
			paramMap.put("id", id);// id
		}
		try {
			// 分页查询
			Pager<SmspCustModel> pager = smspCustDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());

			response.setResult(new Pager<SmspCustModel>(pager.getTotal(), pager.getData()));
			return response;
		} catch (Exception e) {
			log.error("vendor time query error", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
			return response;
		}
	}

	/**
	 * 查询短信信息 niufw 未完成
	 * 
	 * @param smspId
	 * @return
	 */
	@Override
	public Response<SmspMdlModel> findSmspMess(String smspId) {
		Response<SmspMdlModel> response = new Response<SmspMdlModel>();
		try {
			SmspMdlModel smspMdlModel = smspMdlDao.findById(smspId);
			response.setResult(smspMdlModel);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("vendor time query error", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
		}
		return response;
	}

	/**
	 * 插入名单数据 niufw
	 * 
	 * @param smspCustModelList
	 * @return
	 */
	@Override
	public Response<List<SmspCustModel>> createCust(List<SmspCustModel> smspCustModelList, Long id, String createOper ,String filePath) {
		Response<List<SmspCustModel>> response = new Response<List<SmspCustModel>>();
		List<SmspCustModel> smspCustModelRepeate = Lists.newArrayList();
		List<SmspCustModel> smspCustModelSuccess = Lists.newArrayList();
		List<SmspCustModel> smspCustModelFail = Lists.newArrayList();
		// 查询该短信维护表id下的所有名单
		List<SmspCustModel> smspCustModelListAll = smspCustDao.findSmspCustById(id);
		// 查询重复的名单（依据是手机号相同）
		for (SmspCustModel smspCustModel : smspCustModelList) {
			String phone = smspCustModel.getPhone();
			for (SmspCustModel smspCustModelDb : smspCustModelListAll) {
				String phoneDb = smspCustModelDb.getPhone();
				if (phone.equals(phoneDb)) {
					// 提取重复项
					smspCustModelRepeate.add(smspCustModel);
				}
			}
		}
		// 剔除重复项,形成可以进行新增的名单list(循环时不允许移除)
		smspCustModelList.removeAll(smspCustModelRepeate);
		// 对于重复名单的进行更新：成功更新db的存入成功的list,失败的存入失败的list
		for (SmspCustModel smspCustModel : smspCustModelRepeate) {
			smspCustModel.setModifyOper(createOper);
			Boolean result = messageTemplateManager.updateCust(smspCustModel);
			if (result == true) {
				smspCustModelSuccess.add(smspCustModel);
			} else {
				smspCustModelFail.add(smspCustModel);
			}
		}

		// 新增名单：成功插入db的存入成功的list,失败的存入失败的list
		for (SmspCustModel smspCustModel : smspCustModelList) {
			Boolean result = messageTemplateManager.createCust(smspCustModel);
			if (result) {
				smspCustModelSuccess.add(smspCustModel);
			} else {
				smspCustModelFail.add(smspCustModel);
			}
		}

		//在履历表中插入数据
		Integer totalNum = smspCustModelList.size() + smspCustModelRepeate.size();//总数等于可新增的加重复项
		Integer successNum = smspCustModelSuccess.size();
		Integer failNum = smspCustModelFail.size();
		Integer repeatNum = smspCustModelRepeate.size();
		SmspRecordModel smspRecordModel = new SmspRecordModel();
		smspRecordModel.setSId(id);
		smspRecordModel.setTotalNum(totalNum);
		smspRecordModel.setSuccessNum(successNum);
		smspRecordModel.setFailNum(failNum);
		smspRecordModel.setRepeatNum(repeatNum);
		smspRecordModel.setCreateOper(createOper);
		smspRecordModel.setLoadStatus("0201");
		smspRecordModel.setFilePath(filePath);
		Boolean result = messageTemplateManager.createRecord(smspRecordModel);
//		if(result == false){
//			log.error("create.smsRecord.error");
//			response.setError("create.smsRecord.error");
//			return response;
//		}
		response.setResult(smspCustModelFail);
		return response;
	}

	/**
	 * 根据短信维护表id查询所有名单
	 * 
	 * @param id
	 * @return
	 */
	@Override
	public Response<List<SmspCustModel>> findSmspCustById(Long id) {
		Response<List<SmspCustModel>> response = new Response<List<SmspCustModel>>();
		if (id == null) {
			response.setError("smsCust.time.query.error");
			return response;
		}
		try {
			List<SmspCustModel> smspCustModelList = smspCustDao.findSmspCustById(id);
			response.setResult(smspCustModelList);
			return response;

		} catch (Exception e) {
			log.error("smsCust.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("smsCust.time.query.error");
			return response;
		}
	}

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	@Override
	public Response<Pager<SmspRecordModel>> findImportResult(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
													  @Param("id") Long id) {
		Response<Pager<SmspRecordModel>> response = new Response<Pager<SmspRecordModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (id != null) {
			// 将查询条件放入到paramMap
			paramMap.put("id", id);// id
		}
		try {
			// 分页查询
			Pager<SmspRecordModel> pager = smspRecordDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());

			response.setResult(new Pager<SmspRecordModel>(pager.getTotal(), pager.getData()));
			return response;
		} catch (Exception e) {
			log.error("vendor time query error", Throwables.getStackTraceAsString(e));
			response.setError("vendor.time.query.error");
			return response;
		}
	}
}
