package cn.rkylin.apollo.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.rkylin.apollo.common.util.CookiesUtil;
import cn.rkylin.apollo.common.util.PropertiesUtils;
import cn.rkylin.apollo.service.ProjectRuleAttachService;
import cn.rkylin.apollo.service.ProjectRuleService;
import cn.rkylin.apollo.system.domain.UserInfo;
import cn.rkylin.apollo.utils.FileUtil;
import cn.rkylin.core.ApolloMap;
import cn.rkylin.core.controller.AbstractController;

/**
 * Created by Admin on 2016/7/8.
 */
@Controller
@RequestMapping("/project/rule")
public class ProjectRuleController extends AbstractController {
	private static final Log log = LogFactory.getLog(ProjectRuleController.class);
	private static final String remotePath = PropertiesUtils.getVal("uploadDir");
	// private static final String FORMAT_YMD_HMS = "yyyyMMddHHmmss";
	//private static final String FILE_URL = "D:/zipSettlementFile/";

	@Autowired
	public ProjectRuleService projectRuleService;
	@Autowired
	ProjectRuleAttachService projectRuleAttachService;

	/**
	 * 增加结算规则
	 * 
	 * @param request
	 * @param files
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/addProjectRule")
	@ResponseBody
	public Map<String, Object> addProjectRule(HttpServletRequest request, @RequestParam("file") MultipartFile[] files)
			throws Exception {
		HttpSession session = request.getSession();
		UserInfo user = (UserInfo) session.getAttribute("_userInfo");
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		if (null != user) {
			params.put("user_id", user.getUserid());
			params.put("user_name", user.getUserName());
		}
		projectRuleService.addProjectRule(params, files);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "新增成功！");
		return retMap;
	}

	/**
	 * 修改结算规则
	 * 
	 * @param request
	 * @param files
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateProjectRule")
	@ResponseBody
	public Map<String, Object> updateProjectRule(HttpServletRequest request,
			@RequestParam("file") MultipartFile[] files) throws Exception {
		UserInfo user = CookiesUtil.getUserCookies(request);
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		if (null != user) {
			params.put("user_id", user.getUserid());
			params.put("user_name", user.getUserName());
		}
		projectRuleService.updateProjectRule(params, files);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "修改成功！");
		return retMap;
	}

	/**
	 * 检测本地文件关系表中的文件是否有效状态再检测服务器上是否有此文件 只要文件关系表中还存在有效文件就认为可以下载。
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/projectRuleFilesExist")
	@ResponseBody
	public Map<String, Object> projectRuleFilesExist(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		List<Map<String, Object>> projectRuleAttachList = projectRuleAttachService.findProjectRuleAttach(params);
		if (null != projectRuleAttachList && projectRuleAttachList.size() > 0) {
			for (Map<String, Object> fileMap : projectRuleAttachList) {
				if (null != fileMap.get("FILE_NAME")) {
					String fileNmae = String.valueOf(fileMap.get("FILE_NAME"));
					if (!FileUtil.checkFileExistByName(null, fileNmae)) {
						log.info("检查服务器上不存在此文件==" + fileNmae);
					}
				}
			}
			retMap.put("resultId", 1);
		} else {
			retMap.put("resultId", 0);
			retMap.put("resultDescription", "此规则没有要下载的文件或者已删除！");
		}
		return retMap;
	}

	/**
	 * 下载结算规则文件 2个以上的文件打包后再下载，1个直接下载
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/projectRuleFilesDownload")
	@ResponseBody
	public void projectRuleFilesDownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String contentType = null;
		try {
			ApolloMap<String, Object> params = getParams(request);
			List<Map<String, Object>> projectRuleAttachList = projectRuleAttachService.findProjectRuleAttach(params);
			List<File> fileList = new ArrayList<File>();
			if (null != projectRuleAttachList) {
				if (projectRuleAttachList.size() > 1) {
					StringBuffer zipName = new StringBuffer();
					for (Map<String, Object> fileMap : projectRuleAttachList) {
						if (null != fileMap.get("FILE_NAME") && null != fileMap.get("UPLOAD_PATH")) {
							String fileName = String.valueOf(fileMap.get("FILE_NAME"));
							String uploadPath = String.valueOf(fileMap.get("UPLOAD_PATH"));
							File file = new File(uploadPath, fileName); // 创建文件对象
							fileList.add(file);
						}
					}
					// 打包下载
					/*
					 * 一个结算规则有多个文件，文件可能增多或减少，每次下载都会先打包上传到指定路径
					 * 点击下载会根据结算规则ID去路径中找属于自己的包文件。 String currentDate =
					 * DateUtils.getFormatDateStr(new Date(), FORMAT_YMD_HMS);
					 * zipName.append(currentDate);
					 */
					zipName.append(null != params.get("ruleId") ? String.valueOf(params.get("ruleId")) : "");
					zipName.append(".zip");
					File dir = new File(remotePath);
					if (!dir.exists()) {
						dir.mkdir();
					}
					String remotePathFile = remotePath + zipName.toString();
					FileUtil.zipFiles(fileList, remotePathFile);
					contentType = "application/octet-stream; charset=utf-8";
					FileUtil.download(request, response, remotePathFile, contentType, "结算规则.zip");

				} else {
					if (projectRuleAttachList.size() == 1) {
						String fileSuffixName = null;
						String fileName = null;
						String strName = null;
						if (null != projectRuleAttachList.get(0).get("FILE_NAME")) {
							fileName = String.valueOf(projectRuleAttachList.get(0).get("FILE_NAME"));
							fileSuffixName = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
							int strIndex = fileName.lastIndexOf(".");
							strName = fileName.substring(0, strIndex);
							if (StringUtils.isEmpty(strName)) {
								strName = fileName;
							}
						}
						// 支持主流
						if ("pdf".equals(fileSuffixName)) {
							contentType = "application/pdf";
						} else if ("doc".equals(fileSuffixName) || "docx".equals(fileSuffixName)) {
							contentType = "application/msword";
						} else if ("xlsx".equals(fileSuffixName) || "xls".equals(fileSuffixName)) {
							contentType = "application/vnd.ms-excel";
						} else if ("txt".equals(fileSuffixName)) {
							contentType = "text/plain";
						} else if ("bmp".equals(fileSuffixName)) {
							contentType = "image/bmp";
						} else if ("gif".equals(fileSuffixName)) {
							contentType = "image/gif";
						} else if ("jpeg".equals(fileSuffixName)) {
							contentType = "image/jpeg";
						}
						String remotePathFile = remotePath + "/" + fileName;
						FileUtil.download(request, response, remotePathFile, contentType, fileName);
					}
				}
			}
		} catch (Exception e) {
			log.error("结算规则下载附件异常！", e);
		}
	}

	/**
	 * 删除结算规则
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateProjectRuleStatus")
	@ResponseBody
	public Map<String, Object> updateProjectUserStatus(HttpServletRequest request) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		int r = projectRuleService.updateProjectRuleStatus(params);
		if (r > 0) {
			projectRuleAttachService.updateProjectRuleAttach(params);
		}
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "删除成功！");
		return retMap;
	}

	/**
	 * 删除结算上传的文件关系表数据
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/updateProjectRuleAttach")
	@ResponseBody
	public Map<String, Object> updateProjectRuleAttach(HttpServletRequest request) throws Exception {
		Map<String, Object> retMap = new HashMap<String, Object>();
		ApolloMap<String, Object> params = getParams(request);
		projectRuleAttachService.updateProjectRuleAttach(params);
		retMap.put("resultId", 1);
		retMap.put("resultDescription", "删除成功！");
		return retMap;
	}
}
