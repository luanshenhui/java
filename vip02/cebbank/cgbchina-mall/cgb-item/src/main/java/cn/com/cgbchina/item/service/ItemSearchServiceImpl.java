package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dto.*;
import cn.com.cgbchina.item.model.AttributeKey;
import cn.com.cgbchina.item.model.AttributeValue;
import cn.com.cgbchina.item.model.FrontCategory;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Function;
import com.google.common.collect.Collections2;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import com.spirit.search.ESClient;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections.IteratorUtils;
import org.apache.commons.lang3.StringUtils;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.SearchHitField;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.bucket.terms.Terms.Bucket;
import org.elasticsearch.search.sort.SortOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Nullable;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by 133625 on 16-5-5.
 */
@Service
@Slf4j
public class ItemSearchServiceImpl implements ItemSearchService {

	@Autowired
	private ESClient esClient;

	@Autowired
	private CategoryMappingService categoryMappingService;
	@Autowired
	private FrontCategoriesService frontCategoriesService;
	@Autowired
	private AttributeKeyService attributeKeyService;
	@Autowired
	private AttributeValueService attributeValueService;
	@Autowired
	private BrandService brandService;

	private static final String INDEX_NAME = "items";
	private static final String INDEX_TYPE = "item";
	private static final String INNER_TYPE = "1";
	private int pageSize = 20;
	private int startPage = 1;
	private String category1Id;
	private String category2Id;
	private String category3Id;

	@Override
	public Response<itemSearchDto>  searchItem(@Param("businessType") String businessType,
			@Param("channelType") String channelType, @Param("keywords") String keywords,
			@Param("sortField") String sortField, @Param("sortDir") String sortDir,
			@Param("startPage") Integer startPage, @Param("pageSize") Integer pageSize,
			@Param("filterParams") String filterParams) {

		log.debug("ElasticsearchSearch：service：searchItem");
		log.debug("ElasticsearchSearch：service：param: keywords：{}",filterParams);
		log.debug("ElasticsearchSearch：service：param: keywords：{}", keywords);

		Response<itemSearchDto> response = new Response<itemSearchDto>();
		ObjectMapper mapper = new ObjectMapper();
		try {
			Map filterMap = StringUtils.isNotBlank(filterParams) ? mapper.readValue(filterParams, Map.class) : null;
			if (startPage != null) {
				this.startPage = Integer.valueOf(startPage);
			}
			if (pageSize != null) {
				this.pageSize = Integer.valueOf(pageSize);
			}
			int from = (this.startPage - 1) * this.pageSize;
			SearchRequestBuilder searchRequestBuilder = null;
			// 搜索
			searchRequestBuilder = esClient.searchRequestBuilder(INDEX_NAME).setTypes(INDEX_TYPE)
					.setSearchType(SearchType.DFS_QUERY_THEN_FETCH)
					.addFields("itemCode", "name", "price", "itemAttribute", "image1").setExplain(false);
			// 过滤条件
			AndFilterBuilder andFilterBuilder = FilterBuilders.andFilter();
			if (filterMap != null && !filterMap.isEmpty()) {
				setFilters(filterMap, andFilterBuilder);
			}
			// 业务类型过滤
			if (StringUtils.isNotBlank(businessType)) {
				andFilterBuilder = andFilterBuilder
						.add(FilterBuilders.termFilter("ordertypeId", businessType.toLowerCase()));
			}
			// 渠道类型过滤
			if (StringUtils.isNotBlank(channelType)) {
				andFilterBuilder.add(FilterBuilders.termFilter(channelType, "02")); // "02"上架状态
			}
			//内宣商品过滤-内宣商品不检索
			andFilterBuilder.add(FilterBuilders.termFilter("isInner",INNER_TYPE));
			QueryBuilder queryBuilder = null;
			if (andFilterBuilder != null) {
				// 关键字
				if (StringUtils.isNotBlank(keywords)) {
					queryBuilder = QueryBuilders
							.filteredQuery(QueryBuilders.matchQuery("name", keywords), andFilterBuilder);
				} else {
					queryBuilder = QueryBuilders.filteredQuery(QueryBuilders.matchAllQuery(), andFilterBuilder);
				}
			} else {
				// 关键字
				if (StringUtils.isNotBlank(keywords)) {
					queryBuilder = QueryBuilders.matchQuery("name", keywords);
				} else {
					queryBuilder = QueryBuilders.matchAllQuery();
				}
			}
			searchRequestBuilder.setQuery(queryBuilder);

			// 设置返回条数
			searchRequestBuilder.setFrom(from).setSize(this.pageSize);
			// 排序
			if (StringUtils.isNotBlank(sortField)) {
				searchRequestBuilder.addSort(sortField, sortDir.equals("1") ? SortOrder.DESC : SortOrder.ASC);
			}

			// 聚合
			searchRequestBuilder.addAggregation(
					AggregationBuilders.terms("backCategory3Id").field("backCategory3Id").size(Integer.MAX_VALUE));// 类目<br>
			searchRequestBuilder.addAggregation(
					AggregationBuilders.terms("goodsBrandId").field("goodsBrandId").size(Integer.MAX_VALUE));// 品牌<br>
			searchRequestBuilder
					.addAggregation(AggregationBuilders.terms("attrId").field("attrId").size(Integer.MAX_VALUE));// 销售属性<br>

			// 搜索
			SearchResponse searchResponse = searchRequestBuilder.execute().actionGet();

			// 构建结果集
			List<ItemSearchResultDto> itemSearchResultList = Lists.newArrayList();
			for (SearchHit searchHit : searchResponse.getHits()) {

				Map<String, SearchHitField> map = searchHit.getFields();
				ItemSearchResultDto itemSearchResultDto = new ItemSearchResultDto();
				if (map.get("itemCode") != null) {
					itemSearchResultDto.setItemCode(String.valueOf(map.get("itemCode").getValue()));
				}
				if (map.get("name") != null) {
					itemSearchResultDto.setGoodsName(String.valueOf(map.get("name").getValue()));
				}

				if (map.get("image1") != null) {
					itemSearchResultDto.setImage1(String.valueOf(map.get("image1").getValue()));
				}

				// 解析销售属性
				SearchHitField saleAttr = map.get("itemAttribute");
				if (saleAttr != null && saleAttr.getValues() != null) {
					ItemsAttributeDto itemsAttributeDto = JsonMapper.JSON_NON_DEFAULT_MAPPER
							.fromJson(saleAttr.getValue().toString(), ItemsAttributeDto.class);
					if (itemsAttributeDto != null) {
						List<ItemAttributeDto> itemAttributeDtoList = Lists.newArrayList();
						for (ItemsAttributeSkuDto itemsAttributeSkuDto : itemsAttributeDto.getSkus()) {
							ItemAttributeDto itemAttributeDto = new ItemAttributeDto();
							itemAttributeDto.setAttributeKey(itemsAttributeSkuDto.getAttributeValueKey());
							itemAttributeDto.setAttributeName(itemsAttributeSkuDto.getAttributeValueName());
							itemAttributeDto.setAttributeValueKey(
									itemsAttributeSkuDto.getValues().get(0).getAttributeValueKey());
							itemAttributeDto.setAttributeValueName(
									itemsAttributeSkuDto.getValues().get(0).getAttributeValueName());
							itemAttributeDtoList.add(itemAttributeDto);
						}
						itemSearchResultDto.setItemAttributeDtoList(itemAttributeDtoList);
					}
				}
				java.text.DecimalFormat df = new java.text.DecimalFormat("#.00");
				BigDecimal price = new BigDecimal(map.get("price").getValue().toString());
				itemSearchResultDto.setPrice(df.format(price));
				itemSearchResultList.add(itemSearchResultDto);
			}
			itemSearchDto searchResult = new itemSearchDto();
			searchResult.setItemSearchResultList(itemSearchResultList);
			searchResult.setTotalRecord((int) searchResponse.getHits().getTotalHits());
			searchResult.setPageSize(this.pageSize);
			searchResult.setPageCount(searchResult.getTotalRecord() % searchResult.getPageSize() == 0
					? searchResult.getTotalRecord() / searchResult.getPageSize()
					: searchResult.getTotalRecord() / searchResult.getPageSize() + 1);// 总页数
			Terms terms = searchResponse.getAggregations().<Terms> get("backCategory3Id");
			if (StringUtils.isNotBlank(category2Id)) {
				// 三级类目聚合
				searchResult.setCategoryList(getFrontCategoryList(terms, "category3Id", 3));
			} else if (StringUtils.isNotBlank(category1Id)) {
				// 二级类目聚合
				searchResult.setCategoryList(getFrontCategoryList(terms, "category2Id", 2));
			} else {
				// 一级类目聚合
				searchResult.setCategoryList(getFrontCategoryList(terms, "category1Id", 1));

			}
			// 品牌聚合
			searchResult
					.setBrandList(term2Kvs(searchResponse.getAggregations().<Terms> get("goodsBrandId"), "brandId"));
			// 销售属性聚合
			searchResult.setSaleAttrList(term2Kvs(searchResponse.getAggregations().<Terms> get("attrId"), "saleAttr"));
			response.setResult(searchResult);

			return response;
		} catch (IOException e) {
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * 过滤条件设置
	 * 
	 * @param filterParams
	 * @return
	 */
	private void setFilters(Map<String, Object> filterParams, AndFilterBuilder andFilterBuilder) {
		Set<String> filterKeySet = filterParams.keySet();
		for (String filterKey : filterKeySet) {
			if (filterKey.equals("priceRange")) {
				// 价格区间过滤
				String filterValue = (String) filterParams.get(filterKey);
				String lowPriceStr = null;
				String heightPriceStr = null;
				if (StringUtils.isNotBlank((String) filterValue)) {
					if (filterValue.contains("-")) {
						String priceArray[] = filterValue.split("-");
						lowPriceStr = priceArray[0];
						heightPriceStr = priceArray[1];
					}
					FilterBuilder rangeFilter = null;
					double lowPrice = 0;
					double heightPrice = 0;
					if (StringUtils.isNotBlank(lowPriceStr) && StringUtils.isNotBlank(heightPriceStr)) {
						lowPrice = Double.parseDouble(lowPriceStr);
						heightPrice = Double.parseDouble(heightPriceStr);
						if (lowPrice > heightPrice) {
							double t = lowPrice;
							lowPrice = heightPrice;
							heightPrice = t;
						}
						rangeFilter = FilterBuilders.rangeFilter("price").from(lowPrice).to(heightPrice)
								.includeLower(true).includeUpper(true);
					} else if (StringUtils.isNotBlank(lowPriceStr)) {
						lowPrice = Double.parseDouble(lowPriceStr);
						rangeFilter = FilterBuilders.rangeFilter("price").from(lowPrice).includeLower(true);
					} else if (StringUtils.isNotBlank(heightPriceStr)) {
						heightPrice = Double.parseDouble(heightPriceStr);
						rangeFilter = FilterBuilders.rangeFilter("price").to(heightPrice).includeUpper(true);
					}
					if (rangeFilter != null) {
						andFilterBuilder = addFilterBuilder(andFilterBuilder, rangeFilter);
					}
				}
			} else if (filterKey.equals("category3Id")) {
				category3Id = (String) filterParams.get(filterKey);
			} else if (filterKey.equals("category2Id")) {
				category2Id = (String) filterParams.get(filterKey);
			} else if (filterKey.equals("category1Id")) {
				category1Id = (String) filterParams.get(filterKey);
			} else {
				// 其他条件过滤
				List<String> filterValues = (List<String>) filterParams.get(filterKey);
				// 品牌 ，or
				if (filterValues != null) {
					OrFilterBuilder orFB = null;
					for (int i = 0; i < filterValues.size(); i++) {
						if ("brandId".equals(filterKey)) {
							if (filterValues.size() > 1) {
								if (orFB == null) {
									orFB = FilterBuilders.orFilter();
								}
								orFB.add(FilterBuilders.termFilter("goodsBrandId", filterValues.get(i)));
								if (i == filterValues.size() - 1) {
									andFilterBuilder.add(orFB);
								}
							} else {
								andFilterBuilder.add(FilterBuilders.termFilter("goodsBrandId", filterValues.get(i)));
							}
						} else {
							if (filterValues.size() > 1) {
								if (orFB == null) {
									orFB = FilterBuilders.orFilter();
								}
								orFB.add(FilterBuilders.termFilter("saleAttrList.attrId",
										filterKey.concat("attr").concat(filterValues.get(i))));
								if (i == filterValues.size() - 1) {
									andFilterBuilder.add(orFB);
								}
							} else {
								andFilterBuilder.add(FilterBuilders.termFilter("saleAttrList.attrId",
										filterKey.concat("attr").concat(filterValues.get(i))));
							}
						}
					}
				}
			}
		}

		// 类目过滤--需将前台类目转为后台类目
		List<Long> backCategoryIds = null;
		List<CategoryMappingDto> categoryMappingDtoList = null;
		if (StringUtils.isNotBlank(category3Id)) {
			// 根据前台3级类目查找后台三级类目
			categoryMappingDtoList = getBackCategoryIds(category3Id, 3);
		} else if (StringUtils.isNotBlank(category2Id)) {
			// 根据前台2级类目查找后台三级类目
			categoryMappingDtoList = getBackCategoryIds(category2Id, 2);
		} else if (StringUtils.isNotBlank(category1Id)) {
			// 根据前台1级类目查找后台三级类目
			categoryMappingDtoList = getBackCategoryIds(category1Id, 1);
		}
		if (categoryMappingDtoList != null) {
			Collection<Long> collection = Collections2.transform(categoryMappingDtoList,
					new Function<CategoryMappingDto, Long>() {
						@Nullable
						@Override
						public Long apply(@Nullable CategoryMappingDto categoryMappingDto) {
							return categoryMappingDto.getBackCategoryId();
						}
					});
			if (collection != null) {
				backCategoryIds = IteratorUtils.toList(collection.iterator());
			}
		}
		if (backCategoryIds != null) {
			OrFilterBuilder orFB = null;
			for (int i = 0; i < backCategoryIds.size(); i++) {
				if (backCategoryIds.size() > 1) {
					if (orFB == null) {
						orFB = FilterBuilders.orFilter();
					}
					orFB.add(FilterBuilders.termFilter("backCategory3Id", backCategoryIds.get(i)));
					if (i == backCategoryIds.size() - 1) {
						andFilterBuilder.add(orFB);
					}
				} else {
					andFilterBuilder.add(FilterBuilders.termFilter("backCategory3Id", backCategoryIds.get(i)));
				}
			}
		}
	}

	/**
	 * 查找前台类目对应的后台类目
	 * 
	 * @param categoryId
	 * @param level
	 * @return
	 */
	private List<CategoryMappingDto> getBackCategoryIds(String categoryId, int level) {
		List<CategoryMappingDto> categoryMappingDtoList = categoryMappingService.getMappingByFrontId(categoryId)
				.getResult();
		// 如果前台'level'级类目无对应的后台三级类目，则需要通过前台'level'级类目的叶节点（前台三级类目）查找后台三级类目
		if (level + 1 <= 3) {
			List<FrontCategory> frontCategoryList = frontCategoriesService.findChildById(Long.valueOf(categoryId))
					.getResult();
			for (FrontCategory frontCategory : frontCategoryList) {
				categoryMappingDtoList.addAll(getBackCategoryIds(frontCategory.getId().toString(), level + 1));
			}
		}
		return categoryMappingDtoList;
	}

	/**
	 * 整合And Filter Builer
	 *
	 * @param andFilterBuilder
	 * @param filterBuilder
	 */
	private AndFilterBuilder addFilterBuilder(AndFilterBuilder andFilterBuilder, FilterBuilder filterBuilder) {
		if (andFilterBuilder == null) {
			andFilterBuilder = FilterBuilders.andFilter(filterBuilder);
		} else {
			andFilterBuilder = andFilterBuilder.add(filterBuilder);
		}
		return andFilterBuilder;
	}

	/**
	 *
	 * Description : 解析聚合结果集
	 *
	 * @param terms
	 * @return
	 */
	private List<ItemFilterDto> term2Kvs(Terms terms, String typeName) {
		List<ItemFilterDto> facets = Lists.newArrayList();
		if ("brandId".equals(typeName)) {
			Collection<Long> brands = Collections2.transform(terms.getBuckets(), new Function<Bucket, Long>() {
				@Nullable
				@Override
				public Long apply(@Nullable Bucket bucket) {
					return Long.valueOf(bucket.getKey());
				}
			});
			if (!brands.isEmpty()) {
				List<Long> list = IteratorUtils.toList(brands.iterator());
				Response<List<GoodsBrandModel>> res = brandService.findByIds(list);
				if (!res.isSuccess()) {
					log.error("failed query goodsbrand ,cause:{}");
					return null;
				}
				List<GoodsBrandModel> goodsBrandModels = res.getResult();
				Collection<ItemFilterDto> itemFilterDtoList = Collections2.transform(goodsBrandModels,
						new Function<GoodsBrandModel, ItemFilterDto>() {
							@Nullable
							@Override
							public ItemFilterDto apply(@Nullable GoodsBrandModel goodsBrandModel) {
								ItemFilterDto itemFilterDto = new ItemFilterDto();
								itemFilterDto.setId(goodsBrandModel.getId().toString());
								itemFilterDto.setName(goodsBrandModel.getBrandName());
								itemFilterDto.setSpell(goodsBrandModel.getInitial());
								return itemFilterDto;
							}
						});
				facets = IteratorUtils.toList(itemFilterDtoList.iterator());
			}
		} else if ("saleAttr".equals(typeName)) {
			Map<String, List<ItemFilterDto>> groupSaleAttr = Maps.newHashMap();
			for (Bucket bucket : terms.getBuckets()) {
				String[] attrIds = bucket.getKey().split("attr");
				List<ItemFilterDto> attrValues = groupSaleAttr.get(attrIds[0]);
				if (attrValues == null) {
					attrValues = Lists.newArrayList();
					groupSaleAttr.put(attrIds[0], attrValues);
				}
				AttributeValue attributeValue = attributeValueService.findById(Long.valueOf(attrIds[1])).getResult();
				if (attributeValue != null) {
					ItemFilterDto kvDto = new ItemFilterDto();
					kvDto.setCount(bucket.getDocCount());
					kvDto.setId(attrIds[1]);
					kvDto.setName(attributeValue.getValue());
					attrValues.add(kvDto);
				}
			}
			for (String attrId : groupSaleAttr.keySet()) {
				AttributeKey attributeKey = attributeKeyService.findAttributeKeyById(Long.valueOf(attrId)).getResult();
				if (attributeKey != null) {
					ItemFilterDto facet = new ItemFilterDto();
					facet.setId(attrId);
					facet.setName(attributeKey.getName());
					facet.setItemFilterDtoList(groupSaleAttr.get(attrId));
					facets.add(facet);
				}
			}
		}

		return facets;
	}

	private List<ItemFilterDto> getFrontCategoryList(Terms terms, String typeName, int level) {
		List<ItemFilterDto> facets = Lists.newArrayList();
		Map<String, ItemFilterDto> facetMap = Maps.newHashMap();
		Map<Long, Bucket> bucketMap = Maps.newHashMap();
		for (Bucket bucket : terms.getBuckets()) {
			bucketMap.put(Long.valueOf(bucket.getKey()), bucket);
		}
		if (bucketMap.isEmpty()) {
			return facets;
		}
		Collection<CategoryMappingDto> filter = categoryMappingService.findByBackIds(bucketMap.keySet()).getResult();
		// 找出了参数中的所有后台类目对应的mapping对象
		// 从mapping对象中取出所有前台类目id
		Map<String, List<Long>> categoryMap = Maps.newHashMap();
		for (CategoryMappingDto categoryMappingDto : filter) {
			String frontCategoryId = categoryMappingDto.getFrontCategoryId().toString();
			List<Long> backCategoryIds = categoryMap.get(frontCategoryId);
			if (backCategoryIds == null) {
				backCategoryIds = Lists.newArrayList();
				categoryMap.put(frontCategoryId, backCategoryIds);
			}
			backCategoryIds.add(categoryMappingDto.getBackCategoryId());
		}
		// 通过所有前台类目id查到前台类目id的对象
		List<FrontCategoryMappingDto> frontCategoryMappingDtos = categoryMappingService
				.frontByFrontIds(categoryMap.keySet()).getResult();

		for (FrontCategoryMappingDto frontCategoryMappingDto : frontCategoryMappingDtos) {
			String frontCategoryId = null;
			int frontCategoryLevel = frontCategoryMappingDto.getLevel();
			String frontCategoryName = null;
			// 寻找前端显示的类目集
			if (level == frontCategoryLevel) {
				frontCategoryId = frontCategoryMappingDto.getId().toString();
				frontCategoryName = frontCategoryMappingDto.getName();
			} else {
				List<String> frontCategoryIds = Lists.newArrayList();
				frontCategoryIds.add(frontCategoryMappingDto.getParentId().toString());
				while (level < frontCategoryLevel) {
					FrontCategoryMappingDto parentFrontCategoryMappingDto = categoryMappingService
							.frontByFrontIds(frontCategoryIds).getResult().get(0);
					frontCategoryLevel = parentFrontCategoryMappingDto.getLevel();
					if (level == frontCategoryLevel) {
						frontCategoryId = parentFrontCategoryMappingDto.getId().toString();
						frontCategoryName = parentFrontCategoryMappingDto.getName();
					} else {
						frontCategoryIds.remove(0);
						frontCategoryIds.add(parentFrontCategoryMappingDto.getParentId().toString());
					}
				}

			}
			if (StringUtils.isNotBlank(frontCategoryId)) {
				ItemFilterDto facet = facetMap.get(frontCategoryId);
				if (facet == null) {
					facet = new ItemFilterDto();
					facet.setId(frontCategoryId);
					facet.setName(frontCategoryName);
					facet.setCount(0l);
					facetMap.put(frontCategoryId, facet);
				}
				List<Long> backCategoryIds = categoryMap.get(frontCategoryMappingDto.getId().toString());
				Long docCount = facet.getCount();
				for (Long backCategoryId : backCategoryIds) {
					docCount = docCount + bucketMap.get(backCategoryId).getDocCount();
				}
				facet.setCount(docCount);
			}
		}
		for (String key : facetMap.keySet()) {
			facets.add(facetMap.get(key));
		}
		return facets;
	}

}
