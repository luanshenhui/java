package cn.com.cgbchina.trade.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * Created by lvzd on 2016/9/24.
 */
@Setter
@Getter
@ToString
public class CarInfoDto implements Serializable {
    private static final long serialVersionUID = 1L;
    private String k = "";
    private String i = "";
    private String c = "";
}