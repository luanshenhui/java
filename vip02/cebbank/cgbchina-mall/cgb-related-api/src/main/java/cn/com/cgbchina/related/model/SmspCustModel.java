package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class SmspCustModel implements Serializable {

    private static final long serialVersionUID = -4897140533512250285L;
    @Getter
    @Setter
    private Long id;//短信维护表id
    @Getter
    @Setter
    private String phone;//手机号
    @Getter
    @Setter
    private String cardNo;//卡号
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