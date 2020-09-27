package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by liuchang on 2016/6/23.
 */
public class UploadItemWeChatDto implements Serializable {

    private static final long serialVersionUID = -8569929169706558672L;
    @Getter
    @Setter
    private String uploadFlag; // 导入成功标识

    @Getter
    @Setter
    private String uploadFailedReason; // 导入成功标识

    @Getter
    @Setter
    private String itemCode; // 单品mid

    @Getter
    @Setter
    private String wxOrder; // 微信商品显示顺序
}
