package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.OrigPlaceCargoDto;
import com.dpn.ciqqlc.standard.model.OrigPlaceDto;
import com.dpn.ciqqlc.standard.model.VideoEventModel;

public interface OrigPlaceFlowService {

	List<OrigPlaceDto> findorigList(OrigPlaceDto origPlace) throws Exception;

	int findOrigCount(OrigPlaceDto origPlace) throws Exception;
	
	void insertOrigPlace(OrigPlaceDto origPlace) throws Exception;

	OrigPlaceDto findOrigById(String id) throws Exception;

	List<VideoEventModel> getViewImg(VideoEventModel videoEvent);

	List<OrigPlaceDto> findAppPrigList(OrigPlaceDto origPlace);

	List<CheckDocsRcdModel> getOptionList(CheckDocsRcdModel checkDocsRcd);

	List<Map<String, String>> getOrigById(String id);


	OrigPlaceDto getOrigPlace(OrigPlaceDto origPlace);

	List<OrigPlaceCargoDto> getOrigPlaceCargo(OrigPlaceCargoDto origPlaceCargo);


}
