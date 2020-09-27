package cn.rkylin.core.controller;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import cn.rkylin.core.exception.BusinessException;
import cn.rkylin.core.utils.LogUtils;
import cn.rkylin.core.utils.PropertiesUtils;
import cn.rkylin.core.utils.WebUtils;

/**
 * 
 * ClassName: FileUploadController
 * 
 * @Description: 文件上传、图片上传controller
 * @author shixiaofeng@tootoo.cn
 * @date 2016-1-12 上午10:26:29
 */
@Controller
@RequestMapping("/upload")
public class FileUploadController extends AbstractController {
	private static Logger logger = Logger.getLogger(LogUtils.LOG_BOSS);

	private static final int picturesizelimit = PropertiesUtils.getInstance().getIntByKey("picturesizelimit");
	private static final String allowType = PropertiesUtils.getInstance().getPropertyByKey("allowType");
	private static final String uploadPath = PropertiesUtils.getInstance().getPropertyByKey("uploadPath");

	/**
	 * 
	 * @Description: 上传图片
	 * @param file
	 * @param request
	 * @param model
	 * @return
	 * @throws BusinessException
	 *             String
	 * @throws @author
	 *             shixiaofeng@tootoo.cn
	 * @date 2016-1-12 上午10:26:51
	 */
	@RequestMapping(value = "/uploadImg.action", produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String uploadImg(MultipartHttpServletRequest request, ModelMap model) throws BusinessException {
		long t1 = System.currentTimeMillis();
		try {
			JSONObject ret = new JSONObject();
			String uuid = (String) request.getAttribute("uuid");
			LogUtils.info(logger, uuid, "【进入FileUploadController的uploadImg方法中】");
			Map<String, Object> param = this.getParamMap(request);
			Object paramObj = param.get("params");
			String params = "";
			if (paramObj == null) {
				return "{msg:'param参数不正确！'}";
			} else {
				params = paramObj.toString();
				if (params.trim().length() == 0) {
					return "{msg:'param参数不正确！'}";
				}
			}

			Iterator<String> itr = request.getFileNames();
			while (itr.hasNext()) {
				long t2 = System.currentTimeMillis();
				MultipartFile file = request.getFile(itr.next());
				// 获得文件名：
				String filename = file.getOriginalFilename();
				if (!extIsAllowed(getExtension(filename))) {
					LogUtils.info(logger, uuid, "上传文件类型不正确,文件名[" + file.getName() + "]");
					return "{msg:'上传文件类型不正确！只允许上传类型为[" + allowType + "]的文件！'}";
				}
				long t3 = System.currentTimeMillis();
				long size = file.getSize();
				if (size > Long.valueOf(picturesizelimit)) {
					LogUtils.info(logger, uuid, "上传文件数据过大,大小[" + size + "]");
					return "{msg:'上传文件数据过大！只允许上传文件小于[" + Long.valueOf(picturesizelimit) / 1024 / 1024 + "M]的文件！'}";
				}
				long t4 = System.currentTimeMillis();
				BufferedImage sourceImg = ImageIO.read(file.getInputStream());
				ret.put("width", sourceImg.getWidth());
				ret.put("height", sourceImg.getHeight());
				ret.put("size", size / 1024);
				long t5 = System.currentTimeMillis();
				File source = new File(getContextRealPath() + uploadPath + filename.toString());
				file.transferTo(source);
				long t6 = System.currentTimeMillis();
				String filepath = WebUtils.upload2WWW(source, params);
				long t7 = System.currentTimeMillis();
				System.out.println("上传用时明细：(1)=" + (t2 - t1) + "(2)=" + (t3 - t2) + "(3)=" + (t4 - t3) + "(4)="
						+ (t5 - t4) + "(5)=" + (t6 - t5) + "(6)=" + (t7 - t6));
				filepath = filepath.substring(9, filepath.length() - 2);
				ret.put("filepath", filepath);
				return ret.toString();
			}
			return "{msg:'没有找到需要上传的图片'}";
		} catch (IOException e) {
			throw new BusinessException(e, "图片上传失败", "");
		}
	}

	public long getFileSize(File f) throws IOException, FileNotFoundException {// È¡µÃÎÄ¼þ´óÐ¡
		long s = 0;
		if (f.exists()) {
			FileInputStream fis = null;
			fis = new FileInputStream(f);
			s = fis.available();
		}
		return s;
	}

	/**
	 * 判断扩展名是否允许的方法
	 */
	private boolean extIsAllowed(String ext) {
		ext = ext.toLowerCase();
		return allowType.indexOf(ext) != -1;
	}

	/**
	 * 获取扩展名的方法
	 */
	private String getExtension(String fileName) {
		return fileName.substring(fileName.lastIndexOf(".") + 1);
	}

	public String getContextRealPath() {
		String path = FileUploadController.class.getClassLoader().getResource("").getPath();
		int end = path.length() - "WEB-INF/classes/".length();
		path = path.substring(1, end);
		return "/" + path;
	}
}
