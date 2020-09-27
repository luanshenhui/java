package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class GoodsPriceRegionModel implements Serializable {

    private static final long serialVersionUID = -5427076325214115777L;
    @Getter
    @Setter
    private Integer regionId;//自增主键
    @Getter
    @Setter
    private Integer minPoint;//区间最小值
    @Getter
    @Setter
    private Integer maxPoint;//区间最大值
    @Getter
    @Setter
    private Integer delFlag;//逻辑删除标记 0：未删除 1：已删除
    @Getter
    @Setter
    private String createOper;//创建人
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String modifyOper;//修改人
    @Getter
    @Setter
    private java.util.Date modifyTime;//修改时间
}