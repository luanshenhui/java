package cn.com.cgbchina.related.dto;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

public class TimeOutHtmlDto implements Serializable {

    private static final long serialVersionUID = 6894498050117180785L;
    @Getter
    @Setter
    private List<String> timeEndList;//已经过期
    @Getter
    @Setter
    private List<String> timeEndingList;//即将要过期

}