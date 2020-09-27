package com.cebbank.ccis.cebmall.common.controller;

import com.cebbank.ccis.cebmall.user.model.Address;
import com.cebbank.ccis.cebmall.user.service.AddressService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("/api/address")
@Slf4j
public class Addresses {

	@Resource
	private AddressService addressService;
	@Resource
	private MessageSources messageSources;

	@RequestMapping(value = "/provinces", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Address> provinces() {
		Response<List<Address>> result = addressService.provinces();
		if (!result.isSuccess()) {
			log.error("find provinces failed, cause:{}", result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}

	@RequestMapping(value = "/province/{provinceId}/cities", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Address> cities(@PathVariable("provinceId") Integer provinceId) {
		Response<List<Address>> result = addressService.citiesOf(provinceId);
		if (!result.isSuccess()) {
			log.error("find cities failed, provinceId={}, cause:{}", provinceId, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}

	@RequestMapping(value = "/city/{cityId}/districts", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Address> district(@PathVariable("cityId") Integer cityId) {
		Response<List<Address>> result = addressService.districtOf(cityId);
		if (!result.isSuccess()) {
			log.error("find cities failed, cityId={}, cause:{}", cityId, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
		return result.getResult();
	}

}
