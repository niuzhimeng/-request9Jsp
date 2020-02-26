<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="com.alibaba.fastjson.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    // 完美门店流程，带出省份、区县、城市
    // 开业准备流程表名
    String tableName = "formtable_main_18";
    BaseBean baseBean = new BaseBean();
    RecordSet recordSet = new RecordSet();
    RecordSet recordSet1 = new RecordSet();
    try {
        String mdbh = request.getParameter("myJson");
        // 查询后台编号信息
        recordSet.executeQuery("select * from " + tableName + " where mdbh = '" + mdbh + "'");
        recordSet.next();
        String sf = recordSet.getString("sf1");
        String cs = recordSet.getString("cs");
        String qx = recordSet.getString("qx");

        recordSet1.executeQuery("select provincename from hrmprovince where id = '" + sf + "'");
        recordSet1.next();
        String sfVal = recordSet1.getString("provincename");

        recordSet1.executeQuery("select cityname from hrmcity  where id = '" + cs + "'");
        recordSet1.next();
        String csVal = recordSet1.getString("cityname");

        recordSet1.executeQuery("select cityname from hrmcitytwo where id = '" + qx + "'");
        recordSet1.next();
        String qxVal = recordSet1.getString("cityname");

        Map<String, String> returnMap = new HashMap<>();
        returnMap.put("sf", sf);
        returnMap.put("sfVal", sfVal);

        returnMap.put("cs", cs);
        returnMap.put("csVal", csVal);

        returnMap.put("qx", qx);
        returnMap.put("qxVal", qxVal);
        out.clear();

        String toJSONString = JSONObject.toJSONString(returnMap);
        baseBean.writeLog("返回map： " + toJSONString);
        out.print(toJSONString);
    } catch (Exception e) {
        baseBean.writeLog("完美门店流程，带出字段异常： " + e);
    }


%>












