package com.dpn.ciqqlc.webservice.xml;

import java.util.List;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamImplicit;

@XStreamAlias("NewDataSet")
public class GoodXml {

    @XStreamImplicit(itemFieldName="TGoods")
	private List<TgoodsXml> list;

	public List<TgoodsXml> getList() {
		return list;
	}

	public void setList(List<TgoodsXml> list) {
		this.list = list;
	}
	
}
