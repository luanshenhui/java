package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
public class TblConfigModel implements Serializable {

    @Getter
    @Setter
    private Long id;//id
    @Getter
    @Setter
    private String cfgType;//字典代码
    @Getter
    @Setter
    private Integer cfgCode;//详细编码
    @Getter
    @Setter
    private String cfgName;//名称
    @Getter
    @Setter
    private Integer cfgOrder;//排序
    @Getter
    @Setter
    private String cfgValue1;//值1
    @Getter
    @Setter
    private String cfgValue2;//值2
    @Getter
    @Setter
    private String cfgValue3;//值3
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