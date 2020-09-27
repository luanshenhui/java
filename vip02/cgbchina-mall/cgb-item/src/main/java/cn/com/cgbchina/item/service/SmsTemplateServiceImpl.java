/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.SmspCustDao;
import cn.com.cgbchina.item.dao.SmspInfDao;
import cn.com.cgbchina.item.dao.SmspMdlDao;
import cn.com.cgbchina.item.dao.SmspRecordDao;
import cn.com.cgbchina.item.dto.SmspInfDto;
import cn.com.cgbchina.item.manager.MessageTemplateManager;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.scheduler.model.TaskScheduled;
import com.google.common.base.Function;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.jms.mq.QueueSender;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.*;

/**
 * @author niufw
 * @version 1.0
 * @since 16-6-20.
 */
@Slf4j
@Service
@SuppressWarnings("unchecked")
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
	private ItemService itemService;

	@Autowired
	@Qualifier("queueSenderSms")
	private QueueSender queueSender;
	private DateTimeFormatter dateTimeFormatter=DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");



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
	public Response<Pager<SmspInfDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("id") String id, @Param("status") String status, @Param("type") String type) {
		Response<Pager<SmspInfDto>> response = new Response<Pager<SmspInfDto>>();
		List<SmspInfDto> smspInfDtos = new ArrayList<>();
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
		paramMap.put("type", type);// 根据type区分是短信模板管理，还是短信模板审核

		try {
			// 分页查询
			Pager<SmspInfModel> pager = smspInfDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			if (pager.getTotal() > 0) {
				SmspInfDto smspInfDto = null;
				List<SmspInfModel> smspInfModelList = pager.getData();

				List<String> codes = Lists.transform(smspInfModelList, new Function<SmspInfModel, String>() {
					@NotNull
					@Override
					public String apply(@NotNull SmspInfModel input) {
						return input.getItemCode();
					}
				});

				Map<String, String> itemMid = null;
				if (!codes.isEmpty()) {
					Set<String> set = new HashSet<String>(codes);
					// 获取mid集合
					Response<List<ItemModel>> resp = itemService.findByCodes(new ArrayList<String>(set));

					if (resp.isSuccess()) {
						List<ItemModel> items = resp.getResult();
						if (null != items && !items.isEmpty()) {
							for (ItemModel itemModel : items) {
								if (null == itemMid)
									itemMid = Maps.newHashMapWithExpectedSize(items.size());
								itemMid.put(itemModel.getCode(), itemModel.getMid());
							}
						}
					}
				}

				for (SmspInfModel smspInfModel : smspInfModelList) {

					smspInfDto = new SmspInfDto();
					BeanMapper.copy(smspInfModel, smspInfDto);

					String itemCode = smspInfModel.getItemCode();
					if (null != itemMid) {
						smspInfDto.setItemCode(itemMid.get(itemCode));
					}
					smspInfDto.setNewDate(new Date());
					smspInfDtos.add(smspInfDto);
				}
			}

			response.setResult(new Pager<SmspInfDto>(pager.getTotal(), smspInfDtos));
			return response;
		} catch (Exception e) {
			log.error("smsTemp.time.query.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("smsTemp.time.query.error");
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
				response.setError("create.smsTemplate.error");
				return response;
			}
			// 如果优惠券金额是空，则给优惠券金额赋值0
			BigDecimal voucherPrice = smspInfModel.getVoucherPrice();
			if (voucherPrice == null) {
				smspInfModel.setVoucherPrice(new BigDecimal(0));
			}
			Boolean result = messageTemplateManager.create(smspInfModel);
			if (!result) {
				response.setError("create.smsTemplate.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("create.smsTemplate.error");
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
				response.setError("update.smsTemplate.error");
				return response;
			}
			Boolean result = messageTemplateManager.update(smspInfModel);
			if (!result) {
				response.setError("update.smsTemplate.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("update.smsTemplate.error");
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
				response.setError("delete.smsTemplate.error");
				return response;
			}
			Boolean result = messageTemplateManager.delete(id);
			if (!result) {
				response.setError("delete.smsTemplate.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("delete.smsTemplate.error");
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
				response.setError("submit.smsTemplate.error");
				return response;
			}
			Boolean result = messageTemplateManager.submit(id);
			if (!result) {
				response.setError("submit.smsTemplate.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("submit.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("submit.smsTemplate.error");
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
	public Response<String> submitAll(List<SmspInfModel> smspInfModelList) {
		Response<String> response = Response.newResponse();
		List<Long> idList = new ArrayList<>();
		try {
			for (SmspInfModel smspInfModel : smspInfModelList) {
				idList.add(smspInfModel.getId());
			}
			Map<String, Object> paramMap = Maps.newHashMap();
			List<Long> existIds = smspCustDao.findExistId(idList);
			List<Long> inexistenceId = Lists.newArrayList();
			for (Long id : idList) {
				if (!existIds.contains(id.longValue())) {
					inexistenceId.add(id);
				}
			}
			Integer count = 1;
			if (existIds != null && !existIds.isEmpty()) {
				paramMap.put("idList", existIds);
				count = messageTemplateManager.submitAll(paramMap);
			}
			if (count > 0) {
				if (inexistenceId != null && !inexistenceId.isEmpty()) {
					response.setResult(inexistenceId.toString());
					return response;
				}
				response.setResult(null);
				return response;
			} else {
				response.setError("submit.smsTemplate.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("submit.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("submit.smsTemplate.error");
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
		List<Long> idList = new ArrayList<>();
		try {
			for (SmspInfModel smspInfModel : smspInfModelList) {
				idList.add(smspInfModel.getId());
			}
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("idList", idList);
			Integer count = messageTemplateManager.deleteAll(paramMap);
			if (count > 0) {
				response.setResult(1);
				return response;
			} else {
				response.setError("delete.smsTemplate.error");
				return response;
			}

		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("delete.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("delete.smsTemplate.error");
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
			log.error("find.smsTemplate.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.smsTemplate.error");
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
			@Param("id") Long id,@Param("userType") Integer userType) {
		Response<Pager<SmspCustModel>> response = new Response<Pager<SmspCustModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (id != null) {
			// 将查询条件放入到paramMap
			paramMap.put("id", id);// id
		}
		if(userType != null){
			paramMap.put("userType", userType);// 用户类型
		}
		try {
			// 分页查询
			Pager<SmspCustModel> pager = smspCustDao.findByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());

			response.setResult(new Pager<SmspCustModel>(pager.getTotal(), pager.getData()));
			return response;
		} catch (Exception e) {
			log.error("find.mspCust.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.mspCust.error");
			return response;
		}
	}

	/**
	 * 查询短信信息 niufw
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
			log.error("find.smspMess.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.smspMess.error");
		}
		return response;
	}

	/**
	 * 短信模板审核白名单添加 niufw
	 *
	 * @param smspCustModel
	 * @return
	 */
	@Override
	public Response<Boolean> addNameForAudit(SmspCustModel smspCustModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验
			if (smspCustModel == null) {
				response.setError("create.name.error");
				return response;
			}
			Boolean result = messageTemplateManager.createCust(smspCustModel);
			if (!result) {
				response.setError("create.name.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.name.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("create.name.error");
			return response;
		}
	}

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	@Override
	public Response<Pager<SmspRecordModel>> findImportResult(@Param("pageNo") Integer pageNo,
			@Param("size") Integer size, @Param("id") Long id) {
		Response<Pager<SmspRecordModel>> response = new Response<Pager<SmspRecordModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (id != null) {
			// 将查询条件放入到paramMap
			paramMap.put("id", id);// id
		}
		try {
			// 分页查询
			Pager<SmspRecordModel> pager = smspRecordDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());

			response.setResult(new Pager<SmspRecordModel>(pager.getTotal(), pager.getData()));
			return response;
		} catch (Exception e) {
			log.error("find.mspCust.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.mspCust.error");
			return response;
		}
	}

	/**
	 * 审核页面白名单管理批量删除 niufw
	 *
	 * @param smspCustModelList
	 * @return
	 */
	@Override
	public Response<Integer> deleteNameForAudit(List<SmspCustModel> smspCustModelList) {
		Response<Integer> response = new Response<Integer>();
		try {
			for (SmspCustModel smspCustModel : smspCustModelList) {
				messageTemplateManager.deleteNameForAudit(smspCustModel);
			}
			response.setResult(1);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("delete.name.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("delete.name.error");
		}
		return response;
	}

	/**
	 * 审核页面短信发送 niufw
	 *
	 * @param dto
	 * @return BaseResult
	 */
	@Override
	public Response<Boolean> sendMessage(final SmspInfDto dto) {
		Response<Boolean> response = Response.newResponse();
		JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
		try {
			// 更新状态
			boolean changeStatus = messageTemplateManager.updateStatus(dto);
			if (!changeStatus) {
				log.error("send.sms.error,error：messageTemplateManager.changeStatus.updateFailed");
				response.setError("update.status.failed");
				return response;
			}

			SmspInfModel model = smspInfDao.findById(dto.getId());
			BeanMapper.copy(model, dto);
			String[] dtoStr = new String[]{jsonMapper.toJson(dto)};
			if("0".equals(model.getSendDatetime()) || "1".equals(dto.getUserType())){
				// 发送 短信模板
				queueSender.send("shop.cgb.sms.send", dtoStr);
			}else {
				//定时发送
				//yyyy-MM-dd HH:mm:ss
				DateTime sendTime = dateTimeFormatter.parseDateTime(dto.getSendDatetime());
				TaskScheduled taskScheduled = new TaskScheduled();
				taskScheduled.setTaskGroup("cn.com.cgbchina.batch.service.BatchSmspCustService");
				taskScheduled.setTaskName("sendMessage");
				taskScheduled.setDesc("定时发送短信");
				taskScheduled.setTaskType("smsClock");
				taskScheduled.setStatus("1");
				taskScheduled.setParamArgs(dtoStr);
                taskScheduled.setPromotionStartDate(sendTime.toDate());//开始发送时间  直接使用活动开始时间字段 不在自立字段
                taskScheduled.setPromotionId(String.valueOf(dto.getId()));//短信模板发送id 用于区别定时任务
				queueSender.send("shop.cgb.scheduler.notify",taskScheduled);
			}
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("send.sms.error,error：{}", Throwables.getStackTraceAsString(e));
			response.setError("send.sms.error");
		}
		return response;
	}

	/**
	 * 状态更新
	 *
	 * @param smspInfModel 更新对象
	 * @return Boolean
	 */
	@Override
	public Response<Boolean> updateStatus(SmspInfModel smspInfModel) {
		Response<Boolean> response = Response.newResponse();
		try {
			Boolean result = messageTemplateManager.updateStatus(smspInfModel);
			response.setResult(result);
			if (!result) {
				response.setError("update.status.error");
			}
		} catch (Exception e) {
			log.error("execute.sql.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("execute.sql.error");
		}
		return response;
	}

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	@Override
	public Response<List<SmspCustModel>> findAllByPhone(@Param("pageNo") String phone) {
		Response<List<SmspCustModel>> response = new Response<List<SmspCustModel>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		if (phone != null) {
			// 将查询条件放入到paramMap
			paramMap.put("phone", phone);
		}
		try {
			List<SmspCustModel> list = smspCustDao.findAllByPhone(paramMap);
			response.setResult(list);
			return response;
		} catch (Exception e) {
			log.error("find.findAllByPhone.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.findAllByPhone.error");
			return response;
		}
	}

	/**
	 * 查询短信信息 niufw
	 *
	 * @param smspId
	 * @return
	 */
	@Override
	public Response<Map> findAllById(String smspId) {
		Response<Map> response = new Response<Map>();
		try {
			Map smspMdlModel = smspMdlDao.findAllById(smspId);
			response.setResult(smspMdlModel);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("find.smspMess.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.smspMess.error");
		}
		return response;
	}

	@Override
	public Response<SmspInfModel> findAllByIds(List<String> ids) {
		Response<SmspInfModel> response = new Response<SmspInfModel>();
		try {
			SmspInfModel smspMdlModel = smspInfDao.findAllByIds(ids);
			response.setResult(smspMdlModel);
			return response;
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
		} catch (Exception e) {
			log.error("find.findAllByIds.error,error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.findAllByIds.error");
		}
		return response;
	}

	/**
	 * 导入结果记录 创建
	 *
	 * @param smspRecordModel 导入白名单信息
	 */
	@Override
	public Response<Boolean> createRecord(SmspRecordModel smspRecordModel) {
		Response<Boolean> response = Response.newResponse();
		Boolean flag = messageTemplateManager.createRecord(smspRecordModel);
		response.setResult(flag);
		return response;
	}

	/**
	 * 检测导入格式
	 *
	 * @param phone
	 * @param cardNo
	 * @return
	 */
	private Boolean checkFormat(String phone, String cardNo) {
		if (null == phone || null == cardNo)
			return Boolean.FALSE;
		if (phone.length() > 20 || cardNo.length() > 20)
			return Boolean.FALSE;
		return Boolean.TRUE;
	}
}
