package cn.com.cgbchina.admin.controller;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import cfca.sadk.org.bouncycastle.cert.ocsp.Req;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.item.dto.GoodsBrandAdvertiseDto;
import cn.com.cgbchina.item.dto.UploadBrandsDto;
import cn.com.cgbchina.item.model.EspNavCategoryInfModel;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.service.BrandService;
import cn.com.cgbchina.item.service.EspNavCategoryInfService;
import cn.com.cgbchina.related.model.AdvertisingManageModel;
import cn.com.cgbchina.related.service.AdvertisingManageService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by Liuhan on 16-4-12.
 */
@Controller
@RequestMapping("/api/admin/brand")
@Slf4j
public class Brands {
	private final static Set<String> allowed_types = ImmutableSet.of("xls", "xlsx");
	@Resource
	private BrandService brandService;// 商品service
	@Autowired
	private MessageSources messageSources;
	@Resource
	private AdvertisingManageService advertisingManageService;
	@Resource
	private EspNavCategoryInfService espNavCategoryInfService;

	// @Value("#{app.fileUploadPath}")
	private String rootFilePath;

	public Brands() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	/**
	 * 新增品牌信息
	 */
	@RequestMapping(value = "/add-brand", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean createBrand(GoodsBrandModel goodsBrandModel) {
		User user = UserUtil.getUser();

		Response<Boolean> result = brandService.createBrandInfo(goodsBrandModel, user, Contants.BUSINESS_TYPE_YG);
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
	@RequestMapping(value = "/edit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean edit(GoodsBrandModel goodsBrandModel) {
		return this.update(goodsBrandModel);
	}

	/**
	 * 审核品牌
	 *
	 * @param goodsBrandModel
	 * @return
	 */
	@RequestMapping(value = "/audit", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean audit(GoodsBrandModel goodsBrandModel) {
		// 对textarea进行SafeHtmlValidator类校验
		// 包含脚本或事件，返回true, 否则返回false
		if (checkScriptAndEvent(goodsBrandModel.getApproveMemo())) {
			boolean checkResult = false;
			return checkResult;
		}
		return this.update(goodsBrandModel);
	}

	/**
	 * 修改品牌
	 *
	 * @param goodsBrandModel
	 * @return
	 */
	private Boolean update(GoodsBrandModel goodsBrandModel) {
		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 修改
			goodsBrandModel.setModifyOper(user.getName());
			Response<Boolean> result = brandService.updateBrandInfo(goodsBrandModel);
			if(!result.isSuccess()){
				log.error("Response.error,error code: {}", result.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
			}
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
	@RequestMapping(value = "/add-checkBrandName", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public GoodsBrandModel checkBrandName(String brandName) {
		// 查询品牌是否存在
		Response<GoodsBrandModel> result = brandService.checkBrandName(brandName, Contants.BUSINESS_TYPE_YG);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("find.errror，erro:{}", brandName, result.getError());
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
	@RequestMapping(value = "/delete-checkStatus", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Integer findIsAuthroizeByName(@Param("brandName") String brandName, @Param("brandId") String brandId) {
		Response<Integer> result = brandService.findIsAuthroizeByName(brandName, Contants.BUSINESS_TYPE_YG, brandId);
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
	@RequestMapping(value = "/delete/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
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
	@RequestMapping(value = "/import-exportExcel", method = RequestMethod.GET, produces = MediaType.ALL_VALUE)
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

	@RequestMapping(value = "/import-excel", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Map<String, Object> processUpload(MultipartFile files, HttpServletResponse httpServletResponse) {
		User user = UserUtil.getUser();
		if (null == files)
			throw new ResponseException("上传失败，上传文件不存在");
		// 获取上传文件名
		String fileName = files.getOriginalFilename();
		String relativeFilePath = "/tempfile/" + fileName;
		String tempFilePath = rootFilePath + relativeFilePath;
		File file = new File(tempFilePath);
		Map<String, Object> map = null;
		if (file.exists()) {
			boolean flag = file.delete();
			if (!flag)
				throw new ResponseException("导入失败，无法删除已经存在的文件");
		}

		try (FileInputStream configInput = new FileInputStream(rootFilePath + "/config/brand.xml"); // 导入
				FileInputStream OutfileInput = new FileInputStream(rootFilePath + "/template/brand.xlsx"); // 输出模板
				FileOutputStream fileOutputStream = new FileOutputStream(tempFilePath); // 导出路径
				InputStream uploadFile = files.getInputStream()) {

			Map<String, Object> dataBeans = Maps.newHashMap();
			List<UploadBrandsDto> details = Lists.newArrayList();
			dataBeans.put("brands", details);
			ExcelUtil.importExcelToData(dataBeans, uploadFile, configInput);

			Response<List<UploadBrandsDto>> result = brandService.uploadBrands(details, user,
					Contants.BUSINESS_TYPE_YG);
			map = Maps.newHashMap();
			if (result.isSuccess()) {
				exportTempFileExcel(OutfileInput, fileOutputStream, result);
				map.put("success", Boolean.TRUE);
				map.put("fileName", fileName);
			} else {
				map.put("success", Boolean.FALSE);
			}
		} catch (IllegalArgumentException e) {
			log.error("import.BackCategories.xls.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("category.import.fail"));
		} catch (IllegalStateException e) {
			log.error("import.BackCategories.xls.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("category.import.fail"));
		} catch (Exception e) {
			log.error("import.BackCategories.xls.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("category.import.fail"));
		}
		return map;
	}

	/**
	 *
	 * 生成临时文件
	 *
	 * @param fileInputStream
	 * @param fileOutputStream
	 * @param response
	 * @throws IOException
	 * @throws InvalidFormatException
	 *
	 * @author zhanglin
	 */
	private void exportTempFileExcel(FileInputStream fileInputStream, FileOutputStream fileOutputStream,
			Response response) throws IOException, InvalidFormatException {
		Map<String, Object> mapData = Maps.newHashMap();
		if(!response.isSuccess()){
			log.error("Response.error,error code: {}", response.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(response.getError()));
		}
		mapData.put("brands", response.getResult());
		org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(fileInputStream);
		ExportUtils.exportTemplate(workbook, mapData);
		workbook.write(fileOutputStream);
		fileOutputStream.flush();
	}

	/**
	 * 导出文件
	 *
	 * @param response
	 * @author zhanglin
	 */
	@RequestMapping(value = "/export-brands", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public void exportCategories(HttpServletResponse response) {

		String fileName = "Brand" + UUID.randomUUID().toString() + ".xlsx";
		String filePath = rootFilePath + "/template/brand.xlsx";
		try {
			Response<List<UploadBrandsDto>> listResponse = brandService.exportBrands(Contants.BUSINESS_TYPE_YG);
			if (listResponse.isSuccess()) {
				Map<String, Object> map = Maps.newHashMap();
				map.put("brands", listResponse.getResult());
				ExportUtils.exportTemplate(response, fileName, filePath, map);

			} else {
				log.error("fail to export brands data");
				throw new ResponseException(500, listResponse.getError());
			}
		} catch (Exception e) {
			log.error("fail to export backCategories data , bad code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, "文件导出失败");
		}
	}

	/**
	 * 新增品牌广告详情
	 */
	@RequestMapping(value = "/add-brand-detail", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean createBrandDetail(GoodsBrandAdvertiseDto model) {

		if (model != null) {
			if (model.getSlide1Id() != null) {
				Response<AdvertisingManageModel> slide1Model = advertisingManageService.findById(model.getSlide1Id());
				if(!slide1Model.isSuccess()){
					log.error("Response.error,error code: {}", slide1Model.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(slide1Model.getError()));
				}
				if (slide1Model.getResult() != null) {
					AdvertisingManageModel adModel = slide1Model.getResult();
					//307382 必须是审核通过且有效的广告 niufw  1--审核通过 1--有效
					if(Contants.AD_CHECK_STATUS_1.equals(adModel.getCheckStatus()) &&
							adModel.getIsValid().equals(Contants.AD_IS_VALID_1)){
						model.setSlide1Pic(adModel.getMedia());
						model.setSlide1Link(adModel.getLink());
					}else{
						throw new ResponseException(500, messageSources.get("brand.carousel.ad.none-au","1"));
					}
				}else{
					throw new ResponseException(500, messageSources.get("brand.carousel.ad.audit-au","1"));
				}
			}
			if (model.getSlide2Id() != null) {
				Response<AdvertisingManageModel> slide2Model = advertisingManageService.findById(model.getSlide2Id());
				if(!slide2Model.isSuccess()){
					log.error("Response.error,error code: {}", slide2Model.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(slide2Model.getError()));
				}
				if (slide2Model.getResult() != null) {
					AdvertisingManageModel adModel = slide2Model.getResult();
					//307382 必须是审核通过且有效的广告 niufw  1--审核通过 1--有效
					if(Contants.AD_CHECK_STATUS_1.equals(adModel.getCheckStatus()) &&
							adModel.getIsValid().equals(Contants.AD_IS_VALID_1)) {
						model.setSlide2Pic(adModel.getMedia());
						model.setSlide2Link(adModel.getLink());
					}else{
						throw new ResponseException(500, messageSources.get("brand.carousel.ad.none-au","2"));
					}
				}else{
					throw new ResponseException(500, messageSources.get("brand.carousel.ad.audit-au","2"));
				}
			}
			if (model.getSlide3Id() != null) {
				Response<AdvertisingManageModel> slide3Model = advertisingManageService.findById(model.getSlide3Id());
				if(!slide3Model.isSuccess()){
					log.error("Response.error,error code: {}", slide3Model.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(slide3Model.getError()));
				}
				if (slide3Model.getResult() != null) {
					AdvertisingManageModel adModel = slide3Model.getResult();
					//307382 必须是审核通过且有效的广告 niufw  1--审核通过 1--有效
					if(Contants.AD_CHECK_STATUS_1.equals(adModel.getCheckStatus()) &&
							adModel.getIsValid().equals(Contants.AD_IS_VALID_1)) {
						model.setSlide3Pic(adModel.getMedia());
						model.setSlide3Link(adModel.getLink());
					}else{
						throw new ResponseException(500, messageSources.get("brand.carousel.ad.none-au","3"));
					}
				}else{
					throw new ResponseException(500, messageSources.get("brand.carousel.ad.audit-au","3"));
				}
			}
			if (model.getSlide4Id() != null) {
				Response<AdvertisingManageModel> slide4Model = advertisingManageService.findById(model.getSlide4Id());
				if(!slide4Model.isSuccess()){
					log.error("Response.error,error code: {}", slide4Model.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(slide4Model.getError()));
				}
				if (slide4Model.getResult() != null) {
					AdvertisingManageModel adModel = slide4Model.getResult();
					//307382 必须是审核通过且有效的广告 niufw  1--审核通过 1--有效
					if(Contants.AD_CHECK_STATUS_1.equals(adModel.getCheckStatus()) &&
							adModel.getIsValid().equals(Contants.AD_IS_VALID_1)) {
						model.setSlide4Pic(adModel.getMedia());
						model.setSlide4Link(adModel.getLink());
					}else{
						throw new ResponseException(500, messageSources.get("brand.carousel.ad.none-au","4"));
					}
				}else{
					throw new ResponseException(500, messageSources.get("brand.carousel.ad.audit-au","4"));
				}
			}
			if (model.getSlide5Id() != null) {
				Response<AdvertisingManageModel> slide5Model = advertisingManageService.findById(model.getSlide5Id());
				if(!slide5Model.isSuccess()){
					log.error("Response.error,error code: {}", slide5Model.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(slide5Model.getError()));
				}
				if (slide5Model.getResult() != null) {
					AdvertisingManageModel adModel = slide5Model.getResult();
					//307382 必须是审核通过且有效的广告 niufw  1--审核通过 1--有效
					if(Contants.AD_CHECK_STATUS_1.equals(adModel.getCheckStatus()) &&
							adModel.getIsValid().equals(Contants.AD_IS_VALID_1)) {
						model.setSlide5Pic(adModel.getMedia());
						model.setSlide5Link(adModel.getLink());
					}else{
						throw new ResponseException(500, messageSources.get("brand.carousel.ad.none-au","5"));
					}
				}else{
					throw new ResponseException(500, messageSources.get("brand.carousel.ad.audit-au","5"));
				}
			}
		}
		User user = UserUtil.getUser();
		Response<Boolean> result = brandService.createGoodsBrandDetail(model, user);
		if (result.isSuccess()) {
			return result.getResult();
		} else {
			log.error("failed to create {},error code:{}", model, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	/**
	 * 校验轮播广告ID是否存在
	 */
	@RequestMapping(value = "/checkCarouselId", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String checkCarouselId(Integer slide){
		Response<AdvertisingManageModel> slide2Model = advertisingManageService.findById(slide);
		if(!slide2Model.isSuccess()){
			log.error("Response.error,error code: {}", slide2Model.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(slide2Model.getError()));
		}
		if (slide2Model.getResult() == null) {
			//该轮播广告id不存在
			return messageSources.get("brand.carousel.ad.none");
		}else{
			AdvertisingManageModel adModel = slide2Model.getResult();
			//307382 必须是审核通过且有效的广告 niufw  2--审核通过 1--有效
			if(Contants.AD_CHECK_STATUS_1.equals(adModel.getCheckStatus()) &&
					adModel.getIsValid().equals(Contants.AD_IS_VALID_1)) {
				return "true";
			}else {
				//该轮播广告未同通过审核
				return messageSources.get("brand.carousel.ad.audit");
			}
		}
	}

	/**
	 * 获取品牌分类
	 *
	 * @return
	 */
	@RequestMapping(value = "/findBrandType", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<EspNavCategoryInfModel> findBrandType() {
		Response<List<EspNavCategoryInfModel>> response = espNavCategoryInfService.findEspNavCategoryInf();
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("findBrandType.error，error:{}", response.getError());
		throw new ResponseException(500, messageSources.get("findBrandType.error"));
	}

	@RequestMapping(value = "/changeBrandState", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean changeBrandState(Long id ,Integer state) {
		User user = UserUtil.getUser();
		Response<Boolean> response = brandService.changeBrandState(id,state,user);
		if (response.isSuccess()) {
			return response.getResult();
		}
		log.error("change.brand.state.error:{}", response.getError());
		throw new ResponseException(500, messageSources.get("change.brand.state.error"));
	}

}
