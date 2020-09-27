package com.hepowdhc.dcapp.engine.node;

import java.util.HashMap;
import java.util.Map;

import com.hepowdhc.dcapp.engine.Node;

/**
 * Created by fzxs on 16-11-26.
 */
public abstract class ActionNode extends AbsNode {

	private final Map<String, Node> nodes = new HashMap<>();

	protected ActionNode(String nodeId) {
		super(nodeId);
	}

	@Override
	public Map<RuleType, Map<String, Object>> getNodeRule() {
		return null;
	}

	@Override
	public void validate(Map<String, Object> nodeData) {

	}

}
