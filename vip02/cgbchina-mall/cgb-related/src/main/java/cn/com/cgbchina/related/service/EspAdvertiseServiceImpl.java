/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.related.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.related.dao.EspAdvertiseDao;
import cn.com.cgbchina.related.dto.EspAdvertiseDto;
import cn.com.cgbchina.related.manager.EspAdvertiseManager;
import cn.com.cgbchina.related.model.EspAdvertiseModel;
import com.google.common.base.Joiner;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.category.model.BackCategory;
import com.spirit.category.service.BackCategoryService;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-6-30.
 */
@Service
@Slf4j
public class EspAdvertiseServiceImpl implements EspAdvertiseService {
	@Resource

	private EspAdvertiseManager espAdvertiseManager;
	@Resource
	private EspAdvertiseDao espAdvertiseDao;

	@Resource
	BackCategoryService backCategoriesService;

	/**
	 * 手机广告新增
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	@Override
	public Response<Boolean> create(EspAdvertiseModel espAdvertiseModel, String partitionsKeyword,
			String backCategory1Id, String backCategory2Id, String backCategory3Id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			checkArgument(StringUtils.isNotBlank(espAdvertiseModel.getOrdertypeId()), "espAdvertiseModel is null");
			espAdvertiseModel.setPageType(Contants.PAGETYPE_P1);// 页面类型 01：首页,02：频道,P1 :手机广告
			espAdvertiseModel.setPublishStatus(Contants.PUBLISHSTATUSS_21);// 发布状态 21是等待发布
			espAdvertiseModel.setIsStop(Contants.ISSTOP_0);// 是否启用标志 0-停止，1-启用
			// 图片上传
			if (StringUtils.isNotEmpty(espAdvertiseModel.getAdvertiseImage())) {
				espAdvertiseModel.setAdvertiseImage(espAdvertiseModel.getAdvertiseImage());
			}
			// keyword字段是关键字 分区和类别使用 advertiseHref字段是页面和超链接使用 以下判断方便区分
			// 如果业务类型为积分商城JF 那么关键字keyword为分区或者类别 链接为超链接 跳转类型linkType为3 那么keyword为分区 为4时是类别
			if (Contants.ORDERTYPEID_JF.equals(espAdvertiseModel.getOrdertypeId())
					&& Contants.LINGKTYPE_3.equals(espAdvertiseModel.getLinkType())) {
				espAdvertiseModel.setKeyword(partitionsKeyword);
			}
			if (Contants.ORDERTYPEID_JF.equals(espAdvertiseModel.getOrdertypeId())
					&& Contants.LINGKTYPE_4.equals(espAdvertiseModel.getLinkType())) {
                String categoryUnion = Joiner.on(">").skipNulls().join(Strings.emptyToNull(backCategory1Id),
                        Strings.emptyToNull(backCategory2Id),
                        Strings.emptyToNull(backCategory3Id));
				espAdvertiseModel.setKeyword(categoryUnion);
			}
			espAdvertiseManager.insert(espAdvertiseModel);
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), espAdvertiseModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "default.create.error");
		}
		return response;
	}

	/**
	 * 手机广告更新
	 *
	 * @param id
	 * @param espAdvertiseModel
	 * @return
	 */
	@Override
	public Response<Boolean> update(String id, EspAdvertiseModel espAdvertiseModel, String partitionsKeyword,
			String backCategory1Id, String backCategory2Id, String backCategory3Id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			checkArgument(StringUtils.isNotBlank(espAdvertiseModel.getLinkType()), "espAdvertiseModel is null");
			// 获取ID
			espAdvertiseModel.setId(Long.valueOf(id));
			espAdvertiseModel.setPageType(Contants.PAGETYPE_P1);// 页面类型 01：首页,02：频道,P1 :手机广告
			espAdvertiseModel.setPublishStatus(Contants.PUBLISHSTATUSS_21);// 发布状态 21是等待发布
			espAdvertiseModel.setIsStop(Contants.ISSTOP_0);// 是否启用标志 0-停止，1-启用
			espAdvertiseModel.setDelFlag(Contants.DEL_FG_0);
			//清空非所需数据
			switch (espAdvertiseModel.getLinkType()){
				case "1":
					espAdvertiseModel.setAdvertiseHref("");
					break;
				case "2":
					espAdvertiseModel.setKeyword("");
					break;
				case "3":
					espAdvertiseModel.setAdvertiseHref("");
					break;
				case "4":
					espAdvertiseModel.setAdvertiseHref("");
					break;
				case "5":
					espAdvertiseModel.setKeyword("");
					break;
			}
			// 图片上传
			if (StringUtils.isNotEmpty(espAdvertiseModel.getAdvertiseImage())) {
				espAdvertiseModel.setAdvertiseImage(espAdvertiseModel.getAdvertiseImage());
			}
			// keyword字段是关键字 分区和类别使用 advertiseHref字段是页面和超链接使用 以下判断方便区分
			// 如果业务类型为积分商城JF 那么关键字keyword为分区或者类别 链接为超链接 跳转类型linkType为3 那么keyword为分区 为4时是类别
			if (Contants.ORDERTYPEID_JF.equals(espAdvertiseModel.getOrdertypeId())
					&& Contants.LINGKTYPE_3.equals(espAdvertiseModel.getLinkType())) {
				espAdvertiseModel.setKeyword(partitionsKeyword);
			}
			if (Contants.ORDERTYPEID_JF.equals(espAdvertiseModel.getOrdertypeId())
					&& Contants.LINGKTYPE_4.equals(espAdvertiseModel.getLinkType())) {
                String categoryUnion = Joiner.on(">").skipNulls().join(Strings.emptyToNull(backCategory1Id),
                        Strings.emptyToNull(backCategory2Id),
                        Strings.emptyToNull(backCategory3Id));
				espAdvertiseModel.setKeyword(categoryUnion);
			}
			Boolean result = espAdvertiseManager.update(espAdvertiseModel);
			response.setResult(Boolean.TRUE);
		} catch (IllegalArgumentException e) {
			log.error(e.getMessage(), espAdvertiseModel, Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("create.error,error code:{}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, "default.update.error");
		}
		return response;
	}

	/**
	 * 删除
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	@Override
	public Response<Boolean> delete(EspAdvertiseModel espAdvertiseModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean result = espAdvertiseManager.delete(espAdvertiseModel);
			if (!result) {
				response.setError("delete.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("delete.espAdvertise.error", Throwables.getStackTraceAsString(e));
			response.setError("delete.error");
			return response;
		}
	}

	/**
	 * 发布手机广告
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	@Override
	public Response<Boolean> updateAdvetiseStatus(EspAdvertiseModel espAdvertiseModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			espAdvertiseModel.setPublishStatus(Contants.PUBLISHSTATUSS_00);// 00：已发布
            espAdvertiseModel.setIsStop(Contants.ISSTOP_1);// 1 启用
			Boolean result = espAdvertiseManager.updateAdvetiseStatus(espAdvertiseModel);
			if (!result) {
				response.setError("update.espAdvertise.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.espAdvertise.error", Throwables.getStackTraceAsString(e));
			response.setError("update.espAdvertise.error");
			return response;
		}
	}

	/**
	 * 更新启用状态
	 *
	 * @param espAdvertiseModel
	 * @return
	 */
	@Override
	public Response<Boolean> updateIsStop(EspAdvertiseModel espAdvertiseModel) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			if (Contants.ISSTOP_0.equals(espAdvertiseModel.getIsStop())) {
				espAdvertiseModel.setIsStop(Contants.ISSTOP_1);
			} else {
				espAdvertiseModel.setIsStop(Contants.ISSTOP_0);
			}
			Boolean result = espAdvertiseManager.updateIsStop(espAdvertiseModel);
			if (!result) {
				response.setError("update.espAdvertise.error");
				return response;
			}
			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("update.espAdvertise.error", Throwables.getStackTraceAsString(e));
			response.setError("update.espAdvertise.error");
			return response;
		}
	}

	/**
	 * 手机广告查询
	 * 
	 * @param pageNo
	 * @param size
	 * @param advertisePos
	 * @param publishStatus
	 * @return
	 */
	@Override
	public Response<Pager<EspAdvertiseDto>> findByPage (Integer pageNo, Integer size, String ordertypeId,
			String advertisePos, String publishStatus) {
		Response<Pager<EspAdvertiseDto>> response = new Response<Pager<EspAdvertiseDto>>();
		List<BackCategory> backCategoryList = Lists.newArrayList();
		// 创建List DTo实例对象
		List<EspAdvertiseDto> espAdvertiseDtos = new ArrayList<EspAdvertiseDto>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		// 根据条件查询 去掉前后空格
		if (StringUtils.isNotEmpty(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId.trim().replace(" ", ""));
		}
		if (StringUtils.isNotEmpty(advertisePos)) {
			paramMap.put("advertisePos", advertisePos.trim().replace(" ", ""));
		}
		if (StringUtils.isNotEmpty(publishStatus)) {
			paramMap.put("publishStatus", publishStatus.trim().replace(" ", ""));
		}
		try {
			Pager<EspAdvertiseModel> pager = espAdvertiseDao.findByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			if (pager.getTotal() > 0) {

				List<EspAdvertiseModel> espAdvertiseModelList = pager.getData();
				// 循环取值set
				for (EspAdvertiseModel esp : espAdvertiseModelList) {
                    EspAdvertiseDto espAdvertiseDto = new EspAdvertiseDto();
					BeanMapper.copy(esp, espAdvertiseDto);
					// 因类别存储的是列别id 所以需要页面初始化时根据类别id进行查询类别name
						if ("4".equals(esp.getLinkType())) {
                            // 拆字符串
                            String[] keywordList = esp.getKeyword().split(">");
							Long[] str = new Long[keywordList.length];
							for (int i = 0; i < keywordList.length; i++) {
								if(Strings.isNullOrEmpty(keywordList[i])){
									break;
								}
								str[i] = Long.valueOf(keywordList[i]);
								Response<BackCategory> backCategoryRespone = backCategoriesService.findById(str[i]);
								if (backCategoryRespone.isSuccess()&&backCategoryRespone!=null) {
                                    Method method =  espAdvertiseDto.getClass().getMethod("setBackCategory" + String.valueOf(i+1) + "Name", String.class);
                                    method.invoke(espAdvertiseDto, backCategoryRespone.getResult().getName());
								}
							}
					}
                    espAdvertiseDtos.add(espAdvertiseDto);
				}
			}
			Pager<EspAdvertiseDto> pagerProduct = new Pager<EspAdvertiseDto>(pager.getTotal(), espAdvertiseDtos);
			response.setResult(pagerProduct);
			return response;
		} catch (Exception e) {
			log.error("default term query error{}", Throwables.getStackTraceAsString(e));
			response.setError("default.term.query.error");
			return response;
		}

	}

	/**
	 * 顺序校验
	 *
	 * @param checkAdvertiseSeq
	 * @return
	 */
	@Override
	public Response<Boolean> checkAdvertiseSeq(Long id, String checkAdvertiseSeq) {
		Response<Boolean> response = new Response<Boolean>();
		// 新增和编辑对checkAdvertiseSeq的校验区分 当id为null时是新增操作 不为null时是编辑操作
		if (id != null) {
			// 当为编辑操作时 先通过id查出该条数据的checkAdvertiseSeq
			EspAdvertiseModel espAdvertiseModel = espAdvertiseDao.findById(id);
			// 如果不相同 代表编辑操作更改了 这样就是查询全部来校验 如果相同 即可以编辑
			if (!checkAdvertiseSeq.equals(String.valueOf(espAdvertiseModel.getAdvertiseSeq()))) {
				// 取得相同的条数 大于0代表有重复
				Long total = espAdvertiseDao.checkAdvertiseSeq(checkAdvertiseSeq);
				if (total != 0) {
					response.setResult(Boolean.FALSE);
				} else {
					response.setResult(Boolean.TRUE);
				}
			}else{
				response.setResult(Boolean.TRUE);

			}
		} else {
			// 新增时走以下方法
			Long total = espAdvertiseDao.checkAdvertiseSeq(checkAdvertiseSeq);
			if (total != 0) {
				response.setResult(Boolean.FALSE);
			} else {
				response.setResult(Boolean.TRUE);
			}
		}

		return response;
	}

	/**
	 * 查询有效广告，外部接口调用
	 *
	 * @param paramMap 参数Map
	 * @return 广告列表
	 * <p/>
	 * geshuo 20160721
	 */
	public Response<List<EspAdvertiseModel>> findAvailableAds(Map<String, Object> paramMap) {
		Response<List<EspAdvertiseModel>> response = Response.newResponse();
		try {
			List<EspAdvertiseModel> result = espAdvertiseDao.findAvailableAds(paramMap);
			response.setResult(result);
		} catch (Exception e) {
			log.error("EspAdvertiseServiceImpl.findAvailableAds error {}", Throwables.getStackTraceAsString(e));
			response.setError("EspAdvertiseServiceImpl.findAvailableAds error");
		}
		return response;
	}

}
