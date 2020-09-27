package cn.com.cgbchina.item.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * 增值服务专区表
 *
 * add by zhoupeng
 */
public class VirtualPrefuctureModel implements Serializable {

    private static final long serialVersionUID = -8113347319188356488L;
    @Getter
    @Setter
    private Integer id;//自增主键
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
    @Getter
    @Setter
    private String prefuctureId;//专区id
    @Getter
    @Setter
    private String prefuctureNm;//专区名称
    @Getter
    @Setter
    private Integer prefuctureSeq;//专区顺序
    @Getter
    @Setter
    private String remark;//备注
}