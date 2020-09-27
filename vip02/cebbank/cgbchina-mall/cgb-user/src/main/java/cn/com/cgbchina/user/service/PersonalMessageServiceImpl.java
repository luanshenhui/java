package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.PersonalMessageDao;
import cn.com.cgbchina.user.dto.PersonalMessageDto;
import cn.com.cgbchina.user.manager.PersonalMessageManager;
import cn.com.cgbchina.user.model.PersonalMessageModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.user.UserUtil;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class PersonalMessageServiceImpl implements PersonalMessageService {
	@Resource
	private PersonalMessageDao personalMessageDao;
	@Resource
	private PersonalMessageManager personalMessageManager;

	// 我的消息分页tab数据
	@Override
	public Response<Pager<PersonalMessageDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("type") String type, @Param("user") User user) {
		Response<Pager<PersonalMessageDto>> response = new Response<Pager<PersonalMessageDto>>();
		List<PersonalMessageDto> list = Lists.newArrayList();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		// 非空判断
		if (StringUtils.isNotEmpty(type)) {
			paramMap.put("type", type);
		}
		paramMap.put("custId", user.getId());
		try {
			// 取得分页数据
			Pager<PersonalMessageModel> pager = personalMessageDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			if (pager.getTotal() > 0) {
				List<PersonalMessageModel> personList = pager.getData();
				for (PersonalMessageModel person : personList) {
					PersonalMessageDto personalMessageDto = new PersonalMessageDto();
					BeanMapper.copy(person, personalMessageDto);
					// 判断type是否为空
					if (personalMessageDto.getType() != null) {
						String typeName = personalMessageDto.getType();
						// 根据type值来确定消息类型
						// 消息类型--交易动态0售后信息1促销活动2
						if (typeName.equals("0")) {
							personalMessageDto.setTypeName(Contants.USER_MESSAGE_TYEP_0);
						}
						if (typeName.equals("1")) {
							personalMessageDto.setTypeName(Contants.USER_MESSAGE_TYEP_1);
						}
						if (typeName.equals("2")) {
							personalMessageDto.setTypeName(Contants.USER_MESSAGE_TYEP_2);
						}
					}
					list.add(personalMessageDto);
				}
			}
			Pager<PersonalMessageDto> personalMessageDtoPager = new Pager<PersonalMessageDto>(pager.getTotal(), list);
			response.setResult(personalMessageDtoPager);
			return response;
		} catch (Exception e) {
			log.error("select.MyMessage.error", Throwables.getStackTraceAsString(e));
			response.setError("select.MyMessage.error");
			return response;
		}
	}

	/**
	 * 消息全部已读功能
	 *
	 * @param personalMessageMode
	 * @return
	 */
	@Override
	public Response<Boolean> updateAllMessage(PersonalMessageModel personalMessageMode) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = personalMessageManager.updateAllMessage(personalMessageMode);
			if (!result) {
				response.setError("allMessageRead.error");
				return response;
			}
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("allMessageRead error", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
		}
		return response;
	}
}
