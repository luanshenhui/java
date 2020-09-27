package cn.com.cgbchina.related.dto;

import java.io.Serializable;

import cn.com.cgbchina.related.model.EsphtmInfModel;
import lombok.Getter;
import lombok.Setter;

public class EsphtmInfDto extends EsphtmInfModel implements Serializable {

    private static final long serialVersionUID = -3015303659749387689L;
    @Getter
    @Setter
    private String simpleName;//供应商简称

}