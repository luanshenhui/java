package cn.rkylin.oms.item.vo;

import cn.rkylin.oms.item.domain.Item;

/**
 * 平台商品值对象，用于满足前台展示、系统间交互的需要
 *
 * @author wangxing
 * @version 1.0
 * @created 14-2月-2017 16:00:00
 */
public class ItemVO extends Item {
    /**
     * 序列化id
     */
    private static final long serialVersionUID = 1197685576331484879L;

    /**
     * 状态定义
     */
    private static final String STATUS_ONSALE = "<span>%s</span>";
    private static final String STATUS_INSTOCK = "<span style=\"color:red\">%s</span>";
    private static final String STATUS_SKUSHOW = "<span class=\"fa fa-chevron-down\" ecitemid=\"%s\"></span>";
    private static final String STATUS_CHK = "<input id=\"chkItem\" name=\"chkItem\" type=\"checkbox\" />%s</input>";

    public void finalize() throws Throwable {
        super.finalize();
    }

    /**
     * 平台规格编码扩展
     */
    private String ecSkuCode;

    public String getEcSkuCode() {
        return ecSkuCode;
    }

    public void setEcSkuCode(String ecSkuCode) {
        this.ecSkuCode = ecSkuCode;
    }

    /**
     * 平台规格名称扩展
     */
    private String ecSkuName;

    public String getEcSkuName() {
        return ecSkuName;
    }

    public void setEcSkuName(String ecSkuName) {
        this.ecSkuName = ecSkuName;
    }

    /**
     * 平台规格信息展开按钮扩展
     */
    private String skuShow;

    public String getSkuShow() {
        return String.format(STATUS_SKUSHOW, this.getEcItemId()).toString();
    }

    public void setSkuShow(String skuShow) {
        this.skuShow = String.format(STATUS_SKUSHOW, "").toString();
    }

    /**
     * 平台商品复选框扩展
     */
    private String chk;

//    public String getChk() {
//        return String.format(STATUS_CHK, this.chk).toString();
//    }
public String getChk() {
    return this.chk;
}

    public void setChk(String chk) {
        this.chk = String.format(STATUS_CHK, "").toString();
    }

    /**
     * 上下架状态
     */
    private String status;

    public String getStatus() {
        return this.status;
    }

    /**
     * 设置列表上的上下架列label
     *
     * @param status
     */
    public void setStatus(String status) {
        StringBuffer statusButton = new StringBuffer();
        if (this.getApproveStatus().equalsIgnoreCase("上架")) {
            statusButton.append(String.format(STATUS_ONSALE, "上架"));
        } else {
            statusButton.append(String.format(STATUS_INSTOCK, "下架"));
        }
        this.status = statusButton.toString();
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