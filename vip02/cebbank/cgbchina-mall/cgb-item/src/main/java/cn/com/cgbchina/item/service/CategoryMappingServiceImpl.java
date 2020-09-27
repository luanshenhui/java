package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.CategoryMappingDao;
import cn.com.cgbchina.item.dao.FrontCategoryDao;
import cn.com.cgbchina.item.dto.CategoryMappingDto;
import cn.com.cgbchina.item.dto.FrontCategoryMappingDto;
import cn.com.cgbchina.item.model.FrontCategory;
import com.google.common.base.Predicate;
import com.google.common.base.Throwables;
import com.google.common.collect.Collections2;
import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.IteratorUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

/**
 * Created by 郝文佳 on 2016/5/16.
 */
@Service
@Slf4j
public class CategoryMappingServiceImpl implements CategoryMappingService {
	private final static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	private CategoryMappingDao categoryMappingDao;
	@Resource
	private FrontCategoryDao frontCategoryDao;
	@Resource
	private FrontCategoriesService frontCategoriesService;

	@Override
	public Response<List<FrontCategoryMappingDto>> frontByFrontIds(Iterable<String> ids) {
		Response<List<FrontCategoryMappingDto>> response = new Response<>();
		try {
			List<FrontCategory> frontCategories = frontCategoryDao.findByIds(ids);

			// 对所有前台类目 计算出当前层级
			List<FrontCategoryMappingDto> frontCategoryMappingDtos = new ArrayList<>();
			for (FrontCategory frontCategory : frontCategories) {
				FrontCategoryMappingDto frontCategoryMappingDto = new FrontCategoryMappingDto();
				BeanMapper.copy(frontCategory, frontCategoryMappingDto);
				frontCategoryMappingDto
						.setLevel(frontCategoriesService.ancestorsOfNoCache(frontCategory.getId()).getResult().size());
				frontCategoryMappingDtos.add(frontCategoryMappingDto);
			}
			response.setResult(frontCategoryMappingDtos);
		} catch (Exception e) {
			log.warn("can not find front category with ids = {}", ids, Throwables.getStackTraceAsString(e));
			response.setError("category.not.found");
		}
		return response;
	}

	@Override
	public Response<List<CategoryMappingDto>> findByBackIds(final Iterable<Long> ids) {
		Response<List<CategoryMappingDto>> response = new Response<>();
		Set<String> groupSet = categoryMappingDao.groupSet();
		List<CategoryMappingDto> categoryMappingDtos = new ArrayList<>();
		for (String groupId : groupSet) {
			categoryMappingDtos.add(jsonMapper.fromJson(groupId, CategoryMappingDto.class));
		}
		// 对所有mapping进行过滤 过滤出参数传进来的 包含所有后台类目的
		Collection<CategoryMappingDto> filter = Collections2.filter(categoryMappingDtos,
				new Predicate<CategoryMappingDto>() {
					@Override
					public boolean apply(@Nullable CategoryMappingDto input) {
						Boolean flag = Boolean.FALSE;
						for (Long id : ids) {
							if (id.equals(input.getBackCategoryId())) {
								flag = Boolean.TRUE;
								break;
							}
						}
						return flag;
					}
				});
		response.setResult(IteratorUtils.toList(filter.iterator()));
		return response;
	}

	@Override
	public Response<List<CategoryMappingDto>> getMappingByFrontId(String frontId) {
		Response<List<CategoryMappingDto>> response = new Response<>();
		Set<String> groupSet = categoryMappingDao.getMappingByFrontId(frontId);
		List<CategoryMappingDto> categoryMappingDtos = new ArrayList<>();
		for (String groupId : groupSet) {
			categoryMappingDtos.add(jsonMapper.fromJson(groupId, CategoryMappingDto.class));
		}
		response.setResult(categoryMappingDtos);
		return response;
	}
}
