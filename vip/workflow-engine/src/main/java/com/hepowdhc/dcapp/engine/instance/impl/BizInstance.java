package com.hepowdhc.dcapp.engine.instance.impl;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import com.hepowdhc.dcapp.engine.instance.Instance;

/**
 * Created by fzxs on 16-12-12.
 */
public abstract class BizInstance implements Instance,Serializable {

    protected BizInstance() {

        init();
    }

    protected abstract void init();
    
    
    /**
     * 业务数据id列表,用于消除风险和预警
     * 20170110
     */
    protected List<String> oaDataIdList;


	public List<String> getOaDataIdList() {
		if(null == oaDataIdList){
			oaDataIdList = new ArrayList<String>();
		}
		return oaDataIdList;
	}

	public void setOaDataIdList(List<String> oaDataIdList) {
		this.oaDataIdList = oaDataIdList;
	}
    
}
