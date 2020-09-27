package cn.rkylin.oms.item.vo;

import cn.rkylin.oms.item.domain.Sku;

/**
 * 平台规格值对象，用于满足前台展示、系统间交互的需要
 *
 * @author wangxing
 * @version 1.0
 * @created 15-2月-2017 16:58:00
 */
public class SkuVO extends Sku {
    /**
     * 序列化id
     */
    private static final long serialVersionUID = 1197685522201484879L;

    public void finalize() throws Throwable {
        super.finalize();
    }

    /**
     * orderBy子句
     */
    private String orderBy;

    public String getOrderBy() {
        // 此字段需要防止sql注入
        return orderBy == null ? null : orderBy.replaceAll(".*([';]+|(--)+).*", " ");
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    /**
     * 搜索条件
     */
    private String searchCondition;

    public String getSearchCondition() {
        return searchCondition;
    }

    public void setSearchCondition(String searchCondition) {
        this.searchCondition = searchCondition;
    }

}