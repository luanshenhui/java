/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.GoodsCheckUtil;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.dto.SmspInfDto;
import cn.com.cgbchina.item.dto.SmspMdlDto;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.SmsTemplateService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.io.Files;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.jms.mq.QueueSender;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.elasticsearch.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;
import java.util.concurrent.*;

/**
 * @author niufw
 * @version 1.0
 * @since 2016/06/22
 */
@Controller
@RequestMapping("/api/mall/smsTemplate")
@Slf4j
public class MessageTemplates {

	@Autowired
	private SmsTemplateService smsTemplateService;

	@Autowired
	private MessageSources messageSources;

	@Autowired
	private GoodsService goodsService;

	@Autowired
	private ItemService itemService;

	@Value("#{app.smsTemplateUp}")
	private String fileUpBase;

	@Value("#{app.smsTemplateDown}")
	private String fileDwBase;

	private JsonMapper jsonMapper = JsonMapper.JSON_NON_EMPTY_MAPPER;
	@Autowired
	@Qualifier("queueSenderSmsU")
	private QueueSender queueSender;
	/**
	 * 短信模板管理添加 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(SmspInfModel smspInfModel) {
		// 从登录信息中获取用户id和用户名称并插入到model中
		User user = UserUtil.getUser();
		String createOper = user.getId();
		smspInfModel.setCreateOper(createOper);
		// 校验单品编码是否存在
		String mid = smspInfModel.getItemCode();// 该字段为单品表的mid
		try {
			Response<ItemModel> itemModelResponse = itemService.findByMid(mid);
			if (!itemModelResponse.isSuccess() || null == itemModelResponse.getResult()) {
				log.error("itemCode.is.not.find，error:{}", itemModelResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(itemModelResponse.getError()));
			}
			smspInfModel.setItemCode(itemModelResponse.getResult().getCode());

			// 新增
			Response<Boolean> result = smsTemplateService.create(smspInfModel);
			if (!result.isSuccess()) {
				log.error("create.smsTemplate.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (ResponseException e) {
			log.error("create.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.smsTemplate.error"));
		}
	}

	/**
	 * 短信模板管理编辑 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(SmspInfModel smspInfModel) {

		// 从登录信息中获取用户id和用户名称并插入到model中
		User user = UserUtil.getUser();
		String modifyOper = user.getId();
		smspInfModel.setModifyOper(modifyOper);

		// 校验单品编码是否存在
		String mid = smspInfModel.getItemCode();// 该字段为单品表的mid
		try {
			Response<ItemModel> itemModelResponse = itemService.findByMid(mid);
			if (!itemModelResponse.isSuccess() || null == itemModelResponse.getResult()) {
				log.error("itemCode.is.not.find，error:{}", itemModelResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(itemModelResponse.getError()));
			}
			smspInfModel.setItemCode(itemModelResponse.getResult().getCode());
			// 编辑
			Response<Boolean> result = smsTemplateService.update(smspInfModel);

			if (!result.isSuccess()) {
				log.error("update.smsTemplate.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (ResponseException e) {
			log.error("create.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("update.smsTemplate.error"));
		}
	}

	/**
	 * 短信模板管理审核
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/changeStatus/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> smsTemplateCheck(@PathVariable("id") Long id, String operate) {
		SmspInfModel smspInfModel = null;
		User user = UserUtil.getUser();
		try {

			if (null == id || null == operate) {
				log.error("check.smsTemplate.error，error:property.is.null");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("property.is.null"));
			}

			switch (operate) {
			case "check":
				smspInfModel = new SmspInfModel();
				smspInfModel.setStatus(Contants.SMSP_CURSTATUS_0206); // 白名单发送--0206
				break;
			case "refuse":
				smspInfModel = new SmspInfModel();
				smspInfModel.setStatus(Contants.SMSP_CURSTATUS_0205); // 已拒绝--0205
				break;
			case "sendSuccess":
				smspInfModel = new SmspInfModel();
				smspInfModel.setStatus(Contants.SMSP_CURSTATUS_0204); // 已完成--0204
				break;
			case "sendFail":
				smspInfModel = new SmspInfModel();
				smspInfModel.setStatus(Contants.SMSP_CURSTATUS_0207); // 发送失败--0207
				break;
			default:
				log.error("check.smsTemplate.error，error:unknown.operate");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("unknown.operate"));
			}
			smspInfModel.setId(id);
			smspInfModel.setModifyOper(user.getId());
			Response<Boolean> result = smsTemplateService.updateStatus(smspInfModel);
			if (!result.isSuccess()) {
				log.error("check.smsTemplate.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (ResponseException e) {
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("check.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.smsTemplate.error"));
		}
	}

	/**
	 * 短信模板管理拒绝 niufw
	 *
	 * @param id
	 * @return
	 */
	// @RequestMapping(value = "/audit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	// @ResponseBody
	// public Response<Boolean> smsTemplateRefuse(Long id) {
	// try {
	// // 拒绝
	// Response<Boolean> result = smsTemplateService.smsTemplateRefuse(id);
	// if (!result.isSuccess()) {
	// log.error("refuse.smsTemplate.error，error:{}", result.getError());
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	// }
	// return result;
	// } catch (IllegalArgumentException e) {
	// log.error("refuse.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
	// } catch (Exception e) {
	// log.error("refuse.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("refuse.smsTemplate.error"));
	// }
	// }
	//
	// /**
	// * 短信模板审核短信发送成功 niufw
	// *
	// * @param id
	// * @return
	// */
	// @RequestMapping(value = "/sendSuccess", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	// @ResponseBody
	// public Response<Boolean> sendSuccess(Long id) {
	// try {
	// // 审核
	// Response<Boolean> result = smsTemplateService.sendSuccess(id);
	// if (!result.isSuccess()) {
	// log.error("send.sms.error，error:{}", result.getError());
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	// }
	// return result;
	// } catch (IllegalArgumentException e) {
	// log.error("send.sms.error，error:{}", Throwables.getStackTraceAsString(e));
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
	// } catch (Exception e) {
	// log.error("send.sms.error.error，error:{}", Throwables.getStackTraceAsString(e));
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("send.sms.error"));
	// }
	// }
	//
	// /**
	// * 短信模板审核短信发送失败 niufw
	// *
	// * @param id
	// * @return
	// */
	// @RequestMapping(value = "/sendFail", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	// @ResponseBody
	// public Response<Boolean> sendFail(Long id) {
	// try {
	// // 审核
	// Response<Boolean> result = smsTemplateService.sendFail(id);
	// if (!result.isSuccess()) {
	// log.error("send.sms.error，error:{}", result.getError());
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	// }
	// return result;
	// } catch (IllegalArgumentException e) {
	// log.error("send.sms.error，error:{}", Throwables.getStackTraceAsString(e));
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
	// } catch (Exception e) {
	// log.error("send.sms.error，error:{}", Throwables.getStackTraceAsString(e));
	// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("send.sms.error"));
	// }
	// }

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	@RequestMapping(value = "/ae-submitAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> submitAll(@RequestBody SmspInfModel[] smspInfModelList) {
		// try {
		// 提交
		Response<String> result = smsTemplateService.submitAll(Arrays.asList(smspInfModelList));
		if (!result.isSuccess()) {
			log.error("submit.smsTemplate.error，error:{}", result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
		}
		return result;
		// } catch (IllegalArgumentException e) {
		// log.error("submit.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
		// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		// } catch (Exception e) {
		// log.error("submit.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
		// throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("submit.smsTemplate.error"));
		// }
	}

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	@RequestMapping(value = "/deleteAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> deleteAll(@RequestBody SmspInfModel[] smspInfModelList) {
		try {
			// 提交
			Response<Integer> result = smsTemplateService.deleteAll(Arrays.asList(smspInfModelList));
			if (!result.isSuccess()) {
				log.error("delete.smsTemplate.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.smsTemplate.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.smsTemplate.error"));
		}
	}

	/**
	 * 查询所有的短信模板 niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/ae-smsTemplate", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<SmspMdlModel> smsTemplate() {
		Response<List<SmspMdlModel>> result = smsTemplateService.findAllSmsTemplate();
		if (!result.isSuccess()) {
			log.error("find.smsTemplate.error，error:{}", result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/look-mspCust", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<SmspCustModel> smspCust(@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size, Long id,Integer userType) {
		Response<Pager<SmspCustModel>> result = smsTemplateService.findByPager(pageNo, size, id, userType);
		if (!result.isSuccess()) {
			log.error("find.mspCust.error，error:{}", result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
		}
		// 对银行卡号进行加密
		Pager<SmspCustModel> smspCustModelPager = result.getResult();
		List<SmspCustModel> smspCustModelList = smspCustModelPager.getData();
		for (SmspCustModel smspCustModel : smspCustModelList) {
			String cardNum = smspCustModel.getCardNo();
			int length = cardNum.length();
			// 先这么做，待确认
			String cardNo = "";
			if (length < 7) {
				cardNo = "****";
			} else {
				cardNo = cardNum.substring(0, length - 6) + "****" + cardNum.substring(length - 2);
			}
			smspCustModel.setCardNo(cardNo);
		}
		smspCustModelPager.setData(smspCustModelList);
		return smspCustModelPager;
	}

	/**
	 * 商品以及短信模板信息查询
	 *
	 * @return SmspMdlDto 返回参数
	 */
	@RequestMapping(value = "/ae-findSmspMess", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public SmspMdlDto findSmspMess(String smspId, String itemCode) {

		SmspMdlDto resultDto = new SmspMdlDto();

		// 根据短信模板id查询短信内容开始
		Response<SmspMdlModel> smspMdlModelResponse = smsTemplateService.findSmspMess(smspId);
		if (!smspMdlModelResponse.isSuccess()) {
			log.error("find.smspMess.error，error:{}", smspMdlModelResponse.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(smspMdlModelResponse.getError()));
		}

		SmspMdlModel smspMdlModel = smspMdlModelResponse.getResult();
		// 根据短信模板id查询短信内容结束
		BeanMapper.copy(smspMdlModel, resultDto);

		//单品信息查询
		if (StringUtils.notEmpty(itemCode)) {
			// 查询单品Code
			Response<ItemModel> itemResp = itemService.findByMid(itemCode);// mid
			if (!itemResp.isSuccess() || null == itemResp.getResult()) {
				log.error("ItemService.findByMid()------------>find.item.error");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("find.item.error"));
			}
			//查询所需的单品
			Response<RecommendGoodsDto> recommendGoodsDtoResponse = goodsService.findItemInfoByItemCode(itemResp.getResult().getCode());
			if (!recommendGoodsDtoResponse.isSuccess()) {
				log.error("find.item.error，error:{}", recommendGoodsDtoResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500,
						messageSources.get(recommendGoodsDtoResponse.getError()));
			}
			RecommendGoodsDto recommendGoodsDto = recommendGoodsDtoResponse.getResult();
			if (recommendGoodsDto != null) {
				String[] goodsName = recommendGoodsDto.getGoodsName().split("/");//获取商品名称
				resultDto.setGoodsName(goodsName[0]);
				resultDto.setInstallmentNumber(
						GoodsCheckUtil.getMaxInstallmentNumber(recommendGoodsDto.getMaxInstallmentNumber()));
				resultDto.setPrice(recommendGoodsDto.getPrice());
			}
		}

		return resultDto;
//		log.error("find.smspMess.error");
//		throw new ResponseException(500, messageSources.get("find.smspMess.error"));
	}

	private static List<String> readImportFile(MultipartFile files) {
		List<String> readlines = Lists.newArrayList();
		// 1 文件读取
		Reader reader = null;
		BufferedReader bufferedReader = null;
		try {
			reader = new InputStreamReader(files.getInputStream(), "UTF-8");
			bufferedReader = new BufferedReader(reader);
			String strLine;
			// 将导入内容写入服务器
			while ((strLine = bufferedReader.readLine()) != null) {
				readlines.add(strLine);
			}

			bufferedReader.close();
			reader.close();
		} catch (IOException e) {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
		}
		return readlines;
	}

	private Response<Boolean> updateSms(Long id, String userId, String loadStatus) {
		// 短信模板导入状态
		final SmspInfModel smspInfModel = new SmspInfModel();
		smspInfModel.setId(id);
		smspInfModel.setLoadDatetime(new Date());
		smspInfModel.setModifyOper(userId);
		smspInfModel.setStatus(Contants.SMSP_CURSTATUS_0201);//待处理
		smspInfModel.setLoadStatus(loadStatus);// 导入中
		// 导入短信模板数据
		return smsTemplateService.update(smspInfModel);
	}

    /**
     * 白名单导入
     *
     * @param files
     * @param httpServletResponse
     */
    @RequestMapping(value = "/ae-nameListUpload", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
    @ResponseBody
    public String importNameList(MultipartFile files, HttpServletResponse httpServletResponse,
                                 @RequestParam(value = "id") Long id) {
		Map<String, Object> mapResult = Maps.newHashMap();
        String userId = UserUtil.getUser().getId();
        // 1 导入文件读取
		String filenm = files.getOriginalFilename();
		String ext = Files.getFileExtension(filenm).toLowerCase();
		if (!"txt".equals(ext)){
			throw new ResponseException(Contants.ERROR_CODE_500, "导入文件需要为txt文件");
		}
		try {
			files.transferTo(new File(fileUpBase + filenm));
		} catch (IOException e) {
			log.error("File upload.error,error: {}", Throwables.getStackTraceAsString(e));
			mapResult.put("resultFlag", Boolean.FALSE);
			return jsonMapper.toJson(mapResult);
		}

		// 2 数据库状态更新
        Response<Boolean> response = updateSms(id, userId, Contants.SMSP_LOAD_0201);
        if (!response.isSuccess()) {
            log.error("Response.error,error code: {}", response.getError());
            throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
        }
		String[] smsTmp = new String[]{filenm, id.toString(), userId};
		queueSender.send("shop.cgb.sms.upload", smsTmp);
        mapResult.put("resultFlag", Boolean.TRUE);
        return jsonMapper.toJson(mapResult);
    }

    /**
     * 创建文件夹
     *
     * @param path 路径
     */
    private void mkdir(String path) {
        File file = new File(path);
        if (!file.exists()) {
            boolean flag = file.mkdirs();
            if (!flag) {
                throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("mkdir.failed"));
            }
        }
    }

	/**
	 * 查询导入结果 niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/look-importResult", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<SmspRecordModel> importResult(@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size, Long id) {
		Response<Pager<SmspRecordModel>> result = smsTemplateService.findImportResult(pageNo, size, id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("find.importResult.error，error:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 短信模板审核白名单添加 niufw
	 *
	 * @param id
	 * @param phone
	 * @param cardNo
	 * @return
	 */
	@RequestMapping(value = "/audEdit-add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> auditCreateName(Long id, String phone, String cardNo) {
		// 从登录信息中获取用户id和用户名称并插入到model中
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String creatOper = user.getId();
		SmspCustModel smspCustModel = new SmspCustModel();
		smspCustModel.setId(id);
		smspCustModel.setPhone(phone);
		smspCustModel.setCardNo(cardNo);
		smspCustModel.setCreateOper(creatOper);
		smspCustModel.setUserType("1");
		try {
			// 新增
			Response<Boolean> result = smsTemplateService.addNameForAudit(smspCustModel);
			if (!result.isSuccess()) {
				log.error("create.name.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.name.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.name.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.name.error"));
		}
	}

	/**
	 * 审核页面白名单管理批量删除 niufw
	 *
	 * @param smspCustModelList
	 * @return
	 */
	@RequestMapping(value = "/audEdit-delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> deleteNameForAudit(@RequestBody SmspCustModel[] smspCustModelList) {
		try {
			// 提交
			Response<Integer> result = smsTemplateService.deleteNameForAudit(Arrays.asList(smspCustModelList));
			if (!result.isSuccess()) {
				log.error("delete.name.error，error:{}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.name.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.name.error，error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.name.error"));
		}
	}

	/**
	 *
	 * 审核页面短信发送
	 *
	 * @param smspInfDto 前台存储数据
	 * @return BaseResult 结果信息
	 */
	@RequestMapping(value = "/sendMessage", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean sendMessage(SmspInfDto smspInfDto) {
		User user = UserUtil.getUser();
		if (smspInfDto == null) {
			log.error("send.sms.error，error: smspInfDto is null");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("smspInfDto is null"));
		}
		// 点击白名单发送，改变短信模板当前状态为（0203-处理中）
		smspInfDto.setStatus(Contants.SMSP_CURSTATUS_0203);
		smspInfDto.setModifyOper(user.getId());
		// 提交
		Response<Boolean> response = smsTemplateService.sendMessage(smspInfDto);
		if (!response.isSuccess()) {
			log.error("send.sms.error，error:{}", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}

        return response.getResult();
    }

    /**
     * 失败名单文件下载 niufw
     *
     * @param response
     * @param fileName
     */
    @RequestMapping(value = "/look-exportImportResult", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public void exportGoodsData(HttpServletResponse response, String fileName) {
        OutputStream outputStream = null;
        InputStream inputStream = null;
        try {
            inputStream = new FileInputStream(fileDwBase + fileName);
            outputStream = response.getOutputStream();
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition",
                    "attachment;filename=" + new String(fileName.getBytes("UTF-8"), "iso8859-1") + ";target=_blank");
            IOUtils.copy(inputStream, outputStream);
            outputStream.flush();
        } catch (Exception e) {
            log.error("downLoad fail cause by{}", Throwables.getStackTraceAsString(e));
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (Exception e) {
                log.error("fail to close stream cause by{}", Throwables.getStackTraceAsString(e));
            }
        }
    }


    /**
     * 内容写出
     *
     * @param path
     * @param content
     */
    private static void write(String path, String content) {
        File f = new File(path);
        try (BufferedWriter output = new BufferedWriter(new FileWriter(f, true))) {
            output.write(content + "\r\n");
            output.close();
        } catch (Exception e) {
            log.error(Throwables.getStackTraceAsString(e));
        }
    }
}
