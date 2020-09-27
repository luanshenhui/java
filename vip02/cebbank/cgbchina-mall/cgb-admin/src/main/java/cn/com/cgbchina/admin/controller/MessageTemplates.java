/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import java.io.*;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.related.model.SmspRecordModel;
import org.elasticsearch.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.item.dto.RecommendGoodsDto;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.dto.SmspMdlDto;
import cn.com.cgbchina.related.model.SmspCustModel;
import cn.com.cgbchina.related.model.SmspInfModel;
import cn.com.cgbchina.related.model.SmspMdlModel;
import cn.com.cgbchina.related.service.SmsTemplateService;
import lombok.extern.slf4j.Slf4j;

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
	SmsTemplateService smsTemplateService;

	@Autowired
	MessageSources messageSources;

	@Autowired
	GoodsService goodsService;

	@Autowired
	ItemService itemService;

	/**
	 * 短信模板管理添加 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateCreate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> create(SmspInfModel smspInfModel) {
		// 从登录信息中获取用户id和用户名称并插入到model中
		User user = UserUtil.getUser();
		String creatOper = user.getName();
		smspInfModel.setCreateOper(creatOper);
		// 校验
		try {
			// 校验
			// 新增
			Response<Boolean> result = smsTemplateService.create(smspInfModel);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.error"));
		}
	}

	/**
	 * 短信模板管理编辑 niufw
	 *
	 * @param smspInfModel
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateUpdate", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(SmspInfModel smspInfModel) {
		// 从登录信息中获取用户id和用户名称并插入到model中
		User user = UserUtil.getUser();
		String modifyOper = user.getName();
		smspInfModel.setModifyOper(modifyOper);
		// 校验
		try {
			// 校验
			// 编辑
			Response<Boolean> result = smsTemplateService.update(smspInfModel);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.error"));
		}
	}

	/**
	 * 短信模板管理删除 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateDelete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(Long id) {
		Response<Boolean> result = new Response<Boolean>();
		// 校验
		try {
			// 校验

			// 删除
			result = smsTemplateService.delete(id);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("delete.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("delete.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("delete.error"));
		}
	}

	/**
	 * 短信模板管理提交 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateSubmit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> submit(Long id) {
		Response<Boolean> result = new Response<Boolean>();
		// 校验
		try {
			// 校验

			// 提交
			result = smsTemplateService.submit(id);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("submit.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("submit.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("submit.error"));
		}
	}

	/**
	 * 短信模板管理审核 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateCheck", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> smsTemplateCheck(Long id) {
		Response<Boolean> result = new Response<Boolean>();
		// 校验
		try {
			// 校验

			// 审核
			result = smsTemplateService.smsTemplateCheck(id);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("check.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("check.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("check.error"));
		}
	}

	/**
	 * 短信模板管理拒绝 niufw
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateRefuse", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> smsTemplateRefuse(Long id) {
		Response<Boolean> result = new Response<Boolean>();
		// 校验
		try {
			// 校验

			// 拒绝
			result = smsTemplateService.smsTemplateRefuse(id);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("refuse.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("refuse.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("refuse.error"));
		}
	}

	/**
	 * 短信模板管理批量提交 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateSubmitAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> submitAll(@RequestBody SmspInfModel[] smspInfModelList) {
		Response<Integer> result = new Response<Integer>();
		// 校验
		try {
			// 校验

			// 提交
			result = smsTemplateService.submitAll(Arrays.asList(smspInfModelList));
			return result;
		} catch (IllegalArgumentException e) {
			log.error("submit.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("submit.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("submit.error"));
		}
	}

	/**
	 * 短信模板管理批量删除 niufw
	 *
	 * @param smspInfModelList
	 * @return
	 */
	@RequestMapping(value = "/messageTemplateDeleteAll", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Integer> deleteAll(@RequestBody SmspInfModel[] smspInfModelList) {
		Response<Integer> result = new Response<Integer>();
		// 校验
		try {
			// 校验

			// 提交
			result = smsTemplateService.deleteAll(Arrays.asList(smspInfModelList));
			return result;
		} catch (IllegalArgumentException e) {
			log.error("submit.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("submit.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("submit.error"));
		}
	}

	/**
	 * 查询所有的短信模板 niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/smsTemplate", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<SmspMdlModel> smsTemplate() {
		Response<List<SmspMdlModel>> result = smsTemplateService.findAllSmsTemplate();
		if (!result.isSuccess()) {
			log.error("find smsTemplate failed, cause:{}", result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}

	/**
	 * 查询所有的短信客户群(名单预览) niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/mspCust", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<SmspCustModel> smspCust(@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size, Long id) {
		Response<Pager<SmspCustModel>> result = smsTemplateService.findByPager(pageNo, size, id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to selectMspCust,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 查询短信信息 niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/findSmspMess", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public SmspMdlDto findSmspMess(String smspId, String itemCode) {
		Response<SmspMdlDto> result = new Response<SmspMdlDto>();
		SmspMdlDto smspMdlDto = new SmspMdlDto();
		// 根据短信模板id查询短信内容开始
		Response<SmspMdlModel> smspMdlModelResponse = smsTemplateService.findSmspMess(smspId);
		SmspMdlModel smspMdlModel = smspMdlModelResponse.getResult();
		// 根据短信模板id查询短信内容结束
		BeanMapper.copy(smspMdlModel, smspMdlDto);

		if (StringUtils.notEmpty(itemCode)) {
			// 查询单品名称开始
			Response<RecommendGoodsDto> recommendGoodsDtoResponse = goodsService.findItemInfoByItemCode(itemCode);
			if (recommendGoodsDtoResponse.getResult() != null) {
				RecommendGoodsDto recommendGoodsDto = recommendGoodsDtoResponse.getResult();
				smspMdlDto.setGoodsName(recommendGoodsDto.getGoodsName());
			}
			// 查询单品名称结束
			// 查询单品价格、期数开始
			ItemModel itemModel = itemService.findItemDetailByCode(itemCode);
			BigDecimal price = itemModel.getPrice();
			String periods = itemModel.getInstallmentNumber();
			// 定义数组存放所有分期数用来查找最大分期数(最少会有一个分期，故此处就不添加非空判断了)
			String[] periodsArr = new String[50];
			periodsArr = periods.split(",");
			String stage = periodsArr[0];
			for (int i = 0; i < periodsArr.length; i++) {
				if (Integer.parseInt(periodsArr[i]) > Integer.parseInt(stage)) {
					stage = periodsArr[i];
				}
			}
			Integer installmentNumber = Integer.parseInt(stage);
			smspMdlDto.setInstallmentNumber(installmentNumber);
			smspMdlDto.setPrice(price);
			// 根查询单品价格、期数结束
		}
		result.setResult(smspMdlDto);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to selectMspCust,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 名单导入(测试通过，正式备用)
	 *
	 * @param files
	 * @param httpServletResponse
	 */
//	@RequestMapping(value = "/nameListUpload", method = RequestMethod.POST)
//	public void importNameList(MultipartFile files, HttpServletResponse httpServletResponse,
//			@RequestParam(value = "id") Long id) {
//		User user = UserUtil.getUser();
//		if (user == null) {
//			throw new UserNotLoginException("user.not.login");
//		}
//		String createOper = user.getName();
//        //获取时间戳开始
//        Date date = new Date();
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
//        String fileName = sdf.format(date);
//        //获取时间戳结束
//		FileOutputStream out = null;
//		InputStream inputStream = null;
//		BufferedReader bufferedReader = null;
//		try {
//			inputStream = files.getInputStream();
//			bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
//			String temp = "";
//			out = new FileOutputStream(new File("D:/cgbtemp/smsupload/"+fileName+".txt"));
//			// 读一行写一行
//			while ((temp = bufferedReader.readLine()) != null) {
//                temp =id +"|"+ temp + "|"+ createOper ;
//				out.write(temp.getBytes());
//				out.write("\r\n".getBytes());
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			try {
//				inputStream.close();
//				bufferedReader.close();
//				out.close();
//			} catch (Exception e) {
//
//				e.printStackTrace();
//
//			}
//		}
//	}


	/**
	 * 名单导入
	 *
	 * @param files
	 * @param httpServletResponse
	 */
	@RequestMapping(value = "/nameListUpload", method = RequestMethod.POST)
	public void importNameList(MultipartFile files, HttpServletResponse httpServletResponse,
							   @RequestParam(value = "id") Long id) {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException("user.not.login");
		}
		String createOper = user.getName();

		String fileUpBasePath = "D:/cgbtemp/smsupload/";
		String fileDwBasePath = "D:/cgbtemp/smsdownload/";
		//文件流声明
		FileOutputStream out = null;
		FileOutputStream outFail = null;
		InputStream inputStream = null;
		BufferedReader bufferedReader = null;
		//导入信息
		List<SmspCustModel> smspCustModelList = Lists.newArrayList();
		//导入失败信息
		List<SmspCustModel> smspCustModelFail = Lists.newArrayList();
		//获取时间戳
		String fileName = DateHelper.getCurrentTimess();
		try {
			//读取文件，获取导入信息
			inputStream = files.getInputStream();
			bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
			String temp = "";
			//上传文件路径
			out = new FileOutputStream(new File(fileUpBasePath+fileName+".txt"));
			//插入失败文件
			String filePath = fileDwBasePath+fileName+".txt";
			outFail = new FileOutputStream(new File(filePath));
			// 将导入内容写入服务器
			while ((temp = bufferedReader.readLine()) != null) {
				String[] arry = {};
				SmspCustModel smspCustModel = new SmspCustModel();
				temp =id +"|"+ temp + "|"+ createOper ;
				out.write(temp.getBytes());
				out.write("\r\n".getBytes());
				//进行数据操作
				arry = temp.split("\\|");
				smspCustModel.setId(Long.parseLong(arry[0]));
				smspCustModel.setPhone(arry[1]);
				smspCustModel.setCardNo(arry[2]);
				smspCustModel.setCreateOper(arry[3]);
				smspCustModelList.add(smspCustModel);
			}

			//导入短信模板数据 (异步)
			Response<List<SmspCustModel>> response = smsTemplateService.createCust(smspCustModelList, id, createOper,filePath);
			//导入结果-成功：失败
			smspCustModelFail = response.getResult();
			//如果有导入失败的数据
			if(smspCustModelFail.size() > 0){
				//在服务器上写失败文件
				for(SmspCustModel smspCustModel : smspCustModelFail){
					String fileFail = smspCustModel.getId() + "|" +smspCustModel.getPhone() + "|" +
							smspCustModel.getCardNo() +"|" + smspCustModel.getCreateOper();
					outFail.write(fileFail.getBytes());
					outFail.write("\r\n".getBytes());
				}

			}else{//导入成功
				String fileFail = "全部数据导入成功！";
				outFail.write(fileFail.getBytes());
			}
//TODO
//			if(response.isSuccess()){
//
//			}else {
//				response.getError();
//				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("pwd.control.error"));
//			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				inputStream.close();
				bufferedReader.close();
				out.close();
				outFail.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 查询导入结果 niufw
	 *
	 * @return
	 */
	@RequestMapping(value = "/importResult", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<SmspRecordModel> importResult(@RequestParam(value = "pageNo", required = false) Integer pageNo,
										 @RequestParam(value = "size", required = false) Integer size, Long id) {
		Response<Pager<SmspRecordModel>> result = smsTemplateService.findImportResult(pageNo, size, id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to selectImportResult,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}
}
