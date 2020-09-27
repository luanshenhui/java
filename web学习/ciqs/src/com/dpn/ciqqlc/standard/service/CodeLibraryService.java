package com.dpn.ciqqlc.standard.service;

import java.util.List;

import com.dpn.ciqqlc.standard.model.CodeLibraryDTO;

public interface CodeLibraryService {
	
	/**
	 * 查询列表
	 * @param type
	 * @return
	 */
	List<CodeLibraryDTO> findCodeLibraryList(String type);
	
}
