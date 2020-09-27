package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class GoodsRegionModel implements Serializable {

    private static final long serialVersionUID = -9161626972027681885L;
    @Getter
    @Setter
    private Long id;//id
    @Getter
    @Setter
    private String code;//分区代码
    @Getter
    @Setter
    private String name;//分区名称
    @Getter
    @Setter
    private String pointsType;//积分类型
    @Getter
    @Setter
    private String limitCards;//限第三级卡产品编号
    @Getter
    @Setter
    private String status;//当前状态0启用1禁用
    @Getter
    @Setter
    private String publishStatus;//发布状态0未发布1已发布
    @Getter
    @Setter
    private Integer sort;//显示顺序
    @Getter
    @Setter
    private String memo;//备注
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
    @Getter
    @Setter
    private String createOper;//创建者
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改者
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}