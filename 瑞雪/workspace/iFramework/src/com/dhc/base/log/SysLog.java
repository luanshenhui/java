package com.dhc.base.log;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.dhc.base.common.util.StringUtil;

/**
 * 封装日志
 */
public class SysLog {

	/**
	 * trace级别的日志信息是否输出。 description:
	 * 
	 * @param moduleName
	 * @return
	 */
	public static boolean isEnabledTrace(String moduleName) {
		Log logger = LogFactory.getLog(moduleName);
		return logger.isTraceEnabled();
	}

	/**
	 * debug级别的日志信息是否输出。 description:
	 * 
	 * @param moduleName
	 * @return
	 */
	public static boolean isEnabledDebug(String moduleName) {
		Log logger = LogFactory.getLog(moduleName);
		return logger.isDebugEnabled();
	}

	/**
	 * info级别的日志信息是否输出。 description:
	 * 
	 * @param moduleName
	 * @return
	 */
	public static boolean isEnabledInfo(String moduleName) {
		Log logger = LogFactory.getLog(moduleName);
		return logger.isInfoEnabled();
	}

	/**
	 * warn级别的日志信息是否输出。 description:
	 * 
	 * @param moduleName
	 * @return
	 */
	public static boolean isEnabledWarn(String moduleName) {
		Log logger = LogFactory.getLog(moduleName);
		return logger.isWarnEnabled();
	}

	/**
	 * error级别的日志信息是否输出。 description:
	 * 
	 * @param moduleName
	 * @return
	 */
	public static boolean isEnabledError(String moduleName) {
		Log logger = LogFactory.getLog(moduleName);
		return logger.isErrorEnabled();
	}

	/**
	 * fatal级别的日志信息是否输出。 description:
	 * 
	 * @param moduleName
	 * @return
	 */
	public static boolean isEnabledFatal(String moduleName) {
		Log logger = LogFactory.getLog(moduleName);
		return logger.isFatalEnabled();
	}

	/**
	 * 写系统日志的方法 description:
	 * 
	 * @param moduleName
	 *            模块名称，必须符合规范中定义的名称
	 * @param logType
	 *            日志信息的类型，包括trace、debug、info、warn、error、fatal
	 * @param logInfo
	 *            需要输出的日志信息 return
	 */
	public static void writeLogs(String moduleName, String logLevel, String logInfo) {
		Log logger = LogFactory.getLog(moduleName);
		if (logLevel.equals(LogLevel.TRACE))
			logger.trace(logInfo);
		else if (logLevel.equals(LogLevel.DEBUG))
			logger.debug(logInfo);
		else if (logLevel.equals(LogLevel.INFO))
			logger.info(logInfo);
		else if (logLevel.equals(LogLevel.WARN))
			logger.warn(logInfo);
		else if (logLevel.equals(LogLevel.ERROR))
			logger.error(logInfo);
		else if (logLevel.equals(LogLevel.FATAL))
			logger.fatal(logInfo);
	}

	/**
	 * 把异常的堆栈信息输出到日志信息中 description:
	 * 
	 * @param moduleName
	 *            模块名称，必须符合规范中定义的名称
	 * @param logLevel
	 *            日志信息的类型，包括trace、debug、info、warn、error、fatal
	 * @param logInfo
	 *            需要输出的日志信息
	 * @param e
	 *            异常 return
	 */
	public static void writeExceptionLogs(String moduleName, String logLevel, String logInfo, Exception e) {
		Log logger = LogFactory.getLog(moduleName);
		if (logLevel.equals("TRACE"))
			logger.trace(logInfo + StringUtil.getStackTrace(e));
		else if (logLevel.equals("DEBUG"))
			logger.debug(logInfo + StringUtil.getStackTrace(e));
		else if (logLevel.equals("INFO"))
			logger.info(logInfo + StringUtil.getStackTrace(e));
		else if (logLevel.equals("WARN"))
			logger.warn(logInfo + StringUtil.getStackTrace(e));
		else if (logLevel.equals("ERROR"))
			logger.error(logInfo + StringUtil.getStackTrace(e));
		else if (logLevel.equals("FATAL"))
			logger.fatal(logInfo + StringUtil.getStackTrace(e));
	}

}
