package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class SmspMdlModel implements Serializable {

    private static final long serialVersionUID = -5862502812032552787L;
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