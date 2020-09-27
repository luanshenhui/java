package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class SmspCustModel implements Serializable {

    private static final long serialVersionUID = 8353654905425310045L;
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
    @Getter
    @Setter
    private String userType;//角色类型

    public String toString(){
        return this.phone + "|" +this.cardNo;
    }
}