package cn.com.cgbchina.rest.common.process;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * Comment:
 * Created by 11150321050126 on 2016/12/12.
 */
@Setter
@Getter
public class TestList {
    private String a;
    private String b;
    private List<TestList> c;
}
