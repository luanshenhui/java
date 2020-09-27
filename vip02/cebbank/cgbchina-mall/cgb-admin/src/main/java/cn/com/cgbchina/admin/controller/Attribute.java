package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.item.model.AttributeKey;
import cn.com.cgbchina.item.service.AttributeKeyService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.util.List;

/**
 * 属性管理
 */

@Controller
@RequestMapping("/api/admin/attribute")
@Slf4j
public class Attribute {

	@Autowired
	private AttributeKeyService attributeService;
	@Autowired
	private MessageSources messageSources;

	/**
	 * 添加
	 *
	 * @param attributeKey
	 * @return
	 */

	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<String> create(@Valid AttributeKey attributeKey, BindingResult bindingResult) {
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
		Response<Boolean> result = attributeService.create(attributeKey);
		if (result.isSuccess()) {
			response.setResult(result.getResult().toString());
			return response;
		}
		log.error("failed to create {},error code:{}", attributeKey, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable Long id) {
		Response<Boolean> response = new Response<Boolean>();
		if (id == null) {
			response.setError("delete.id.notNull");
			return response;
		}
		Response<Boolean> result = attributeService.delete(id);
		if (result.getResult()) {
			response.setResult(result.getResult());
			return response;
		}
		log.error("failed to create {},error code:{}", id, result.getError());
		response.setError(messageSources.get(result.getError()));
		throw new ResponseException(500, messageSources.get(result.getError()));
	}
}
