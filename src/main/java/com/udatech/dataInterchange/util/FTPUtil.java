package com.udatech.dataInterchange.util;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.net.SocketException;

/**
 * <p>
 * 基于 apache commons-net-1.4.1 lib 封装的FTP工具类
 * </p>
 */
public class FTPUtil {

    private static final Log logger = LogFactory.getLog(FTPUtil.class);

    private static final String ENCODING = "UTF-8";

    /**
     * 操作返回代码: 创建远程目录成功
     */
    private static final int CREATE_DIRECTORY_SUCCESS = 100;
    /**
     * 操作返回代码: 创建远程目录失败
     */
    private static final int CREATE_DIRECTORY_FAILED = 101;
    /**
     * 操作返回代码: 上产新文件成功
     */
    private static final int UPLOAD_NEW_FILE_SUCCESS = 200;
    /**
     * 操作返回代码: 上传新文件失败
     */
    private static final int UPLOAD_NEW_FILE_FAILED = 201;
    /**
     * 操作返回代码: 上传断点文件成功
     */
    private static final int UPLOAD_FROM_BREAK_SUCCESS = 202;
    /**
     * 操作返回代码: 上传断点文件失败
     */
    private static final int UPLOAD_FROM_BREAK_FAILED = 203;
    /**
     * 操作返回代码: 服务器目录中存在和本地目录相同的文件
     */
    private static final int FILE_EXITS = 204;
    /**
     * 操作返回代码: 服务器目录中已经存在的文件大于本地目录政要上传的文件
     */
    private static final int REMOTE_BIGGET_LOCAL = 205;
    /**
     * 操作返回代码: 服务器目录中不存在要下载的文件
     */
    private static final int LOCAL_FILE_NOT_EXIST = 206;
    /**
     * 操作返回代码: 下载新文件成功
     */
    private static final int DOWNLOAD_NEW_FILE_SUCCESS = 300;
    /**
     * 操作返回代码: 下载新文件失败
     */
    private static final int DOWNLOAD_NEW_FILE_FAILED = 301;
    /**
     * 操作返回代码: 服务器目录中不存在要下载的文件
     */
    private static final int REMOTE_FILE_NOT_EXIST = 302;
    /**
     * 操作返回代码: 本地目录政要下载的文件大于服务器目录中已经存在的文件
     */
    private static final int LOCAL_BIGGET_REMOTE = 303;
    /**
     * 操作返回代码: 下载断电文件成功
     */
    private static final int DOWNLOAD_FROM_BREAK_SUCCESS = 304;
    /**
     * 操作返回代码: 下载断电文件失败
     */
    private static final int DOWNLOAD_FROM_BREAK_FAILED = 305;
    /**
     * 操作返回代码: 删除远程目录指定目录文件失败
     */
    private static final int DELETE_REMOTE_SUCCESS = 400;
    /**
     * 操作返回代码: 删除远程目录指定目录文件失败
     */
    private static final int DELETE_REMOTE_FAULED = 401;

    private FTPClient ftpClient;

    public FTPUtil() {
        super();
        ftpClient = new FTPClient();
    }

    /**
     * <p>
     * 使用FTP默认端口号(21),连接登录目的主机
     * </p>
     *
     * @param hostname 主机名称
     * @param username 用户名
     * @param password 密码
     * @return {@code true} 连接登陆成功, {@code false} 连接登陆失败
     * @throws IOException
     * @throws SocketException
     */
    public boolean login(String hostname, String username, String password) throws SocketException, IOException {
        return connect(hostname, 21, username, password);
    }

    /**
     * <p>
     * 使用给定的FTP端口连接登陆到目的主机
     * </p>
     *
     * @param hostname 主机名
     * @param port     端口
     * @param username 用户名
     * @param password 密码
     * @return {@code true} 连接登陆成功, {@code false} 连接登陆失败
     * @throws IOException
     * @throws SocketException
     */
    public boolean login(String hostname, int port, String username, String password) throws SocketException, IOException {
        return connect(hostname, port, username, password);
    }

    /**
     * <p>
     * 连接登陆到FTP服务器
     * </p>
     *
     * @param hostname 主机名
     * @param port     端口
     * @param username 用户名
     * @param password 密码
     * @return {@code true} 连接登陆成功, {@code false} 连接登陆失败
     * @throws IOException
     * @throws SocketException
     */
    private boolean connect(String hostname, int port, String username, String password) throws SocketException, IOException {
        ftpClient.setDefaultTimeout(60000);
        ftpClient.setDataTimeout(60000);
        // 检测连接
        ftpClient.connect(hostname, port);
        ftpClient.setControlEncoding(ENCODING);
        int reply = ftpClient.getReplyCode();
        System.out.println(this.getClass().getName() + " " + "returns the replycode ============= " + reply);
        if (FTPReply.isPositiveCompletion(reply)) {
            // 连接成功,进行登陆
            if (ftpClient.login(username, password)) {
                return true;
            }
        }
        closeCon();
        return false;
    }

    /**
     * <p>
     * 把本地给定文件路径的文件上传到目的主机上指定的文件路径下
     * </p>
     * <p>
     * <p>
     * 这里的上传为覆盖上传,不支持目录文件.文件路径使用"/"进行分隔, 使用"\\"进行分隔,文件上传后的名称可能发生异常造成上传失败.
     * </p>
     * <p>
     * <p>
     * 如果给定的目的主机路径为绝对路径,按照绝对路径进行执行; 如果给定的目的主机路径为相对路径,会按照登录时所在的路径位置为起点进行计算
     * 得到目的路径.本地给定文件路径同理.文件上传后文件名为原文件名不变
     * </p>
     * <p>
     * <p>
     * 当目的目的主机上不存在上传指定路径时,方法会创建该路径,以下是一些使用实例(目标路径存在和不存在情况相同), 若参数remotePath为:
     * shine/test01, 文件被上传至创建的shine/test01目录下 若参数remotePaht为: shine/test01/,
     * 文件被上传至创建的shine/test01目录下 若参数remotePath为: shine, 文件被上传至存在的shine目录下
     * 若参数remotePath为: /, 文件被上传至登陆时所在的当前目录下
     * </p>
     *
     * @param remotePath 目的主机上指定的文件路径
     * @param srcUrl     本地文件路径
     * @return 操作状态返回代码, 上传成功:200 上传失败:201 远程目录创建失败:101 本地文件不存在:207
     */
    public int uploadOverride(String remotePath, String srcUrl) {
        String remoteFileName = getNameByPath(srcUrl);
        if (!remotePath.endsWith("/")) {
            remotePath += "/";
        }
        if (remoteFileName.equals(String.valueOf(FTPUtil.LOCAL_FILE_NOT_EXIST))) {
            return FTPUtil.LOCAL_FILE_NOT_EXIST;
        } else {
            return uploadFile(remotePath, srcUrl, remoteFileName);
        }
    }

    /**
     * <p>
     * 把本地给定文件路径的文件上传到目的主机上指定的文件路径下
     * </p>
     * <p>
     * <p>
     * 这里的上传为覆盖上传,不支持目录文件.文件路径使用"/"进行分隔, 使用"\\"进行分隔,文件上传后的名称可能发生异常造成上传失败.
     * </p>
     * <p>
     * <p>
     * 如果给定的目的主机路径为绝对路径,按照绝对路径进行执行; 如果给定的目的主机路径为相对路径,会按照登录时所在的路径位置为起点进行计算
     * 得到目的路径.本地给定文件路径同理.文件上传后文件名变为给定的文件名
     * </p>
     * <p>
     * <p>
     * 当目的目的主机上不存在上传指定路径时,方法会创建该路径,以下是一些使用实例(目标路径存在和不存在情况相同), 若参数remotePath为:
     * shine/test01, 文件被上传至创建的shine/test01目录下 若参数remotePaht为: shine/test01/,
     * 文件被上传至创建的shine/test01目录下 若参数remotePath为: shine, 文件被上传至存在的shine目录下
     * 若参数remotePath为: /, 文件被上传至登陆时所在的当前目录下
     * </p>
     *
     * @param remotePath 目的主机上指定的文件路径
     * @param srcUrl     本地文件路径
     * @param targetName 上传成功后文件的命名
     * @return 操作状态返回代码, 上传成功:200 上传失败:201 远程目录创建失败:101 本地文件不存在:207
     */
    public int uploadOverride(String remotePath, String srcUrl, String targetName) {
        return uploadFile(remotePath, srcUrl, targetName);
    }

    private String getNameByPath(String filePath) {
        File srcFile = new File(filePath);
        if (srcFile.exists()) {
            return srcFile.getName();
        }
        return String.valueOf(FTPUtil.LOCAL_FILE_NOT_EXIST);
    }

    /**
     * <p>
     * 根据参数配置,使用FTP上传本地指定目录下的文件到目的主机的指定目录
     * </p>
     *
     * @param remotePath  上传文件后在服务器上的文件路径
     * @param srcUrl      要上传的文件在本地的文件路径
     * @param targetFname 上传文件后的文件名称
     * @param startDic    服务器上的起始目录
     * @param booDispatch 是否启用指定特定的起始目录startDic
     * @return true 操作状态返回代码 上传成功:200 上传失败:201 远程目录创建失败:101 本地文件不存在:207
     */
    private int uploadFile(String remotePath, String srcUrl, String targetFname) {
        int status = FTPUtil.UPLOAD_NEW_FILE_FAILED;
        if (ftpClient != null) {
            File srcFile = new File(srcUrl);
            FileInputStream fis = null;
            try {
                fis = new FileInputStream(srcFile);
                if (createDirecroty(remotePath, ftpClient) == FTPUtil.CREATE_DIRECTORY_FAILED) {
                    return FTPUtil.CREATE_DIRECTORY_FAILED;
                }
                // 设置上传目录
                ftpClient.changeWorkingDirectory(remotePath);
                // 设置PassiveMode传输 ,防止在linux下出現阻塞
                ftpClient.enterLocalPassiveMode();
                ftpClient.setBufferSize(1024);
                ftpClient.setControlEncoding(ENCODING);
                // 设置文件类型（二进制）
                ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
                // 上传
                if (ftpClient.storeFile(targetFname, fis)) {
                    status = FTPUtil.UPLOAD_NEW_FILE_SUCCESS;
                }
            } catch (FileNotFoundException e) {
                logger.error(e.getMessage(), e);
                return FTPUtil.LOCAL_FILE_NOT_EXIST;
            } catch (IOException e) {
                logger.error(e.getMessage(), e);
                return FTPUtil.UPLOAD_NEW_FILE_FAILED;
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
            } finally {
                IOUtils.closeQuietly(fis);
            }
        }
        return status;
    }

    /**
     * <p>
     * 使用ftp上传文件,支持断点续传
     * </p>
     * <p>
     * <p>
     * 这里的上传不能为覆盖上传,不支持目录文件.文件路径使用"/"进行分隔, 使用"\\"进行分隔,文件上传后的名称可能发生异常造成上传失败.
     * </p>
     * <p>
     * <p>
     * 目的主机目录结尾不能为"/",否则会发生错误, 例如 upload("D:/Documents/Downloads/tree01。zip",
     * "/shine35/shine95")
     * 将会将本地目录D:/Documents/Downloads下的tree01.zip文件上传到目的主机/shine35/
     * 下并保存文件名为shine95
     * </p>
     *
     * @param localPath  本地文件的绝对路径
     * @param remotePath 目的主机的绝对路径
     * @return 操作状态返回代码
     * @throws IOException
     */
    public int upload(String localPath, String remotePath) throws IOException {
        int status;
        // 设置PassiveMode传输 ,防止在linux下出現阻塞
        ftpClient.enterLocalPassiveMode();
        // 设置以二进制流的方式传输
        ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
        ftpClient.setControlEncoding(ENCODING);
        String remoteFileName = remotePath;
        if (remotePath.contains("/")) {
            remoteFileName = remotePath.substring(remotePath.lastIndexOf("/") + 1);
            // 创建服务器远程目录结构，创建失败直接返回
            if (createDirecroty(remotePath, ftpClient) == FTPUtil.CREATE_DIRECTORY_FAILED) {
                return FTPUtil.CREATE_DIRECTORY_FAILED;
            }
        }
        // 检查远程是否存在文件
        FTPFile[] files = ftpClient.listFiles(new String(remoteFileName.getBytes(ENCODING), "iso-8859-1"));
        if (files.length == 1) {
            long remoteSize = files[0].getSize();
            File f = new File(localPath);
            long localSize = f.length();
            if (remoteSize == localSize) {
                return FTPUtil.FILE_EXITS;
            } else if (remoteSize > localSize) {
                return FTPUtil.REMOTE_BIGGET_LOCAL;
            }
            // 尝试移动文件内读取指针,实现断点续传
            status = uploadFile(remoteFileName, f, ftpClient, remoteSize);
            // 如果断点续传没有成功，则删除服务器上文件，重新上传
            if (status == FTPUtil.UPLOAD_FROM_BREAK_FAILED) {
                if (!ftpClient.deleteFile(remoteFileName)) {
                    return FTPUtil.DELETE_REMOTE_FAULED;
                }
                status = uploadFile(remoteFileName, f, ftpClient, 0);
            }
        } else {
            status = uploadFile(remoteFileName, new File(localPath), ftpClient, 0);
        }
        return status;
    }

    /**
     * <p>
     * 递归创建远程服务器目录
     * </p>
     *
     * @param remote    远程服务器文件绝对路径
     * @param ftpClient FTPClient对象
     * @return 操作结果状态码
     * @throws IOException
     */
    private int createDirecroty(String remote, FTPClient ftpClient) throws IOException {
        String directory = remote.substring(0, remote.lastIndexOf("/") + 1);
        if (!directory.equalsIgnoreCase("/") && !ftpClient.changeWorkingDirectory(new String(directory.getBytes(ENCODING), "iso-8859-1"))) {
            // 如果远程目录不存在，则递归创建远程服务器目录
            int start = 0;
            int end = 0;
            if (directory.startsWith("/")) {
                start = 1;
            } else {
                start = 0;
            }
            end = directory.indexOf("/", start);
            while (true) {
                String subDirectory = new String(remote.substring(start, end).getBytes(ENCODING), "iso-8859-1");
                if (!ftpClient.changeWorkingDirectory(subDirectory)) {
                    if (ftpClient.makeDirectory(subDirectory)) {
                        ftpClient.changeWorkingDirectory(subDirectory);
                    } else {
                        System.out.println("创建目录失败");
                        return FTPUtil.CREATE_DIRECTORY_FAILED;
                    }
                }
                start = end + 1;
                end = directory.indexOf("/", start);
                // 检查所有目录是否创建完毕
                if (end <= start) {
                    break;
                }
            }
        }
        return FTPUtil.CREATE_DIRECTORY_SUCCESS;
    }

    /**
     * <p>
     * 上传文件到服务器,新上传和断点续传
     * </p>
     *
     * @param remoteFile  远程文件名，在上传之前已经将服务器工作目录做了改变
     * @param localFile   本地文件File句柄，绝对路径
     * @param processStep 需要显示的处理进度步进值
     * @param ftpClient   FTPClient引用
     * @return
     * @throws IOException
     */
    private int uploadFile(String remoteFile, File localFile, FTPClient ftpClient, long remoteSize) throws IOException {
        // 显示进度的上传
        long step = localFile.length() / 100;
        long process = 0;
        long localReadBytes = 0L;
        byte[] bytes = new byte[1024];
        int c, status;
        RandomAccessFile raf = new RandomAccessFile(localFile, "r");
        OutputStream out = ftpClient.appendFileStream(new String(remoteFile.getBytes(ENCODING), "iso-8859-1"));
        // 断点续传
        if (remoteSize > 0) {
            ftpClient.setRestartOffset(remoteSize);
            process = remoteSize / step;
            raf.seek(remoteSize);
            localReadBytes = remoteSize;
        }
        while ((c = raf.read(bytes)) != -1) {
            out.write(bytes, 0, c);
            localReadBytes += c;
            if (localReadBytes / step != process) {
                process = localReadBytes / step;
                System.out.println("上传进度:" + process);
                // TODO 汇报上传状态
            }
        }
        out.flush();
        raf.close();
        out.close();
        boolean result = ftpClient.completePendingCommand();
        if (remoteSize > 0) {
            status = result ? FTPUtil.UPLOAD_FROM_BREAK_SUCCESS : FTPUtil.UPLOAD_FROM_BREAK_FAILED;
        } else {
            status = result ? FTPUtil.UPLOAD_NEW_FILE_SUCCESS : FTPUtil.UPLOAD_NEW_FILE_FAILED;
        }
        return status;
    }

    /**
     * <p>
     * 从FTP服务器上下载文件,支持断点续传，上传百分比汇报
     * </p>
     * <p>
     * <p>
     * 目的主机目录结尾不能为"/",否则可能找不到文件, 例如 download("/shine35/shine96",
     * "D:/Documents/Downloads/tree123fd1231.zip/")
     * 将目的主机目录/shine35下的文件shine96下载到本地目录
     * D:/Documents/Downloads下并命名为tree123fd1231.zip, 最后的"/"无论有无都不影响命名结果
     * </p>
     *
     * @param remote 远程绝对文件路径
     * @param local  本地绝对文件路径
     * @return 操作结果状态码
     * @throws IOException
     */
    public int download(String remote, String local) throws IOException {
        // 设置被动模式
        ftpClient.enterLocalPassiveMode();
        // 设置以二进制方式传输
        ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
        int status;

        // 检查远程文件是否存在
        FTPFile[] files = ftpClient.listFiles(new String(remote.getBytes(ENCODING), "iso-8859-1"));
        if (files.length != 1) {
            System.out.println("远程文件不存在");
            return FTPUtil.REMOTE_FILE_NOT_EXIST;
        }

        long lRemoteSize = files[0].getSize();
        File f = new File(local);
        // 本地存在文件，进行断点下载
        if (f.exists()) {
            long localSize = f.length();
            // 判断本地文件大小是否大于远程文件大小
            if (localSize >= lRemoteSize) {
                System.out.println("本地文件大于远程文件，下载中止");
                return FTPUtil.LOCAL_BIGGET_REMOTE;
            }

            // 进行断点续传，并记录状态
            FileOutputStream out = new FileOutputStream(f, true);
            ftpClient.setRestartOffset(localSize);
            InputStream in = ftpClient.retrieveFileStream(new String(remote.getBytes(ENCODING), "iso-8859-1"));
            byte[] bytes = new byte[1024];
            long step = lRemoteSize / 100;
            long process = localSize / step;
            int c;
            while ((c = in.read(bytes)) != -1) {
                out.write(bytes, 0, c);
                localSize += c;
                long nowProcess = localSize / step;
                if (nowProcess > process) {
                    process = nowProcess;
                    if (process % 10 == 0)
                        System.out.println("下载进度：" + process);
                    // TODO 更新文件下载进度,值存放在process变量中
                }
            }
            in.close();
            out.close();
            boolean isDo = ftpClient.completePendingCommand();
            if (isDo) {
                status = FTPUtil.DOWNLOAD_FROM_BREAK_SUCCESS;
            } else {
                status = FTPUtil.DOWNLOAD_FROM_BREAK_FAILED;
            }
        } else {
            OutputStream out = new FileOutputStream(f);
            InputStream in = ftpClient.retrieveFileStream(new String(remote.getBytes(ENCODING), "iso-8859-1"));
            byte[] bytes = new byte[1024];
            long step = lRemoteSize / 100;
            long process = 0;
            long localSize = 0L;
            int c;
            while ((c = in.read(bytes)) != -1) {
                out.write(bytes, 0, c);
                localSize += c;
                long nowProcess = localSize / step;
                if (nowProcess > process) {
                    process = nowProcess;
                    if (process % 10 == 0)
                        System.out.println("下载进度：" + process);
                    // TODO 更新文件下载进度,值存放在process变量中
                }
            }
            in.close();
            out.close();
            boolean upNewStatus = ftpClient.completePendingCommand();
            if (upNewStatus) {
                status = FTPUtil.DOWNLOAD_NEW_FILE_SUCCESS;
            } else {
                status = FTPUtil.DOWNLOAD_NEW_FILE_FAILED;
            }
        }
        return status;
    }

    /**
     * <p>
     * 删除目录文件及这个目录文件下的所有子文件和文件夹
     * </p>
     * <p>
     * <p>
     * 文件路径之间使用"/"作为分隔符, removeDirsAll("/shine45")和removeDirsAll("/shine45/")
     * 的效果相同,都会删除整个shine45目录
     * </p>
     *
     * @param filePath 要删除的目录文件路径
     * @return 操作结果状态码
     */
    public int removeDirsAll(String filePath) {
        if (!filePath.endsWith("/")) {
            filePath += "/";
        }
        try {
            removeAllFiles(filePath);
            removeAllDirs(filePath);
            ftpClient.removeDirectory(filePath);
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
            return FTPUtil.DELETE_REMOTE_FAULED;
        }
        return FTPUtil.DELETE_REMOTE_SUCCESS;
    }

    /**
     * <p>
     * 清空目录文件下的所有子文件和文件夹(不包括这个目录)
     * </p>
     * <p>
     * <p>
     * 文件路径之间使用"/"作为分隔符, ClearDirsAll("/shine45")和ClearDirsAll("/shine45/")
     * 的效果相同,都会清空shine45目录
     * </p>
     *
     * @param filePath 要清空的目录文件路径
     * @return 操作结果状态码
     */
    public int clearDirsAll(String filePath) {
        if (!filePath.endsWith("/")) {
            filePath += "/";
        }
        try {
            removeAllFiles(filePath);
            removeAllDirs(filePath);
        } catch (IOException e) {
            logger.error(e.getMessage(), e);
            return FTPUtil.DELETE_REMOTE_FAULED;
        }
        return FTPUtil.DELETE_REMOTE_SUCCESS;
    }

    private void removeAllFiles(String filePath) throws IOException {
        FTPFile[] files = ftpClient.listFiles(filePath);
        for (FTPFile element : files) {
            if (element.isFile()) {
                ftpClient.deleteFile(filePath + element.getName());
            } else {
                removeAllFiles(filePath + element.getName() + "/");
            }
        }
    }

    private void removeAllDirs(String filePath) throws IOException {
        FTPFile[] files = ftpClient.listFiles(filePath);
        if (files.length == 0) {
            ftpClient.removeDirectory(filePath);
        } else {
            for (FTPFile element : files) {
                removeAllDirs(filePath + element.getName() + "/");
            }
        }
    }

    /**
     * <p>
     * 删除目的主机指定路径下的文件
     * </p>
     * <p>
     * <p>
     * 例如, 方法removeFile("/shine35/shine96"),将删除目的主机/shine35目录下的文件shine96
     * </p>
     *
     * @param filePath 目的主机上要进行删除的文件的文件路径
     * @return 操作结果状态码
     */
    public int removeFile(String filePath) {
        int status = FTPUtil.DELETE_REMOTE_FAULED;
        if (ftpClient != null) {
            try {
                if (ftpClient.deleteFile(filePath)) {
                    status = FTPUtil.DELETE_REMOTE_SUCCESS;
                }
            } catch (IOException e) {
                logger.error(e.getMessage(), e);
            }
        }
        return status;
    }

    /**
     * <p>
     * 删除目的主机指定路径下的空文件夹
     * </p>
     * <p>
     * <p>
     * 例如, 方法removeFile("/shine35/shine96"),将删除目的主机/shine35目录下的空文件夹shine96
     * </p>
     *
     * @param filePath 目的主机上要进行删除的文件的文件路径
     * @return 操作结果状态码
     */
    public int removeEmptyDir(String filePath) {
        int status = FTPUtil.DELETE_REMOTE_FAULED;
        if (ftpClient != null) {
            try {
                if (ftpClient.removeDirectory(filePath)) {
                    status = FTPUtil.DELETE_REMOTE_SUCCESS;
                }
            } catch (IOException e) {
                logger.error(e.getMessage(), e);
            }
        }
        return status;
    }

    /**
     * <p>
     * 登出关闭与目的主机的FTP连接
     * </p>
     */
    public void closeCon() {
        if (ftpClient != null) {
            try {
                ftpClient.logout();
            } catch (IOException e) {
                logger.error(e.getMessage(), e);
            } finally {
                if (ftpClient.isConnected()) {
                    try {
                        ftpClient.disconnect();
                        ftpClient = null;
                    } catch (IOException e) {
                        logger.error(e.getMessage(), e);
                    }
                }
            }
        }
    }

    public FTPClient getFtpClient() {
        return ftpClient;
    }

    public void setFtpClient(FTPClient ftpClient) {
        this.ftpClient = ftpClient;
    }

    public static void main(String[] args) throws SocketException, IOException {
        FTPUtil instance = new FTPUtil();
        instance.login("192.168.20.25", 21, "admin", "111111");
//        instance.uploadOverride("/data/", "F:/test.xml");
        instance.uploadOverride("/data/", "F:/spring注解详细介绍.doc");
        instance.closeCon();
    }
}
