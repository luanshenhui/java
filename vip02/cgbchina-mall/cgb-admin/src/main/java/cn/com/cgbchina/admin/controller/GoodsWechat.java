package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.item.dto.UploadItemWeChatDto;
import cn.com.cgbchina.item.service.ItemWechatService;
import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.io.Files;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.filefilter.FalseFileFilter;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by Tanliang 微信商品管理
 *
 * @time:2016-6-14
 */
@Controller
@RequestMapping("/api/admin/GoodsWeChat") // 请求映射
@Slf4j
public class GoodsWechat {
	@Autowired
	private ItemWechatService itemWeChatService;
	@Autowired
	private MessageSources messageSources;

	private final static Set<String> allowed_types = ImmutableSet.of("xlsx", "xls");

	private JsonMapper jsonMapper = JsonMapper.JSON_NON_EMPTY_MAPPER;

	private String rootFilePath;

	public GoodsWechat() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	/**
	 * 编辑微信商品（更改排序）
	 *
	 * @param wxOrder
	 * @return
	 */
	@RequestMapping(value = "/editItemWeChat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean editItemWeChat(Long wxOrder, String code) {
		try {
			Response<Boolean> result = itemWeChatService.editItemWeChat(wxOrder, code);
			if(!result.isSuccess()){
				log.error("Response.error,error code: {}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
			return result.getResult();
		} catch (Exception e) {
			log.error("updateProduct.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("update.error"));
		}
	}

	/**
	 * 删除微信商品
	 *
	 * @return
	 */
	@RequestMapping(value = "/deleteItemWeChat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean deleteItemWeChat(String code) {
		Response<Boolean> result = itemWeChatService.deleteItemWechate(code);
		if(!result.isSuccess()){
			log.error("Response.error,error code: {}", result.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}

	/**
	 * 下载模板
	 *
	 * @param request
	 * @param response
	 * @throws java.io.IOException
	 */
	@ResponseBody
	@RequestMapping(value = "/outWeChatTemplate", method = RequestMethod.GET)
	public void downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws IOException {
		try {
			String path = rootFilePath + "/template/wechat_goods.xls";
			File file = new File(path);
			// 下载文件中文名转换
			String fileName = Contants.WECHAT_ITEM_EXCEL;
			fileName = URLEncoder.encode(fileName, "UTF-8");
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(path));
			byte[] buffer = new byte[1024];
			// 清空response
			response.reset();
			// 设置response的Header
			response.addHeader("Content-Disposition", "attachment;filename=" + new String(fileName.getBytes()));
			response.addHeader("Content-Length", "" + file.length());
			OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
			response.setContentType("application/octet-stream");
			int len;
			while ((len = fis.read(buffer)) > 0) {
				toClient.write(buffer, 0, len);
			}
			fis.close();
			toClient.flush();// 提交文件流
			toClient.close();
		} catch (IOException e) {
			response.sendError(404);
			e.printStackTrace();
		}
	}

	/**
	 * <p>
	 * 微信商品信息 上传
	 * <p/>
	 *
	 * @param files 上传对象
	 * @param request 请求对象
	 * @return String 返回结果信息
	 */
	@RequestMapping(value = "/uploadItemWeChat", method = RequestMethod.POST, produces = MediaType.TEXT_HTML_VALUE)
	@ResponseBody
	public String uploadItemWeChat(MultipartFile files, HttpServletRequest request) {
		Map<String, Object> mapResult = Maps.newHashMap();
		User user = UserUtil.getUser();

		if (null == files) {
			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "fileNotExist");
			return jsonMapper.toJson(mapResult);
		}

		// 获取上传文件名
		String fileName = files.getOriginalFilename();
		String ext = Files.getFileExtension(fileName).toLowerCase();
		if (!allowed_types.contains(ext)) {
			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "fileIllegalExt");
			return jsonMapper.toJson(mapResult);
		}
		String userAgent = request.getHeader("User-Agent");

		String relativeFilePath = rootFilePath + "/tempfile/" + fileName;
		String configPath = rootFilePath + "/config/wechat_goods.xml";
		String resultFile = rootFilePath + "/template/wechat_goods_export.xls";

		File file = new File(relativeFilePath);

		if (file.exists()) {
			boolean flag = file.delete();
			if (!flag) {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "deleteExistFile");
				return jsonMapper.toJson(mapResult);
			}
		}
		try (InputStream configInput = new FileInputStream(configPath); // 导入 配置模板
				FileInputStream OutfileInput = new FileInputStream(resultFile); // 输出模板
				FileOutputStream fileOutputStream = new FileOutputStream(relativeFilePath); // 导出路径
				InputStream uploadFile = files.getInputStream()) {

			// User user = UserUtil.getUser();
			Map<String, Object> dataBeans = com.google.common.collect.Maps.newHashMap();
			List<UploadItemWeChatDto> details = Lists.newArrayList();
			dataBeans.put("wechatItems", details);
			ExcelUtil.importExcelToData(dataBeans, uploadFile, configInput);
			if (details.isEmpty()) {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "emptyFile");
				return jsonMapper.toJson(mapResult);
			}
			Response<Map<String, Object>> result = itemWeChatService.uploadItemWeChat(details, user);
			if (result.isSuccess()) {
				exportTempFileExcel(OutfileInput, fileOutputStream, result);
				String new_filename = URLEncoder.encode(files.getOriginalFilename(), "UTF-8");

				// 如果没有UA，则默认使用IE的方式进行编码
				String rtn = new_filename;
				if (userAgent != null) {
					userAgent = userAgent.toLowerCase();
					// IE浏览器，只能采用URLEncoder编码
					if (userAgent.contains("msie")) {
						rtn = new_filename;
					}
					// Safari浏览器，只能采用ISO编码的中文输出
					else if (userAgent.contains("safari")) {
						rtn = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
					}
					// Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
					else if (userAgent.contains("applewebkit")) {
						rtn = new_filename;
					}
					// ie11
					else if (userAgent.contains("mozilla") && !userAgent.contains("firefox")) {
						rtn = new_filename;
						// 火狐
					} else if (userAgent.contains("firefox") && userAgent.contains("mozilla")) {
						rtn = new String(fileName.getBytes("UTF-8"), "ISO8859-1");
					}
				}
				mapResult.put("isImportSuccess", result.getResult().get("isImportSuccess"));
				mapResult.put("isSuccess", Boolean.TRUE);
				mapResult.put("fileName", rtn);
			} else {
				mapResult.put("isSuccess", Boolean.FALSE);
				mapResult.put("errorCode", "updateData");
				return jsonMapper.toJson(mapResult);
			}
		} catch (RuntimeException e) {
			log.error("import.goods.wechat.xls.error, error:{}", Throwables.getStackTraceAsString(e));

			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "unKnownError");
			mapResult.put("errorMsg", Throwables.getStackTraceAsString(e));
			return jsonMapper.toJson(mapResult);
		} catch (Exception e) {
			log.error("import.goods.wechat.xls.error, error:{}", Throwables.getStackTraceAsString(e));

			mapResult.put("isSuccess", Boolean.FALSE);
			mapResult.put("errorCode", "unKnownError");
			mapResult.put("errorMsg", Throwables.getStackTraceAsString(e));
			return jsonMapper.toJson(mapResult);
		}
		return jsonMapper.toJson(mapResult);
	}

	/**
	 * 生成文件
	 * 
	 * @param fileInputStream
	 * @param fileOutputStream
	 * @param response
	 * @throws IOException
	 * @throws InvalidFormatException
	 */
	private void exportTempFileExcel(FileInputStream fileInputStream, FileOutputStream fileOutputStream,
			Response<Map<String, Object>> response) throws IOException, InvalidFormatException {
		Map<String, Object> mapData = Maps.newHashMap();
		Map<String, Object> resultMap = response.getResult();
		mapData.put("wechatItems", resultMap.get("uploadItemWeChatDtos"));
		Workbook workbook = WorkbookFactory.create(fileInputStream);
		ExportUtils.exportTemplate(workbook, mapData);
		workbook.write(fileOutputStream);
		fileOutputStream.flush();
	}

	/**
	 * 导出文件
	 *
	 * @param response
	 * @author zhoupeng
	 */
	@RequestMapping(value = "/exportFile", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public void exportExcel(HttpServletRequest request, HttpServletResponse response, String fileName) {
		InputStream inputStream = null;
		OutputStream outputStream = null;
		try {
			String userAgent = request.getHeader("User-Agent");
			String rtn = "";

			String new_filename = URLEncoder.encode(fileName, "UTF-8");
			// 如果没有UA，则默认使用IE的方式进行编码
			rtn = "filename=\"" + new_filename + "\"";
			if (userAgent != null) {
				userAgent = userAgent.toLowerCase();
				// IE浏览器，只能采用URLEncoder编码
				if (userAgent.contains("msie")) {
					rtn = "filename=\"" + new_filename + "\"";
				}
				// Opera浏览器只能采用filename*
				else if (userAgent.contains("opera")) {
					rtn = "filename*=UTF-8''" + new_filename;
				}
				// Safari浏览器，只能采用ISO编码的中文输出
				else if (userAgent.contains("safari")) {
					rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
				}
				// Chrome浏览器，只能采用MimeUtility编码或ISO编码的中文输出
				else if (userAgent.contains("applewebkit")) {
					rtn = "filename=\"" + new_filename + "\"";
				}
				// ie11
				else if (userAgent.contains("mozilla") && !userAgent.contains("firefox")) {
					rtn = "filename=\"" + new_filename + "\"";
					// 火狐
				} else if (userAgent.contains("firefox") && userAgent.contains("mozilla")) {
					rtn = "filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO8859-1") + "\"";
				}
			}
			response.reset();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition", "attachment;" + rtn + ";target=_blank");
			// 对文件名进行url编码以适应ie
			String relativeFilePath = "/tempfile/" + fileName;
			String tempFilePath = rootFilePath + relativeFilePath;
			inputStream = new FileInputStream(tempFilePath);
			outputStream = response.getOutputStream();
			byte b[] = new byte[1024 * 1024 * 1];// 1M
			int read = 0;
			while ((read = inputStream.read(b)) != -1) {
				outputStream.write(b, 0, read);// 每次写1M
			}
			outputStream.flush();
			outputStream.close();

		} catch (UnsupportedEncodingException e) {
			log.error("export excel template, error:{}", e);
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			log.error("export excel template, error:{}", e);
			e.printStackTrace();
		} catch (IOException e) {
			log.error("export excel template, error:{}", e);
			e.printStackTrace();
		} finally {
			try {
				if (inputStream != null) {
					inputStream.close();
				}
				if (outputStream != null) {
					outputStream.close();
				}
			} catch (IOException e) {
				log.error("fail to close inputstream , error:{}", Throwables.getStackTraceAsString(e));
			}
		}
	}
}
