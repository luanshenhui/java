package com.dpn.ciqqlc.standard.service;

import com.dpn.ciqqlc.standard.model.Tgoods;


public interface TgoodsService {
	
    int deleteByPrimaryKey(String GID);

    int insert(Tgoods record);

    int insertSelective(Tgoods record);

    Tgoods selectByPrimaryKey(String ID);

    int updateByPrimaryKeySelective(Tgoods record);

    int updateByPrimaryKey(Tgoods record);
    
    int fetchMaxGoodId();
    
    void addGoodByWebClient(String sessionID);
    
    void updateGoodByWebClient(String sessionID);
}