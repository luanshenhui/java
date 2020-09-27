package cn.rkylin.oms.system.project.vo;

/**
 * 项目距值对象，用于满足导出
 *
 * @author wangxing
 * @version 1.0
 * @created 13-2月-2017 09:11:15
 */
public class ProjectExportVO extends ProjectVO {


    /**
     * 有效状态
     */
    private String enableStatus;


    public String getEnableStatus() {
        return enableStatus;
    }

    public void setEnableStatus(String enableStatus) {
        if (this.getEnable().equalsIgnoreCase("a")) {
            this.enableStatus = "登记";
        } else if (this.getEnable().equalsIgnoreCase("y")) {
            this.enableStatus = "启用";
        } else {
            this.enableStatus = "停用";
        }
    }
}
