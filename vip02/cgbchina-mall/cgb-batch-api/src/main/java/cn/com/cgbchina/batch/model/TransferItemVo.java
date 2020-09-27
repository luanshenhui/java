package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

/**
 * Created by 11150121050003 on 2016/9/5.
 */
public class TransferItemVo implements Serializable {

    private static final long serialVersionUID = 9116430413819353257L;
    @Getter
    @Setter
    private String orgTableName;
    @Getter
    @Setter
    private String targetTableName;
    @Getter
    @Setter
    private String idName;
    @Getter
    @Setter
    private String dateName;
    @Getter
    @Setter
    private Integer transferDays;
    @Getter
    @Setter
    private String sql;//操作多表关联查询sql
    @Getter
    @Setter
    private List paramList;//存放条件
    @Getter
    @Setter
    private String transferDateFormat;
    @Getter
    @Setter
    private String sqlFlag;//查询语句条件使用in 或者 or  1:使用in ; 2 使用or

    public TransferItemVo(String orgTableName, String targetTableName, String idName, String dateName, Integer transferDays) {
        super();
        this.orgTableName = orgTableName;
        this.targetTableName = targetTableName;
        this.idName = idName;
        this.dateName = dateName;
        this.transferDays = transferDays;
    }


    public TransferItemVo(String orgTableName, String targetTableName,
                          String transferDateFormat, String sql, List list) {
        super();
        this.orgTableName = orgTableName;
        this.targetTableName = targetTableName;
        this.transferDateFormat = transferDateFormat;
        this.sql = sql;
        this.paramList = list;
    }

    public TransferItemVo(String orgTableName, String targetTableName,
                          String transferDateFormat, String sql, List list, String sqlFlag) {
        super();
        this.orgTableName = orgTableName;
        this.targetTableName = targetTableName;
        this.transferDateFormat = transferDateFormat;
        this.sql = sql;
        this.paramList = list;
        this.sqlFlag = sqlFlag;
    }


}
