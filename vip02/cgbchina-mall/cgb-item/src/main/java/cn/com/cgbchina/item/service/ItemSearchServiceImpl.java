package cn.com.cgbchina.item.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.dao.GoodsPointRegionDao;
import cn.com.cgbchina.item.dao.GoodsPriceRegionDao;
import cn.com.cgbchina.item.dto.BrandPair;
import cn.com.cgbchina.item.dto.ItemRichDto;
import cn.com.cgbchina.item.dto.ItemSearchFactDto;
import cn.com.cgbchina.item.model.GoodsBrandModel;
import cn.com.cgbchina.item.model.GoodsPointRegionModel;
import cn.com.cgbchina.item.model.GoodsPriceRegionModel;
import cn.com.cgbchina.item.service.search.SearchHelper;
import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.base.MoreObjects;
import com.google.common.base.Predicate;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.*;
import com.spirit.category.model.AttributeKey;
import com.spirit.category.model.AttributeValue;
import com.spirit.category.model.BackCategory;
import com.spirit.category.model.CategoryMapping;
import com.spirit.category.model.CategoryNode;
import com.spirit.category.model.FrontCategory;
import com.spirit.category.service.BackCategoryHierarchy;
import com.spirit.category.service.Forest;
import com.spirit.category.service.FrontCategoryHierarchy;
import com.spirit.category.service.FrontCategoryService;
import com.spirit.common.model.Response;
import com.spirit.search.ESClient;
import com.spirit.search.Pair;
import com.spirit.search.RawSearchResult;
import com.spirit.search.SearchFacet;
import lombok.extern.slf4j.Slf4j;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.search.facet.FacetBuilder;
import org.elasticsearch.search.facet.FacetBuilders;
import org.elasticsearch.search.facet.Facets;
import org.elasticsearch.search.facet.terms.TermsFacet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import static com.google.common.base.Objects.equal;

/**
 * Created by 133625 on 16-5-5.
 */
@Service
@Slf4j
public class ItemSearchServiceImpl implements ItemSearchService {

    private final static Splitter splitter = Splitter.on('_').trimResults().omitEmptyStrings();
    public static final ImmutableList<Pair> rootCategory = ImmutableList.of(new Pair("所有分类", 0L));
    @Autowired
    private ESClient esClient;

    @Autowired
    private FrontCategoryService frontCategoriesService;
    @Autowired
    FrontCategoryHierarchy fch;
    @Autowired
    BackCategoryHierarchy bch;
    @Autowired
    private BrandService brandService;
    private final GoodsPriceRegionDao goodsPriceRegionDao;
    private final GoodsPointRegionDao goodsPointRegionDao;
    @Autowired
    private Forest forest;

    private static final String INDEX_NAME = "items";
    private static final String INDEX_TYPE = "item";
    public static final String CAT_FACETS = "cat_facets";
    public static final String ATTR_FACETS = "attr_facets";
    public static final String BRAND_FACETS = "brand_facets";
    private final static Joiner joiner = Joiner.on('_').skipNulls();
    private static final String MAX_PRICE = "以上";

    public static final int BRAND_LIMITS = 10;

    private final List<GoodsPriceRegionModel> goodsPrices;
    private final List<GoodsPointRegionModel> goodsPoints;

    @Autowired
    public ItemSearchServiceImpl(final GoodsPriceRegionDao goodsPriceRegionDao, final GoodsPointRegionDao goodsPointRegionDao) {
        this.goodsPriceRegionDao = goodsPriceRegionDao;
        this.goodsPointRegionDao = goodsPointRegionDao;
        this.goodsPrices = goodsPriceRegionDao.findGoodsPriceRegionList();
        this.goodsPoints = goodsPointRegionDao.findGoodsPointRegionList();
    }

    /**
     * 查询商品价格区间数据
     *
     * @return 结果
     */
    @Override
    public Response<List<GoodsPriceRegionModel>> findGoodsPriceRegion() {
        Response<List<GoodsPriceRegionModel>> response = new Response<List<GoodsPriceRegionModel>>();
        try {
            List<GoodsPriceRegionModel> goodsPriceRegionList = goodsPriceRegionDao.findGoodsPriceRegionList();
            response.setResult(goodsPriceRegionList);
        } catch (Exception e) {
            log.error("find goods price region error{}", Throwables.getStackTraceAsString(e));
            response.setError("findGoodsPriceRegion.error");
        }
        return response;
    }

    /**
     * 查询商品积分区间数据
     *
     * @return 结果
     */
    @Override
    public Response<List<GoodsPointRegionModel>> findGoodsPointRegion() {
        Response<List<GoodsPointRegionModel>> response = new Response<List<GoodsPointRegionModel>>();
        try {
            List<GoodsPointRegionModel> goodsPointRegionList = goodsPointRegionDao.findGoodsPointRegionList();
            response.setResult(goodsPointRegionList);
        } catch (Exception e) {
            log.error("find goods point region error{}", Throwables.getStackTraceAsString(e));
            response.setError("findGoodsPointRegion.error");
        }
        return response;
    }

    /**
     * @param pageNo 分页数
     * @param size   每页显示条数
     * @param params 搜索条件
     * @return
     */
    @Override
    public Response<ItemSearchFactDto> itemSearch(int pageNo, int size, Map<String, String> params) {
        Response<ItemSearchFactDto> result = Response.newResponse();

        pageNo = pageNo <= 0 ? 1 : pageNo;
        size = size <= 0 ? 20 : size;
        if (params == null) {
            params = Maps.newHashMap();
        }

        //前台类目
        final Long categoryId = !Strings.isNullOrEmpty(params.get("cid")) ? Long.valueOf(params.get("cid")) : null;
        // 品牌id
        final Long brandId = !Strings.isNullOrEmpty(params.get("bid")) ? Long.valueOf(params.get("bid")) : null;
        // 价格区间
        final Integer pid = !Strings.isNullOrEmpty(params.get("pid")) ? Integer.parseInt(params.get("pid")) : null;
        // 积分区间
        final Integer qid = !Strings.isNullOrEmpty(params.get("qid")) ? Integer.parseInt(params.get("qid")) : null;
        boolean pidPresent = pid != null;
        boolean qidPresent=qid!=null;
        boolean categoryIdPresent = categoryId != null && !equal(categoryId, 0L);
        boolean brandIdPresent = brandId != null;
        if (pidPresent) {
            GoodsPriceRegionModel goodsPriceRegionModel = filterPrice(pid);
            if (goodsPriceRegionModel != null) {
                params.put("p_i", String.valueOf(goodsPriceRegionModel.getMinPoint() != null ? goodsPriceRegionModel.getMinPoint() : 0));
                params.put("p_x", String.valueOf(goodsPriceRegionModel.getMaxPoint() != null ? goodsPriceRegionModel.getMaxPoint() : Double.MAX_VALUE));
            }
        }
        if(qidPresent){
            GoodsPointRegionModel goodsPointRegionModel = filterPoint(qid);
            if(goodsPointRegionModel!=null){
                params.put("q_f", String.valueOf(goodsPointRegionModel.getMinPoint() != null ? goodsPointRegionModel.getMinPoint() : 0));
                params.put("q_t", String.valueOf(goodsPointRegionModel.getMaxPoint() != null ? goodsPointRegionModel.getMaxPoint() : Double.MAX_VALUE));
            }

        }

        String pvids = params.get("pvids");//attribute value ids
        Set<Long> attributeIds = null;
        if (!Strings.isNullOrEmpty(pvids)) {
            List<String> parts = splitter.splitToList(pvids);
            attributeIds = Sets.newLinkedHashSetWithExpectedSize(parts.size());
            for (String part : parts) {
                attributeIds.add(Long.valueOf(part));
            }
        }

        Long frontCategoryId = !Strings.isNullOrEmpty(params.get("fcid")) ? Long.parseLong(params.get("fcid")) : null;
        if (frontCategoryId != null) {
            // 根据前台类目Id查找后台叶子Id
            Iterable<Long> backLeafIds = frontCategoryToBackLeafIds(frontCategoryId);
            params.put("categoryIds", joiner.join(backLeafIds));
        }

        String bids = params.get("bids"); //brand ids
        Set<Long> brandIds = null;
        if(!Strings.isNullOrEmpty(bids)){
            List<String> parts = splitter.splitToList(bids);
            brandIds  =Sets.newLinkedHashSetWithExpectedSize(parts.size());
            for (String part : parts) {
                brandIds.add(Long.valueOf(part));
            }
        }
        SearchRequestBuilder requestBuilder = esClient.searchRequestBuilder(INDEX_NAME);
        // 搜索条件
        QueryBuilder queryBuilder = SearchHelper.buildQuery(params);
        requestBuilder.setQuery(queryBuilder);
        // 排序条件
        SearchHelper.buildSortQuery(requestBuilder, params);
        requestBuilder.setFrom((pageNo - 1) * size).setSize(size);
        FacetBuilder catFacetBuilder = FacetBuilders.termsFacet(CAT_FACETS).field("categoryIds").size(50);
        FacetBuilder attrFacetBuilder = FacetBuilders.termsFacet(ATTR_FACETS).field("attributeIds").size(100);
        FacetBuilder brandFacetBuilder = FacetBuilders.termsFacet(BRAND_FACETS).field("goodsBrandId").size(50);

        requestBuilder.addFacet(catFacetBuilder).addFacet(attrFacetBuilder).addFacet(brandFacetBuilder);
        if (!Contants.SOURCE_ID_CELL.equals(params.get("c_t"))) {
            // 手机商城渠道不做高亮处理
            requestBuilder.addHighlightedField("name");
        }

        RawSearchResult<ItemRichDto> rawResult = esClient.facetSearchWithIndexType(INDEX_TYPE, ItemRichDto.class, requestBuilder);

        ItemSearchFactDto refinedResult = from(rawResult);
        //refine result price or point if  this channel is activing
        refineResultPriceAndPoint(params.get("c_t"), refinedResult);
        //refine category navigator if necessary
        refineCategoryNavigator(categoryId, categoryIdPresent, refinedResult);

        //refine bread crumbs
        refineBreadCrumbs(categoryId, categoryIdPresent, refinedResult);

        //refine brand
        refineBrandNavigator(brandId, brandIdPresent, refinedResult);

        //refine property navigator
        refineAttributeNavigator(attributeIds, refinedResult);

        if(brandIds!=null &&brandIds.size()!=0){
            refineBrandsNavigator(brandIds, refinedResult);
        }
        //价格区间与积分区间只能选中一个 不选的话全部显示
        if(pidPresent) {
            refinePrice(pid, pidPresent, refinedResult);
        }else if(qidPresent){
            refinePoint(qid,qidPresent,refinedResult);
        }else {
            refinePrice(pid, pidPresent, refinedResult);
            refinePoint(qid,qidPresent,refinedResult);
        }
        if (frontCategoryId != null) {
            Response<FrontCategory> frontCategoryR = frontCategoriesService.findById(frontCategoryId);
            if (!frontCategoryR.isSuccess() || frontCategoryR.getResult() == null) {
                log.error("fail to find frontCategory by fcid={}, error code:{}, skip",
                        frontCategoryId, frontCategoryR.getError());
            } else {
                refinedResult.setFcName(frontCategoryR.getResult().getName());
            }
        }
        result.setResult(refinedResult);

        return result;
    }


    private void refineResultPriceAndPoint(String channel,ItemSearchFactDto itemSearchFactDto){
        if(itemSearchFactDto.getResultDtos()!=null){
            for(ItemRichDto itemRichDto:itemSearchFactDto.getResultDtos()){
                switch (MoreObjects.firstNonNull(channel, Contants.CHANNEL_MALL_CODE)){
                    case Contants.CHANNEL_MALL_CODE: // 00:网上商城（包括广发，积分商城）
                       if(Integer.valueOf(0).equals(itemRichDto.getMallPromoType())){
                        itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                        itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                       }
                        break;
                    case Contants.CHANNEL_PHONE_CODE: // "03" 手机商城
                        if(Integer.valueOf(0).equals(itemRichDto.getPhonePromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    case Contants.CHANNEL_CC_CODE: // "01"呼叫中心
                        if(Integer.valueOf(0).equals(itemRichDto.getCcPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    case Contants.CHANNEL_SMS_CODE: // "04"短信渠道
                        if(Integer.valueOf(0).equals(itemRichDto.getSmsPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    case Contants.CHANNEL_APP_CODE: // "09"APP渠道
                        if(Integer.valueOf(0).equals(itemRichDto.getAppPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    case Contants.CHANNEL_MALL_WX_CODE: // "05"广发银行(微信)
                        if(Integer.valueOf(0).equals(itemRichDto.getMallWxPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    case Contants.CHANNEL_CREDIT_WX_CODE: // "06"广发信用卡(微信)
                        if(Integer.valueOf(0).equals(itemRichDto.getCreditWxPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    case Contants.CHANNEL_IVR_CODE: // "02"IVR渠道
                        if(Integer.valueOf(0).equals(itemRichDto.getIvrPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                    default:
                        if(Integer.valueOf(0).equals(itemRichDto.getMallPromoType())){
                            itemRichDto.setPrice(itemRichDto.getOriginalPrice());
                            itemRichDto.setPoints(itemRichDto.getOriginalPoints());
                        }
                        break;
                }
            }
        }
    }


    private GoodsPriceRegionModel filterPrice(Integer pid) {
        GoodsPriceRegionModel rtnPriceRegionModel = null;
        if (!this.goodsPrices.isEmpty()) {
            for (GoodsPriceRegionModel goodsPriceRegionModel : this.goodsPrices) {
                if (equal(pid, goodsPriceRegionModel.getRegionId())) {
                    rtnPriceRegionModel = goodsPriceRegionModel;
                }
            }
        }
        return rtnPriceRegionModel;
    }
    private GoodsPointRegionModel filterPoint(Integer qid) {
        GoodsPointRegionModel rtnPointRegionModel = null;
        if (!this.goodsPrices.isEmpty()) {
            for (GoodsPointRegionModel goodsPointRegionModel : this.goodsPoints) {
                if (equal(qid, goodsPointRegionModel.getRegionId())) {
                    rtnPointRegionModel = goodsPointRegionModel;
                }
            }
        }
        return rtnPointRegionModel;
    }


    private void refinePrice(final Integer pid, boolean pidPresent,ItemSearchFactDto refinedResult) {
        List<SearchFacet> prices = Lists.newArrayListWithCapacity(5);
        List<Pair> chosenPrices = Lists.newArrayListWithCapacity(5);
        if (!this.goodsPrices.isEmpty()) {
            for (GoodsPriceRegionModel priceRegionModel : this.goodsPrices) {
                Integer minPoint = priceRegionModel.getMinPoint();
                String maxPoint = "-";
                if (priceRegionModel.getMaxPoint() == null) {
                    maxPoint += MAX_PRICE;
                } else {
                    maxPoint += priceRegionModel.getMaxPoint();
                }
                if (pidPresent && equal(pid, priceRegionModel.getRegionId())) {
                    chosenPrices.add(new Pair(minPoint + maxPoint, Long.valueOf(priceRegionModel.getRegionId())));
                }

                prices.add(new SearchFacet(Long.valueOf(priceRegionModel.getRegionId()), Long.valueOf(this.goodsPrices.size()), minPoint + maxPoint));
            }
        }
        if (pidPresent) {
          refinedResult.setChosenPrices(chosenPrices);
        } else {
            refinedResult.setPrices(prices);
        }

    }
    private void refinePoint(final Integer qid,boolean qidPresent,ItemSearchFactDto refinedResult){
        List<SearchFacet> points = Lists.newArrayListWithCapacity(5);
        List<Pair> chosenPoints = Lists.newArrayListWithCapacity(5);
        if(!this.goodsPoints.isEmpty()){
            for(GoodsPointRegionModel pointRegionModel:this.goodsPoints){
                Long minPoint = pointRegionModel.getMinPoint();
                String maxPoint = "-";
                if(pointRegionModel.getMaxPoint()==null){
                    maxPoint+=MAX_PRICE;
                }else {
                    maxPoint+=pointRegionModel.getMaxPoint();
                }
                if(qidPresent && equal(qid,pointRegionModel.getRegionId())){
                    chosenPoints.add(new Pair(minPoint+maxPoint,Long.valueOf(pointRegionModel.getRegionId())));
                }
                points.add(new SearchFacet(Long.valueOf(pointRegionModel.getRegionId()),Long.valueOf(this.goodsPoints.size()),minPoint+maxPoint));
            }
        }
        if (qidPresent) {
            refinedResult.setChosenPoints(chosenPoints);
        } else {
            refinedResult.setPoints(points);
        }
    }



    //if a category has been selected as a query filter, then it should not appears in category navigator
    private void refineCategoryNavigator(final Long categoryId, boolean categoryIdPresent, ItemSearchFactDto result) {
        if (categoryIdPresent) {
            //if is leaf category,no need to show category navigator any more
            if (isLeaf(categoryId)) {
                result.setCategories(Collections.<SearchFacet>emptyList());
            }

            //remove selected category
            Iterables.removeIf(result.getCategories(), new Predicate<SearchFacet>() {
                @Override
                public boolean apply(SearchFacet input) {
                    return equal(input.getId(), categoryId);
                }
            });
        }
    }

    private boolean isLeaf(Long categoryId) {
        CategoryNode subTree = bch.getSubTreeById(categoryId);
        return subTree != null && subTree.getChildren().isEmpty();
    }

    //if user has selected a category or only one category matches the query ,then use that category as a bread crumbs,
    // else only virtual root shows on bread crumbs
    private void refineBreadCrumbs(Long categoryId, boolean categoryIdPresent, ItemSearchFactDto result) {
        //if user specified a category or only one category found,then add breadCrumbs
        if (categoryIdPresent || result.getCategories().size() == 1) {
            Long targetId = categoryId != null ? categoryId : result.getCategories().get(0).getId();
            List<BackCategory> ancestors = bch.ancestorsOf(targetId);

            //to make result,we use java.util.ArrayList
            List<Pair> breadCrumbs = Lists.newArrayListWithCapacity(ancestors.size());
            for (BackCategory backCategory : ancestors) {
                breadCrumbs.add(new Pair(backCategory.getName(), backCategory.getId()));
                if (equal(backCategory.getId(), categoryId)) {
                    List<Pair> chosenCategories = Lists.newArrayList();
                    chosenCategories.add(new Pair(backCategory.getName(), backCategory.getId()));
                    result.setChosenCategories(chosenCategories);
                }
            }

            result.setBreadCrumbs(breadCrumbs);


            //if the leaf category used as bread crumbs, then it should not appears in category navigator
            if (!categoryIdPresent) {
                result.setCategories(Collections.<SearchFacet>emptyList());
            }
        } else { //only add virtual root category
            result.setBreadCrumbs(rootCategory);
        }
    }


    //if a attribute has been selected as a query filter, then it should not appear in attribute navigator.
    //NOTE: we need to return user chosen properties
    private void refineAttributeNavigator(final Set<Long> attributeIds, ItemSearchFactDto result) {
        if (attributeIds != null) {
            final List<Pair> chosenAttributes = Lists.newArrayListWithCapacity(attributeIds.size());
            Iterables.removeIf(result.getAttributes(), new Predicate<ItemSearchFactDto.AttributeNavigator>() {
                @Override
                public boolean apply(ItemSearchFactDto.AttributeNavigator input) {
                    for (SearchFacet searchFacet : input.getValues()) {
                        if (attributeIds.contains(searchFacet.getId())) {
                            chosenAttributes.add(new Pair(input.getKey() + ":" + searchFacet.getName(), searchFacet.getId()));
                            return true;
                        }
                    }
                    return false;
                }
            });
            result.setChosenAttributes(chosenAttributes);
        }
        result.setAttributes(Lists.newArrayList(Iterables.limit(result.getAttributes(), 5)));//return atMost 5 attribute group
    }


    private void refineBrandsNavigator(final Set<Long> brandIds,ItemSearchFactDto result){
       List<BrandPair> chosenBrand=Lists.newArrayListWithCapacity(brandIds.size());
        ImmutableMap<Long, BrandPair> brandsMap = Maps.uniqueIndex(result.getAllBrands(), new Function<BrandPair, Long>() {
            @Override
            public Long apply(BrandPair brandPair) {
                return brandPair.getId();
            }
        });
        for(Long id:brandIds){
            BrandPair exist = brandsMap.get(id);
            chosenBrand.add(new BrandPair(id,exist.getCount(),exist.getName(),exist.getInitial()==null? "" :exist.getInitial().toLowerCase()));
        }
        result.setChosenBrands(chosenBrand);
        result.setBrands(Lists.newArrayList(Iterables.limit(result.getBrands(), 10)));
    }

    private void refineBrandNavigator(Long brandId, boolean brandIdPresent, ItemSearchFactDto result) {
        if (brandIdPresent) {
            List<BrandPair> brands = Lists.newArrayList();
            BrandPair toRemove = null;
            for (BrandPair sf : result.getBrands()) {
                if (equal(brandId, sf.getId())) {
                    brands.add(new BrandPair(sf.getId(), sf.getCount(), sf.getName(), sf.getInitial()==null? "" :sf.getInitial().toLowerCase()));
                    toRemove = sf;
                }
            }
            result.setChosenBrands(brands);
            //remove chosen brand
            if (toRemove != null) {
                result.getBrands().remove(toRemove);
            }
        }
        //return atMost 5 brand group
        result.setBrands(Lists.newArrayList(Iterables.limit(result.getBrands(), 10)));
    }

    /**
     * 将前台类目转换为后台叶子类目集合便于搜索
     *
     * @param frontCategoryId 前台类目id
     * @return 后台叶子类目集合
     */
    private Iterable<Long> frontCategoryToBackLeafIds(final long frontCategoryId) {
        Set<Long> leafIds = Sets.newHashSet();
        leafIds.add(frontCategoryId);
        getFrontCategoryChildIds(frontCategoryId,leafIds);
        List<Long> backCategoryIds = Lists.newArrayList();
        for (Long leafId : leafIds) {
            Response<List<CategoryMapping>> cm = frontCategoriesService.findMappingList(leafId);
            if (cm.isSuccess()) {
                List<Long> backIds = Lists.transform(cm.getResult(), new Function<CategoryMapping, Long>() {
                    @Override
                    public Long apply(CategoryMapping input) {
                        return input.getBackCategoryId();
                    }
                });
                backCategoryIds.addAll(backIds);
            } else {
                log.error("failed to find category mapping for front category (id={}),error code:{}, skip it",
                        frontCategoryId, cm.getError());
            }
        }

        return backCategoryIds;
    }

    private ItemSearchFactDto from(RawSearchResult<ItemRichDto> rawResult) {

        ItemSearchFactDto result = new ItemSearchFactDto();
        Facets facets = rawResult.getFacets();

        //handle category facets
        TermsFacet catFacet = facets.facet(CAT_FACETS);
        List<SearchFacet> leafCategoryFacet = processCategoryFacets(catFacet);

        //handle property facets
        TermsFacet attrFacet = facets.facet(ATTR_FACETS);
        List<ItemSearchFactDto.AttributeNavigator> attributeNavigators = processAttributeFacets(leafCategoryFacet, attrFacet);

        TermsFacet brandFacet = facets.facet(BRAND_FACETS);
        List<BrandPair> brandNavigators = processBrandFacet(brandFacet);

        List<BrandPair> allBrand = findAllBrand(brandFacet);

        // 总条数
        result.setTotal(rawResult.getTotal());
        // 搜索商品信息
        result.setResultDtos(rawResult.getData());
        result.setCategories(leafCategoryFacet);
        result.setAttributes(attributeNavigators);
        result.setBrands(brandNavigators);
        result.setAllBrands(allBrand);
        return result;
    }

    private List<BrandPair> processBrandFacet(TermsFacet brandFacet) {
        List<BrandPair> brands = Lists.newArrayListWithCapacity(BRAND_LIMITS);
        int total = 0;
        Iterator<TermsFacet.Entry> it = brandFacet.iterator();
        while (it.hasNext() && total < BRAND_LIMITS) {
            TermsFacet.Entry entry = it.next();
            Long brandId = Long.valueOf(entry.getTerm().string());
            Long count = (long) entry.getCount();
            final Response<GoodsBrandModel> brandR = brandService.findBrandInfoById(brandId);
            if (!brandR.isSuccess()) {
                log.error("failed to find brand(id={}), error code:{}", brandId, brandR.getError());
            } else {
                GoodsBrandModel brand = brandR.getResult();
                brands.add(new BrandPair(brand.getId(), count, brand.getBrandName(), brand.getInitial() == null ? "" : brand.getInitial().toLowerCase()));
            }
            total++;
        }
        return brands;
    }


    private List<BrandPair> findAllBrand(TermsFacet brandFacet){
        List<BrandPair> brands = Lists.newArrayList();
        if (brandFacet != null && brandFacet.iterator().hasNext()) {
            Iterator<TermsFacet.Entry> it = brandFacet.iterator();
            TermsFacet.Entry entry = it.next();
            Long count = (long) entry.getCount();
            Response<List<GoodsBrandModel>> brandsR = brandService.findAllBrandsForItemSearch();
            if (brandsR.isSuccess()) {
                List<GoodsBrandModel> list = brandsR.getResult();
                for (GoodsBrandModel brand : list) {
                    brands.add(new BrandPair(brand.getId(), count, brand.getBrandName(), brand.getInitial() == null ? "" : brand.getInitial().toLowerCase()));
                }
            }
        }
        return brands;
    }




    //find out attribute key and fill attrFacet name
    private List<ItemSearchFactDto.AttributeNavigator> processAttributeFacets(List<SearchFacet> leafCategoryFacet,
                                                                              TermsFacet propFacets) {
        Multimap<String, SearchFacet> allAttributes = LinkedHashMultimap.create();
        // 销售属性ID集合
        Map<Long, TermsFacet.Entry> byAttributeId = Maps.uniqueIndex(propFacets, new Function<TermsFacet.Entry, Long>() {
            @Override
            public Long apply(TermsFacet.Entry entry) {
                return Long.valueOf(entry.getTerm().string());
            }
        });
        for (SearchFacet categoryFacet : leafCategoryFacet) {
            Long categoryId = categoryFacet.getId();
            List<AttributeKey> attributeKeys = forest.getAttributeKeys(categoryId);
            for (AttributeKey attributeKey : attributeKeys) {
                Long attributeKeyId = attributeKey.getId();
                List<AttributeValue> attributeValues = forest.getAttributeValues(categoryId, attributeKeyId);
                for (AttributeValue attributeValue : attributeValues) {
                    Long attributeValueId = attributeValue.getId();
                    if (byAttributeId.containsKey(attributeValueId)) {
                        TermsFacet.Entry entry = byAttributeId.get(attributeValueId);
                        SearchFacet searchFacet = new SearchFacet(attributeValueId, (long) entry.getCount());
                        searchFacet.setName(attributeValue.getValue());//fill name
                        allAttributes.put(attributeKey.getName(), searchFacet);

                    }
                }
            }
        }
        List<ItemSearchFactDto.AttributeNavigator> attributeNavigators = Lists.newArrayListWithCapacity(allAttributes.keySet().size());
        for (String key : allAttributes.keySet()) {
            ItemSearchFactDto.AttributeNavigator navigator = new ItemSearchFactDto.AttributeNavigator();
            navigator.setKey(key);

            Set<SearchFacet> values = (Set<SearchFacet>) allAttributes.get(key);

            //make values be serializable
            Set<SearchFacet> nativeVal = Sets.newHashSetWithExpectedSize(values.size());
            //remove duplicate attribute-value name
            Set<String> allAttributeValueNames = Sets.newHashSet();
            for (SearchFacet val : values) {
                if(!allAttributeValueNames.contains(val.getName())) {
                    nativeVal.add(val);
                    allAttributeValueNames.add(val.getName());
                }
            }
            navigator.setValues(nativeVal);
            attributeNavigators.add(navigator);
        }
        return attributeNavigators;
    }


    //find leaf node and fill the category name
    private List<SearchFacet> processCategoryFacets(TermsFacet catFacet) {
        List<SearchFacet> leafCategoryFacet = Lists.newArrayList();
        for (TermsFacet.Entry entry : catFacet) {

            Long categoryId = Long.valueOf(entry.getTerm().string());
            CategoryNode subTreeRootNode = bch.getSubTreeById(categoryId);
            if (subTreeRootNode != null) {
                if (subTreeRootNode.getChildren().isEmpty()) {
                    SearchFacet searchFacet = new SearchFacet(Long.valueOf(entry.getTerm().string()),
                            (long) entry.getCount());
                    searchFacet.setName(subTreeRootNode.getCategory().getName());
                    leafCategoryFacet.add(searchFacet);
                } else {
                    log.debug("skip non-leaf category(id={},name={}) ", categoryId, subTreeRootNode.getCategory().getName());
                }
            } else {
                log.error("failed to find category(id={})", categoryId);
            }
        }
        return leafCategoryFacet;
    }


    private List<FrontCategory> findChildFrontById(final  long id){
        Response<List<FrontCategory>> childrenById = this.frontCategoriesService.findChildrenById(id);
        return MoreObjects.<List<FrontCategory>>firstNonNull(childrenById.getResult(),Collections.<FrontCategory>emptyList());
    }

    private void getFrontCategoryChildIds(long id,Set<Long> resultFrontCategory) {
        List<FrontCategory> childFrontById = findChildFrontById(id);
        for (FrontCategory frontCategory : childFrontById) {
            resultFrontCategory.add(frontCategory.getId());
            getFrontCategoryChildIds(frontCategory.getId(),resultFrontCategory);
        }
    }

}
