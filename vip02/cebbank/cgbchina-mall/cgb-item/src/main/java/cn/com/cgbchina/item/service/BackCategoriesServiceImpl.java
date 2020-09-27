package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.AttributeKeyDao;
import cn.com.cgbchina.item.dao.BackCategoriesDao;
import cn.com.cgbchina.item.dto.AttributeDto;
import cn.com.cgbchina.item.dto.AttributeTransDto;
import cn.com.cgbchina.item.dto.BackCategoryDto;
import cn.com.cgbchina.item.dto.BackCategoryEditDto;
import cn.com.cgbchina.item.model.AttributeKey;
import cn.com.cgbchina.item.model.BackCategory;
import cn.com.cgbchina.item.model.CategoryNode;
import com.google.common.base.*;
import com.google.common.base.Objects;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import com.spirit.util.KeyUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import java.util.*;

/**
 * Created by 11150221040129 on 16-4-8.
 */
@Service
@Slf4j
public class BackCategoriesServiceImpl implements BackCategoriesService {
	private final static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	private static final int MAX_ALLOWED_LEVEL = 3;
	private static final Long countStep = -1L;
	private static final Integer attributeType = 1; // 产品属性
	private static final Integer skuType = 2;// 销售属性

	@Resource
	private BackCategoriesDao backCategoriesDao;
	@Resource
	private AttributeKeyDao attributeKeyDao;

	/**
	 * 通过父节点id查找所有子节点 不带属性值
	 *
	 * @param parentId
	 * @return
	 */
	@Override
	public Response<List<BackCategory>> withoutAttribute(Long parentId) {
		Response<List<BackCategory>> response = new Response<List<BackCategory>>();
		try {
			List<BackCategory> childrenById = backCategoriesDao.findChildrenById(parentId);
			response.setResult(childrenById);
		} catch (Exception e) {
			log.error("failed to find child node parentId={};cause by{}", parentId,
					Throwables.getStackTraceAsString(e));
			response.setError("category.child.not.error");

		}
		return response;

	}

	/**
	 * 创建类目不包含属性
	 *
	 * @param backCategory
	 * @return
	 */
	@Override
	public Response<Long> create(BackCategory backCategory) {
		Response<Long> result = new Response<Long>();
		if (Strings.isNullOrEmpty(backCategory.getName())) {
			log.error("back category name can not be null");
			result.setError("category.name.empty");
			return result;
		}
		try {
			// 根节点的parentId为0 这边就当根节点算给parentId赋值为0
			Long parentId = MoreObjects.firstNonNull(backCategory.getParentId(), Long.valueOf(0L));
			backCategory.setParentId(parentId);
			if (parentId > 0L) {
				BackCategory parent = backCategoriesDao.findById(parentId);
				if (parent == null) {
					log.error("can't find parent back category by id={}", backCategory.getParentId());
					result.setError("parent.category.not.found");
					return result;
				}
				int parentLevel = (ancestorsOfNoCache(parent.getId()).getResult()).size();
				if (parentLevel >= MAX_ALLOWED_LEVEL) {
					log.error("exceed max allowed parentLevel");
					result.setError("category.parentLevel.overflow");
					return result;
				}
			}
			List<BackCategory> children = this.backCategoriesDao.findChildrenById(parentId);

			for (BackCategory child : children) {
				if (Objects.equal(child.getName(), backCategory.getName().trim())) {
					log.error("back category name {} duplicated under the same parent(id={})", backCategory.getName(),
							backCategory.getParentId());
					result.setError("category.name.duplicated");
					return result;
				}
			}
			backCategory.setName(backCategory.getName().trim());
			Long newId = this.backCategoriesDao.create(backCategory);
			result.setResult(newId);
			return result;
		} catch (Exception e) {
			log.error("failed to create back category {}, cause: {}", backCategory,
					Throwables.getStackTraceAsString(e));
			result.setError("category.create.fail");
		}

		return result;
	}

	/**
	 * 判断当前属性列表是否包含新添加的属性列表
	 *
	 * @param attributeDto 当前节点属性
	 * @param attributeTransDto 带新增的节点属性
	 * @return
	 */
	private Boolean duplicatedCheck(AttributeDto attributeDto, AttributeTransDto attributeTransDto) {
		AttributeKey attributeKey = new AttributeKey();
		BeanMapper.copy(attributeTransDto, attributeKey);

		Set<AttributeKey> merge = new HashSet<>();

		// 产品属性
		if (attributeDto != null && attributeDto.getAttribute() != null) {
			merge.addAll(attributeDto.getAttribute());
		}
		// 销售属性
		if (attributeDto != null && attributeDto.getSku() != null) {
			merge.addAll(attributeDto.getSku());
		}
		if (merge.contains(attributeKey)) {
			return Boolean.TRUE;
		}

		return Boolean.FALSE;

	}

	/**
	 * 属性添加
	 *
	 * @param categoryId
	 * @param attributeTransDto
	 * @return
	 */
	@Override
	public Response<Boolean> addAttribute(Long categoryId, AttributeTransDto attributeTransDto) {
		Response<Boolean> response = new Response<>();
		try {
			AttributeKey store = new AttributeKey();
			BeanMapper.copy(attributeTransDto, store);
			// 拿到当前节点属性 判断非重

			BackCategory currentCategory = backCategoriesDao.findById(categoryId);

			log.error("拿到了当前后台类目的节点，当前节点为{}", currentCategory.toString());
			if (currentCategory == null) {
				log.error("back category not found", categoryId, attributeTransDto);
				response.setError("category.not.found");
				return response;
			}
			AttributeDto currentAttribute = jsonMapper.fromJson(currentCategory.getAttribute(), AttributeDto.class);
			// 判断当前节点属性重复
			Boolean aBoolean = duplicatedCheck(currentAttribute, attributeTransDto);
			if (aBoolean) {
				response.setError("category.attribute.duplicated");
				return response;
			}
			// 拿到父节点属性 判断非重
			AttributeDto parentsAttribute = backCategoriesDao.findParentsAttribute(currentCategory.getParentId());
			Boolean bBoolean = duplicatedCheck(parentsAttribute, attributeTransDto);
			if (bBoolean) {
				response.setError("category.attribute.duplicated");
				return response;
			}
			// 通过重复性判断 可以插入了
			if (attributeType.equals(attributeTransDto.getType())) {
				if (currentAttribute != null) {
					if (currentAttribute.getAttribute() != null) {
						currentAttribute.getAttribute().add(store);
					} else {
						List<AttributeKey> list = Lists.newArrayList();
						list.add(store);
						currentAttribute.setAttribute(list);
					}
					// 当前属性为空
				} else {
					currentAttribute = new AttributeDto();
					List<AttributeKey> list = Lists.newArrayList();
					list.add(store);
					currentAttribute.setAttribute(list);
				}

			}
			if (skuType.equals(attributeTransDto.getType())) {
				if (currentAttribute != null) {
					if (currentAttribute.getSku() != null) {
						currentAttribute.getSku().add(store);
					} else {
						List<AttributeKey> list = Lists.newArrayList();
						list.add(store);
						currentAttribute.setSku(list);
					}
					// 当前属性为空
				} else {
					currentAttribute = new AttributeDto();
					List<AttributeKey> list = Lists.newArrayList();
					list.add(store);
					currentAttribute.setSku(list);
				}

			}

			// 判断销售属性是否多不多于八条 产品属性无限制
			if (attributeTransDto.getType() == 2) {
				Integer count = 0;
				if (currentAttribute != null && currentAttribute.getSku() != null) {
					count = count + currentAttribute.getSku().size();
				}
				if (parentsAttribute != null && parentsAttribute.getSku() != null) {
					count = count + parentsAttribute.getSku().size();
				}
				// 走到这步的时候 新建的属性节点已经加入到集合中 判断加入后的集合长度是否大于八
				if (count > 8) {
					log.error("backcategory attribute add error");
					response.setError("back.spu.length.out");
					return response;
				}

			}
			backCategoriesDao.addAttribute(categoryId, jsonMapper.toJson(currentAttribute));
			// 将属性计数加一
			attributeKeyDao.incrAttributeCount(store.getId(), Math.abs(countStep));
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("backcategory attribute add error{}", Throwables.getStackTraceAsString(e));
			response.setError("attribute.create.error");
		}
		return response;
	}

	/**
	 * @param backCategoryEditDto
	 * @return
	 */
	@Override
	public Response<Boolean> update(final BackCategoryEditDto backCategoryEditDto) {
		Response<Boolean> result = new Response<Boolean>();
		try {
			// 有子节点不允许删除 前台已经校验一次了
			if (backCategoriesDao.isParent(backCategoryEditDto.getId())) {
				result.setError("category.delete.parent.error");
				return result;
			}

			// 拿到当前节点
			BackCategory oldBackCategory = backCategoriesDao.findById(backCategoryEditDto.getId());
			if (backCategoryEditDto.getNewName().equals(backCategoryEditDto.getOldName())) {
				result.setResult(null);
				return result;
			}

			// 新建的类目名在当前父类目下是否有重复的
			List<BackCategory> currentChildren = backCategoriesDao.findChildrenById(oldBackCategory.getParentId());
			Collection<BackCategory> filterResult = Collections2.filter(currentChildren, new Predicate<BackCategory>() {
				@Override
				public boolean apply(@Nullable BackCategory input) {
					return input.getName().equals(backCategoryEditDto.getNewName());
				}
			});

			if (filterResult.size() != 0) {
				result.setError("category.name.duplicated");
				return result;
			}
			// 当前类目没有子节点，新名和旧名不一样，新建的名称不重复，允许插入
			// 新建的类目
			backCategoriesDao.update(oldBackCategory.getId(), backCategoryEditDto.getNewName());
			result.setResult(Boolean.TRUE);
			return result;
		} catch (Exception e) {
			log.error("failed to update back category", backCategoryEditDto, Throwables.getStackTraceAsString(e));
			result.setError("update.error");
			return result;
		}

	}

	/**
	 * 根据id算出处于第几层
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<List<Long>> ancestorsOfNoCache(Long id) {
		Response result = new Response();
		if (id == null) {
			log.error("back category id can not be null");
			result.setError("id.not.null.fail");
			return result;
		}
		List ancestors = Lists.newArrayListWithCapacity(3);
		Long current = id;
		try {
			while (current >= 1L) {
				BackCategory backCategory = this.backCategoriesDao.findById(current);
				if (backCategory == null) {
					log.warn("can not find back category with id = {}", current);
					result.setError("category.not.found");
					return result;
				}
				ancestors.add(current);
				current = backCategory.getParentId();
			}
			result.setResult(Lists.reverse(ancestors));
			return result;
		} catch (Exception e) {
			log.error("failed to find ancestors of back category(id={}),cause:{}", id,
					Throwables.getStackTraceAsString(e));
			result.setError("query.error");
		}
		return result;
	}

	/**
	 * @param id
	 * @return
	 */
	@Override
	public Response<BackCategory> findById(Long id) {
		Response<BackCategory> result = new Response<BackCategory>();
		if (id == null) {
			log.error("method 'findById' args 'id' cannot be null");
			result.setError("category.query.id.null");
			return result;
		}

		try {
			// 将父类目的属性挂载到当前属性下
			BackCategory category = this.backCategoriesDao.findById(id);// 当前
			result.setResult(category);
			return result;
		} catch (Exception e) {
			log.error("fail to invoke method 'findById' with id={};cause by {}", id, e);
			result.setError("category.query.fail");
		}
		return result;
	}

	@Override
	public Response<List<BackCategory>> rootNode() {
		Response<List<BackCategory>> response = new Response<List<BackCategory>>();
		try {
			List<BackCategory> childrenById = backCategoriesDao.findChildrenById(0L);
			response.setResult(childrenById);
		} catch (Exception e) {
			log.error("failed to find child node", Throwables.getStackTraceAsString(e));
			response.setError("category.child.not.error");

		}
		return response;
	}

	/**
	 * 转换器
	 *
	 * @param type
	 * @param isInherit
	 * @return
	 */
	private Function<AttributeKey, AttributeTransDto> getFunction(final Integer type, final Boolean isInherit) {
		return new Function<AttributeKey, AttributeTransDto>() {
			@Override
			public AttributeTransDto apply(AttributeKey attributeKey) {
				AttributeTransDto attributeTransDto = new AttributeTransDto();
				BeanMapper.copy(attributeKey, attributeTransDto);
				attributeTransDto.setIsInherit(isInherit);
				attributeTransDto.setType(type);
				return attributeTransDto;
			}
		};

	}

	/**
	 * @param id
	 * @return
	 */
	@Override
	public Response<BackCategoryDto> findChildWithAttribute(Long id) {
		Response<BackCategoryDto> response = new Response<BackCategoryDto>();
		try {
			// 找到所有子类目组成的集合
			BackCategoryDto backCategoryDto = new BackCategoryDto();
			List<BackCategory> backCategories = backCategoriesDao.findChildrenById(id);
			// 获取当前类目
			BackCategory current = backCategoriesDao.findById(id);
			// 当前属性列表 isInherit为false
			AttributeDto currentAttributeDto = jsonMapper.fromJson(current.getAttribute(), AttributeDto.class);
			// 父属性列表 父属性列表isInherit为true
			AttributeDto parentsAttribute = backCategoriesDao.findParentsAttribute(current.getParentId());
			List<AttributeTransDto> list = new ArrayList<AttributeTransDto>();// 集合并集
			if (currentAttributeDto != null) {
				if (currentAttributeDto.getAttribute() != null) {
					// 当前节点的产品属性 type 1
					Collection<AttributeTransDto> transform1 = Collections2
							.transform(currentAttributeDto.getAttribute(), getFunction(1, false));
					list.addAll(transform1);
				}
				if (currentAttributeDto.getSku() != null) {
					// 当前节点的销售属性 type=2
					Collection<AttributeTransDto> transform2 = Collections2.transform(currentAttributeDto.getSku(),
							getFunction(2, false));
					list.addAll(transform2);
				}
			}
			// 父节点属性不管有没有都不会是空
			// 父节点的产品属性 type=1
			Collection<AttributeTransDto> transform3 = Collections2.transform(parentsAttribute.getAttribute(),
					getFunction(1, true));
			list.addAll(transform3);
			// 父节点的销售属性
			Collection<AttributeTransDto> transform4 = Collections2.transform(parentsAttribute.getSku(),
					getFunction(2, true));
			list.addAll(transform4);
			// 集合并集
			backCategoryDto.setAttributeTransDtos(list);
			backCategoryDto.setBackCategories(backCategories);
			response.setResult(backCategoryDto);

		} catch (Exception e) {
			log.error("failed to find child node id={},cause by={}", id, Throwables.getStackTraceAsString(e));
			response.setError("category.child.not.error");
			return response;
		}

		return response;
	}

	/**
	 * 通过当前id查询子节点 不包含属性列表
	 *
	 * @param id
	 * @param currentLevel
	 * @return
	 */
	@Override
	public Response<List<CategoryNode<BackCategory>>> findChildById(Long id, final Integer currentLevel) {
		Response<List<CategoryNode<BackCategory>>> response = new Response<List<CategoryNode<BackCategory>>>();
		List<BackCategory> childrenById = null;
		try {
			childrenById = backCategoriesDao.findChildrenById(id);
		} catch (Exception e) {
			log.error("failed to find child node id={},currentLevel={},cause by{}", id, currentLevel,
					Throwables.getStackTraceAsString(e));
			response.setError("category.child.not.error");
			return response;
		}

		Function<BackCategory, CategoryNode<BackCategory>> function = new Function<BackCategory, CategoryNode<BackCategory>>() {
			@Nullable
			@Override
			public CategoryNode<BackCategory> apply(BackCategory input) {

				return new CategoryNode<>(input, currentLevel);
			}
		};
		List<CategoryNode<BackCategory>> transform = Lists.transform(childrenById, function);
		response.setResult(transform);
		return response;
	}

	/**
	 * - 删除 有子节点时候不让删 并且如果当前类目已经挂载了属性 那么会修改相关的属性节点的count值
	 *
	 * @param id
	 * @return
	 */
	@Override
	public Response<Boolean> delete(Long id) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			Boolean exists = backCategoriesDao.exists(KeyUtil.backendCategoryChildrenOf(id));
			if (exists) {
				response.setError("category.delete.parent.error");
				return response;
			}
			BackCategory currentCategory = backCategoriesDao.findById(id);
			// 删除的时候需要对该值中的count判断 如果不是零 大于零 说明有前台类目绑定在上面 不允许删除
			if (currentCategory.getCount() != null && currentCategory.getCount() > 0) {
				response.setError("front.back.mapping.not.delete");
				return response;
			}
			if (currentCategory.getGoodCount() != null && currentCategory.getGoodCount() > 0) {
				response.setError("backcategory.good.mapping.not.delete");
				return response;
			}
			// 对当前的后台类目的属性进行处理 把当前类目下所有挂载的属性的count值-1
			List<AttributeKey> currentAttribute = Lists.newArrayList();
			if (currentCategory.getAttribute() != null) {
				AttributeDto attributeDto = jsonMapper.fromJson(currentCategory.getAttribute(), AttributeDto.class);
				if (attributeDto != null) {
					if (attributeDto.getAttribute() != null) {
						currentAttribute.addAll(attributeDto.getAttribute());
					}
					if (attributeDto.getSku() != null) {
						currentAttribute.addAll(attributeDto.getSku());
					}
				}
			}
			// 所有减一
			attributeKeyDao
					.incrAttributesCount(Collections2.transform(currentAttribute, new Function<AttributeKey, Long>() {
						@Nullable
						@Override
						public Long apply(@Nullable AttributeKey input) {

							return input.getId();
						}
					}), countStep);

			Long parentId = currentCategory.getParentId();

			backCategoriesDao.delete(id, parentId);
			response.setResult(Boolean.TRUE);

		} catch (Exception e) {
			log.error("category.delete.error id={};cause by{}", id, Throwables.getStackTraceAsString(e));
			response.setError("delete.error");

		}
		return response;
	}

	@Override
	public Response<List<BackCategory>> findByIds(List<Long> list) {
		Response<List<BackCategory>> response = new Response<List<BackCategory>>();
		Function<Long, String> function = new Function<Long, String>() {
			@Nullable
			@Override
			public String apply(@Nullable Long input) {
				return String.valueOf(input);
			}
		};
		Collection<String> transform = Collections2.transform(list, function);
		try {
			List<BackCategory> byIds = backCategoriesDao.findByIds(transform);
			response.setResult(byIds);
		} catch (Exception e) {
			log.error("failed to find backCategory", list, Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}

		return response;
	}

	/**
	 * 删除后台类目下的某一个属性 维护属性表版本
	 *
	 * @param categoryId
	 * @param attributeId
	 * @param type
	 * @return
	 */
	@Override
	public Response<Boolean> deleteAttribute(Long categoryId, Long attributeId, Integer type) {
		Response<Boolean> response = new Response<>();
		BackCategory backCategory = backCategoriesDao.findById(categoryId);
		AttributeKey attributeKey = attributeKeyDao.findAttributeKeyById(attributeId);
		AttributeDto attributeDto = jsonMapper.fromJson(backCategory.getAttribute(), AttributeDto.class);
		// 1 产品属性
		if (attributeType.equals(type)) {
			List<AttributeKey> attributeKeys = attributeDto.getAttribute();
			attributeKeys.remove(attributeKey);

		}
		// 2 销售属性
		if (skuType.equals(type)) {
			List<AttributeKey> sku = attributeDto.getSku();
			sku.remove(attributeKey);
		}
		final String stringAttribute = jsonMapper.toJson(attributeDto);
		try {
			backCategoriesDao.changeAttribute(categoryId, stringAttribute);
			attributeKeyDao.incrAttributeCount(attributeId, countStep);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to delete category attribute", Throwables.getStackTraceAsString(e));
			response.setError("change.category.attribute.error");

		}

		return response;
	}

	/**
	 * 此版本的删除只是删除后台类目绑定的属性值，没有维护属性的count 减1 所以这种删除只适用于修改
	 * 
	 * @param categoryId
	 * @param attributeId
	 * @param type
	 * @return
	 */
	private Response<AttributeDto> deleteAttributeNotDecr(Long categoryId, Long attributeId, Integer type) {
		Response<AttributeDto> response = new Response<>();
		BackCategory backCategory = backCategoriesDao.findById(categoryId);
		AttributeKey attributeKey = attributeKeyDao.findAttributeKeyById(attributeId);
		AttributeDto attributeDto = jsonMapper.fromJson(backCategory.getAttribute(), AttributeDto.class);
		// 1 产品属性
		if (type.equals(attributeType)) {
			List<AttributeKey> attributeKeys = attributeDto.getAttribute();
			attributeKeys.remove(attributeKey);

		}
		// 2 销售属性
		if (type.equals(skuType)) {
			List<AttributeKey> sku = attributeDto.getSku();
			sku.remove(attributeKey);
		}
		final String stringAttribute = jsonMapper.toJson(attributeDto);
		try {
			backCategoriesDao.changeAttribute(categoryId, stringAttribute);
			response.setResult(attributeDto);
		} catch (Exception e) {
			log.error("failed to delete category attribute", Throwables.getStackTraceAsString(e));
			response.setError("change.category.attribute.error");
		}
		return response;
	}

	/**
	 * 编辑操作 删除旧 新建新
	 *
	 * @param categoryId
	 * @param attributeId
	 * @param oldType
	 * @param newType
	 * @return
	 */
	@Override
	public Response<Boolean> editAttribute(Long categoryId, Long attributeId, Integer oldType, Integer newType) {

		Response<Boolean> response = new Response<>();
		if (oldType.equals(newType)) {
			response.setResult(Boolean.TRUE);
			return response;
		}

		// 如果要从产品属性改成销售属性 需要判断当前的销售属性 包括继承的 长度是否已经达到八个 达到八个不允许修改
		if (newType == 2) {
			Integer spuCount = 0;
			// 拿到当前节点属性 判断非重
			BackCategory currentCategory = backCategoriesDao.findById(categoryId);
			AttributeDto currentAttribute = jsonMapper.fromJson(currentCategory.getAttribute(), AttributeDto.class);

			if (currentAttribute != null && currentAttribute.getSku() != null) {
				spuCount += currentAttribute.getSku().size();
			}

			// 拿到父节点属性 判断非重
			AttributeDto parentsAttribute = backCategoriesDao.findParentsAttribute(currentCategory.getParentId());
			if (parentsAttribute != null && parentsAttribute.getSku() != null) {
				spuCount += parentsAttribute.getSku().size();
			}
			if (spuCount >= 8) {
				log.error("backcategory attribute add error");
				response.setError("back.spu.length.out");
				return response;
			}

		}

		// 拿到当前属性
		AttributeKey attributeKeyById = attributeKeyDao.findAttributeKeyById(attributeId);

		// 拿到当前后台类目
		BackCategory backCategory = backCategoriesDao.findById(categoryId);

		String attribute = backCategory.getAttribute();
		AttributeDto attributeDto = jsonMapper.fromJson(attribute, AttributeDto.class);
		// 加入编辑此节点的时候 检查当前属性是否还存在，是否被另一个线程删除
		Boolean notExistFlag = true;
		if (oldType.equals(attributeType)) {
			if (attributeDto == null || attributeDto.getAttribute() == null
					|| attributeDto.getAttribute().size() == 0) {
				response.setError("backcategory.attribute.not.exist");
				return response;
			}
			for (AttributeKey attributeKey : attributeDto.getAttribute()) {

				if (attributeKey.getId().equals(attributeId)) {
					notExistFlag = false;
				}

			}

		}
		if (oldType.equals(skuType)) {
			if (attributeDto == null || attributeDto.getSku() == null || attributeDto.getSku().size() == 0) {
				response.setError("backcategory.attribute.not.exist");
				return response;
			}
			for (AttributeKey attributeKey : attributeDto.getSku()) {

				if (attributeKey.getId().equals(attributeId)) {
					notExistFlag = false;
					break;// 如果确认出已经存在了 就说明没有被另一个人删除 跳出循环
				}

			}
		}
		// 如果从数据库中取出来的东西 不包含页面传过来要编辑的这个属性 说明这个属性已经被另一个人删除了 报错不让编辑
		if (notExistFlag) {
			response.setError("backcategory.attribute.not.exist");
			return response;
		}
		// 新旧type不一样
		// 删除旧type 返回处理完的属性集合 也就是数据库当前的集合 此步骤不会报错
		Response<AttributeDto> attributeDtoResponse = deleteAttributeNotDecr(categoryId, attributeId, oldType);
		// 旧type已经删除完毕了 放入新type的时候就不能使用上面那个attributeDto 因为它在数据库中已经被改变了
		if (!attributeDtoResponse.isSuccess()) {
			response.setError("change.category.attribute.error");
			return response;

		}
		AttributeDto result = attributeDtoResponse.getResult();
		// 1 产品属性
		if (newType.equals(attributeType)) {
			List<AttributeKey> attributeKeys = result.getAttribute();
			if (attributeKeys == null) {
				attributeKeys = Lists.newArrayList();
				result.setAttribute(attributeKeys);
			}
			attributeKeys.add(attributeKeyById);
		}
		// 2 销售属性
		if (newType.equals(skuType)) {
			List<AttributeKey> sku = result.getSku();
			if (sku == null) {
				sku = Lists.newArrayList();
				result.setSku(sku);
			}
			sku.add(attributeKeyById);
		}

		String attributeResult = jsonMapper.toJson(result);
		try {
			// 改变属性的类型 由于上边删除属性的时候 已经减小了属性的count 所以此处的新增
			backCategoriesDao.changeAttribute(categoryId, attributeResult);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to change category attribute cause by{}", Throwables.getStackTraceAsString(e));
			response.setError("change.category.attribute.error");
		}
		return response;

	}

	/**
	 * 判断是否是父节点
	 *
	 * @param categoryId
	 * @return
	 */
	@Override
	public Response<Boolean> isParent(Long categoryId) {
		Response<Boolean> response = new Response<>();
		try {
			Boolean parent = backCategoriesDao.isParent(categoryId);
			response.setResult(parent);
		} catch (Exception e) {
			log.error("failed to find backCategory", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	@Override
	public Response<AttributeDto> getAttributeById(Long id) {
		Response<AttributeDto> response = new Response<>();
		try {
			BackCategory backCategory = backCategoriesDao.findById(id);

			AttributeDto attributeDto = jsonMapper.fromJson(backCategory.getAttribute(), AttributeDto.class);
			response.setResult(attributeDto);
		} catch (Exception e) {
			log.error("failed to find backCategory", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	public Response<List<BackCategory>> allSimpleData() {
		Response<List<BackCategory>> response = new Response<>();
		try {
			List<BackCategory> backCategories = backCategoriesDao.allSimpleData();
			response.setResult(backCategories);
		} catch (Exception e) {
			log.error("failed to find backCategory", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	@Override
	public Response<Boolean> changeCount(Long backcategoryId, Long step) {
		Response<Boolean> response = new Response<>();
		try {
			backCategoriesDao.changeCount(backcategoryId, step);
			response.setResult(Boolean.TRUE);
		} catch (Exception e) {
			log.error("failed to change backcategory id={};cause by{}", backcategoryId,
					Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}

		return response;
	}

}
