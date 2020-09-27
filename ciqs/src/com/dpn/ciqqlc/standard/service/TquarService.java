package com.dpn.ciqqlc.standard.service;

import com.dpn.ciqqlc.standard.model.Tquar;



public interface TquarService {
	
    int deleteByPrimaryKey(String TID);

    int insert(Tquar record);

    int insertSelective(Tquar record);

    Tquar selectByPrimaryKey(String ID);

    int updateByPrimaryKeySelective(Tquar record);

    int updateByPrimaryKey(Tquar record);
}