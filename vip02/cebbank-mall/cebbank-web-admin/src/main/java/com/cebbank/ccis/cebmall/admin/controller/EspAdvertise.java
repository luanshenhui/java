package com.cebbank.ccis.cebmall.admin.controller;



import com.cebbank.ccis.cebmall.user.model.EspAdvertiseModel;
import com.cebbank.ccis.cebmall.user.service.EspAdvertiseService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-1.
 */
@Controller
@RequestMapping("/api/admin/espAdvertise")
@Slf4j
public class EspAdvertise {
	@Autowired
	private EspAdvertiseService espAdvertiseService;
	@Autowired
	MessageSources messageSources;

	/**
	 * 手机广告新增
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	@RequestMapping(value = "/add",method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(EspAdvertiseModel espAdvertiseModel, String partitionsKeyword,
						  @RequestParam(value = "backCategory1Id", required = false) String backCategory1Id,
						  @RequestParam(value = "backCategory2Id", required = false) String backCategory2Id,
						  @RequestParam(value = "backCategory3Id", required = false) String backCategory3Id) {
		User user = UserUtil.getUser();
		String createName = user.getName();
		espAdvertiseModel.setCreateOper(createName);
		Response<Boolean> booleanResponse = espAdvertiseService.create(espAdvertiseModel, partitionsKeyword,
                backCategory1Id, backCategory2Id, backCategory3Id);
		if (booleanResponse.isSuccess()) {
			return booleanResponse.getResult();
		}
		log.error("insert.error，erro:{}", booleanResponse.getError());
		throw new ResponseException(500, messageSources.get(booleanResponse.getError()));
	}

	/**
	 * 手机广告更新
	 *
	 * @param id
	 * @param espAdvertiseModel
	 * @return
	 */
	@RequestMapping(value = "edit/{id}", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(@PathVariable String id, EspAdvertiseModel espAdvertiseModel, String partitionsKeyword,
                          @RequestParam(value = "backCategory1Id", required = false) String backCategory1Id,
                          @RequestParam(value = "backCategory2Id", required = false) String backCategory2Id,
                          @RequestParam(value = "backCategory3Id", required = false) String backCategory3Id) {
		User user = UserUtil.getUser();
		String createName = user.getName();
		espAdvertiseModel.setModifyOper(createName);
		Response<Boolean> result  = espAdvertiseService.update(id, espAdvertiseModel, partitionsKeyword, backCategory1Id,backCategory2Id,backCategory3Id);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("update.error，erro:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));
	}

	/**
	 * 手机广告删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(Long id) {
		Response<Boolean> result = Response.newResponse();
		try {
			EspAdvertiseModel espAdvertiseModel = new EspAdvertiseModel();
			espAdvertiseModel.setId(id);
			User user = UserUtil.getUser();
			espAdvertiseModel.setModifyOper(user.getName());
			result = espAdvertiseService.delete(espAdvertiseModel);
		} catch (Exception e) {
			log.error("detele.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

	/**
	 * 手机广告发布
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/announcement", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> updateAdvetiseStatus(Long id) {
		Response<Boolean> result = Response.newResponse();
		try {
			EspAdvertiseModel espAdvertiseModel = new EspAdvertiseModel();
			espAdvertiseModel.setId(id);
			User user = UserUtil.getUser();
			espAdvertiseModel.setModifyOper(user.getName());
			result = espAdvertiseService.updateAdvetiseStatus(espAdvertiseModel);
		} catch (Exception e) {
			log.error("update.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

	/**
	 * 手机广告启用状态更新
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/updateIsStop", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> updateIsStop(Long id, String isStop) {
		Response<Boolean> result = Response.newResponse();
		try {
			checkArgument(StringUtils.isNotBlank(isStop), "isStop.not.empty");// 开启状态不能为空
			EspAdvertiseModel espAdvertiseModel = new EspAdvertiseModel();
			espAdvertiseModel.setId(id);
			espAdvertiseModel.setIsStop(isStop);
			User user = UserUtil.getUser();
			espAdvertiseModel.setModifyOper(user.getName());
			result = espAdvertiseService.updateIsStop(espAdvertiseModel);
		} catch (IllegalArgumentException e) {
			log.error("update.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("update.advertise.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}


    /**
     * 顺序唯一性校验
     *
     * @param advertiseSeq
     * @return
     * @author :yuxinxin
     */
    @RequestMapping(value = "checkAdvertiseSeq", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Boolean checkAdvertiseSeq(@RequestParam(value = "advertiseSeq", required = true) String advertiseSeq, Long id) {
        try {
            Response<Boolean> result = espAdvertiseService.checkAdvertiseSeq(id, advertiseSeq);
			if(!result.isSuccess()){
				log.error("Response.error,error code: {}", result.getError());
				throw new ResponseException(500, messageSources.get(result.getError()));
			}
            return result.getResult();
        } catch (Exception e) {
            log.error("check.checkAdvertiseSeq.error:{}", Throwables.getStackTraceAsString(e));
            throw new ResponseException(500, messageSources.get("check.error"));
        }
    }

}
