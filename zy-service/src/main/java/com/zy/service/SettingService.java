package com.zy.service;

import com.zy.entity.sys.Setting;

public interface SettingService {

	Setting find();

	void merge(Setting setting, String... fields);
	
	String checkScript(String script, String field);

}
