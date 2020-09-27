package cn.com.cgbchina.item.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * Created by 1115012105001 on 2016/11/1.
 */
@Setter
@Getter
public class GroupClassify implements Serializable{
    private static final long serialVersionUID = -8512432368486154197L;
    private Long id;
    private String name;

    public GroupClassify() {
    }


}
