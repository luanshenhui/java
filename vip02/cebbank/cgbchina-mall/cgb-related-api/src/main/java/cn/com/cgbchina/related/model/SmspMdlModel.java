package cn.com.cgbchina.related.model;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

public class SmspMdlModel implements Serializable {

    private static final long serialVersionUID = -6568572931417162019L;
    @Getter
    @Setter
    private String smspId;//短信模板id
    @Getter
    @Setter
    private String smspMess;//短信模板内容
    @Getter
    @Setter
    private java.util.Date createTime;//创建时间
    @Getter
    @Setter
    private String createOper;//创建人
}