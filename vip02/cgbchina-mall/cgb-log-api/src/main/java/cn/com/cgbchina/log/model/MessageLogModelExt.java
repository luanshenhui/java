package cn.com.cgbchina.log.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Comment:
 * Created by 11150321050126 on 2016/9/21.
 */
@Setter
@Getter
public class MessageLogModelExt extends MessageLogModel implements Serializable{
    private String orgMessage;
    private int type;
}
