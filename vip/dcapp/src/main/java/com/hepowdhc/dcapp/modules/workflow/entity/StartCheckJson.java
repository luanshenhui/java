package com.hepowdhc.dcapp.modules.workflow.entity;

import java.util.Map;

public class StartCheckJson {

	private String flowId;
	private String title;
	private Map<String, Nodes> nodes;
	private Map<String, Lines> lines;
	private Map<String, Lines> areas;
	private int initNum;

	public String getFlowId() {
		return flowId;
	}

	public void setFlowId(String flowId) {
		this.flowId = flowId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Map<String, Nodes> getNodes() {
		return nodes;
	}

	public void setNodes(Map<String, Nodes> nodes) {
		this.nodes = nodes;
	}

	public Map<String, Lines> getLines() {
		return lines;
	}

	public void setLines(Map<String, Lines> lines) {
		this.lines = lines;
	}

	public Map<String, Lines> getAreas() {
		return areas;
	}

	public void setAreas(Map<String, Lines> areas) {
		this.areas = areas;
	}

	public int getInitNum() {
		return initNum;
	}

	public void setInitNum(int initNum) {
		this.initNum = initNum;
	}

}
