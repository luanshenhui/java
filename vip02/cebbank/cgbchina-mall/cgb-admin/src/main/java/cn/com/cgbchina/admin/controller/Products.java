package cn.com.cgbchina.admin.controller;

import static com.google.common.base.Preconditions.checkArgument;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.utils.ExcelUtil;
import cn.com.cgbchina.common.utils.ExportUtils;
import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.AttributeKey;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ProductModel;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ProductService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by Tanliang on 16-4-13. 产品管理页面
 */
@Controller
@RequestMapping("/api/admin/products") // 请求映射
@Slf4j // 日志
public class Products {
    private final static Set<String> allowed_types = ImmutableSet.of("xls", "xlsx");
    @Autowired
    private ProductService productService;
    @Autowired
    private BackCategoriesService backCategoriesService;
    @Autowired
    private MessageSources messageSources;
    @Autowired
    private GoodsService goodsService;

    @Value("#{app.fileUploadPath}")
    private String rootFilePath;

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
        Response<List<GoodsModel>> responselist = goodsService.findGoodsByProductId(id);
        if(responselist.isSuccess()) {
            // list>0 证明有多条商品关联 不允许删除
            if (responselist.getResult().size() > 0) {
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
        } else {
            log.error("delete.product.error,error code:{}", id, responselist.getError());
            throw new ResponseException(500, messageSources.get(responselist.getError()));
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
            if (result.getResult()) {
                return "ok";
            } else {
                log.error("updateProduct.error,error code:{}", productDto, result.getError());
                throw new ResponseException(500, messageSources.get(result.getError()));
            }
        } catch (IllegalArgumentException e) {
            // 不合法的参数异常
            log.error("inputProduct.error, error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get(e.getMessage()));
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
            log.error("add.productAttribute.error,error code:{}", id, response.getError());
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
    @RequestMapping(value = "/exportProductTemplate")
    public void exportProductTemplate(HttpServletResponse response) {
        String fileName = "产品导入模板.xlsx";// 输出给前台显示的文件名
        String filePath = rootFilePath + "/template/productImport.xlsx";// 文件的绝对路径
        Map<String, Object> context = Maps.newHashMap();
        context.put("products", Collections.emptyList());
        try {
            ExportUtils.exportTemplate(response, fileName, filePath, context);
        } catch (Exception e) {
            // 此处不处理异常，这些方法不会抛异常，抛出的运行时异常框架会将页面跳走
            log.error("fail to export excel template,error code:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get("export.template.excel.error"));
        }
    }

    /**
     * 产品批量导入
     *
     * @return
     */

    @RequestMapping(value = "/uploadProduct", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public void uploadProduct(MultipartFile files, HttpServletResponse httpServletResponse, String ordertypeId) {
        FileInputStream fileInputStream = null;
        User user = UserUtil.getUser();
        try {
            String fileName = "产品导入结果.xlsx";// 输出给前台显示的文件名
            Map<String, Object> dataBeans = new HashMap<String, Object>();
            List<UploadProductDto> details = new ArrayList<UploadProductDto>();
            dataBeans.put("products", details);
            fileInputStream = new FileInputStream(rootFilePath + "/config/products.xml");
            ExcelUtil.importExcelToData(dataBeans, files.getInputStream(), fileInputStream);
            Response<List<UploadProductDto>> response = productService.uploadProduct(details, ordertypeId, user);
            Map<String, Object> map = Maps.newHashMap();
            map.put("products", response.getResult());
            ExportUtils.exportTemplate(httpServletResponse, fileName, rootFilePath + "/template/productImport.xlsx", map);
        } catch (Exception e) {
            log.error("uploadProduct.error, error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get("uploadProduct.error"));
        } finally {
            if (fileInputStream != null) {
                try {
                    fileInputStream.close();
                } catch (IOException e) {
                    log.error("uploadProduct.error, error:{}", Throwables.getStackTraceAsString(e));
                }
            }
        }
    }
}

