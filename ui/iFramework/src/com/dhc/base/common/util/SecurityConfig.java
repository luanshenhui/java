package com.dhc.base.common.util;

import java.io.IOException;
import java.util.Properties;

public class SecurityConfig {
	static String regex_key_word;
	static String key_char;

	public SecurityConfig() {
		String path = "SecurityConfig.properties";
		Properties regexParams = new Properties();
		try {
			regexParams = FileUtil.getProperties(path);
			regex_key_word = regexParams.getProperty("KEY_WORD");
			key_char = regexParams.getProperty("KEY_CHAR");
		} catch (IOException e) {
			regex_key_word = "^script |^select |^net |^or |^and |^insert |^delete |^from |^count |^drop |^table |^update |^truncate |^mid |^char |^xp_cmdshell |^exec |^master |^netlocalgroup |^administrators ";//
			key_char = "<0>0&0#0$0'0+0[0]0^";
		}
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

}
