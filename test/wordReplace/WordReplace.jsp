<%@ page import="cn.hutool.core.io.FileUtil" %>
<%@ page import="cn.hutool.core.io.IoUtil" %>
<%@ page import="cn.hutool.core.util.ZipUtil" %>
<%@ page import="com.weavernorth.ningbowuxin.wordoperate.DocCreateService" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    /**
     * 子目录id
     */
    final String MU_LU_ID = "122";
    BaseBean baseBean = new BaseBean();

    BufferedInputStream inputStream1 = null;
    BufferedOutputStream outputStream1 = null;
    BufferedReader bufferedReader = null;
    BufferedWriter bufferedWriter = null;
    BufferedInputStream inputStream2 = null;
    BufferedOutputStream outputStream2 = null;

    try {
        baseBean.writeLog("word标记替换开始 ；========");
        // 将模板复制一份 zip格式
        inputStream1 = FileUtil.getInputStream("e:/weaver/ecology/wordTemplate/2.docx");

        File file = new File("e:/weaver/ecology/temp/2.zip");

        outputStream1 = FileUtil.getOutputStream(file);
        long copySize = IoUtil.copy(inputStream1, outputStream1, IoUtil.DEFAULT_BUFFER_SIZE);
        baseBean.writeLog("另存一份zip文件完成，copySize: " + copySize);

        // 解压该zip文件 读取document.xml文件
        File unzip = ZipUtil.unzip(file);
        baseBean.writeLog("解压完成： " + unzip);

        String unPathStr = unzip.toString() + File.separatorChar + "word" + File.separatorChar + "document.xml";
        baseBean.writeLog("xml路径： " + unPathStr);

        bufferedReader = FileUtil.getReader(unPathStr, "utf-8");

        String xmlStr = IoUtil.read(bufferedReader);
        baseBean.writeLog("读取到的xml： " + xmlStr);
        baseBean.writeLog("xml长度： " + xmlStr.length());

        // 替换xml
        xmlStr = xmlStr.replace("{name}", "牛智萌1")
                .replace("{address}", "齐齐哈尔市1")
                .replace("{email}", "295290968@qq.com")
                .replace("{phone}", "15777777777");

        // 输出新的xml false 表示不追加
        bufferedWriter = FileUtil.getWriter(unPathStr, "utf-8", false);
        bufferedWriter.write(xmlStr);

        // 重新压缩
        File zip = ZipUtil.zip(unzip);
        String inPath = zip.toString();
        baseBean.writeLog("重新压缩后的路径： " + inPath);

        // 复制一份为 .docx的文件
        String outPath = inPath.substring(0, inPath.lastIndexOf(".")) + ".docx";
        inputStream2 = FileUtil.getInputStream(inPath);
        outputStream2 = FileUtil.getOutputStream(outPath);
        IoUtil.copy(inputStream2, outputStream2, IoUtil.DEFAULT_BUFFER_SIZE);

        baseBean.writeLog("模板填充完成： " + outPath);
        // 上传附件
        DocCreateService service = new DocCreateService("sysadmin", "1");
        String strDocId = service.init("生成的附件" + ".docx", outPath, MU_LU_ID, "");

        // 更新流程表单
        RecordSet recordSet = new RecordSet();
        recordSet.executeUpdate("update formtable_main_16 set ht1 = '" + strDocId + "' where requestid = " + 65);

    } catch (Exception e) {
        baseBean.writeLog("word标记替换异常： " + e);
    } finally {
        myClose(inputStream1, outputStream1, bufferedReader, bufferedWriter, inputStream2, outputStream2);
    }
%>

<%!

    private void myClose(Closeable... closeableList) {
        for (Closeable closeable : closeableList) {
            try {
                if (closeable != null) {
                    closeable.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

%>



