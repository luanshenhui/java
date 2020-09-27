package cn.rkylin.oms.item.vo;

/**
 * 平台商品值对象，用于满足导出
 *
 * @author wangxing
 * @version 1.0
 * @created 14-2月-2017 16:00:00
 */
public class ItemExportVO extends ItemVO {

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
        if (this.getApproveStatus().equalsIgnoreCase("上架")) {
            this.status = "上架";
        } else {
            this.status = "下架";
        }
    }

}
