package com.cebbank.ccis.cebmall.user.dto;


import com.cebbank.ccis.cebmall.user.model.EspAdvertiseModel;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * @author yuxinxin
 * @version 1.0
 * @Since 16-7-14.
 */
@Getter
@Setter
@ToString
public class EspAdvertiseDto extends EspAdvertiseModel {

    private static final long serialVersionUID = -1782263446914702739L;
    private String backCategory1Name; // 后台类目1名称
    private String backCategory2Name; // 后台类目2名称
    private String backCategory3Name; // 后台类目3名称
//    private String backCategory4Name; // 后台类目3名称
    private String categoryList; // 后台类目List
    private Long backCategory1Id; // 后台类目1ID
    private Long backCategory2Id; // 后台类目2ID
    private Long backCategory3Id; // 后台类目3ID
//    private Long backCategory4Id; // 后台类目4ID
}
