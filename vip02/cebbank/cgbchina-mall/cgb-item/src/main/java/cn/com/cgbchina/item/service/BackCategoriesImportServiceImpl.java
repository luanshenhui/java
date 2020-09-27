package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.BackCategoriesDao;
import cn.com.cgbchina.item.dto.AttributeTransDto;
import cn.com.cgbchina.item.dto.BackCategoryDto;
import cn.com.cgbchina.item.dto.BackCategoryExportDto;
import cn.com.cgbchina.item.dto.BackCategoryImportDto;
import cn.com.cgbchina.item.model.BackCategory;
import com.google.common.base.*;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;

/**
 * 后台类目的导入 Created by zhoupeng on 2016/6/29.
 */
@Service
@Slf4j
public class BackCategoriesImportServiceImpl implements BackCategoriesImportService {

	private final static String SUCCESS_FLAG_Y = "成功";
	private final static String SUCCESS_FLAG_N = "失败";

	@Resource
	private BackCategoriesDao backCategoriesDao;
	@Resource
	private BackCategoriesService backCategoriesService;

	@Override
	public Response<List<BackCategoryImportDto>> importBackCategoriesData(List<BackCategoryImportDto> details,
			User user) {
		Response<List<BackCategoryImportDto>> result = new Response<List<BackCategoryImportDto>>();

		// 1.1定义返回结果集
		List<BackCategoryImportDto> resultList = Lists.newArrayList();
		BackCategoryImportDto resultDto;
		try {
			for (BackCategoryImportDto dto : details) {

				resultDto = new BackCategoryImportDto();

				BeanMapper.copy(dto, resultDto);

				String firstBackCate = dto.getFirstBackCategory();
				String secondBackCate = dto.getSecondBackCategory();
				String thirdBackCate = dto.getThirdBackCategory();
				// 判断父级类目丢失的情况，记录并开始下一条数据操作
				if ((Strings.isNullOrEmpty(firstBackCate) && !Strings.isNullOrEmpty(secondBackCate))
						|| (Strings.isNullOrEmpty(secondBackCate) && !Strings.isNullOrEmpty(thirdBackCate))
						|| (Strings.isNullOrEmpty(firstBackCate) && !Strings.isNullOrEmpty(thirdBackCate))) {
					resultDto.setSuccessFlag(SUCCESS_FLAG_N);
					resultDto.setFailReason("子节点存在时，父节点不能为空");
					resultList.add(resultDto);
					continue;
				}
				// 一级类目
				BackCategory bcFirst = isExists(firstBackCate, 0L);
				if (null != bcFirst) {
					// 一级类目存在，并且没有子类目的情况（认为是重复数据）
					if (null == secondBackCate) {
						resultDto.setSuccessFlag(SUCCESS_FLAG_N);
						resultDto.setFailReason("该目录已经存在");
						resultList.add(resultDto);
						continue;
					}
					// 二级类目
					BackCategory bcSecond = isExists(secondBackCate, bcFirst.getId());
					if (null != bcSecond) {

						if (null == thirdBackCate) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("该目录已经存在");
							resultList.add(resultDto);
							continue;
						}
						// 三级类目
						BackCategory bcThird = isExists(thirdBackCate, bcSecond.getId());
						if (null != bcThird) {
							resultDto.setSuccessFlag(SUCCESS_FLAG_N);
							resultDto.setFailReason("该目录已经存在");
						} else {
							// 插入
							// 三级
							createBackCategory(thirdBackCate.trim(), bcSecond.getId());
							resultDto.setSuccessFlag(SUCCESS_FLAG_Y);
						}
					} else {
						// 插入
						// 二级
						Long secondId = createBackCategory(secondBackCate.trim(), bcFirst.getId());
						// 三级
						createBackCategory(thirdBackCate.trim(), secondId);
						resultDto.setSuccessFlag(SUCCESS_FLAG_Y);
					}
				} else {
					// 插入
					// 一级
					Long firstId = createBackCategory(firstBackCate.trim(), 0L);
					// 二级
					Long secondId = createBackCategory(secondBackCate.trim(), firstId);
					// 三级
					createBackCategory(thirdBackCate.trim(), secondId);

					resultDto.setSuccessFlag(SUCCESS_FLAG_Y);
				}

				resultList.add(resultDto);
			}
			result.setResult(resultList);
		} catch (Exception e) {
			log.error("import backCategories list error,cause:{}", Throwables.getStackTraceAsString(e));
			result.setError("category.import.fail");
		}
		return result;
	}

	/**
	 * 类目--导出
	 * 
	 * @param details 导出数据
	 * @return
	 */
	@Override
	public Response<List<BackCategoryExportDto>> exportBackCategoriesData(User user) {
		Response<List<BackCategoryExportDto>> response = new Response<List<BackCategoryExportDto>>();

		List<BackCategoryExportDto> dtosList = Lists.newArrayList();

		try {
			List<BackCategory> listFirst = this.backCategoriesDao.findChildrenById(0L);

			for (BackCategory backCategoryFirst : listFirst) {
				List<BackCategory> listSecond = this.backCategoriesDao.findChildrenById(backCategoryFirst.getId());

				if (null != listSecond && listSecond.size() != 0) {
					for (BackCategory backCategorySecond : listSecond) {
						List<BackCategory> listThird = this.backCategoriesDao.findChildrenById(backCategorySecond.getId());
						if (null != listThird && listThird.size() != 0) {
							for (BackCategory backCategoryThird : listThird) {
								// 属性、类目赋值（三级类目）
								findAttributes(backCategoryThird.getId(), "backCategoryThird", dtosList, backCategoryFirst,
										backCategorySecond, backCategoryThird);
							}
						} else {
							// 属性、类目赋值 （二级类目,且不存在三级类目）
							findAttributes(backCategorySecond.getId(), "backCategorySecond", dtosList, backCategoryFirst,
									backCategorySecond, null);
						}
					}
				} else {
					// 属性、类目赋值 （一级类目,且不存在二级类目）
					findAttributes(backCategoryFirst.getId(), "backCategoryFirst", dtosList, backCategoryFirst,
							null, null);
				}
			}
			response.setSuccess(true);
			response.setResult(dtosList);
		}catch (Exception e){
			log.error("export.backCategoriesExport.list.error", Throwables.getStackTraceAsString(e));
			response.setError("category.Export.fail");
			response.setSuccess(false);
		}
		return response;
	}

	/**
	 * 装填 属性信息
	 * @param id
	 * @param flag
	 * @param dtosList
	 * @param backCategoryFirst
	 * @param backCategorySecond
	 * @param backCategoryThird
	 */
	private void findAttributes(Long id, String flag, List<BackCategoryExportDto> dtosList,
			BackCategory backCategoryFirst, BackCategory backCategorySecond, BackCategory backCategoryThird) {
		Response<BackCategoryDto> resp = backCategoriesService.findChildWithAttribute(id);
		List<AttributeTransDto> listAttr = resp.getResult().getAttributeTransDtos();

		if (null == listAttr || listAttr.size() == 0) {
			BackCategoryExportDto backCategoryExportDto = new BackCategoryExportDto();
			putDto(flag, backCategoryExportDto,backCategoryFirst,backCategorySecond,backCategoryThird);
			dtosList.add(backCategoryExportDto);
			return;
		}

		for (AttributeTransDto attr : listAttr) {
			BackCategoryExportDto backCategoryExportDto = new BackCategoryExportDto();

			putDto(flag, backCategoryExportDto,backCategoryFirst,backCategorySecond,backCategoryThird);
			backCategoryExportDto.setAttributeId(attr.getId());
			backCategoryExportDto.setAttributeType(attr.getType());
			backCategoryExportDto.setAttributeName(attr.getName());

			dtosList.add(backCategoryExportDto);
		}
	}

	/**
	 * 装填 类目数据
	 * @param flag
	 * @param backCategoryExportDto
	 * @param backCategoryFirst
	 * @param backCategorySecond
	 * @param backCategoryThird
	 */
	private void putDto(String flag, BackCategoryExportDto backCategoryExportDto, BackCategory backCategoryFirst,
			BackCategory backCategorySecond, BackCategory backCategoryThird) {

		switch (flag) {
		case "backCategoryFirst":
			backCategoryExportDto.setFirstBackCategoryId(backCategoryFirst.getId());
			backCategoryExportDto.setFirstBackCategory(backCategoryFirst.getName());
			break;
		case "backCategorySecond":
			backCategoryExportDto.setFirstBackCategoryId(backCategoryFirst.getId());
			backCategoryExportDto.setFirstBackCategory(backCategoryFirst.getName());
			backCategoryExportDto.setSecondBackCategoryId(backCategorySecond.getId());
			backCategoryExportDto.setSecondBackCategory(backCategorySecond.getName());
			break;
		case "backCategoryThird":
			backCategoryExportDto.setFirstBackCategoryId(backCategoryFirst.getId());
			backCategoryExportDto.setFirstBackCategory(backCategoryFirst.getName());
			backCategoryExportDto.setSecondBackCategoryId(backCategorySecond.getId());
			backCategoryExportDto.setSecondBackCategory(backCategorySecond.getName());
			backCategoryExportDto.setThirdBackCategoryId(backCategoryThird.getId());
			backCategoryExportDto.setThirdBackCategory(backCategoryThird.getName());
			break;
		}
	}

	/**
	 * 创建类目
	 * 
	 * @param name 类目名
	 * @param parentId 父级Id
	 * @return
	 */
	public Long createBackCategory(String name, Long parentId) {

		BackCategory bc = new BackCategory();
		bc.setName(name);
		bc.setParentId(parentId);
		return this.backCategoriesDao.create(bc);
	}

	/**
	 * 根据名字查询是否存在
	 *
	 * @param name 查询的名称，父级ID
	 * @return 存在 返回 BackCategory，不存在 null
	 */
	public BackCategory isExists(String name, Long parentId) {
		List<BackCategory> children = this.backCategoriesDao.findChildrenById(parentId);

		for (BackCategory child : children) {
			if (com.google.common.base.Objects.equal(child.getName(), name.trim())) {
				return child;
			}
		}
		return null;
	}

}
