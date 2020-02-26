<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow" %>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell" %>
<%@ page import="java.io.BufferedOutputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.OutputStream" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    XSSFWorkbook xssfWorkbook = new XSSFWorkbook();
    XSSFSheet xssfSheet = xssfWorkbook.createSheet("1");
    for (int i = 0; i < 5; i++) {
        XSSFRow row = xssfSheet.createRow(i);
        for (int j = 0; j < 8; j++) {
            XSSFCell cell = row.createCell(j);
            cell.setCellValue("第：" + i + "行， " + j + " 列");
        }
    }

//    response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode("test.xlsx", "UTF-8"));  //返回头 文件名
//    response.addHeader("Content-Length", "" + 100);  //返回头 文件大小
//    response.setContentType("application/octet-stream");    //设置数据种类

    FileOutputStream fileOutputStream = new FileOutputStream("e:/weaver/ecology/tempExcel/q123.xlsx");
    xssfWorkbook.write(fileOutputStream);
    fileOutputStream.close();

    response.sendRedirect("/tempExcel/q123.xlsx");
%>

