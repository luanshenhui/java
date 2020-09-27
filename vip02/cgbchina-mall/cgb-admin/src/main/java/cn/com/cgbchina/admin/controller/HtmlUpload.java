/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ZipUtil;
import cn.com.cgbchina.related.dto.TimeOutHtmlDto;
import cn.com.cgbchina.related.model.EsphtmInfModel;
import cn.com.cgbchina.related.service.HtmlUploadService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author wusy
 * @version 1.0
 * @Since 2016/7/13.
 */
@RequestMapping("/api/admin/html")
@Controller
@Slf4j
public class HtmlUpload {

	@Autowired
	private MessageSources messageSources;
	@Resource
	private HtmlUploadService htmlUploadService;
	// 新增路径
	@Value("#{app.htmlUploadUrl}")
	private String htmlUploadUrl;
	// 发布路径
	@Value("#{app.htmlPushUrl}")
	private String htmlPushUrl;

	/**
	 * 通过静态页
	 * 
	 * @param actId 静态页面代码
	 * @return
	 */
	@RequestMapping(value = "/audit-html", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean auditHtml(@RequestParam("actId") String actId, @RequestParam("operate") String operate) {

		// 参数校验
		if (Strings.isNullOrEmpty(actId)) {
			log.error("pass html error,cause:{}", "html.id.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.id.empty"));
		}
		if (Strings.isNullOrEmpty(operate)) {
			log.error("pass html error,cause:{}", "html.operate.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.operate.empty"));
		}

		User user = UserUtil.getUser();

		// 通过静态页
		EsphtmInfModel esphtmInfModel = new EsphtmInfModel();
		esphtmInfModel.setActId(actId);
		// 更新通过，状态变为待发布
		switch (operate) {
		case "pass":// 通过
			esphtmInfModel.setPublishStatus(Contants.PUBLISH_STATUS_01);
			break;
		case "refuse":// 拒绝
			esphtmInfModel.setPublishStatus(Contants.PUBLISH_STATUS_40);
			break;
		default:
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("unknown.operate"));
		}

		esphtmInfModel.setModifyOper(user.getId());
		Response res = htmlUploadService.update(esphtmInfModel);
		if (res.isSuccess()) {
			return Boolean.TRUE;
		}
		log.error("audit Html error,cause:{}", res.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
	}

	/**
	 * 静态页指定
	 * 
	 * @param actId 静态页面代码
	 * @param vendorId 指定人id
	 * @return
	 */
	@RequestMapping(value = "/assign", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean assignHtml(@RequestParam("actId") String actId, @RequestParam("vendorId") String vendorId) {
		// 参数校验
		if (Strings.isNullOrEmpty(actId)) {
			log.error("refuse html error,cause:{}", "html.id.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.id.empty"));
		}

		User user = UserUtil.getUser();

		// 指定静态页
		EsphtmInfModel esphtmInfModel = new EsphtmInfModel();
		esphtmInfModel.setActId(actId);
		if (!Strings.isNullOrEmpty(vendorId))
			esphtmInfModel.setVendorId(vendorId);
		esphtmInfModel.setPublishStatus(Contants.PUBLISH_STATUS_50);// 状态待上传
		esphtmInfModel.setModifyOper(user.getId());
		Response res = htmlUploadService.assignHtml(esphtmInfModel);
		if (res.isSuccess()) {
			return Boolean.TRUE;
		}
		log.error("assign Html error,cause:{}", res.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
	}

	/**
	 * 新建zip包上传
	 * 
	 * @param files 文件流
	 * @return String
	 */
	@RequestMapping(value = "/add-zip", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
	@ResponseBody
	public String zipAdd(MultipartFile files) {

		if (files.getSize() == 0) {
			log.error("add html error,cause:{}", "html.upload.object to empty error");
			return "fail-empty";
		}

		// 判断是不是zip
		String fileName = files.getOriginalFilename();
		int pos = fileName.lastIndexOf(".");
		String suffixName = fileName.substring(pos, fileName.length());
		if (!".zip".equals(suffixName)) {
			log.error("add html error,cause:{}", "html.upload.file not ZipFile error");
			return "fail-notZip";
		}

		// 判断文件名长度
		String prefixName = fileName.substring(0, pos);
		if (prefixName.length() > 8) {
			log.error("add html error,cause:{}", "html.upload.fileName to Long error");
			return "fail-tooLongName";
		}
		//不允许中文和特殊字符
		String regPattern = "^[0-9a-zA-Z\\-_~]*$";
		Pattern pat = Pattern.compile(regPattern);
		Matcher ma = pat.matcher(prefixName);
		if (!ma.matches()) {
			log.error("add html error,cause:{}", "html.upload.fileName to Long error");
			return "fail-gbkInName";
		}
		EsphtmInfModel esphtmInfModel = new EsphtmInfModel();
		esphtmInfModel.setActId(fileName.substring(0, pos));
		Response<EsphtmInfModel> response = htmlUploadService.findByActId(esphtmInfModel);
		if (!response.isSuccess()) {
			log.error("add html error,cause:{}", "html.find.error");
			return "fail-findError";
		}
		// 是否已经存在
		if (response.getResult() != null) {
			log.error("add html error,cause:{}", "html.info.exist");
			return "fail-findExist";
		}

		// 上传文件
		InputStream in = null;
		try {
			in = files.getInputStream();
			String filePath = htmlUploadUrl + fileName.substring(0, pos);
			log.info("-----------------" + filePath);
			File f1 = new File(filePath);
//			boolean bmkdirs = false;
//			if (!f1.isDirectory()) {
//				bmkdirs = f1.mkdirs();
//			}
//			if (!bmkdirs) {
//				log.error("add folder error,cause:{}", "create.folder.error");
//				return "fail-localExist";
//			}

			boolean bmkdirs = false;
			if (!f1.exists()) {
				bmkdirs = f1.mkdirs();//创建文件夹
			} else {
				Boolean flag = deleteDir(f1);
				if (flag) {//删除后创建新的文件夹
					bmkdirs = f1.mkdirs();
				}
			}

			if(!bmkdirs){
				log.error("upload folder error,cause:{}", "object.file.delete is fail,resource is using error");
				return "fail-localExist";
			}

			ZipUtil.unzip(filePath, in, null);
			return "success";
		} catch (IOException e) {
			// e.printStackTrace();
			log.error("IOException->:add html error,cause:{}", Throwables.getStackTraceAsString(e));
			return "fail-uploadFile";
		} catch (IllegalArgumentException e) {
			String errorMsg = Throwables.getStackTraceAsString(e);
			// 存在中文问题是因为java.util.zip下的格式转换有问题 ，jdk中的zip存在字符编码的问题 TODO 暂时无法解决，求解
			if (errorMsg.indexOf("MALFORMED") > 0) {
				log.error("IOException->:add html error,cause:{}", Throwables.getStackTraceAsString(e));
				return "fail-gbkInZip";
			}
			log.error("IllegalArgumentException->:add html error,cause:{}", Throwables.getStackTraceAsString(e));
			return "fail-uploadFile";
		} catch (Exception e) {
			// e.printStackTrace();
			log.error("Exception->:add html error,cause:{}", Throwables.getStackTraceAsString(e));
			return "fail-uploadFile";
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (Exception e) {
					log.error("add html error,cause:{}", e.getMessage());
				}
			}
		}
	}

	/**
	 * 新建静态页
	 *
	 * @param esphtmInfModel 静态页面信息
	 * @return Boolean
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean createHtml(EsphtmInfModel esphtmInfModel) {
		// 参数校验
		if (Strings.isNullOrEmpty(esphtmInfModel.getActId()) || Strings.isNullOrEmpty(esphtmInfModel.getActName())
				|| Strings.isNullOrEmpty(esphtmInfModel.getPageId()) || esphtmInfModel.getStartTime() == null
				|| esphtmInfModel.getEndTime() == null || Strings.isNullOrEmpty(esphtmInfModel.getOrdertypeId())) {
			log.error("create html error,cause:{}", "html.model.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.model.empty"));
		}

		Response<EsphtmInfModel> response = htmlUploadService.findByActId(esphtmInfModel);
		if (!response.isSuccess()) {
			log.error("create html error,cause:{}", "html.find.error");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}
		// 是否已经存在
		if (response.getResult() != null) {
			log.error("create html error,cause:{}", "html.info.exist");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.info.exist"));
		}
		User user = UserUtil.getUser();

		// 新增商城预留页
		esphtmInfModel.setPageType(Contants.HTML_PAGE_TYPE_05);
		esphtmInfModel.setCreateOper(user.getId());
		esphtmInfModel.setModifyOper(user.getId());
		esphtmInfModel.setActFilename(esphtmInfModel.getActId() + ".zip");
		esphtmInfModel.setBrowsePath(esphtmInfModel.getActId() + "/index.html");
		esphtmInfModel.setPublishStatus(Contants.PUBLISH_STATUS_01);

		// 添加静态页
		Response res = htmlUploadService.createHtml(esphtmInfModel);
		if (res.isSuccess()) {
			return Boolean.TRUE;
		}
		log.error("create html error,cause:{}", res.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));

	}

	/**
	 * 编辑zip包上传
	 * 
	 * @param files 文件流
	 * @return
	 */
	@RequestMapping(value = "/edit-zip", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
	@ResponseBody
	public String zipUpdate(MultipartFile files, String actId) {

		// 上传文件
		if (files.getSize() == 0) {
			log.error("upload html error,cause:{}", "html.upload.object to empty error");
			return "fail-empty";
		}

		// 判断是不是zip
		String fileName = files.getOriginalFilename();
		int pos = fileName.lastIndexOf(".");
		String name = fileName.substring(pos, fileName.length());
		if (!".zip".equals(name)) {
			log.error("upload html error,cause:{}", "html.upload.file not ZipFile error");
			return "fail-notZip";
		}

		// 判断文件名长度
		String prefixName = fileName.substring(0, pos);
		if (prefixName.length() > 8) {
			log.error("upload html error,cause:{}", "html.upload.fileName to Long error");
			return "fail-tooLongName";
		}
		//不允许中文和特殊字符
		String regPattern = "^[0-9a-zA-Z\\-_~]*$";
		Pattern pat = Pattern.compile(regPattern);
		Matcher ma = pat.matcher(prefixName);
		if (!ma.matches()) {
			log.error("add html error,cause:{}", "html.upload.fileName to Long error");
			return "fail-gbkInName";
		}
		// 是否已经存在
		if (!Objects.equals(actId, prefixName)) {
			log.error("edit html error,cause:{}", "html.fileName.not.equals.actId");
			return "fail-equalError";
		}

		try (InputStream in = files.getInputStream()){
			String filePath = htmlUploadUrl + fileName.substring(0, pos);
			File f1 = new File(filePath);

			boolean bmkdirs = false;
			if (!f1.exists()) {
				bmkdirs = f1.mkdirs();//创建文件夹
			} else {
				Boolean flag = deleteDir(f1);
				if (flag) {//删除后创建新的文件夹
					bmkdirs = f1.mkdirs();
				}
			}
			if(!bmkdirs){
				log.error("upload folder error,cause:{}", "object.file.delete is fail,resource is using error");
				return "fail-localExist";
			}

			ZipUtil.unzip(filePath, in, null);
			return "success";
		} catch (IOException e) {
			log.error("upload html error,cause:{}", Throwables.getStackTraceAsString(e));
			return "fail-uploadFile";
		} catch (IllegalArgumentException e) {
			String errorMsg = Throwables.getStackTraceAsString(e);
			// 存在中文问题是因为java.util.zip下的格式转换有问题 ，jdk中的zip存在字符编码的问题 TODO 暂时无法解决，求解
			if (errorMsg.indexOf("MALFORMED") > 0) {
				log.error("IOException->:upload html error,cause:{}", Throwables.getStackTraceAsString(e));
				return "fail-gbkInZip";
			}
			log.error("IllegalArgumentException->:upload html error,cause:{}", Throwables.getStackTraceAsString(e));
			return "fail-uploadFile";
		} catch (Exception e) {
			log.error("Exception->:upload html error,cause:{}", Throwables.getStackTraceAsString(e));
			return "fail-uploadFile";
		}
	}

	/**
	 * 上传页指定 修改
	 * 
	 * @param esphtmInfModel 静态页面信息
	 * @return
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateHtml(EsphtmInfModel esphtmInfModel) {
		// 参数校验
		if (Strings.isNullOrEmpty(esphtmInfModel.getActId()) || Strings.isNullOrEmpty(esphtmInfModel.getActName())
				|| esphtmInfModel.getStartTime() == null || esphtmInfModel.getEndTime() == null) {
			log.error("update html error,cause:{}", "html.model.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.model.empty"));
		}
		User user = UserUtil.getUser();

		esphtmInfModel.setModifyOper(user.getId());
		esphtmInfModel.setPublishStatus(Contants.PUBLISH_STATUS_01);
		esphtmInfModel.setActFilename(esphtmInfModel.getActId() + ".zip");
//		esphtmInfModel.setBrowsePath(esphtmInfModel.getActId() + "/" + esphtmInfModel.getActId() + ".html");

		// 上传静态页
		Response res = htmlUploadService.updateHtml(esphtmInfModel);
		if (res.isSuccess()) {
			return Boolean.TRUE;
		}

		log.error("create html error,cause:{}", res.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));

	}

	/**
	 * 发布
	 * 
	 * @param actId 静态页面代码
	 * @return
	 */
	@RequestMapping(value = "/publish/{actId}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean publishHtml(@PathVariable("actId") String actId) {
		// 参数校验
		if (Strings.isNullOrEmpty(actId)) {
			log.error("update html error,cause:{}", "html.model.empty");
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.model.empty"));
		}
		String tempUrl = htmlUploadUrl + "/" + actId;
		String publishUrl = htmlPushUrl + "/" + actId;
		File tempFile = new File(tempUrl); // 临时文件
		File publishFile = new File(publishUrl); // 发布文件

		// 存在 则删除 已经发布过的文件
		if (publishFile.exists()) {
			Boolean flag = deleteDir(publishFile);
			if (!flag) {
				log.error("upload folder error,cause:{}", "object.file.delete is fail,resource is using error");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.folder.error"));
			}
		}

		try {
			FileUtils.copyDirectory(tempFile, publishFile);
		} catch (IOException e) {
			log.error("create html error,cause:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("html.publish.error"));
		}

		User user = UserUtil.getUser();

		// 发布静态页
		EsphtmInfModel esphtmInfModel = new EsphtmInfModel();
		esphtmInfModel.setActId(actId);
		// 更新发布，状态变为已发布
		esphtmInfModel.setPublishStatus(Contants.PUBLISH_STATUS_00);
		esphtmInfModel.setModifyOper(user.getId());

		Response res = htmlUploadService.update(esphtmInfModel);
		if (res.isSuccess()) {
			// 发布成功则 删除临时文件
//			Boolean flag = deleteDir(tempFile);
//			if (!flag) {
//				log.error("upload folder error,cause:{}", "object.file.delete is fail,resource is using error");
//				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.folder.error"));
//			}
			return Boolean.TRUE;
		} else {
			// 发布失败则 删除发布文件
			Boolean flag = deleteDir(publishFile);
			if (!flag) {
				log.error("upload folder error,cause:{}", "object.file.delete is fail,resource is using error");
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("create.folder.error"));
			}
		}
		log.error("create html error,cause:{}", res.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
	}

	/**
	 * 查询将要过期和已过期的数据
	 *
	 * @return 过期数据
	 */
	@RequestMapping(value = "/findEndHtml", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public TimeOutHtmlDto findEndHtml() {
		// 查询将要过期和已过期的数据
		EsphtmInfModel esphtmInfModel = new EsphtmInfModel();
		Response<List<EsphtmInfModel>> res = htmlUploadService.findEndHtml(esphtmInfModel);
		if (!res.isSuccess()) {
			log.error("findEndHtml html error,cause:{}", res.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
		}

		List<EsphtmInfModel> list = res.getResult();
		// 返回数据
		return checkTimeEndHtml(list);
	}

	/**
	 * 过期数据判断，距离结束时间还有15天为即将过期，已经超过结束时间为已经过期
	 * 
	 * @param list 数据库查询数据
	 * @return 过期数据
	 */
	private TimeOutHtmlDto checkTimeEndHtml(List<EsphtmInfModel> list) {
		TimeOutHtmlDto dto = new TimeOutHtmlDto();
		List<String> timeEndList = new ArrayList<>();// 已经过期
		List<String> timeEndingList = new ArrayList<>();// 即将过期
		try {
			for (EsphtmInfModel model : list) {
				Date dt = new Date();
				if (model.getEndTime() != null) {
					long time = model.getEndTime().getTime() - dt.getTime();
					double timeout = time / (1000D * 60D * 60D * 24D);
					// 过期的情况下
					if (timeout < 0) {
						timeEndList.add(model.getActId());
						continue;
					}
					if (timeout <= 15) {
						timeEndingList.add(model.getActId());
					}
				}
			}
			dto.setTimeEndList(timeEndList);
			dto.setTimeEndingList(timeEndingList);
			return dto;
		} catch (Exception e) {
			log.error("find html time out error,cause:{}", e);
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get("findEndHtml.html.error"));
		}

	}

	@RequestMapping(value = "/delHtml/{actId}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean delHtml(@PathVariable("actId") String actId, @RequestParam("status") String status) {
		if (Strings.isNullOrEmpty(actId)) {
			throw new ResponseException("actId.is.null");
		}
		if (Strings.isNullOrEmpty(status)) {
			throw new ResponseException("status.is.null");
		}

		String userId = UserUtil.getUser().getId();

		String filePath;
		if (Contants.PUBLISH_STATUS_00.equals(status)) {
			filePath = htmlPushUrl + actId;
		} else {
			filePath = htmlUploadUrl + actId;
		}

		File f1 = new File(filePath);
		if (f1.exists()) {
			Boolean flag = deleteDir(f1);
			if (!flag) {
				log.error("upload folder error,cause:{}", "object.file.delete is fail,resource is using error");
				return Boolean.FALSE;
			}
		}
		// EsphtmInfModel esphtmInfModel = new EsphtmInfModel();
		// esphtmInfModel.setActId(actId);
		// esphtmInfModel.setModifyOper(userId);
		// esphtmInfModel.setDelFlag(Contants.DEL_INTEGER_FLAG_1);// 删除
		Response res = htmlUploadService.delByActId(actId);

		if (res.isSuccess()) {
			return Boolean.TRUE;
		}

		log.error("create html error,cause:{}", res.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(res.getError()));
	}

	/**
	 * 递归删除 文件、文件夹
	 *
	 * @param dir
	 * @return
	 */
	private static boolean deleteDir(File dir) {
		if (dir.isDirectory()) {
			File[] children = dir.listFiles();
			// 递归删除目录中的子目录下
			for (int i = 0; i < children.length; i++) {
				boolean success = deleteDir(children[i]);
				if (!success) {
					return false;
				}
			}
		}
		// 目录此时为空，可以删除
		return dir.delete();
	}

	public static void main(String[] a) {
		boolean flag = deleteDir(new File("C:\\mmc\\activity\\11111111111111111"));
		System.out.print(flag);
	}
}
