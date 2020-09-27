package com.cebbank.ccis.cebmall.item.service;

import com.cebbank.ccis.cebmall.item.dao.ItemDao;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by 133625 on 16-5-19.
 */
@Service
@Slf4j
public class ItemServiceImpl implements ItemService {


    @Resource
    private ItemDao itemDao;
    @Override
    public List get(User user) {
        user.getId();
        return itemDao.getItemListTest();
    }

}