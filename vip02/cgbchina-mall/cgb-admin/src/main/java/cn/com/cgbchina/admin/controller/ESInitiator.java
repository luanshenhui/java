package cn.com.cgbchina.admin.controller;

import com.google.common.base.Splitter;
import com.google.common.collect.ImmutableSet;
import com.spirit.search.ESClient;
import com.spirit.search.ESHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.List;
import java.util.Set;

@Component
public class ESInitiator {
	private static final Set<String> indices = ImmutableSet.<String> builder().add("items/item").build();

	private final ESClient esClient;

	@Autowired
	public ESInitiator(ESClient esClient) {
		this.esClient = esClient;
	}

	@PostConstruct
	public void init() {
		for (String index : indices) {
			List<String> parts = Splitter.on('/').omitEmptyStrings().trimResults().splitToList(index);
			ESHelper.createIndexIfNeeded(esClient.getClient(), parts.get(0), parts.get(1));
		}
	}
}
