package cn.com.cgbchina.item.service.search;

import cn.com.cgbchina.common.contants.Contants;
import com.google.common.base.Function;
import com.google.common.base.MoreObjects;
import com.google.common.base.Objects;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;
import org.elasticsearch.action.search.SearchRequestBuilder;
import org.elasticsearch.index.query.*;
import org.elasticsearch.search.sort.SortOrder;

import java.util.List;
import java.util.Map;

/**
 * Created by 11140721050130 on 2016/8/29.
 */
public class SearchHelper {

    private final static Splitter splitter = Splitter.on('_').trimResults().omitEmptyStrings();
    private static final String INNER_TYPE = "1";

    public static QueryBuilder buildQuery(Map<String, String> params) {
        QueryBuilder queryBuilder;
        List<FilterBuilder> filters = Lists.newArrayList();
        String keywords = params.get("keywords");
        if (!Strings.isNullOrEmpty(keywords)) {
            //queryBuilder = QueryBuilders.matchQuery("name", keywords);
            queryBuilder = QueryBuilders.matchPhrasePrefixQuery("name", keywords);
        } else {
            queryBuilder = QueryBuilders.matchAllQuery();
        }
        // 业务类型过滤
        if (StringUtils.isNotBlank(params.get("b_t"))) {
            filters.add(FilterBuilders.termFilter("ordertypeId", params.get("b_t").toLowerCase()));
        }
        // 内宣商品过滤-内宣商品不检索
        filters.add(FilterBuilders.termFilter("isInner", INNER_TYPE));
        // 渠道类型过滤
        buildChannelQuery(filters, params);
        // 分区(礼品用)
        if (StringUtils.isNotBlank(params.get("r_t"))) {
            filters.add(FilterBuilders.termFilter("regionType", params.get("r_t").toLowerCase()));
        }

        // mx id
        buildMXidQuery(filters, params);
        //价格区间检索处理
        buildPriceQuery(filters,params);
        //积分区间检索处理
        buildPointsQuery(filters,params);



        //根据品牌id搜索
        String brandId = params.get("bid");
        if(!Strings.isNullOrEmpty(brandId)) {
            filters.add(FilterBuilders.termFilter("goodsBrandId", brandId));
        }
        // 类目ID
        Long categoryId = !Strings.isNullOrEmpty(params.get("cid")) ? Long.valueOf(params.get("cid")) : null;
        if (categoryId != null && !Objects.equal(categoryId, 0L)) { // category id 0 means search all categories
            filters.add(FilterBuilders.termFilter("categoryIds", categoryId));
        }
        //根据多个categoryIds搜索
        String categoryIds = params.get("categoryIds");
        if(!Strings.isNullOrEmpty(categoryIds)) {
            List<String> parsingCids = splitter.splitToList(categoryIds);
            filters.add(FilterBuilders.inFilter("categoryIds", parsingCids.toArray(new String[parsingCids.size()])));
        }

        //根据brandIds搜索
        String brandIds = params.get("bids");
        if(!Strings.isNullOrEmpty(brandIds)) {
            List<String> bIds = splitter.splitToList(brandIds);
            filters.add(FilterBuilders.inFilter("goodsBrandId", bIds.toArray(new String[bIds.size()])));
        }

        String attributeIds = params.get("pvids");
        if (!Strings.isNullOrEmpty(attributeIds)) {
            Iterable<Long> attributes = Iterables.transform(splitter.split(attributeIds), new Function<String, Long>() {
                @Override
                public Long apply(String input) {
                    return Long.valueOf(input);
                }
            });
            for (Long attribute : attributes) {
                filters.add(FilterBuilders.termFilter("attributeIds", attribute));
            }
        }

        if (filters.isEmpty()) {
            return queryBuilder;
        } else {
            AndFilterBuilder and = new AndFilterBuilder();
            for (FilterBuilder filter : filters) {
                and.add(filter);
            }
            return new FilteredQueryBuilder(queryBuilder, and);
        }
    }

    public static void buildSortQuery(SearchRequestBuilder requestBuilder, Map<String, String> params) {
        String sort = Strings.nullToEmpty(params.get("sort"));
        if (Strings.isNullOrEmpty(sort)) {
            String channel = Strings.nullToEmpty(params.get("c_t"));
            // 渠道类型过滤
            switch (channel) {
                case Contants.CHANNEL_MALL_WX_CODE: // "05"广发银行(微信)
                    requestBuilder.addSort("stickOrder", SortOrder.ASC);
                    break;
                case Contants.CHANNEL_MALL_CODE: // 00:网上商城（包括广发，积分商城）
                case Contants.CHANNEL_PHONE_CODE: // "03" 手机商城
                case Contants.CHANNEL_CC_CODE: // "01"呼叫中心
                case Contants.CHANNEL_SMS_CODE: // "04"短信渠道
                case Contants.CHANNEL_APP_CODE: // "09"APP渠道
                case Contants.CHANNEL_CREDIT_WX_CODE: // "06"广发信用卡(微信)
                case Contants.CHANNEL_IVR_CODE: // "02"IVR渠道
                default:
                    //以上渠道有个优先排序：置顶商品
                    // requestBuilder.addSort("stickFlag", SortOrder.DESC);非必须
                    requestBuilder.addSort("stickOrder", SortOrder.ASC);
                    break;
            }
            requestBuilder.addSort("modifyTime", SortOrder.DESC);
        }
        else {
            Iterable<String> parts = splitter.split(sort);
            String soldQuantity= Iterables.getFirst(parts, "0");
            String price = Iterables.get(parts, 1, "0");
            String modifyTime = Iterables.get(parts, 2, "0");
            String wxOrder = Iterables.get(parts, 3, "0");
            switch (Integer.valueOf(price)) {
                case 1:
                    requestBuilder.addSort("totalPrice", SortOrder.ASC);
                    break;
                case 2:
                    requestBuilder.addSort("totalPrice", SortOrder.DESC);
                    break;
                default:
                    break;
            }

            switch (Integer.valueOf(soldQuantity)) {
                case 1:
                    requestBuilder.addSort("salesNum", SortOrder.ASC);
                    break;
                case 2:
                    requestBuilder.addSort("salesNum", SortOrder.DESC);
                    break;
                default:
                    break;
            }
            switch (Integer.valueOf(modifyTime)) {
                case 1:
                    requestBuilder.addSort("modifyTime", SortOrder.ASC);
                    break;
                case 2:
                    requestBuilder.addSort("modifyTime", SortOrder.DESC);
                    break;
                default:
                    break;
            }
            switch (Integer.valueOf(wxOrder)) {
                case 1:
                    requestBuilder.addSort("wxOrder", SortOrder.ASC);
                    break;
                case 2:
                    requestBuilder.addSort("wxOrder", SortOrder.DESC);
                    break;
                default:
                    break;
            }
        }
    }


    private  static void buildPointsQuery(List<FilterBuilder> filters,Map<String,String> params){
        // 积分区间
        String quantityFrom = params.get("q_f");
        String quantityTo = params.get("q_t");
        if (!Strings.isNullOrEmpty(quantityFrom) || !Strings.isNullOrEmpty(quantityTo)) {

            String channel = Strings.nullToEmpty(params.get("c_t"));
            NotFilterBuilder promBuilder;//在活动中的标识
            RangeFilterBuilder pointsBuilder=null;//积分 如果参加活动广发商城兑换积分会变导致搜索结果不准确
            TermFilterBuilder notPromBuilder;//不在活动中标识
            RangeFilterBuilder originalPointsBuilder=null;//原价过滤
            // 渠道类型过滤
            switch (MoreObjects.firstNonNull(channel,Contants.CHANNEL_MALL_CODE)) {
                case Contants.CHANNEL_MALL_CODE: // 00:网上商城（包括广发，积分商城）
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("mallPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("mallPromoType", 0);
                    break;
                case Contants.CHANNEL_PHONE_CODE: // "03" 手机商城
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("phonePromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("phonePromoType", 0);
                    break;
                case Contants.CHANNEL_CC_CODE: // "01"呼叫中心
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("ccPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("ccPromoType", 0);
                    break;
                case Contants.CHANNEL_SMS_CODE: // "04"短信渠道
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("smsPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("smsPromoType", 0);
                    break;
                case Contants.CHANNEL_APP_CODE: // "09"APP渠道
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("appPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("appPromoType", 0);
                    break;
                case Contants.CHANNEL_MALL_WX_CODE: // "05"广发银行(微信)
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("mallWxPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("mallWxPromoType", 0);
                    break;
                case Contants.CHANNEL_CREDIT_WX_CODE: // "06"广发信用卡(微信)
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("creditWxPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("creditWxPromoType", 0);
                    break;
                case Contants.CHANNEL_IVR_CODE: // "02"IVR渠道
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("ivrPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("ivrPromoType", 0);
                    break;
                default:
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("mallPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("mallPromoType", 0);
                    break;
            }
            pointsBuilder = FilterBuilders.rangeFilter("points");//过滤活动字段
            originalPointsBuilder = FilterBuilders.rangeFilter("originalPoints");

            if (!Strings.isNullOrEmpty(quantityFrom)) {
                Double pointsFrom = Double.parseDouble(quantityFrom);
                pointsBuilder.from(pointsFrom.intValue());
                originalPointsBuilder.from(pointsFrom.intValue());
            }
            if (!Strings.isNullOrEmpty(quantityTo)) {
                Double pointsTo = Double.parseDouble(quantityTo);
                pointsBuilder.to(pointsTo.intValue());
                originalPointsBuilder.to(pointsTo.intValue());
            }

            TermFilterBuilder orderTypeYG = FilterBuilders.termFilter("ordertypeId", "yg");
            TermFilterBuilder orderTypeJF = FilterBuilders.termFilter("ordertypeId", "jf");


            OrFilterBuilder orFilterBuilder = FilterBuilders.orFilter(FilterBuilders.andFilter(orderTypeJF, originalPointsBuilder),
                    FilterBuilders.andFilter(orderTypeYG, promBuilder, pointsBuilder), FilterBuilders.andFilter(orderTypeYG,notPromBuilder, originalPointsBuilder));

          filters.add(orFilterBuilder);
        }
    }



    /**
     * 只有广发商城有使用价格区间已经检索的需求 其他渠道没有 故只处理商城渠道的搜索列表页价格检索区间的差异
     * @param filters
     * @param params
     */
    private  static void  buildPriceQuery(List<FilterBuilder> filters, Map<String, String> params){
        // 价格区间
        String priceFrom = params.get("p_i");
        String priceTo = params.get("p_x");
        if (!Strings.isNullOrEmpty(priceFrom) || !Strings.isNullOrEmpty(priceTo)) {
            String channel = Strings.nullToEmpty(params.get("c_t"));
            NotFilterBuilder promBuilder;//在活动中的标识
            RangeFilterBuilder totalPriceBuilder=null;//活动价过滤
            TermFilterBuilder notPromBuilder;//不在活动中标识
            RangeFilterBuilder originalTotalPrice=null;//原价过滤
            // 渠道类型过滤
            switch (MoreObjects.firstNonNull(channel,Contants.CHANNEL_MALL_CODE)) {
                case Contants.CHANNEL_MALL_CODE: // 00:网上商城（包括广发，积分商城）
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("mallPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("mallPromoType", 0);
                    break;
                case Contants.CHANNEL_PHONE_CODE: // "03" 手机商城
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("phonePromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("phonePromoType", 0);
                    break;
                case Contants.CHANNEL_CC_CODE: // "01"呼叫中心
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("ccPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("ccPromoType", 0);
                    break;
                case Contants.CHANNEL_SMS_CODE: // "04"短信渠道
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("smsPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("smsPromoType", 0);
                    break;
                case Contants.CHANNEL_APP_CODE: // "09"APP渠道
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("appPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("appPromoType", 0);
                    break;
                case Contants.CHANNEL_MALL_WX_CODE: // "05"广发银行(微信)
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("mallWxPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("mallWxPromoType", 0);
                    break;
                case Contants.CHANNEL_CREDIT_WX_CODE: // "06"广发信用卡(微信)
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("creditWxPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("creditWxPromoType", 0);
                    break;
                case Contants.CHANNEL_IVR_CODE: // "02"IVR渠道
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("ivrPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("ivrPromoType", 0);
                    break;
                default:
                    promBuilder = FilterBuilders.notFilter(FilterBuilders.termFilter("mallPromoType", 0));
                    notPromBuilder = FilterBuilders.termFilter("mallPromoType", 0);
                    break;
            }
            totalPriceBuilder = FilterBuilders.rangeFilter("totalPrice");//过滤活动字段
            originalTotalPrice = FilterBuilders.rangeFilter("originalTotalPrice");

            if (!Strings.isNullOrEmpty(priceFrom)) {
                Double price = Double.parseDouble(priceFrom);
                totalPriceBuilder.from(price.intValue());
                originalTotalPrice.from(price.intValue());
            }
            if (!Strings.isNullOrEmpty(priceTo)) {
                Double price = Double.parseDouble(priceTo);
                totalPriceBuilder.to(price.intValue());
                originalTotalPrice.to(price.intValue());
            }
            OrFilterBuilder orFilterBuilder = FilterBuilders.orFilter(FilterBuilders.andFilter(promBuilder,
                    totalPriceBuilder), FilterBuilders.andFilter(notPromBuilder, originalTotalPrice));

            filters.add(orFilterBuilder);
        }
    }



    // 渠道类型过滤
    private static void buildChannelQuery(List<FilterBuilder> filters, Map<String, String> params) {
        String channel = Strings.nullToEmpty(params.get("c_t"));
        String promotionType = Strings.nullToEmpty(params.get("p_t"));
        String promotionKey = null;
        // 渠道类型过滤
        switch (channel) {
            case Contants.CHANNEL_MALL_CODE: // 00:网上商城（包括广发，积分商城）
                filters.add(FilterBuilders.orFilter(
                        FilterBuilders.termFilter("channelMall", "02"),
                        FilterBuilders.termFilter("channelPoints", "02")
                ));
                promotionKey = "mallPromoType";
                break;
            case Contants.CHANNEL_PHONE_CODE: // "03" 手机商城
                filters.add(FilterBuilders.termFilter("channelPhone", "02"));
                promotionKey = "phonePromoType";
                break;
            case Contants.CHANNEL_CC_CODE: // "01"呼叫中心
                filters.add(FilterBuilders.termFilter("channelCc", "02"));
                promotionKey = "ccPromoType";
                break;
            case Contants.CHANNEL_SMS_CODE: // "04"短信渠道
                filters.add(FilterBuilders.termFilter("channelSms", "02"));
                promotionKey = "smsPromoType";
                break;
            case Contants.CHANNEL_APP_CODE: // "09"APP渠道
                filters.add(FilterBuilders.termFilter("channelApp", "02"));
                promotionKey = "appPromoType";
                break;
            case Contants.CHANNEL_MALL_WX_CODE: // "05"广发银行(微信)
                filters.add(FilterBuilders.termFilter("channelMallWx", "02"));
                promotionKey = "mallWxPromoType";
                break;
            case Contants.CHANNEL_CREDIT_WX_CODE: // "06"广发信用卡(微信)
                filters.add(FilterBuilders.termFilter("channelCreditWx", "02"));
                promotionKey = "creditWxPromoType";
                break;
            case Contants.CHANNEL_IVR_CODE: // "02"IVR渠道
                filters.add(FilterBuilders.termFilter("channelIvr", "02"));
                promotionKey = "ivrPromoType";
                break;
            default:
                filters.add(FilterBuilders.orFilter(
                        FilterBuilders.termFilter("channelMall", "02"),
                        FilterBuilders.termFilter("channelPoints", "02")
                ));
                break;
        }

        if (StringUtils.isNotBlank(promotionType) && !Strings.isNullOrEmpty(promotionKey)) {
            if (("0").equals(promotionType)) {
                //
            }
            else {
                filters.add(FilterBuilders.termFilter(promotionKey, params.get("p_t") + "0"));
            }
        }
    }

    private static void buildMXidQuery(List<FilterBuilder> filters, Map<String, String> params) {
        // 分区(礼品用)
        if (StringUtils.isNotBlank(params.get("r_t"))) {
            filters.add(FilterBuilders.termFilter("regionType", params.get("r_t").toLowerCase()));
        }
        // 商品ID(分期唯一值用于外系统)
        if (StringUtils.isNotBlank(params.get("m_i"))) {
            filters.add(FilterBuilders.termFilter("mid", params.get("m_i").toLowerCase()));
        }
        // 商品ID(一次性唯一值用于外系统)
        if (StringUtils.isNotBlank(params.get("o_i"))) {
            filters.add(FilterBuilders.termFilter("oid", params.get("o_i").toLowerCase()));
        }
        // 礼品编码
        if (StringUtils.isNotBlank(params.get("x_i"))) {
            filters.add(FilterBuilders.termFilter("xid", params.get("x_i").toLowerCase()));
        }
        // 虚拟礼品代号
        if (StringUtils.isNotBlank(params.get("b_i"))) {
            filters.add(FilterBuilders.termFilter("bid", params.get("b_i").toLowerCase()));
        }
    }
}
