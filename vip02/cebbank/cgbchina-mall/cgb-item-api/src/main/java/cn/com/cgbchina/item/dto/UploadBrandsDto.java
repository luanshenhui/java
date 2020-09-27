package cn.com.cgbchina.item.dto;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

/**
 * Created by liuchang on 2016/6/23.
 */
public class UploadBrandsDto implements Serializable {

    private static final long serialVersionUID = -3776935485163613981L;
    @Getter
    @Setter
    private String uploadFlag; // 导入成功标识

    @Getter
    @Setter
    private String uploadFailedReason; // 导入成功标识

    @Getter
    @Setter
    private String ordertypeId; // 业务类型代码 YG：广发 JF：积分

    @Getter
    @Setter
    private String brandName; // 品牌名称
}
