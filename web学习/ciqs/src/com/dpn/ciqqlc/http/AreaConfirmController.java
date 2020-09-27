package com.dpn.ciqqlc.http;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dpn.ciqqlc.standard.model.CheckResultModel;
import com.dpn.ciqqlc.standard.model.ChkRckModel;
import com.dpn.ciqqlc.standard.service.AreaConfirmFlowService;

/**
 * 原产地证书签发行政确认 控制器类
 * @author LuanShenhui
 *
 */
@Controller
@RequestMapping(value = "/area")
public class AreaConfirmController {
	@Autowired
	@Qualifier("areaServer")
	private AreaConfirmFlowService areaServer = null; 
	
	
	@InitBinder
	public void InitBinder(WebDataBinder binder) {
		try {
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");  
			dateFormat.setLenient(false);  
			binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 结果保存
	 * http://localhost:7001/ciqs/area/confirm?id=1&procMainId=22&projCode=678&resultState=1&resultRmk=备注&oprUser=操作人&oprDate=1989-09-08
	 * @param chkRckModel
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/confirm",method=RequestMethod.GET)
	public Map<String, Object> confirm(ChkRckModel chkRckModel) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			areaServer.insertConfirm(chkRckModel);
			map.put("status", "OK");
			map.put("results", "无数据");
			return map;
		} catch (Exception e) {
			e.printStackTrace();
		}
		map.put("status", "FAIL");
		map.put("results", "无数据");
		return map;
	}
	
	/**
	 * 下载
	 * http://localhost:7001/ciqs/area/download?applyCompany=口岸物流
	  &applyTime=1999-09-22&companyName=企业名称&icp=企业备案号&purpose=最终国家&seaOutTime=出运日期
	  &zsNumber=证书号&fpNumber=发票号&fpDate=发票日期
	 * @param chkRckModel
	 * @return
	 */
	@RequestMapping(value = "/download",method=RequestMethod.POST)
	public void download(HttpServletResponse response, CheckResultModel checkResult) {
		try {
			List<CheckResultModel> list = areaServer.selectCheckResult(checkResult);
			InputStream is = new ByteArrayInputStream(list.toString().getBytes());
			response.reset();
			response.setContentType("application/json;charset=utf-8");
			ServletOutputStream out = response.getOutputStream();
			BufferedInputStream bis = null;
			BufferedOutputStream bos = null;
			try {
				bis = new BufferedInputStream(is);
				bos = new BufferedOutputStream(out);
				byte[] buff = new byte[2048];
				int bytesRead;
				while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
					bos.write(buff, 0, bytesRead);
				}
			} catch (final IOException e) {
				throw e;
			} finally {
				if (bis != null)
					bis.close();
				if (bos != null)
					bos.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 根据申请单位和申请日期查询
	 * http://localhost:7001/ciqs/area/selectCheckResult?applyCompany=口岸物流&applyTime=1999-09-22
	 * @param chkRckModel
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/selectCheckResult",method=RequestMethod.GET)
	public Map<String, Object> selectCheckResult(CheckResultModel checkResult) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			List<CheckResultModel> list =areaServer.selectCheckResult(checkResult);
			map.put("status", "OK");
			map.put("results", list);
			return map;
		} catch (Exception e) {
			e.printStackTrace();
		}
		map.put("status", "FAIL");
		map.put("results", "无数据");
		return map;
	}

}
