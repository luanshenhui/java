package cn.com.cgbchina.item.dto;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by tongxueying on 2016/6/29.
 */
public class UploadProductDto implements Serializable {

    private static final long serialVersionUID = -8843593864657402770L;
    @Getter
    @Setter
    private String uploadFlag; // 导入成功标识
    @Getter
    @Setter
    private String uploadFailedReason; // 导入成功标识
    @Getter
    @Setter
    private Long backCategory1Id;//一级后台类目id
    @Getter
    @Setter
    private Long backCategory2Id; // 二级后台类目id
    @Getter
    @Setter
    private Long backCategory3Id; // 三级后台类目id
    @Getter
    @Setter
    private String brandName;// 品牌名称
    @Getter
    @Setter
    private String name;// 产品名称
}
