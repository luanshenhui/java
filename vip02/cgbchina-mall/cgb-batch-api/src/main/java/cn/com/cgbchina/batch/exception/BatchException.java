package cn.com.cgbchina.batch.exception;

import org.apache.commons.lang3.StringUtils;
import org.springframework.ui.ModelMap;

/**
 *
 */
public class BatchException extends RuntimeException {

    private static final long serialVersionUID = 5121938860385967547L;

    public BatchException() {
    }

    public BatchException(Throwable ex) {
        super(ex);
    }

    public BatchException(String message) {
        super(message);
    }

    public BatchException(String message, Throwable ex) {
        super(message, ex);
    }

}
