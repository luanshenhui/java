package cn.com.cgbchina.admin.controller;

import static com.google.common.base.Preconditions.checkArgument;

import java.io.*;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.xml.sax.SAXException;

import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.PinYinHelper;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.service.BrandService;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.read.biff.BiffException;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by zhanglin on 16-4-12.
 */
@Controller
@RequestMapping("/api/admin/pointsBrand")
@Slf4j
public class PointsBrands {
	private final static Set<String> allowed_types = ImmutableSet.of("xls", "xlsx");
	@Autowired
	private BrandService brandService;// 商品service
	@Autowired
	private MessageSources messageSources;

	/**
	 * 新增品牌信息
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean createBrand(GoodsBrandModel goodsBrandModel) {
		User user = UserUtil.getUser();
		goodsBrandModel.setDelFlag(Contants.DEL_FLAG_0);
		goodsBrandModel.setCreateOper(user.getName());
		goodsBrandModel.setModifyOper(user.getName());
		goodsBrandModel.setPublishStatus(Contants.BRAND_PUBLIST_STATUS_00);
		goodsBrandModel.setBrandInforStatus(Contants.BRAND_APPROVE_STATUS_00);
		goodsBrandModel.setOrdertypeId(Contants.BUSINESS_TYPE_JF);
		goodsBrandModel.setInitial(PinYinHelper.getAllFirstSpell(goodsBrandModel.getBrandName()));
		goodsBrandModel.setSpell(PinYinHelper.getPingYin(goodsBrandModel.getBrandName()));
		Response<Boolean> result = brandService.createBrandInfo(goodsBrandModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error code:{}", goodsBrandModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 修改品牌
	 *
	 * @param goodsBrandModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(GoodsBrandModel goodsBrandModel) {
		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 修改
			goodsBrandModel.setModifyOper(user.getName());
			Response<Boolean> result = brandService.updateBrandInfo(goodsBrandModel);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("brand.update.error"));
		}
	}

	/**
	 * 通过品牌名称查询品牌ID
	 *
	 * @param brandName
	 * @return
	 */
	@RequestMapping(value = "/checkBrandName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public GoodsBrandModel checkBrandName(String brandName) {
		// 查询品牌是否存在
		Response<GoodsBrandModel> result = brandService.checkBrandName(brandName, Contants.BUSINESS_TYPE_JF);
		if(result.isSuccess()){
			return result.getResult();
		}
		log.error("find.errror，erro:{}",brandName, result.getError());
		throw new ResponseException(500, messageSources.get("find.error"));
	}

	/**
	 * 查询所有品牌的名字和品牌模糊查询（产品用）
	 *
	 * @param brandName
	 * @return
	 * @Add by Tanliang
	 */
	@RequestMapping(value = "list", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	// 绑定value对象 可以为空required = false
	public Pager<GoodsBrandModel> findBrandNameLike(
			@RequestParam(value = "brandName", required = false) String brandName,
			@RequestParam(value = "order_typeId", required = false) String ordertypeId,
			@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size) {

		// 如果params为空取出所有品牌名，如果params不为空进行品牌模糊查询
		Response<Pager<GoodsBrandModel>> result = brandService.findBrandByParam(brandName, ordertypeId, pageNo, size);
		if (result.isSuccess()) {
			return result.getResult();

		}
		log.error("failed to selectBrandName where brandNameLike={},error code:{}", brandName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 根据品牌名称查询该品牌是否被供应商授权过
	 *
	 * @param brandName
	 * @return
	 */
	@RequestMapping(value = "/findIsAuthroizeByName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean findIsAuthroizeByName(String brandName) {
		Response<Boolean> result = brandService.findIsAuthroizeByName(brandName, Contants.BUSINESS_TYPE_JF);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", brandName, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 删除品牌
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String delete(@PathVariable("id") Long id) {
		Response<Boolean> result = brandService.deleteBrandInfo(id);
		if (result.isSuccess()) {
			return "ok";
		} else {
			log.error("failed to delete goodsBrandModel where code={},error code:{}", id, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	/**
	 * 下载模板
	 *
	 * @return
	 */
	@RequestMapping(value = "/exportExcel", method = RequestMethod.GET, produces = MediaType.ALL_VALUE)
	public void exportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String filename = "导入品牌.xls";
		// if (request.getHeader("User-Agent").toLowerCase().indexOf("firefox") > 0) {
		// filename = new String(filename.getBytes("UTF-8"), "ISO8859-1");// firefox浏览器
		// } else if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0) {
		filename = URLEncoder.encode(filename, "UTF-8");// IE浏览器
		// }
		response.reset();
		response.setContentType("application/octet-stream");
		// response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment;filename=\"" + filename + "\"; target=_blank");
		Enumeration<?> enu = request.getParameterNames();
		while (enu.hasMoreElements()) {
			String rn = (String) enu.nextElement();
			String id = request.getParameter(rn);
		}
		try {
			OutputStream os = response.getOutputStream();
			Workbook workbook = null;
			InputStream in = new FileInputStream("E:/brand.xls");
			workbook = Workbook.getWorkbook(in);
			WorkbookSettings ws = new WorkbookSettings();
			Locale locale = new Locale("zh", "CN");
			ws.setLocale(locale);
			ws.setEncoding("utf-8");
			// 下面这句代码是关键，将workbook写入os流中
			WritableWorkbook wbook = Workbook.createWorkbook(os, workbook, ws);
			// WritableSheet writeSheet = wbook.getSheet(0);// sheet名称
			wbook.write(); // 写入文件
			wbook.close();
			workbook.close();
			in.close();
			try {
				if (os != null) {
					os.flush();
					os.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		} catch (BiffException e1) {
			e1.printStackTrace();
		} catch (WriteException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
	}

	@RequestMapping(value = "/importExcel", method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String processUpload(@RequestParam(required = false) String category, MultipartHttpServletRequest request) {

		Map<String, Object> dataBeans = new HashMap<String, Object>();
		List<GoodsBrandModel> details = new ArrayList<GoodsBrandModel>();
		try {
			dataBeans.put("brands", details);
			ExcelUtil.importExcelToData(dataBeans, new FileInputStream(new File("E:/brand.xls")),
					new FileInputStream(new File("E:/brand.xml")));

			System.out.print(dataBeans);
			User user = UserUtil.getUser();

			FileInputStream fs = new FileInputStream("E:/brand.xls"); // 获取E:/brand.xls
			POIFSFileSystem ps = new POIFSFileSystem(fs); // 使用POI提供的方法得到excel的信息
			HSSFWorkbook wb = new HSSFWorkbook(ps);
			HSSFSheet sheet = wb.getSheetAt(0); // 获取到工作表，因为一个excel可能有多个工作表
			HSSFRow row = sheet.getRow(0); // 获取第一行（excel中的行默认从0开始，所以这就是为什么，一个excel必须有字段列头），即，字段列头，便于赋值
			FileOutputStream out = new FileOutputStream("E:/brand.xls"); // 向d://test.xls中写数据

			for (int i = 0; i < details.size(); i++) {
				Response<GoodsBrandModel> response = brandService.checkBrandName(details.get(i).getBrandName(), Contants.BUSINESS_TYPE_JF);
				if(response.isSuccess()){
					GoodsBrandModel goodsBrand = response.getResult();
					if (goodsBrand == null) {
						GoodsBrandModel goodsBrandModel = new GoodsBrandModel();
						goodsBrandModel.setOrdertypeId(details.get(i).getOrdertypeId());
						goodsBrandModel.setBrandName(details.get(i).getBrandName());
						goodsBrandModel.setDelFlag(Contants.DEL_FLAG_0);
						goodsBrandModel.setCreateOper(user.getName());
						goodsBrandModel.setModifyOper(user.getName());
						goodsBrandModel.setPublishStatus(Contants.BRAND_PUBLIST_STATUS_00);
						goodsBrandModel.setBrandInforStatus(Contants.BRAND_APPROVE_STATUS_00);
						goodsBrandModel.setOrdertypeId(Contants.BUSINESS_TYPE_JF);
						goodsBrandModel.setInitial(PinYinHelper.getAllFirstSpell(details.get(i).getBrandName()));
						goodsBrandModel.setSpell(PinYinHelper.getPingYin(details.get(i).getBrandName()));
						Response<Boolean> result = brandService.createBrandInfo(goodsBrandModel);
						row = sheet.getRow(i + 2);
						row.createCell(0).setCellValue("成功");
					} else {
						if ("00".equals(goodsBrand.getBrandInforStatus())) {

							row = sheet.getRow(i + 2);
							row.createCell(0).setCellValue("失败");
							row.createCell(1).setCellValue("审核状态存在");
						}
						if ("01".equals(goodsBrand.getBrandInforStatus())) {

							row = sheet.getRow(i + 2);
							row.createCell(0).setCellValue("失败");
							row.createCell(1).setCellValue("品牌存在");
						}
					}
				}

			}
			out.flush();
			wb.write(out);
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (InvalidFormatException e) {
			e.printStackTrace();
		}

		return "";

	}
}
