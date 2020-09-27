package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.service.AttributeKeyService;
import cn.com.cgbchina.item.service.BackCategoriesImportService;
import cn.com.cgbchina.item.service.BackCategoriesService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/api/admin/backCategories")
@Slf4j
public class BackCategories {

	@Autowired
	private BackCategoriesService backCategoriesService;

	@Autowired
	private MessageSources messageSources;
	@Autowired
	private AttributeKeyService attributeKeyService;

	@Autowired
	private BackCategoriesImportService backCategoriesImportService;// 报表导入

	@Value("#{app.fileUploadPath}")
	private String rootFilePath;

	/**
	 * 添加
	 *
	 * @param backCategory
	 * @return
	 */

	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Long> create(@Valid BackCategory backCategory, BindingResult bindingResult) {
		Response<Long> response = new Response<Long>();
		if (bindingResult.hasErrors()) {
			for (FieldError fieldError : bindingResult.getFieldErrors()) {
				response.setError(fieldError.getDefaultMessage());
				return response;
			}
		}
		Response<Long> result = backCategoriesService.create(backCategory);
		if (result.isSuccess()) {
			response.setResult(result.getResult());
			return response;
		}
		log.error("failed to create {},error code:{}", backCategory, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * @param backCategoryEditDto
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(BackCategoryEditDto backCategoryEditDto) {
		Response<Boolean> result = backCategoriesService.update(backCategoryEditDto);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to update {},error code:{}", backCategoryEditDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean delete(@PathVariable Long id) {
		Response<Boolean> result = backCategoriesService.delete(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	@RequestMapping(value = "/findChildWithAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public BackCategoryDto findChildWithAttribute(Long id) {

		Response<BackCategoryDto> response = backCategoriesService.findChildWithAttribute(id);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to delete {},error code:{}", id, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	/**
	 * 类目属性添加
	 *
	 * @param categoryId
	 * @param attributeTransDto
	 * @return
	 */
	@RequestMapping(value = "/addCategoryAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean addAttribute(Long categoryId, AttributeTransDto attributeTransDto) {

		Response<Boolean> response = backCategoriesService.addAttribute(categoryId, attributeTransDto);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to add attribute {},error code:{}", attributeTransDto, response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	/**
	 * 属性列表
	 *
	 * @return
	 */
	@RequestMapping(value = "/listAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<AttributeKeyDto> listAttribute() {
		Response<Pager<AttributeKeyDto>> response = attributeKeyService.find(1, 50, null);
		if (response.isSuccess()) {
			return response.getResult().getData();
		}
		log.error("failed to list attribute {}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	/**
	 * 模糊查询
	 *
	 * @param name
	 * @return
	 */
	@RequestMapping(value = "/fuzzyQuery", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<AttributeKeyDto> fuzzyQuery(@RequestBody String name) {
		Response<List<AttributeKeyDto>> response = attributeKeyService.fuzzyQuery(name);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to list attribute {}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	@RequestMapping(value = "/deleteAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean deleteAttribute(Long categoryId, Long attributeId, Integer type) {
		Response<Boolean> response = backCategoriesService.deleteAttribute(categoryId, attributeId, type);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to list attribute {}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	@RequestMapping(value = "/editAttribute", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean editAttribute(Long categoryId, Long attributeId, Integer oldType, Integer newType) {
		Response<Boolean> response = backCategoriesService.editAttribute(categoryId, attributeId, oldType, newType);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to list attribute {}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	@RequestMapping(value = "/isParent", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean isParent(@RequestBody Long categoryId) {
		Response<Boolean> response = backCategoriesService.isParent(categoryId);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("failed to list attribute {}", response.getError());
		throw new ResponseException(500, messageSources.get(response.getError()));

	}

	/**
	 * 批量导入
	 *
	 * @param files
	 * @param httpServletResponse
	 */
	@RequestMapping(value = "/importBackCategories", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public void importBackCategories(MultipartFile files, HttpServletResponse httpServletResponse) {
		User user = UserUtil.getUser();

		try (FileInputStream fileInputStream = new FileInputStream(rootFilePath + "/config/back_category.xml");
				InputStream uploadFile = files.getInputStream()) {
			String fileName = ((CommonsMultipartFile) files).getFileItem().getName();

			Map<String, Object> dataBeans = Maps.newHashMap();
			List<BackCategoryImportDto> details = Lists.newArrayList();
			dataBeans.put("items", details);
			ExcelUtil.importExcelToData(dataBeans, uploadFile, fileInputStream);

			Response<List<BackCategoryImportDto>> response = backCategoriesImportService
					.importBackCategoriesData(details, user);
			// 将结果返回给前台
			Map<String, Object> map = Maps.newHashMap();
			map.put("backCategories", response.getResult());
			ExportUtils.exportTemplate(httpServletResponse, fileName, rootFilePath + "/template/back_category.xlsx",
					map);
		} catch (Exception e) {
			log.error("import.BackCategories.xls.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("category.import.fail"));
		}
	}

	@RequestMapping(value = "/exportTemplateExcel")
	public void exportTemplateExcel(HttpServletResponse response) {
		String fileName = "后台类目导入模板.xlsx"; // 输出给前台显示的文件名
		String filePath = rootFilePath + "/template/back_category.xlsx";// 文件的绝对路径
		try {
			Map<String, Object> map = Maps.newHashMap();
			map.put("backCategories", Collections.emptyList());
			ExportUtils.exportTemplate(response, fileName, filePath, map);
		} catch (Exception e) {
			log.error("fail to download excel", e);
			response.reset();
			throw new ResponseException(500, messageSources.get("export.goods.excel.error"));
		}
	}

	@RequestMapping(value = "/exportBackCategoriesExcel")
	public Response<String> exportBackCategoriesExcel() {

		Response<String> result = new Response<String>();
		User user = UserUtil.getUser();

		String relativeFilePath = "/tempfile/BackCategories" + UUID.randomUUID().toString() + ".xlsx";
		String tempFilePath = rootFilePath + relativeFilePath;

		try (FileInputStream fileInputStream = new FileInputStream(
				rootFilePath + "/template/back_category_export.xlsx");
				FileOutputStream fileOutputStream = new FileOutputStream(tempFilePath)) {
			Response<List<BackCategoryExportDto>> listResponse = backCategoriesImportService
					.exportBackCategoriesData(user);
			if (listResponse.isSuccess()) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("backCategories", listResponse.getResult());
				Workbook workbook = WorkbookFactory.create(fileInputStream);
				ExportUtils.exportTemplate(workbook, map);
				workbook.write(fileOutputStream);
				fileOutputStream.flush();
				result.setSuccess(Boolean.TRUE);
				result.setResult(relativeFilePath);
			} else {
				log.error("fail to export backCategories data");
				throw new ResponseException(500, listResponse.getError());
			}
		} catch (Exception e) {
			log.error("fail to export backCategories data");
			throw new ResponseException(500, "文件导出失败");
		}
		return result;
	}
}
