package com.wa.framework.utils;

import cn.org.bjca.client.exceptions.*;
import cn.org.bjca.client.security.SecurityEngineDeal;
import com.wa.framework.common.PropertyConfigurer;
import com.wa.framework.exception.CaException;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

/**
 * @category CA工具类
 * @author admin
 *
 */
public class CaUtil {

	private static Logger log = Logger.getLogger(CaUtil.class);

	private static SecurityEngineDeal sed = null;

	static {
		try {
			String path = PropertyConfigurer.getValue("ca.config.path");
			String name = PropertyConfigurer.getValue("ca.config.name");
			SecurityEngineDeal.setProfilePath(path);
			sed = SecurityEngineDeal.getInstance(name);
		} catch (SVSConnectException e) {
			e.printStackTrace();
			log.error(e);
		} catch (ApplicationNotFoundException e) {
			e.printStackTrace();
			log.error(e);
		} catch (InitException e) {
			e.printStackTrace();
			log.error(e);
		}
	}

	private CaUtil() {
	}

	/**
	 * @category 获取随机数
	 * @return
	 */
	public static String getRandomString() {
		if (sed != null) {
			try {
				return sed.genRandom(20);
			} catch (SVSConnectException e) {
				e.printStackTrace();
				log.error(e);
			} catch (ParameterOutRangeException e) {
				e.printStackTrace();
				log.error(e);
			}
		}
		return "";
	}

	/**
	 * @category 获取服务器签名
	 * @param RandomString
	 * @return
	 */
	public static String getServerSignedData(String RandomString) {
		if (sed != null) {
			try {
				return sed.signData(RandomString);
			} catch (SVSConnectException e) {
				e.printStackTrace();
				log.error(e);
			} catch (ParameterTooLongException e) {
				e.printStackTrace();
				log.error(e);
			}
		}
		return null;
	}

	/**
	 * @category 获取服务器端证书
	 * @return
	 */
	public static String getServerCert() {
		if (sed != null) {
			try {
				return sed.getServerCertificate();
			} catch (SVSConnectException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * @category 根据用户ca获取用户key
	 * @param UserCert
	 * @param UserSignedData
	 * @return
	 */
	public static String getUserKey(String UserCert, String RandomString,
			String UserSignedData) {
		if (sed != null) {
			try {
				checkCert(UserCert);

				checkSignedData(UserCert, RandomString, UserSignedData);

				return getCaKey(UserCert);

			} catch (CaException e) {
				e.printStackTrace();
				log.error(e);
				throw e;
			} catch (Exception e) {
				e.printStackTrace();
				log.error(e);
				throw new CaException("证书验证失败");
			}
		}
		return null;
	}

	/**
	 * @category 验证证书
	 * @param sed
	 * @param UserCert
	 * @throws SVSConnectException
	 * @throws ParameterTooLongException
	 * @throws ParameterInvalidException
	 * @throws ParameterOutRangeException
	 */
	private static void checkCert(String UserCert) throws SVSConnectException,
			ParameterTooLongException, ParameterInvalidException,
			ParameterOutRangeException {
		int retValue = sed.validateCert(UserCert);

		switch (retValue) {
		case -1:
			throw new CaException("登录证书的根不被信任");
		case -2:
			throw new CaException("登录证书超过有效期");
		case -3:
			throw new CaException("登录证书为作废证书");
		case -4:
			throw new CaException("登录证书被临时冻结");
		case -5:
			throw new CaException("登录证书未生效");
		}
	}

	/**
	 * @category 验证签名
	 * @param sed
	 * @param UserCert
	 * @param RandomString
	 * @param UserSignedData
	 * @throws SVSConnectException
	 * @throws ParameterTooLongException
	 * @throws ParameterInvalidException
	 * @throws UnkownException
	 */
	private static void checkSignedData(String UserCert, String RandomString,
			String UserSignedData) throws SVSConnectException,
			ParameterTooLongException, ParameterInvalidException,
			UnkownException {
		boolean bool = sed.verifySignedData(UserCert, RandomString,
				UserSignedData);
		if (!bool) {
			throw new CaException("验证签名错误");
		}
	}

	/**
	 * @category 获取用户key
	 * @param sed
	 * @param UserCert
	 * @return
	 * @throws ParameterInvalidException
	 * @throws ParameterOutRangeException
	 * @throws ParameterTooLongException
	 * @throws SVSConnectException
	 */
	private static String getCaKey(String UserCert) throws SVSConnectException,
			ParameterTooLongException, ParameterOutRangeException,
			ParameterInvalidException {
		String caKey = sed.getCertInfoByOid(UserCert, "1.2.86.11.7.1.8");

		if (StringUtils.isBlank(caKey)) {
			caKey = sed.getCertInfoByOid(UserCert, "2.16.840.1.113732.2");
		}

		return caKey;
	}

}
