package com.dpn.ciqqlc.webservice.xml;

import java.util.List;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import com.thoughtworks.xstream.annotations.XStreamImplicit;

@XStreamAlias("NewDataSet")
public class QuarXml {

    @XStreamImplicit(itemFieldName="TQuar")
	private List<TquarXml> list;

	public List<TquarXml> getList() {
		return list;
	}

	public void setList(List<TquarXml> list) {
		this.list = list;
	}
}
