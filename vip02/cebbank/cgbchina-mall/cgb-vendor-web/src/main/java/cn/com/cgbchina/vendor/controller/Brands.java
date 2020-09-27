package cn.com.cgbchina.vendor.controller;

import static com.google.common.base.Preconditions.checkArgument;

import java.text.ParseException;
import java.util.Date;

import cn.com.cgbchina.common.contants.Contants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.item.dto.BrandAuthorizeDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.service.BrandService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by Liuhan on 16-5-12.
 */
@Controller
@RequestMapping("/api/vendor/brand")
@Slf4j
public class Brands {
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Autowired
	private BrandService brandService;// 商品service
	@Autowired
	private MessageSources messageSources;

	/**
	 * 添加品牌审核信息
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Long create(BrandAuthorizeDto brandAuthorizeModel) throws ParseException {

		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 校验
			checkArgument(StringUtils.isNotBlank(brandAuthorizeModel.getBrandName()), "name is null");
			// 增加品牌审核信息
			Response<Long> result = brandService.create(brandAuthorizeModel, user);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("create.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
		}
	}

	/**
	 * 修改品牌
	 *
	 * @param brandAuthorizeModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(BrandAuthorizeDto brandAuthorizeModel) {
		try {
			// 获取用户信息
			User user = UserUtil.getUser();
			// 校验
			// checkArgument(StringUtils.isNotBlank(brandAuthorizeModel.getBrandImage()), "image is null");
			// checkArgument(StringUtils.isNotBlank(brandAuthorizeModel.getBrandAuthorizeImage()), "image is null");
			// 修改
			brandAuthorizeModel.setCreateTime(new Date());
			Response<Boolean> result = brandService.update(brandAuthorizeModel, user, Contants.BUSINESS_TYPE_YG);
			return result.getResult();
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("create.error"));
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
}
