package cn.com.cgbchina.admin.controller;

import com.spirit.common.model.Response;
import com.spirit.core.enums.ComponentCategory;
import com.spirit.core.model.ComponentModel;
import com.spirit.core.service.ComponentService;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by changji.zhang on 15-12-30.
 */
@Controller
@RequestMapping("/api/admin/components")
@Slf4j
public class Compontents {

	@Autowired
	private ComponentService componentService;
	@Autowired
	private MessageSources messageSources;

	@RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<ComponentModel> list() {
		Response<List<ComponentModel>> result = componentService.all();
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to list all components,error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Long create(ComponentModel component, @RequestParam("componentCategory") String category) {
		component.setComponentCategory(ComponentCategory.valueOf(category.toUpperCase()));
		Response<Long> result = componentService.create(component);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error code:{}", component, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(@PathVariable("id") Long id, ComponentModel component) {
		component.setId(id);
		Response<Boolean> result = componentService.update(component);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update {},error code:{}", component, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ComponentModel view(@PathVariable("id") Long id) {
		Response<ComponentModel> result = componentService.findById(id);
		if (result.isSuccess()) {
			return result.getResult();
		} else {
			log.error("failed to find component where id= {},error code:{}", id, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String delete(@PathVariable("id") Long id) {
		Response<Boolean> result = componentService.delete(id);
		if (result.isSuccess()) {
			return "ok";
		} else {
			log.error("failed to delete component where id={},error code:{}", id, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

	@RequestMapping(value = "/{id}/edit", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ComponentModel edit(@PathVariable("id") Long id) {
		Response<ComponentModel> result = componentService.findById(id);
		if (result.isSuccess()) {
			return result.getResult();
		} else {
			log.error("failed to find component where id= {},error code:{}", id, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

}
