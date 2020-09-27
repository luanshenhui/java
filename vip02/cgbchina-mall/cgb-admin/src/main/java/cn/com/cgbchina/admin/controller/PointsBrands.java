package cn.com.cgbchina.admin.controller;

import static cn.com.cgbchina.web.utils.SafeHtmlValidator.checkScriptAndEvent;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableSet;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.service.BrandService;
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
	private String rootFilePath;

	public PointsBrands() {
		this.rootFilePath = this.getClass().getResource("/upload").getPath();
	}

	/**
	 * 新增品牌信息
	 */
	@RequestMapping(value = "/add-brand", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean createBrand(GoodsBrandModel goodsBrandModel) {
		User user = UserUtil.getUser();
		Response<Boolean> result = brandService.createBrandInfo(goodsBrandModel, user, Contants.BUSINESS_TYPE_JF);
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
		Response<GoodsBrandModel> result = brandService.checkBrandName(brandName, Contants.BUSINESS_TYPE_JF);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("find.errror，erro:{}", brandName, result.getError());
		throw new ResponseException(500, messageSources.get("find.error"));
	}

	/**
	 * 查询所有品牌的名字和品牌模糊查询（产品用）
	 *
	 * @param brandName 品牌名称
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
		Response<Integer> result = brandService.findIsAuthroizeByName(brandName, Contants.BUSINESS_TYPE_JF, brandId);
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
}
