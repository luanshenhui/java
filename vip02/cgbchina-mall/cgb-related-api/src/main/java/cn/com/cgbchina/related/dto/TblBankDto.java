package cn.com.cgbchina.related.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

public class TblBankDto implements Serializable {

    private static final long serialVersionUID = 4758150871564971320L;
    @Getter
    @Setter
    private Long id;//自增主键
    @Getter
    @Setter
    @NotNull
    private String code;//分行号
    @Getter
    @Setter
    @NotNull
    private String name;//分行名称
    @Getter
    @Setter
    @NotNull
    private String bankCityNm;//发卡城市
}