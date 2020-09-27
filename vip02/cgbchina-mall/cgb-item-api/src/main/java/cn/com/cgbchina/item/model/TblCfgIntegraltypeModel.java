package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;
import java.io.Serializable;

public class TblCfgIntegraltypeModel implements Serializable {


    private static final long serialVersionUID = -5060514957648806816L;
    @Getter
    @Setter
    private String integraltypeId;//积分类型id
    @Getter
    @Setter
    private String integraltypeNm;//积分类型名称
    @Getter
    @Setter
    private String curStatus;//状态
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