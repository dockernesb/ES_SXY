package com.wa.framework.exception;

public class CaException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public CaException() {
		super();
	}

	public CaException(String message, Throwable cause,
			boolean enableSuppression, boolean writableStackTrace) {
		super(message, cause, enableSuppression, writableStackTrace);
	}

	public CaException(String message, Throwable cause) {
		super(message, cause);
	}

	public CaException(String message) {
		super(message);
	}

	public CaException(Throwable cause) {
		super(cause);
	}

}
