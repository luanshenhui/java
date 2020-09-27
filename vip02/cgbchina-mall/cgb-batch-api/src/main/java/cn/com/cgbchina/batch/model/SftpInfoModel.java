package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;

/**
 * Created by 11150121040023 on 2016/8/15.
 */
@Setter
@Getter
@ToString
public class SftpInfoModel extends BaseModel implements Serializable {
    private static final long serialVersionUID = 3687256148940530322L;
    private String serverHost;
    private String serverPort;
    private String serverUser;
    private String serverName;
    private String serverPassword;
    private String sftpPath;
    private String sftpName;
}
