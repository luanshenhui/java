package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.trade.model.PointCollocation;
import cn.com.cgbchina.trade.service.PointCollocationService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by yuxinxin on 16-4-15.
 */
@Controller
@RequestMapping("/api/admin/collocation")
@Slf4j
public class PointsCollocationSell {
	@Autowired
	PointCollocationService pointCollocationService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 批量删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean delete(@PathVariable String id) {
		PointCollocation pointCollocation = new PointCollocation();
		pointCollocation.setId(id);
		Response<Boolean> result = pointCollocationService.deleteAll(pointCollocation);

		if (result.isSuccess()) {
			return result.getResult();
		}
		throw new ResponseException(500, messageSources.get(result.getError()));

	}
}
