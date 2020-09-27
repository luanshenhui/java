package com.cebbank.ccis.cebmall.user.model;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 11140721050130 on 2016/12/21.
 */
@EqualsAndHashCode
public class TestModel implements Serializable {
    @Getter
    @Setter
    private String id;
    @Getter
    @Setter
    private String name;
    @Getter
    @Setter
    private String code;
}
