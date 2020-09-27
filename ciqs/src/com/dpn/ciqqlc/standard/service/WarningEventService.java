package com.dpn.ciqqlc.standard.service;

import java.util.List;

import com.dpn.ciqqlc.service.dto.WarningDto;
import com.dpn.ciqqlc.standard.model.WarningStandardEventDto;

public interface WarningEventService {
	public String updateEvent(WarningDto dto) ;
	
	public List<WarningStandardEventDto> calculateStandard(WarningDto dto) ;
}
