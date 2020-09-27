package cn.com.cgbchina.admin.controller;

import static com.google.common.base.Preconditions.checkArgument;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.xml.sax.SAXException;

import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.AttributeKey;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ProductModel;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ProductService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by zhoupeng on 16-4-13. 产品管理页面(积分商品)
 */
@Controller
@RequestMapping("/api/admin/pointsProducts") // 请求映射
@Slf4j // 日志
public class PointsProducts {
	private final static Set<String> allowed_types = ImmutableSet.of("xls", "xlsx");
	@Autowired
	private ProductService productService;
	@Autowired
	private BackCategoriesService backCategoriesService;
	@Autowired
	private MessageSources messageSources;
	@Autowired
	private GoodsService goodsService;

	/**
	 * 查看产品功能
	 *
	 * @param id
	 * @return
	 * @author :tanliang
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	public ProductModel checkProduct(@PathVariable Long id) {
		// 根据id查询
		Response<ProductDto> result = productService.findProductById(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("check.product.error,error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 删除产品功能
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String delete(@PathVariable("id") Long id) {
		// 如果产品关联了商品不允许被删除
		List<GoodsModel> list = Lists.newArrayList();
		Response<List<GoodsModel>> responseGoods = goodsService.findGoodsByProductId(id);
		if(responseGoods.isSuccess()){
			list = responseGoods.getResult();
		}
		// list>0 证明有多条商品关联 不允许删除
		if (list.size() > 0) {
			return "don't delete";
		} else {
			// 根据id删除
			Response<Boolean> result = productService.deleteProductById(id);
			if (result.isSuccess()) {
				return "ok";
			} else {
				log.error("delete.product.error,error code:{}", id, result.getError());
				throw new ResponseException(500, messageSources.get(result.getError()));
			}
		}
	}

	/**
	 * 新增、编辑产品功能
	 *
	 * @param id
	 * @param productDto
	 * @return
	 */
	@RequestMapping(value = "productOperation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String editProduct(@RequestParam(value = "id", required = false) Long id, ProductDto productDto) {
		try {
			User user = UserUtil.getUser();
			// 获取DTO内的参数，为空即抛异常
			checkArgument(StringUtils.isNotEmpty(productDto.getBrandName()), "brandName.is.empty");
			checkArgument(StringUtils.isNotEmpty(productDto.getName()), "productName.is.empty");
			checkArgument(StringUtils.isNotEmpty(productDto.getCategoryList()), "categoryList.is.empty");
			if (StringUtils.isNotEmpty(productDto.getManufacturer())) {
				productDto.setManufacturer(productDto.getManufacturer().trim());
			}
			productDto.setName(productDto.getName().trim());
			// 拆分后台类目
			List<String> list = Arrays.asList(productDto.getCategoryList().split(">"));
			if (list.get(0) != null && list.get(1) != null && list.get(2) != null) {
				long id1 = Long.parseLong(list.get(0));
				productDto.setBackCategory1Id(id1);
				long id2 = Long.parseLong(list.get(1));
				productDto.setBackCategory2Id(id2);
				long id3 = Long.parseLong(list.get(2));
				productDto.setBackCategory3Id(id3);
			} else {
				log.error("insert.categoryList.error,error code:{}");
				throw new ResponseException(500, messageSources.get("insert.categoryList.error"));
			}
			if (id != null) {
				// 获取产品id ，如果有id 进行编辑操作 否则进行新增操作
				productDto.setId(id);
			}
			Response<Boolean> result = productService.saveOrEditProduct(productDto, user);
			if (result.isSuccess()) {
				return "ok";
			} else {
				log.error("updateProduct.error,error code:{}", productDto, result.getError());
				throw new ResponseException(500, messageSources.get(result.getError()));
			}
		} catch (IllegalArgumentException e) {
			// 不合法的参数异常
			log.error("inputProduct.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			// 更新失败
			log.error("updateProduct.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("update.error"));
		}
	}

	/**
	 * 新增产品选择三级类目取出产品属性
	 *
	 * @param id
	 * @return
	 */

	@RequestMapping(value = "/findChildWithAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ItemsAttributeDto findChildWithAttribute(Long id) {
		Response<AttributeDto> response = backCategoriesService.getAttributeById(id);
		try {
			ItemsAttributeDto itemsAttributeDto = new ItemsAttributeDto();
			if (response.isSuccess()) {
				if (response.getResult() == null) {
					itemsAttributeDto.setAttributes(null);
					itemsAttributeDto.setSkus(null);
					return itemsAttributeDto;
				}
				// 非空判断
				if (response.getResult().getAttribute() != null || response.getResult().getSku() != null) {
					List<ItemAttributeDto> attributes = Lists.newArrayList();
					List<ItemsAttributeSkuDto> skus = Lists.newArrayList();
					AttributeDto dto = response.getResult();
					// 循环产品属性
					if (dto.getAttribute() != null) {
						ItemAttributeDto itemAttributeDto = null;
						for (AttributeKey attr : dto.getAttribute()) {
							itemAttributeDto = new ItemAttributeDto();
							itemAttributeDto.setAttributeKey(attr.getId());
							itemAttributeDto.setAttributeName(attr.getName());
							attributes.add(itemAttributeDto);
						}
					}
					if (dto.getSku() != null) {
						ItemsAttributeSkuDto itemsAttributeSkuDto = null;
						// 循环产品销售属性
						for (AttributeKey sku : dto.getSku()) {
							itemsAttributeSkuDto = new ItemsAttributeSkuDto();
							itemsAttributeSkuDto.setAttributeValueKey(sku.getId());
							itemsAttributeSkuDto.setAttributeValueName(sku.getName());
							skus.add(itemsAttributeSkuDto);
						}
					}
					// 将attributes，skus赋值itemsAttributeDto 统一名字
					itemsAttributeDto.setAttributes(attributes);
					itemsAttributeDto.setSkus(skus);
				}
			}
			return itemsAttributeDto;
		} catch (Exception e) {
			log.error("add.productAttribute.error", id, response.getError());
			throw new ResponseException(500, messageSources.get(response.getError()));
		}
	}

	/**
	 * 产品名称重复校验
	 *
	 * @param name
	 * @return
	 * @author :tanliang modify:同三级类目下的产品名称不能重复，并非同一类下的产品名称可以重复 2016-6-2
	 */
	@RequestMapping(value = "checkProductName", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean checkProduct(@RequestParam(value = "name", required = true) String name,
			@RequestParam(value = "id", required = false) Long id,
			@RequestParam(value = "backCategory3Id", required = true) Long backCategory3Id) {
		try {
			Response<Boolean> result = productService.findByName(name, id, backCategory3Id);
			return result.getResult();
		} catch (Exception e) {
			log.error("check.productCheckName.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("check.error"));
		}
	}

	/**
	 * 下载导入模板
	 */

	/**
	 * 通过EXCEL模板导入产品数据
	 */
	@RequestMapping(value = "/uploadExcelProduct", method = RequestMethod.POST, produces = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public String uploadExcelProduct(@RequestParam(required = false) String category,
			MultipartHttpServletRequest request) throws IOException, InvalidFormatException, SAXException {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new ResponseException(401, messageSources.get("user.not.login"));
		}
        Iterator<String> excelFileName = request.getFileNames();
		Map<String, Object> dataBeans = new HashMap<String, Object>();
		List<ProductDto> productDtoList = Lists.newArrayList();
		dataBeans.put("data", productDtoList);
		try {
			ExcelUtil.importExcelToData(dataBeans, new FileInputStream(new File("D:/students.xls")),
					new FileInputStream(new File("D:/students.xml")));
		} catch (IOException e) {

			e.printStackTrace();
		} catch (SAXException e) {

			e.printStackTrace();
		} catch (InvalidFormatException e) {

			e.printStackTrace();
		}
        return "ok";
	}
}

