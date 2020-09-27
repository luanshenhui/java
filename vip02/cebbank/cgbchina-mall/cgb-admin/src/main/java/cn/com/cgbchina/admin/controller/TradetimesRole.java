package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.trade.model.DeadlineModel;
import cn.com.cgbchina.trade.service.TradeTimeRoleService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

@Controller
@RequestMapping("/api/admin/tradeTimeRole")
@Slf4j
public class TradetimesRole {
	@Autowired
	TradeTimeRoleService tradeTimeRoleService;

	@Autowired
	MessageSources messageSources;

	@RequestMapping(value = "/{params}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> update(String params) {
		// 校验
		Response<Boolean> result = null;
		String[] a = params.split(",");
		Map map = new HashMap();
		for (int i = 0; i < a.length; i++) {
			String b = a[i].toString();
			String[] c = b.split(":");
			map.put("id" + i, c[0]);
			map.put("end" + i, c[1]);
			map.put("wait" + i, c[2]);
		}
		try {
			// 校验

			// 1234435:123@345||3423432:234@3242
			// checkArgument(StringUtils.isNotBlank(deadlineModel.getRule()), "rule.not.empty");
			// 更新
			// List<DeadlineModel> list = JSON_MAPPER.fromJson(params, JSON_MAPPER.createCollectionType(List.class,
			// DeadlineModel.class));
			for (int i = 0; i < (map.size() / 3); i++) {
				DeadlineModel deadlineModel = new DeadlineModel();
				deadlineModel.setId(Long.valueOf(map.get("id" + i).toString()));
				deadlineModel.setEnd(Integer.valueOf(map.get("end" + i).toString()));
				deadlineModel.setWarn(Integer.valueOf(map.get("wait" + i).toString()));
				deadlineModel.setUpdateOper("admin");
				result = tradeTimeRoleService.update(deadlineModel);
			}
		} catch (IllegalArgumentException e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.errror，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("update.error"));
		}
		return result;
	}

	public final static JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();

}
