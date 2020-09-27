package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.EspPublishInfDao;
import cn.com.cgbchina.user.dto.EspPublishInfDto;
import cn.com.cgbchina.user.manager.EspPublishInfManage;
import cn.com.cgbchina.user.model.EspPublishInfModel;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * 公告管理
 *
 * @author Tanliang
 * @time 2016-6-6
 */

@Service
@Slf4j
public class EspPublishInfServiceImpl implements EspPublishInfService {
	@Resource
	private EspPublishInfDao espPublishInfDao;
	@Resource
	private EspPublishInfManage espPublishInfManage;

	@Override
	// 分页数据
	public Response<Pager<EspPublishInfDto>> findAll(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("publishTitle") String publishTitle, @Param("curStatus") String curStatus,
			@Param("startTime") String startTime) {
		Response<Pager<EspPublishInfDto>> response = new Response<Pager<EspPublishInfDto>>();
		List<EspPublishInfDto> list = Lists.newArrayList();
		Map<String, Object> paramMap = Maps.newHashMap();
		// 非空判断
		PageInfo pageInfo = new PageInfo(pageNo, size);
		if (StringUtils.isNotEmpty(publishTitle)) {
			paramMap.put("publishTitle", publishTitle);
		}
		if (StringUtils.isNotEmpty(curStatus)) {
			/* CHANGE START BY geshuo 20160729:[测试缺陷 #19911] 启用状态查询修正 ---------------- */
//			paramMap.put("publishType", curStatus);
			paramMap.put("curStatus", curStatus);
			/* CHANGE END   BY geshuo 20160729 -------------------------------------------------- */
		}
		if (StringUtils.isNotEmpty(startTime)) {
			paramMap.put("startTime", startTime);
		}
		try {
			Pager<EspPublishInfModel> pager = espPublishInfDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			if (pager.getTotal() > 0) {
				// 取得分页数据
				List<EspPublishInfModel> publishList = pager.getData();
				for (EspPublishInfModel model : publishList) {
					EspPublishInfDto espPublishInfDto = new EspPublishInfDto();
					// 循环取得数据将数据copy给DTO
					BeanMapper.copy(model, espPublishInfDto);
					// 判断公告类型不为空
					if (StringUtils.isNotEmpty(espPublishInfDto.getCurStatus())) {
						// 公告状态 0102 启用
						if (espPublishInfDto.getCurStatus().equals(Contants.PUBLISH_STATUS_CODE_0102)) {
							espPublishInfDto.setCurStatusName(Contants.PUBLISH_STATUS_NAME_0102);
						}
						// 公告状态 0101停用
						if (espPublishInfDto.getCurStatus().equals(Contants.PUBLISH_STATUS_CODE_0101)) {
							espPublishInfDto.setCurStatusName(Contants.PUBLISH_STATUS_NAME_0101);
						}
					}
					if (StringUtils.isNotEmpty(espPublishInfDto.getPublishType())) {
						// 业务订：公告类型目前只有 最新公告 “00” --2016-6-7
						if (espPublishInfDto.getPublishType().equals(Contants.PUBLISH_TYPE_CODE_00)) {
							espPublishInfDto.setPublishTypeName(Contants.PUBLISH_TYPE_NAME_00);
						}
					}
					// 将最终数据放入List 应用于前台接收展示
					list.add(espPublishInfDto);
				}
			}
			Pager<EspPublishInfDto> espPublishInfDtoPager = new Pager<EspPublishInfDto>(pager.getTotal(), list);
			response.setResult(espPublishInfDtoPager);
			return response;
		} catch (Exception e) {
			log.error("select.MyMessage.error", Throwables.getStackTraceAsString(e));
			response.setError("select.MyMessage.error");
			return response;
		}
	}

	/**
	 * 公告发布 （新增)
	 * 
	 * @param espPublishInfDto
	 * @return
	 */
	@Override
	public Response<Boolean> createPublish(EspPublishInfDto espPublishInfDto, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 创建公告实例model
			EspPublishInfModel espPublishInfModel = new EspPublishInfModel();
			// 将dto的数据给model 前给后
			BeanMapper.copy(espPublishInfDto, espPublishInfModel);
			espPublishInfModel.setCreateOper(user.getName());
			espPublishInfModel.setOrderTypeId(Contants.BUSINESS_TYPE_YG); // 业务类型YG 默认
			espPublishInfModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标识0未删除1已删除
//			espPublishInfModel.setCurStatus(Contants.PUBLISH_STATUS_CODE_0102); // 当前状态启动0102 0101未启用
			// 新增调用manage
			Boolean result = espPublishInfManage.createPublish(espPublishInfModel);
			response.setResult(result);
			if (!result) {
				response.setError("savePublish.error");
				return response;
			}
			return response;
		} catch (Exception e) {
			log.error("savePublish.error,error code:{}", Throwables.getStackTraceAsString(e));
			response.setError("savePublish.error");
			return response;
		}
	}

	/**
	 * 公告查看 根据id查询
	 * 
	 * @param id
	 * @return
	 */
	@Override
	public Response<EspPublishInfDto> findPublishById(Long id) {
		Response<EspPublishInfDto> response = new Response<>();
		EspPublishInfModel espPublishInfModel = espPublishInfDao.findById(id);
		if (espPublishInfModel != null) {
			EspPublishInfDto espPublishInfDto = new EspPublishInfDto();
			// 将model的值给DTO
			BeanMapper.copy(espPublishInfModel, espPublishInfDto);
			// 判断公告类型不为空
			if (StringUtils.isNotEmpty(espPublishInfModel.getCurStatus())) {
				// 公告状态 0102 启用
				if (espPublishInfModel.getCurStatus().equals(Contants.PUBLISH_STATUS_CODE_0102)) {
					espPublishInfDto.setCurStatusName(Contants.PUBLISH_STATUS_NAME_0102);
				}
				// 公告状态 0101停用
				if (espPublishInfModel.getCurStatus().equals(Contants.PUBLISH_STATUS_CODE_0101)) {
					espPublishInfDto.setCurStatusName(Contants.PUBLISH_STATUS_NAME_0101);
				}
			}
			if (StringUtils.isNotEmpty(espPublishInfModel.getPublishType())) {
				// 业务订：公告类型目前只有 最新公告 “00” --2016-6-7
				if (espPublishInfModel.getPublishType().equals(Contants.PUBLISH_TYPE_CODE_00)) {
					espPublishInfDto.setPublishTypeName(Contants.PUBLISH_TYPE_NAME_00);
				}
			}
			response.setResult(espPublishInfDto);
		}
		return response;
	}

	/**
	 * 入口页公告栏装修展示
	 *
	 * @param ids
	 * @return
	 */
    public Response<Map<String, Object>> findPublishByIds(@Param("ids") List<String> ids){
		Response<Map<String, Object>> response = Response.newResponse();
		Map<String, Object> mapParam = Maps.newHashMap();
		try {
			Response<List<EspPublishInfModel>> resultFindByIds = findByIds(ids);
			if(resultFindByIds.isSuccess()){
				List<EspPublishInfModel> spPublishInfDtoList = resultFindByIds.getResult();
				mapParam.put("publishList", spPublishInfDtoList);
			}

        } catch (Exception e) {
            log.error("findPublishByIds.error,error code:{}", Throwables.getStackTraceAsString(e));
            response.setError("findPublishByIds.error");
        }
		response.setResult(mapParam);
		return response;
    }

	/**
	 * 通过公告ID List 查询公告详细信息
	 *
	 * @param ids
	 * @return
	 */
	public Response<List<EspPublishInfModel>> findByIds(List<String> ids){
		Response<List<EspPublishInfModel>> response = Response.newResponse();
		if (ids == null || ids.size() == 0) {
			response.setResult(Collections.<EspPublishInfModel>emptyList());
			return response;
		}
		try {
			List<EspPublishInfModel> publishInfoList = espPublishInfDao.findByIds(ids);
			response.setResult(publishInfoList);
		} catch (Exception e) {
			log.error("findByCodes.item.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("findByCodes.item.error");
		}
		return response;
	}
	/**
	 * 更新公告启用停用状态
	 *
	 * @return
	 */
	public Response<Boolean> updatePublishStatus(String state,String code,User user){
		EspPublishInfModel espPublishInfModel = new EspPublishInfModel();
		espPublishInfModel.setModifyOper(user.getName());
		if (Contants.PUBLISH_STATUS_CODE_0102.equals(state)){
			espPublishInfModel.setCurStatus(Contants.PUBLISH_STATUS_CODE_0101);
		}
		if (Contants.PUBLISH_STATUS_CODE_0101.equals(state)){
			espPublishInfModel.setCurStatus(Contants.PUBLISH_STATUS_CODE_0102);
		}
		checkArgument(StringUtils.isNotBlank(code), "publishcode.is.null");
		espPublishInfModel.setId(Long.parseLong(code));
		Response<Boolean> response = Response.newResponse();
		Integer num = espPublishInfManage.update(espPublishInfModel);
		if (num == 1){
			response.setResult(Boolean.TRUE);
			return response;
		}else{
			response.setResult(Boolean.FALSE);
			return response;
		}
	}

	public Response<Integer> update(EspPublishInfModel espPublishInfModel){
		Response<Integer> result = new Response<Integer>();
		try {
			Integer count = espPublishInfManage.update(espPublishInfModel);
			result.setResult(count);
			return result;
		} catch (Exception e) {
			log.error("publish update error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("publish.update.error");
			return result;
		}
	}

	@Override
	public Response<List<EspPublishInfModel>> findPublishIsNow(){
		Response<List<EspPublishInfModel>> result = Response.newResponse();
		try {
			List<EspPublishInfModel> publishList = espPublishInfDao.findPublishIsNow();
			result.setResult(publishList);
			return result;
		}catch (Exception e){
			log.error("find publish is now,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("find.publish.is.now.error");
			return result;
		}
	}
}