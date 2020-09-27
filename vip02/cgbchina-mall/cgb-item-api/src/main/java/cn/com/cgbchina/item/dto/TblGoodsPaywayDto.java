package cn.com.cgbchina.item.dto;

import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by liuchang on 2016/8/17.
 */
public class TblGoodsPaywayDto extends TblGoodsPaywayModel implements Serializable {

    private static final long serialVersionUID = 6807932253036896850L;

    @Getter
    @Setter
    private String ischeckOld;

    @Getter
    @Setter
    private String ischeckNew;

}
