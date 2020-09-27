package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.dto.CategoryMappingDto;
import cn.com.cgbchina.item.dto.FrontCategoryDto;
import cn.com.cgbchina.item.dto.FrontCategoryEditDto;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.FrontCategory;
import cn.com.cgbchina.item.service.BackCategoriesService;
import cn.com.cgbchina.item.service.FrontCategoriesService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.Arrays;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/4/28.
 */
@Controller
@Slf4j
@RequestMapping("/api/admin/frontCategories")
public class FrontCategories {
	@Resource
	private MessageSources messageSources;
	@Resource
	private FrontCategoriesService frontCategoriesService;
	@Resource
	private BackCategoriesService backCategoriesService;

	/**
	 * 返回自增的id
	 *
	 * @param frontCategory
	 * @param bindingResult
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Long> create(@Valid FrontCategory frontCategory, BindingResult bindingResult) {
		Response<Long> response = new Response<Long>();
		if (bindingResult.hasErrors()) {
			for (FieldError fieldError : bindingResult.getFieldErrors()) {
				response.setError(fieldError.getDefaultMessage());
				return response;
			}
		}
		Response<Long> result = frontCategoriesService.create(frontCategory);
		if (result.isSuccess()) {
			response.setResult(result.getResult());
			return response;
		}
		log.error("failed to create {},error code:{}", frontCategory, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 更新
	 *
	 * @param frontCategory
	 * @return
	 */
	@RequestMapping(method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(@Valid FrontCategoryEditDto frontCategory, BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
			for (FieldError fieldError : bindingResult.getFieldErrors()) {
				Response<Boolean> response = new Response<>();
				response.setError(fieldError.getDefaultMessage());
				return response;
			}
		}
		Response<Boolean> result = frontCategoriesService.update(frontCategory);
		if (result.isSuccess()) {
			return result;
		}
		log.error("failed to create {},error code:{}", frontCategory, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean delete(@PathVariable Long id) {
		BackCategory model = new BackCategory();
		model.setId(id);
		Response<Boolean> result = frontCategoriesService.delete(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete {},error code:{}", model, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	@RequestMapping(value = "/childrenFrontCategory", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public FrontCategoryDto childrenFrontCategory(Long id) {

		Response<FrontCategoryDto> result = frontCategoriesService.childrenWithMapping(id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to find {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 返回后台类目的树
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/withoutAttribute", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<BackCategory> withoutAttribute(Long id) {

		Response<List<BackCategory>> result = backCategoriesService.withoutAttribute(id);
		if (result.isSuccess()) {

			return result.getResult();
		}
		log.error("failed to find {},error code:{}", id, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	@RequestMapping(value = "/addCategoryMapping", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean addCategoryMapping(@RequestBody CategoryMappingDto[] categoryMappingArr) {
		Response<Boolean> result = frontCategoriesService.addCategoryMapping(Arrays.asList(categoryMappingArr));
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to add mapping {},error code:{}", categoryMappingArr, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	@RequestMapping(value = "/deleteBackMapping", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean deleteBackMapping(@RequestBody @Valid CategoryMappingDto categoryMappingDto,
			BindingResult bindingResult) {
		Response<String> response = new Response<>();
		// 判断校验是否成功
		if (bindingResult.hasErrors()) {
			StringBuilder sb = new StringBuilder();
			List<FieldError> fieldErrors = bindingResult.getFieldErrors();
			for (FieldError fieldError : fieldErrors) {
				sb.append(fieldError.getDefaultMessage());
			}
			throw new ResponseException(500, sb.toString());
		}

		Response<Boolean> result = frontCategoriesService.deleteBackMapping(categoryMappingDto);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to delete mapping {},error code:{}", categoryMappingDto, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/changeSort", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean changeSort(Long currentId, Long changeId) {

		Response<Boolean> result = frontCategoriesService.changeSord(currentId, changeId);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to change sort currentId is {},changeId is {},error code:{}", currentId, changeId,
				result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

}
