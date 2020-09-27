package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by w2001316 on 2016/7/28.
 */
@Getter
@Setter
@ToString
public class MakePrivilegeFileModel extends BaseModel implements Serializable {

    private static final long serialVersionUID = 843026857752629782L;

    private String voucherNo;

    private String contIdcard;

    private String doDate;

    private String doTime;

    private Date createTime;

    private String curStatusId;
}
