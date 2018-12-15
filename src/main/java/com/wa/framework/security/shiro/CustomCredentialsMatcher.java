package com.wa.framework.security.shiro;

import com.wa.framework.util.SecurityUtil;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authc.credential.SimpleCredentialsMatcher;

/**
 * 描述：自定义 密码验证类 
 * 创建人：guoyt
 * 创建时间：2016年10月12日下午1:47:11
 * 修改人：guoyt
 * 修改时间：2016年10月12日下午1:47:11
 */
public class CustomCredentialsMatcher extends SimpleCredentialsMatcher {
    
    private String md5Code;
    
    /** 
     * @Description: 验证密码是否正确
     * @see： @see org.apache.shiro.authc.credential.SimpleCredentialsMatcher#doCredentialsMatch(org.apache.shiro.authc.AuthenticationToken, org.apache.shiro.authc.AuthenticationInfo)
     * @since JDK 1.6
     */
    @Override
    public boolean doCredentialsMatch(AuthenticationToken authcToken, AuthenticationInfo info) {
        UsernamePasswordToken token = (UsernamePasswordToken) authcToken;

        // 登录用户输入的密码使用加密算法计算
        Object tokenCredentials = token.getPassword();
        
        // 数据库中保存的密文密码
        Object accountCredentials = getCredentials(info);

        // 将密码加密与系统中的密码校验，内容一致就返回true,不一致就返回false
        return equals(tokenCredentials, accountCredentials);
    }

    /**
     * @Description: 将传进来密码加密方法
     * @param: @param token
     * @param: @return
     * @return: String
     * @throws
     * @since JDK 1.6
     */
    @SuppressWarnings("unused")
	private String encrypt(UsernamePasswordToken token) {
        String md5 = SecurityUtil.MD5String(String.valueOf(token.getPassword()) + md5Code + token.getUsername());
        return md5;
    }
    
    public String getMd5Code() {
        return md5Code;
    }

    public void setMd5Code(String md5Code) {
        this.md5Code = md5Code;
    }
    
}
