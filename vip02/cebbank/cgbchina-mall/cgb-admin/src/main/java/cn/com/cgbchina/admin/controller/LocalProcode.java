package cn.com.cgbchina.admin.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dto.CardProDto;
import cn.com.cgbchina.user.dto.LocalProcodeDto;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.model.LocalProcodeModel;
import cn.com.cgbchina.user.service.CardProService;
import cn.com.cgbchina.user.service.LocalProcodeService;
import com.google.common.base.Throwables;
import com.spirit.common.model.Pager;
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

import javax.annotation.Resource;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by yuxinxin on 16-6-12.
 */
@Controller
@RequestMapping("/api/admin/localProcode")
@Slf4j
public class LocalProcode {
	@Autowired
	LocalProcodeService localProcodeService;
	@Autowired
	MessageSources messageSources;
	@Resource
	CardProService cardProService;

	/**
	 * 白金卡等级新增
	 *
	 * @param localProcodeModel
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean create(LocalProcodeModel localProcodeModel) {
		// 校验搜索词名称非空
		checkArgument(StringUtils.isNotBlank(localProcodeModel.getProCode()), "proCode.not.empty");
		checkArgument(StringUtils.isNotBlank(localProcodeModel.getProNm()), "proNm.not.empty");
		// 获取登录人
		User user = UserUtil.getUser();
		String createName = user.getName();
		localProcodeModel.setCreateOper(createName);
		Response<Boolean> booleanResponse = localProcodeService.create(localProcodeModel);
		if (booleanResponse.isSuccess()) {
			return booleanResponse.getResult();
		}
		log.error("insert.error，erro:{}", booleanResponse.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(booleanResponse.getError()));
	}

	/**
	 * 唯一性check
	 * 
	 * @param proCode
	 * @param proNm
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "checkLocalProCode", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public LocalProcodeDto checkServicePromise(String proCode, String proNm, Long id) {
		try {
			Response<LocalProcodeDto> result = localProcodeService.findNameByName(proCode, proNm, id);
			return result.getResult();
		} catch (Exception e) {
			log.error("check.checkLocalProCode.error:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get("check.error"));
		}
	}

	/**
	 * 白金卡等级删除
	 *
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Response<Boolean> delete(@PathVariable("id") Long id) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			LocalProcodeModel localProcodeModel = new LocalProcodeModel();
			localProcodeModel.setId(Long.valueOf(id));
			localProcodeModel.setModifyOper("admin");// TODO
			// defaultSearchModel.setDelFlag("1");
			result = localProcodeService.delete(localProcodeModel);
		} catch (IllegalArgumentException e) {
			log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		} catch (Exception e) {
			log.error("detele.error，erro:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(500, messageSources.get(e.getMessage()));
		}
		return result;

	}

	/**
	 * 白金卡等级更新
	 *
	 * @param localProcodeModel
	 * @return
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Boolean update(@PathVariable("id") Long id, LocalProcodeModel localProcodeModel) {
		Response<Boolean> result = new Response<Boolean>();
		// 校验搜索词名称非空
		checkArgument(StringUtils.isNotBlank(localProcodeModel.getProNm()), "proNm.not.empty");
		checkArgument(StringUtils.isNotBlank(localProcodeModel.getProCode()), "proCode.not.empty");
		User user = UserUtil.getUser();
		String createName = user.getName();
		localProcodeModel.setModifyOper(createName);
		result = localProcodeService.update(id, localProcodeModel);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("update.error，erro:{}", result.getError());
		throw new ResponseException(Contants.ERROR_CODE_500, messageSources.get(result.getError()));
	}

	/**
	 * 获取未绑定的卡类卡板列表
	 * 
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@RequestMapping(method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<CardPro> findAllCardPro(@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size) {
		User user = UserUtil.getUser();
		Response<Pager<CardPro>> result = cardProService.findAllCardPro(pageNo, size, user);
		if (result.isSuccess()) {
			return result.getResult();

		}
		log.error("failed to selectCardPro where CardProLike={},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

	/**
	 * 获取已绑定卡类卡板列表
	 * 
	 * @param pageNo
	 * @param size
	 * @return
	 */
	@RequestMapping(value = "/{proCode}", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public Pager<CardProDto> findCardProCode(@PathVariable("proCode") String proCode,
			@RequestParam(value = "pageNo", required = false) Integer pageNo,
			@RequestParam(value = "size", required = false) Integer size) {
		Response<Pager<CardProDto>> result = cardProService.findCardProCode(pageNo, size, proCode);
		if (result.isSuccess()) {
			return result.getResult();
		}
		log.error("failed to selectCardPro where CardProLike={},error code:{}", result.getError());
		throw new ResponseException(500, messageSources.get(result.getError()));

	}

}
