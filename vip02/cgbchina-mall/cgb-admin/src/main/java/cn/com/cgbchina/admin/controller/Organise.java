package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.model.OrganiseModel;
import cn.com.cgbchina.user.service.OrganiseService;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.UserNotLoginException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
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

/**
 * Created by 11140721050130 on 2016/5/8.
 */
@Controller
@RequestMapping("/api/admin/org")
@Slf4j
public class Organise {

	@Resource
	private MessageSources messageSources;
	@Resource
	private OrganiseService organiseService;

	@RequestMapping(value = "/add", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(OrganiseModel organiseModel) {
		User user = UserUtil.getUser();
		if (user == null) {
			throw new UserNotLoginException(messageSources.get("user.not.login.yet"));
		}
		organiseModel.setCreateOper(user.getId().toString());
		Response<Boolean> result = organiseService.create(organiseModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to create {},error code:{}", organiseModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/edit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String update(@PathVariable("id") String code, OrganiseModel organiseModel) {
        User user = UserUtil.getUser();
		organiseModel.setCode(code);
        organiseModel.setModifyOper(user.getName());
		Response<Boolean> result = organiseService.update(organiseModel);
		if (result.isSuccess()) {
			return "ok";
		}
		log.error("failed to update {},error code:{}", organiseModel, result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	@RequestMapping(value = "/delete/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public String delete(@PathVariable("id") String code) {
        User user = UserUtil.getUser();
        OrganiseModel organiseModel = new OrganiseModel();
        organiseModel.setModifyOper(user.getName());
        organiseModel.setCode(code);
        organiseModel.setDelFlag(Contants.DEL_FLAG_1);
		Response<Boolean> result = organiseService.delete(organiseModel);
		if (result.isSuccess()) {
			return "ok";
		} else {
			log.error("failed to delete organiseModel where code={},error code:{}", code, result.getError());
			throw new ResponseException(500, messageSources.get(result.getError()));
		}
	}

    @RequestMapping(value = "findAll", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<OrganiseModel> findNameAll() {
        Response< List<OrganiseModel>> result = organiseService.findAll();
        if (result.isSuccess()) {
            return result.getResult();
        } else {
            log.error("failed to delete organiseModel where code={},error code:{}", result.getError());
            throw new ResponseException(500, messageSources.get(result.getError()));
        }
    }
}
