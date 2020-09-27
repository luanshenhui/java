package cn.com.cgbchina.vendor.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;

import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.OrderPartBackService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by yuxinxin on 16-5-10.
 */
@Controller
@Slf4j
@RequestMapping("/api/vendor/reviewed")
public class OrderPartBack {
	@Autowired
	OrderPartBackService orderPartBackService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 审核撤单, 供应商端使用此方法
	 *
	 * @param orderSubModel
	 * @return
	 * @throws IOException
	 * @throws ClassNotFoundException
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response updateRevocation(OrderSubModel orderSubModel, String memo, String memoExt) {
		try {
			// 更新操作
			User user = UserUtil.getUser();
			orderSubModel.setModifyOper(user.getName());

			Response<Boolean> result = orderPartBackService.updateRevocation(orderSubModel, memo, memoExt);
			return result;
		} catch (IllegalArgumentException e) {
			log.error("update.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			// 更新失败
			log.error("update.error, error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("update.error"));
		}
	}

	/**
	 * 批量撤单
	 *
	 * @param array
	 * @return
	 */
	@RequestMapping(value = "/updateAllRevocation", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean updateAllRevocation(@RequestParam(value = "array[]") Long[] array, String memo,String memoExt) {
		Response<Integer> response = new Response<Integer>();
		Boolean dateleFlag = false;
		List<String> updateAll = Lists.newArrayList();
		// 循环取出id
		for (Long orderId : array) {
			updateAll.add(orderId.toString());
		}
        User user = UserUtil.getUser();
		// 调用批量删除方法
		response = orderPartBackService.updateAllRevocation(user,updateAll, memo,memoExt);
		if (response.isSuccess()) {
			dateleFlag = true;
			return dateleFlag;
		}
		log.error("failed to update all {},errco code:{}");
		throw new ResponseException(500, messageSources.get(response.getError()));
	}
}
