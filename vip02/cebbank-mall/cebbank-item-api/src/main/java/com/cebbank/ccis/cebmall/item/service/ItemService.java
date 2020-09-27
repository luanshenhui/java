package com.cebbank.ccis.cebmall.item.service;

import com.spirit.Annotation.Param;
import com.spirit.user.User;

import java.util.List;

/**
 * Created by 11140721050130 on 16-2-26.
 */
public interface ItemService {

    public List get(@Param("user")User user);

}
