package com.wa.framework.security.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;

/**
 * 虚拟路径过滤器
 *
 * @author Administrator
 */
public class VirtualPathFilter implements Filter {

    private String vp = "$_virtual_path_$";

    public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        if (uri != null && uri.indexOf(vp) >= 0) {
            uri = URLDecoder.decode(uri, "utf-8");
            String name = getName(uri);
            File file = new File(name);
            if (file.exists()) {
                int len = (int) file.length();
                byte[] bytes = new byte[len];
                ServletContext sc = req.getSession().getServletContext();
                String type = sc.getMimeType(name);
                resp.setContentType(type);
                resp.setContentLength(len);
                InputStream is = null;
                OutputStream os = null;
                try {
                    is = new FileInputStream(file);
                    os = resp.getOutputStream();
                    is.read(bytes, 0, len);
                    os.write(bytes);
                    os.flush();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    closeStream(is);
                    closeStream(os);
                }
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            chain.doFilter(request, response);
        }
    }

    // 获取文件名
    private String getName(String uri) {
        uri = uri.replaceAll("/+", "/");
        String name = uri;
        int start = uri.indexOf(vp);
        int end = uri.indexOf("?");
        if (start >= 0) {
            if (end >= 0) {
                name = uri.substring(start + vp.length(), end);
            } else {
                name = uri.substring(start + vp.length());
            }
        }
        return name;
    }

    // 关闭流
    private void closeStream(InputStream is) {
        try {
            if (is != null) {
                is.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void closeStream(OutputStream os) {
        try {
            if (os != null) {
                os.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void destroy() {

    }

}
