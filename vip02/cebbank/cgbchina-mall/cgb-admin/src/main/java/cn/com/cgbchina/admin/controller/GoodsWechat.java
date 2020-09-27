package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.item.dto.UploadItemWeChatDto;
import cn.com.cgbchina.item.service.ItemWechatService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Tanliang 微信商品管理
 *
 * @time:2016-6-14
 */
@Controller
@RequestMapping("/api/admin/GoodsWeChat") // 请求映射
@Slf4j // 日志
public class GoodsWechat {
	@Autowired
	private ItemWechatService itemWeChatService;
	@Autowired
	private MessageSources messageSources;

	/**
	 * 根据单品code删除单品（逻辑删除）
	 *
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/{code}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String deleteItemWeChat(@PathVariable("code") String code) {
		// 根据id删除
		Response<Boolean> result = itemWeChatService.deleteItemByCode(code);
		if (result.isSuccess()) {
			return "ok";
		} else {
			log.error("delete.deleteItemWeChat,error code:{}", code, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	/**
	 * 编辑微信商品（更改排序）
	 *
	 * @param wxOrder
	 * @return
	 */
	@RequestMapping(value = "/editItemWeChat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean editItemWeChat(@RequestParam(value = "wxOrder", required = true) Long wxOrder,
			@RequestParam(value = "code", required = true) String code) {
		try {
			Response<Boolean> result = itemWeChatService.editItemWeChat(wxOrder, code);
			return result.getResult();
		} catch (Exception e) {
			log.error("updateProduct.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("update.error"));
		}
	}
    /**
     * 下载模板
     * @param request
     * @param response
     * @throws java.io.IOException
     */
    @ResponseBody
    @RequestMapping(value="/outWeChatTemplate",method =RequestMethod.GET)
    public void downloadTemplate (HttpServletRequest request ,HttpServletResponse response) throws IOException {
        try{
            String path = request.getSession(true).getServletContext().getRealPath("/resources/files/wechat_goods.xls");
            File file = new File(path);
            //下载文件中文名转换
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
	 * 上传微信商品
	 *
	 * @return
	 */
	// TODO 错误代码，自己更正
	@RequestMapping(value = "/uploadItemWeChat", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean uploadItemWeChat() {
		try {
			Map<String, Object> dataBeans = new HashMap<String, Object>();
			List<UploadItemWeChatDto> details = new ArrayList<UploadItemWeChatDto>();
			dataBeans.put("wechatItems", details);

//			String path_template = request.getSession(true).getServletContext().getRealPath("/src/resources/upload/template/wechat_goods.xls");
			File file_template = new File("C:/upload/wechat_goods.xls");

//			String path_config = request.getSession(true).getServletContext().getRealPath("/src/resources/upload/config/wechat_goods.xml");
			File file_config = new File("C:/upload/wechat_goods.xml");

			ExcelUtil.importExcelToData(dataBeans, new FileInputStream(file_template),new FileInputStream(file_config));

			Response<Boolean> result = itemWeChatService.uploadItemWeChat(details);
			return result.getResult();
		} catch (Exception e) {
			log.error("uploadItemWeChat.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("uploadItemWeChat.error"));
		}
	}
}
