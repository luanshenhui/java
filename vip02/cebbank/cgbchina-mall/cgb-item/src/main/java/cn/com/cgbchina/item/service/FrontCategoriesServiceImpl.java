package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.BackCategoriesDao;
import cn.com.cgbchina.item.dao.CategoryMappingDao;
import cn.com.cgbchina.item.dao.FrontCategoryDao;
import cn.com.cgbchina.item.dto.CategoryMappingDto;
import cn.com.cgbchina.item.dto.FrontCategoryDto;
import cn.com.cgbchina.item.dto.FrontCategoryEditDto;
import cn.com.cgbchina.item.model.FrontCategory;
import com.google.common.base.*;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.ListUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/4/28.
 */
@Service
@Slf4j
public class FrontCategoriesServiceImpl implements FrontCategoriesService {
	public final static Integer MAX_ALLOWED_LEVEL = 3;
	@Resource
	private FrontCategoryDao frontCategoryDao;
	@Resource
	private BackCategoriesDao backCategoriesDao;
	@Resource
	private CategoryMappingDao categoryMappingDao;

	/**
	 * @param frontCategory
	 * @return
	 */
	@Override
	public Response<Long> create(FrontCategory frontCategory) {
		Response<Long> result = new Response<>();
		if (Strings.isNullOrEmpty(frontCategory.getName())) {
			log.error("front category name  couldn't be empty");
			result.setError("category.name.not.empty");
			return result;
		}
		try {
			Long parentId = MoreObjects.firstNonNull(frontCategory.getParentId(), 0L);
			frontCategory.setParentId(parentId);
			// 看当前节点的父节点是否已经绑定了后台类目
			if (categoryMappingDao.isExist(parentId)) {
				log.error("front category couldn't have child node");
				result.setError("front.back.mapping.exist");
				return result;
			}
			if (parentId > 0L) {
				FrontCategory parent = this.frontCategoryDao.findById(parentId);
				if (parent == null) {
					log.error("can't find parent front category by id={}", frontCategory.getParentId());
					result.setError("parent.category.not.found");
					return result;
				}
				int parentLevel = (ancestorsOfNoCache(parent.getId()).getResult()).size();
				if (parentLevel >= MAX_ALLOWED_LEVEL) {
					log.error("exceed max allowed level");
					result.setError("category.level.overflow");
					return result;
				}
			}
			List<FrontCategory> children = this.frontCategoryDao.findChildrenById(parentId);
			for (FrontCategory fc : children) {
				if (Objects.equal(fc.getName(), frontCategory.getName().trim())) {
					log.error("front category name {} duplicated under the same parent(id={})", frontCategory.getName(),
							frontCategory.getParentId());

					result.setError("category.name.duplicated");
					return result;
				}
			}
			frontCategory.setName(frontCategory.getName().trim());

			// 返回自增的id
			Long id = frontCategoryDao.create(frontCategory);
			result.setResult(id);
			return result;
		} catch (Exception e) {
			log.error("failed to create front category {}, cause: {}", frontCategory,
					Throwables.getStackTraceAsString(e));
			result.setError("category.create.fail");
		}
		return result;
	}

	/**
	 * 通过节点id 得出他是第几级
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<List<Long>> ancestorsOfNoCache(Long id) {
		Response<List<Long>> result = new Response<List<Long>>();
		if (id == null) {
			log.error("back category id can not be null");
			result.setError("id.not.null.fail");
			return result;
		}
		List ancestors = Lists.newArrayListWithCapacity(3);
		Long current = id;
		try {
			while (current >= 1L) {
				FrontCategory frontCategory = this.frontCategoryDao.findById(current);
				if (frontCategory == null) {
					log.warn("can not find front category with id = {}", current);
					result.setError("category.not.found");
					return result;
				}
				ancestors.add(current);
				current = frontCategory.getParentId();
			}
			result.setResult(Lists.reverse(ancestors));
			return result;
		} catch (Exception e) {
			log.error("failed to find ancestors of front category(id={}),cause:{}", id,
					Throwables.getStackTraceAsString(e));
			result.setError("category.query.fail");
		}
		return result;
	}

	/**
	 * 通过id查询子节点 不包含上面已经绑定的后台类目
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<List<FrontCategory>> findChildById(Long id) {
		Response<List<FrontCategory>> response = new Response<>();
		try {

			List<FrontCategory> childrenById = frontCategoryDao.findChildrenById(id);
			for (FrontCategory temp : childrenById) {
				temp.setIsParent(frontCategoryDao.isParent(temp.getId()));
			}
			response.setResult(childrenById);
		} catch (Exception e) {
			log.error("failed to find child node id={};cause by {}", id, Throwables.getStackTraceAsString(e));
			response.setError("category.child.not.error");
			return response;
		}
		return response;
	}

	/**
	 * 带后台类目的前台类目子节点
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<FrontCategoryDto> childrenWithMapping(Long id) {
		Response<FrontCategoryDto> response = new Response<>();
		FrontCategoryDto frontCategoryDto = new FrontCategoryDto();
		try {
			// 获取所有子节点
			List<FrontCategory> children = frontCategoryDao.findChildrenById(id);
			for (FrontCategory temp : children) {
				temp.setIsParent(frontCategoryDao.isParent(temp.getId()));
			}
			frontCategoryDto.setFrontCategories(children);
			// 获取当前类目挂载的所哟后台类目
			List<CategoryMappingDto> categoryMappings = frontCategoryDao.findCategoryMapping(id);
			frontCategoryDto.setCategoryMappingDtos(categoryMappings);

			response.setResult(frontCategoryDto);
		} catch (Exception e) {
			log.error("failed to find child node id={},cause by{}", id, Throwables.getStackTraceAsString(e));
			response.setError("category.child.not.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<Boolean> delete(Long id) {
		Response result = new Response();
		if (id == null) {
			log.error("front category id can not be null");
			result.setError("id.not.null.fail");
			return result;
		}
		try {
			FrontCategory fc = this.frontCategoryDao.findById(id);
			if (fc == null) {
				log.error("failed to find front category where id={}", id);
				result.setError("category.not.found");
				return result;
			}

			List children = this.frontCategoryDao.findChildrenById(id);
			if (!children.isEmpty()) {
				log.error("front category(id={}) is not leaf, delete fail", id);
				result.setError("category.not.leaf");
				return result;
			}
			// 判断是否有子节点成功
			// 下面判断是否有后台类目挂载 有后台类目挂载不允许删除
			if (categoryMappingDao.isExist(id)) {
				log.error("failed to delete front category with id={}", id);
				result.setError("category.delete.fail");
				return result;
			}

			this.frontCategoryDao.delete(id);
			result.setResult(Boolean.TRUE);
			return result;
		} catch (Exception e) {
			log.error("failed to delete front category with id={}, cause: {}", id, Throwables.getStackTraceAsString(e));
			result.setError("category.delete.fail");
		}
		return result;
	}

	@Override
	public Response<FrontCategory> findById(Long id) {
		Response<FrontCategory> result = new Response<>();
		if (id == null) {
			log.error("front category id can not be null");
			result.setError("id.not.null.fail");
			return result;
		}
		try {
			FrontCategory frontCategory = this.frontCategoryDao.findById(id);
			if (frontCategory == null) {
				log.error("can not find front category where id={}", id);
				result.setError("category.not.found");
				return result;
			}
			result.setResult(frontCategory);
			return result;
		} catch (Exception e) {
			log.error("failed to query front category cause by{}", Throwables.getStackTraceAsString(e));
			result.setError("category.query.fail");
		}
		return result;
	}

	@Override
	public Response<Boolean> update(FrontCategoryEditDto frontCategoryEditDto) {
		Response<Boolean> result = new Response<Boolean>();
		if (frontCategoryEditDto.getId() == null) {
			result.setError("id.not.null.fail");
			return result;
		}
		try {
			FrontCategory existed = this.frontCategoryDao.findById(frontCategoryEditDto.getId());
			if (existed == null) {
				log.error("no front category found by id={}", frontCategoryEditDto.getId());
				result.setError("category.not.found");
				return result;
			}
			this.frontCategoryDao.update(frontCategoryEditDto);
			result.setResult(Boolean.TRUE);
			return result;
		} catch (Exception e) {
			log.error("failed to update front category {}, cause: {}", frontCategoryEditDto,
					Throwables.getStackTraceAsString(e));
			result.setError("category.update.fail");
		}
		return result;
	}

	/**
	 * 为前台类目绑定后台类目
	 *
	 * @return
	 */
	@Override
	public Response<Boolean> addCategoryMapping(List<CategoryMappingDto> categoryMappingDtos) {
		Response<Boolean> response = new Response<>();
		// list为空直接返回 前台已经验证一回了
		if ((categoryMappingDtos.size() == 0)) {
			response.setResult(Boolean.TRUE);
			return response;
		}
		try {
			// 取出任意一条获取前台类目的id
			Long frontCateogoryId = categoryMappingDtos.get(0).getFrontCategoryId();
			// 通过此id查找到已经绑定的所有后台类目
			List<CategoryMappingDto> alreadyMapping = frontCategoryDao.findCategoryMapping(frontCateogoryId);
			List intersection = ListUtils.intersection(alreadyMapping, categoryMappingDtos);
			if (intersection.size() > 0) {
				response.setError("category.mapping.create.error");
				return response;
			}

			frontCategoryDao.addCategoryMapping(frontCateogoryId, categoryMappingDtos);

			// 已经被绑定的后台类目 需要在后台类目的字段中维护一个count 如果count值大于零 说明有前台类目绑定 后台类目就不让删了

			Collection<String> backCategoryIds = Collections2.transform(categoryMappingDtos,
					new Function<CategoryMappingDto, String>() {
						@Nullable
						@Override
						public String apply(@Nullable CategoryMappingDto input) {
							return input.getBackCategoryId().toString();
						}
					});
			backCategoriesDao.incrCount(backCategoryIds, 1);

			response.setResult(Boolean.TRUE);

		} catch (Exception e) {
			log.error("failed to addCategoryMapping {} , cause: {}", categoryMappingDtos,
					Throwables.getStackTraceAsString(e));
			response.setError("category.mapping.create.error");
		}

		return response;

	}

	/**
	 * 删除前台类目绑定的后台类目
	 *
	 * @param categoryMappingDto
	 * @return
	 */
	@Override
	public Response<Boolean> deleteBackMapping(CategoryMappingDto categoryMappingDto) {
		Response<Boolean> response = new Response<>();
		try {

			frontCategoryDao.deleteBackMapping(categoryMappingDto);
			// 删除当前绑定的后台类目后 需要将后台类目的count值减1
			backCategoriesDao.incrCount(Arrays.<String> asList(categoryMappingDto.getBackCategoryId().toString()), -1);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to delete mapping node", categoryMappingDto,Throwables.getStackTraceAsString(e));
			response.setError("category.mapping.delete.error");
			return response;
		}
		return response;

	}

	@Override
	public Response<Boolean> changeSord(Long currentId, Long changeId) {

		Response<Boolean> response = new Response<>();
		try {

			FrontCategory exists = frontCategoryDao.findById(currentId);
			if (exists == null) {
				log.error("failed to change front category sort", currentId, changeId);
				response.setError("category.exchange.sort.error");
				return response;

			}
			frontCategoryDao.changeSort(currentId, changeId, exists.getParentId());
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to change front category sort currentId={},changeId={};cause by {}", currentId, changeId,Throwables.getStackTraceAsString(e));
			response.setError("category.exchange.sort.error");
			return response;
		}
		return response;
	}

	@Override
	public Response<List<FrontCategory>> findByIds(Iterable<String> ids) {

		Response<List<FrontCategory>> response = new Response<>();
		try {

			frontCategoryDao.findByIds(ids);
		} catch (Exception e) {
			log.error("failed to find front category ids", ids, Throwables.getStackTraceAsString(e));
			response.setError("query.error");
			return response;
		}
		return response;
	}
}
