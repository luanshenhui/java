package cn.com.cgbchina.batch.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serializable;
import java.util.List;

/**
 * @author wenjia.hao
 * @version 1.0
 * @Since 2016/7/15.
 */
@Setter
@Getter
@ToString
public class PromItemEntry implements Serializable {

    private static final long serialVersionUID = -2139539418854597731L;
    private String itemCode;
    private List<PromEntry> promEntries;
}