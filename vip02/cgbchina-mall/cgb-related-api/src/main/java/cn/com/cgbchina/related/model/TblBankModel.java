package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class TblBankModel implements Serializable {

    private static final long serialVersionUID = -3466435374228817957L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    private String code;//分行号
    @Getter
    @Setter
    private String name;//分行名称
    @Getter
    @Setter
    private String bankCityNm;//发卡城市
    @Getter
    @Setter
    private Integer delFlag;//删除标志
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