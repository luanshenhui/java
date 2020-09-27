package cn.com.cgbchina.admin.controller;

import static com.google.common.base.Preconditions.checkArgument;

import java.io.*;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.item.dto.BackCategoryImportDto;
import cn.com.cgbchina.item.dto.UploadBrandsDto;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
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
 * Created by Liuhan on 16-4-12.
 */
@Controller
@RequestMapping("/api/admin/brand")
@Slf4j
public class Brands {
	private final static Set<String> allowed_types = ImmutableSet.of("xls", "xlsx");
	@Autowired
	private BrandService brandService;// 商品service
	@Autowired
	private MessageSources messageSources;
	@Value("#{app.fileUploadPath}")
	private String rootFilePath;

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
		goodsBrandModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);
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
		Response<GoodsBrandModel> result = brandService.checkBrandName(brandName, Contants.BUSINESS_TYPE_YG);
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
	 * @param ordertypeId 业务区分Id
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
		Response<Boolean> result = brandService.findIsAuthroizeByName(brandName, Contants.BUSINESS_TYPE_YG);
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
		String fileName = "品牌名称导入模板.xlsx"; // 输出给前台显示的文件名
		String filePath = rootFilePath + "/template/brand.xlsx";// 文件的绝对路径
		try {
			Map<String, Object> map = Maps.newHashMap();
			map.put("brands", Collections.emptyList());
			ExportUtils.exportTemplate(response, fileName, filePath, map);
		} catch (Exception e) {
			log.error("fail to download excel", e);
			response.reset();
			throw new ResponseException(500, messageSources.get("export.brands.excel.error"));
		}

	}

	@RequestMapping(value = "/importExcel", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void processUpload(MultipartFile files, HttpServletResponse httpServletResponse) {
		User user = UserUtil.getUser();

		try (FileInputStream fileInputStream = new FileInputStream(rootFilePath + "/config/brand.xml");
			 InputStream uploadFile = files.getInputStream()) {
			String fileName = ((CommonsMultipartFile) files).getFileItem().getName();

			Map<String, Object> dataBeans = Maps.newHashMap();
			List<UploadBrandsDto> details = Lists.newArrayList();
			dataBeans.put("brands", details);
			ExcelUtil.importExcelToData(dataBeans, uploadFile, fileInputStream);

			Response<List<UploadBrandsDto>> response = brandService.uploadBrands(details, user, Contants.BUSINESS_TYPE_YG);
			// 将结果返回给前台
			Map<String, Object> map = Maps.newHashMap();
			map.put("brands", response.getResult());
			ExportUtils.exportTemplate(httpServletResponse, fileName, rootFilePath + "/template/brand.xlsx",
					map);
		} catch (Exception e) {
			log.error("import.brand.xls.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("brand.import.fail"));
		}
	}
}
