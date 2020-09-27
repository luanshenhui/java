package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

/**
 * 订单迁移记录表
 *
 * Created by 11150121050003 on 2016/9/5.
 */
@Getter
@Setter
public class TblTransferRecordModel extends BaseModel {

    private static final long serialVersionUID = -1894055707352492005L;
    private Long id; // 自增id
    private String orgtablename; // 原表名
    private String targertablename; // 目标表名
    private Date begin_time; // 开始时间
    private Date end_time; // 结束时间
    private String isexception; // 是否异常
    private String remard; // 注意内容
}
