package com.dhc.base.common.util;

import java.io.IOException;
import java.util.Properties;

public class SystemConfig {
	static String regex_key_word;
	static String key_char;
	static String system_title;
	static String system_short_title;
	static String top_username;
	static String help_link;
	static String TOP_USERNAME_DEFAULT_SET = "1";// 默认只显示姓名
	public static final String LANGUAGE = PropertiesUtil.language;

	public SystemConfig() {
		String path = "SystemConfig.properties";
		Properties configParams = new Properties();
		try {
			configParams = FileUtil.getProperties(path);
			regex_key_word = configParams.getProperty("KEY_WORD");
			key_char = configParams.getProperty("KEY_CHAR");
			system_title = getSystemTitle(configParams);
			system_short_title = getSystemShortTitle(configParams);
			top_username = getTopUserName(configParams);
			help_link = configParams.getProperty("HELP_LINK");
		} catch (IOException e) {
			regex_key_word = "^script |^select |^net |^or |^and |^insert |^delete |^from |^count |^drop |^table |^update |^truncate |^mid |^char |^xp_cmdshell |^exec |^master |^netlocalgroup |^administrators ";//
			key_char = "<0>0&0#0$0'0+0[0]0^";
			system_title = getSystemTitleFromInternationalConfig();
			system_short_title = system_title;
			top_username = TOP_USERNAME_DEFAULT_SET;
			help_link = null;
		}
	}

	public static String getSystemTitle() {
		return system_title;
	}

	public static String getSystemShortTitle() {
		return system_short_title;
	}

	public static String getTopUserName() {
		return top_username;
	}

	public static String getHelpLink() {
		return help_link;
	}

	public static String getRegexKeyWord() {
		return regex_key_word;
	}

	public void setRegexKeyWord(String _regex_key_word) {
		this.regex_key_word = _regex_key_word;
	}

	public static String getKeyChar() {
		return key_char;
	}

	public void setKeyChar(String key_char) {
		this.key_char = key_char;
	}

	private String getSystemTitle(Properties configParams) {
		String title = configParams.getProperty("SYSTEM_TITLE");
		// 如果是中文，取SystemConfig的配置，否则取国际化配置
		if (title == null) {
			title = getSystemTitleFromInternationalConfig();
		}
		return title;
	}

	private String getSystemShortTitle(Properties configParams) {
		String short_title = configParams.getProperty("SYSTEM_SHORT_TITLE");
		// 如果是中文，取SystemConfig的配置，否则取国际化配置
		if (short_title == null) {
			short_title = system_title;
		}
		return short_title;
	}

	private String getTopUserName(Properties configParams) {
		String top_username = configParams.getProperty("TOP_USERNAME");
		if (top_username == null) {
			top_username = TOP_USERNAME_DEFAULT_SET;
		}
		return top_username;
	}

	private String getSystemTitleFromInternationalConfig() {
		try {
			return PropertiesUtil.getMessage("system.title");
		} catch (Exception e) {
			return "iFramework";
		}
	}
}
